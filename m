Return-Path: <kvm+bounces-27858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F68B98F730
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 21:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63F78283B3F
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 19:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CADA1AD3F6;
	Thu,  3 Oct 2024 19:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAmI5UPQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9EC1A4F0F;
	Thu,  3 Oct 2024 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727984904; cv=none; b=o+ur7rwP1PHFGXi7PAHlTEzT6GG9r7cX+eaLcKaDARzVi1bWnrEdnJWClAH4zWQz/q8Cp4+KwOCC9grchZS7ELdvdxBiQQno6bNiZFbZ8CDGa+FlP8r5gxpFYr9wZ1yfrDQ40kc9vuukk177n1j0efX4nkpRTHT8LfhtzftuMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727984904; c=relaxed/simple;
	bh=qqtwyKHdqGFDaQm8XpSYQcJY1KwB0a1nrS7ZyxA15TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJA19NNdyGpBXRYS42Vj4XgCl1ObhX6ywZckfjX2RG9FJc+VZyEf7AJjakkbHAHBa3H00u5+IiIO6NNdLmSriovzgqmFDAmZYl99P2Xh9lyMikhQxNr9BDbzRh2eN9LUEBhjluMuQOInFttIJ4Qap5SpP35o14ZQFII+vE73L3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAmI5UPQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C088CC4CEC5;
	Thu,  3 Oct 2024 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727984904;
	bh=qqtwyKHdqGFDaQm8XpSYQcJY1KwB0a1nrS7ZyxA15TY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VAmI5UPQD76BOp3/CbtoGgE9LU5UY72qHe7Uon2iTn7vUs+7cQ3W9oj9xI8qsYbc8
	 6OTGBA1ps6XoKk9GN18YtDi7q+OuOJfJe/aBvkO+qg74E3mHREZCPi75wxY5NlpU8b
	 rz4L2xwngxBLhcsFx0tygoBILHedxri66rdoGazleOOSPIgXB6lMK+4sgbfpI3ykkj
	 OkC9ke0aHEymouPQS8nPlXa099bUhTYRL7dBjFNMm8oRqvwgUMpgkYy+gw4YWWuwxi
	 OrMwaU6R5HUpSXIU4vcc0zjU7EajPrKjG0ekD2nPC1dyRiR+4Rj1TF4vXmc97LhjSa
	 Gz2Ca5vdfz4zw==
Date: Thu, 3 Oct 2024 12:48:22 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, kuba@kernel.org,
	stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <Zv71BrHKO_YwDhG_@bombadil.infradead.org>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
 <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
 <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>

+ linux-modules@vger.kernel.org + Lucas

On Mon, Sep 30, 2024 at 07:03:52PM +0200, Aleksandr Mikhalitsyn wrote:
> On Mon, Sep 30, 2024 at 5:43 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Hi Aleksandr,
> >
> > On Mon, Sep 30, 2024 at 04:43:36PM GMT, Aleksandr Mikhalitsyn wrote:
> > >On Mon, Sep 30, 2024 at 4:27 PM Stefano Garzarella
> > ><sgarzare@redhat.com> wrote:
> > >>
> > >> On Sun, Sep 29, 2024 at 08:21:03PM GMT, Alexander Mikhalitsyn wrote:
> > >> >Add an explicit MODULE_VERSION("0.0.1") specification for the vhost_vsock module.
> > >> >
> > >> >It is useful because it allows userspace to check if vhost_vsock is there when it is
> > >> >configured as a built-in.
> > >> >
> > >> >This is what we have *without* this change and when vhost_vsock is
> > >> >configured
> > >> >as a module and loaded:
> > >> >
> > >> >$ ls -la /sys/module/vhost_vsock
> > >> >total 0
> > >> >drwxr-xr-x   5 root root    0 Sep 29 19:00 .
> > >> >drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 coresize
> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initsize
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initstate
> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
> > >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
> > >> >-r--r--r--   1 root root 4096 Sep 29 20:05 taint
> > >> >--w-------   1 root root 4096 Sep 29 19:00 uevent
> > >> >
> > >> >When vhost_vsock is configured as a built-in there is *no* /sys/module/vhost_vsock directory at all.
> > >> >And this looks like an inconsistency.
> > >> >
> > >> >With this change, when vhost_vsock is configured as a built-in we get:
> > >> >$ ls -la /sys/module/vhost_vsock/
> > >> >total 0
> > >> >drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> > >> >drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> > >> >--w-------   1 root root 4096 Sep 26 15:59 uevent
> > >> >-r--r--r--   1 root root 4096 Sep 26 15:59 version
> > >> >
> > >> >Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> > >> >---
> > >> > drivers/vhost/vsock.c | 1 +
> > >> > 1 file changed, 1 insertion(+)
> > >> >
> > >> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > >> >index 802153e23073..287ea8e480b5 100644
> > >> >--- a/drivers/vhost/vsock.c
> > >> >+++ b/drivers/vhost/vsock.c
> > >> >@@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
> > >> >
> > >> > module_init(vhost_vsock_init);
> > >> > module_exit(vhost_vsock_exit);
> > >> >+MODULE_VERSION("0.0.1");
> > >
> > >Hi Stefano,
> > >
> > >>
> > >> I was looking at other commits to see how versioning is handled in order
> > >> to make sense (e.g. using the same version of the kernel), and I saw
> > >> many commits that are removing MODULE_VERSION because they say it
> > >> doesn't make sense in in-tree modules.
> > >
> > >Yeah, I agree absolutely. I guess that's why all vhost modules have
> > >had version 0.0.1 for years now
> > >and there is no reason to increment version numbers at all.
> >
> > Yeah, I see.
> >
> > >
> > >My proposal is not about version itself, having MODULE_VERSION
> > >specified is a hack which
> > >makes a built-in module appear in /sys/modules/ directory.
> >
> > Hmm, should we base a kind of UAPI on a hack?
> 
> Good question ;-)
> 
> >
> > I don't want to block this change, but I just wonder why many modules
> > are removing MODULE_VERSION and we are adding it instead.
> 
> Yep, that's a good point. I didn't know that other modules started to
> remove MODULE_VERSION.

MODULE_VERSION was a stupid idea and there is no real value to it.
I agree folks should just remove its use and we remove it.

> > >I spent some time reading the code in kernel/params.c and
> > >kernel/module/sysfs.c to figure out
> > >why there is no /sys/module/vhost_vsock directory when vhost_vsock is
> > >built-in. And figured out the
> > >precise conditions which must be satisfied to have a module listed in
> > >/sys/module.
> > >
> > >To be more precise, built-in module X appears in /sys/module/X if one
> > >of two conditions are met:
> > >- module has MODULE_VERSION declared
> > >- module has any parameter declared
> >
> > At this point my question is, should we solve the problem higher and
> > show all the modules in /sys/modules, either way?

Because if you have no attribute to list why would you? The thing you
are trying to ask is different: "is this a module built-in" and for that we
have userpsace solution already suggested: /lib/modules/*/modules.builtin

> Probably, yes. We can ask Luis Chamberlain's opinion on this one.
> 
> +cc Luis Chamberlain <mcgrof@kernel.org>

Please use linux-modules in the future as I'm not the only maintainer.

  Luis

