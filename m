Return-Path: <kvm+bounces-72881-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCPFBqq+qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72881-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:34:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 329EB216500
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DC9DC306D784
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C611FBCA7;
	Thu,  5 Mar 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tng4PLFQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ED021A459
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731614; cv=pass; b=j0QG9zTSETdQjK6k1QqGWuwYcdVkaHnWM5OEzKJdiluivYb5BTMqPvMQSAOcFGrD0FHCOCWFulo6fd/O/DJolG0XCFOpghHNnXiGFmc7oXAYGc7taInUSYOBMyiPS7XFSNquK0MXEhhC2bJeuacuLkkXj/NfgpeFr2p99MLyJKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731614; c=relaxed/simple;
	bh=XOVsdktOF6nyNimRfFhPjPXph4/eizuY/zAJWFeEW6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pTIizKZK0WeRGTtCOkkfMvYcbpvDxx4hVpv1uIPNOxfqZKXAJFoum2DxhLBhRmYRrT163SWXVVo/Af7qKghUK85bDC3Z/U0dH1oMsUY7L3Rq+SaQx92HyzHTH7S7+0ukSCPK+xZjXhGf8zNf/HlJRU5BAy8mCcDxcZkA5WUPSa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tng4PLFQ; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a126c8aab9so1584726e87.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:26:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772731611; cv=none;
        d=google.com; s=arc-20240605;
        b=eLniv3wWiiuSWm3O+h1E4cAD+LRSf6JtgfKNRsP1czvgRsrUdJeKYanDYTgENt3DC0
         hA3xfc1KNBSMpCigi24TPuGJiUpQrzRCnbyEkM2XTzzYBMJNhQHVfXPNpL4WN11pSu5q
         xg22YEJ6rn4Ir3U6KvMk7+rjtf6Cjti8Q3ll49PpEE9pUwxdFAccupU6TvD2bdWpX+u8
         RfapSXdlAHTekPbd8AXbKqLQ5cnSB6QIdVIXr3TcmTSkbW6B6kw2P/qmBWZtQJ14iwJo
         csb493dFK3NoMsvt4ySdmBq8fawvDRofQL41kQOOcAS9eoAaNiKFivWF7h+ZFfOWa+Rf
         rtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        fh=6ZF399NxwNNxH4VDBbIwN/92DOzv7tw99XiYxkW0xjQ=;
        b=NmVSa0q1x//rK1/dGzWWkdOxRm9lKj4Yhoz+Oeh5wMrxnofhQ/eFBj4xqkGurGj7XO
         5HqUCsgRGwn8VKYGiV+znRmHdxXdXzl5Io/z0JhraFeMrVjNDedA31k2W536E+Fz7DAL
         W1xchHU9aACDsHEhEGYLM1s3IqhS5z0NUqMjRo+6Sxq9z2G1WTCMCeDU7qkGeZFsy3aj
         CBIvflCFSZ7pQrlfvCtoy55YsjxIX/xJCxwgz1nKE79pDPyFXQtyJidROqmKfXBl56nN
         mPP02LWjlMCT68d0fmkH3t71O5G+p7iFpRVyJPto0GiOg8b/7+fj/beKqUXo1PiOCxqD
         wQzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731611; x=1773336411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        b=tng4PLFQL4r2avxoGdjpbwbXviJtyJCnkv8XkH4errimTGz921LhizCAKmfFEv5sQs
         WbAPtPme1rUhPGB0BRQMazNWLDNR+e8DYrJlAI44W8QFd4kkZeNaGZtKss8RkoGa3VKi
         Th87OwM1OMGjxJsID277JEjfxbZqnYkVkwj2aYp8O6jbpQt9/ysmleqGnBPJ6NwfKSI4
         cvAb0d8rcBPEcb9DsvjtVB8wLERucFSIx1xuyrqTAk149d0BHaNCj077MHgo9/9TUTlY
         vEK46Rlz6nmQ7L18z3MmHKV0UDKKCQPum+gYyL78qMkdAplwmg2qpcMNfWNpO2HpcJLS
         EttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731611; x=1773336411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        b=jFyhc20khvBwtqsBzoRyqIDXnlaxkqSGkcsl6n5F8H8DdSiYGVcjNdO8gGgpZU/3u1
         dn2QU5EpkxPN4YZSIbmnzHztd0s3XpBga41lkB0s2ohabJafpN8tKiT5o8B3f2mfQIkN
         mreFWpvnmW/powWcOcEVgbpErsQT9O2yuEcPQDx+fOlpbLMIa4XfkSiFNk3vEuNqvii6
         +E0R0+2lQHOuCXVNHQpawhlWpAYKLJZ23Hab/Q0TEgTZ6JVih1JQwV3f0VLa2dO5ebYd
         ixvqwmYlmWiMU+eI/26AVFWJ488FwZYKw4bu8RUnXTbP9j5U+U4GbxA5hDiP5WrkMOu2
         UfQw==
X-Forwarded-Encrypted: i=1; AJvYcCVg3v3ogkDmDilx2cQBb6O5yboAeyJMY6+H3jKeL1IPFcX8FTF6sXuZKGV3ulipfgP8nmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH6qlnyccD1AIod/JqZ+j+aqP3N5uX23Tw8Tftp/KhLa04V2ao
	V0+0egy4pLnIrhjNSqQ//yI31diXnuIomiz0qeAGOfz/6z2KW8V4NM3z9HxINNmwotyZUXSnb34
	DnmrrbAOFo1WigeYDPmeoqNeKFE6d2KNiL6Y8+DU7
X-Gm-Gg: ATEYQzzdoHs9+HXi9/k/9Wtr+vc78lMWHMZUPcE76ebty+gW8xXpsIBduQDaWAWeJ3E
	GBk4ooTug41Rc54DgFwPNSTkI4zMrDDMAurYoDzi7xWXIcLel0aECQ1YtxvaVge4k2g7Lf+kzuX
	wTSxZCT0UZ3YJ+Tvat0UDjTsTumKHUEyUOAAwcuRhQOFrS6t1oAO2rD8BRsSJRvoPzv+NZeZsMq
	0GQEoZexPJ0pv+oiChrczFRMGnEKX6Wdu8GPVYw4/Ue4hF9nKfosg4GmdSHp/Fh31kYhLs2r7mI
	+uxUmwen
X-Received: by 2002:a05:6512:696:b0:5a1:2f18:5e19 with SMTP id
 2adb3069b0e04-5a12f185e8bmr1324271e87.22.1772731610293; Thu, 05 Mar 2026
 09:26:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com> <aam77t8fe5RKSr2Q@google.com>
In-Reply-To: <aam77t8fe5RKSr2Q@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 09:26:22 -0800
X-Gm-Features: AaiRm52LsX1aPJ2JM5xqUBPHr_QH0uBSIJaRMA7nyUfm3apWkfHV7m2i8095U3w
Message-ID: <CALzav=etzo9A7FNQrbLCmj=pNLN5fO-a5isP1k6MuTDkJw1bqQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Bibo Mao <maobibo@loongson.cn>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Colin Ian King <colin.i.king@gmail.com>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 329EB216500
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72881-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[41];
	FREEMAIL_CC(0.00)[redhat.com,google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 9:22=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Feb 20, 2026, David Matlack wrote:
> > This series renames types across all KVM selftests to more align with
> > types used in the kernel:
> >
> >   vm_vaddr_t -> gva_t
> >   vm_paddr_t -> gpa_t
> >
> >   uint64_t -> u64
> >   uint32_t -> u32
> >   uint16_t -> u16
> >   uint8_t  -> u8
> >
> >   int64_t -> s64
> >   int32_t -> s32
> >   int16_t -> s16
> >   int8_t  -> s8
> >
> > The goal of this series is to make the KVM selftests code more concise
> > (the new type names are shorter) and more similar to the kernel, since
> > selftests are developed by kernel developers.
> >
> > v2:
> >  - Reapply the series on top of kvm/queue
> >
> > v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@googl=
e.com
>
> Sorry, I was too slow and missed the window to get this into kvm/next wit=
hout
> causing a disaster of merge conflicts.
>
> I don't think you need to send a v3 though.  I'll prep a v3, a branch, an=
d send
> Paolo a pull request during the next merge window.

Sounds good, thanks Sean.

