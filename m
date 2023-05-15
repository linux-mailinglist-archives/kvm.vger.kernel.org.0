Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9135703A81
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244905AbjEORvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240776AbjEORvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:51:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865BA1CA77
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:49:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24e147c206eso6922975a91.0
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684172962; x=1686764962;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUXfDVEOZN73+1c0jBwpYDx4Lp9671FBUhLy9esSzws=;
        b=2Y4rqA63ePB40J0RrmyaWoCdNET9IDC+RHvWceFj1vN24maTmC33yhQ4BU4vewfnQA
         LTt6YayFFTypg3qgR3xkilYk9L86yIhtH5I+IeWy2FI6XCP3mF3TSUtVDxjYKXnh0NmZ
         u1FJ/QVMLyxnNPBqTDobD184UJP5ldnhCwimpb52+0BsoUP0iOi15PQte4j49pYFOAeR
         0YTS6The5SJhq7gAt/OmDCuGfIdrsBcMdMJfZwL2C1hi7vG+f0D4URgeCcGFK06HqBrB
         bFgh8WbxAdjdGwApYLmm5wfTKXDQn8TDgZ8h9kwx3bG8rGb3sdYrDFe+w7UOxfRy5seu
         w4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684172962; x=1686764962;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YUXfDVEOZN73+1c0jBwpYDx4Lp9671FBUhLy9esSzws=;
        b=fsavwbrYAw4iek73t6+HgoK7+buVgCbqgiLXuBtd/DHzSPmOMsPMcLZX1U90m+ASQi
         r6hJP4z6onBwoKVwSh4DHRVv0LaYgHR+sNMUu+KDS5PPZrJPBuC369YRGhr26eiQYGH5
         pYBAlBw+uexudVj1OzbvxvtSChoabqsimsSpH7BeDCJjNSGKb+zA2sWWxKgA0GQ8XS8U
         MkCB1+QYiHpldSmOC9Uw46c7URgARPiC46Cxh9RMIqxU2uIzpQrTk1BDt3mSWywncfXc
         OPj0bfY9yoWkVLef0+I8YuYPwmeYq37mlBNbTNEvdK8RuhPeN95aaP4sICXYIi7WRBwv
         eSAA==
X-Gm-Message-State: AC+VfDwo7ACUzIVvYvMytfu0kLICzDhxKvGxibPgc6jzFbkhHTC9cM6e
        gPT6tqdLJzjBYQG2/JjvaRRKQdmFq94=
X-Google-Smtp-Source: ACHHUZ7TaBfG344HLW8kEXFgjWe9h2Wo72d14XZZmcYXeo7U23yXiv4bhyvVuzgqLKu5xrzUYSrF2nzPUaY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c595:b0:250:aae3:4668 with SMTP id
 l21-20020a17090ac59500b00250aae34668mr6270721pjt.1.1684172961756; Mon, 15 May
 2023 10:49:21 -0700 (PDT)
Date:   Mon, 15 May 2023 10:49:20 -0700
In-Reply-To: <7972883f69abe6fe61a2e76def6a0a1f1f28228b.camel@intel.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com> <20230511233351.635053-6-seanjc@google.com>
 <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
 <ZF5qnQQYa6OAI0Hy@google.com> <7972883f69abe6fe61a2e76def6a0a1f1f28228b.camel@intel.com>
Message-ID: <ZGJwoFCWVWMSX5c3@google.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="iso-8859-1"
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

On Mon, May 15, 2023, Kai Huang wrote:
> On Fri, 2023-05-12 at 09:35 -0700, Sean Christopherson wrote:
> > On Fri, May 12, 2023, Kai Huang wrote:
> > > On Thu, 2023-05-11 at 16:33 -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index e7f78fe79b32..8b356c9d8a81 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3700,8 +3700,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
> > > >  			return 1;
> > > >  		}
> > > >  		break;
> > > > -	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> > > > -	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
> > > > +	case MSR_IA32_CR_PAT:
> > > > +	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
> > > > +	case MSR_MTRRdefType:
> > > >  		return kvm_mtrr_set_msr(vcpu, msr, data);
> > > >  	case MSR_IA32_APICBASE:
> > > >  		return kvm_set_apic_base(vcpu, msr_info);
> > > > @@ -4108,9 +4109,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu=
, struct msr_data *msr_info)
> > > >  		msr_info->data =3D kvm_scale_tsc(rdtsc(), ratio) + offset;
> > > >  		break;
> > > >  	}
> > > > +	case MSR_IA32_CR_PAT:
> > > >  	case MSR_MTRRcap:
> > >=20
> > > ... Should we put MSR_IA32_CR_PAT after MSR_MTRRcap so it can be symm=
etric to
> > > kvm_set_msr_common()?
> > >=20
> > > Looks there's no reason to put it before MSR_MTRRcap.
> >=20
> > No, it's above MTRRcap for two reasons:
> >=20
> >  1. When PAT is moved out of mtrr.c, PAT doesn't get bunded with the ot=
her MTRRs
> >     and so would just need to be hoisted back up.  The end code looks l=
ike:
> >=20
> > 	case MSR_IA32_CR_PAT:
> > 		msr_info->data =3D vcpu->arch.pat;
> > 		break;
> > 	case MSR_MTRRcap:
> > 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
> > 	case MSR_MTRRdefType:
> > 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
>=20
> Sorry I mistakenly thought MSR_MTRRcap wasn't handled in kvm_mtrr_get_msr=
().=20
> Yes looks good to me.
>=20
> > =20
> >  2. There is no MSR_MTRRcap case statement in kvm_set_msr_common() beca=
use it's
> >     a read-only MSR, i.e. the two can't be symmetric :-)
>=20
> Do you know why it is a read-only MSR, which enables both FIXED ranges an=
d
> (fixed number of) dynamic ranges?

MTTRcap doesn't "enable" anything, it's a capabilities MSR (MTRR Capability=
 is
its given name in the SDM), similar to ARCH_CAPABILITIES, PERF_CAPABILITIES=
, etc.
They're all essentially CPUID leafs, but presumably are MSRs due to being r=
elevant
only to CPL0.  Or maybe some higher ups at Intel just spin a wheel to deter=
mine
whether to use a CPUID leaf or an MSR.  :-)

> I am asking because there's a x86 series to fake a simple synthetic MTRR =
which
> neither has fixed nor dynamic ranges but only has a default MSR_MTRRdefTy=
pe:
>=20
> https://lore.kernel.org/lkml/20230509233641.GGZFrZCTDH7VwUMp5R@fat_crate.=
local/T/
>=20
> The main use cases are Xen PV guests and SEV-SNP guests running under
> Hyper-V, but it appears TDX guest is also desired to have similar handlin=
g,
> because:=EF=BF=BD
>=20
> 1) TDX module exposes MTRR in CPUID to guest, but handles nothing about M=
TRR
> MSRs but only injects #VE.
>=20
> 2) TDX module always maps guest private memory as WB (and ignores guest's=
 PAT
> IIUC);
>=20
> 3) For shared memory, w/o non-coherent DMA guest's MTRRs are ignored by K=
VM
> anyway.  TDX doesn't officially support non-trusted device assignment AFA=
ICT.
> Even we want to consider non-coherent DMA, it would only add confusion to=
 honor
> guest's MTRRs since they can point to private memory, which is always map=
ped as
> WB.

Yeah, I think the best option is for KVM to disallow attaching non-coherent=
 DMA
to TDX VMs.  AFAIK, there's no use case for such a setup.

> So basically looks there's no value to exposing FIXED and dynamic MTRR ra=
nges to
> TDX guest.

Agreed.
