Return-Path: <kvm+bounces-568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D82317E0C9B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FB8C282025
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EC8623;
	Sat,  4 Nov 2023 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Bw+1wvB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB4F163
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:07:50 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEC3E0
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:07:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7cc433782so34715187b3.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056468; x=1699661268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7pCmBk/d8/7BmVgL/y39uEDYRNT0sESO20FlC/h78mQ=;
        b=3Bw+1wvBB502igmVg9vShkrkTyS/4dAuVY/RhuSDUxqcUBP9N6qsgjtn83Curc87fu
         sK+iaqEqvyWyBnzKNs1iBZrHJJxl1BL4tMTlsl7uB6yfBKlg/BACoFhivpO+sJXVV5Qz
         koUazJOEN1AxcuZFQgARXSlfplq95NH7Qhutwov47gvLJLlVlCWb7NOe2giT1kNUQmFw
         GbUlU82fSpshwQAUWfCatTKMS2a6+oHG6qrLgxgshFXbMx96r7mMIwjLErSV+SCYLaBa
         od9OcYXmOskmqn6oPVSQBhv3l9w79BBckDLu1yJKyBFfCRfpSM6vdek9tQjr25GgtuDJ
         Qe1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056468; x=1699661268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7pCmBk/d8/7BmVgL/y39uEDYRNT0sESO20FlC/h78mQ=;
        b=DTOjZK/i9DlnbOMrGwvLOaUaqGXN4Of7Kp2mw0K1iduQzZsn2q6Zj+GnfzJu3YuSZe
         Nd1YiVFmD5uUcVmpACQxZi6WAPucN38NvKFT4q5IAZWU70dkLUsXJqGg0QE2MNE+Gt1U
         lq/DhbWMDg7tXkYQx7yqziYGB71fKsTE7uknPJL2wkklGQaeNm3cIyoSBZwrSAFGJg9Y
         VKWXUvkonnuRvtnF5lvW7KCGZFRNfhh1tSDUK979hRPt6DAioFxNaQ8FK3yFTLauNG8h
         y4og2t+Ko0gXa6azPq+R3DVKJ8qxvlGFEfqUeYkFxAaPNawhGxTxGVM0aoE37OdkNpbP
         QiJA==
X-Gm-Message-State: AOJu0YypggIPAxRz5Yk7NVNKPXL8XibxRBF3vGNtKFuenHMQ1nDxbaX3
	htwGZgGJIfnV9qt/IIvIBAyqCOwssto=
X-Google-Smtp-Source: AGHT+IHrFg0i8c+upGstRkCOtYCLhKbcNDwrwPljNf59tCzhF8790qymO/HYfk6E37nQq71VNARXcw7+prY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d6d6:0:b0:5a7:f68c:8d1 with SMTP id
 y205-20020a0dd6d6000000b005a7f68c08d1mr91440ywd.10.1699056468054; Fri, 03 Nov
 2023 17:07:48 -0700 (PDT)
Date: Fri, 3 Nov 2023 17:07:46 -0700
In-Reply-To: <73c4d3d4c4e7b631d5604178a127bf20cc122034.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-19-weijiang.yang@intel.com> <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
 <ZUJy7A5Hp6lnZVyq@google.com> <73c4d3d4c4e7b631d5604178a127bf20cc122034.camel@redhat.com>
Message-ID: <ZUWLUs3J-G_5VCx_@google.com>
Subject: Re: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework to
 track "SHSTK/IBT enabled"
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> On Wed, 2023-11-01 at 08:46 -0700, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > > Use the governed feature framework to track whether X86_FEATURE_SHSTK
> > > > and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> > > > the features can be used iff both KVM and guest CPUID can support them.
> > > PS: IMHO The whole 'governed feature framework' is very confusing and
> > > somewhat poorly documented.
> > > 
> > > Currently the only partial explanation of it, is at 'governed_features',
> > > which doesn't explain how to use it.
> > 
> > To be honest, terrible name aside, I thought kvm_governed_feature_check_and_set()
> > would be fairly self-explanatory, at least relative to all the other CPUID handling
> > in KVM.
> 
> What is not self-explanatory is what are the governed_feature and how to query them.

...

> > > However thinking again about the whole thing: 
> > > 
> > > IMHO the 'governed features' is another quite confusing term that a KVM
> > > developer will need to learn and keep in memory.
> > 
> > I 100% agree, but I explicitly called out the terrible name in the v1 and v2
> > cover letters[1][2], and the patches were on the list for 6 months before I
> > applied them.  I'm definitely still open to a better name, but I'm also not
> > exactly chomping at the bit to get behind the bikehsed.
> 
> Honestly I don't know if I can come up with a better name either.  Name is
> IMHO not the underlying problem, its the feature itself that is confusing.

...

> > Yes and no.  For "governed features", probably not.  But for CPUID as a whole, there
> > are legimiate cases where userspace needs to enumerate things that aren't officially
> > "supported" by KVM.  E.g. topology, core crystal frequency (CPUID 0x15), defeatures
> > that KVM hasn't yet learned about, features that don't have virtualization controls
> > and KVM hasn't yet learned about, etc.  And for things like Xen and Hyper-V paravirt
> > features, it's very doable to implement features that are enumerate by CPUID fully
> > in userspace, e.g. using MSR filters.
> > 
> > But again, it's a moot point because KVM has (mostly) allowed userspace to fully
> > control guest CPUID for a very long time.
> > 
> > > Such a feature which is advertised as supported but not really working is a
> > > recipe of hard to find guest bugs IMHO.
> > > 
> > > IMHO it would be much better to just check this condition and do
> > > kvm_vm_bugged() or something in case when a feature is enabled in the guest
> > > CPUID but KVM can't support it, and then just use guest CPUID in
> > > 'guest_can_use()'.
> 
> OK, I won't argue that much over this, however I still think that there are
> better ways to deal with it.
> 
> If we put optimizations aside (all of this can surely be optimized such as to
> have very little overhead)
> 
> How about we have 2 cpuids: Guest visible CPUID which KVM will never use directly
> other than during initialization and effective cpuid which is roughly
> what governed features are, but will include all features and will be initialized
> roughly like governed features are initialized:
> 
> effective_cpuid = guest_cpuid & kvm_supported_cpuid 
> 
> Except for some forced overrides like for XSAVES and such.
> 
> Then we won't need to maintain a list of governed features, and guest_can_use()
> for all features will just return the effective cpuid leafs.
> 
> In other words, I want KVM to turn all known CPUID features to governed features,
> and then remove all the mentions of governed features except 'guest_can_use'
> which is a good API.
> 
> Such proposal will use a bit more memory but will make it easier for future
> KVM developers to understand the code and have less chance of introducing bugs.

Hmm, two _full_ CPUID arrays would be a mess and completely unnecessary.  E.g.
we'd have to sort out Hyper-V and KVM PV, which both have their own caches.  And
a duplicate entry for things like F/M/S would be ridiculous.

But maintaining a per-vCPU version of the CPU caps is definitely doable.  I.e. a
vCPU equivalent to kvm_cpu_caps and the per-CPU capabilities.  There are currently
25 leafs that are tracked by kvm_cpu_caps, so relative to "governed" features,
the cost will be 96 bytes per vCPU.  I agree that 96 bytes is worth eating, we've
certainly taken on more for a lot, lot less.

It's a lot of churn, and there are some subtle nasties, e.g. MWAIT and other
CPUID bits that changed based on MSRs or CR4, but most of the churn is superficial
and the result is waaaaay less ugly than governed features and for the majority of
features will Just Work.

I'll get a series posted next week (need to write changelogs and do a _lot_ more
testing).  If you want to take a peek at where I'm headed before then:

  https://github.com/sean-jc/linux x86/guest_cpufeatures

