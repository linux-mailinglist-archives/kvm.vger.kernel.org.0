Return-Path: <kvm+bounces-72407-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEZhFwzUpWmvHAAAu9opvQ
	(envelope-from <kvm+bounces-72407-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 19:16:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E831DE53C
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 19:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9775530A92F8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 18:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F158E378D73;
	Mon,  2 Mar 2026 18:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bTMZwI8Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D188A340273
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772475300; cv=pass; b=Y7xg/fubpAH+itdEsmDpB02fQxViX41lqPHMAXKZI/cJh3hgm7GksnKpdmUwFKljUFdlLzHskJVoG8xnkrCNNjf5/8Z2+PjPYm3eo8h+2Ju6h/wYdcQUev2r28TQ3ZJtYNa1WJx2hfaXSmaIIZyUel/7ViwJCFlKgBnwCO3Gi7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772475300; c=relaxed/simple;
	bh=BTi+4ARakd9uxctTdqjtJnxTFNq/yPeOIt/d2iLvfuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XvP/apoN1a++RF2d5/lsKEnsek05CkvtkGjKDwkoqlvD3+6S1cpa24q35u6awVOscCg/JgovrVN65yF+ggfaP1w6F8JNBZDl1UUX3bQYzOxj480FQ8cr3TgnHi+d5v2xJvv7TCO0TTA0MVp5RygRa8diTBRR1i26+3pLyKc5h5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bTMZwI8Z; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-389e2950f54so12974461fa.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 10:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772475297; cv=none;
        d=google.com; s=arc-20240605;
        b=ZQkt208eIRPp2O0tlBO1wGenuWL2+/SNvqOt/YK0iOwVSbp3gyRv4kpDAsLZUcSz/b
         B7O/9jxm+JdMeslwcTPok5c2uumhBwDvQqVYk4vRQao2ljlXCum97RBGwIEkM82AVRl+
         uz8/qpP0QXm7atl9Me0um6BxkKm0vkm8Q3IY1iCKssUewMiA6wyV78ZYNOct9P62HqCk
         eOdLXTfFtk/T756guw4rwRhoRrRU2HNpT0Jy7+3fXsL08mpUPphffnc2oTQmxHta7xuU
         qXNyip27c6x8sfZNG/pF3bQinOow95SEfzkyzp7ddoPeiz0TT0gHbgWMcvArxujkb1v2
         yoEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        fh=0C59ahSAxTvTXyDkXi6J2oB3+ayMFSHn13qiiEjtgrs=;
        b=jfJi/zwjs5CevItskXF+9Xxpeqh3eHksY5fY6HiefMSAmixZ4QWUq/pRNBeZMQWuWO
         f0dhsa8wWsfgqapgZ+jPpdjZjiieHyH9WwC1GKQXm3C1VDUmij855FFtKm0BzGTtf8yu
         +lb6CTDpiv5a/ZUC1qbNZylGZ2b8PWAYEwPZLtLWD7KtTYLGumy2KPW1XzygfLBxxiG1
         QFgj9rTQxmgc0qnbW/8GSl6NWXvwIctoqp+r91iFvKnQmfvtCDRHPkFYG0tY1zXdtCTN
         5iD53XgUAZaQttpwJE5iF2FUxAfGj4KnE14EZObdYs+K/tKgugIYVIaCWuRuR46u0Oqc
         l7NA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772475297; x=1773080097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        b=bTMZwI8ZdQqnj4AgTxkJe6IjG1pfNONBuMwDLAvSla2GHqfEkX0h99WhB2RdJaxT+T
         ujJn1WMtH6ol/zVwaursQALwAzikhqQRDXCXEVQw3oUlr3T6wYY/W1MLeTLqR1U0ivhK
         o6px54O0EN+5JWoPVTj/QKoXmNd1VRfu++gSIhoN5AiBjhlmwEUJsUfn/rAaKxPB66UU
         TgVupI8uG5Ma/tMs0zMwft7t0/FZmOkm4e6VdgXJ5uE9PhQ3K1eQqmyVK7Xy56dQ0n+C
         EdIjgD9nrHWAmhLtECRerfHkXFdZoUUZGd/7Y3fpDuU4gxAd0M745lS0yWkTmNo9M+Rj
         J7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772475297; x=1773080097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZw46QiejIxPJc1G5DNZGnj4KsLWM6jIVrYLGkqOkHQ=;
        b=tw5onlVUTIyv04zK1m2b5mlGJO0Veb8ksELxzE5kb8jcGIlcTvq2DkZ1YwvDEADWEu
         ftZ4DJDV2hZDxxrXK0EnYuO5VFve9DSH9I0m7QzitydsVB0PyC4ALebBk1nhMES7bRwc
         uW4tYP8FAoCZxCsm0hWIig2FDepDFJ/1QYSWjouovVyM2MEXJX3WCWPhHUEYiEfQGyBz
         WY8WIyFAypvUzu4LqRtNSM4CTwIsrZ3uccah9K2xbpHPqCQ6fXo7zdO8KzLbd/cYpOQj
         mxksde0RYCKysjToxQW3lRNWH7KiPF86O/bMVw7/A8/wMxbdD5XT7VTP6wc38mhNBg4V
         M+qg==
X-Forwarded-Encrypted: i=1; AJvYcCWC1lD6ZAUU2OESTlkMgUQgbyxmJP+W7caQ+IxVuC1Ssra3l39nzis2AmeVsC9QjhG2/1s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8W9zy49CGAd4ZirxGZvVZBJfiH/tRo3Hb3x7zFveNvBt0v39m
	5qCkB83evMoGVWg2sumT2tdEiz9bBTzJFSqLESiuBZXE0jNHO2QO113u8+b4DRhX2n7ZoTnjwCm
	0ZQmf7wWu2/WcsUiLWtivk9FlCbXCFEd0E1gC4ABX
X-Gm-Gg: ATEYQzzGNtUZAengyHWaYo9wo8tALbdeuGgfiGpf0KTgWfFYGdTiQ8EACmPgB9bGB/V
	Kuq/WSvhs/ajePbeiLTLoXIrE5ZG4tI/Fz1FPJBCOEXIaZNnNkrZdGoz/rq0yHygpAiM1R+bZrU
	9pPrWCMh+bapN40dBZjYvXEzQ7iI2DcXiUhLBcbycb3q3nLwOVRA0JukHshRODl1rECeEzoNd3w
	JWquaGLTUnOFZEZbTZZExpCOCCbSlKZny8QJxqmNtYbsvNCOpIcp4nzBKavizakarXc7tDzg9to
	AwEX26M=
X-Received: by 2002:a2e:8094:0:b0:389:ed12:9731 with SMTP id
 38308e7fff4ca-389f1e29849mr81213251fa.16.1772475296490; Mon, 02 Mar 2026
 10:14:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-4-dmatlack@google.com> <20260225224746.GA3714478@bhelgaas>
 <aZ-Dqi782aafiE_-@google.com> <20260226144057.GA5933@nvidia.com>
 <20260227090449.2a23d06d@shazbot.org> <20260301192236.GQ5933@nvidia.com>
In-Reply-To: <20260301192236.GQ5933@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 2 Mar 2026 10:14:29 -0800
X-Gm-Features: AaiRm53G4DyTBgh8HthgkNXd7A4lLjemXkfCrH3k_RfrPJCtk91UZa8WxDGHRMs
Message-ID: <CALzav=eJ63gitLatAerrjEc+o3VXcRor3XwA7_o2PmKYnMwCuA@mail.gmail.com>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
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
X-Rspamd-Queue-Id: F1E831DE53C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72407-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.993];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Sun, Mar 1, 2026 at 11:22=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 27, 2026 at 09:04:49AM -0700, Alex Williamson wrote:
>
> > Not only fabric topology, but also routing.
>
> Yes
>
> > ACS overrides on the
> > command line would need to be enforced between the original and kexec
> > kernel such that IOMMU groups are deterministic.  Thanks,
>
> That's a good point, I think as a reasonable starting point we should
> require live update preserved devices to have singleton iommu_groups
> on both sides. That is easy to check and enforce, and it doesn't
> matter how the administrator makes that happen.

I can add that in the next version.

> You also can't change the ACS flags while traffic is flowing because
> that changes the fabric routing too. This should take care to enforce
> that restriction as well.

I'll look into this but will probably defer it to a future series. We
need several more pieces in place until we are ready to support
traffic to/from preserved devices during the Live Update.

