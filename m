Return-Path: <kvm+bounces-71187-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNazE83QlGlGIAIAu9opvQ
	(envelope-from <kvm+bounces-71187-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:34:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC8314FFEE
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5476307AA1D
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03D7378D76;
	Tue, 17 Feb 2026 20:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UeVHbMib"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183E17993
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360308; cv=pass; b=CiQOE37iEkR5dx4jLWMj7qnvtdoZwEgXw0/PQLnhLk9Nh6zPbP7c69MlRK1xMgeZffVTTTpx2pLtngEmSlRHera6i3XtbaOrOboQAd60TF5pXX7BDo8B1S2Zcuh0i0NFDFSGuQMqzkLglF7NJD7XZTfZ9BsHopNEbSVLDylYzFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360308; c=relaxed/simple;
	bh=O6hX9dg3oPdI5w6wnUKEspXcKuxPryEjYBIewl5phQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iTzG5vXaGm5dI2ls/y6DKk4LeaawZxSIrpyZscTsrW6iKgB/vrKGngdvkZECQDQPMmo8QdxmSzrA6NEiDFY7SO4v0t2b1ZLvI2Jg0oei+ZhI9tnduP/9V+NGWQ8ai+X/WprXA6PDaAAoY5LdosJ3KVQIBwoIEM5WH1RLuH/BBmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UeVHbMib; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-505d3baf1a7so14411cf.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 12:31:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771360305; cv=none;
        d=google.com; s=arc-20240605;
        b=gMTPwgY+PqWcrJ9BB+EJ1UyEgAJRudLs//5KanvRKBnNhz0OBM62Jl9yLnocrUunCf
         AwT/oK4kz0lVPNejvZtyJeqnACtzdwpiufZcx0hBfjhEeT6M5+DCL4wC0aJo/kG+bpNc
         8XhMHMal43rL1u067bXz7ur+X7o0FYF91++4lVSFfyOCSoZNEVK8+3QehU2VxrhdGvXW
         t6/JEPDlY48kQaah4aaZsnJ0m7DUNWkcH35Psr1EhMBLUKsSvR58pu6nEZ7f5DcLAgmk
         MiDJugnJ3wer8zmPh0bgT3ToWEjwlHO35x89vKiVaewYSRt/vVnxyEUq2SxE4UmVpmlr
         Jzvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        fh=iGzhLAZe8Tdzdz0oWxmUiF2Kp835l9wxsENE+UHIqnY=;
        b=hceUjXh7Vi2IM7Rmj6z6BFYA9PHdA4qNMjxMLdCKfRbtDbTXfy8FBpUY95CPnqY+Js
         3QBvS9YXhXZGI55EqjdLxEqlle7/csDLUtskfP7NCjaltBW8eYqAZw0EStfcWfddxBQ4
         qqp3dVREqJ2byKWWTM6U/kHxHjpBdii7QaEp3ynTbcLZIkMEulAVnGwbTaABTjVBWupI
         +pFoFW7BxtOH4ofbRMOezafo1vf4brozoqmL+3CYMlf1vcOA6D+lSTtoSKd5PoVymlY0
         WMvcYLzfsNthzUvKu31vOSlG8ROJP4e1030Wh3BV6Q96eG8L9OjeIWHBsCwcHYkXthgq
         pZ9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771360305; x=1771965105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        b=UeVHbMibqOfRQKGYKAh/WRjskzuqNuGewj5Dj+apgjsEjuBzhDfIsnD23PEgJpxicM
         GtonqZ79YXpeGY7YZxuPk5TAKfJ5zKwhPYQNR7+GnsUNiPcyjPuJP3FeMnOeZBsw1y7k
         Vvt0YJa2del8puxvK+dDnZ1T+/jW/QRN8clTbwfu2YpUHi4vqt1e2iporg7aAZ/a9hZ8
         aqXSRBOk+KR8TmyjmhsJv2TILjh6GeofkYID3UaiKqw8fYq1He+zNTkQI6wDkal3kkbd
         Nqv+R2WaJunaw5qubIBhFRLpLYiI6cKaUpKBugcN9Gtz6FSBw9Qth0tM0EbtJdcKcB10
         UvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771360305; x=1771965105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        b=etkHSjZA99CQVuae1yCyKhCKxKXI7Lh7AWO8GhgL2DDHFC9ljuQ2agf9ziJ8NVXTcY
         bZCLCJ+RHlP26KdOPXRTgYYiMKUo87+onlWUzAfmlJ/+hJyZaGOoMACPYStwF5e7E2Ow
         gtSI67ISv+nAZt5J1qHtjTzYCOAqFeCE2GoT2Sc/70tn+fphWbACfDLdnQTlJhPPGNn3
         f8LlG9ZaAQAy4LUMBg+/fQCUygYKjmYf7JOC+LTj5tS6afmiat5RoAi9mI2WgmBjZWHV
         MWzDhQmGKMkQWricSebi3djGKggvpDQU4dlV3WPozYaLea8gwPovFGOr9M6wok/dG1gn
         DbSw==
X-Forwarded-Encrypted: i=1; AJvYcCXkMX/t39OuZ20NNyPiWrVt8S/u8MbNbpcFq/YiI1bjzU5V1vBV2yq+nc/L7TMi1MmrsoA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7auGGvQ2IOXqYv264g7Y4qRGlUBfqNpG8qUBitAhhMHMmG2+X
	zWxtlZjzLt/8Actek0cErvj8mwuRxtkUWWhqIr4jqewZ5E/zn+ISbFW+cFFqzKaSvs2idSPDlsb
	VNOmf6u9f1kwClYnvRqBUiGz+qr7gX+ZBvWKvnAIU
X-Gm-Gg: AZuq6aI453KnyCD7PfBBjcghCzb93wSWxc0+yt5jcH43YBQPZ2gsQveX8GJn0i6iReq
	q54V52ex3fyHI65OGkxw0dJFzhmfFwVJtbcnNPgG3bn35Rz4biSY1gTfVNRXp1iSSqqkQg55g1r
	qvu276cfrGTUu1JellDQYWBgfdwKswj5YVGhFv/SLoz1swrmAMQMNxAszEaQ19rn1V1VoYvGMB6
	fWW2/cnv/0K6CpH9i9TMTPzklyN9oNnQdv55veNGn68DM535LZZMwdkZS3C0cKiivgHHHtV+dub
	NVwIzpk/daPp7id1IPXaUg5HkRoC5sKlFrQ4Vg==
X-Received: by 2002:ac8:5746:0:b0:506:9852:75ec with SMTP id
 d75a77b69052e-506cdb4c09cmr21741071cf.9.1771360303253; Tue, 17 Feb 2026
 12:31:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
In-Reply-To: <20260217191530.13857Aae-hca@linux.ibm.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Feb 2026 12:31:32 -0800
X-Gm-Features: AaiRm503YYR0kTgCvbJHDicLagxX0QqBNRpofu84bYZnAbv1-xnaYHyLZPIeE6k
Message-ID: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71187-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[42];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: ACC8314FFEE
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:15=E2=80=AFAM Heiko Carstens <hca@linux.ibm.com>=
 wrote:
>
> On Tue, Feb 17, 2026 at 08:32:50AM -0800, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  5 +++--
> >  arch/s390/mm/gmap.c      | 13 ++++++++++---
> >  fs/proc/task_mmu.c       |  7 ++++++-
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  4 files changed, 33 insertions(+), 12 deletions(-)
>
> The s390 code modified with this patch does not exist upstream
> anymore. It has been replaced with Claudio's huge gmap rewrite.

Hmm. My patchset is based on mm-new. I guess the code was modified in
some other tree. Could you please provide a link to that patchset so I
can track it? I'll probably remove this patch from my set until that
one is merged.

