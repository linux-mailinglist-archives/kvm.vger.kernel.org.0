Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D645B1BDA
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiIHLtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIHLtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:49:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5733AB5;
        Thu,  8 Sep 2022 04:49:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E47B14BF;
        Thu,  8 Sep 2022 04:49:28 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DC473F71A;
        Thu,  8 Sep 2022 04:49:12 -0700 (PDT)
Message-ID: <919bfaae-0a1d-de88-8211-f9fa476e6ebf@arm.com>
Date:   Thu, 8 Sep 2022 12:49:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Content-Language: en-GB
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com> <YxeBCsA32jnwMjSj@nvidia.com>
 <87leqvv3g7.wl-maz@kernel.org>
 <MN2PR12MB4358E3CFD2E3ECECC14471F489419@MN2PR12MB4358.namprd12.prod.outlook.com>
 <87illzuzyw.wl-maz@kernel.org>
 <MN2PR12MB43581495197F603E901BBACA89419@MN2PR12MB4358.namprd12.prod.outlook.com>
 <87edwmuw4f.wl-maz@kernel.org>
 <SA0PR12MB4365D5D2C05EAB412567D42B89409@SA0PR12MB4365.namprd12.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <SA0PR12MB4365D5D2C05EAB412567D42B89409@SA0PR12MB4365.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-08 10:51, Radovanovic, Aleksandar wrote:
> [AMD Official Use Only - General]
> 
> 
> 
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: 08 September 2022 09:08
>> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>; Gupta, Nipun
>> <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
>> krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
>> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
>> cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
>> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
>> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
>> jeffrey.l.hugo@gmail.com; saravanak@google.com;
>> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
>> robin.murphy@arm.com; will@kernel.org; joro@8bytes.org;
>> masahiroy@kernel.org; ndesaulniers@google.com; linux-arm-
>> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
>> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
>> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
>> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
>> git (AMD-Xilinx) <git@amd.com>
>> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
>> domain as parent
>>
>> [CAUTION: External Email]
>>   
>> OK, so you definitely need a mapping, but it cannot be a translation, and it
>> needs to be in all the possible address spaces. OMG.
> 
> Could you elaborate why it needs to be in all the possible address spaces? I'm in no way familiar with kernel IOVA allocation, so not sure I understand this requirement. Note that each CDX device will have its own unique StreamID (in general case, equal to DeviceID sent to the GIC), so, from a SMMU perspective, the mapping can be specific to that device. As long as that IOVA is not allocated to any DMA region for _that_ device, things should be OK? But, I appreciate it might not be that simple from a kernel perspective.

That's the point - any device could could have its own mapping, 
therefore that hole has to be punched in *every* mapping that any of 
those devices could use, so that MSI writes don't unexpectedly fault, or 
corrupt memory if that address is free to be used to map a DMA buffer. 
At least the HiSilicon PCI quirk is functionally similar (for slightly 
different underlying reasons) so there's already precedent and an 
example that you can follow to a reasonable degree.

Robin.
