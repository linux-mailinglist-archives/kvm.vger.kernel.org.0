Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040BE742947
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjF2PQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 11:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjF2PQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 11:16:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D430E6
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 08:16:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso652198276.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688051805; x=1690643805;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7TGC0VGQH5Yr0gxepslsru//MnVacowxczeMG+0ih5U=;
        b=uIFm08lWh354I3Yb9tpSwcd/lD37ejiz/aCL5wO1kFc5Ja7IMAEB1ZSZGhggEMCr+t
         XPlBhlePXtWobpv6scIZE66hOihfqD98wraX24uBzW6weu93/0bGUFdNcHOg/9Hr+kB7
         tJIO8EPiuQ25OtnSTaoJRFsQ6K7zxFJcROu18Vkqmd7NCCkHYpV25twRhFFuKh321+oc
         e6oAvwWKRR2wyrvtxH5+AVlLxrBMrNkdSdU1SfcSaGPNN9rbOo9oAsEhxC734AqnKxBc
         JT7oUS5wf4a4xrsxvVjIHWcyYCNMVoP5UbsfA2yOC4M5ti1xsgf2SHYvJzKDcMCMpih7
         /Fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688051805; x=1690643805;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7TGC0VGQH5Yr0gxepslsru//MnVacowxczeMG+0ih5U=;
        b=dgTwlfX732Op3IKkbnvFu8HOEQ+CIyQNqr+QaxVvHzyZKfCtHArTtZuAtP5CR0cAK5
         kgbvBbrfWVLj4ep0X6zzL+du5SRDRn6QZ3+rKy0x79e13LRtORNtjepir2wm6Qhp+pdx
         aGeNvk+0HdCKXIWIWKqiSjidNMxY1GcarUthotYPLUU8BzAQXcM8HAWli1y63P7K4zca
         vgSlZYbl4GOMwzhv8/7xtsUsQgZbriw25TAdxBOU1zxRpwbDqb395nfRl+vXOys9vAA5
         /HboLveryC08UhoY/NAw1MOJi1UE2DtjskhdpY7Ey1fV2zZXPadl98mV1nQ8h83YrEzI
         +7wA==
X-Gm-Message-State: ABy/qLbK3ysY+rRv7ukCaXF5nhA6eOmUkYl1qhOlWm9PcJofjr2mD1/p
        FdlZ3lo3acY1zG04wnMwSb5wBnNB8nM=
X-Google-Smtp-Source: APBJJlHMhTJvRuoOzizvVvyutfaZ8MDqcMNL35+km2IIyOk3qRIiEWBi4YHhm17Hsnxd/WY8WeoexSN0f6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3610:0:b0:c15:cbd1:60d6 with SMTP id
 d16-20020a253610000000b00c15cbd160d6mr1647yba.5.1688051804809; Thu, 29 Jun
 2023 08:16:44 -0700 (PDT)
Date:   Thu, 29 Jun 2023 08:16:43 -0700
In-Reply-To: <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com> <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
Message-ID: <ZJ2gW1gD9noko8H6@google.com>
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Binbin Wu wrote:
> On 6/28/2023 8:15 AM, Sean Christopherson wrote:
> > On Tue, Jun 06, 2023, Binbin Wu wrote:
> > Use the perfectly good helper added earlier in the series:
> >=20
> > 		cr3_lam =3D kvm_get_active_lam_bits();
> Good suggestion. Thanks.
>=20
> >=20
> > That has the added bonus of avoiding a VMREAD of CR3 when LAM is disabl=
ed in CR4.
> Why? I don't get the point.

Sorry, typo on my end.  When LAM is disabled in guest CPUID, not CR4.

> > > +void vmx_untag_addr(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags)
> > Rather than modify the pointer, return the untagged address.  That's mo=
re flexible
> > as it allows using the result in if-statements and whatnot.  That might=
 not ever
> > come into play, but there's no good reason to use an in/out param in a =
void
> > function.
> In earlier version, it did return the untagged address.
> In this version, I changed it as an in/out param to make the interface
> conditional and avoid to add a dummy one in SVM.
> Is it can be a reason?

Hmm, no.  You can achieve the same by doing:

	struct kvm_vcpu *vcpu =3D emul_to_vcpu(ctxt);

	if (!kvm_x86_ops.get_untagged_addr)
		return addr;

	return static_call(kvm_x86_get_untagged_addr)(vcpu, addr, flags);

> > gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
> > 			    unsigned int flags)
> > {
> > 	unsigned long cr3_bits, cr4_bits;
> > 	int lam_bit;
> >=20
> > 	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH_INVLPG | X86EMUL_F_IMP=
LICIT))
> Thanks for the suggestion. Overall, it looks good to me.
>=20
> Suppose "X86EMUL_F_BRANCH_INVLPG "=C2=A0 should be two flags for branch a=
nd
> invlpg, right=EF=BC=9F

Yeah, typo again.  Should just be X86EMUL_F_INVLPG, because unlike LASS, LA=
M
ignores all FETCH types.

> And for LAM, X86EMUL_F_IMPLICIT will not be used because in the implicit
> access to memory management registers or descriptors,
> the linear base addresses still need to be canonical and no hooks will be
> added to untag the addresses in these pathes.
> So I probably will remove the check for X86EMUL_F_IMPLICIT here.

No, please keep it, e.g. so that changes in the emulator don't lead to brea=
kage,
and to document that they are exempt.

If you want, you could do WARN_ON_ONCE() for the IMPLICIT case, but I don't=
 know
that that's worthwhile, e.g. nothing will go wrong if KVM tries to untag an
implicit access, and deliberately avoiding the call make make it annoying t=
o
consolidate code in the future.
