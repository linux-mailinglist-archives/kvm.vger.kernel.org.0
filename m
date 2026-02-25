Return-Path: <kvm+bounces-71899-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAfcOOR8n2mrcQQAu9opvQ
	(envelope-from <kvm+bounces-71899-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:51:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAD719E775
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2DAF73074573
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 22:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B900366DC4;
	Wed, 25 Feb 2026 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVRV/1XX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05E36605D
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059862; cv=pass; b=VaEzc77oXSWov9Opx6rOai5pj2V5k9Uo+IwYmlNbyF+nvIQOOkoBypyaFPGedGf/0DvD1c7YFEgrPlOoxPmz3uKOvhTQf88/6hViExS5F8sRPcDjQfCnTgS3NL1xCJqweCCuyketuvF64Crr5p9ZnECNixIHbS3fgIxsYk7sBSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059862; c=relaxed/simple;
	bh=7OqNOR2pf3cTOCHBcFY4ktMJJpHonFJgCAwij4qDwtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M5whyr2bl7SM7Upizp87NNk34IQt+KiKcrWe0XNvnDEm2t7Safn+xOmN73GBrtRrh2EcMYMvgeLq06+gnrcnvi7/DZ9NMnkH/oZi4y12W3R40DzzIUtecLGPDQ+RQGTFetLVPaxKW3Ne8srMN38oLrCfYGymbSNFAO84WDP6/YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVRV/1XX; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5033b64256dso193331cf.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 14:51:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772059859; cv=none;
        d=google.com; s=arc-20240605;
        b=T9BVCUCbC+M8/QeO5eEpR3CeaVYMRYYK5/OIfMoZx4VysjmF9N646qD98gEHC2UPS5
         OHbr/M8yZ3iIBxp5N72+vhw13NLJMhl4Wqg8EXfNIzUY1Rzwu02PAPIjCMx6/Ir2wG59
         D+Fd/1Lb9viHLssCypBNY2j5zvoQNHWmNNg7FhBU/W7a3TCulEjoTnG+hT5ZtEz5u2CO
         gLiLvHcwf7y/MEItXr0yszoV+IhKOUQYT/OL7WDOStQ/KLn4s945lDJTBhBSZCZUiSLJ
         IG/TYFhki0R01x+chbaLXZmL9RkNmNCdcqeSzlKvXd0lDAO2dYF17jmi5SCeNKPPa1Ia
         ZUJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        fh=BgLhdeS5s+UMQzXn/zUFIPndNXImrn4gG8GksJzezjM=;
        b=B48hEDBKD86UkCaxQWOxepyMl3vxK+hwHMxhJuMYyrbByyUHaaaql9Wy42OhLpi/Cb
         4bdQVmfBrXJWxnSapGCmLPkpp8ZUGBP9FS7XWbQEzXYoK3BJhjzzCG5eyyFcvvG9r+P1
         jNZSQX1N9Tmy6+h8JVtykicjrjZktWWKy+DczqQSgN1hJ5VpOwQDbQxs+iuDmshoeIvj
         q4PHWySUnC8fJ1XihyQt+OlN22/mgHGVKQFf8c90qZctXudf9nQ/zh5wonJKv8JBiNfn
         6KRR6S81Rx2IZb3C00dddTHqqwl3VpLN9VqQqURLTtscFlbvMdzkJ0kCf0aGraRiXmV2
         +7Jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772059859; x=1772664659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        b=WVRV/1XXo2nnw8gzHzdS8IksP9JKJvN3r6Llnl75OoENUwU5YDeA9MYBGEFJ9nBAd9
         J2IyxpI+5I8/f8KlhHspyQxqjMQqFVdGuyY15FT88FsCEbh0Gnrx3OQwF8uAVf+Y/wXH
         udcDYJpAudc8TDhtI10nVAMJgFuFYzKKqOotF1h3fiM5+i+rswqgvv605CkgnyXgjh22
         2P/0AfOQoYmBaoOiaIPsQAcgXxM7WW3G21sByw1cq3WvPBd/UgRbG0bRapKQlaDnnpxF
         1/N3w/nSBohJrJPVpdytsvq1ReNEffews0/3EuPaAR4TVp4MH1SO5aTam8noYyp7wwfb
         Nc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059859; x=1772664659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        b=a+Ag69dOqWz3RXCavgF0pfbt4p8Q6I2EbqyRIhCa+rlvtGKYoA2T5HPKyyZHawsLyS
         ysif7dz6+bTqOjoh10J84cITqDmpOxUP9mgNv6v4fJf22cWT65PPPcbqfMjKUx15ibAX
         Rk7Ue39mrTxH96sPhji7esCSXP6vSHLBptxYcGJ/q10dNPTQaFXO5KGeUb1I0LxYODXW
         h+hgwdaZW4lRb4tEfQ/KsfLmsdzMx9lWw8sg1W1W9lht2P/U5hLl7nC4j+IYM8MymWtl
         M5fCtSH76rDfCKQ52S6YK1ZmrI1xorAAdpYhV+UdE9XM9VOK/FyxKsad2+LI7YcRIgJs
         zWHw==
X-Forwarded-Encrypted: i=1; AJvYcCVdULU3b1I3Gdt+iS+nejlykioUVSz5EqRLXLNYA5yGbc2UZnlM+u5IKdK4+NUCUwwu8G4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh4u+O3p9UssxBTo4G3y+STdkrR0sM8tN3f1vBeC/QxmLSuXhG
	dntxvrfRaa+7Ys/QEiZGe1drvyRPxjyOuVpaT6u4cEBWZ37pV5SjOxM7UfyW3BFPp8uc8Cw/cb4
	LGxN1izIOstegIIqZJh/1rTCvPxXh9PI3hHbhrWce
X-Gm-Gg: ATEYQzy6LPzjEQZEkFrQv8MRshPzPZJ9rjVi/moU7LWT0MFW0tg71QVitegZZ40C99v
	4RDDo6bnYlpY4zDVrnWOoWYgZjzhlXhntFwSM4l7rz6IxQ4Z+aFrJZ/o8H3f+PRmnWxCayvPJoL
	5/lBQiI1CcgoNvFn43NXwbv6NE34KZPXuEMZ4j/y93ppwrL1FUePQyRQ293IIvYyYnmE/rXLIhp
	WeBW+clyihE5+DFYFzL5SaZnucRaa+sSMjZVwIypWSbVcOJmPmvI+8KlCRMjcNEfk2edi6519yM
	+0lmViDSZVdbwFGheJuV4/tdzGWgK86P9Yl5IoXEnyhO7Vqa3+UW
X-Received: by 2002:a05:622a:10c:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-507441cb73fmr3920551cf.8.1772059858971; Wed, 25 Feb 2026
 14:50:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org> <aZ9yWlcqs2b6FLxy@google.com> <aZ931bYILhhkhW-Y@google.com>
In-Reply-To: <aZ931bYILhhkhW-Y@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 25 Feb 2026 14:50:47 -0800
X-Gm-Features: AaiRm51aoTymXymwCHLQ9gcq3ldQPi6BvUrjqTLQO_zSuAjigNCnBqzqKSIxD-4
Message-ID: <CAAywjhShWTQbkwhDYB=9a_PZjGHnJ-=HTLAzDBvnDsmtvP=Auw@mail.gmail.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
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
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
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
	TAGGED_FROM(0.00)[bounces-71899-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,google.com,nvidia.com,amazon.com,fb.com,linux-foundation.org,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4AAD719E775
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 2:29=E2=80=AFPM Pranjal Shrivastava <praan@google.c=
om> wrote:
>
> On Wed, Feb 25, 2026 at 10:06:18PM +0000, Pranjal Shrivastava wrote:
> > On Wed, Feb 25, 2026 at 02:33:28PM -0700, Alex Williamson wrote:
> > > On Thu, 29 Jan 2026 21:24:51 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pc=
i.c
> > > > index 0c771064c0b8..19e88322af2c 100644
> > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
> > > >   int ret;
> > > >   bool is_disable_vga =3D true;
> > > >
> > > > + ret =3D vfio_pci_liveupdate_init();
> > > > + if (ret)
> > > > +         return ret;
> > > > +
> > > >  #ifdef CONFIG_VFIO_PCI_VGA
> > > >   is_disable_vga =3D disable_vga;
> > > >  #endif
> > > > @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
> > > >
> > > >   /* Register and scan for devices */
> > > >   ret =3D pci_register_driver(&vfio_pci_driver);
> > > > - if (ret)
> > > > + if (ret) {
> > > > +         vfio_pci_liveupdate_cleanup();
> > > >           return ret;
> > > > + }
> > > >
> > > >   vfio_pci_fill_ids();
> > > >
> > > > @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
> > > >  static void __exit vfio_pci_cleanup(void)
> > > >  {
> > > >   pci_unregister_driver(&vfio_pci_driver);
> > > > + vfio_pci_liveupdate_cleanup();
> > > >  }
> > > >  module_exit(vfio_pci_cleanup);
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/=
pci/vfio_pci_liveupdate.c
> > > > new file mode 100644
> > > > index 000000000000..b84e63c0357b
> > > > --- /dev/null
> > > > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > > > @@ -0,0 +1,69 @@
> > > ...
> > > > +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_o=
ps =3D {
> > > > + .can_preserve =3D vfio_pci_liveupdate_can_preserve,
> > > > + .preserve =3D vfio_pci_liveupdate_preserve,
> > > > + .unpreserve =3D vfio_pci_liveupdate_unpreserve,
> > > > + .retrieve =3D vfio_pci_liveupdate_retrieve,
> > > > + .finish =3D vfio_pci_liveupdate_finish,
> > > > + .owner =3D THIS_MODULE,
> > > > +};
> > > > +
> > > > +static struct liveupdate_file_handler vfio_pci_liveupdate_fh =3D {
> > > > + .ops =3D &vfio_pci_liveupdate_file_ops,
> > > > + .compatible =3D VFIO_PCI_LUO_FH_COMPATIBLE,
> > > > +};
> > > > +
> > > > +int __init vfio_pci_liveupdate_init(void)
> > > > +{
> > > > + if (!liveupdate_enabled())
> > > > +         return 0;
> > > > +
> > > > + return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > > > +}
> > >
> > > liveupdate_register_file_handler() "pins" vfio-pci with a
> > > try_module_get().  Since this is done in our module_init function and
> > > unregister occurs in our module_exit function, rather than relative
> > > to any actual device binding or usage, this means vfio-pci CANNOT be
> > > unloaded.  That seems bad.  Thanks,
> >
> > Hmm... IIUC the concern here is about liveupdate policy if the user
> > wants to unload a module which was previously marked for preservation?
> >
> > AFAICT, In such a case, the user is expected to close the LUO session F=
D,
> > which "unpreserves" the FD. Finally, when rmmod is executed, the __exit
> > (vfio_pci_cleanup) calls vfio_pci_liveupdate_cleanup() which ends up
> > calling liveupdate_unregister_file_handler(), thereby dropping the ref
> > held by the liveupdate orchestrator which allows the module to be
> > unloaded.
> >
>
> Ohh wait, You're right, Alex. I just realized the __exit won't even be
> reached because of the internal pin. The current implementation creates
> a catch-22 where the module pins itself during init and can't reach the
> unregister call in exit. I believe we should drop the ref when the user
> closes the session FD? Additionally, should we move try_module_get out of
> the global liveupdate_register_file_handler() and instead take the ref
> only when a file is actually marked for preservation?

If we don't do try_module_get during registration, the registered file
handler can go away on module unload while LUO is using the handler
during FD preservation. This makes it racy. Maybe register/unregister
need to move outside the module_init/exit.
>
> Thanks,
> Praan
>
> > I think we should document this policy somewhere or have a dev_warn to
> > scream at the users when they try unloading the module without closing
> > the session FD.
> >
> > Thanks,
> > Praan
> >
> > >
> > > Alex
> > >
> > > > +
> > > > +void vfio_pci_liveupdate_cleanup(void)
> > > > +{
> > > > + if (!liveupdate_enabled())
> > > > +         return;
> > > > +
> > > > + liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> > > > +}

