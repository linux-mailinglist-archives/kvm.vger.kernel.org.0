Return-Path: <kvm+bounces-72239-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAQABPEcomkqzgQAu9opvQ
	(envelope-from <kvm+bounces-72239-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:38:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 725691BEBE2
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CA253142ADE
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393D847AF46;
	Fri, 27 Feb 2026 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVtgg8N4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A063D4118
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231777; cv=pass; b=tbUhuJDQDIpLsosW6tn28LSMpxTmQ1kLH1JdS13E4s/wTASunmhGQ/0lxSzRJklsLJjqg+yaFVAHatr2w3iI+Nsw0LUFUXSgJizqEerrqqhc50DrNO86numWtiY7B3B0Dv6W1fi46nEGLl19VdkI7aRokDiAN9vBLMvVzus1+dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231777; c=relaxed/simple;
	bh=berk4tsWZDjmNM3orug+7lqR7AAUJi2hBtoYZryZJRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDpLy26Hyexj2yXyKGYI7XxutlmfrjfnwBKhDgSG3x+74sa0+plQ++/vMYmB8pyvlprJcJtTxYIj3tJG8lLf3eVkbPJx/muSH6NFMBhdLefXgO/bj480ZZbWbvtvyo0oNsbyw99TJfKEJBsIMOxiVGruNa86xiy4dyDty5QVmW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVtgg8N4; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-389ff3f41f8so6388611fa.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 14:36:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772231774; cv=none;
        d=google.com; s=arc-20240605;
        b=c19gvfM2idGu0Cy+al+q2Lqjif4zCR+HELQviiyOGxjQjxf/lYuByhS8RxDeTS6/4a
         I25sa4VeSa1p76sdsiuZ/ZLBU3cL55Z1Ucn1vnKPZg1RNmCQsS/PbZxTgTq1tbiKekD/
         KbKQKjmq/aUohM0HbxBJaOI91oeHPfqsuT6StdAm9F9yQHm3NLvcyVQGruPsPVhqOPr1
         mms4oO4bYH0DeSFAzHfPYJyDAqRcSrC36m0uycmXJry+KU3n2ZfFxZlDlUkkIfHVNEdi
         VzDy24Lbm1LJHSQzR8be6cCLT5CPyMQHfRA7aUk6XTroIOZseDn88QLYJBSuDXtDt3RO
         UAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        fh=wBp8WF8Mhujyt/2oFlfeSE7Ns0T2xLYQMa7F2o1MdW4=;
        b=OwyCaZPSNKHarqBIzNa+lu7P8rqDUoVo1UOpqfN0War3+l5dvROmsiz4/iyNycEc2V
         JDhXT8lRS5J40Zpdn0nzIFh8He9MtHbRiblGq4eCulF3eb9lxcDVqll1uqrf1HRQ68a1
         YuneUGu1o8g8R8c0KirtmUDD3wiHHIYGdDLRBTYBIpVnPomzay4EGp+iDfRCpkDd0H9E
         XE1SSAj1ljsu36T8i0f6kWdrpLYu0tWjMykWWGjFSstsOzajEBJC5zDbsniAgwBHBmtc
         dMl5n+TdC5W2NbUKIufq1VqnBbJX40/FNCG5UgW5Y2eEwtYOI/rTwSdT1Weuxzao7NSj
         POYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772231774; x=1772836574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        b=iVtgg8N4xFAGPLbnedfvEO4hhvKnGvP7UyMRM8KNH+eRdwdfMqqovCE3l8sBVa6ykH
         dgwERnHdkIXtDTfJlvMTL4CPWg/D33OG0kMUlWVIlfaqRd5xcIN0DJ/FtkM9s4Lu2QMy
         WGiPz7ev5mcyneZ9lN8vsMUaL3iaVKGlhSyTBDzp3aLV9dWCfM2D4GsdaIEE210HdBsC
         8d66lXztqqEghm8qxhnalaC2afyo2oLfzROB0aMp33KaN6twVI2NS5gze19c41D8ZnfW
         u7zCOuAqBq+FHxc47uRZ56jb8QOLuhhmkdl2Z4cm93JqMKUM53DSJ872cAzZidSBDGwz
         jObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231774; x=1772836574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        b=cPkUlSvy7E+bePGY3Nm5RS8MIWE0lpHwY7JW1uDV6cFGBSL0kKy9f+HMEyt36m11vK
         i1vf5E8CrZXaPMTP/a2fxm3AbnkJ5BTl1829h+5X+iAY3SXJwFDQyvF6BwOys2co6zI8
         4S8XgNHe6HzgqLzwih60hxL7QOTazV6E+iVrzIldQcFw6DUWH8AZjhUVCV2jG6gxJZev
         HTMfOO1JSm6ieg+kMGkjvYNSXaovqSZSzJy4U/IeMRcurfRVZBoNA78/ayWY8FyYBFlE
         QVOMlAqNZCRv0bhf4dp7CJk7hb+mR1d7YOm+q7HrPE1FtGy/3LK5Sy/ZwVJ3Oa8kQhfR
         UAFA==
X-Forwarded-Encrypted: i=1; AJvYcCW6nb1LLePhIXWkGDw04w0C+wh2wbMeFK6VOE1UYS+ukavHryaMvhWTgxRa1OGXLPb/ZtA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWTjGdQ5EzpCyTLEpZCqw8UoYZAh97pO1SRa6zM/g21VeuzP4V
	9tbltJPpmJJhVqpRP9rUC/sMOZ8qpLNA1GPGE6AgJtLlPxTDabbUMxTAWcqhl/8jxfn6VEkvXcx
	Z+wIEiQksmZthkEqGm5bGWtKd5V35iWt6AtJYEbZL
X-Gm-Gg: ATEYQzxe4fT3IRZW6UEyq1tL8qS5DHkndLtKgtJv3qCQko9SOM/v8NsTYScNZ8MOoPA
	3RLup951+2FwiwvDkhvG08LZnfAxe3mwtjF1ysDAGJ7V6KdvXC2uhup4ks+WEuN5jIL89M/coqd
	Daaoz7YENHgR4onoX2ZAyFYE59UQjNxcx7R87q0dwfZaWNRvcYDVuvINVQYBl4sKB4Po9m0NKNk
	1z8D0P9dx2e9WxlgLofOtFubBVfD/4X2xanCFoMylZkyPI6ELrVXmB+QINhXHKNY/flNY/27qwZ
	Zb7Byok=
X-Received: by 2002:a05:651c:150e:b0:384:9355:6a7e with SMTP id
 38308e7fff4ca-389ff144dcdmr32194241fa.17.1772231773691; Fri, 27 Feb 2026
 14:36:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org> <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
 <20260227152330.1b2b0ebb@shazbot.org>
In-Reply-To: <20260227152330.1b2b0ebb@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 14:35:42 -0800
X-Gm-Features: AaiRm50D90uQBM2OzGa-RA7PnZi6CheC4aDHB2jS6rwjE4obcECpnTV5MTFBKgA
Message-ID: <CALzav=fq-3J4WFD-uNd5zJ_Fx2sHGv0vL+EtpV7WvGO8ddG5mw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72239-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,shazbot.org:email]
X-Rspamd-Queue-Id: 725691BEBE2
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 2:23=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 14:19:45 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.=
org> wrote:
> > >
> > > On Fri, 27 Feb 2026 09:19:28 -0800
> > > David Matlack <dmatlack@google.com> wrote:
> > >
> > > > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazb=
ot.org> wrote:
> > > > >
> > > > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > > > David Matlack <dmatlack@google.com> wrote:
> > > > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args =
*args)
> > > > > > > > +{
> > > > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > > > + int max_nr_devices =3D 0;
> > > > > > > > + struct pci_ser *ser;
> > > > > > > > + unsigned long size;
> > > > > > > > +
> > > > > > > > + for_each_pci_dev(dev)
> > > > > > > > +         max_nr_devices++;
> > > > > > >
> > > > > > > How is this protected against hotplug?
> > > > > >
> > > > > > Pranjal raised this as well. Here was my reply:
> > > > > >
> > > > > > .  Yes, it's possible to run out space to preserve devices if d=
evices are
> > > > > > .  hot-plugged and then preserved. But I think it's better to d=
efer
> > > > > > .  handling such a use-case exists (unless you see an obvious s=
imple
> > > > > > .  solution). So far I am not seeing preserving hot-plugged dev=
ices
> > > > > > .  across Live Update as a high priority use-case to support.
> > > > > >
> > > > > > I am going to add a comment here in the next revision to clarif=
y that.
> > > > > > I will also add a comment clarifying why this code doesn't both=
er to
> > > > > > account for VFs created after this call (preserving VFs are exp=
licitly
> > > > > > disallowed to be preserved in this patch since they require add=
itional
> > > > > > support).
> > > > >
> > > > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > > > preservation in support of vfio-pci VFs, it seems like this only
> > > > > supports a very niche use case.
> > > >
> > > > The intent is to start by supporting a simple use-case and expand t=
o
> > > > more complex scenarios over time, including preserving VFs. Full GP=
U
> > > > passthrough is common at cloud providers so even non-VF preservatio=
n
> > > > support is valuable.
> > > >
> > > > > I expect the majority of vfio-pci
> > > > > devices are VFs and I don't think we want to present a solution w=
here
> > > > > the requirement is to move the PF driver to userspace.
> > > >
> > > > JasonG recommended the upstream support for VF preservation be limi=
ted
> > > > to cases where the PF is also bound to VFIO:
> > > >
> > > >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> > > >
> > > > Within Google we have a way to support in-kernel PF drivers but we =
are
> > > > trying to focus on simpler use-cases first upstream.
> > > >
> > > > > It's not clear,
> > > > > for example, how we can have vfio-pci variant drivers relying on
> > > > > in-kernel channels to PF drivers to support migration in this mod=
el.
> > > >
> > > > Agree this still needs to be fleshed out and designed. I think the
> > > > roadmap will be something like:
> > > >
> > > >  1. Get non-VF preservation working end-to-end (device fully preser=
ved
> > > > and doing DMA continuously during Live Update).
> > > >  2. Extend to support VF preservation where the PF is also bound to=
 vfio-pci.
> > > >  3. (Maybe) Extend to support in-kernel PF drivers.
> > > >
> > > > This series is the first step of #1. I have line of sight to how #2
> > > > could work since it's all VFIO.
> > >
> > > Without 3, does this become a mainstream feature?
> >
> > I do think there will be enough demand for (3) that it will be worth
> > doing. But I also think ordering the steps this way makes sense from
> > an iterative development point of view.
> >
> > > There's obviously a knee jerk reaction that moving PF drivers into
> > > userspace is a means to circumvent the GPL that was evident at LPC,
> > > even if the real reason is "in-kernel is hard".
> > >
> > > Related to that, there's also not much difference between a userspace
> > > driver and an out-of-tree driver when it comes to adding in-kernel co=
de
> > > for their specific support requirements.  Therefore, unless migration=
 is
> > > entirely accomplished via a shared dmabuf between PF and VF,
> > > orchestrated through userspace, I'm not sure how we get to migration,
> > > making KHO vs migration a binary choice.  I have trouble seeing how
> > > that's a viable intermediate step.  Thanks,
> >
> > What do you mean by "migration" in this context?
>
> Live migration support, it's the primary use case currently where we
> have vfio-pci variant drivers on VFs communicating with in-kernel PF
> drivers.  Thanks,

I see so you're saying if those users wanted Live Update support and
we didn't do (3), they would have to give up their Live Migration
support. So that would be additional motivation to do (3).

Jason, does this change your mind about whether (3) is worth doing, or
whether it should be prioritized over (2)?

I think I still lean toward doing (2) before (3) since Live Update is
most useful in setups that cannot support Live Migration. If you can
support Live Migration, you have a reasonable way to update host
software with minimal impact to the VM. Live Update really shines in
scenarios where Live Migraiton is untenable, since host upgrades
require VM terminations. In the limit, Live Update can have lower
impact on the VM than Live Migration, since there is no state transfer
across hosts. But Live Migration can enable more maintenance scenarios
than Live Update (like HW maintenance, and firmware upgrades). So I
think both are valuable to support.

