Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CFD617E46
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiKCNpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiKCNpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:45:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A83AF50;
        Thu,  3 Nov 2022 06:45:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B3421FB;
        Thu,  3 Nov 2022 06:45:18 -0700 (PDT)
Received: from [10.1.39.27] (e122027.cambridge.arm.com [10.1.39.27])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CF4A3F534;
        Thu,  3 Nov 2022 06:45:07 -0700 (PDT)
Message-ID: <fbdec740-5654-ee23-caa0-22cc7d7b1f02@arm.com>
Date:   Thu, 3 Nov 2022 13:45:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
Content-Language: en-GB
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20221103131210.3603385-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2022 13:12, Usama Arif wrote:
> This includes table format and using reST labels for
> cross-referencing to vcpu.rst.
> 
> Suggested-by:  Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  Documentation/virt/kvm/arm/pvtime.rst   | 14 ++++++++------
>  Documentation/virt/kvm/devices/vcpu.rst |  2 ++
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
> index 392521af7c90..e88b34e586be 100644
> --- a/Documentation/virt/kvm/arm/pvtime.rst
> +++ b/Documentation/virt/kvm/arm/pvtime.rst
> @@ -23,21 +23,23 @@ the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
>  ARCH_FEATURES mechanism before calling it.
>  
>  PV_TIME_FEATURES
> -    ============= ========    ==========
> +
> +    ============= ========    =================================================
>      Function ID:  (uint32)    0xC5000020
>      PV_call_id:   (uint32)    The function to query for support.
>                                Currently only PV_TIME_ST is supported.
>      Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>                                PV-time feature is supported by the hypervisor.
> -    ============= ========    ==========
> +    ============= ========    =================================================
>  
>  PV_TIME_ST
> -    ============= ========    ==========
> +
> +    ============= ========    ==============================================
>      Function ID:  (uint32)    0xC5000021
>      Return value: (int64)     IPA of the stolen time data structure for this
>                                VCPU. On failure:
>                                NOT_SUPPORTED (-1)
> -    ============= ========    ==========
> +    ============= ========    ==============================================
>  
>  The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
>  with inner and outer write back caching attributes, in the inner shareable
> @@ -76,5 +78,5 @@ It is advisable that one or more 64k pages are set aside for the purpose of
>  these structures and not used for other purposes, this enables the guest to map
>  the region using 64k pages and avoids conflicting attributes with other memory.
>  
> -For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
> -section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
> +For the user space interface see
> +:ref:`Documentation/virt/kvm/devices/vcpu.rst <kvm_arm_vcpu_pvtime_ctrl>`.
> \ No newline at end of file
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 716aa3edae14..31f14ec4a65b 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -171,6 +171,8 @@ configured values on other VCPUs.  Userspace should configure the interrupt
>  numbers on at least one VCPU after creating all VCPUs and before running any
>  VCPUs.
>  
> +.. _kvm_arm_vcpu_pvtime_ctrl:
> +
>  3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>  ==================================
>  

