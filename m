Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8665C551585
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 12:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbiFTKLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 06:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiFTKLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 06:11:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4210F958E;
        Mon, 20 Jun 2022 03:11:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C40DE113E;
        Mon, 20 Jun 2022 03:11:10 -0700 (PDT)
Received: from [10.57.84.159] (unknown [10.57.84.159])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 162D83F7D7;
        Mon, 20 Jun 2022 03:11:05 -0700 (PDT)
Message-ID: <55e352d5-3fea-7e46-0530-b41d323b6fcf@arm.com>
Date:   Mon, 20 Jun 2022 11:11:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Content-Language: en-GB
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-6-nicolinc@nvidia.com>
 <BL1PR11MB52710E360B50DDA99C9A65D18CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YquxcH2S1fM+llOf@Asurada-Nvidia>
 <BN9PR11MB5276C7BFA77C2C176491B56A8CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <BN9PR11MB5276C7BFA77C2C176491B56A8CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-17 03:53, Tian, Kevin wrote:
>> From: Nicolin Chen <nicolinc@nvidia.com>
>> Sent: Friday, June 17, 2022 6:41 AM
>>
>>> ...
>>>> -     if (resv_msi) {
>>>> +     if (resv_msi && !domain->msi_cookie) {
>>>>                ret = iommu_get_msi_cookie(domain->domain,
>>>> resv_msi_base);
>>>>                if (ret && ret != -ENODEV)
>>>>                        goto out_detach;
>>>> +             domain->msi_cookie = true;
>>>>        }
>>>
>>> why not moving to alloc_attach_domain() then no need for the new
>>> domain field? It's required only when a new domain is allocated.
>>
>> When reusing an existing domain that doesn't have an msi_cookie,
>> we can do iommu_get_msi_cookie() if resv_msi is found. So it is
>> not limited to a new domain.
> 
> Looks msi_cookie requirement is per platform (currently only
> for smmu. see arm_smmu_get_resv_regions()). If there is
> no mixed case then above check is not required.
> 
> But let's hear whether Robin has a different thought here.

Yes, the cookie should logically be tied to the lifetime of the domain 
itself. In the relevant context, "an existing domain that doesn't have 
an msi_cookie" should never exist.

Thanks,
Robin.
