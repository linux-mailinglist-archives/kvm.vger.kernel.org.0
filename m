Return-Path: <kvm+bounces-72194-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAFXHMrQoWkfwgQAu9opvQ
	(envelope-from <kvm+bounces-72194-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:13:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4F01BB453
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 303C7311B865
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6FC361DA1;
	Fri, 27 Feb 2026 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PgPiHSvB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A3389E18
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212100; cv=pass; b=BTuWGXVPSs82Uh/0stT+snyYnVz38C4ePLs4LZ+4GLXkKo270FpFJU8M0LvT2ml8cHloQLc9pUb3JhqkY0XbfpXX6ChuDjtUM88Gr/mlHNdDIgnYifsM4wOCWs7BRtYGfrff8MhbbhDMWs3dAd7Vti7mK2HUVF1F2JNYMlNoKUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212100; c=relaxed/simple;
	bh=hgtMP8VUtY9P76ez7WKUM8aE1sgvg9AP+19rjG+g6HA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKcMMW92lSEfB96jV7Fds29kafD+jg+zzdft937YZZTArRTP/BczCA2MLq553xqjomAoocXUwW+oTHk3gpuP2VPLdAMahxdm5/NZbhGxaPuxHCj1RfYDHmcXqzJKIRTVsLPaeemaGjnaaEIhhYpdlGsV5qyM1KzhjW5opjGTWn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PgPiHSvB; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3870902760cso28679541fa.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 09:08:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772212097; cv=none;
        d=google.com; s=arc-20240605;
        b=Dbv7ltYmnKmXa6sNeMaoqygyRhBiiXO+KOqwmKWFUlZ5ZU7HH4G27I1vSLH926YnGB
         Dl60I+VGbEJ71tz4aUGoMp++THhkX6tV/Vls2wTtWVS2tWC8oluSJDUxoMCJxqmNMBFC
         /SIVN3FFOh/9D7K2B4kw7ILtkUbKZ7inJFDUshKmUBliAA8/hrnviAXLmq1UT6xXKohG
         cmj8MduQJOGEtMxHvUJ37xAel3/M9a4oI3FMoTctypqfcSov/i246ZR9SqnBedMYRL4K
         Mz8s5v0NXRbWh7gK95XkMdPOZC9l26gZit2nA6/EfYmTBNQi/1ZyrLXnNI3Iah4UR0fv
         XEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        fh=1qPBDeWGpI2e6U5ZXz6MVrTCT7l3hr9vALpROwQlmqM=;
        b=JhXsvGnis+d5tgh0Y7YVwNDypuJp18Nk1xNsUYNbKbiIm7gN6B5dzEm9IP4emp2/1v
         FYdazQeekaYG/RACB0hlyn0YtlQLNHzEj7VekayTdCguLYos5Yoady3mDFrNiTVpD0dE
         Ib13tXvLaWSma4dhqGCWysCkm3Ju88MJOAV9TdHEyrRgxay2IfgPKVdonDGokzlmxc13
         YduDRJ0JA1dTYzy57c7PNShXplXAVOsheXPs7NGK7/uJQU9JPb4no/HFw2uBxu0Yhlxn
         NdLPZQuqFsd/9b9YYYnyPpxMK4Ob+jjw+tZdcluqpYeOrEx0ECDPUROpSELwwUeMJQHV
         WpSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772212097; x=1772816897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        b=PgPiHSvBUI+6gG4LIWdV1P8tP+hFkKXk+TFFDvSHQY50WokDZVU56YMWiqXkadzDvF
         dmtlcfNCGrEBiqCje044yvDu+SRSRfiletzn5UHk6aDk5+045qCqDx9KZIhw/o27OQyt
         UCKQGipmAhUvcb93PWkufu6jfbdDWWfD7jV0cQTUEWeMstaBqGManjqzjqQYtybdqa4L
         pEO1bYIczqigj3PY5FSg2rMiDk5C7w1QRrnXsEnaAKPLDJTj6pp3XYC4Ydv2DCasxQxQ
         uDX642xnkksbRVZwr1quu0e2bw6oAYru6aoEG0ikwUHlNxPLSG690KLg3C8rSaGWmiey
         vDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772212097; x=1772816897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        b=LLc1xaB/UzURdYrkzXPreNL0gLEY18Jk5n+5RLS0LTnnmuflbs+wra5twEahQh7K/y
         QPpPMiGgjpmWCt7ECubyuAYyHpn0+oKrgoyCkG0fXk3V20O8DvaMFpnh7ksTHctdFTNf
         L32rQj7hvVZWZWkC90Gh/pmem/9jbAu5Ik2bMjycmKPUVdUgATLYQsPgIJLA1tjNy7DS
         ckDo5JRAREKmBNoUI5n4y/9ojrLvJFU+kfbXTv60nJUYykreooOlVzEwttPVSyVgCbQB
         7HVCmr4cNPpBe3s9tWq5Xq8vzHqBSuugpYZb2UDnLdMjGz3cHCDRk+GMogY7hE3ZmNmf
         JCDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrGM3uZ3IX9b9YHzdonZz907p9jYfrlj2XaVpmgVMqYcSYj4MJEmynf/+LSgjh6ogkZCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd7TNja2zw5TGq5E9ggZDj2ENbFmHcW1bpkjbzOuX+7EFXx2KY
	IrfKYwR/4HGSKLJ6Gitt+LvAUDfGzt8Fb4WYkD3+7xoiuRq2/bBC5JIT27ybieRHbH0p44/ZCNi
	mT7HF5PGlq+xTyFJu6V/OomOKecYJ9oCM8+UyPkkN
X-Gm-Gg: ATEYQzzlLxkgDhr/O+FBSug2K70eOPs4ls0PYdpTDOBjpuWCNEqpVQhcqy3wnB2tPII
	kn0Jr/nVKzNovoDawrjkZijvHDBUHMpyYof/Ug05X3zp2srHhmLTxOf6FI4VTQh0U6IXNjd11WT
	Kbd//LeO/sLqB2ib7EIMaNqDTUIKQIMwiCLZ1kBB2bnvoifwVo9ICnNf56v6fFFAY4O3vN9lzmJ
	19RyOA6XyZyUxd/tJSCT+Nrb8TzoomvIcLLNcy2adgFSJ2YHLDtg/cl+1RvAeseUu4oSJS68aLF
	bDBYJBwRXAKuKStwqQ==
X-Received: by 2002:a05:651c:50f:b0:385:f7ce:f321 with SMTP id
 38308e7fff4ca-389ff15f271mr19911451fa.26.1772212096622; Fri, 27 Feb 2026
 09:08:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com> <20260227084658.3767d801@shazbot.org>
In-Reply-To: <20260227084658.3767d801@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 09:07:48 -0800
X-Gm-Features: AaiRm519T9RurPcNiWyO80VEVhcFvT0_H9lBfATMd1KVW4QtGFBpubzCvVI4oqQ
Message-ID: <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
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
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72194-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0D4F01BB453
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 00:51:18 +0000
> David Matlack <dmatlack@google.com> wrote:
>
> > On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > - vdev->reset_works =3D !ret;
> > > >   pci_save_state(pdev);
> > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev);
> > >
> > > Isn't this a problem too?  In the first kernel we store the initial,
> > > post reset state of the device, now we're storing some arbitrary stat=
e.
> > > This is the state we're restore when the device is closed.
> >
> > The previous kernel resets the device and restores it back to its
> > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > control to the next kernel. So my intention here is that VFIO will
> > receive the device in that state, allowing it to call
> > pci_store_saved_state() here to capture the post reset state of the
> > device again.
> >
> > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() an=
d
> > preserve vdev->pci_saved_state across the Live Update. But I was hoping
> > to add that in a follow up series to avoid this one getting too long.
>
> I appreciate reviewing this in smaller chunks, but how does userspace
> know whether the kernel contains a stub implementation of liveupdate or
> behaves according to the end goal?

Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
information to userspace?

> Also, didn't we violate our own contract in this patch by adding the
> reset_works field to the serialization data without updating the
> compatibility string?  Thanks,

Yes, I will fix that in v3.

