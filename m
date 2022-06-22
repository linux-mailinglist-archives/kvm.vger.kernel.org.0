Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AB45543E5
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 10:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352008AbiFVHzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 03:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350096AbiFVHy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 03:54:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FB9B34666;
        Wed, 22 Jun 2022 00:54:56 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC87913D5;
        Wed, 22 Jun 2022 00:54:56 -0700 (PDT)
Received: from [10.57.85.1] (unknown [10.57.85.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E50B3F66F;
        Wed, 22 Jun 2022 00:54:50 -0700 (PDT)
Message-ID: <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
Date:   Wed, 22 Jun 2022 08:54:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Content-Language: en-GB
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
 <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YqutYjgtFOTXCF0+@Asurada-Nvidia>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YqutYjgtFOTXCF0+@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-16 23:23, Nicolin Chen wrote:
> On Thu, Jun 16, 2022 at 06:40:14AM +0000, Tian, Kevin wrote:
> 
>>> The domain->ops validation was added, as a precaution, for mixed-driver
>>> systems. However, at this moment only one iommu driver is possible. So
>>> remove it.
>>
>> It's true on a physical platform. But I'm not sure whether a virtual platform
>> is allowed to include multiple e.g. one virtio-iommu alongside a virtual VT-d
>> or a virtual smmu. It might be clearer to claim that (as Robin pointed out)
>> there is plenty more significant problems than this to solve instead of simply
>> saying that only one iommu driver is possible if we don't have explicit code
>> to reject such configuration. 😊
> 
> Will edit this part. Thanks!

Oh, physical platforms with mixed IOMMUs definitely exist already. The 
main point is that while bus_set_iommu still exists, the core code 
effectively *does* prevent multiple drivers from registering - even in 
emulated cases like the example above, virtio-iommu and VT-d would both 
try to bus_set_iommu(&pci_bus_type), and one of them will lose. The 
aspect which might warrant clarification is that there's no combination 
of supported drivers which claim non-overlapping buses *and* could 
appear in the same system - even if you tried to contrive something by 
emulating, say, VT-d (PCI) alongside rockchip-iommu (platform), you 
could still only describe one or the other due to ACPI vs. Devicetree.

Thanks,
Robin.
