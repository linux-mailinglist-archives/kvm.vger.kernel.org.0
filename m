Return-Path: <kvm+bounces-69881-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKjDFDbrgGleCAMAu9opvQ
	(envelope-from <kvm+bounces-69881-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:21:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA898D01A1
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 762533036EF2
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD412E0938;
	Mon,  2 Feb 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PSJ2pVDb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8902D6407
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770056128; cv=pass; b=Gn7vvBcgTolnr7UOJ3m01MbehLbFlPDXdmQw+EzgeNUO4RZYUEmFaqM4/BMsG7uxfzTTVm8dfdYe1c+ZPTNek93niIlZeCW+n2pfLR0kzjloitbn+K2aM2ArhEiilOprTiVVWuejDre4sxBNXVwqbEwOI0GxLTIZNDBQQDo5oKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770056128; c=relaxed/simple;
	bh=hfLkISPUv1gvXr1CboqWBn1bs3Sd5IoZNOLzZg55skM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iF3+Vcj9hY3LFdVkbqT7NpezdvuXAj73tke4Ebb5qL/3YekiQctX4+cJoZ5yWpqzrbFupi+5+yM6Y0cB4Qa1MnYffbUi487OBQ5S2WCMOpDgRZUO8+Ne/irZGx2WCaWqo38gfpfQqPkpphWIM+XEm+iZ8HvOyYRXz8EcJ7UhPVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PSJ2pVDb; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-385bdc72422so40698151fa.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 10:15:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770056125; cv=none;
        d=google.com; s=arc-20240605;
        b=BvrWDPvOxXS4jDJEH0JOq4z52ZQpLq3SdIhXheJKqHWVa9oU7/xm+3wruQ4rbHPGpf
         8ChAGvIp4P/0a1B16kkTNQZvtmyD4N7mSFVY5zwWIXOH+AQpqYi0w5+9pkuFICZ9tvzU
         UBcoYCgWX+WAILI8aTSUEeWzupaY9kTiM3svxYK36SIu+Wvx4xF/LaxmWEJ09t3l234f
         iZ3GLwi1Q5LSc1M5apT78lTbUhEIsLeB9R+Ft1xaZhFSJRIkE/2MgE8syH7zE+Kjxc92
         sJncFmNUQ+BmiRH0ssd8o9gQjlDs7kwCREs6jLUIXi8WAh2tq8xLMD0dmr9KF2fbWVCq
         lNFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        fh=7U87KjgqShi4UURLQFlzyVwaUW+uzy1lyOLm1LCammQ=;
        b=AE1FprTCpZfWYWff24dV//qSmbeBK5TSeVSlWUYk7GuQRhQtGbKJkDkkNm58QnMhw8
         cWaQTnTyEVsU/Njd/3fRDnEihsEpoNFqRP3Le0R0pz73Y/Zvvy9v9Uivtu54w0mDQ9ng
         ERF2AjXjt1aeoX5SNjfm6istkxnMUvNTUGuDapDrjdCFeN2Lh0R4hwHfmjVmBi/whvPQ
         aiuYApSFpf3SS2amiL9aVX4xZkDtWFwTbuzHUVM4gXoqjEb62EEhzfoQtIIuBjhwCuLZ
         lGYae8zbij/UcDk7WYA2Uc0TaX/WeJzVOcg+Oi2jSQpSckrlK9zSj3PEBVHh15OpQIYG
         81Ig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770056125; x=1770660925; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        b=PSJ2pVDbNQVnPXrXNjymko4FOE40C743kvBmJ86NLSh4GircZENoqWveK5OWNMFOO9
         GpNsC5mwmhTxifUlf/daWGwYTrtNmBzSI9eXvPrODcez7DbDVIYiqvcyBy8amLYrrxVp
         DLhTd6QbiVH1AZJlMuR6iTv3Niiaa2lm5P9p2E6o7tcArvBjQTQzHxA7WxzzMWq7visY
         Ddj+8fe+ab5vxCLuvIu9gW3nb9y1abZAGX4BKFdWVZfyFeTp3yFB593U7yT/3WYrmVXT
         hClbGiN6g1pDtf0H+z9QDhit5pfuUP7PHyl+0qS9jvPbM1Ti2diqJ0edF/uO0rC2wXpJ
         ZfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770056125; x=1770660925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LIHmbN0vtM4SeA7+jGmffdOqzfQaVyhc47MhdLc1+1s=;
        b=bZkRL/vY62a3HJ94c/1bRmcTeLCasiesqqu4rbMKRITw30783vD/EEBpD8woHgFLAO
         P/PrcXmiZjvkFV9qYbTxtsC/5fsk8Uoi2GS8PJzwgJYfyCfaAHlY5/bT6VbCj8t+hO21
         x5KuElFxUKXElEJZj7eiEBG1I+H1wJoTJctaN6QpSEQO5Jyxyv5PxJnFegYzeLogzzHa
         oIMK1M97bIWLvMZKVUI5XjTp2PCVic07eyVr4t8XTxl1Pzb1e38SldkcVQnNgz1FjxxD
         9HOijLKYBkOr3PshHIDO+3uA3bGLVozsoRIv276G6i1s1lubnQfBwel5tL7gI8ku/G9M
         /ddA==
X-Forwarded-Encrypted: i=1; AJvYcCUtf4A5k1ZSFqVU342ZPfj5ZN+E+6Xl3ztWyalKoYxheqd5+gTS/cW7Ht2sevU1r26FsOY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCGtAfZ3/sAasxx2HnVn60cGtVKMqnpp+JB4NM9zl46jAZVhJL
	jRNFt6R5M7ci4EfXx/qsnuuJhqNRyhCcqvzSWG4uGFjDMcyGUtlRdA3UhhxW21fSTPI4mcNpLu+
	ewN0Xu53eXByYWvnL+t7dQEZRWM2FtkTb6lck7sir
X-Gm-Gg: AZuq6aLGbyqnhgjdUTY+o4eNwFEgs3irkwUwHk+rhWOmUgtxH1li4dPXbcXPlkaViKr
	OC4/CMMWv6nMTSiP3x48KbQP3YTgAsW3yJcciKyLCraBLeKx0ceVIVJmAdqIJrVHiZgBbPGP0Yz
	vBX6tcbLi7vHJxb2cCLTQ49+wN5CJSKsrNl+/f/0Whb3RZMALscAHkRJkdVBakJEICzX2bmd3ns
	lZjmHA6x8U4Aeby80dGASgyP33n57T8mQTCmyT32ysBcvvw0mmfKd87LamJJ5ONnhD6IA==
X-Received: by 2002:a2e:a54b:0:b0:383:1c18:ade6 with SMTP id
 38308e7fff4ca-3864662d728mr40696471fa.20.1770056124374; Mon, 02 Feb 2026
 10:15:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
In-Reply-To: <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Mon, 2 Feb 2026 10:14:56 -0800
X-Gm-Features: AZwV_QhgTJZ7rnxODmCU1qhjsI1pWSHh1k-rPTozueyr5OUveeJ2FC59ISanCNo
Message-ID: <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Zhu Yanjun <yanjun.zhu@linux.dev>
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
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69881-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA898D01A1
X-Rspamd-Action: no action

On Sat, Jan 31, 2026 at 10:38=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> =
wrote:
>
> =E5=9C=A8 2026/1/29 13:24, David Matlack =E5=86=99=E9=81=93:
> > Add an API to enable the PCI subsystem to track all devices that are
> > preserved across a Live Update, including both incoming devices (passed
> > from the previous kernel) and outgoing devices (passed to the next
> > kernel).
> >
> > Use PCI segment number and BDF to keep track of devices across Live
> > Update. This means the kernel must keep both identifiers constant acros=
s
> > a Live Update for any preserved device. VFs are not supported for now,
> > since that requires preserving SR-IOV state on the device to ensure the
> > same number of VFs appear after kexec and with the same BDFs.
> >
> > Drivers that preserve devices across Live Update can now register their
> > struct liveupdate_file_handler with the PCI subsystem so that the PCI
> > subsystem can allocate and manage File-Lifecycle-Bound (FLB) global dat=
a
> > to track the list of incoming and outgoing preserved devices.
> >
> >    pci_liveupdate_register_fh(driver_fh)
> >    pci_liveupdate_unregister_fh(driver_fh)
>
> Can the above 2 functions support the virtual devices? For example,
> bonding, veth, iSWAP and RXE.
>
> These virtual devices do not have BDF. As such, I am not sure if your
> patches take these virtual devices in to account.

No this patch series only supports PCI devices, since those are the
only devices so far we've needed to support.

I am not familiar with any of the devices that you mentioned. If they
are virtual then does that mean it's all just software? In that case I
would be curious to know what problem is solved by preserving them in
the kernel, vs. tearing them down and rebuilding them across a Live
Udpate.

