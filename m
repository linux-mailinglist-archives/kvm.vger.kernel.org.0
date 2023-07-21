Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D689F75C944
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 16:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGUOLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 10:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjGUOLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 10:11:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41E2FD
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:11:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so1728886276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689948704; x=1690553504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4SdCBonFvWuf+V0yEJ7nT449w336KZFoWRjXJb2o+8=;
        b=n0oKwH0dgFAGMVF27nk3YDk+kFnnpdNBuswzKKsDjUoF2nttUcFPQAkqIQGcn0vrbH
         T/IucMfN+WY88gtSSszC9sE2AOaEvI3LvZ/89ISKL1/4Eui6pr5dnCaRqpMbBbdVWsYv
         NRptPq/VIq8QeXzcY4lctUyDp4uXHQnVipX3esx5J7htoMXXac4+aNvckJCuvtputXFM
         Ey6stLIQHLTh6AWzRANZgxRvllCkH15KVd+nBxOMRRXGWHdlimZlTV+Wew5WEIFL+PBk
         V1aphpXfO/KyTCCCKDLLkTbYJ6wkv8i3EyZqsT8phHQ8tdPzL6w1VMKzFt0jzzKo/WGf
         WWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689948704; x=1690553504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4SdCBonFvWuf+V0yEJ7nT449w336KZFoWRjXJb2o+8=;
        b=OW74g0smQ4nFb/JxnXi7ACZ4GrPeJYX+RK7gr+XFjc5z/gfQKrdm4roa1JM5vt2EDu
         tD5+N8kfmDZVOAUEbYRYOeBcBQtV0e9P4LURdT1oSpPFSQUlNR/RGEl+wOsnWWtHOy2r
         slkxad5TSJaHErVP6/VGNqflpNjkF1Q+UUkgSrhFdiYbXzHL2nqrVNGorSqGuV+C+t9d
         k4JLxfPYIjai5Z4vOEMCeZVFU92tOL9tL3Tsr2VOppMhNvXOc/qcdlX9sI2/m6fTutmB
         /AuWRV+JF03YEbSChLor1yK5jer/e9akBsxE0Vr/KtM/YqZ7/tAzBmzqOCh5MPOjdz9k
         KoMg==
X-Gm-Message-State: ABy/qLbxf6DMC5O6tSJkrH0jHn3BtZRyuNWl2cJGNk/LkTgbpKpSddjr
        ryoVdtTMO3APlGT7/ykiIpKJuMKRU0Q=
X-Google-Smtp-Source: APBJJlGU/N1c7xh9FsCGTTqaD2PqcnAod11BMYxzm1muKo1ARK3G7tqDbEj8dtVJ1jfB1maibUqj4V2HcNs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ba06:0:b0:c61:7151:6727 with SMTP id
 t6-20020a25ba06000000b00c6171516727mr13809ybg.10.1689948704796; Fri, 21 Jul
 2023 07:11:44 -0700 (PDT)
Date:   Fri, 21 Jul 2023 07:11:43 -0700
In-Reply-To: <f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com> <f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com>
Message-ID: <ZLqSH/lEbHEnQ9i8@google.com>
Subject: Re: [RFC PATCH v4 04/10] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to
 indicate fault is private
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/Introduce/Use

This doesn't "introduce" anything, in the sense that it's an AMD-defined error
code flag.  That matters because KVM *did* introduce/define PFERR_IMPLICIT_ACCESS.

On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add two PFERR codes to designate that the page fault is private and that
> it requires looking up memory attributes.  The vendor kvm page fault
> handler should set PFERR_GUEST_ENC_MASK bit based on their fault
> information.  It may or may not use the hardware value directly or
> parse the hardware value to set the bit.
> 
> For KVM_X86_PROTECTED_VM, ask memory attributes for the fault privateness.

...

> +static inline bool kvm_is_fault_private(struct kvm *kvm, gpa_t gpa, u64 error_code)
> +{
> +	/*
> +	 * This is racy with mmu_seq.  If we hit a race, it would result in a
> +	 * spurious KVM_EXIT_MEMORY_FAULT.
> +	 */
> +	if (kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
> +		return kvm_mem_is_private(kvm, gpa_to_gfn(gpa));

Please synthesize the error code flag for SW-protected VMs, same as TDX, e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 20e289e872eb..de9e0a9c41e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5751,6 +5751,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
        if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
                return RET_PF_RETRY;
 
+       if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+               error_code |= PFERR_GUEST_ENC_MASK;
+
        r = RET_PF_INVALID;
        if (unlikely(error_code & PFERR_RSVD_MASK)) {
                r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);

Functionally it's the same, but I want all VM types to have the same source of
truth for private versus shared, and I really don't want kvm_is_fault_private()
to exist.
