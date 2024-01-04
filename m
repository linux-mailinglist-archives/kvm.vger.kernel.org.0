Return-Path: <kvm+bounces-5613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E439823B2A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 04:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 867661F26068
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C978CD297;
	Thu,  4 Jan 2024 03:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BImaPWoC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6948A5226
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 03:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so3964a12.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 19:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704339614; x=1704944414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yf6KVWHh5HVTEFcktH0c2TfJ+tqBshOevQ3WwZHVLcs=;
        b=BImaPWoCdudp7kKAw0+O9fxmRS1Qfh1LNem7lUnx63jCuKWYvU7XlDgrQvBq8nrmOZ
         XLzTI5Q8FsE+XsBJACN4K9N7Fp3masbfey8nfuBf23URqUZiFD8k12XW4IrkfeKjCd/b
         DeXTF6nYy3ZBlMI0CeJ+F20nqmplZN9ebn9ibwFcZWPBs2rFKGrNiHHabmUx4GaJR7r6
         Emu+nulhDsxcZDTf4ZAS/kTC4MATaplBVLuqEJcjWnkWmfnOIogbEu3MEWi5gtfu4Tkp
         QU20eHbIjNbEQGabDneFOgsCAlWH/2kc6I6syYW4Q6SYG1+jzI+OyfmWHVkCfInFUEBC
         58/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704339614; x=1704944414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yf6KVWHh5HVTEFcktH0c2TfJ+tqBshOevQ3WwZHVLcs=;
        b=Jp9KrYExdVkdnPcrG6kzSYM97unt2c3BtSESieeKTc9uHo9jCieEXE0NwZSHlzztNQ
         ny3goaAhCfZuyS93JApDgHHACV0ORBWa2FN4sy6YZShMkRJmnibHYMAKeLCkZJK8FY+X
         yKvXeLYcn0bGWaABPEYYuZItnUi4qphpUhi+eiQjMHMfUbOSn0fG4D7On0s4bTiZR7kE
         0mCTbzciu4DoJnhaWTmX84Kmvh3rfkceqAGo4YbpTREEuVs4w8rJFfjibBOMPRAiHsXp
         zxrlrLHV+j4rSRP9ijfsr8WsGYMv3QzP0NODIJIIsIBXYN+0aBc5Y53xBo3yQgmXwT0a
         A4HQ==
X-Gm-Message-State: AOJu0YxcemvAjTNjQEjUyuRIbJKXm6vVlJXdUy0kwNfIZ31Qiv08I8za
	ZEiiRWEyrX79E4j19C4iqUnY6sCuQG/e0xMJiHJtYGdLWVEnS5I65LaCS1H5hA==
X-Google-Smtp-Source: AGHT+IH7u4n/mf2sWMe1BWD41Zws7dp9RLBxSNvwnRzYPzQmHw3kWG63pCUd9c77DKuwG+y1NNfnQuwBejFwZ+lCvlU=
X-Received: by 2002:a50:9e6c:0:b0:553:b7c6:1e47 with SMTP id
 z99-20020a509e6c000000b00553b7c61e47mr302159ede.2.1704339614509; Wed, 03 Jan
 2024 19:40:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050> <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com> <ZZYbzzDxPI8gjPu8@chao-email>
In-Reply-To: <ZZYbzzDxPI8gjPu8@chao-email>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 3 Jan 2024 19:40:02 -0800
Message-ID: <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote:
>
> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> >On Tue, Jan 02, 2024, Jim Mattson wrote:
> >> On Tue, Jan 2, 2024 at 3:24=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> >> >
> >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrot=
e:
> >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> > > > > index c57e181bba21..72634d6b61b2 100644
> >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits=
(struct kvm_vcpu *vcpu,
> >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> >> > > > >  }
> >> > > > >
> >> > > > > +/* guest-physical-address bits limited by TDP */
> >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> >> > > > > +{
> >> > > > > + return max_tdp_level =3D=3D 5 ? 57 : 48;
> >> > > >
> >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> >> > > >
> >> > > >   Bits 56:52 of each guest-physical address are necessarily zero=
 because
> >> > > >   guest-physical addresses are architecturally limited to 52 bit=
s.
> >> > > >
> >> > > > Rather than split hairs over something that doesn't matter, I th=
ink it makes sense
> >> > > > for the CPUID code to consume max_tdp_level directly (I forgot t=
hat max_tdp_level
> >> > > > is still accurate when tdp_root_level is non-zero).
> >> > >
> >> > > It is still accurate for now. Only AMD SVM sets tdp_root_level the=
 same as
> >> > > max_tdp_level:
> >> > >
> >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> >> > >                         get_npt_level(), PG_LEVEL_1G);
> >> > >
> >> > > But I wanna doulbe confirm if directly using max_tdp_level is full=
y
> >> > > considered.  In your last proposal, it is:
> >> > >
> >> > >   u8 kvm_mmu_get_max_tdp_level(void)
> >> > >   {
> >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> >> > >   }
> >> > >
> >> > > and I think it makes more sense, because EPT setup follows the sam=
e
> >> > > rule.  If any future architechture sets tdp_root_level smaller tha=
n
> >> > > max_tdp_level, the issue will happen again.
> >> >
> >> > Setting tdp_root_level !=3D max_tdp_level would be a blatant bug.  m=
ax_tdp_level
> >> > really means "max possible TDP level KVM can use".  If an exact TDP =
level is being
> >> > forced by tdp_root_level, then by definition it's also the max TDP l=
evel, because
> >> > it's the _only_ TDP level KVM supports.
> >>
> >> This is all just so broken and wrong. The only guest.MAXPHYADDR that
> >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
> >> every #PF,
>
> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supports =
only
> 4-level EPT), KVM has no need to intercept #PF because accessing a GPA wi=
th
> RSVD bits 51-48 set leads to EPT violation.

At the completion of the page table walk, if there is a permission
fault, the data address should not be accessed, so there should not be
an EPT violation. Remember Meltdown?

> >> and to emulate the faulting instruction to see if the RSVD
> >> bit should be set in the error code. Hardware isn't going to do it.
>
> Note for EPT violation VM exits, the CPU stores the GPA that caused this =
exit
> in "guest-physical address" field of VMCS. so, it is not necessary to emu=
late
> the faulting instruction to determine if any RSVD bit is set.

There should not be an EPT violation in the case discussed.

> >> Since some page faults may occur in CPL3, this means that KVM has to
> >> be prepared to emulate any memory-accessing instruction. That's not
> >> practical.
>
> as said above, no need to intercept #PF for this specific case.

I disagree. See above.

