Return-Path: <kvm+bounces-37545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88308A2B800
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00C741889373
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F814161310;
	Fri,  7 Feb 2025 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="lixXaRF/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240CB14F9FF
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892348; cv=none; b=dBLdvBiXAGUli3RWi2ZRGXrK4Op8jax+1brv5LVOVXpqHUiiULfjD8CG78qB3A/DzBplsuCWCPJzy6NNGuXgFJiTPT0X5blwQBRRH9ujZ5GvbbOpZvQKMWRUPXHUC9i+ahrQ9QxgKboruiOT0zANKPyQ4g+5czASyHiFLUNJkWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892348; c=relaxed/simple;
	bh=RWD/jJAmsYyNOn211Bbue2KjkmRhyD6nM7GKyaekbWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=exvCUP2hBSkou1PBJzBHu+jYfIrcWbqtKrJzao0YPciDYwPRKnvay6ZXNgo/nP7/sEb/YDLTZaz/2ZshNL8E7vpeA9SO+f2mG/qf+Z6twBGcvosPYRqaGq5sGTJNYSHF+25SnDsp/5W5nS/T/k0Cr+3/GGFjca3qHQXM+n+L5NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=lixXaRF/; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4659F3F291
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892342;
	bh=GTkrXOMiM73qeeJp4KtVvMnuZB30bb4oVfWJGcMkjrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=lixXaRF/AVw4ivLiHknu2xhV8/7dEOfvktgFIzNy109gWEAHAHpyDvxBtl36yW5cZ
	 Gb0y+KHLDagwQuK18G4SwcU87vO+JKsyuZ+Yt1zOEpB/e8KuCu3rzIJ12Mag2LR4qa
	 qa0MHGucJJjzoQmjZKTTKer6omJt9M8d2A8bcl+9jRNXGeF24r7zp+aBBnOom6k1IY
	 MzF2IO/Fs89nvyWv1AsorHpMw58gcSUEF94T2XdlxDg+MA1PvZG2tS5Tw+mTJ8lXHM
	 iCjfWKtFmaodRR5CTtPz6cXI8Znx+USuY+t3B6INu80zxoHZZfF1JKAD9eo/gzso1n
	 Wj6H1BqyTeeJg==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5da14484978so1686065a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892340; x=1739497140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GTkrXOMiM73qeeJp4KtVvMnuZB30bb4oVfWJGcMkjrM=;
        b=sguUFJuVyVqKH7aJ/+aS6sFfkVBgzTt5828Bip7qWm2pI98lX+WDsRSWcT1nyuJQM3
         KfddZCIcsRbmPzlLjb3kISxrIDwc+NFj57heIcPfhyOQUQONJXJpsuJeR5T1SjVu77Uj
         wRxMeDIGtU18tcRdGxWzpLsdlGjWvIxMY82WekYmKoq55sTBKxdaWqHzgbjZyol/WAQW
         1hJTplYq3oj4rubzDAUufz8QdbTz3gYSVhQ/esgIcJ+KUXibk5kkwoZCmjzTsj0CjHiJ
         n4RUBwnKQy+umIbCWWBc0WdnVn2j+g9T6dy+5s70gx6072IRBPaICOCg8TqqrBbV+yW0
         JK8Q==
X-Gm-Message-State: AOJu0YxR6poVX637ZlQUUp7q84/whew412DY4SIlWKgEjF7KSttn7O+g
	2W1i+rjfrQxxVsrZvLF1GguBMg7ft4yzrW6BGyQNkqYj2lqz/cbR0sjD4CQ2FDeV9LbEMAjytRP
	CDl439sCD6b2zCCpwrEeNXQzbzzWTN/L8NZe5AmsKlfnKR9MDcc3LFyO2SZgKd1r7espSo2NIV0
	eiHaJD0VMzTDwPIuwHv8x3HTq5/o60P8kyofzohmBY
X-Gm-Gg: ASbGncv27yfYrz8dvpzDF4lQBqteUEMClQNTiCWX21YjpTAIuwLceFqvtm4FQh4idQI
	Uigr/KCe2k9gTtLVB23TQnwje8/ewDfdtfIhgCmY20RW6cqEy1s0Y6x1ganRA
X-Received: by 2002:a05:6402:2711:b0:5db:f317:98d7 with SMTP id 4fb4d7f45d1cf-5de4504012amr1547474a12.6.1738892340423;
        Thu, 06 Feb 2025 17:39:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgOhkvrAKf7nnqy6gf6zaVcLFDeVOoBgzqKLIZs9WBroJfeQUTu2VncuzrSklAcKO7aLry1JfOkH3CEhT1YvI=
X-Received: by 2002:a05:6402:2711:b0:5db:f317:98d7 with SMTP id
 4fb4d7f45d1cf-5de4504012amr1547459a12.6.1738892340077; Thu, 06 Feb 2025
 17:39:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com> <20250205231728.2527186-5-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-5-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:38:49 -0600
X-Gm-Features: AWEUYZlzA01SrkVvm2yXKQXBYBNe15LNEHSv-QmGFlSTajNCQkvq6Nepgp2ijso
Message-ID: <CAHTA-ub-FG_9NZvBsz657jLpKncsEz_jpXr86JmzdAPq7+wimQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm: Provide page mask in struct follow_pfnmap_args
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>


On Wed, Feb 5, 2025 at 5:18=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> follow_pfnmap_start() walks the page table for a given address and
> fills out the struct follow_pfnmap_args in pfnmap_args_setup().
> The page mask of the page table level is already provided to this
> latter function for calculating the pfn.  This page mask can also be
> useful for the caller to determine the extent of the contiguous
> mapping.
>
> For example, vfio-pci now supports huge_fault for pfnmaps and is able
> to insert pud and pmd mappings.  When we DMA map these pfnmaps, ex.
> PCI MMIO BARs, we iterate follow_pfnmap_start() to get each pfn to test
> for a contiguous pfn range.  Providing the mapping page mask allows us
> to skip the extent of the mapping level.  Assuming a 1GB pud level and
> 4KB page size, iterations are reduced by a factor of 256K.  In wall
> clock time, mapping a 32GB PCI BAR is reduced from ~1s to <1ms.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  include/linux/mm.h | 2 ++
>  mm/memory.c        | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b1c3db9cf355..0ef7e7a0b4eb 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2416,11 +2416,13 @@ struct follow_pfnmap_args {
>          * Outputs:
>          *
>          * @pfn: the PFN of the address
> +        * @pgmask: page mask covering pfn
>          * @pgprot: the pgprot_t of the mapping
>          * @writable: whether the mapping is writable
>          * @special: whether the mapping is a special mapping (real PFN m=
aps)
>          */
>         unsigned long pfn;
> +       unsigned long pgmask;
>         pgprot_t pgprot;
>         bool writable;
>         bool special;
> diff --git a/mm/memory.c b/mm/memory.c
> index 398c031be9ba..97ccd43761b2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6388,6 +6388,7 @@ static inline void pfnmap_args_setup(struct follow_=
pfnmap_args *args,
>         args->lock =3D lock;
>         args->ptep =3D ptep;
>         args->pfn =3D pfn_base + ((args->address & ~addr_mask) >> PAGE_SH=
IFT);
> +       args->pgmask =3D addr_mask;
>         args->pgprot =3D pgprot;
>         args->writable =3D writable;
>         args->special =3D special;
> --
> 2.47.1
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

