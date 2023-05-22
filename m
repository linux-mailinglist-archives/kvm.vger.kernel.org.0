Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54370C397
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjEVQhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 12:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjEVQhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 12:37:53 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D34BF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:37:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-528ab7097afso5315510a12.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684773472; x=1687365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VtfwEOOrFT56Me1+y80csEj29fh/4MEfuxZGlV/VCwA=;
        b=VkBCPFP4Xr4WiQTM6UWimd/KzdFgGf1iO10w8WMqvOYGA9ksvBEI+77IilCjSLsRg6
         EX8gGuEzmu2jQ0l7+I42/XZ73M6g2Hivq0shGrBNxEDc+Wrb9R1UNelbm6cq/cHThulK
         u+OAoXsC9QgWYKMhU2KgdeOWPmh1cMUs53eLClb9eluF/vE1mwbxnOuGVT8U3OzSrzv6
         TNSSJ0siqzX/P+ElcDsqhyZTm+e0IggrzH0mMbpYpy/mYsc5K8Xm+vixj+7wRdKd2CBS
         g2xqYzW399l2F4YXnV7jDYyb6ILAyoabt9yzprRzFSWOT5ELhje2w5Z+2IEgOgC3vEFe
         qvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684773472; x=1687365472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VtfwEOOrFT56Me1+y80csEj29fh/4MEfuxZGlV/VCwA=;
        b=JyriJyKyoOxqu26bgOlJmAriouxCWar/LiQN5/+x+5JQgVtMfGfP9Gy1vmobFIuoLx
         MJfIjGgh86SRpwisELFnodUbRMfpXRus9LDQdP/ZgxF6EpFAisn/wTPtYrDQJF1DU2x3
         JYoSpBqcPYLwzMmyBXlg6mkifQTUSccDgtxMX3A1HQci6A2XVVcOhqeDTQYP/fRqbfJa
         jG1mrFL0FAQPx8dvFoshP8x5gTU4KHvQlRl9iImqRm50/FagJLeeMr+NpYF9eQcWTaZB
         7Obzb9sAQcFr7gFnAUc2ah1+aUzuGkDUtS/zHwdIezq8cHYzCZz99xGNv8JkgviSLhNp
         rAvw==
X-Gm-Message-State: AC+VfDy/AhYKQRGWWjOf48YcRTSN6/ZzJBniATz3lWxT+plJBUSjys63
        pVHSqH7f7EmMdqP9e+kF+P1KxhuRe5c=
X-Google-Smtp-Source: ACHHUZ6EpaYD3bKwNCWWyaUrZhak9gLowttSZvR91by2PQtqwd6WvpY4NdAZKtlgX3Hlhqji73+7Shdv7ow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ec12:0:b0:52c:4227:aa60 with SMTP id
 j18-20020a63ec12000000b0052c4227aa60mr2565348pgh.7.1684773472003; Mon, 22 May
 2023 09:37:52 -0700 (PDT)
Date:   Mon, 22 May 2023 09:37:50 -0700
In-Reply-To: <4ffbb2c3-8ed1-d419-16ca-b311867537be@intel.com>
Mime-Version: 1.0
References: <20230506030435.80262-1-chao.gao@intel.com> <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com> <4ffbb2c3-8ed1-d419-16ca-b311867537be@intel.com>
Message-ID: <ZGuaXp2f5VhfEyUI@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Dave Hansen wrote:
> On 5/18/23 10:33, Sean Christopherson wrote:
> > 
> >   2. I'm pretty sure conditioning mmio_stale_data_clear on kvm_arch_has_assigned_device()
> >      is a bug.  AIUI, the vulnerability applies to _any_ MMIO accesses.  Assigning
> >      a device is necessary to let the device DMA into the guest, but it's not
> >      necessary to let the guest access MMIO addresses, that's done purely via
> >      memslots.
> 
> Just to make sure we're all on the same page: KVM needs mitigations when
> real, hardware MMIO is exposed to the guest.  None of this has anything
> to do with virtio or what guests _normally_ see as devices or MMIO.  Right?

Yes.  I try to always call MMIO that is handled by a synthetic/virtual/emulated
device "emulated MMIO", specifically to differentiate between the two cases.

> But direct device assignment does that "real hardware MMIO" for sure
> because it's mapping parts of the PCI address space (which is all MMIO)
> into the guest.  That's what the kvm_arch_has_assigned_device() check
> was going for.
> 
> But I think you're also saying that, in the end, memory gets exposed to
> the guest by KVM userspace setting up a memslot.  KVM userspace _could_
> have mapped a piece of MMIO and could just pass that down to a guest
> without kvm_arch_has_assigned_device() being involved.  That makes the
> kvm_arch_has_assigned_device() useless.

Yep.

> In other words, all guests with kvm_arch_has_assigned_device() need
> mitigation.

Yes, assuming the guest wants to actually use the device :-)

> But there are potentially situations where the guest can see real hardware MMIO
> and yet also be !kvm_arch_has_assigned_device().

Yes.  There may or may not be _legitimate_ scenarios for exposing host MMIO to the
guest without an assigned device, but as far as the mitigation is concerned, being
legitimate or not doesn't matter, all that matters is that userspace can expose
host MMIO to the guest irrespective of VFIO.

FWIW, I think this would be a minimal fix without having to apply the mitigation
blindly.  My only concern is that there might be gaps in the kvm_is_mmio_pfn()
heuristic, but if that's the case then KVM likely has other issues, e.g. would
potentially map MMIO with the wrong memtype.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2865c3cb3501..ac3c535ae3b9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1274,6 +1274,7 @@ struct kvm_arch {
 
        bool apic_access_memslot_enabled;
        bool apic_access_memslot_inhibited;
+       bool vm_has_passthrough_mmio;
 
        /* Protects apicv_inhibit_reasons */
        struct rw_semaphore apicv_update_lock;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cf2c6426a6fc..83d235488e56 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -189,6 +189,10 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
        if (level > PG_LEVEL_4K)
                spte |= PT_PAGE_SIZE_MASK;
 
+       if (static_branch_unlikely(&mmio_stale_data_clear) &&
+           !vcpu->kvm->arch.vm_has_passthrough_mmio && kvm_is_mmio_pfn(pfn))
+               vcpu->kvm->arch.vm_has_passthrough_mmio = true;
+
        if (shadow_memtype_mask)
                spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
                                                         kvm_is_mmio_pfn(pfn));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..9c66ba35af92 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7159,7 +7159,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
        else if (static_branch_unlikely(&mds_user_clear))
                mds_clear_cpu_buffers();
        else if (static_branch_unlikely(&mmio_stale_data_clear) &&
-                kvm_arch_has_assigned_device(vcpu->kvm))
+                to_kvm_vmx(vcpu->kvm)->vm_has_passthrough_mmio)
                mds_clear_cpu_buffers();
 
        vmx_disable_fb_clear(vmx);
