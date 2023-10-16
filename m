Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16F97CA1AE
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 10:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjJPIdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 04:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjJPIdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 04:33:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD3DA1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 01:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697445196; x=1728981196;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=agsCH6CLFzy7WE5OXx+c69Oob0sNJ20hmEq/QR+OWM8=;
  b=lTA0TRQuuiSU/3dnelcFPkl/DbaKtnktvYV0qsnHFs1O2RSkxyYEwz5W
   SZ4/tsqQLTLijvbA/ZCujkcOWVp8ioZabVFNKVL1822bYw8Vxqay3hYjH
   YEiCOzxLvIOKQUZp5OH36xzDBMU46k77RJ/02pz/gDb9v1VD7kM1nAVmU
   C77jRAfy8zlqX5XwkBGkiMiPIkAtu2cqJjyrvs6AZ8AlZvZ7i7IrI07CS
   qfRnrKCh9mui3KHtJi4CoUuoThtVGwR5qUh1sjuPKC6m6JU22VwHfxs1U
   IJF9N+TnGEHAPMpZpO0vAVQxNBoqD1KUXO8vSycs/BTlFNEbkEwqsRE8c
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="416545390"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="416545390"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 01:33:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="872004377"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="872004377"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.35.20]) ([10.93.35.20])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 01:33:13 -0700
Message-ID: <818c4212-9d9a-4775-80f3-c07e82057be8@intel.com>
Date:   Mon, 16 Oct 2023 16:33:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com> <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
 <20231012132749.GK3952@nvidia.com>
 <840d4c6f-4150-4818-a66c-1dbe1474b4c6@intel.com>
 <20231013094959-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20231013094959-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/13/2023 9:50 PM, Michael S. Tsirkin wrote:
> On Fri, Oct 13, 2023 at 06:28:34PM +0800, Zhu, Lingshan wrote:
>>
>> On 10/12/2023 9:27 PM, Jason Gunthorpe wrote:
>>
>>      On Thu, Oct 12, 2023 at 06:29:47PM +0800, Zhu, Lingshan wrote:
>>
>>
>>          sorry for the late reply, we have discussed this for weeks in virtio mailing
>>          list. I have proposed a live migration solution which is a config space solution.
>>
>>      I'm sorry that can't be a serious proposal - config space can't do
>>      DMA, it is not suitable.
>>
>> config space only controls the live migration process and config the related
>> facilities.
>> We don't use config space to transfer data.
>>
>> The new added registers work like queue_enable or features.
>>
>> For example, we use DMA to report dirty pages and MMIO to fetch the dirty data.
>>
>> I remember in another thread you said:"you can't use DMA for any migration
>> flows"
>>
>> And I agree to that statement, so we use config space registers to control the
>> flow.
>>
>> Thanks,
>> Zhu Lingshan
>>
>>
>>      Jason
>>
> If you are using dma then I don't see what's wrong with admin vq.
> dma is all it does.
dma != admin vq,

and I think we have discussed many details in pros and cons
in admin vq live migration proposal in virtio-comment.
I am not sure we should span the discussions here, repeat them over again.

Thanks
>

