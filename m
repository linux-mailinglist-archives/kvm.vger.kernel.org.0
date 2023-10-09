Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9727BED6E
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378653AbjJIVga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 17:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377082AbjJIVg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 17:36:29 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97509C
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 14:36:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27756e0e4d8so4888446a91.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696887387; x=1697492187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CeiLuszUQzm1dE5vxA8gfNKXniFYODS3y9KHytRWFpM=;
        b=DS0pyVOSgJn+2cY+lenjN3nIPtGMAAwB7k12PM5aOtfo64vgPgPjUApWcD9l54GZJo
         ZQsSUZREQdCs95eFYRv+CoN/tgNCrKuOEMZsk9Hx7X3b3r/R/PC/y+XIf9drXdqneDUo
         fiNCv7f594wHPeQ06bELorTMs1bj/H68GkKjIlJK121d33Kvjg3vQ/CmDTKkgPdqqC0Z
         gwXm8nMXKh4n79ciTYlf1IDYy8cbNqNYXGH8Hr/IX1rE3GWqQf190pKZzXVnk7zTC9CI
         MIdI0ArO5VroGsxc8bXrokQ0CcwEpGbYTBU34H7COid2q1kj4NauxUGPYi/2y2KeqaCH
         UK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696887387; x=1697492187;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CeiLuszUQzm1dE5vxA8gfNKXniFYODS3y9KHytRWFpM=;
        b=gvSEpb5rrBITNt7qKIl/QszNsNyKdd7+SDr6egvJpWysM4iIxeRRdnmzTv91p1PNgo
         Hdra0Gjr302q74uYGM1I3+32FNhWm54C6DVu6Yg5Sb4lLZrHbQJM/G2cStpr19xvDKg7
         AszqnOhGggKWiRCDqkUeLqG7SyhRgUlKP1nop6WtpnNXT16XYyfi6IAES0E5CDFzkYGV
         vXlrxnNQz9nt3/kp25JvQKKGDkQFDg4+//OAnMoIg47vRVNEzGbl1jVOzqNHv4y5sWEj
         CAzW/rEXTAQKc09QTHMQtJPWURPA2ZJdPRaSx+lG+d2aJ3Rp+aW+0vGK1AfREXBaQa2U
         Q5+g==
X-Gm-Message-State: AOJu0Yxh4HEdvUb0olwEUlJiUUmtrRUdm8o8SqFEVdmkohpqOh+csl/R
        zwdP7Ecn+gm7/i35HAyhV/30bNXNyKI=
X-Google-Smtp-Source: AGHT+IH8GWGnwoLTEqdBmVnAXJqCsoSI7/uTXTXbteBLWdYRa84UsZFE39P2qq7akQ3npr7ZQiqyYJ/tw74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a393:b0:274:90a4:f29 with SMTP id
 x19-20020a17090aa39300b0027490a40f29mr280600pjp.1.1696887387251; Mon, 09 Oct
 2023 14:36:27 -0700 (PDT)
Date:   Mon, 9 Oct 2023 14:36:25 -0700
In-Reply-To: <ZSRwNO4xWU6Dx1ne@google.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com> <ZSRZ_y64UPXBG6lA@google.com>
 <ZSRwNO4xWU6Dx1ne@google.com>
Message-ID: <ZSRyWYZBYur-cKYS@google.com>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023, Sean Christopherson wrote:
> On Mon, Oct 09, 2023, Sean Christopherson wrote:
> > On Sat, Oct 07, 2023, Like Xu wrote:
> > > On 14/7/2023 2:50=E2=80=AFpm, Yan Zhao wrote:
> > > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > > index 92d5a1924fc1..38bd449226f6 100644
> > > > --- a/arch/x86/kvm/mmu.h
> > > > +++ b/arch/x86/kvm/mmu.h
> > > > @@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_v=
cpu *vcpu, struct kvm_mmu *mmu,
> > > >   	return -(u32)fault & errcode;
> > > >   }
> > > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_non=
coherent_dma);
> > > > +
> > > > +static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> > > > +{
> > > > +	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent=
_dma(kvm));
> > > > +}
> > > > +
> > > >   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gf=
n_end);
> > > >   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 1e5db621241f..b4f89f015c37 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm=
_vcpu *vcpu,
> > > >   }
> > > >   #endif
> > > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_non=
coherent_dma)
> > >=20
> > > According to the motivation provided in the comment, the function wil=
l no
> > > longer need to be passed the parameter "struct kvm *kvm" but will rel=
y on
> > > the global parameters (plus vm_has_noncoherent_dma), removing "*kvm" =
?
> >=20
> > Yeah, I'll fixup the commit to drop @kvm from the inner helper.  Thanks=
!
>=20
> Gah, and I gave more bad advice when I suggested this idea.  There's no n=
eed to
> explicitly check tdp_enabled, as shadow_memtype_mask is set to zero if TD=
P is
> disabled.  And that must be the case, e.g. make_spte() would generate a c=
orrupt
> shadow_memtype_mask were non-zero on Intel with shadow paging.
>=20
> Yan, can you take a look at what I ended up with (see below) to make sure=
 it
> looks sane/acceptable to you?
>=20
> New hashes (assuming I didn't botch things and need even more fixup).

Oof, today is not my day.  I forgot to fix the missing "check" in the chang=
elog
that Yan reported.  So *these* are the new hashes, barring yet another goof=
 on
my end.

[1/5] KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      https://github.com/kvm-x86/linux/commit/1affe455d66d
[2/5] KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are ho=
nored
      https://github.com/kvm-x86/linux/commit/7a18c7c2b69a
[3/5] KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/9a3768191d95
[4/5] KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stop=
s
      https://github.com/kvm-x86/linux/commit/68c320298404
[5/5] KVM: VMX: drop IPAT in memtype when CD=3D1 for KVM_X86_QUIRK_CD_NW_CL=
EARED
      https://github.com/kvm-x86/linux/commit/8925b3194512
