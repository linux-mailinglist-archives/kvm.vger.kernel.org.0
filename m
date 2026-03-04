Return-Path: <kvm+bounces-72622-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBveKnN3p2nyhgAAu9opvQ
	(envelope-from <kvm+bounces-72622-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:06:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 259EB1F8AF1
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DBC5330B0F01
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126CB1624D5;
	Wed,  4 Mar 2026 00:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfXVaCfv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227C1E51E0
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582585; cv=pass; b=TQUC+5f4Qsest3+6J7ogdFpvd4C6mT5CfbYRDXRlLKsHHBvgaG68joejL6dqNyG/3fiUxcMNCghI7fHHUaLwg9P6U9OzFBajBJfD1CIe2+HFrl/GsxcXhhGm8Bc25ZxR4oiZwaiKlmho/TGZd0+uaXj4bPy71eFwaa9O0YgI5YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582585; c=relaxed/simple;
	bh=dByzt3pn9TIMSvSR73Q79+jZ1OR4sJM3C9OqpmTgZ6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwYGppNZXOGP/ufjMEwUFHNE/vxnmc3+bfNCcAPn8tKZBb+Dvn8Ru1UGvVTtS2ukYQJpbpkhALuMgPtW3VTABUYJO+hfh0pSUOZbt/YbE5dpjS/cwuvL5ZfHFq4KYD4yNR6aDhBeU4e0LxwK5UOE7wWgvjSPvLGhh8QbpzcSmtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfXVaCfv; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-505d3baf1a7so737451cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:03:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582582; cv=none;
        d=google.com; s=arc-20240605;
        b=QFScgYve1j7ouVxmo/5FJQYgMMQXQWq0Er6IopkzImUN4dMBTSnX8lXEBMecODiRrv
         D9SwMCDKMUg1NfUPv+msFICXluZ2zsfm0lk4U+nX6C0NJIUC/VAWqPQPUYYXWQwiWcSf
         uyyCVgEJpV/nZTc8u1839t/3bYzZKt8Bq0tAsc2xh10M9BvSoZPZGCFquv9tVG/0jQAX
         ljZYh2/g/8mQDe8mieWGPYLrPFVW03qFx27AgaelkPaEkc4pw8x55DzoNB4WoQ2k4vcx
         0RX3cDRmCbHVrBenGmoFWamgrXreAQ0DGbQ1Qiej/w+qb2R4A/XVViFRgqsDtt/6YoSu
         VCYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        fh=6lit4lzAw/Z0DvQAq32DvEHPjHv0BoHHrEYLSkuU/18=;
        b=J3mKyZr3RF7Y/g+PCdTVlkI/EdSDuj8tqPw8DL6ZNqZYwzda6DKAn/yzYyO2cjYBzr
         3ehhev1J1okYXDIqnL/iTLaXcHxl3k6dvDPiIm9WHgMQOMGTa7PYrv3W/+yfzJy7H40V
         X027IDXxi4Mn3Ook1Vi8618tRpVM5arvbUtvK5OcKz4zFWWcTxhUziU7TgSJDAcljQqc
         tE/oSDUgAy6o3a8hcSmaDvHLYXvLR0CqyefpSmvuoeiX5Jx0Oi/51funii6W2jVI/VdT
         GZ5EXV5FhXZHlv2rsIJmHv743SxIbtcCVXHYEWKKtwOQ6PFnqdy0sFwU/iBtj3zTTCFT
         F0ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772582582; x=1773187382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        b=SfXVaCfvJQk7LXw0c+gVWSR1C2tou0YM7EuDzy/DznFC0EnFVvdI+4M53D6SZyKMBN
         rWzTAvepejChcLdicpitylt8Ir5I8N3gbM/WRSi5riJg1kQcg0Afm1InaOBctyaQWgme
         QlFmCvxJZVIEFtP3pI/hFBoj8+QhBjN3z9elgM81nNtLZyRsBdyErL1Uyk9gfU9goseC
         mq2k95g8ti0gJHOWSHZGehe3TVy6XaBr2nrMS3NXY5iv9DVSR4kQtqr+98Z8TGXlS3Zb
         Da4/6oNcgkEkFK+CSpV/3oKtJvdc05kBx9ImRALojNMScv92RnRlYb7qP04ds5ALwDgS
         dRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582582; x=1773187382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        b=MawSBNL7D/sHg4/MozHW7+qGm0zO4djpEFQcoicjvTXxQ+zgZ8eNP3xfzBB17lswq3
         wu56a9NGE+NglXwuGgb4s6zMK0rWlokCZ8+zbPENEYeVTOPhBgo5IzvKnqEVaBpDUCbS
         jXKlvsbwg8okWIokTCBoCz5AIF1FOv2kgPZdXBNvatBHyyUN0SY9YWh9NgYad4TXf6fr
         m1Nvb5zLheVz7MymiqfAOKYxqRscGizJdyJ4SfATcyTArWvghjKbThKqqQqpS99Ak6YL
         0vkzFly+Tdeds+glaY1i+H6Y527XV6jDnnM+fPzw4sHI2mtmVRcwVEY2nEmgIhacdbQ8
         yhrg==
X-Forwarded-Encrypted: i=1; AJvYcCUQdaRMqvc6UC0CWoqO+HV+QaY8S3uUKRA8mloB4DIpPTltxtniWj9PN+PP1H0BI0CiSQM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/rKaoZMYxbFHlAqYw10EnsnkHD/TBkUsvO31OIRgt+oJEfS5Y
	c5Ut170JzWHk5k14L1iAU6N+4VDOaNCyx4cnYECVmRrky+BHIWvv5jXhwfJlGGXlMrqFn2j3Wgj
	XxgM44l+YkBvesbflQ/39vfOPJrz2AYUeoX6YS8nj
X-Gm-Gg: ATEYQzw6jyN2CAReWTeJklCG+wLZvr+M766Gxm0vslzr5hwFDE4j5XZGeV4amKBBH9n
	0/d7ADkJGvsSf28Sd6pb9oNGsY5qLfkkiyqYYSILxFnLuyZ1ZSNTFxH8RqTE2pp71oKSz1+CGwK
	TXcZDyZyqHPF868xRg9X6arNzJvnsSKcjpH2o3lNpyoflpf8LwV3uiggpVahTp7hPI2nA6K8VUO
	va3qv3uN1kQjQJv6w3IMAOh3qoqOi7EzfPGscUkWOi/De0qfpAIO7q+41isPkBQz5VUn/ReSYD/
	0VT09yBxVJHi2bpgi4JuQRC53OU87xNbAXv7rjSKegsWG0Q=
X-Received: by 2002:a05:622a:1916:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5076186da97mr2167841cf.17.1772582581904; Tue, 03 Mar 2026
 16:03:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local> <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
In-Reply-To: <aadeHiMqhHF0EQkt@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 16:02:50 -0800
X-Gm-Features: AaiRm525OgcepzAJNzfaRHa0oE6Zi6kSq3Az8BaDbo99H969zeTJWZ4WhKpE7cQ
Message-ID: <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 259EB1F8AF1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72622-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 2:18=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > On Mon, Mar 2, 2026 at 6:53=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > Overall I'm a little concerned about whether callers can handle -EINT=
R in all
> > > cases, have you checked? Might we cause some weirdness in userspace i=
f a syscall
> > > suddenly returns -EINTR when before it didn't?
> >
> > I did check the kernel users and put the patchset through AI reviews.
> > I haven't checked if any of the affected syscalls do not advertise
> > -EINTR as a possible error. Adding that to my todo list for the next
> > respin.
>
> This only allows interruption by *fatal* signals.  ie there's no way
> that userspace will see -EINTR because it's dead before the syscall
> returns to userspace.  That was the whole point of killable instead of
> interruptible.

Ah, I see. So, IIUC, that means any syscall can potentially fail with
-EINTR and this failure code doesn't need to be documented. Is that
right?

