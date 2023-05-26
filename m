Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95A712A3F
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbjEZQKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 12:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbjEZQJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 12:09:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABE713D
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:09:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bacd408046cso2049844276.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685117350; x=1687709350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpUAYBR7ODlbfqByA26sgwrFPskSnkMccKtexCI4xR0=;
        b=KnVM34SmIvYa3JrBOC/gfiKutXIv3WzMp6Togx1KyyMfwc+AvVwsruPYa13rekp9Du
         hJSJccPYF3kwP7fVGsyDSB6T6EsENVuGIMBPYOo2phW8bza8WhwFUiZj1G/abHuYwuGt
         BA9RbXbR0qcsI43tAGMKau9ThV0zksu/ltW3dpwBrw6Qt69YgVB7FiM11XR9mwT/mas9
         MpjFUHuesGRqZOZIuBe5YP1Xbafc7wLL8uoHFnPz/rw0djUfELZNqOr601SnGGW1ZBfr
         5mlJJzsBZbUqptvWCkDuWc9CbGuFGiMlsBYGJGv9V2K1ranMzLHDHVIiGSaojD6g+szT
         UeBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117350; x=1687709350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpUAYBR7ODlbfqByA26sgwrFPskSnkMccKtexCI4xR0=;
        b=Mdwt//bMTdhjDwYRcgmecg/OYSRWXR0IdDxyKcKTLBqMX94SiMgCvbhMnQtPLyAdoF
         Cu0gtu7NUnMSJS/QvHazMCqfV+ZHcVOsgiZPa0lY9ozHGgIcQXqVez3fKBQiMPB9jg7A
         +8XGzB7nMHWcC02z6IIDTngATAcyRMlMTn+SkiAceZWIybT7jUAHvpuwZ4dzb4rTTnix
         526ijVMDZxz+qpk5YCVTW9nM3DWwcvXU+eBFNUy+SlCcAEh0Zh/ml4OdNyeNgi8mfoGd
         GNWBN71vpibzdrGaVSpcyf8W1R3pzmVEoHuX/j5/nmXimD70VqQfbcfevzBEq/V/rxGF
         N69Q==
X-Gm-Message-State: AC+VfDz7d8h9m3KRHZGCQPljBZnr9ztsax4O8yEDId2Oj1eJGNSRHRQQ
        Th00XDOe8ZD/mLTbSkRrDlf6HUS1wjE=
X-Google-Smtp-Source: ACHHUZ7sOlnlrTgkj5FFmOi0FWZo3NsBjA6ZssYVmLqPoS9NGVJZ/4P4hM/CZbfp7Dc5/d73ga9wDul1k8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f826:0:b0:ba8:2e68:7715 with SMTP id
 u38-20020a25f826000000b00ba82e687715mr1225792ybd.2.1685117350000; Fri, 26 May
 2023 09:09:10 -0700 (PDT)
Date:   Fri, 26 May 2023 09:09:08 -0700
In-Reply-To: <ZHBloxxmY/EUyswL@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com> <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com> <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
 <ZG5VlRzJkcwo9Qju@google.com> <ZG8z493pfPIOPAT2@yzhao56-desk.sh.intel.com>
 <ZG92dWFxu+ue31Sl@google.com> <ZHBloxxmY/EUyswL@yzhao56-desk.sh.intel.com>
Message-ID: <ZHDZpHYQhPtkNnQe@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Robert Hoo <robert.hoo.linux@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Yan Zhao wrote:
> On Thu, May 25, 2023 at 07:53:41AM -0700, Sean Christopherson wrote:
> > > > > > So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> > > > > > then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> > > > > > and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> > > > > > if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> > > > > > zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> > > Not only non-WB ranges are required to be zapped.
> > > Think about a scenario:
> > > (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too.
> > > (2) after CR0.CD=1, without zap, its EPT entry memtype is still UC.
> > > (3) then guest performs MTRR disable, no zap too.
> > > (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> > > (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.
> > 
> > KVM installs WB memtype when the quirk is enabled, thus no need to zap.  KVM
> > currently zaps everything when the quirk is disabled, and I'm not proposing that
> > be changed.
> I didn't explain it clearly.
> 
> (1) one fixed MTRR range is UC initially. Its EPT entry memtype is UC, too. ==> EPT entry has been created here
> (2) after CR0.CD=1, because of the quirk, no zap, the created EPT entry memtype is still UC.
> (3) then guest performs MTRR disable, no zap too, according to our change.
> (4) guest updates this fixed MTRR range to WB, and performs MTRR enable.
> (5) CR0.CD=0. we need to zap this fixed range to update the EPT memtype to WB.==>we also need to zap WB range.

Ugh, right.  But that case can be handled by zapping non-WB ranges on CR0.CD being
set.  Hmm, and KVM would need to zap everything if CR0.CD is toggled with MTRRs
disabled, but I don't think OVMF ever does that.  Zapping on CR0.CD toggling would
would likely introduce a small performance hit for SeaBIOS due to SeaBIOS clearing
CR0.CD immediately after SIPI, i.e. with MTRRs disabled, but that's arguably a
correctness fix since the quirk means KVM incorrectly runs the vCPU with WB SPTEs
until MTRRs are programmed.

With precise+batched zapping, zapping non-WB ranges even when CR0.CD is set should
still be a healthy performance boost for OVMF.

> > It doesn't actually require non-coherent DMA within the CR0.CD=1 window though.
> If we don't need to mind non-coherent DMA within the window CR0.CD=1 to CR0.CD=0,
> do you think it's a good idea to do in this way...
> 
> (1) when CR0.CD=1, return guest mtrr type. 
> 
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7532,12 +7532,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> 
>         if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
> -               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -                       cache = MTRR_TYPE_WRBACK;
> -               else
> +               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
> +                       cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
> +                       return cache << VMX_EPT_MT_EPTE_SHIFT;
> +               } else {
>                         cache = MTRR_TYPE_UNCACHABLE;
> -
> -               return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +                       return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +               }
>         }
> 
> 
> (2) return MTRR_TYPE_WRBACK if guest mtrr has not been enabled for once
> u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
> @@ -628,13 +635,23 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
>         struct mtrr_iter iter;
>         u64 start, end;
>         int type = -1;
>         const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
>                                | (1 << MTRR_TYPE_WRTHROUGH);
>  
> +       if (!mtrr_state->enabled_once)
> +               return MTRR_TYPE_WRBACK;

No, because this assumes too many things about the guest, and completely falls
apart if the guest reboots.

> (3) when CR0.CD = 1 and the quirk is on, return MTRR type as if MTRR is enabled
> +       ignore_disable = kvm_read_cr0_bits(vcpu, X86_CR0_CD) &&
> +                        kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED);
> 
> -static void mtrr_lookup_start(struct mtrr_iter *iter)
> +static void mtrr_lookup_start(struct mtrr_iter *iter, bool ignore_disable)
>  {
> -       if (!mtrr_is_enabled(iter->mtrr_state)) {
> +       if (!ignore_disable && !mtrr_is_enabled(iter->mtrr_state)) {
>                 iter->mtrr_disabled = true;
>                 return;
>         }
> 
> (4) Then we only need to do EPT zap when MTRR is enabled for the first time
> and when MTRR fixed/var entries are changed at enabling MTRR or at CR0.CD=0
> (I prefer at enabling MTRR, as seabios may do the MTRR disable/update/enable when
> CR0.CD=0)
> 
> 
> Besides, accoding to the commit message introducing KVM_QUIRK_CD_NW_CLEARED,

I am not willing to lean on the historical commit messages for the quirk to
justify any change.  I'm not at all convinced that there was any meaningful thought
put into ensuring correctness.

> we can return MTRR_TYPE_WRBACK for CR0.CD=1 only when MTRR is not enbled for
> once. (And I tried, it works!)

On your system, for your setup.  The quirk terrifies me because it likely affects
every KVM-based VM out there (I can't find a single VMM that disables the quirk).
These changes are limited to VMs with noncoherent DMA, but still.

In short, I am steadfastly against any change that piles more arbitrary behavior
functional behavior on top of the quirk, especially when that behavior relies on
heuristics to try and guess what the guest is doing.
