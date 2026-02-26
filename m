Return-Path: <kvm+bounces-71913-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AE1lL16Zn2mucwQAu9opvQ
	(envelope-from <kvm+bounces-71913-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:52:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0F919FA1B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 688B330416DB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C0531984E;
	Thu, 26 Feb 2026 00:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Isym9Zp4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218EE2E62B3
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067139; cv=pass; b=ng41OlrDf28jsdKfuk+DCwcUXJg7b2OGmCIm3nIJO2V/m5nYP8mRR+0dU3C4UpHvkI+w6yVKgDvZAPNanfkrP7h7fmAnkiSXQfFyCyKJ9nDM0/b5EgIxmQ665SvnVlHh0gXM2vQo0SKqbebu5a8RzRCJmrvmFg/WoOGxhWnQvNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067139; c=relaxed/simple;
	bh=5UM3OPrEzy38BQ/z8lTr67s9jTiNGfLCQhFUKKuIZuE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ne8t0KZphlUtf2bX56nEN0Khvkp3SLwctyWJSqMISbd+DpMH2rlLr6kUMNYoYCI30HTFAPCFvh2wFQmZL4Xtej4sL8u2qyk1PEEQ4F0VxZ5SOL+GYeLzQJFz2JwihfrO5neCNFXrYZu4N2TtXz8pp0Jh7iuNwf7bQUnPFltzTyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Isym9Zp4; arc=pass smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5688b639a19so153012e0c.2
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 16:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772067137; cv=none;
        d=google.com; s=arc-20240605;
        b=igJpb0Nlkc7RIkZ6As+j0FaA8cAFMgJHm6/Iv+LwQmo1U7DnCFtzFhQozamUKOiAHL
         2KU3aFHhqy8LkNc42EuA3NeqywXSCowAfbLwu/Cjh3L19Z5mVHGC0FYATILHKhRJfUxa
         gfSxwvJWH77F8OYtNTRu/ejdREtN31107fRWSJQ6b+nzztW+5A5Ub/maINFfQnQ/TW2j
         bV37pnaposeo3RTVTpaUeRaRhJy5UJKb8Su9qWV4oGonot5OUg0RnKlh6BKq5Wn188zh
         Eko+T+jfkMU+ZWs8sWT/1m7LF7YIARKeRSIQMAERkDUE4dIaj+elted38r79W+TgRUIc
         f8CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        fh=k3DT/jwrnVohNlmGYOZTSKjqCcjJGX1GQ5Lm3153TOc=;
        b=FTTlnGZPbeumLlkORj2jPcf2t7/SnrqnccH/QYqv2jXC1VkajvGsWPzUkSJ5oYoEI2
         t9vBxr0dk5MjAaUKnObe8Lmyo6yrY214e+o0EDK0Oy3ZIRHId8+xP4OzKpneGYgnBalo
         PEnztiF5tnBL02GbwFSMtmPPFynxdasPkNczWDmSPCHV9+2xyvk5ycJj1g9If5pYLEn0
         CKHgXNiy34gIQcwmWs+7o7Z087W7FNhKbPNmTxQHMG+jCQ5K1l790O1E6+TEy0F7cn93
         Ct7yTwEAnMZ5qcru1oPQozWORpBcb+OxZDC6SB3VIASk4v0F2rSBt9apCukP0UlBrhZJ
         AU2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772067137; x=1772671937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        b=Isym9Zp4jjzR+PC3c/BniSDPSxJbrLU8884r+rart9fG1ueJm/2EFzUZ54EEDwayeH
         4TElbvJ6sEuwu2Q91jPlhwmiNC15kR69yqOPhVJPvW2wHKUiI3ZQuEvDaubPPR5D993m
         Hnp/o4nbcJCA4D1/8p1P4oraDX5owxN0FTeHHx1eObgCadot88UiLgxyonvldRh4c++g
         zxEIpMNtWGmkw4Kjsp4F1Pk6APFcQZ8azzng1d+4eZdwvQfMelhgLDii/TcG/monS+0f
         1Zte2TRT8ls6qpt0pJKTAa4dnhta0PRjvHW754pcnzj+v1EdXGsgPbefOu4Ncl8P2vbY
         cZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772067137; x=1772671937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        b=Z50tOhrVSZt+279EU59uFVRGqnqlvP00MDCL0GLvXRBgRUNpIhYi3xYWdLku4oKKPo
         wnpcqo0tYMIfk5m+F2oOW1W3FJfxV2Q7SOpK06kthEezl5fvirII6uiulaJjbf754hbX
         bq/5RR1Sr7+WHZyl4IzkzWh0J26EBnf2O1ZwhoAFNgwsiNE9pM3BChL1BABB6/YJ8fxj
         V49ONS5XIU5EQEl2cl8k1UnJBgz/DPShZ8UgTYTIKrpvQKuBzbROt3vm+Ts+kC3B7M1a
         spLi+4elegxPemGOhTVnC10TklglzHp1ZQVSB6RbdQk6TnM6392Um1xkMXSJBkkl13dW
         zliQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaPwC+Myrdwn1ivSYeVxCrDiq9bQUqYHlt8dTCHieBRbiZEHSpF5wMF0Y8KRkRc/NuLGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YySjmePJVFAYDb36VjhIydqYrpeFsXWcBqGKsYfNi++asz8k2nF
	eoAs/WYwbSIyowFsnpjk2lyubJ2KU5KIvU5fwT/Dauppads185f2X6aRtRroVgOurWpqQUgEKFh
	XhvsytDBBdp6868owveSBLZ8LBV+wdmtNEnGc3w9M
X-Gm-Gg: ATEYQzxdFv8kXMexG2/bJJfPrkEa/YaDV84+tfG8vkFViYGxn5Y8zT/7SyKOqhJ/URO
	eVSzzYm773CTxoZjXl39mA0jlyG6cVTdJqbtbzLF/BNwlUGkSTel+G6O5weZLubCclIUJ8Z4CEn
	HoNGQe0w71sBwp70XYxfChwEfB5Rs19NAcbeuA5RfSxH1QoJV4o7tjeZxpvZQ82mBIRDTRiv4ja
	bv3BCRxMFPa/XrZc8at71z6BEMycg1HGUsdvwWA0QXzaq9IfzvJ4G2knZR//ezgrA54HUiIE6A8
	KK1zLzg=
X-Received: by 2002:a05:6102:3f0d:b0:5ed:f13:e58a with SMTP id
 ada2fe7eead31-5ff1419f7b6mr1037473137.37.1772067136513; Wed, 25 Feb 2026
 16:52:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-10-dmatlack@google.com>
 <aZ606sDJxtfNF6qW@google.com>
In-Reply-To: <aZ606sDJxtfNF6qW@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Feb 2026 16:51:47 -0800
X-Gm-Features: AaiRm51I1tTdJRO5CbbBFYwdOmR4S6VSPvkujC59eyupuwvOv4iLZLnGYRmW3DQ
Message-ID: <CALzav=cH0-qqQJTOjDD7pHzsFeZOir5DoC3f1hhDg=jqK7vdgw@mail.gmail.com>
Subject: Re: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in
 struct vfio_pci_core_device
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71913-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6B0F919FA1B
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 12:38=E2=80=AFAM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:56PM +0000, David Matlack wrote:

> >  static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_a=
rgs *args)
> >  {
> > -     return args->retrieved;
> > +     struct vfio_pci_core_device *vdev;
> > +     struct vfio_device *device;
> > +
> > +     if (!args->retrieved)
> > +             return false;
> > +
> > +     device =3D vfio_device_from_file(args->file);
> > +     vdev =3D container_of(device, struct vfio_pci_core_device, vdev);
> > +
> > +     /* Check that vdev->liveupdate_incoming_state is no longer in use=
. */
> > +     guard(mutex)(&device->dev_set->lock);
> > +     return !vdev->liveupdate_incoming_state;
>
> Since we set this to NULL in the success path of vfio_pci_core_enable()
> I'm wondering if a failure in vfio_pci_core_enable could cause a
> resource leak? Because vfio_pci_liveupdate_can_finish() returns false
> as long as that pointer is valid, a single device failure will
> perpetually block the LIVEUPDATE_SESSION_FINISH IOCTL for the entire
> session preventing the LUO from reclaiming KHO memory.
>
> Shall we also set vdev->liveupdate_incoming_state =3D NULL on the error
> paths of vfio_pci_core_enable() ?

LIVEUPDATE_SESSION_FINISH will also perpetually fail if userspace
never calls ioctl(VFIO_DEVICE_BIND_IOMMUFD) (which is what triggers
vfio_pci_core_enable()). Or if that ioctl fails before it gets to
vfio_pci_core_enable().

It's not a great situation to be in, but this is why can_finish()
exists as a callback. Userspace must properly and correctly restore
all of the state in the session before the session can be cleaned up.
And the kernel is not going to handle every possible edge case (some
files in a session are restored but some are not), at least not
initially. If userspace gets stuck and cannot recover a resource then
userspace will have to reboot the host to get back to a healthy state.

