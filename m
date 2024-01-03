Return-Path: <kvm+bounces-5589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7CA823414
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 19:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70F38283575
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5711C1C687;
	Wed,  3 Jan 2024 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="39GfXxnT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456121C2AF
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d4b8ad631dso11711075ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 10:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704305083; x=1704909883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wL8IXXsYfFy26/UG/5cAxjeFGbj/mmT3i11QIPO0ET0=;
        b=39GfXxnT8rNQSqrAF+U0riMR6jNO3QCmb+SarwNCohTqRuq0WIpngSh/nggJL9iVaq
         ks+pyjeeeQIV1idN5HnqzLYLu+n4yEnwZWW7e5n3wlIlqyaldNv8s3hjnbaesG6UUTFN
         9wu5aCbd6EeboSNkWiGgy2e+Dpvn3Lnj3Jhb9EwrQ7AumGPau62de+WCJtO/2aBpJibK
         x/qiwdPDvemVbaWlQnGWoy82D5WGdhwCAaLcaFVR4Gn+ej5njhpfw3Tn2r0i7/BleIJs
         tvVRCC2X8p6UWq3jvKHTxc+1mbeagI1tcrM9z7tEkdSoEGDE4ciSY4ni9vug7EAtIvz1
         pOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704305083; x=1704909883;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wL8IXXsYfFy26/UG/5cAxjeFGbj/mmT3i11QIPO0ET0=;
        b=JWIJAGY2q65Mq2cDXjJ0uvN6tESOWoqpe8BFpE0z10cesr8qTX4w8p/EuA/iy/gy/h
         ph78ggznhoPdE7mCzM4nxNA539OmDMm0MHOvW3jySWh7dxm8Ch+J+SRTCBhctuhOUVR/
         AJaFNhvbb3pjqK4sQoW3LHRx69RbHWW83/P/txk8CIXC3sbCl/S5+BxNpJFCr0q1ASP4
         1ngGR91e1Bu/cI13OQU9sCgj5srZxjl/ikqHNms93R0260dYe78cuCw+enISranit4c9
         L7j54WtlUSymi+M+YGMTk17r0v3aypaNUc7S33WFIykcOyOL0kTZ4Ws8p35kPEu4QAOU
         qX0g==
X-Gm-Message-State: AOJu0Yw55nrr4SHF/JcJwy2JnW/d8LWnVlFF15J/g5ensxxt0cgXRVqs
	YCCv5iu2oO1fm3fM08wSb9p2i3E42XtvUrCr0A==
X-Google-Smtp-Source: AGHT+IHIUn9fRx3tLZTYr4r8MGhfPCkDNIuHBJL/1zF/JVaWcxJtLYy/YrQEqhVxIH8aIq6LWbNdD8PwOiA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e742:b0:1d4:de1:6b01 with SMTP id
 p2-20020a170902e74200b001d40de16b01mr608452plf.9.1704305083462; Wed, 03 Jan
 2024 10:04:43 -0800 (PST)
Date: Wed, 3 Jan 2024 10:04:41 -0800
In-Reply-To: <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050> <ZZSbLUGNNBDjDRMB@google.com> <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
Message-ID: <ZZWhuW_hfpwAAgzX@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, Tao Su <tao1.su@linux.intel.com>, 
	kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com, 
	chao.gao@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 02, 2024, Jim Mattson wrote:
> On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index c57e181bba21..72634d6b61b2 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(st=
ruct kvm_vcpu *vcpu,
> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> > > > >  }
> > > > >
> > > > > +/* guest-physical-address bits limited by TDP */
> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > > > > +{
> > > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> > > >
> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > > >
> > > >   Bits 56:52 of each guest-physical address are necessarily zero be=
cause
> > > >   guest-physical addresses are architecturally limited to 52 bits.
> > > >
> > > > Rather than split hairs over something that doesn't matter, I think=
 it makes sense
> > > > for the CPUID code to consume max_tdp_level directly (I forgot that=
 max_tdp_level
> > > > is still accurate when tdp_root_level is non-zero).
> > >
> > > It is still accurate for now. Only AMD SVM sets tdp_root_level the sa=
me as
> > > max_tdp_level:
> > >
> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> > >                         get_npt_level(), PG_LEVEL_1G);
> > >
> > > But I wanna doulbe confirm if directly using max_tdp_level is fully
> > > considered.  In your last proposal, it is:
> > >
> > >   u8 kvm_mmu_get_max_tdp_level(void)
> > >   {
> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> > >   }
> > >
> > > and I think it makes more sense, because EPT setup follows the same
> > > rule.  If any future architechture sets tdp_root_level smaller than
> > > max_tdp_level, the issue will happen again.
> >
> > Setting tdp_root_level !=3D max_tdp_level would be a blatant bug.  max_=
tdp_level
> > really means "max possible TDP level KVM can use".  If an exact TDP lev=
el is being
> > forced by tdp_root_level, then by definition it's also the max TDP leve=
l, because
> > it's the _only_ TDP level KVM supports.
>=20
> This is all just so broken and wrong. The only guest.MAXPHYADDR that
> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
> every #PF, and to emulate the faulting instruction to see if the RSVD
> bit should be set in the error code. Hardware isn't going to do it.
> Since some page faults may occur in CPL3, this means that KVM has to
> be prepared to emulate any memory-accessing instruction. That's not
> practical.
>=20
> Basically, a CPU with more than 48 bits of physical address that
> doesn't support 5-level EPT really doesn't support EPT at all, except
> perhaps in the context of some new paravirtual pinky-swear from the
> guest that it doesn't care about the RSVD bit in #PF error codes.

Doh, I managed to forget about the RSVD #PF mess.  That said, this patch wi=
ll
"work" if userspace enables allow_smaller_maxphyaddr.  In quotes because I'=
m still
skeptical that allow_smaller_maxphyaddr actually works in all scenarios.  A=
nd we'd
need a way to communicate all of that to userspace.  Blech.

