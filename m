Return-Path: <kvm+bounces-71544-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOAPOnTenGm4LwQAu9opvQ
	(envelope-from <kvm+bounces-71544-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:10:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A406817EEEE
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D8B1A305A493
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC0A37E303;
	Mon, 23 Feb 2026 23:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d2jOm9V3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B9B37C0F7
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888130; cv=pass; b=g8Hv9XBElSVKzaKQdPzynH/huR2LHvtPkHL8sr7ZqefxXHX1kUDXz3Uh9GX+q33OOSJNrZZAZKiOcyDxeqc+CGP20MA1bdBrdqrJHPAmt9dgyHmF7XsV93E+Z0FEE7kmy04EDyofvMjiZ/BI8QN4bfwEw2HZDXh1GdNF0ctqGOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888130; c=relaxed/simple;
	bh=Ydbc6rbyk4KLWrkHSXSI7j05eAvfIq7SG6ROABriCE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nfDqdAK8XFjClXEnGOJKspNWbfl8Gx1ZeEDyDwzyDZEOzMEewzfrcndIS6nfYoWMbmiWRF1odjQYF6fdQNSTqNX1nxdNfitf1ZDTw2r7rsvEPvkVhi46MclzVpapqCRs0a2WPrs1AlQhtDAFNcrIbDOD+1uh/NgYAA8xzbRQyys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d2jOm9V3; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59e62834439so5521676e87.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 15:08:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771888128; cv=none;
        d=google.com; s=arc-20240605;
        b=Q/X0EGd5a27m8kbmNl9nFNb1KT8qHcKwbSI+EspSbo7imf8yFVB80QtOpXXYXG9uLp
         E22sftnG8bjL9/gBrpeowntIv8vsEv6sHZte+kopnkOOl7V2E44OnxexDd1wd6C2o3cS
         CSfmoQR17BaB+d1zWZZ/SHuH2dGGA8K/ixX0arhGqi18OjpXsXAyC1HT1vu1QLrLST4D
         1Zj5licmr09jrK4XpBLVGOBP0arLB2b9GQMMMl9EaFvdsp/R+mx8J/9BBUwCmN5VTEyq
         L6K95NcRgupwDUqd3VX4T/FBsLUMMHVbjcFJhGPVShZAa9ASPFH+SHQfW4/o51i9+b+E
         SiDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        fh=VwRYYpnicQ1wznIgvKE+JzI/1O0IWDwL4VSQzrSSdIA=;
        b=UaTAN4ECR/4dNHV4HXHiD3Yrg/KxjPVmxwq+a+/LmVzkZglj6Mu9qFpkpTebna8qw/
         v8Vltyn/eXwy3aEvqAMDz3mqlP3PfeE66jp3uM/iH2LY/d04+LBfjnBFfbEVD4BQEDUC
         kqY33eiYVgLWW7Cn/RSa0is3CQVXKW54nztzFqjmzv5p7T8CugtcsPSM/VPoOiYwY6e2
         iU0/ObI6ZO7BT+RTFVs7Y4TDXmzZ9f+Qpb92zBVDC/VALa4juztyVMX/7w6Y8otHG+zY
         9H7n++8XTKOB1bTsC6jtFNq0bJ4vGHMkyh+Y5/cM4dfeWlVjWK7yZvqmp3o/szjGEeP5
         gnTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771888128; x=1772492928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        b=d2jOm9V3cdZfFgFgtcOR6roP0zV6o54zg6vrHNIGDgRJKHwNbJiF1oKLByePDLu+RZ
         RvMt3et4QhS2OXYEZLCppfk879ITR1XE3hdUPE0ThGM4C5mKeUT1c6Dnw3A0lQECdVkl
         MLoG2wBeARg8OaPUQOIlRAOfeFOFaPvyTTni1e89jNXDRH3Y9eV5MY26WNXGwo94WMnt
         BXxRYZWJ2B8+cz37pMBIO8DoV8yI9noiFuHZhCyj7m7o3+hGADuNCMWgfkYrPxRDSG8F
         BiW+Yp8TW7QxilchJG8UantylCuotfQo/2+FVQfg77AktnxQ2HvZ5eoU2Dy5tsafT9wJ
         KNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771888128; x=1772492928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        b=uDr+oT0Ul/+3wS7EDYO4dUROSogNuilfCR6dUpVV3z2PScucexMniyrnZhIcSsko4s
         XhinwnZfLHnxsPvKNO9VBtF7Ki7QWCtbioI4SfXOPZi5ThcKsDnIaUFZKsWEDOO4aVkB
         V4poEm9EZUQ+8tEtbLU2aFgTJYqjqb3kivzZNmJaRl+MvpFknxHeZcrKYOCATokH3L3p
         0vEhsbcCf+Ouc+NO3Wf/C0Gv6l0/8BGXRmMRa5BKaQVA9apNKYHAJz9IVCevGMNbRPxF
         m1QU//z2NqnnuFeLIaanmgpIzpKcLfvmuyyPSdFfiQ7uIvQfjV120lVB+fiKQ80WSJqz
         /khw==
X-Forwarded-Encrypted: i=1; AJvYcCXv0wUomEdRzl/oBDwCE5YYkczHnVt0UiKOjdzqBycUx+yKbRE3P7YeDmBycLjpCe98gmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFmJEP59uciyXNtW1MwJjsctoxdzUC6ND+WEObyLXE8Dw3PTDn
	AZh/+uuPr4AHlAlbBWEnqe3020D5+cG1KQN2+w/2URYsigzK7UAlLGK7UbZ4jtKwOoW27NrL0JA
	9iOz1DDPloPNqx5nqcPAbe1DfnwaPBek1h/xksCjI
X-Gm-Gg: ATEYQzw/9OE+Atr3ioR1ZOtk5FI+x3Nw6P63rXvAGRkIlhVDB+q7nsq/RpWGU7Vr6iO
	QwHt+rEmLAeL965dILxVVLIBmUijeqtqVC/awcXgt3omyOuLoH4AyUed4CdZp2SGM3i+kwReZnS
	jcCfsbzKYg8DF5OJWz+0EqHDJbc6ASJGoyIasBr28CqxKeKqmlVyZ9jXXZQ0sIkNaD65VKX1V+i
	/Rk5R54Bd0ntEZHXzpSwhFrOyxYiQiRd/ZBWaC2dK8SSN7tOZ0VYz4Fq4uq8FMhyoSnglPhrwYA
	7Ahsaqs=
X-Received: by 2002:a05:6512:3b9c:b0:59f:8546:1899 with SMTP id
 2adb3069b0e04-5a0ed87de41mr2986457e87.11.1771888127316; Mon, 23 Feb 2026
 15:08:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
In-Reply-To: <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 Feb 2026 15:08:19 -0800
X-Gm-Features: AaiRm50_OD8BarR0N1ju3iFQZFALazFmYS4w16LFHF58C19D7VPNrgpsKvMORCE
Message-ID: <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Samiullah Khawaja <skhawaja@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71544-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A406817EEEE
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 2:04=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:

> >Drivers can notify the PCI subsystem whenever a device is preserved and
> >unpreserved with the following APIs:
> >
> >  pci_liveupdate_outgoing_preserve(pci_dev)
> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
>
> nit: Preserve and Unpreserve can only be done from outgoing kernel, maybe
> remove the "outgoing" from the function name.

That's reasonable, I can make that change in v3.

> >+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> >+{
> >+      struct pci_dev *dev =3D NULL;
> >+      int max_nr_devices =3D 0;
> >+      struct pci_ser *ser;
> >+      unsigned long size;
> >+
> >+      for_each_pci_dev(dev)
> >+              max_nr_devices++;
>
> This will not work for SRIOV as new devices will be registered when
> sriov is enabled and the max will increase. As we are not handling VFs
> with this patch series, this can be fine?

That's right. Since this series does not support VFs
(pci_liveupdate_outgoing_preserve(VF) will return -EINVAL), I dropped
the logic from v1 that included the maximum possible number of VFs in
max_nr_devices.

Once we add support for preserving VFs, we can update this logic.

Another way that pci_liveupdate_outgoing_preserve() could fail due to
running out of room is if hot-plugged devices are preserved. But I
don't think that's an important problem to solve right now.

