Return-Path: <kvm+bounces-72237-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MPbHrEYomnFzAQAu9opvQ
	(envelope-from <kvm+bounces-72237-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:20:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C1A1BEA08
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2A5A5306C03B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6383047B40F;
	Fri, 27 Feb 2026 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0MQQxTeH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD3347AF7B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 22:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772230820; cv=pass; b=N0wbDqkfCofoENsH6vuVA0vemR9UJlNx3Z9ELUT4BspOjMHmnKRPSXU1TlNHdwG7gwMvlERU/Y3CfUYSi0kGy/agTAC/P/CDUrisaN6U/RTwysyfXWb3E5hODIPjZSkcotrJOIYnVELjyupoS29yTuhPB5UQt8wFt0vq4JjwaXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772230820; c=relaxed/simple;
	bh=GtsGyeZPiDudjfd8L49wF+hn5MDTTqKv6ZZkfauqv5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pldhkWTs86IDZPj/NpR77Ag20lTh8xlM6WpHFOMhuphUw7ejojjwsRp859JQR7bi9SGjxwB3Gfvt8d380MBnptcg00lJ6KrWBQmVq1t2rRHO7qK1tAJByZMlGrK4cbS6wQskj0D4vIhzusXhuPv0Oq/N1OO/+EE3PiXV3uAPp1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0MQQxTeH; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3871a08189aso36020981fa.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 14:20:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772230815; cv=none;
        d=google.com; s=arc-20240605;
        b=bAX8AIU4ERmX7ZqxABggvsGgdiU95qObYlMoXIhqfQWjZ6SHKIl4zDgNYEsgKtLIoh
         qPb+p3xj+fNjjtAQ+jpUY3CBfXg1sdGkBFTcMy25rB9LxZT2d6KBd15Lc1VFT2I/KQrI
         iDZ585/0sbX27WBrrCkx2xRZzPLvOYr2DnVPnCNdlWqtNe7sLQQ+eouGryZj45Rm0dWm
         IS/1j93LNEGWd7x2avYC4LrtZbUHJr9YbJzBGiG8yX9ACyyvqpYWnXNh53BUraLIbz+w
         EobCFcg+dZeaUXnCI4vARjqV3PTcDyFPLSGoQ1eiHt1s9Ua4C8ZIAPkWzAvWrEZonVYf
         cJTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        fh=Xq4OmFVpxWTRPM0xtfFlDqyPG7jn9b/kVR99dxy+13M=;
        b=flxJJpJBN9hQdGcpVo/Api+ZMyuRdpFHFaXVGF5WbfFAfcJmvPeh4aw7/JPl29F+Hz
         f1ZoB9jvMAa6PkHNMKEnfXOqShi0EuZsca8eu5R1jGL83f555qY+WI9oKbpxl7MeDudA
         SElQ05AHcXb4toK2Zv+z4JZg4dQ31Or8MOaRWuS3DpjWEotIIOc6Pph4gZpTNA/Rwd5V
         4Y6IGhP1CegA55eYBL9ft7eRJ9+ps0VrZJfpoZNh65+PHRRTrx4SYDo+lYL6itPiy7uM
         LMAGEQCGisrQQb5euih7q3MxyZI6JYMoWTIWIpyPw7UG49vdWAw9M1igfo4jF7SgECkq
         7lbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772230815; x=1772835615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        b=0MQQxTeH4drNtPAxjqOERP30fqO8XGjxdB8a9Frg3KPY+t8k3Y0sxCohBY5MIxsuTV
         0SYevnvypqsMoj3K43Wvq1GOO30l/rBN1wyPGme/CTUWr1yUJ2QCoLtzogotQH3yg2O6
         d0rVcxDdYsnPoREkiLxgsIbopf84baaXx5kguZVoSSaXIyOBQaPlUuQJR7yqklfcEDzG
         y6+H9dCbQP+sX0YaMOwfQlp3JLknU8Sgfx4baCXMStTha/TdULiY2ks5COvznkqBzgHP
         G3WHoxY4XbgEXL/9dYBdBr78/vD3tKpWC9db+Q/AJSMI2Bswx2iLix5B6oYhW+txUhLK
         NwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772230815; x=1772835615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        b=EwNnbWIPex3gWG3ivZYpqnpA5P1h0gr1ynpPgahUMQrBCLQQh5n9k63exMhBpBjbJG
         l2oBl+0ixx9MQpr6Vem96Gd/KFnqq4Z1IQXJoCPwgLWoEbSrjdvOhe/aUIDJrRZA3ad1
         C5S45NwQ3UjEXqB/N4zHD4OeqQSZtSgAdBBzZPknyb+mkWX6ewzsWAkpt+HQxvES4Qed
         ICssY83OMKrwOs6QLY4BVk7mgd00Xq3qrwIhR0M4oeK5M3bambP1u68Uv6UcmsksPttQ
         INNLtwlvoePE5jzxz+/e0hLq4YynepgqEoBUbboMpipzsRm6YZIqjAOTIBOwrMTkRKtN
         zEgg==
X-Forwarded-Encrypted: i=1; AJvYcCWtkn+6xLGVxIWaFHiA4eB/UFJqYSoHbqv1ZEfJ2ps2quXTIN172Vsei2wO5DURnvYH5Vk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz118Ve4zfYOmyZXDSmbC+HkTlZWQ6mTFhGcSwNE9DOMJdvSTYT
	soCmF8LC7xJLYF199bs23S5Jzdm1kQXyzVG4HYdR/bRhPtbTiNG6FeUcMyEkgjGoXb7UVAyKmgc
	x3gUpMO7sGttVszPmSPzw1Xu+T9wFTF0eKXSyq5ml
X-Gm-Gg: ATEYQzwfcfQlE5ifpyjgGwskQ/gpjyh+RfiuOQH8aMN63y1pUnyXh4mE0oI5i7UCAYn
	PNBaVIA4lw0MzaCgrVauEYejWVYossddkiaIvXkDW1AFz6laQAicnZ8iP7ZMoE5Mx08VKqGjquX
	2nWaN3ytZDt19qhMeYn3/LHNhiYBhPShkmZm2DKgws9SXz4ey2n9t+v0XCOiyeBLVuj08kK9yWr
	+ADfXTwB9UKhwx5v7j4TVzROoPDy7kBZbJm0L+HFh/is4SklvVIFyRmdu5kSBab9Lahm9bgry7D
	SgddVTjNTe3LtgV5tg==
X-Received: by 2002:a2e:be9b:0:b0:389:fcc6:4923 with SMTP id
 38308e7fff4ca-389ff36c676mr32953561fa.36.1772230814172; Fri, 27 Feb 2026
 14:20:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com> <20260227112501.465e2a86@shazbot.org>
In-Reply-To: <20260227112501.465e2a86@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 14:19:45 -0800
X-Gm-Features: AaiRm50CpBktJDVkdNswfpkBixm1XqIc04gAiSgoLOF5-QNcfKrgPA3B04Dkoqw
Message-ID: <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
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
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72237-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,shazbot.org:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 22C1A1BEA08
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.org>=
 wrote:
>
> On Fri, 27 Feb 2026 09:19:28 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.o=
rg> wrote:
> > >
> > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *arg=
s)
> > > > > > +{
> > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > + int max_nr_devices =3D 0;
> > > > > > + struct pci_ser *ser;
> > > > > > + unsigned long size;
> > > > > > +
> > > > > > + for_each_pci_dev(dev)
> > > > > > +         max_nr_devices++;
> > > > >
> > > > > How is this protected against hotplug?
> > > >
> > > > Pranjal raised this as well. Here was my reply:
> > > >
> > > > .  Yes, it's possible to run out space to preserve devices if devic=
es are
> > > > .  hot-plugged and then preserved. But I think it's better to defer
> > > > .  handling such a use-case exists (unless you see an obvious simpl=
e
> > > > .  solution). So far I am not seeing preserving hot-plugged devices
> > > > .  across Live Update as a high priority use-case to support.
> > > >
> > > > I am going to add a comment here in the next revision to clarify th=
at.
> > > > I will also add a comment clarifying why this code doesn't bother t=
o
> > > > account for VFs created after this call (preserving VFs are explici=
tly
> > > > disallowed to be preserved in this patch since they require additio=
nal
> > > > support).
> > >
> > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > preservation in support of vfio-pci VFs, it seems like this only
> > > supports a very niche use case.
> >
> > The intent is to start by supporting a simple use-case and expand to
> > more complex scenarios over time, including preserving VFs. Full GPU
> > passthrough is common at cloud providers so even non-VF preservation
> > support is valuable.
> >
> > > I expect the majority of vfio-pci
> > > devices are VFs and I don't think we want to present a solution where
> > > the requirement is to move the PF driver to userspace.
> >
> > JasonG recommended the upstream support for VF preservation be limited
> > to cases where the PF is also bound to VFIO:
> >
> >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> >
> > Within Google we have a way to support in-kernel PF drivers but we are
> > trying to focus on simpler use-cases first upstream.
> >
> > > It's not clear,
> > > for example, how we can have vfio-pci variant drivers relying on
> > > in-kernel channels to PF drivers to support migration in this model.
> >
> > Agree this still needs to be fleshed out and designed. I think the
> > roadmap will be something like:
> >
> >  1. Get non-VF preservation working end-to-end (device fully preserved
> > and doing DMA continuously during Live Update).
> >  2. Extend to support VF preservation where the PF is also bound to vfi=
o-pci.
> >  3. (Maybe) Extend to support in-kernel PF drivers.
> >
> > This series is the first step of #1. I have line of sight to how #2
> > could work since it's all VFIO.
>
> Without 3, does this become a mainstream feature?

I do think there will be enough demand for (3) that it will be worth
doing. But I also think ordering the steps this way makes sense from
an iterative development point of view.

> There's obviously a knee jerk reaction that moving PF drivers into
> userspace is a means to circumvent the GPL that was evident at LPC,
> even if the real reason is "in-kernel is hard".
>
> Related to that, there's also not much difference between a userspace
> driver and an out-of-tree driver when it comes to adding in-kernel code
> for their specific support requirements.  Therefore, unless migration is
> entirely accomplished via a shared dmabuf between PF and VF,
> orchestrated through userspace, I'm not sure how we get to migration,
> making KHO vs migration a binary choice.  I have trouble seeing how
> that's a viable intermediate step.  Thanks,

What do you mean by "migration" in this context?

