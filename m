Return-Path: <kvm+bounces-3155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D283801232
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DF601C20A5F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7464EB49;
	Fri,  1 Dec 2023 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f2JAaNoB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41DEE6
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 10:05:06 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6cdd6205e41so3254068b3a.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 10:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701453906; x=1702058706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ID46ENj/Fh/G8RRDa+k3Uoj4bQwAKEF1/ejHex8ImUI=;
        b=f2JAaNoBANES0kjwO1ObALyR0hinKMFqm2Mhn34gLXKWCQsr7zxFhMWjIJdya514+/
         iYD+0oawOgwuriRK91nVt0PnPLsqImiOVT9ULQZKp3ihz1Prgj7yioV6/gvL3IzxbJeC
         DuPQIW7Gpo+G9lR8CT3T90/rOoeRDrstW5jMUI7RU5pCsrPFY2uqhT7T9viThkC7gxrg
         rD6BFR/mUmVI4wZAPjsy+Att/g1fGrLdufTnsWZ9rvxTLW+BzwUhpzQthSCrAawACjF6
         Bg9RcYv4+GjInUHDVHmqslRv7S0yAkxYGenM+nZWY1kqKPNYpw0/4QVFwPbZLe+XZOMt
         b7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701453906; x=1702058706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ID46ENj/Fh/G8RRDa+k3Uoj4bQwAKEF1/ejHex8ImUI=;
        b=sf/q15mQaV1xPWnR263uDiaC3msHPAdG+/QpOcfnvJdwr1BPo1HCw2s4RU23tZ8oJd
         fdyVmfJPm2omfOltj5E+WubDL5wqqzvoRdmaOMCDTc7DtQaDYAd6QnZOnpyYMDJ8U7Ls
         UrJeRjZ2RFsYz5VTnh6hXu9v8Ju/2UFh/EZWK/xc/cZEjIbCeeaQi0BWZHGt/586yKVw
         1Zf+fj18jiuC+Z3OwkxX0Bqmwyi7SvgZrvHifNFSQwvC8SX9fTMjS9xyNZZ3rxwh5mGu
         mteYja5oNSmc+5IXuG+oJ3egwyKxq8BQQ5dvgNyL78AKJhiOjRKjHXPuZIKa0u66nsgI
         g2IQ==
X-Gm-Message-State: AOJu0YzAIApLJ3HFQvwFlJTbsvbIrBdswLi8e13drfaLUwfmqEfHZfbA
	10mx8XZl3oNcY6fI4luKC8SpLRH/XUk=
X-Google-Smtp-Source: AGHT+IHXIhkhlp8Pp/eO9XIn+foVGU3RZLfvv4sQeW8bL2+znczzX9ji8VTl646rQFKFT3VNvpvwQ4z5Ciw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:13a9:b0:6ce:5b6:4cf5 with SMTP id
 t41-20020a056a0013a900b006ce05b64cf5mr391076pfg.0.1701453906301; Fri, 01 Dec
 2023 10:05:06 -0800 (PST)
Date: Fri, 1 Dec 2023 10:05:04 -0800
In-Reply-To: <20231110003734.1014084-1-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com>
Message-ID: <ZWogUHqoIwiHGehZ@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
From: Sean Christopherson <seanjc@google.com>
To: Jacky Li <jackyli@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Ashish Kalra <Ashish.Kalra@amd.com>, 
	David Rientjes <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>, 
	Peter Gonda <pgonda@google.com>, Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Jacky Li wrote:
> The cache flush operation in sev guest memory reclaim events was
> originally introduced to prevent security issues due to cache
> incoherence and untrusted VMM. However when this operation gets
> triggered, it causes performance degradation to the whole machine.
> 
> This cache flush operation is performed in mmu_notifiers, in particular,
> in the mmu_notifier_invalidate_range_start() function, unconditionally
> on all guest memory regions. Although the intention was to flush
> cache lines only when guest memory was deallocated, the excessive
> invocations include many other cases where this flush is unnecessary.
> 
> This RFC proposes using the mmu notifier event to determine whether a
> cache flush is needed. Specifically, only do the cache flush when the
> address range is unmapped, cleared, released or migrated. A bitmap
> module param is also introduced to provide flexibility when flush is
> needed in more events or no flush is needed depending on the hardware
> platform.

I'm still not at all convinced that this is worth doing.  We have clear line of
sight to cleanly and optimally handling SNP and beyond.  If there is an actual
use case that wants to run SEV and/or SEV-ES VMs, which can't support page
migration, on the same host as traditional VMs, _and_ for some reason their
userspace is incapable of providing reasonable NUMA locality, then the owners of
that use case can speak up and provide justification for taking on this extra
complexity in KVM.

