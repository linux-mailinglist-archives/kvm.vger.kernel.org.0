Return-Path: <kvm+bounces-4823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF5E818AF9
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3306B1F23B11
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7421C6B3;
	Tue, 19 Dec 2023 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VsA3q/78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB321C6B2
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e74c97832aso20151477b3.2
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 07:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702998965; x=1703603765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4coqQCSKX59Kttv4qZsEIP2X5Pj/cyaVwpO8KQJ6rI=;
        b=VsA3q/78v5Rb+AQrB6XJxN4PA9fCsmfZ1rrWp+qM8Wapih6gEe1+RGLsX8aBkuxPMC
         w4UjtKLads0BoVG9ly3c9RguyqLoQhXVdc0B2daWkbRvxEhNAEKPqtvgDmRP3XZ2eSdX
         zVT75QeEZEItOopeGCmQidOF4LlU62GdAguGWiZcZSzjkDOreYVtJeHE5sB+uRQonMFZ
         NkERhC+5LtwhDDW0GU7QNMVpdSG3XhkLaiyIWTi/zILzXuWdvJXsFztq34SoHDA+4AxM
         8tc1p99AnYPCrxKCWLR9pMf3SZVNN6pTJVdcqeMKDRw0XaCWT/XCPwXiu7i5Sn5YhNEh
         7JYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702998965; x=1703603765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4coqQCSKX59Kttv4qZsEIP2X5Pj/cyaVwpO8KQJ6rI=;
        b=eHw8SLvA+POE1uwmYjz5CrXGPvk2f7BiJ6tTLcL1q2ydSMaJbz/1p2BF1Efh56O7gI
         sKKcZX0/V37Wngr41VevE9QxJ1oqPBEOR9pD7RfN9mk8OAof6MRBlx7T7aMIVnVJkjrE
         ZcXz+/GtE1zzQTRo+cxC4wdAQZU7EqcB2SFoo1Gl/DU55X2moPYPcNbYgkQqa6xHH6Oe
         CbdULcijhqcyInmJwlI+GvXq+VaENWMTGa8yMpC7F0u9nmig2V/Dh1R4n5gCOuaR2qXU
         2kDp1zgPixUujwwuz+mdrbxZ0VN/c0wKbDWnWCHN6a2zpyMbbggAQ8KMPKJEZfMy8O/J
         R8jg==
X-Gm-Message-State: AOJu0Yxfxz13H1wi4uVaNC5X6YNzgGvz8XxVa5Tkvymst7pMPZc0bmff
	z6zOPg05Swkhc6W7aHPhUl6bT9+ZtOg=
X-Google-Smtp-Source: AGHT+IE7+BA1OH6FWRIrijAlDeWAR269iwl9OEzeh0AwEstTKrqOLwJo4penj32eM9184EXl57u2qFOgyfA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10c:b0:5e6:1e40:e2e3 with SMTP id
 bd12-20020a05690c010c00b005e61e40e2e3mr1558948ywb.5.1702998965049; Tue, 19
 Dec 2023 07:16:05 -0800 (PST)
Date: Tue, 19 Dec 2023 07:16:03 -0800
In-Reply-To: <bug-218259-28872-h88Ho5XI7I@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218259-28872@https.bugzilla.kernel.org/> <bug-218259-28872-h88Ho5XI7I@https.bugzilla.kernel.org/>
Message-ID: <ZYGzsxv9jANSYuX0@google.com>
Subject: Re: [Bug 218259] High latency in KVM guests
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 19, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218259
> 
> --- Comment #6 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> (In reply to Sean Christopherson from comment #5)
> 
> > This is likely/hopefully the same thing Yan encountered[1].  If you are able
> > to
> > test patches, the proposed fix[2] applies cleanly on v6.6 (note, I need to
> > post a
> > refreshed version of the series regardless), any feedback you can provide
> > would
> > be much appreciated.
> > 
> > [1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> > [2] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com
> 
> I admit that I don't understand most of what's written in the those threads.

LOL, no worries, sometimes none of us understand what's written either ;-)

> I applied the two patches from [2] (excluding [3]) to v6.6 and it appears to
> solve the problem.
> 
> However I haven't measured how/if any of the changes/flags affect performance
> or if any other problems are caused. After about 1 hour uptime it appears to be
> okay.

Don't worry too much about additional testing.  Barring a straight up bug (knock
wood), the changes in those patches have a very, very low probability of
introducing unwanted side effects.

> > KVM changes aside, I highly recommend evaluating whether or not NUMA
> > autobalancing is a net positive for your environment.  The interactions
> > between
> > autobalancing and KVM are often less than stellar, and disabling
> > autobalancing
> > is sometimes a completely legitimate option/solution.
> 
> I'll have to evaluate multiple options for my production environment.
> Patching+Building the kernel myself would only be a last resort. And it will
> probably take a while until Debian ships a patch for the issue. So maybe
> disable the NUMA balancing, or perhaps try to pin a VM's memory+cpu to a single
> NUMA node.

Another viable option is to disable the TDP MMU, at least until the above patches
land and are picked up by Debian.  You could even reference commit 7e546bd08943
("Revert "KVM: x86: enable TDP MMU by default"") from the v5.15 stable tree if
you want a paper trail that provides some justification as to why it's ok to revert
back to the "old" MMU.

Quoting from that:

  : As far as what is lost by disabling the TDP MMU, the main selling point of
  : the TDP MMU is its ability to service page fault VM-Exits in parallel,
  : i.e. the main benefactors of the TDP MMU are deployments of large VMs
  : (hundreds of vCPUs), and in particular delployments that live-migrate such
  : VMs and thus need to fault-in huge amounts of memory on many vCPUs after
  : restarting the VM after migration.

In other words, the old MMU is not broken, e.g. it didn't suddently become unusable
after 15+ years of use.  We enabled the newfangled TDP MMU by default because it
is the long-term replacement, e.g. it can scale to support use cases that the old
MMU falls over on, and we want to put the old MMU into maintenance-only mode.

But we are still ironing out some wrinkles in the TDP MMU, particularly for host
kernels that support preemption (the kernel has lock contention logic that is
unique to preemptible kernels).  And in the meantime, for most KVM use cases, the
old MMU is still perfectly servicable.

