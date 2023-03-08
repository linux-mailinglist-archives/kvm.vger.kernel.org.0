Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791F46B11D4
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 20:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCHTME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 14:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHTMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 14:12:02 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622748A70
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 11:12:01 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-538116920c3so178378297b3.15
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 11:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678302720;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fw2hLbVqL5SgHu0yC2jKBnr76E23Fn3jrIrBYUu2agc=;
        b=d/8zt05dy3n7YdgyvlG/ZVVUTzcOMdR6coISyHK+JNpiS/QghTGvQoyP01I/rGR+BJ
         lJtM2/uOjEckgQj5foG9YaT1tAV+92pXB4s8ImQVMjPYWnPEM4XRAsy9HXKawnqX0EOs
         dn/gm7nSlK8hoY9Psy3NnWccliKHBc2zbJitYY3k+oybLNEI+g/1XWCE5rvgnxHBbpU4
         mYTwWsTz4ib93zqW0yxJwyFJJmuo/MILCqzqHZJVSXlJ88qK7BTf0XE2e/htSoXbbaT/
         7N54IM4L18cDjJ66Tg9GGrE1I1QXhsv90sWEWB19rJ6OH2hlN+tZUUAILs22Qe/nyK0y
         /jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302720;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fw2hLbVqL5SgHu0yC2jKBnr76E23Fn3jrIrBYUu2agc=;
        b=YObOeIyrQdXeardn7NUs1guOawxaBE/kCzJuBJ7ZJ7SmkWBSXEvWGDBRAJ7CbcdqEg
         rbXaUtcalURd1jBl830taJESD4E+szLRIBmzkpFm5dga1M4HRG+IXpUc1Bhf3iMbchae
         yQOSDt33yCUF/pn0EpRLSFDSV6PJjw8wR48G++ktIbiR0TIhSpjmMH1AHsyYfL6nQIYw
         x8uoZNf12I+mieycEdGAvUfCGo2LwDW2XOFYuUkyi43mur5O49DM1+qWHd+UmgCZ4A2f
         CsqNwFTDOox5R/SAhE0TjJR9dOY8ElYOYAGpz59KDbHjqdZNud7srramnNe2oBtRbCO0
         ZCsA==
X-Gm-Message-State: AO0yUKXnIIJBgPr+Lfa4tX1QWxTZipnmZT/okldP+D2ZbuGa/y90mKuo
        aCfhPXwePVWBghPYbxyQEJdzZkRNKbE=
X-Google-Smtp-Source: AK7set9TU9lXDs4kxvj5e+Thvl8AKWgxlgGcLBUP85taJjXQ9TonCcX0lJT9aDbYwFLweK2nOQllXUnyhl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4520:0:b0:534:515:e472 with SMTP id
 s32-20020a814520000000b005340515e472mr12577476ywa.4.1678302720319; Wed, 08
 Mar 2023 11:12:00 -0800 (PST)
Date:   Wed, 8 Mar 2023 11:11:58 -0800
In-Reply-To: <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <CABgObfa1578yKuw3sqnCeLXpyyKmMPgNaftP9HCdgHNM9Tztjw@mail.gmail.com>
 <ZAfZPA5Ed7STUT2B@google.com> <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
Message-ID: <ZAjd/ktCeT8D5anK@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023, Jeremi Piotrowski wrote:
> On 08/03/2023 01:39, Sean Christopherson wrote:
> > On Wed, Mar 08, 2023, Paolo Bonzini wrote:
> >> On Tue, Mar 7, 2023 at 6:36=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> >>> Thinking about this more, I would rather revert commit 1e0c7d40758b (=
"KVM: SVM:
> >>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straita=
way.  KVM
> >>> doesn't magically handle the flushes correctly for the shadow/legacy =
MMU, KVM just
> >>> happens to get lucky and not run afoul of the underlying bugs.
> >>
> >> I don't think it's about luck---the legacy MMU's zapping/invalidation
> >> seems to invoke the flush hypercall correctly:
> >=20
> > ...for the paths that Jeremi has exercised, and for which a stale TLB e=
ntry is
> > fatal to L2.  E.g. kvm_unmap_gfn_range() does not have a range-based TL=
B flush
> > in its path and fully relies on the buggy kvm_flush_remote_tlbs().
> >
>=20
> Why do you say "buggy kvm_flush_remote_tlbs"? kvm_flush_remote_tlbs calls=
 the
> hypercall that is needed, I don't see how this might be an issue of a mis=
sing
> "range-based TLB flush".

Doh, I forgot that the arch hook in kvm_flush_remote_tlbs() leads to the Hy=
per-V
hook.

svm_flush_tlb_current is very much broken, but in practice it doesn't matte=
r outside
of the direct call from kvm_mmu_load(), because in all other paths KVM will=
 flow
through a Hyper-V flush if KVM actually modifies its MMU in any ways.  E.g.=
 the
request from kvm_mmu_new_pgd() when force_flush_and_sync_on_reuse=3Dtrue is=
 neutered,
but that exists only as a safeguard against MMU bugs.  And for things like
kvm_invalidate_pcid() and kvm_post_set_cr4(), my understanding is that Hype=
r-V
will still flush the bare metal TLB, it's only Hyper-V's shadow page tables=
 that
are stale.

Depending on how Hyper-V handles ASIDs, pre_svm_run() may also be broken.  =
If
Hyper-V tracks and rebuilds only the current ASID, then bumping the ASID wo=
n't
rebuild potentially stale page tables.  But I'm guessing Hyper-V ignores th=
e ASID
since the hypercall takes only the root PA.

The truly problematic case is kvm_mmu_load(), where KVM relies on the flush=
 to
force Hyper-V to rebuild shadow page tables for an old, possibly stale nCR3=
.  This
affects only the TDP MMU because of an explicit optimization in the TDP MMU=
.  So
in practice we could squeak by with something like this:

	if (kvm_x86_ops.tlb_remote_flush =3D=3D hv_remote_flush_tlb)
		hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa);
	else
		static_call(kvm_x86_flush_tlb_current)(vcpu);

but I'm not convinced that avoiding a hypercall in svm_flush_tlb_current() =
just
to avoid overhead when running an L3 (nested VM from L1 KVM's perspective) =
is
worthwhile.  The real problem there is that KVM nested SVM TLB/ASID support=
 is an
unoptimized mess, and I can't imagine someone running an L3 is going to be =
super
concerned with performance.

I also think we should have a sanity check in the flush_tlb_all() path, i.e=
. WARN
if kvm_flush_remote_tlbs() falls back.

Something like this (probably doesn't compile, likely needs #ifdefs or help=
ers):

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef4f9e3b35a..38afc5cac1c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3770,7 +3770,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vc=
pu)
        svm->vmcb->save.rflags |=3D (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
=20
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm =3D to_svm(vcpu);
=20
@@ -3794,6 +3794,23 @@ static void svm_flush_tlb_current(struct kvm_vcpu *v=
cpu)
                svm->current_vmcb->asid_generation--;
 }
=20
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+       if (kvm_x86_ops.tlb_remote_flush =3D=3D hv_remote_flush_tlb &&
+           VALID_PAGE(vcpu->arch.mmu->root.hpa))
+               hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa);
+
+       svm_flush_tlb_asid(vcpu);
+}
+
+static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+       if (WARN_ON_ONCE(kvm_x86_ops.tlb_remote_flush =3D=3D hv_remote_flus=
h_tlb))
+               hv_remote_flush_tlb(vcpu->kvm);
+
+       svm_flush_tlb_asid(vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
        struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -4786,10 +4803,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
        .set_rflags =3D svm_set_rflags,
        .get_if_flag =3D svm_get_if_flag,
=20
-       .flush_tlb_all =3D svm_flush_tlb_current,
+       .flush_tlb_all =3D svm_flush_tlb_all,
        .flush_tlb_current =3D svm_flush_tlb_current,
        .flush_tlb_gva =3D svm_flush_tlb_gva,
-       .flush_tlb_guest =3D svm_flush_tlb_current,
+       .flush_tlb_guest =3D svm_flush_tlb_asid,
=20
        .vcpu_pre_run =3D svm_vcpu_pre_run,
        .vcpu_run =3D svm_vcpu_run,

