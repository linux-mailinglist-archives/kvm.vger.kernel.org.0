Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7164E6E9
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiLPF0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 00:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLPF0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 00:26:47 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D56936D60;
        Thu, 15 Dec 2022 21:26:45 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t18so1035189pfq.13;
        Thu, 15 Dec 2022 21:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LP4ffXoiDO65KIjVIcDAkvN8bi+1ldsaOGyKaP67OqU=;
        b=Nc/v7HgHfvIrS1eZ6VDfSd6TVmIZxuBH4WdtykfA/0ZNQNVVNLgvaUKK2MYG1tAtny
         9cFrsXYpifcdrn7v0CSNYDev5j0PesePa39Ttv2cDtZUyN6VutywkII5/kG1l1Py/t36
         8Uxi+ooq7Zl/oP2gfZsXjjiYIaPuMg15kx4KiNLvsg8E3XwQv4bdP6VnrEngvEd2ZIk+
         Gg7HcJHKbQeMLQPlP9bH9gMvYdx8S+26nMprOeBf5VzMhHKj/5xtevrDLLKWkOAjblVO
         a8NJKYWOdqk4UeLIZpVlvcL9BH7tABfj1GvUU30siiDQVHCJoBMfxbupBBGYeQa0tfYS
         lJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LP4ffXoiDO65KIjVIcDAkvN8bi+1ldsaOGyKaP67OqU=;
        b=3jVCJnehbOmPXWHlJAgH12XqNTb6FE8yUs72Yd9FSME3j0d/EAbR6lcvEJgXYcptPG
         QD2ce0/OCWFmxSd13mkMFRw2pCbvGQ/PYvTMs3qm5lIt3oW0TH+vg7r5G4RDFUsZZlfC
         H+lr6/epZRx8b5dJmOzIA5aGezJ+2ux5Cn5ZP4ZaHn0mei8yZKhoSxzY2pcGrCo9Q5IF
         xXq0EcrcLjPMzDuQeXQf94mj4+o9BBSGziJuxlqxCdriPNBnE3nI3YH13RevVYDuezEE
         i3PYNcKQb3twFFFr9hZOhegH+6PwU9vygU0yCc2IM5jbODTdnW9KqXBLpaVpUgP+gwBX
         iNkA==
X-Gm-Message-State: ANoB5pkcvNrubmjPz2ETCdLBTSZXnkXisrCnw6IIogFKPgLRYyc+GIui
        q4/ZiI9qSZFPkvIHP07REb0=
X-Google-Smtp-Source: AA0mqf6lIpA85WoHjZGzQWzPaLy0pwvIo54KDzSw1r9f+3dE75IaK1s8W5XOOw5NX0+3E7TLf4nJTg==
X-Received: by 2002:aa7:911a:0:b0:577:5afa:6321 with SMTP id 26-20020aa7911a000000b005775afa6321mr34819434pfh.26.1671168404629;
        Thu, 15 Dec 2022 21:26:44 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i73-20020a62874c000000b0056bc5ad4862sm533894pfe.28.2022.12.15.21.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 21:26:44 -0800 (PST)
Date:   Thu, 15 Dec 2022 21:26:42 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Message-ID: <20221216052642.GF527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
 <5dc0263aa963534bb049b61adbfb18dec3f65f00.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dc0263aa963534bb049b61adbfb18dec3f65f00.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 11:43:14AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:23 -0700, isaku.yamahata@intel.com wrote:
> > +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	if (is_td_vcpu(vcpu)) {
> > +		if (is_mmio)
> > +			return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> > +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> > +	}
> > +
> > +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> > +}
> 
> So you are returning WB for _ALL_ guest memory, including shared.  Wouldn't this
> break MTRR handling for shared memory?  For instance, IIUC we can still support
> assigning a device to a TDX guest while the VT-d doesn't support coherent
> memory, in which case guest's MTRR/PAT are honored.  I think this should also
> apply to TDX guest's shared memory?

You're right. So here is the updated change.
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -798,11 +798,8 @@ static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
-       if (is_td_vcpu(vcpu)) {
-               if (is_mmio)
-                       return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
-               return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
-       }
+       if (is_td_vcpu(vcpu))
+               return tdx_get_mt_mask(vcpu, gfn, is_mmio);
 
        return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ac47b20e4e91..f1842eb32d6c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -568,7 +568,31 @@ int tdx_vm_init(struct kvm *kvm)
        return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+       if (is_mmio)
+               return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+               return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+
+       /* Guest CR0 is unknown.  Assume CR0.CD = 0. */
+
+       /* TDX private GPA is always WB. */
+       if (gfn & kvm_gfn_shared_mask(vcpu->kvm))
+               return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+
+       /*
+        * Because the definition of MTRR MSR is unaware of shared-bit,
+        * clear shared-bit.
+        */
+       gfn = kvm_gfn_private(vcpu->kvm, gfn);
+       return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+
+
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
        struct vcpu_tdx *tdx = to_tdx(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 96f5546194d4..38fb888e1be9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -168,6 +168,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu,
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
                           int trig_mode, int vector);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
                u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 bool tdx_is_emulated_msr(u32 index, bool write);

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
