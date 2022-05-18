Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B4C52B35C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 09:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiERHWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 03:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiERHWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 03:22:44 -0400
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E586C3467A
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 00:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1652858554;
        bh=E2bfNbAZPsPeJpae1xBvIxUbRxVgnCUpNs+arIz/lmw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=pgU4nsithjhlTjRshDEn2gouX4M9pA0DvnAv0LIWAEA3UX9E8O/vysj2Bi4WlKoW3
         dXFu4qFfCNmqUtqeX1K6A4baQ/+h3snqrKm58c2RuYv53gXeULeL/DkSSGDlpXpxWk
         oU66WHfolgrPgpqyLCnhdyVKfsdNIcGyD5PU6Uj4=
Received: from [IPv6:240e:362:473:8f00:d54e:7436:a5f7:1d1b] ([240e:362:473:8f00:d54e:7436:a5f7:1d1b])
        by newxmesmtplogicsvrszc10.qq.com (NewEsmtp) with SMTP
        id 59C14C43; Wed, 18 May 2022 15:22:28 +0800
X-QQ-mid: xmsmtpt1652858548t2dd6b794
Message-ID: <tencent_C3C342C7F0605284FB368A1A63534B5A4806@qq.com>
X-QQ-XMAILINFO: M1OHdYEWKc2ZdF7zCuC0uBDNPrKvC6yaU9jUJ43ncuRdwXAu+w/jI/oYCebiED
         /GD+OebH8rXM/IZSTQQKK1NyXfMkkvbD39R5X86ip2KyOTQmoG2M9l1Kajb/jPFH9+r0mz4Yb6O2
         Ki/t6DBGJogJ8BYdkpfRnRcwFKx+marCOMHNmmj52p9GYZdDtcdU3xQBEAnCnFLeQpDViLq2b5lB
         BlQ7ufFKKhMB0oZD4gzoR+rrupUiHUY46fN3gtQITpRN54vJ94sBTApfEB58s8YSrzbCSxycluE0
         Oj+EzliHyAEi5as+pobe6jVM5ay9yazVVlLgeAjcGBrhwhDafI3Zy9K/qdPDG59XwRciAn085WHt
         Ndya9ckU9sJhEavdk+Oq2d+Y9q2x6xKSOropnAmM6Bv4R0xRUdrJev+HP2Z13AwPCYwq4y4JI4Cs
         Ot0i6XhgIIoM21Nef+K1A+wdCMXQy/3DErzmHsGh3/61Nk84RvhjtUZM/PgOgCYpnuuOAkw6zkd1
         is64clTxwogOzLys7VV0DtI+iBXQox87QYBcW+jMZ0hxaucl0zfAKZYoMwGCGurKp02ZGh6XruEb
         3sQipNVVH3tbKzNB09N2nYvQ/WKiHYfKYFh/k+U3qbKiS9yTS7C28PdWH3MmDTM1e2Pn+8Jfr+Iv
         P72bH6xWzBblIZqka1M0301tkJ3Rp8epTUH8W+ZvAulP6QoyLjjSzYVL+BsQ8B8bUMWNk0XcH3DH
         23AkHqdeueuWRPKyc48UJHK2IaO1d7d0zAC03LVU+Yw17f3LhC0LZQy6+29pSMb9/5aT/p12pg3X
         9JKHQix+HgjJC8+e35xQUoUtfFmFmmXXJXnvp5GJZDxC/8ENnAFjCOCHRwB6Xcx+LtYOafbORsu7
         xSjLEOuzMb10Xcj/kX5Ko4JAeF8U1DIHyy5wXOCxkkRGML8kbMwzryEDnif0kP4rQyVtE+FKxcuq
         5H2thHDpxEVEdTzn4rXdwVL6xLyePL/CBA2Xt4Q8a20TCDc7IQ7Q==
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
To:     Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     eric.auger@redhat.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
 <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
 <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
 <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
 <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
From:   "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
X-OQ-MSGID: <db2f2541-c085-f026-e079-fef69d3c559a@foxmail.com>
Date:   Wed, 18 May 2022 15:22:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/5/17 下午4:55, Yi Liu wrote:
> Hi Zhangfei,
>
> On 2022/5/12 17:01, zhangfei.gao@foxmail.com wrote:
>>
>> Hi, Yi
>>
>> On 2022/5/11 下午10:17, zhangfei.gao@foxmail.com wrote:
>>>
>>>
>>> On 2022/5/10 下午10:08, Yi Liu wrote:
>>>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>>>> Thanks Yi and Eric,
>>>>>> Then will wait for the updated iommufd kernel for the PCI MMIO 
>>>>>> region.
>>>>>>
>>>>>> Another question,
>>>>>> How to get the iommu_domain in the ioctl.
>>>>>
>>>>> The ID of the iommu_domain (called the hwpt) it should be returned by
>>>>> the vfio attach ioctl.
>>>>
>>>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>>>> qemu. You can query page table related capabilities with this id.
>>>>
>>>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/ 
>>>>
>>>>
>>> Thanks Yi,
>>>
>>> Do we use iommufd_hw_pagetable_from_id in kernel?
>>>
>>> The qemu send hwpt_id via ioctl.
>>> Currently VFIOIOMMUFDContainer has hwpt_list,
>>> Which member is good to save hwpt_id, IOMMUTLBEntry?
>>
>> Can VFIOIOMMUFDContainer  have multi hwpt?
>
> yes, it is possible
Then how to get hwpt_id in map/unmap_notify(IOMMUNotifier *n, 
IOMMUTLBEntry *iotlb)

>
>> Since VFIOIOMMUFDContainer has hwpt_list now.
>> If so, how to get specific hwpt from map/unmap_notify in 
>> hw/vfio/as.c, where no vbasedev can be used for compare.
>>
>> I am testing with a workaround, adding VFIOIOASHwpt *hwpt in 
>> VFIOIOMMUFDContainer.
>> And save hwpt when vfio_device_attach_container.
>>
>>>
>>> In kernel ioctl: iommufd_vfio_ioctl
>>> @dev: Device to get an iommu_domain for
>>> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id, 
>>> struct device *dev)
>>> But iommufd_vfio_ioctl seems no para dev?
>>
>> We can set dev=Null since IOMMUFD_OBJ_HW_PAGETABLE does not need dev.
>> iommufd_hw_pagetable_from_id(ictx, hwpt_id, NULL)
>
> this is not good. dev is passed in to this function to allocate domain
> and also check sw_msi things. If you pass in a NULL, it may even unable
> to get a domain for the hwpt. It won't work I guess.

The iommufd_hw_pagetable_from_id can be used for
1, allocate domain, which need para dev
case IOMMUFD_OBJ_IOAS
hwpt = iommufd_hw_pagetable_auto_get(ictx, ioas, dev);

2. Just return allocated domain via hwpt_id, which does not need dev.
case IOMMUFD_OBJ_HW_PAGETABLE:
return container_of(obj, struct iommufd_hw_pagetable, obj);

By the way, any plan of the nested mode?

Thanks
