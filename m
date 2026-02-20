Return-Path: <kvm+bounces-71420-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0B3MDiqwmGm3KwMAu9opvQ
	(envelope-from <kvm+bounces-71420-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:04:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5CA416A3DD
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D77F030677B0
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF60366DB9;
	Fri, 20 Feb 2026 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FMxVguAz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DF132B9A5
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614230; cv=pass; b=NWRt2LsquYxRvE4I5SU58NH0JqiIggZpqDZeFWo2m0ejFiGS1l3QaUFhFGFVITw/zuRkh2ZLjQU1bdVGDsAnNpZ9svNH4mhg3O5EdGSRs0icfFZ5wwhwj9n+NLBoUl1uHw9KlJeCqgE2dPsZkAh//EwK679fT9ywDnaWGyLZVrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614230; c=relaxed/simple;
	bh=XUamG8pxMZfQQBQ8tt/1daaovPkkzl+bwqT9M55iAqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bH95hRXsBAEu2i/4HePP1l6XqZmnPvZfRPD0V3c2hJgLDrmNGyv1ZLuFleLJT2Ha2eXStfPaWBvEYKLLwMj/OTzDp376rygWycMBn7QQRyYaAdZo+T2UJYHrFWfmRFv+l1MGI4w+8fmSfaeEoybHxglKsXyXoqMVmWDLeYSTPp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FMxVguAz; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59de2d1fc2cso2815954e87.2
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 11:03:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771614227; cv=none;
        d=google.com; s=arc-20240605;
        b=Cbv8QD8wc9FDOWpRxJH5muF1sEGUsQ8p6ASR3qQXCqyhTF3GcfTKcD10iurO6cEICH
         NyviXq3jFLELJhMm4dMlYGPFeVDXjfELIpg2bCIBpMaZrJGJNYlX9I0iha9BwxfXJCmy
         IbRYLqXRbRWcaDj0vL+cB9w0Fi98FD8olR56bbfAO9ni+MFYInPb8I6H7B+D/i8VWjxp
         PzXZb8Wd+sdiDvHC/3PZMW25Fjo8ICvx/RPfFIlC8qqOVBS+B5T+R5YUSmsGVr8236dv
         9FNVw2pBMdMozuRI6TJsSrKYVRuGsvnez3j1yE0SWoy7ODp3cyERjiAJ5ZEQMWCH8/rP
         h38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        fh=JBOO41GrPmk972bFIB3Exs5QVWnC/a0vVs3qG+zWdk0=;
        b=eDwmf2aN0aNXrqrKh3lFkAuDBOK3YY+hZwZoIn8TZ2plz9qi7i7/X09Q3PgYxG4ft1
         LNJeAVnnCTIRlolf/OEfk8UuOvaTay/LNzX7cDbM03EXtm6T2PSzgbSxDozMaJXb053O
         o+BPBSQjsq8shwDwRYL3emGFRx8bagJYO/j2VxklfSMQQo/+dug1fgSGoudQKzIIqHVB
         MMYacP2sDyxhRtMy7jK85N/MbKGvsOl4Xuu2waaf7IFBvGtGq3nVahm1nOsDAn4oBKTr
         JKcaNuUFZeMuQGUi9sn132xIcKwe6lFJfYLCKrJ6PWebniF0nWUh2huIkRh+jUv4jpbx
         6ASQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771614227; x=1772219027; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        b=FMxVguAz6Q/R1hmgXeSH9QRwrNKbVLRvC+fTcHleXKS+z00fYt4eSpsR5eSdZebl2Q
         stNtMUUklDPm7LXfZBYfvmbfMH4XSTcw2FaMbs7/rLtm1DVQzKoHoZWDqMIsTB5YoS5L
         29rvQpnIGVX/9OZjqH27AR+uDyuBE14IFCdBcO9OfwvurN7HwTN4P06RxzAcFSNAOuuZ
         qWtARLGRmW4OS9MzRAGi7qbYS0uSz1q/JXfGfFaZFFaSyxfK4f6zmDMvnXsmHrwBRa6X
         k+8p4GbXaEtr68I3ZjPAsHRbpcsb5tVBURaWON2qi1dPvIfLgZxFs1qy1WDCZUSI/1nX
         h6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614227; x=1772219027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        b=SV1hXuWJgo/sMMdFZ+jy0J7+uZ2NwlUO1Dzi+8rlwBRHPrOxAkgEe7G68xbXaGFr1C
         cGulnAC0k2Xn6wuUX2+VH14A9WNxopUMbPMJg66UTSq3UoI+WCGpQCDE4iuxResnYY77
         C+csgvQc5vs4EQj5+rBPZcjttL6dFoEZsd5dHoYYNjHoPeUM2SDWwW9nzb3smC+w2GRu
         yXGr9PpYbXxx8yQdbv3pgkv9B1dN5Y/aQg4PbLcbuuN8yHkKIoped+tzeLQ1zZ2l4ZR3
         UHl1cLKetoZGqD81KJVhWv5D6nV37k5FitvbKcj/Cxmj702MMpkRzRje4ccsQjf3rWra
         Pnog==
X-Forwarded-Encrypted: i=1; AJvYcCXQ2fQGAsW3a5tP1WeYl1n6MnlLCOFjrs6FBOubiu9fasdwnTjwA8jJViEPVBPaXiJi480=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy217/xUjl08Ea1pA/ZvpKvd3XtWermZ1TE9PoB+ahHSjlu5N68
	jvkcm/K4shHy2/IAUrMOKIAcWIs3Zm2y5k5wggPxGqZWx4qce1nOxdkcmUnhEf7ffEicW6KERRZ
	pGcJdXivM9JNilivTwOyABMsogv4bB9gAXVZMRf5J
X-Gm-Gg: AZuq6aLAwYsfzvXDXewMSLjMG8m/uKxGNSTyg4mcl9RFC7zuCEnvDp/TOeNMfaCh1hg
	vLKQ4BJvWyTn43jVX9mcGc0yOl0c8Q5bWhHTZBBNLD7/aUx83s0VsJkDpeGsGIsjJXyrgidRQZz
	jk36B2aQcUOrjGFc0HaolG6V45J+Uo0bGLZfDAhSHNK6J/bvFdkHs7ON7kdLK6lm7dZm6YiJlBH
	RAJQXOtp1BfVV4nX3pQ/9gDfeL2E5V+1lPxWuNqk+DhdsKEXDOSMI2W+d62Ezw0ssrwuzoHjHnc
	MYrSQ/kumqw+02wEaw==
X-Received: by 2002:ac2:4c56:0:b0:59f:8546:203c with SMTP id
 2adb3069b0e04-5a0ed894dd1mr165159e87.12.1771614226924; Fri, 20 Feb 2026
 11:03:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev> <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
 <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
In-Reply-To: <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Fri, 20 Feb 2026 11:03:18 -0800
X-Gm-Features: AaiRm528gVDC51Vc6VmuyDJufgtIlxh6fV-eX6614wdRe-TzmLDadtAg2AEPmi8
Message-ID: <CALzav=dEykMZGsqz35TgvPqqZZFzG0kqojmry1Ya+Xf+zEgyAg@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
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
	TAGGED_FROM(0.00)[bounces-71420-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B5CA416A3DD
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 4:10=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
>
> On 2/2/26 10:14 AM, David Matlack wrote:
> > On Sat, Jan 31, 2026 at 10:38=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.d=
ev> wrote:
> >> =E5=9C=A8 2026/1/29 13:24, David Matlack =E5=86=99=E9=81=93:
> >>> Add an API to enable the PCI subsystem to track all devices that are
> >>> preserved across a Live Update, including both incoming devices (pass=
ed
> >>> from the previous kernel) and outgoing devices (passed to the next
> >>> kernel).
> >>>
> >>> Use PCI segment number and BDF to keep track of devices across Live
> >>> Update. This means the kernel must keep both identifiers constant acr=
oss
> >>> a Live Update for any preserved device. VFs are not supported for now=
,
> >>> since that requires preserving SR-IOV state on the device to ensure t=
he
> >>> same number of VFs appear after kexec and with the same BDFs.
> >>>
> >>> Drivers that preserve devices across Live Update can now register the=
ir
> >>> struct liveupdate_file_handler with the PCI subsystem so that the PCI
> >>> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global d=
ata
> >>> to track the list of incoming and outgoing preserved devices.
> >>>
> >>>     pci_liveupdate_register_fh(driver_fh)
> >>>     pci_liveupdate_unregister_fh(driver_fh)
> >> Can the above 2 functions support the virtual devices? For example,
> >> bonding, veth, iSWAP and RXE.
> >>
> >> These virtual devices do not have BDF. As such, I am not sure if your
> >> patches take these virtual devices in to account.
> > No this patch series only supports PCI devices, since those are the
> > only devices so far we've needed to support.
> >
> > I am not familiar with any of the devices that you mentioned. If they
> > are virtual then does that mean it's all just software? In that case I
> > would be curious to know what problem is solved by preserving them in
> > the kernel, vs. tearing them down and rebuilding them across a Live
> > Udpate.
>
> Bonding, veth, rxe, and siw can be used in KVM environments.
>
> Although these are software-only virtual devices with no associated
> hardware,
>
> they may maintain state that is observable by userspace.
>
> As a result, Live Update should preserve their state across the update.

Sorry for taking so long to get back to you.

Userspace should serialize the state of those devices out of the
kernel, persist it in memory or on disk across Live Update, and then
recreate it after Live Update.

This is why, for example, KVM does not need to direclty participate in
Live Update. The VMM serializes all KVM state from the kernel, saves
it, and then constructs a completely new KVM VM after the Live Update
using that state. KVM will only need to participate in Live Update
once there is hardware requirement. For example, I believe some of the
Confidential Computing hardware virtualization extensions require
certain memory structures used by hardware remain in place and cannot
be reallocated after Live Update. KVM would have to participate to
preserve those and reassociate them with the right VM after Live
Update.

