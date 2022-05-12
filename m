Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC95249F2
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 12:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350261AbiELKF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 06:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiELKFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 06:05:24 -0400
X-Greylist: delayed 3828 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 03:05:22 PDT
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E9F65419
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 03:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1652349920;
        bh=aZyF8TANXAB1NGHnghRiJhYgqgN/MogIvJnw4We4tis=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=wtFesM9qHjhU9U2bZDLhUcgfVxzDVD9JftkKzbcjFCR/yuIvdxAlQz5nEDYCKkXTQ
         vJKNe4BNSQwCjS/73lyIWvXd0K0jPn27DBpEYPpPDkAUUux4EWLcPtiJxCqWOnUSji
         6e/SmsoXU6jnj6GV9vDhTfb7pbt62zf6acSKaQv0=
Received: from [IPv6:240e:362:4ce:f900:dde6:a887:fd41:fc0a] ([240e:362:4ce:f900:dde6:a887:fd41:fc0a])
        by newxmesmtplogicsvrsza5.qq.com (NewEsmtp) with SMTP
        id 5A86409; Thu, 12 May 2022 17:01:26 +0800
X-QQ-mid: xmsmtpt1652346086t5arb40ue
Message-ID: <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
X-QQ-XMAILINFO: MoXwTY6T4qpUo053K0I1cAIxxh6Bhk+2nVZbUwpKgvBarKgHK/Rd8GNqKn1Fvi
         ulggZiHYdpOz3t+IHdvzPstOcA82vi1lAZ2UzbNgnYHJ/952DLpcQVZJSDgH3fhha1dMrI+PO2zG
         ZSzDRclPdXRyLp3BSbMg1Eurl7hDorso1e4uSoDSo+OD8uortrAcP90k0ofrGpvYoszxnyy5ZYiU
         GhpRSEzn8a+HPOUz7GSrm/kkpBsmWvlOxCmg5MInuCW7DQtG7XYQg9aRb0DSxll+lOZhnZSGczbm
         yUGky2V2gK+JoEpfBAkFDW8CN3WuiGtVv69AGidbHRf3amRRNACu7zSTHXRam4M5U+hBOO7jkvcm
         mhwmcu0YIbYuGOWJCA29BXcanNabQoYVr3kRC2BNIQIJoHjDMRrJqFExUQn1qTwi6LuiiaKxeHIn
         Ugu0tbfdghoQ02F7ZDMBsc4SoWpvcyYUg9TEvX+vwiLgt+xxabIKTwLB5D/YhN/1AOUpkO18HnzV
         Ec/CCBZBxdDDTIP27YM5QO+NU6QhEjgXl0dh4f5L6gwMBp2r6EgdMprMAiZngwTm0kbn5VpjywPC
         CiV3/mAM2yJnzDtF3qh4XlYgeGdCr5xzqVsICZkqu0lOy+Pu7ETCrpSEQLTTT4A7y+TrNrvCIOXr
         vsGWu+eKHjF1106uScvV0n7dSjPTt5uPPNW4WnvuDDznR711CI1lJVU8YR0l0vcAHbr8V1REMoXv
         Rq6bdGKYwDGtmQ1DRotNKtj/deG57ucl/N3XPwGxSA0mvXBdJljcHRsOKd54g4vmsCRI/p9ZgRT4
         p3SsMN/cWMTDOVQ4VVHNI0n3dflZK1mMpy551aDp7E4gJJ3nsAFNudqUjszvT8KUmEqbTzjNMqFN
         U2yhjEyl7ccYsD7nXlSMefq9/4Ks/xiODBTihVfHYZ5pLMN63Ibvl3LCibDJnMNJ39gMbKj+G+lp
         VrDX7HiycJKZ7RLeva6q4AipSLVWOjGee2K7YRcQk=
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
From:   "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>
X-OQ-MSGID: <eb4f1b4c-4c25-64d2-e3d5-823531723009@foxmail.com>
Date:   Thu, 12 May 2022 17:01:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi, Yi

On 2022/5/11 下午10:17, zhangfei.gao@foxmail.com wrote:
>
>
> On 2022/5/10 下午10:08, Yi Liu wrote:
>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>> Thanks Yi and Eric,
>>>> Then will wait for the updated iommufd kernel for the PCI MMIO region.
>>>>
>>>> Another question,
>>>> How to get the iommu_domain in the ioctl.
>>>
>>> The ID of the iommu_domain (called the hwpt) it should be returned by
>>> the vfio attach ioctl.
>>
>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>> qemu. You can query page table related capabilities with this id.
>>
>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/
>>
> Thanks Yi,
>
> Do we use iommufd_hw_pagetable_from_id in kernel?
>
> The qemu send hwpt_id via ioctl.
> Currently VFIOIOMMUFDContainer has hwpt_list,
> Which member is good to save hwpt_id, IOMMUTLBEntry?

Can VFIOIOMMUFDContainer  have multi hwpt?
Since VFIOIOMMUFDContainer has hwpt_list now.
If so, how to get specific hwpt from map/unmap_notify in hw/vfio/as.c, 
where no vbasedev can be used for compare.

I am testing with a workaround, adding VFIOIOASHwpt *hwpt in 
VFIOIOMMUFDContainer.
And save hwpt when vfio_device_attach_container.


>
> In kernel ioctl: iommufd_vfio_ioctl
> @dev: Device to get an iommu_domain for
> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id, 
> struct device *dev)
> But iommufd_vfio_ioctl seems no para dev?

We can set dev=Null since IOMMUFD_OBJ_HW_PAGETABLE does not need dev.
iommufd_hw_pagetable_from_id(ictx, hwpt_id, NULL)

Thanks
>

