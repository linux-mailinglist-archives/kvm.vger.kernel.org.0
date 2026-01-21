Return-Path: <kvm+bounces-68679-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCEdEoJpcGkVXwAAu9opvQ
	(envelope-from <kvm+bounces-68679-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:52:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C79B251B9A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C7BC6C4AAF
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 05:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13FF429809;
	Wed, 21 Jan 2026 05:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fzktm2V0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C214413241
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 05:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768974683; cv=pass; b=X5ScjrLI/R18Uw5SH079w6rOHCUYq+t9RNDr12qx8iWP3FeFJbr88rUUzIYbx31rXlzwOOVWE1jvwY1Zw/AZnetOKkGfSR8RNNGYnrM6LC0R8o8vW4QwCxtsx9u7t/0D/g+1JPAo2x08eYa3z0DkrSuDLJ1o9h/t3ik1i/gYpdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768974683; c=relaxed/simple;
	bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BMnE5TKhDYEYKjS1hK4wD0aJWK2g5p6jpNy0Pe34Rdaz1TepY4lrxBF5AtXO2JzPpI8DP+wi455crDqbaOdSGbpHupfX01X9/hKs2R8fLfFOfsB4b/D47sETrfJkHZ5KMmswfEltw21ddAC/ZUV3DK/058KFh/8APqzmWnb14QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fzktm2V0; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47ee730612dso46965e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 21:51:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768974679; cv=none;
        d=google.com; s=arc-20240605;
        b=OXwSncdUg/HAQpqamXouGIQ6arUAUJXi4RLjksGRzu6zuLQ02eMtnwN9NME0hz97bV
         zGkvjgEffbpEqTR/xouqgKDKrfKfU3oz5oNWVcMXy45Y4zwx6PDYy83XmiCaOtDrtRAw
         FqmijC+vcnVNBIJ4+/2K2IiG4Cha/kgRKvmFpuYvy1gSnDuCqdSemWlPblLFIqeQWc5U
         EjljAHTfzNzwy1vZxiYI/5yoEbLpcbjAG/OM8k6qxINPcRYiEs4Pg89Tc80H4ds9OJT+
         2gjuiFX7pOtthuHn1jsky48GZNfzSNrrNa9oiqeKmlUD0iTtUanvmf6RgrApvfK/z4JE
         NGag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        fh=AAy2pksBtLqPJBUDd6EVULsGbwnOUERNKy+w3Yb2mNs=;
        b=aWxdQckhoBw8bkD9cPP10QwoFdcBC0Yd3FJJTiR5KDriWrmp1XT1sEMRvb8fHMl/lB
         XnT9DlzAA9gRUYFA1XnBiQ335qcCWR2HOBhgEKLhHhGeSZJKVRfRmr1j13PFvbFdW/Jn
         4XOfqfs24A13UGxumZ1F2xdvvm1No59DIxQX+Z3C7iInb7x5Yfk+1BL5Mdi4Z6PcFMpf
         jx2Xow7iuomsQByrqt0liYmJmfrfPokJ91SJ9elvRW9K8G+N/k5l9S0FpJBmJr2Ovur5
         xs91tSR7vLktCv8uQln9euHd4gW9EYMyrIv7Lzk4m/sJiS4FRgEplMwzcHp7feJ8Wsme
         v8Ig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768974679; x=1769579479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        b=Fzktm2V0/f3RiRVqNd8r5aVN3qgiJexDV49Id2wNmpLp66AiGvkPwmFOdwlacpPuAw
         KRLpeiDZ3jO6ZbMLPKb0lNxx0ikiJyVXfYir1tLFuzEAFawbQQfrEdX7HV3Q6YDpx2We
         pGDWUXKLO+Z7B/9012FKnJm4APSW3hC4NcIiXsrw9z1WgUkkeW3/7E2R6t5n6CDpNlXb
         g/QUMZJ2TnAkCGs2J2AFsyA3gNf/yIPyNLYRLgMVDlMmisfgMGXdluHiaj5Z7KaBGL7N
         F0e+0WsktYsyByQ/Rrhm1oDwtuqvxSmZGB53Viur662jKHe2iFwnDRGA5XOI3933C+oJ
         3djQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768974679; x=1769579479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        b=AqUCPiP4O0laIdApk+k6JYPXIjU75RdX3fL8yYDx1qZ6rL3kRppZOOa78fk/6LxB/d
         UFKDgnyxkEMps074kznXIAS1RNoVL6DRaW2VoLVssH0evyfxrkQkagaRqDwctLIhOMh7
         hxwCusFETV0ZO7MQzDGPTZIugs6bBLPQsR3+t9PRq6nKLolmQDFV6qd0TIFP2dDVOoVU
         f1l4LhGjZBbY3Jx3xmaKlI7Ajf4Kkth+37Y1lce55k4r+qb9y04Ko6n0CRiCUSmt+t3t
         ShjWh547Z/V+aF042ZVinJzhHbMgxOoyuGDHF7eF19GKAep+ssCJlm2RtPG0IFSr2Gsw
         v6aQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0V5EZE6QyW0akaB8QKqukuScdZbPSvx2RnP8nXy15TRbzYAamRCB838kvmI/zzJ07xS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YztAhY4yFqaYs2Mt/ho73lMrh38W+6fEJ7yTdK0ccnDaEeQW9ZO
	a56jDz82NIpfGTskIsZK3ikkASbzb0HtxoRh3ZcNsd2FKnJM9XKoRYW+1OB6wcf2/hhO3aVDtz9
	g16pl/6UAomhsmU5DrsqzeA1N06RjcgZUQn7TCSBW
X-Gm-Gg: AZuq6aJ1rMDlC/FKnrBePMFCPfVQsBRLQ8BujPZ535FWwkqTfObXbo9reTkyJwHImuZ
	70KFxgZpuDokC34Hm+QRd7Rm2IJapEDeeG0hFAd/AVWuUog115obTUx3l7AJdq6eQAKp0viXTDk
	Jpj8tuTrvhKMAj5patXkHsSucENL18KVKk0KsiI0N7daySRCvUJXgraFeIXqslGNGTgbd9d6gAj
	EVTPjiiQhHR58VSHSaRIOkVBy456yLKrZzLM5kOmaVlPmOGdASymGDOY54/6OsN0E3Cn3wKyE1j
	LqVi2asl2FospLkW0zcsdBHrv2IE
X-Received: by 2002:a05:600c:3d97:b0:475:da0c:38a8 with SMTP id
 5b1f17b1804b1-480425622f1mr695955e9.4.1768974679127; Tue, 20 Jan 2026
 21:51:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102184434.2406-1-ankita@nvidia.com> <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
 <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
In-Reply-To: <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 20 Jan 2026 21:51:07 -0800
X-Gm-Features: AZwV_QgaTupq6DBMCeoCVM1hXfaRoAYoBx_XZxcQfdu6RhES7vwnX4BR3BC4bEE
Message-ID: <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-68679-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,nvidia.com:email]
X-Rspamd-Queue-Id: C79B251B9A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 8:28=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> On Fri, Jan 16, 2026 at 9:36=E2=80=AFPM Ankit Agrawal <ankita@nvidia.com>=
 wrote:
> >
> > >>
> > >> v2 -> v3
> > >> - Rebased to v6.17-rc7.
> > >> - Skipped the unmapping of PFNMAP during reception of poison. Sugges=
ted by
> > >> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> > >> - Updated the check to prevent multiple registration to the same PFN
> > >> range using interval_tree_iter_first. Thanks Shameer Kolothum for th=
e
> > >> suggestion.
> > >> - Removed the callback function in the nvgrace-gpu requiring trackin=
g of
> > >> poisoned PFN as it isn't required anymore.
> > >
> > > Hi Ankit,
> > >
> > >
> > > I get that for nvgrace-gpu driver, you removed pfn_address_space_ops
> > > because there is no need to unmap poisoned HBM page.
> > >
> > > What about the nvgrace-egm driver? Now that you removed the
> > > pfn_address_space_ops callback from pfn_address_space in [1], how can
> > > nvgrace-egm driver know the poisoned EGM pages at runtime?
> > >
> > > I expect the functionality to return retired pages should also includ=
e
> > > runtime poisoned pages, which are not in the list queried from
> > > egm-retired-pages-data-base during initialization. Or maybe my
> > > expection is wrong/obsolete?
> >
> > Hi Jiaqi, yes the EGM code will include consideration for runtime
> > poisoned pages as well. It will now instead make use of the
> > pfn_to_vma_pgoff callback merged through https://github.com/torvalds/li=
nux/commit/e6dbcb7c0e7b508d443a9aa6f77f63a2f83b1ae4
>
> Thank you! Sorry I wasn't following that thread closely and missed it.

Sorry, one more quesiton. I saw [3] implemented pfn_to_vma_pgoff
callback in nvgrace gpu driver. Is EGM driver's callback posted
somewhere?

[3] https://lore.kernel.org/all/20251211070603.338701-2-ankita@nvidia.com/T=
/#mcc9ccec90b1ca755ad9af0a821f5ce524fed0ffc


>
> >
> > > [1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nv=
idia.com
> > > [2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidi=
a.com
> >

