Return-Path: <kvm+bounces-71630-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIgZCBnhnWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71630-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:34:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C21618A94A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F17F307D7F7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7343A9DB1;
	Tue, 24 Feb 2026 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jolJbCoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30E33ADA0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954440; cv=pass; b=Jtk6I5tQnCtrHoChuG2yz2sIMZgdIA81dXIEmSgFo2vjLvbQ2KktvnfpBXQeD8Bc2fQj7VnBnk+Z1Gia5bTYx/U3niYkgYdKNws5DDrwXSdAhAeEKYFA7kA5C/nweAGYheeyabz2o0qdXu3K6yhSXHJcoeZIDonZCOHGeV/Fwsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954440; c=relaxed/simple;
	bh=cCuihnC83rVuxNh9g4clqD2+2gMDD3M/m5qB3+opnzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDyRqCaQpjR+Wj0TClO4qMHXTHsBPv1sOkdxli4Oj0Os+5hbdi43q7uJ6iS1ymLLYltajPPif5EFyU323PJhn0O9fmwNF8HP1vSDkPiKJ65WzugLZTkkoeLTLOEBBnMvIaNgc4vJ/QBlQoXY7Q0grA4P2z37sVJJFV3O1yxT67I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jolJbCoX; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-5fe0959ae3dso23368137.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771954438; cv=none;
        d=google.com; s=arc-20240605;
        b=FdlD2qXn53JpMNTCK1hbhBaPifnLMWYwjOhdWPnXXzWlK9SzIybVYRNWax1QA9jDdM
         Bn+rpylj7e+uZM5lwQvVUeyKUQZ/E6UhlSVIr9p5Bs3PJhZm+DS5/MdfF4sQzC6S31m0
         7e3fkXX5Lmzzn2PUAIA/195BLXSfL45LY/waJBW7btd0C4oeqFHNTZAGqEIsweNKxMvq
         V3BxjG3cYlnpwLuyQIpFBAcBXfHFI+6Oxh9echxCH48b5G4LTZxJ2pBHC6OhxbqME00z
         wd+igx614nxNgrwBiDo0rdq/zy2QCFBa3DDR9WPDZT3Lq7FgiiBvXEchhB1eGw4+tn6W
         /Qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        fh=JBRfcRsjXFFdns6mAmgYaf/O1NQfp/qIDa5sxLGyTzI=;
        b=MqKQ6DDN88aLEWXKye2rGb3pg5Cy1M5afEsbRPaiNRG6qOz6qes6fOtyJ2GG5n4+Em
         WAyDjY+im5Fic9Caq3JXPhYXvt+lK4Y97oHs82kYufYH9DDjz1S5qyY8XJLPfNYomGkl
         YPEVHULEQQLfzQOewR+gekOOX4Sz+34DC0hbbQ2Uf1vQli9A8BWkRXk8gCg6tEpZjtqg
         uUX5kyAPCbNeMbGALPi9TdK+cXhwWVPiQVUZUwMkXhoP2Ytywtg2OpAErld9qOASH/Ut
         LLUVyDjglX2hWEP0cU1GzLCi9RNpqYh1CcRnY3rHUfmz6oEu0Eero8Eri/QmB6Xg7JQG
         3yNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954438; x=1772559238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        b=jolJbCoXdMN41Sl54UH1EhIF9lYgMnUAkv31VR7d6YHVfXhNEMI/oWJeEqnwMX6hHl
         TXbMLy906AtVogBxlEiPhmHP2/az0SGQhOe2Wk8iSROqBd1ZVWZ9FQu0biRx/10+7W9v
         9vsTLLwtCZvluGsn7DRIhKOr8fJpk8xV1sg2pmfX1MMyoJLgm9bu/Z55W4/uMZ6ejAWA
         oPZ2xKSlt3hnT73Wi2swQS2owsGclHr3lFH+SjxmRPrb7Jq0rrgaNsZRKBKURZCiUdZe
         fV6uj9DlFicm9uEimVZ1LpRi55AsLMi9t/kE7ornmeU7Z08w94OggX7daje69SKh6xP4
         ICfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954438; x=1772559238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        b=i93z/3pUrow0GSifRcs/bbShueiZx5ivXD2g9kcSwP/VZlv4T+awaEC7oyUZWzqcWC
         wC41M/C7f5r0kL9hwF/AKYJG0tE7OmzPGkuu9DoDhQ+ee3gHOvRK1OWSDEWKuJJen2KJ
         yz+dSftBAbl4kFQYFwSzKY6Oe4vwJHrxzTg0VNPNwli2G4utz0axrioaftj6ErhC58Ne
         rqNOcHh2m3Bg/K4wLU+bUsXG6m+vcxumCRjLWD3ZJbDV/w8hbICfjlCQU8jGRAZuD9ld
         cPqg3sttLC6Yf81Ca8uG8R6ewCjIR9JYtxXhwllk5qaUXDg/O6Q86EqT0Sb30hbEWCQp
         u6Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWZPtzszju+4GuOyz9SXUaaFTuv+5udqDZtnPHpTXb/wrW+8DixJwGw9vJYYSxalwT3Z6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlYdTcm9QWte3coqyKY4w7Jk2PQRniNUri7cWUHpowV4r2J2+x
	Nh1OSOF0hK6zHwjz9L5UY+zMq9aTfjt1M3UHBNK6SHTD3WFbFmHfYTBWRm66Fmy0Je8uHGcWqqE
	GUIpyYuzmsFuTicNwhKQu6NzoJVNBiFl69C4Cx4SL
X-Gm-Gg: ATEYQzwpWKtAZX4Nbnwp3yqzMGTbXgYirauy7T4KSPhFa8zg4ktES4oL462bpsA21cI
	p78pfRdwoHSS+PIj+wUrAZspCK88hTktxxMN5ku8m8zIHJRcvrqJ0e1gOKYeqJKZ1mP7V6+1nHS
	J98RSlHXUj2lxfp+tVNzxTMYVvMYWBOgk+nuxSUQ24oz/iPj8WIL0X2C0MPyzNnQDBpnMNPbXk7
	jAHdfsAo8I6qzwHNy3DnMjtJOd1C7HPUzkqOm2V66RQm9oBiQEDB/AkC5tIgruAV196cIxlaoKH
	m/V9aNY=
X-Received: by 2002:a05:6102:e0a:b0:5ef:b32c:dff8 with SMTP id
 ada2fe7eead31-5feffd8e046mr571923137.5.1771954437826; Tue, 24 Feb 2026
 09:33:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
In-Reply-To: <aZ1svGur9IxQ7Td2@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 09:33:28 -0800
X-Gm-Features: AaiRm50ftzuk34ivxDcB4SNiM7gs91UDwPlTbTMB1CMe8djixeonPg3t_5VqAYg
Message-ID: <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71630-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 8C21618A94A
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 1:18=E2=80=AFAM Pranjal Shrivastava <praan@google.c=
om> wrote:
> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > + * Copyright (c) 2025, Google LLC.
>
> Nit: Should these be 2026 now?

Yes! Thanks for catching that.

> > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > +{
> > +     struct pci_dev_ser new =3D INIT_PCI_DEV_SER(dev);
> > +     struct pci_ser *ser;
> > +     int i, ret;
> > +
> > +     /* Preserving VFs is not supported yet. */
> > +     if (dev->is_virtfn)
> > +             return -EINVAL;
> > +
> > +     guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +     if (dev->liveupdate_outgoing)
> > +             return -EBUSY;
> > +
> > +     ret =3D liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (ser->nr_devices =3D=3D ser->max_nr_devices)
> > +             return -E2BIG;
>
> I'm wondering how (or if) this handles hot-plugged devices?
> max_nr_devices is calculated based on for_each_pci_dev at the time of
> the first preservation.. what happens if a device is hotplugged after
> the first device is preserved but before the second one is, does
> max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> the actual possible device count, potentially leading to an unnecessary
> -E2BIG failure?

Yes, it's possible to run out space to preserve devices if devices are
hot-plugged and then preserved. But I think it's better to defer
handling such a use-case exists (unless you see an obvious simple
solution). So far I am not seeing preserving hot-plugged devices
across Live Update as a high priority use-case to support.

> > +u32 pci_liveupdate_incoming_nr_devices(void)
> > +{
> > +     struct pci_ser *ser;
> > +     int ret;
> > +
> > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return 0;
>
> Masking this error looks troubled, in the following patch, I see that
> the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> BDF might still be preserved? Which could lead to DMA aliasing issues,
> without a hint of what happened since we don't even log anything.

All fo the non-0 errors indicate there are 0 incoming devices at the
time of the call, so I think returning 0 is appropriate.

 - EOPNOTSUPP: Live Update is not enabled.
 - ENODATA: Live Update is finished (all incoming devices have been restore=
d).
 - ENOTENT: No PCI data was preserved across the Live Update.

None of these cover the case where an IOMMU mapping for BDF X is
preserved, but device X is not preserved. This is a case we should
handle in some way... but here is not that place.

>
> Maybe we could have something like the following:
>
> int pci_liveupdate_incoming_nr_devices(void)
> {
>         struct pci_ser *ser;
>         int ret;
>
>         ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
>         if (ret) {
>                 if (ret !=3D -ENOENT)
>                         pr_warn("PCI: Failed to retrieve preservation lis=
t: %d\n", ret);

This would cause this warning to get printed if Live Update was
disabled, or if no PCI devices were preserved. But both of those are
not error scenarios.

> > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > +{
> > +     struct pci_ser *ser;
> > +     int ret;
> > +
> > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return;
>
> We should log something here either at info / debug level since the
> error isn't bubbled up and the luo_core doesn't scream about it either.

Any error from liveupdate_flb_get_incoming() simply means there are no
incoming devices. So I don't think there's any error to report in
dmesg.

> > +     dev->liveupdate_incoming =3D !!pci_ser_find(ser, dev);
>
> This feels a little hacky, shall we go for something like:
>
> dev->liveupdate_incoming =3D (pci_ser_find(ser, dev) !=3D NULL); ?

In my experience in the kernel (mostly from KVM), explicity comparison
to NULL is less preferred to treating a pointer as a boolean. But I'm
ok with following whatever is the locally preferred style for this
kind of check.

> > @@ -582,6 +583,10 @@ struct pci_dev {
> >       u8              tph_mode;       /* TPH mode */
> >       u8              tph_req_type;   /* TPH requester type */
> >  #endif
> > +#ifdef CONFIG_LIVEUPDATE
> > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous =
kernel */
> > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next ker=
nel */
> > +#endif
> >  };
>
> This would start another anon bitfield container, should we move this
> above within the existing bitfield? If we've run pahole and found this
> to be better, then this should be fine.

Yeah I simply appended these new fields to the very end of the struct.
If we care about optimizing the packing of struct pci_dev I can find a
better place to put it.

