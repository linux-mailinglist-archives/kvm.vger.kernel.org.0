Return-Path: <kvm+bounces-72195-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCHfBErSoWlLwgQAu9opvQ
	(envelope-from <kvm+bounces-72195-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:20:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A67951BB5D3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 487F63028B5B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4198A361DC5;
	Fri, 27 Feb 2026 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HHFpTT3c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455783F23AA
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212803; cv=pass; b=kTPuxsipPUv8ulubhRVZ5OUcuebdYQtFJZcNYx/gEoLLzi5T3IHesFgUelX9Cw/MeRoVn9lZl5ONkBhutcRv6As4eyFoEcb7D5lwDG9kcNpMSAqPlUL+LvCm1PngF+lNoHt8xrBJk1SHftFkwkEuXm1w1ryOo5TJddJUCV4d+hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212803; c=relaxed/simple;
	bh=SSENmwLLmfNwcsRg3YsbfFMJCVOVJDpYAbDWxLRiUJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WNjBG7GAiUCWlPkxPG3PoY/SydWRvjQLOcHmuLLcRZFbaSwkGhLdJvQcfveyP1gr6ZYbpma4W9m26fEsb/Phhr8IJouek/8t++V9bJhh8gAev1FsDebvdOtqtyfMj+UZmsD8UXM4HgeMswWeQwOIo/nypie2vDVf53jrXBlAN1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HHFpTT3c; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3870acaf78eso1363571fa.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 09:20:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772212798; cv=none;
        d=google.com; s=arc-20240605;
        b=k081M/I1NibZGIj/kq/Zt2uuYGkjjQWuV6sGeY2rC9AaBl0H9guBQY51Sw05qfYDPZ
         Mf2/IwR2bsydoHgMhNJ2tYz8aym3ktDCAHDhLadiTsY+ECa7zk/ZUpU+HKIEJEjqVxzQ
         ZUesiItoT84IAvIMnlnfgu9YIChePLifVl7vZndK4AQ1FT2/hVaWGmK6upwKJckr3/pO
         hCYtZRdJ+gv10icNEWr06MXFeHbvLplZKAV7MxLvbEVtUZtPUSdPnLkYmoqyrRXqazxg
         FV9aIs/c1yYwkU6wdGXGd4BimqGpvSd7GIe6cximZIOsaoBTV9Ko3mUjOGCx6BR+mO+z
         TkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        fh=BA8kaqfhMqcWbhLF6vRY1eoV1xvd8GEMEInLQ5t/Ztc=;
        b=BSFBQ4/Nju+m0sSKiTCXKGyvbBs7aYilev+ZG+fHGVo20IIL7ibW3M01FmpXA34OUX
         bDXzzD30jp/fR1vx04vngvpOC69D86TyJas9CuBv5hFTvjjchzJkLZHV0ed6DVH+Qqf/
         SBAULIekdLg/PHU5BoiKEQzCFG79JFHOSCeP42hHsrpun2Pgl8JejwNzHWN7DRHBdtTQ
         N7k3odEoBEvnxxcFPLqducMtD0lHDj+rnM7c4Hq0f7jX1ceVWsoIlY1LJu5O/pFcvBim
         ZWNhayZOBYQCTBouOUr/CJ/ZC98cnPTK6ibTa9xYKxWX9DMnWxs9LP8t8YYkoyOrOLuw
         Vp2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772212798; x=1772817598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        b=HHFpTT3c9vcvzJ3vVCMKu7JawFYgDIREzI+Q/pn48bejMi8S305zspNJdAZhTcixqt
         ORuLPealSeMmf7TSqbFA+Y3jHgipjhOsfgImPNTkWoxuekKsmaBHFF7KJ7ROyAHHJs8x
         UqNFbkk4dBP54X3yDV1ktfH+gaoQ7dxdNmvVov/DrCkPw/orQrQ2SWpYWQwKbQY+h69c
         8swnMFVs7FafFJfAClz0HhRXDlerQjO4rLhG7QXIwcKFjsJEj9owe/5unM0+qOdZYBsJ
         RhNt8ZD6lCoXGlSkQRNf/GU3UQVOLxTzRh2AdkKAtgrtqLdgEVUkryPPbxSlU5tQIdBh
         A5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772212798; x=1772817598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TlM+Kfuyp7z6KhXNl7/hdctuf7el0QWvoUeGk1mQs2Q=;
        b=Vp7W5KeImKY6saRmo76NIQrwDzBQZ4pbAduAo9OASlQiwMz+3AY/6JAZ7OVnMXv60g
         MgkrsNf2tg1Q7PQxQ4a6977tul7cRPkztOA50bpSKVMkidaMO7VPvYtqC3S3snwjd440
         Bexs+nNk+fQEY4rJ1Z+/lTdpZ/XFEdNduT1FuL7ubuvn0mFXq1Z2EH4bU08YPwe3qRw3
         +lYb1TbOInJAjHICcZLJZHVcJa1SXZ0EokoA3tiikv/gFlFpqTGN/84aNQDyFWll3RvX
         Am/mjpS0msErYNTQRxMZNvKz/81s62Z1T+GA0jJGOFZg6cEciAs4GGx0v9YOVQaRKiwm
         flKA==
X-Forwarded-Encrypted: i=1; AJvYcCU1oXyRYoJje3RXSnOxBUmldLM5HhvHDs5eTXO+0dIRozV1c4FndUK15HBGFYboo7cdIVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxFDQey4NZWE/nwCpk/LjPhwDm3QX88uaLMkt1V2unmh0hOAcr
	DRjie5/72uXG+v09OpGewclcauuky2Ul01w2A3fuY9W9Mcn+wcsYxfx4EBrl9Cf0kJrpMEozMlr
	vvkM2KLnkggWPVEKzTFbjMhGcfs1UuXFMMtgCjK8W
X-Gm-Gg: ATEYQzyLatkzbecjQhEkh/A8tI2a+Gxpd0Et94JubCHCuOL4WzsTfYhkqj24NK7ILdV
	yrlg8KqX+dSZlSoxNG+/3gsewEVeb+e0rsRvO42/BcAbEksUtC0P1A9NOAayv+CppiKqJ+l0sUG
	UQ5r/OqciV6EwuxRZmUrw7Nv8IBhc+mPGmmaX9yQ6DCuEVae2hUyUkbbIo2xK6UGhUia4ZwxMXQ
	VlyA+/3gDroUxbg1nAH0PE+kDPA9Bm9vUvXoOGAW9d+d4gKp8ME+9+8if1M/5NSi3OTDd2UpATh
	juFuC44=
X-Received: by 2002:a05:651c:f17:b0:385:d0b6:6c44 with SMTP id
 38308e7fff4ca-389ff14567amr23252321fa.18.1772212798094; Fri, 27 Feb 2026
 09:19:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
In-Reply-To: <20260227093233.45891424@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 09:19:28 -0800
X-Gm-Features: AaiRm514TJvedInAnynD285P6RuOXX1FfRIbxiQr5Hc2znqJUuMLjDSPlZjM6yI
Message-ID: <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-72195-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: A67951BB5D3
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Thu, 26 Feb 2026 00:28:28 +0000
> David Matlack <dmatlack@google.com> wrote:
> > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > +{
> > > > + struct pci_dev *dev =3D NULL;
> > > > + int max_nr_devices =3D 0;
> > > > + struct pci_ser *ser;
> > > > + unsigned long size;
> > > > +
> > > > + for_each_pci_dev(dev)
> > > > +         max_nr_devices++;
> > >
> > > How is this protected against hotplug?
> >
> > Pranjal raised this as well. Here was my reply:
> >
> > .  Yes, it's possible to run out space to preserve devices if devices a=
re
> > .  hot-plugged and then preserved. But I think it's better to defer
> > .  handling such a use-case exists (unless you see an obvious simple
> > .  solution). So far I am not seeing preserving hot-plugged devices
> > .  across Live Update as a high priority use-case to support.
> >
> > I am going to add a comment here in the next revision to clarify that.
> > I will also add a comment clarifying why this code doesn't bother to
> > account for VFs created after this call (preserving VFs are explicitly
> > disallowed to be preserved in this patch since they require additional
> > support).
>
> TBH, without SR-IOV support and some examples of in-kernel PF
> preservation in support of vfio-pci VFs, it seems like this only
> supports a very niche use case.

The intent is to start by supporting a simple use-case and expand to
more complex scenarios over time, including preserving VFs. Full GPU
passthrough is common at cloud providers so even non-VF preservation
support is valuable.

> I expect the majority of vfio-pci
> devices are VFs and I don't think we want to present a solution where
> the requirement is to move the PF driver to userspace.

JasonG recommended the upstream support for VF preservation be limited
to cases where the PF is also bound to VFIO:

  https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/

Within Google we have a way to support in-kernel PF drivers but we are
trying to focus on simpler use-cases first upstream.

> It's not clear,
> for example, how we can have vfio-pci variant drivers relying on
> in-kernel channels to PF drivers to support migration in this model.

Agree this still needs to be fleshed out and designed. I think the
roadmap will be something like:

 1. Get non-VF preservation working end-to-end (device fully preserved
and doing DMA continuously during Live Update).
 2. Extend to support VF preservation where the PF is also bound to vfio-pc=
i.
 3. (Maybe) Extend to support in-kernel PF drivers.

This series is the first step of #1. I have line of sight to how #2
could work since it's all VFIO.

