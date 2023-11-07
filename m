Return-Path: <kvm+bounces-1039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7453A7E47CF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5228B20EC4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CA73589E;
	Tue,  7 Nov 2023 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWwP9gE2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0733717F0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:05:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DACB125
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699380357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZWN7e/E9MLOuZ4Civj0SoRpxsYHcBxuGSdGcIP4Qsg=;
	b=hWwP9gE2v22MdpzVq26FdbiCsBPFMg1PmFemkLfXr9V+abf2sx0iYXBUQ93N0bnmACPKab
	TNQBOvh4fGtAid2I7q2P4nwpFgH4xLYO6omPi9bQeD8Yb1rIjPR4rM5vHi8aN3WNeGI1FV
	n3sZdJUVR+wfqc5ydkuekpjA+bu7uLc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-_vdWnheVMJ2gMF_dki36Fw-1; Tue, 07 Nov 2023 13:05:55 -0500
X-MC-Unique: _vdWnheVMJ2gMF_dki36Fw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4084001846eso39273115e9.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:05:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699380354; x=1699985154;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZWN7e/E9MLOuZ4Civj0SoRpxsYHcBxuGSdGcIP4Qsg=;
        b=KzK56SXMvvzm6Bh8+CB3nI9Mayd8+BRYoZFWhKWVstil9Yr1vatwLNzs6a6DJvlhr8
         5jrDJj/faQIulziZqhbn4ihKTp0fID/C2QwXUcuxk37hQTJ/QP0MUCXUqqiyPaZXURZD
         zW2RuPzcnlx5Gm5J0/9LMXGGiVKHFUzAgyQbcYWaTcfzFExqI/knagQTde5FeQ6lxU8d
         q6tpvL28GihvA6jmdHDUAw50gkwZULBPcVrjBWt0s/nraOTSUHZMeb1kokHvGM3N7Ybr
         scCefn4nGCuhLJJ+YMFik28wS0fcpReXPi8bvq68A+f4XWejJn8aZtnyYkUNmLT/XMbI
         Kyzw==
X-Gm-Message-State: AOJu0YwFgf95OacAFZm1fL9qnB90CXjMRbvQ2TCICV2NiGjCR0EdLq5h
	vSL3z0hK5sUqvutgrJUG9o0eDTi3bgqrg8qRzpusSV+/jC/me2zmYPM4B8p0AZUverZ/s6kfaYn
	5j6pSAzWzKmrS
X-Received: by 2002:a05:600c:1c24:b0:409:6e0e:e948 with SMTP id j36-20020a05600c1c2400b004096e0ee948mr3090690wms.1.1699380353888;
        Tue, 07 Nov 2023 10:05:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVbUnIMkGEN1RZAQbj4aBP3/Gu/RlHkG0yjlsbbGdC2xv6pzcnYLvZlX7eGdsqZsIc/nN+6Q==
X-Received: by 2002:a05:600c:1c24:b0:409:6e0e:e948 with SMTP id j36-20020a05600c1c2400b004096e0ee948mr3090674wms.1.1699380353435;
        Tue, 07 Nov 2023 10:05:53 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id p29-20020a05600c1d9d00b0040772934b12sm16875455wms.7.2023.11.07.10.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:05:53 -0800 (PST)
Message-ID: <d0df418154b18204ee6130a8e077f2d0c1c65c2f.camel@redhat.com>
Subject: Re: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework
 to track "SHSTK/IBT enabled"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Tue, 07 Nov 2023 20:05:51 +0200
In-Reply-To: <ZUWLUs3J-G_5VCx_@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-19-weijiang.yang@intel.com>
	 <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
	 <ZUJy7A5Hp6lnZVyq@google.com>
	 <73c4d3d4c4e7b631d5604178a127bf20cc122034.camel@redhat.com>
	 <ZUWLUs3J-G_5VCx_@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-03 at 17:07 -0700, Sean Christopherson wrote:
> On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > On Wed, 2023-11-01 at 08:46 -0700, Sean Christopherson wrote:
> > > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > > > Use the governed feature framework to track whether X86_FEATURE_SHSTK
> > > > > and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> > > > > the features can be used iff both KVM and guest CPUID can support them.
> > > > PS: IMHO The whole 'governed feature framework' is very confusing and
> > > > somewhat poorly documented.
> > > > 
> > > > Currently the only partial explanation of it, is at 'governed_features',
> > > > which doesn't explain how to use it.
> > > 
> > > To be honest, terrible name aside, I thought kvm_governed_feature_check_and_set()
> > > would be fairly self-explanatory, at least relative to all the other CPUID handling
> > > in KVM.
> > 
> > What is not self-explanatory is what are the governed_feature and how to query them.
> 
> ...
> 
> > > > However thinking again about the whole thing: 
> > > > 
> > > > IMHO the 'governed features' is another quite confusing term that a KVM
> > > > developer will need to learn and keep in memory.
> > > 
> > > I 100% agree, but I explicitly called out the terrible name in the v1 and v2
> > > cover letters[1][2], and the patches were on the list for 6 months before I
> > > applied them.  I'm definitely still open to a better name, but I'm also not
> > > exactly chomping at the bit to get behind the bikehsed.
> > 
> > Honestly I don't know if I can come up with a better name either.  Name is
> > IMHO not the underlying problem, its the feature itself that is confusing.
> 
> ...
> 
> > > Yes and no.  For "governed features", probably not.  But for CPUID as a whole, there
> > > are legimiate cases where userspace needs to enumerate things that aren't officially
> > > "supported" by KVM.  E.g. topology, core crystal frequency (CPUID 0x15), defeatures
> > > that KVM hasn't yet learned about, features that don't have virtualization controls
> > > and KVM hasn't yet learned about, etc.  And for things like Xen and Hyper-V paravirt
> > > features, it's very doable to implement features that are enumerate by CPUID fully
> > > in userspace, e.g. using MSR filters.
> > > 
> > > But again, it's a moot point because KVM has (mostly) allowed userspace to fully
> > > control guest CPUID for a very long time.
> > > 
> > > > Such a feature which is advertised as supported but not really working is a
> > > > recipe of hard to find guest bugs IMHO.
> > > > 
> > > > IMHO it would be much better to just check this condition and do
> > > > kvm_vm_bugged() or something in case when a feature is enabled in the guest
> > > > CPUID but KVM can't support it, and then just use guest CPUID in
> > > > 'guest_can_use()'.
> > 
> > OK, I won't argue that much over this, however I still think that there are
> > better ways to deal with it.
> > 
> > If we put optimizations aside (all of this can surely be optimized such as to
> > have very little overhead)
> > 
> > How about we have 2 cpuids: Guest visible CPUID which KVM will never use directly
> > other than during initialization and effective cpuid which is roughly
> > what governed features are, but will include all features and will be initialized
> > roughly like governed features are initialized:
> > 
> > effective_cpuid = guest_cpuid & kvm_supported_cpuid 
> > 
> > Except for some forced overrides like for XSAVES and such.
> > 
> > Then we won't need to maintain a list of governed features, and guest_can_use()
> > for all features will just return the effective cpuid leafs.
> > 
> > In other words, I want KVM to turn all known CPUID features to governed features,
> > and then remove all the mentions of governed features except 'guest_can_use'
> > which is a good API.
> > 
> > Such proposal will use a bit more memory but will make it easier for future
> > KVM developers to understand the code and have less chance of introducing bugs.
> 
> Hmm, two _full_ CPUID arrays would be a mess and completely unnecessary.  E.g.
> we'd have to sort out Hyper-V and KVM PV, which both have their own caches.  And
> a duplicate entry for things like F/M/S would be ridiculous.
> 
> But maintaining a per-vCPU version of the CPU caps is definitely doable.  I.e. a
> vCPU equivalent to kvm_cpu_caps and the per-CPU capabilities.  There are currently
> 25 leafs that are tracked by kvm_cpu_caps, so relative to "governed" features,
> the cost will be 96 bytes per vCPU.  I agree that 96 bytes is worth eating, we've
> certainly taken on more for a lot, lot less.
> 
> It's a lot of churn, and there are some subtle nasties, e.g. MWAIT and other
> CPUID bits that changed based on MSRs or CR4, but most of the churn is superficial
> and the result is waaaaay less ugly than governed features and for the majority of
> features will Just Work.
> 
> I'll get a series posted next week (need to write changelogs and do a _lot_ more
> testing).  If you want to take a peek at where I'm headed before then:
> 
>   https://github.com/sean-jc/linux x86/guest_cpufeatures

This looks very good, looking forward to see the patches on the mailing list.

Best regards,
	Maxim Levitsky

> 



