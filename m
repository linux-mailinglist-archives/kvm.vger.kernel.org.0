Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC17AE3AE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbjIZCfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjIZCfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:35:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49299103
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695695704; x=1727231704;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RQkJIbou+c0hSTlcipeunSEpz6AISxc5qlOk5hk+jP4=;
  b=KYTtPh8p0iBN0kT6L+79vhba/IIajuO7Vu28Y/SLgvk9zI9fWIRcSjI3
   D5DzfusTtYbMSyFyDOkZrFue01ZXtDtVSUR6tMqT2zoI1obKIJ8gixZVc
   fqzRFW+A1wALSqr5qCSqxxGxPhms9g22I81IV1ToCgxGrPxE1sPvCIJJa
   dBxi/26GlBxb6/+XhrhCqHckjCiNccuWK/0Y8rjgLkmoLwKKTE0j1ennM
   9txc4NzDl/yiNvQG3u/nENyZ7vuW6BkHFJyBhjJ7S0lHSYIm651cpEFn8
   q7/6afA+o9YnGVA1/ncEyYGgtlQXhMP4YiqWetDl/iY+KaIX2EkJPp4ZG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="385314246"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="385314246"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 19:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995638790"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="995638790"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.21.134]) ([10.93.21.134])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 19:35:01 -0700
Message-ID: <ce58ea54-5fdb-00c5-0cbe-e1d93fd881f4@intel.com>
Date:   Tue, 26 Sep 2023 10:34:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20230925141713-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/26/2023 2:36 AM, Michael S. Tsirkin wrote:
> On Mon, Sep 25, 2023 at 08:26:33AM +0000, Parav Pandit wrote:
>>
>>> From: Jason Wang <jasowang@redhat.com>
>>> Sent: Monday, September 25, 2023 8:00 AM
>>>
>>> On Fri, Sep 22, 2023 at 8:25 PM Parav Pandit <parav@nvidia.com> wrote:
>>>>
>>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Sent: Friday, September 22, 2023 5:53 PM
>>>>
>>>>>> And what's more, using MMIO BAR0 then it can work for legacy.
>>>>> Oh? How? Our team didn't think so.
>>>> It does not. It was already discussed.
>>>> The device reset in legacy is not synchronous.
>>> How do you know this?
>>>
>> Not sure the motivation of same discussion done in the OASIS with you and others in past.
>>
>> Anyways, please find the answer below.
>>
>> About reset,
>> The legacy device specification has not enforced below cited 1.0 driver requirement of 1.0.
>>
>> "The driver SHOULD consider a driver-initiated reset complete when it reads device status as 0."
>>   
>> [1] https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf
> Basically, I think any drivers that did not read status (linux pre 2011)
> before freeing memory under DMA have a reset path that is racy wrt DMA, since
> memory writes are posted and IO writes while not posted have completion
> that does not order posted transactions, e.g. from pci express spec:
>          D2b
>          An I/O or Configuration Write Completion 37 is permitted to pass a Posted Request.
> having said that there were a ton of driver races discovered on this
> path in the years since, I suspect if one cares about this then
> just avoiding stress on reset is wise.
>
>
>
>>>> The drivers do not wait for reset to complete; it was written for the sw
>>> backend.
>>>
>>> Do you see there's a flush after reset in the legacy driver?
>>>
>> Yes. it only flushes the write by reading it. The driver does not get _wait_ for the reset to complete within the device like above.
> One can thinkably do that wait in hardware, though. Just defer completion until
> read is done.
I agree with MST. At least Intel devices work fine with vfio-pci and 
legacy driver without any changes.
So far so good.

Thanks
Zhu Lingshan
>
>> Please see the reset flow of 1.x device as below.
>> In fact the comment of the 1.x device also needs to be updated to indicate that driver need to wait for the device to finish the reset.
>> I will send separate patch for improving this comment of vp_reset() to match the spec.
>>
>> static void vp_reset(struct virtio_device *vdev)
>> {
>>          struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>          struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>
>>          /* 0 status means a reset. */
>>          vp_modern_set_status(mdev, 0);
>>          /* After writing 0 to device_status, the driver MUST wait for a read of
>>           * device_status to return 0 before reinitializing the device.
>>           * This will flush out the status write, and flush in device writes,
>>           * including MSI-X interrupts, if any.
>>           */
>>          while (vp_modern_get_status(mdev))
>>                  msleep(1);
>>          /* Flush pending VQ/configuration callbacks. */
>>          vp_synchronize_vectors(vdev);
>> }
>>
>>
>>> static void vp_reset(struct virtio_device *vdev) {
>>>          struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>          /* 0 status means a reset. */
>>>          vp_legacy_set_status(&vp_dev->ldev, 0);
>>>          /* Flush out the status write, and flush in device writes,
>>>           * including MSi-X interrupts, if any. */
>>>          vp_legacy_get_status(&vp_dev->ldev);
>>>          /* Flush pending VQ/configuration callbacks. */
>>>          vp_synchronize_vectors(vdev);
>>> }
>>>
>>> Thanks
>>>
>>>
>>>
>>>> Hence MMIO BAR0 is not the best option in real implementations.
>>>>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

