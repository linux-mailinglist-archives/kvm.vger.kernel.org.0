Return-Path: <kvm+bounces-37330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5B8A289AE
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98C3618878E6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC8222A4C7;
	Wed,  5 Feb 2025 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9NV518q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8D021516B;
	Wed,  5 Feb 2025 11:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738756175; cv=none; b=qyG/cgixTY/r6CqMgivO4oBFgoGCegHc25Qw46xBcFY7tYDwm233UkPQMhrJ+aw+wELlWKtYA0GDoB64NekYFUBGjL+COOhLeQJwx6x9cGS9lLIkeBKi60STNIu4/QnOZMriU8zLbgI/gONrYPk88nFpJvd3wo/KO4RrpKsUyTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738756175; c=relaxed/simple;
	bh=3AfOgti5ZfBaHE+CdrEanIxg/k8HqDZAzPJO7xCFpUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+M/x4BOdDFwocK+otpJmBOf+h5VX3JdBhKFhd2HWilbcn0ameyoutEveWchdkt7vOIO0LgCu92HU8Ii8zvksWcngLyHsHOocPzrVewk98/0SEMagUlfyIYRlUgw79EgExUi+BA/KukE7iKWpZAmCo960E0EFXuovnTNonZqRvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9NV518q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2C6C4CEE2;
	Wed,  5 Feb 2025 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738756174;
	bh=3AfOgti5ZfBaHE+CdrEanIxg/k8HqDZAzPJO7xCFpUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9NV518qlXg/IjdjRXBH4TsGPiTH94Qwfj5kmzHMf7qY1eT2JNFw9UtBzLKp9vH7c
	 ct0jNW/lSlq9egugThdqPtD33GtHgzXzY+NAELSqFYfiKRd9ZnNuPrca7ugq5kiPZh
	 Tm0+jf3eo/5b2Dz3lQJbhSdke2IRfRZ/yxkmQNZXfasGZS5+c1//mGJ/IJg21zhXiV
	 0ThSU3JA6PV2W01kjZJWK5d7bYwvBXMscfnaStaAigiRG05IzU/dCxBiVVf0Cpa8Gg
	 0DV8EoXAiF+z6DsRIMkwjru8uFI0p5fX3oGFz94ddBIPRa37+sy+iBDnaB09KBq7+2
	 0x4zj8jw8mp/w==
Date: Wed, 5 Feb 2025 12:49:30 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
 <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner>
 <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>

On Tue, Feb 04, 2025 at 05:05:06PM +0100, Paolo Bonzini wrote:
> On Tue, Feb 4, 2025 at 3:19 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Mon, Jan 27, 2025 at 04:15:01PM +0100, Paolo Bonzini wrote:
> > > On Mon, Jan 27, 2025 at 3:10 PM Oleg Nesterov <oleg@redhat.com> wrote:
> > > > On 01/26, Linus Torvalds wrote:
> > > > > On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > >
> > > > > > I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> > > > > > case, next_tid() can just check same_thread_group,
> > > > >
> > > > > That was my thinking yes.
> > > > >
> > > > > If we exclude them from /proc/*/task entirely, I'd worry that it would
> > > > > hide it from some management tool and be used for nefarious purposes
> > > >
> > > > Agreed,
> > > >
> > > > > (even if they then show up elsewhere that the tool wouldn't look at).
> > > >
> > > > Even if we move them from /proc/*/task to /proc ?
> > >
> > > Indeed---as long as they show up somewhere, it's not worse than it
> > > used to be. The reason why I'd prefer them to stay in /proc/*/task is
> > > that moving them away at least partly negates the benefits of the
> > > "workers are children of the starter" model. For example it
> > > complicates measuring their cost within the process that runs the VM.
> > > Maybe it's more of a romantic thing than a real practical issue,
> > > because in the real world resource accounting for VMs is done via
> > > cgroups. But unlike the lazy creation in KVM, which is overall pretty
> > > self-contained, I am afraid the ugliness in procfs would be much worse
> > > compared to the benefit, if there's a benefit at all.
> > >
> > > > Perhaps, I honestly do not know what will/can confuse userspace more.
> > >
> > > At the very least, marking workers as "Kthread: 1" makes sense and

You mean in /proc/<pid>/status? Yeah, we can do that. This expands the
definition of Kthread a bit. It would now mean anything that the kernel
spawned for userspace. But that is probably fine.

But it won't help with the problem of just checking /proc/<pid>/task/ to
figure out whether the caller is single-threaded or not. If the caller
has more than 1 entry in there they need to walk through all of them and
parse through /proc/<pid>/status to discount them if they're kernel
threads.

> > > should not cause too much confusion. I wouldn't go beyond that unless
> > > we get more reports of similar issues, and I'm not even sure how
> > > common it is for userspace libraries to check for single-threadedness.
> >
> > Sorry, just saw this thread now.
> >
> > What if we did what Linus suggests and hide (odd) user workers from
> > /proc/<pid>/task/* but also added /proc/<pid>/workers/*. The latter
> > would only list the workers that got spawned by the kernel for that
> > particular task? This would acknowledge their somewhat special status
> > and allow userspace to still detect them as "Hey, I didn't actually
> > spawn those, they got shoved into my workload by the kernel for me.".
> 
> Wouldn't the workers then disappear completely from ps, top or other
> tools that look at /proc/$PID/task? That seems a bit too underhanded
> towards userspace...

So maybe, but then there's also the possibility to do:

- Have /proc/<pid>/status list all tasks.
- Have /proc/<pid>/worker only list user workers spawned by the kernel for userspace.

count(/proc/<pid>/status) - count(/proc/<pid>/workers) == 1 => (userspace) single threaded

My wider point is that I would prefer we add something that is
consistent and doesn't have to give the caller a different view than a
foreign task. I think that will just create confusion in the long run.

Btw, checking whether single-threaded this way:

  fn is_single_threaded() -> io::Result<bool> {
      match count_dir_entries("/proc/self/task") {
          Ok(1) => Ok(true),
          Ok(_) => Ok(false),
          Err(e) => Err(e),
      }
  }

can be simplified. It should be sufficient to do:

stat("/proc/self/task", &st);
if ((st->st_nlink - 2) == 1)
	// single threaded

Since procfs adds the number of tasks to st_nlink (Which is a bit weird
given that /proc/<pid>/fd puts the number of file descriptors in
st->st_size.).

