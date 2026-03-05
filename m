Return-Path: <kvm+bounces-72882-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAZXLfG+qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72882-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:35:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF0E216549
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 603EE3072C85
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640FF39769B;
	Thu,  5 Mar 2026 17:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKDmLEyS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C2F3ACA65
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731648; cv=pass; b=DykU7a156hucNIpPj6HV0AmJlSXIbUr4jlQeL+UAySv3Bbe2IFqCF3BCSj38duEpGKD/hngaYnP+WkDlRDABTvqY4qRJpGVp/PkcVNHkTjSwjqYS8DRv7aavHUhoLVoxRY+vPkg4rzfHeTUR7ACoAqSAHNip8OLuOxIMcC+Rx9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731648; c=relaxed/simple;
	bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=po7dnPOYQUDl24TJsKT+Te8DGJjbfhjDIlO5d++PGCs/b8uvd+omkMd8eGrPQnd50dO0Y6LqzTaNZh7nmj3EexG9WO+tYY3pbD5VqNgMna3F0YpWsFgGkPIvwBWEbYa4FFEFe175idjs0BVqkPLSWC8Lx3ggICspKYoK/XXitFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKDmLEyS; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-389ff6e5885so72090601fa.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772731646; cv=none;
        d=google.com; s=arc-20240605;
        b=jUOW4ze7U1lhoOxDmLMlFSYyDUvxbW/SSfH38ZLF1iZrfX3LJUF5TuVVCGCs+D60F0
         V9RAaW5hB/PjwvccnVfdUG/PUwK3WJI9u5q5nNPjw+miFzGYwqwcW2knUuEubqnl4r1U
         thMqxqCx0LyzaWiBVQhRajqTFHhI7pepzpCj0sg+saDoB9kwQi2gx3DWB2o2XtWLnCxN
         /b1OWeUFuGurhV3Mk9uddA+6EBDrfoG5KaSV7ltnnugkWX+cK152mhCCtzg7NxKnITx/
         Q78KdfkIwOvJbj8A78NFZPWXTpCkfIgshDkL+xBJxCwVvh4/mzaYNBuBG5/20ccBvdXq
         NtAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        fh=fPH5V7LTTSd7+M6+LXI3Omn+uJkUoUMinG0dKBsNc9U=;
        b=MonKImMQCx/aY2ewriuF9sHn692lo6zuYMukLA67Qr3bVGh73ecBN4MCNwsKpD6xu4
         FYl45Xk6f/1PzEzLDvDA7EfUyPKgAjgw1GepwL/FVRzEMWqrhykH+B4iwyF2Z1Fnt4q/
         quhhic4LochitQZ1R/uHECNXgSEgS9+2OdJI2/zc12JQpchD3lPJIMN28ltKHNm9ZjiT
         8AECm4OndAUKa6qv2u7/7yvZ8QmiQ90M4Z3GSpImZCV/L2cpy8cRQ4HbJd00SK4Rv040
         i79EODbquyROuirOkz/AtXom5fdd2MbA7cla11uUKa1zQIywtt0E270CjDhKR+tz43Px
         Rr+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731646; x=1773336446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        b=PKDmLEySTcjzS9x42yIYEc2CgT2T70PgTgz4Rg6gf/cQNjMt+VSfzVAE2opMTtaf3s
         cjulBhL29EHJWlyAtEyveUbA9evHgdqPBdEkb8QXL0JrT6Ses0zEHl6CrsAUiO+Agyr5
         WKoVD495z5C0R1y983aOJYOrNLrB/UmCMwqfdaU1tSzMd+hPSSq30qdiAUrnz7G0GPqX
         xixg8qnVz3BpbpPj1GyCbAFGZw+M94J9XTGmKXmj6JyWYGXuR18TLiCt+q6lMH/BTTW5
         Z6WBMX0km8ghHLXI+PrlXNye4sgpfNoslNIrk4fkx/i8WCvlZK8UzaApXo/CkoAXlZ2Z
         UYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731646; x=1773336446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        b=QIQekVvgBP9mnH51PUAsZndAUrMQ16W5PU6ZQAsAPltV8a3uFSRowpf1ve+kLhTlJJ
         J2UBouRZzrSPFUhDu3apTkcy1xi5F1oTmfooR6Av+PcAh+rk9HtAdzXC5PmDVH7Jqz5B
         s4HudsiqqXyaI86aXoyd9zF6MsPPemOme4S7sQjsAAhxZ8/07mwFcnKDwyE1Az3lZmJg
         JNZo+2XZpjrglDNmTRv8oJZGnJysb4PEwhHY/h+NE2c28KXLI1cVGSZnQl1tWP9VZgN7
         orZgk3fYtd0PUmUVhu2Wf+T1M+iqAYXdcExbXy7N9xAZt8VE0cudgKTexwXLoVbkR6Pn
         V1PQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4J7Pt/25icymgXtBWv7VZRxHvCzsZ2h1vy56HEpo1h/j3lNiwnR4I014KcuBDhL0xqcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfIIZAFu1bsHEN0MsnOFNkD6J96qIEfYjSQVEi0KQL8s2l+u6z
	pJa+kOrrOZmgcTYeLpc5wzeoB2Rubguj+M80B+rEBt/YwKWk14DtYEMHG8KsFQcIfmMCxcZidkS
	MPfvPWYypvpfp22F7Q43r4z0UX/bK4FYLxUCXTvx+
X-Gm-Gg: ATEYQzzXI6SAbx7KjIhFSLvV5EiDNdq1crnuAnOkYoB/0s93O/DHH7q3lPBsVRUV5vC
	XvqmoAh9dkIsC/zD7xGtID1xBE1QTMqqaAVvRkdL2vllO1JOtrVr+L8A2GR41HHR7Z4/Qpju//Z
	TGDJ6GzIEF2z5JeV/QtxAQZg+RNaYXJWFXJtoAmkutuzjlK2+E96HQZz8EoqNVVqja4pNH2Mus3
	6izUOW6dPigSqg3Sss+wpNlE21TbX9OzECQky2S3PFAFyVeTqcyekZFGI1p0IZ3h8L0pZooFUwD
	jILhGDgp
X-Received: by 2002:a2e:9797:0:b0:387:5ea:e298 with SMTP id
 38308e7fff4ca-38a35158513mr8005261fa.8.1772731645158; Thu, 05 Mar 2026
 09:27:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com> <20260220004223.4168331-5-dmatlack@google.com>
 <aam7JsCyQ5Oacvl5@google.com>
In-Reply-To: <aam7JsCyQ5Oacvl5@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 09:26:57 -0800
X-Gm-Features: AaiRm51o6Q3ZTz6ECMDT5TdlqFdcggDf0j5vT0TJnm45bgTm8VbA0ynEnVZFATE
Message-ID: <CALzav=fV4NX=pxKfX7hH+tO3FBNcSF1KstXsKqprpCj64Ndx2Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] KVM: selftests: Use u64 instead of uint64_t
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
X-Rspamd-Queue-Id: BEF0E216549
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72882-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 9:19=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Feb 20, 2026, David Matlack wrote:
> > -static uint64_t pread_uint64(int fd, const char *filename, uint64_t in=
dex)
> > +static u64 pread_uint64(int fd, const char *filename, u64 index)
>
> I think it's also worth converting the function to pread_u64().

Good eye :). Yes agreed.

