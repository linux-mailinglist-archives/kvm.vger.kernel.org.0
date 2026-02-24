Return-Path: <kvm+bounces-71661-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIz8CTD6nWnLSwQAu9opvQ
	(envelope-from <kvm+bounces-71661-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:21:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A829418BF6B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0A781306F25C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08113ACA73;
	Tue, 24 Feb 2026 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yW6aa2Cu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F7A3AA1B6
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960649; cv=pass; b=DM51uaXqmEjNMWgGGkg+ewuF8YWsjMMGizYaPq/a8Z1q7Ob5QJaColayUFvn+P8Go9p0UQblsCGubPElVxnTeyarD27fYU7WZ1mHp6AESO7B6Xx3He/oSPSeavKSPP5rufaigBNfgSDPMhZvSkbfDqKc3dW6LACZwOcW2iuTsR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960649; c=relaxed/simple;
	bh=2a4zbszLImV50LYJlWzhpafrcVDLmcGNsmNOQqAvaHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xs7O3EgdlKRAKPHXlDrCBI2jeE9IHxk6gOAyzfxQkAqk/UzyUjCJxD8OtRIabQLmuEBe5TfEfI6AuuWNvvyVZcA3UfteKj/GluFxYo1ptilXq65RwwPzxXQy9ceWt89OfupTUAWwUC1tavj1swP30LRSZXz2c2xO189gwIHHpIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yW6aa2Cu; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38700168abaso47829181fa.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:17:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771960645; cv=none;
        d=google.com; s=arc-20240605;
        b=lMamTa6QlsAgW9fo9zFfPegyAN+ZmioYAYlR5ZOxXL6BZ4mLJW09iuur0xlQgcDeb5
         Z8N+fetTd7GQqIZsT0Cx1FE4gTKePxNu4lPsT7myRAC2rLYViOIYqtBdSWWK564xmnPI
         CKSjpPNze8Lb/MlE277BjJ11zLpDfc22uuEz5hUP8KP3VZNYH+bhwX+6NQb/U6/LZi9U
         Y1OqDUaxOriz6Jz/gRj6gQJF428h7BGsah0/b4TOpS9wRoWhk3r6mp9fUydH60R7PeOJ
         9gFIbZZgOEuPcgb7HYSIJQpAkcBI92+ysuwaGYVYP/gidL3ps3i21tTJHyLlgw1HM+y6
         7lGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        fh=h3i0GoxthC5a7YRyqAGWxSFXjYeqytWDD0dztXYRLxk=;
        b=iNZI8u32Pi0Ir2zrkq3y6nXHGUCPPwacf6IYU5eRdutBNZd6pBKCuPywI7zUq2BsO2
         e6CEk7ZcWURWAolu/jPhk6v4iotZHbMx9dSuZds9EZ1MkWo18ROvp+hMzq3JHL8B8ko6
         rRgo6YwW4zbwob7pnxjiD956q+JUoiDE2zBrt++T7FdHHQGE9wPDY5TA6YIi4tPR35wV
         ojxctVuBygJY/0munoLjbw9xcxarS3EhHl5dUIevEzBHN6u7Gboxl0i7ddkJYGx2GZCV
         ptZdRCdSHmiOxOLOxPZFF1NtgHAeRDBpM6ZQ0y6bGGxRN8vzqTIrzHD1EfVowUug9SH1
         qARg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771960645; x=1772565445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        b=yW6aa2CuPZF42UeSQUqShl6k4YAqFr99jv22mDOSrPq1GwWsVX2S/9LWQ2s7KQAzwp
         ErFxjiJX1Mkg12RTmTum/cdK2k4BqW6f0vVD9gqrMAkim6WzP4Di4DozeGWIJdWCJt9O
         J8pwUQxRzStDRfEZYDB7Pesee1QGjOy40Vi1Sy5H+n+3t0JIMN2oXKG1wvLjRetmXdvl
         rIalclYR1qLILW2HrUhvWaaRytfmTeRzmmZb+VQBFFtbH7epubGXsyDi/+YQzZ1q6HOq
         r2Gjek3DxIWVeLfL/h4MRPQKfuJJfbCtevhapSplj5Ae4LIDMLSWI8aeEXqMo6yJDpRP
         j+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771960645; x=1772565445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        b=I+60jf7leYeB/H00jhc55M1uOuaF4E1VdNTYefjOrKsbhtg5vXgOTAiKjmrvjje9hS
         O1FbdteebeFTle+6J+Y/7NwMNl9C3aR0EOwoyWt+U7ftkxU4zqCk3jVKLK8DIx3x5lRh
         dlFuGCq5+1aL2/Ti1ZFfaYgVooErQ6ySyoWb9szWDwHrUcZcCSgN38wTE8BEl8mxgbZ8
         ne0JSrOgp5VGC4/Gxr865+7+PnfBR7EMY3F2Tw148KSgbceR5eod/GUONzxFlU+cqgnj
         G/ch/huoyIl5RbrSIgpB7HxuQd+OpRdIzcVyvJksRfC6eC+QnCRd+6hqxs1yLv4M031j
         j1MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUafK+rY0bWUNdbSjfhoujq5WpA1pb5wbCrNhDSJsUSRRarTpf5i4zGKpYCNRPOoCzcgeI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcp5px2O1xcCRjWA8IgjOt5BkM7di3quZSuHwLM9Kd8cRMcTZH
	0j92SZFrqq5z9ym1dNatS7FGTOwAJSm3zkm5Pq2k7IPRgRa72Zp43+XMsuXz+GA/dl12z+huqfO
	GmlbGiA6fn4u5/rChvkw6615FtZkC8R4fXEJSig08
X-Gm-Gg: ATEYQzxuF6cJSjN96zpihoxYHJq31FYz2gwdPzVZJt6KE4YTM9Nu67MumsUzF6s5EPa
	4rSXU1qk55v80d9ibCzHQppwLSMxcpPV4JYU3n0+BQoI639DXyVmN8jO1VgHfljWHMYgjQQgqlg
	CtgwcoLREhp9FYZxjvR7xoTkm2kd37x/fr7/vZBJ1ap0rjTO82ZA+SWR9aoRAxxPcBq49M86a/I
	ub8Fd+3OF/TFX6nz0DgtcS75OzEvn0ap+aN9OgPZ0bK3Eg3KF1jEX7Y+7TiYj3qn1Nhlbb8Cwiv
	C9zIzMQ=
X-Received: by 2002:a2e:be8b:0:b0:386:e7a5:e26d with SMTP id
 38308e7fff4ca-389a5d5146bmr47895731fa.2.1771960644178; Tue, 24 Feb 2026
 11:17:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-6-dmatlack@google.com>
 <aZ3wBpYSF7mQv_GZ@google.com>
In-Reply-To: <aZ3wBpYSF7mQv_GZ@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 11:16:55 -0800
X-Gm-Features: AaiRm51YtBXd00PzQGhlvFr4r1F_UzQj5UbNk9Nur9O6pTAPmY6O7yFJgVZNGgc
Message-ID: <CALzav=cabKYFs3yhBEWOS9qseOY7rSh7F_Q40fu4spnYpmZMtQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71661-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A829418BF6B
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 10:38=E2=80=AFAM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:52PM +0000, David Matlack wrote:

> > +     /*
> > +      * Reset the device and restore it back to its original state bef=
ore
> > +      * handing it to the next kernel.
> > +      *
> > +      * Eventually both of these should be dropped and the device shou=
ld be
> > +      * kept running with its current state across the Live Update.
> > +      */
> > +     if (vdev->reset_works)
> > +             ret =3D __pci_reset_function_locked(pdev);
>
> I see the 'Eventually both of these should be dropped' comment,
> which acknowledges that a reset is a v1 crutch. However, I wanted to
> clarify the fallback strategy here.
>
> If vdev->reset_works is false, we skip the reset but still jump into the
> new kernel. For devices that don't support FLR, are we comfortable jumpin=
g
> with the device potentially still hot?

That situation is already possible today. Simply use a VFIO device
that does not support reset, close it, and then kexec into a new
kernel. vfio_pci_core_disable() (which runs when the last reference to
the VFIO device file is dropped) also skips the reset, and kexec does
not reset devices.

Note that we still restore the state, which at least will reset the
device's configuration back to a sane default, including disabling bus
mastering.

> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e90859956514..9aa1587fea19 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -81,6 +81,34 @@ struct vfio_device {
> >  #endif
> >  };
> >
> > +struct vfio_device_file {
> > +     struct vfio_device *device;
> > +     struct vfio_group *group;
> > +
> > +     u8 access_granted;
> > +     u32 devid; /* only valid when iommufd is valid */
> > +     spinlock_t kvm_ref_lock; /* protect kvm field */
> > +     struct kvm *kvm;
> > +     struct iommufd_ctx *iommufd; /* protected by struct vfio_device_s=
et::lock */
> > +};
> > +
> > +extern const struct file_operations vfio_device_fops;
> > +
>
> There seem to be two extern declarations for vfio_device_fops in both
> vfio_pci_priv.h and include/linux/vfio.h. Could we consolidate these?

Sure I can clean those up.

> > +static inline struct vfio_device_file *to_vfio_device_file(struct file=
 *file)
> > +{
> > +     if (file->f_op !=3D &vfio_device_fops)
> > +             return NULL;
> > +
> > +     return file->private_data;
> > +}
> > +
> > +static inline struct vfio_device *vfio_device_from_file(struct file *f=
ile)
> > +{
> > +     struct vfio_device_file *df =3D to_vfio_device_file(file);
> > +
> > +     return df ? df->device : NULL;
> > +}
> > +
>
> I'm a little uncomfortable with this part. Why is it necessary to expose
> the internal vfio_device_file structure to drivers? If this is only to
> support vfio_device_from_file(), could we not keep the structure private
> and just export the helper function instead?

Yeah, no problem.

> Exposing internal state into the public API introduces some maintenance
> constraints for e.g. if vfio_main.c ever changes how it tracks
> file-to-device mappings or its internal security state (like
> access_granted), it now has to worry about breaking external drivers.
>
> I believe we expose the struct just to power these static inline helper
> (mainly vfio_device_from_file) ? Instead, could we treat
> `vfio_device_file` as an opaque type in the public header (like struct
> iommu_group) and move the implementation of vfio_device_from_file() into
> vfio_main.c as an exported symbol? This gives drivers the vfio_device
> pointer they need without leaking the core's private internals.

Good points.

