Return-Path: <kvm+bounces-408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A997DF712
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC1E1C20F9B
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC121D559;
	Thu,  2 Nov 2023 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RN0UVusd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A931D523
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 15:52:14 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BF519A
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 08:51:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc591d8177so8983755ad.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698940317; x=1699545117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n3KS4TORQ08dXaJsqxd4Pb+jR6Q6AdhcH6h0cpJ7xRs=;
        b=RN0UVusdj7tpK4hQeFYbhvaU4omd5amSOlKVxzal4e/nLCstlMRgxT8KS/lWr65n+r
         6KNMcJ1uKXesH49i3odou+YkBwJ/tIhElW36o05O1Ng3MGOW1zTOynUX0OWlSK9iMlHj
         OJMx4TYtkPZdEEKgufM2y157tcR2VvjSNNRsDidCaRHU/7AGqt2eLsOIb0GjDh4h5UkI
         d3xSLnn7aKg34XyKrRvm0qT7UzZTcqDYj4o2l8TTa90NNHoGCdJWPnuATWPv334jHVIS
         in4oABR4fLBPKErRzF5sU0/Cy34MuQs7nc5sUT00ipFmdSGxD/NyK8sttyJUHhWQTYBy
         +O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698940317; x=1699545117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n3KS4TORQ08dXaJsqxd4Pb+jR6Q6AdhcH6h0cpJ7xRs=;
        b=Z5npASLYfRRE2g/q9pfaeCF/hnapBJNQ12NrNMqUQSg4XFeA05kz75IoNFBmwpyeRc
         5WwpCM1+KsXZ5SvS6a9OQ8jqcexg1JB1j7XY80pSt3AWmRo1ElZpyYxfhMUllL6JgEYA
         uiT7/emI02iXpp1dHVgN0O6bFO0/ZYvJKwBlxIBBxskE8crcnloiDpQE6YzYK7WOV8sa
         0qrr2tgGuiJWVrNv7mCtAU+zufHem4kZsyRjWebR/ymCePa6DeZENqn2J34zNaIjZTx/
         x4b7FOO93W36UrJPmdZjxFLkvp0p1qQHCNRbuvelu9VEC8RY0e53d7A/Eta+h4lS06Ya
         I4gw==
X-Gm-Message-State: AOJu0YwSzXBV7RR8v5xck/3PBsDnGIi/iMVHtjWN4IVduVJ85+hgYuqA
	1jhDJDmOQlEwTN85MomDGDQTesLowGU=
X-Google-Smtp-Source: AGHT+IFDcwl4s8UdqmTM5rWncqnvjP5M1c0a+jaZEj3IxvzEAcY13jClAPWsClQownnFGH/6j2HG46oUm7Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:efd1:b0:1c6:2b9d:570b with SMTP id
 ja17-20020a170902efd100b001c62b9d570bmr344133plb.7.1698940317130; Thu, 02 Nov
 2023 08:51:57 -0700 (PDT)
Date: Thu, 2 Nov 2023 08:51:55 -0700
In-Reply-To: <33686031-c1df-4ef5-a6ac-1aab7f5c656e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-10-seanjc@google.com>
 <482bfea6f54ea1bb7d1ad75e03541d0ba0e5be6f.camel@intel.com>
 <ZUKMsOdg3N9wmEzy@google.com> <33686031-c1df-4ef5-a6ac-1aab7f5c656e@intel.com>
Message-ID: <ZUPFmwWjPFlXRlPi@google.com>
Subject: Re: [PATCH v13 09/35] KVM: Add KVM_EXIT_MEMORY_FAULT exit to report
 faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "willy@infradead.org" <willy@infradead.org>, 
	"anup@brainfault.org" <anup@brainfault.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "mic@digikod.net" <mic@digikod.net>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "david@redhat.com" <david@redhat.com>, 
	"tabba@google.com" <tabba@google.com>, "amoorthy@google.com" <amoorthy@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, Yilun Xu <yilun.xu@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Xiaoyao Li wrote:
> On 11/2/2023 1:36 AM, Sean Christopherson wrote:
> > > KVM_CAP_MEMORY_FAULT_INFO is x86 only, is it better to put this function to
> > > <asm/kvm_host.h>?
> > I'd prefer to keep it in generic code, as it's highly likely to end up there
> > sooner than later.  There's a known use case for ARM (exit to userspace on missing
> > userspace mapping[*]), and I'm guessing pKVM (also ARM) will also utilize this API.
> > 
> > [*]https://lore.kernel.org/all/20230908222905.1321305-8-amoorthy@google.com
> 
> I wonder how this CAP is supposed to be checked in userspace, for guest
> memfd case? 

It's basically useless for guest_memfd.

> 	if (!kvm_check_extension(s, KVM_CAP_MEMORY_FAULT_INFO) &&
> 	    run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> 		abort("unexpected KVM_EXIT_MEMORY_FAULT");
> 
> In my implementation of QEMU patches, I find it's unnecessary. When
> userspace gets an exit with KVM_EXIT_MEMORY_FAULT, it implies
> "KVM_CAP_MEMORY_FAULT_INFO".
> 
> So I don't see how it is necessary in this series. Whether it's necessary or
> not for [*], I don't have the answer but we can leave the discussion to that
> patch series.

It's not strictly necessary there either.

However, Oliver felt (and presumably still feels) quite strongly, and I agree,
that neither reporting extra information shouldn't be tightly coupled to
KVM_CAP_EXIT_ON_MISSING or KVM_CAP_GUEST_MEMFD.

E.g. if userspace develops a "standalone" use case for KVM_CAP_MEMORY_FAULT_INFO,
userspace should be able to check for support without having to take a dependency
on KVM_CAP_GUEST_MEMFD, especially since because KVM_CAP_GUEST_MEMFD may not be
supported, i.e. userspace should be able to do:

	if (!kvm_check_extension(s, KVM_CAP_MEMORY_FAULT_INFO))
		abort("KVM_CAP_MEMORY_FAULT_INFO required for fancy feature XYZ");



