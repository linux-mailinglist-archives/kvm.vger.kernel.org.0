Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74D73E819
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjFZSW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjFZSWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:22:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7A310FB
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:22:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5700861af1bso50718167b3.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687803707; x=1690395707;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hupRzbzLCG/KIXYw3qGlEQa2tHfb7hjWdTMdzJJmdDM=;
        b=ohSso1FC/DQeIHA+1eUJuSO1lOTpFRkGhOiR6VdJjcISbGPEIquZUTMbeyZVkgFAkQ
         gqRGTWeNf8b1rvSgk4aQYTukf60xObTtwT4X+zDQZJ+F9/1MdV+vYhUlV+KlVB1sIZQl
         YSUd45XUPOPlVoNH5vDpHfpn/OhZw5YQe0e+o/2cD+zYWrq4ct2jjzzZh99BFN+0jmis
         YZXeaME2EtNMRWM1RqJLd+QRh4kVCKYPPe3un35mjJYLRHafNbhjy6+89BfS1H+cJi4g
         yHoyVcUcTxVmYJx+NUDsDXob0MLjaynvK7SamfewI1YntDWnKpSFNLBudyt6JSGfk0aG
         QD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687803707; x=1690395707;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hupRzbzLCG/KIXYw3qGlEQa2tHfb7hjWdTMdzJJmdDM=;
        b=BnBJ7zxdEh6r/7gF5ax/XJ9HH4laDsR9x1tBGb28ladLYlzo8MByO9JpaC/BkWXzKn
         iT2G5QR6sUIq0NZb72WzuCJxQP2CgJxN2EKQMdGEVk6coZM+xbAznZTXLuRMlYc+sE5+
         J2mxHGCMR3Vv8ztfwVj6zPeQdKrhwque0V7kxX0AiGGtXSBVvEsV6UBbHH2E8kusxyLf
         0W9Pksq1eWM/vt3QWeuCPaflgNsCFiFuAgldg8iRU0ZkD6g523MS/IraWvSYEKVHLCx4
         utLF2YH+kgOeoEq4p+ft55rX0WQRyLbVq6uAG4MlIyn1qhja+5Sp2VmauvsicEYOv/KG
         iikQ==
X-Gm-Message-State: AC+VfDz/YBBbg2H7HtRu+lZuBjl6Uzs3q33lRDPfhnNIziEyEe6KB5wz
        nbFSc6q80JinDFSDdiEt0M9UzGD9db8=
X-Google-Smtp-Source: ACHHUZ7RxEyzb6Y1552i3A91XNRZFOLdXv2HoYbR4FmMQlZGGkLJM8luga2UBQhkCA//Pht8ELhRkZL/yL4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4007:0:b0:bc4:8627:57c3 with SMTP id
 n7-20020a254007000000b00bc4862757c3mr12315046yba.9.1687803707139; Mon, 26 Jun
 2023 11:21:47 -0700 (PDT)
Date:   Mon, 26 Jun 2023 11:21:45 -0700
In-Reply-To: <20230626010753.xru5ph3irmyokrgc@amd.com>
Mime-Version: 1.0
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
 <ZJX6s2HxbHOUMXlj@google.com> <20230626010753.xru5ph3irmyokrgc@amd.com>
Message-ID: <ZJnXObRHhn5Q1dX2@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: x86: Introduce fault type to indicate kvm
 page fault is private
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 25, 2023, Michael Roth wrote:
> On Fri, Jun 23, 2023 at 01:04:03PM -0700, Sean Christopherson wrote:
> > On Thu, Jun 22, 2023, isaku.yamahata@intel.com wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_i=
nternal.h
> > > index 7f9ec1e5b136..0ec0b927a391 100644
> > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > @@ -188,6 +188,13 @@ static inline bool is_nx_huge_page_enabled(struc=
t kvm *kvm)
> > >  	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages=
;
> > >  }
> > > =20
> > > +enum kvm_fault_type {
> > > +	KVM_FAULT_MEM_ATTR,
> > > +	KVM_FAULT_SHARED,
> > > +	KVM_FAULT_SHARED_ALWAYS,
> > > +	KVM_FAULT_PRIVATE,
> >=20
> > This is silly.  Just use AMD's error code bit, i.e. PFERR_GUEST_ENC_MAS=
K as per
> > the SNP series.
> >=20
> >   Bit 34 (ENC): Set to 1 if the guest=E2=80=99s effective C-bit was 1, =
0 otherwise.
> >=20
> > Just because Intel's ucode is too crusty to support error codes larger =
than 16
> > bits doesn't mean KVM can't utilize the bits :-)  KVM already translate=
s to AMD's
> > error codes for other things, e.g.
> >=20
> > 	error_code |=3D (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) !=
=3D 0 ?
> > 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> >=20
> > For TDX, handle_ept_violation() can do something like:
> >=20
> > 	if (is_tdx(vcpu->kvm))
> > 		error_code |=3D (gpa & shared) ? 0 : PFERR_GUEST_ENC_MASK;
> > 	else if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(gpa)))
> > 		error_code |=3D PFERR_GUEST_ENC_MASK;
>=20
> Maybe this is what you're getting at below, but seems awkward to have thi=
s
> being handling in TDX code since that would suggest that SVM module would
> also need to duplicate that logic and synthesize this PFERR_GUEST_ENC_MAS=
K
> bit for non-SNP VMs (e.g. gmem self-tests).

Ah, right, forgot about that angle.  The non-TDX synthesizing can be done i=
n
kvm_mmu_page_fault(), e.g.

	if (vcpu->kvm->vm_type =3D=3D KVM_X86_PROTECTED_VM &&
	    kvm_mem_is_private(...))
		error_code |=3D PFERR_GUEST_ENC_MASK;

> So maybe SNP/TDX can rely on passing this via error_code, and then some
> common code, like kvm_mem_is_private(), can handle this for non-TDX/SNP
> guest types. But the current gmem series does this via a new .is_private
> in kvm_page_fault:
>=20
>   .is_private =3D kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT)=
,
>=20
> This seems at odds with the idea of storing this 'fault->is_private'
> logic into the error_code. Isaku and I were discussing[1] that we
> should do one or the other:
>=20
>   a) store everything in error_code
>   b) use the .is_private field that seems to have been introduced to
>      track exactly this information
>=20
> So I think this series is attempting to do b). If you're suggesting we
> should do a), then what purpose is fault->is_private field meant to
> serve? Are you planning to get rid of it? Otherwise it seems redundant.
>=20
> But I think approach b) is useful for another reason:

"is_private" would serve the same purpose as all the other bits that are de=
rived
from the error code, e.g. improve readability, reduce line lengths, etc.  T=
hough
looking at the name, just "private" is probably the right name.

	/* Derived from error_code.  */
	const bool exec;
	const bool write;
	const bool present;
	const bool rsvd;
	const bool user;

> > And that's not even taking into account that TDX might have a separate =
entry point,
> > i.e. the "is_tdx()" check can probably be avoided.
> >=20
> > As for optimizing kvm_mem_is_private() to avoid unnecessary xarray look=
ups, that
> > can and should be done separately, e.g.
> >=20
> >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   {
> > 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> > 	       kvm_guest_has_private_mem(kvm) &&
> > 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIV=
ATE;
> >   }
> >=20
> > where x86's implementation of kvm_guest_has_private_mem() can be
> >=20
> >   #define kvm_guest_has_private_mem(kvm) (!!(kvm)->vm_type)
>=20
> It's just about not checking xarray for non-protected case. The
> optimization here is that neither TDX nor SNP care about the xarray as
> far as determining whether the *fault* was a private or not.

Yes, and what I am suggesting doesn't use kvm_mem_is_private() to synthesiz=
e that
flag for TDX (or SNP).

> We only care later, in part of the KVM MMU code that determines whether t=
he
> fault type is at odds with the xarray state and whether to generate a
> KVM_EXIT_MEMORY_FAULT as a result.
>=20
> In that code, both TDX/SNP, as well as gmem self-tests, will all end up
> calling kvm_mem_is_private().
>=20
> In the gmem self-test case, in current gmem base series, and I think with
> what you've proposed here, we'd check the xarray via kvm_mem_is_privae(),
> both in kvm_mmu_do_page_fault(), as well as later kvm_faultin_pfn() where
> KVM_EXIT_MEMORY_FAULT case is handled. That seems off because:
>=20
>   1) Checking in kvm_mem_is_private() via kvm_mmu_do_page_fault() means
>      that we will grab the value prior to when the KVM MMU records the
>      mmu_invalidate_seq, which means there's a window between
>      kvm_mmu_do_page_fault() and kvm_faultin_pfn() where an updated
>      xarray won't be noticed, and the #NPF retry logic will not get
>      triggered.

That's ok-ish, for some definitions of ok.  There's no fatal bug, but users=
pace
will see a spurious, arguably nonsensical exit.  If the race occurs before =
mmu_seq
is snapshot, this code will detect the change and exit to userspace.

	if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->gfn))
		return kvm_do_memory_fault_exit(vcpu, fault);

>   2) For gmem self-test, kvm_mem_is_private() is the authority on
>      whether the fault is private or not. There's no need to distinguish
>      between what was set via KVM_SET_MEMORY_ATTRIBUTES, vs. what was
>      indicated via fault flags/GPA like TDX/SNP do.
>=20
> So it makes sense, in the gmem case (and TDX/SNP), to defer the
> kvm_mem_is_private() till later in kvm_faultin_pfn(). It avoid a
> duplicate lookup, and a race. But .is_private only conveys
> encrypted/unencrypted fault in TDX/SNP case, it doesn't have a way to
> cleanly convey this case "just use whatever kvm_mem_is_private() reports
> later, because it will always be what the VMM set, and it's too early
> to check kvm_mem_is_private() right now".

Yeah, the duplicate lookup is unfortunate :-/  But I'd really like to be ab=
le to
make kvm_page_fault.private const, just like all the other booleans that ar=
e
derived from the error code.  My concern with making it *not* const is that
there will be a discrepancy between "private" and "error_code", and we'll h=
ave
to be very careful to never touch "private" before kvm_faultin_pfn().

And I don't want to special case "VMM defined", because the primary reason =
the
"VMM defined" case exists at this time is to allow testing KVM's implementa=
tion
without TDX or SNP.  E.g. I don't want to end up with code in fast_page_fau=
lt()
or so that does X for KVM_FAULT_VMM_DEFINED, but Y for KVM_FAULT_PRIVATE.

So I'm leaning toward the above be

	if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
		if (vcpu->kvm->vm_type =3D=3D KVM_X86_PROTECTED_VM)
			return RET_PF_RETRY;
		else
			return kvm_do_memory_fault_exit(vcpu, fault);
	}

even though software-protected VMs would perform a technically-unnecessary
attributes lookup.  *If* software-protected VMs ever get to the point where=
 folks
care about the performance overhead of the extra lookup, then I'm all for
revisiting the implementation, but that is a ginormous "if" at this point. =
 Though
even then I'd still prefer to figure out a way to make the flag const, but =
that's
a future problem.

> So that's where this enum type came from. Although in the discussion I
> linked to above I suggested just:
>=20
>   enum kvm_fault_type {
>     KVM_FAULT_VMM_DEFINED,
>     KVM_FAULT_SHARED,
>     KVM_FAULT_PRIVATE,
>=20
> Which I think would work just as well,

I want to use vm_type for tracking "VMM_DEFINED".  KVM's ABI easily allows =
for 64
VM types, I see no reason to reuse KVM_X86_PROTECTED_VM for TDX and/or SNP,=
 though
the type probably should be KVM_X86_SW_PROTECTED_VM.  With that out of the =
way,
there's no need for an enum to track shared vs. private.
