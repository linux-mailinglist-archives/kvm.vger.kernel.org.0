Return-Path: <kvm+bounces-37238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B32A2743A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 15:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 428C91883381
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850B22135B2;
	Tue,  4 Feb 2025 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGYZJuap"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A267D20A5E0;
	Tue,  4 Feb 2025 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678763; cv=none; b=GUf9Euxq33xzKOQJQcb2ZoP7xDedthMRTESI7DbKe1NFoDFB3LVaA+dzIN4LPEPgMHjYLWg+FRahMCh2qm8mcjBS7nxb5weaBBr3OP1xV4q6pO2QGWAixJopbCcCfNnfMup5pUea7pfe0Qpa/bjzYNJP18ZxmLylHq6J7ix6AxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678763; c=relaxed/simple;
	bh=2ynQ44CVBOxBczaVkXj68IjKAIkULuS2r3wV/UT/4h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKpjsscSzdurghGUc8b9NObE7ub5FRnsZ/ed3GugKRDU6Cuer223ICBx+RlALhk9RrBgg2sAlkza+wBOaULi0VRAhQQhCPBL3s6+UXbJznCrixomdF0mu8NjNmFgXBhPaTIAMqGfizotf217nIHe/+8Qp7kNXsDwKIlG5tXafoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGYZJuap; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA11C4CEDF;
	Tue,  4 Feb 2025 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738678763;
	bh=2ynQ44CVBOxBczaVkXj68IjKAIkULuS2r3wV/UT/4h4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QGYZJuapN1NWWjkg8C/GLM6FsjkmqmYhLCrgAVLHXlzR4Wzc72Y8mEV3zGUfqMB7/
	 MHjYYs98PLEHRuWBpsO1G7tQjpF0EsmoaHEmsOtzFfl6i6W5tuVkmDIyiez/ftshVf
	 jdEYKsr1SXEdiizXtDOW8oqaIGuaKcgsBE4GuqaPIREQmpdBYlTBakW2ezhBgR+Gtk
	 yt/7sLFpWqhsHvRTXhKzwSyHmoirMLniU5/4vaiZ/Leh/1Lfggkkd35XKChK0KDrUF
	 IsMPnLBtLeiPU6plNzXcbhFg34D0GEXv2z3kk2KeHpQkdK39g4xIGQ9xnrwt/YxFuv
	 tI+cmtQaNcivw==
Date: Tue, 4 Feb 2025 15:19:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Oleg Nesterov <oleg@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250204-liehen-einmal-af13a3c66a61@brauner>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
 <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>

On Mon, Jan 27, 2025 at 04:15:01PM +0100, Paolo Bonzini wrote:
> On Mon, Jan 27, 2025 at 3:10 PM Oleg Nesterov <oleg@redhat.com> wrote:
> > On 01/26, Linus Torvalds wrote:
> > > On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
> > > >
> > > > I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> > > > case, next_tid() can just check same_thread_group,
> > >
> > > That was my thinking yes.
> > >
> > > If we exclude them from /proc/*/task entirely, I'd worry that it would
> > > hide it from some management tool and be used for nefarious purposes
> >
> > Agreed,
> >
> > > (even if they then show up elsewhere that the tool wouldn't look at).
> >
> > Even if we move them from /proc/*/task to /proc ?
> 
> Indeed---as long as they show up somewhere, it's not worse than it
> used to be. The reason why I'd prefer them to stay in /proc/*/task is
> that moving them away at least partly negates the benefits of the
> "workers are children of the starter" model. For example it
> complicates measuring their cost within the process that runs the VM.
> Maybe it's more of a romantic thing than a real practical issue,
> because in the real world resource accounting for VMs is done via
> cgroups. But unlike the lazy creation in KVM, which is overall pretty
> self-contained, I am afraid the ugliness in procfs would be much worse
> compared to the benefit, if there's a benefit at all.
> 
> > Perhaps, I honestly do not know what will/can confuse userspace more.
> 
> At the very least, marking workers as "Kthread: 1" makes sense and
> should not cause too much confusion. I wouldn't go beyond that unless
> we get more reports of similar issues, and I'm not even sure how
> common it is for userspace libraries to check for single-threadedness.

Sorry, just saw this thread now.

What if we did what Linus suggests and hide (odd) user workers from
/proc/<pid>/task/* but also added /proc/<pid>/workers/*. The latter
would only list the workers that got spawned by the kernel for that
particular task? This would acknowledge their somewhat special status
and allow userspace to still detect them as "Hey, I didn't actually
spawn those, they got shoved into my workload by the kernel for me.".

(Another (ugly) alternative would be to abuse prctl() and have workloads
opt-in to hiding user workers from /proc/<pid>/task/.)

> 
> Paolo
> 
> > > But as mentioned, maybe this is all more of a hack than what kvm now does.
> >
> > I don't know. But I will be happy to make a patch if we have a consensus.
> >
> > Oleg.
> >
> 

