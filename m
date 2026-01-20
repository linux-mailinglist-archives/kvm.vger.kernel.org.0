Return-Path: <kvm+bounces-68631-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJ/wGivNb2mgMQAAu9opvQ
	(envelope-from <kvm+bounces-68631-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:44:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F22DA49B8F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85F0390DBF5
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B4A4657D5;
	Tue, 20 Jan 2026 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lHA8HEE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF22333421
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768926534; cv=pass; b=lcXOdQTPJ5urARlK79VpeTIcw+mQQC0xZQ18UlyFpjkDrLQ6mjaKAZ6ziDYzuFIWk4h+9Ud/kSGGeTLdu6lT5PGXxsp2/rC5c/hypfUAIOS0yfP+yMWXYTb4J4QrCYhSAIx4SwEUjdnPikBzWIdRLLzaZBuNoNs1pgkrpjd9/XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768926534; c=relaxed/simple;
	bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZZtnvCKHHuTQruzclcnLkzqNh9bTAvpxU+K4Vfn6BmHmjtnuJ720e5zSbUGlZJTy2sdd1bZyzfqrUF2nO6U33kchEe7xz62ad8dymD4rZOgDgT4WDLwxlXE60Ct1+vaTh/VqgE7ZpQgj3HyyQbhegLGahTIyPVDogfklH/RUhds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4lHA8HEE; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so187325e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 08:28:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768926531; cv=none;
        d=google.com; s=arc-20240605;
        b=EtfXk15fEvI0Sko3k0cVMnKL/K5GJPpkEuuZyyld4mhDHPXxXsSfTzv7LTiHS1A9Vb
         3Y8MFHK5pIsiGwcm0LKIo/fcNWg1CP1MC9RkCuKTMZL0vBg6ctBXmZ2c6Af7YiNQRGDU
         Wgaw8QmXwfdw71W2DfCV0sectqJkCvB9NiRi+d7IxqiJ2bytSkKOFpYL1tk/yvQbGFM6
         81pL+wM/OmtU/KH0vPWyNsfhNXkWqJzXO5V5eG/4Q+eR8ddCuOu76r5b6eSQMcIECmpQ
         +1hFHcHondiqmYxclaiRYOYUsKqWSp1s7Sa1ASkLdx9rQKssvDf6hO+nzUueZYo4LmhN
         JIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        fh=EV+t/bqwbjp7tPqd4FTKTpRBjvVXMcIEofyrK5fzsNc=;
        b=UWaU7tsy2ZKhRHkMrE3EcR2xL+jT2vQ/w7pY/4qigN5X1jZUE3kpe2+hVtKUbHB95g
         Jv8Nw97EX/WtV1EaPOrkzGJ4Yt2c+XAyThjlV9INbGA5MnQaP3AVvmwoIIC1KwimdMDi
         5pc4jJlWd93qvPSn0j/2ayb4JHoVDEO6F6pl4TG4yDUfZaavNOcskIF8ytgzB8OZVOkR
         OZwoDkJz17cLWC1dpv14xHbQIh5fXOs56TzhS2VDhW35Cp138ODC+pOTq2weiyt24BmK
         j7W16MMrzD8vvvupqJZMsT3eNjkgdmJ+lZje4EHjUvrLmXKLQDkRdSGviGWX7kMSBSUM
         ndMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768926531; x=1769531331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        b=4lHA8HEEeZgP/YUBLDBV82SFnUFOrX7ylbWOuMGnNSNoaKA04+jhRgmZ+qhYOYg99+
         4/q0soxE3Pa2XFcrYLmgKbAlJzzUeXdCerbKtzNXuFNh8r+/cTLMnFBao6OJleTZCeIz
         7ZaN1ml6p0rnTuTI8HhEKdPtwtLvCZI/E10j4e3HUipvZOeye4xd57FoHWSkO5k0Jg9w
         HaS35CLHn17cCXxobQzdoK4p7kDuKI73MP/UC6nfSP6Ged813+pG2rFFedOjIIWn2T9I
         JhJM5JOb/kOG+hZf3ZnrAuZ2+p5MpEP7yBAo4Y5RiLM9Ie9JT+0EVbUUcW/ZVoJ9Ub/R
         hIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768926531; x=1769531331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        b=vr5S70Xpukrdnv65YWN9fb7gwCtd5psiAqQ4ScKsJ+liLtXBV+kVl5vES/KifRk+r6
         jd+9+ucxw73aUDjKn4L7EltO3UP6jQZBJqRULOLC6RJWsvyd6V/RyAcXYTe42Pa+MH/k
         5IRBuVq8cSETHZTrHGPG9PyAT2SZXMkHa2apg95dz/rULZfaFtxW3KgcevpegYMm58UC
         XPrqIZPGSCaERD68AjgmH3JtzrmXZVWxLo5TaAqvMnOD7Fre/+fohFHC73KBVcnlCEiB
         o4l2ErX6p0a+1W0j9Ri529f8lGIatWnNCt1RSbTdpQTdup3ZzBi2WI0Y93VZhEgILPB2
         R6Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXwd+NaQPXiCGgYchA7X9Fxqa4pEkey/9ZL7YoL7r8CBZgjhmI7eTKaoCbdChWV6vfTM+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE+sVgjPhFBnXLXlsrdMzdRi9ecOpdI67OTLwS19GU+IPpfYsU
	AzAFWDnDdEnZp8oBvH2vnf48X4mvRbX1NWcm/PH7eknfl2E7+255Rstn6iHtk9p+gxa7l53rtmk
	zhaeqDZ2mr8NlQzFwIFn5m40W3RVNLM0LtZMcC+Vt
X-Gm-Gg: AY/fxX7/sh4SGd+1NI85sqVN81KPBvVO0cxeQ+hrxnofBG8Q88W0buAxcGNOskcvxa8
	otFX9EL0nzZtkTsHg2o4rwJ2k6AYuhNhr6pwg//Ona2HeHY1Iv34BauV+owpmh3GevLWT6FrOPU
	Yz+UpzNNhTCkZaWqLa+jcK4Rjz23ermNh8EtXFGwmkhifwpFXgCkAhy/KIWQFewnfGmZTow6bpk
	lsXSRjfKYhSCVAfCH7xqS0KEHcYyaWUZCxoRp3GUwnLfKK15wN32EGUgGmbw0ZD3hkoE/Kxb2bN
	06aGdaP63hn5CO98QTQ2buu44T2l
X-Received: by 2002:a05:600c:198b:b0:47e:dc0a:8591 with SMTP id
 5b1f17b1804b1-4802788e239mr2686005e9.2.1768926530251; Tue, 20 Jan 2026
 08:28:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102184434.2406-1-ankita@nvidia.com> <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To: <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 20 Jan 2026 08:28:38 -0800
X-Gm-Features: AZwV_Qi-sOyZ-R41AFqxYbo27tCfgIMGnJS7jLDAEJnKTv2-_C3tqbgzg63dbdA
Message-ID: <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct page
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>, 
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>, 
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>, 
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68631-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[41];
	FREEMAIL_CC(0.00)[nvidia.com,huawei.com,gmail.com,linux-foundation.org,redhat.com,oracle.com,suse.cz,kernel.org,google.com,suse.com,intel.com,alien8.de,shazbot.org,vger.kernel.org,kvack.org,amd.com,baylibre.com,infradead.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiaqiyan@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,mail.gmail.com:mid,nvidia.com:email]
X-Rspamd-Queue-Id: F22DA49B8F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Jan 16, 2026 at 9:36=E2=80=AFPM Ankit Agrawal <ankita@nvidia.com> w=
rote:
>
> >>
> >> v2 -> v3
> >> - Rebased to v6.17-rc7.
> >> - Skipped the unmapping of PFNMAP during reception of poison. Suggeste=
d by
> >> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> >> - Updated the check to prevent multiple registration to the same PFN
> >> range using interval_tree_iter_first. Thanks Shameer Kolothum for the
> >> suggestion.
> >> - Removed the callback function in the nvgrace-gpu requiring tracking =
of
> >> poisoned PFN as it isn't required anymore.
> >
> > Hi Ankit,
> >
> >
> > I get that for nvgrace-gpu driver, you removed pfn_address_space_ops
> > because there is no need to unmap poisoned HBM page.
> >
> > What about the nvgrace-egm driver? Now that you removed the
> > pfn_address_space_ops callback from pfn_address_space in [1], how can
> > nvgrace-egm driver know the poisoned EGM pages at runtime?
> >
> > I expect the functionality to return retired pages should also include
> > runtime poisoned pages, which are not in the list queried from
> > egm-retired-pages-data-base during initialization. Or maybe my
> > expection is wrong/obsolete?
>
> Hi Jiaqi, yes the EGM code will include consideration for runtime
> poisoned pages as well. It will now instead make use of the
> pfn_to_vma_pgoff callback merged through https://github.com/torvalds/linu=
x/commit/e6dbcb7c0e7b508d443a9aa6f77f63a2f83b1ae4

Thank you! Sorry I wasn't following that thread closely and missed it.

>
> > [1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nvid=
ia.com
> > [2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidia.=
com
>

