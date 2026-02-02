Return-Path: <kvm+bounces-69955-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJ/lB3czgWlQEwMAu9opvQ
	(envelope-from <kvm+bounces-69955-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 00:29:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F6AD2A57
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 00:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A03633003736
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 23:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD19238E5E3;
	Mon,  2 Feb 2026 23:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xw9aWkla"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B9838E5D0
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770074993; cv=pass; b=KcjO0IhIkLMhu+j5el5NtXmGf0exrQ6seCSrVp2h9q64c8dEIYQAGzP1BnzIL5nQAZQ8DW2PjvjW7jU0KpfFjM/6B4UHGBv1FbDCnh/9+MIrjKjscxAKHX7JT4Otzm6f2ZdlCVKTwPN/F+xy2+Z83fyALXeepBHx4tUrFbnpK6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770074993; c=relaxed/simple;
	bh=9xU1ELIOPsspxRS0xVlva7nIQQ424SgRs/Lk+thb9jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KsTySs8rvlz4GQrQPDZ5QciHkfJB4OXXCoHYOb7SiPP+VQFO1Osg2kbfy3XsGWnh423ReRAAPDySMY7iwFG36glfLZbl5SG62IvezRZ7Krpr6OqfNkfbZAQGjz1oGTGuf61XqY86mqRbhMMYHJATWh62BfuJEhryg1BBDMg5rQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xw9aWkla; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-385b6e77ef9so37960141fa.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 15:29:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770074990; cv=none;
        d=google.com; s=arc-20240605;
        b=kKhiz/ig48FmxYEaRP0rNNDBHhYuFoq+j9/M1fUdmZpdx47U0pBSi8RC7x8I05QYn+
         JoWTtmYJu50cVMYbUG2ucfcvYcYwdQgsq5ObKUmuQF2cpVB29h1ScZ7pDGzFq8uAyjy2
         76v8RPnVvO3JHlbeeCcwoDPzQzOa4Ofa5K1NKbIbQvXrPWwWRT9dKSd2+lJVh+idX6I9
         mPh/m47XP60dTiw0auAiQXiT7WtAjZHCKFG/oDwqTa93tw7qKVjOoffkRs7ufVD5+wvq
         WjSXTNqfiOhjFcSdfG9tXmestyLPOvQvrTeXdnVJgZykNIAC1QvK90+1db8Ao6/MhI5B
         OyEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyS4gwVx0BMn3Qhvfk8Yq9Cz8TK3HsqiXevlJlXLDpE=;
        fh=KVTlZzVe5CEGQWjTIThPQJd8UdtWqOYHSyIgYFF9EGs=;
        b=FdRmFZVOw3tfhrgSx0ILvnTlv88nnCJOE7yBQ0RhAfKYdZ05uZ+tOwn/2Of28OptHj
         1gn1vt0Q3QsshN81Ywfog3ESDkt7LxTPTQqP/yvNMbsHjf0nCOY/cLc0k0z0Eqq14zEw
         VbVuPZONW6pCux259256B2JWsCY0g5xNgJPN0+S82iPr6SPm+HzgrHlzJdzD6h8fbQRL
         Ed3cdbuqag0rrpPYlxvB0YvYNRaAo7r1673aWL9aEnX/as8LHK6nSA0MD0PbDQLcrFDb
         BmSD2jcxe4UgOQPrhY7wM82F2negs0pSpq7f3onhsIFexHcz1v6N1HKRxkf0I5Xz2yJP
         wQJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770074990; x=1770679790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyS4gwVx0BMn3Qhvfk8Yq9Cz8TK3HsqiXevlJlXLDpE=;
        b=Xw9aWklaRp8xbMQxMaZ0KEbStqFxqWtYgVdP4zuzT1y1gcNPiKVNXvGxlsfR8QGQKC
         oI8IBNozxfX1tvUDZuTvBJstzIHD/7N9ag+bJI96fhNJJmz2q9tK5Qke8AZw7DlOZI5f
         7NicmcCaXiT3UODZJ8KXX3NqX7eZzj0lbGjtJK/7j+SzkS9jrN7OmUN5e0IG7KLBdZru
         /ldrH6gv9KOXAII9kAx0CkGUTUkFbgp9Wh+N+E+oTMm54Ex02SFTDyKkfilMRRHJWiwX
         gpMh72ndkwRzN6VT8/C/VwBN/R41t0eLDCqlkf4/cnNrpaHEVe8GiEZtc20R4Q47a42+
         Cqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770074990; x=1770679790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xyS4gwVx0BMn3Qhvfk8Yq9Cz8TK3HsqiXevlJlXLDpE=;
        b=qD4myDmQfGOSCM3aXTnqQum16A/NwkXtoxdtasO9zArWayUJhe7QBjRwdpAmFdfW1N
         L5MNUtEr3x3fdXUXkcs/aINki91VxtFcNJDQ9i84NsTRYGTpqO4a7LzWwkCjHLaGi69Z
         KpL/RMgAZEeazn5o5VqxDSzwaruc7ccbvjV+RfSW6ERYRZjiPypWFTa7o1/ndbVbUihc
         95qlw9vuMGIMOja7eFUccWwclg1xMMUjoKMaScmjtquzQrDgDfUH6l4sx9doBXZdaLoY
         VuBdz/Ax4iz0znCF4+AhBGbZElM/1VF93CKhEasVbBZSdviZIqHASXDS/2/gJG+09Qa5
         rkRA==
X-Forwarded-Encrypted: i=1; AJvYcCX2WgliMhs1b/ju6zkA/hBkfugppytK5uvPBz2eCKO5xVWjJUcOnWa8Aiajqykqq5YW9oY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiBPdOSuUd0W/MydtiWlEMuf+TkMy/p6ce5L2v+S1Xa4AexpR6
	GCkh3nEcwDqcZRS/jPXquKF4vJiVElIQGwGdTlAnA/wuwLM5D/af0849JBvVZLhZftxsUdtdUcl
	NtX8l5e7wDfeOo9fZ7Vm8ipdSUrxzlvrYyH6ckTov
X-Gm-Gg: AZuq6aJHwp48oKiMV6zCjCwsDaUXVMmYMcr9aJnXvo3N8du3sCwNfO65HXJZU1Yr5SP
	PNUqZIoWa0kQbR8G1GWqfiSZaWdDNaRRY6YkmslJ2UFSEae7TUqNvRSJ3HXr3sG6l6z8KDDHJbo
	DzeLftfcEbSwOCRv44kRZwQZd3pRIl7w3U94Jjg/cRxtmJlNh3CLmDqioNXYj1w+7AHZK1mWagu
	sNqfRdZTr3oI6vgokZsxBSUMGpqf1SoBaWqUHtzGE76KYhPwrm+XdIB+VAF43sQhuDFodYPWxf/
	CSwI
X-Received: by 2002:a2e:bc82:0:b0:37b:9b58:dd0e with SMTP id
 38308e7fff4ca-38646558980mr44483011fa.10.1770074989357; Mon, 02 Feb 2026
 15:29:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com> <20260202144618.32bde071@shazbot.org>
In-Reply-To: <20260202144618.32bde071@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 2 Feb 2026 15:29:21 -0800
X-Gm-Features: AZwV_QhScOtwfjmTMtLq8iYIDxDbkhhsR0KMkhQVUu2jAUHPbaRWrFkGYxFoz1Q
Message-ID: <CALzav=fYNmy48T0qWOujvaM93iEUyO2PuG5FCeG4WnjkEDaj0w@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: only build tests on arm64 and x86_64
To: Alex Williamson <alex@shazbot.org>
Cc: Ted Logan <tedlogan@fb.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69955-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,mail.gmail.com:mid,fb.com:email]
X-Rspamd-Queue-Id: 40F6AD2A57
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 1:46=E2=80=AFPM Alex Williamson <alex@shazbot.org> w=
rote:
>
> On Fri, 30 Jan 2026 16:02:16 -0800
> Ted Logan <tedlogan@fb.com> wrote:
>
> > Only build vfio self-tests on arm64 and x86_64; these are the only
> > architectures where the vfio self-tests are run. Addresses compiler
> > warnings for format and conversions on i386.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp=
@intel.com/
> > Signed-off-by: Ted Logan <tedlogan@fb.com>
> > ---
> > Do not build vfio self-tests for 32-bit architectures, where they're
> > untested and unmaintained. Only build these tests for arm64 and x86_64,
> > where they're regularly tested.
> >
> > Compiler warning fixed by patch:
> >
> >    In file included from tools/testing/selftests/vfio/lib/include/libvf=
io.h:6:
> >    tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:49:2: warni=
ng: format specifies type 'unsigned long' but the argument has type 'u64' (=
aka 'unsigned long long') [-Wformat]
> >       49 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0=
);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
> >    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: not=
e: expanded from macro 'VFIO_ASSERT_EQ'
> >       32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, =
=3D=3D, ##__VA_ARGS__)
> >          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~
> >    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: not=
e: expanded from macro 'VFIO_ASSERT_OP'
> >       26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",       =
                    \
> >          |                                              ~~~~
> >       27 |                         (u64)__lhs, #_op, (u64)__rhs);      =
                    \
> >          |                                           ^~~~~~~~~~
> > ---
> >  tools/testing/selftests/vfio/Makefile | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/self=
tests/vfio/Makefile
> > index ead27892ab65..eeb63ea2b4da 100644
> > --- a/tools/testing/selftests/vfio/Makefile
> > +++ b/tools/testing/selftests/vfio/Makefile
> > @@ -1,3 +1,10 @@
> > +ARCH ?=3D $(shell uname -m 2>/dev/null || echo not)
> > +
> > +ifeq (,$(filter $(ARCH),arm64 x86_64))
> > +nothing:
> > +.PHONY: all clean run_tests install
> > +.SILENT:
> > +else
> >  CFLAGS =3D $(KHDR_INCLUDES)
> >  TEST_GEN_PROGS +=3D vfio_dma_mapping_test
> >  TEST_GEN_PROGS +=3D vfio_dma_mapping_mmio_test
> > @@ -28,3 +35,4 @@ TEST_DEP_FILES =3D $(patsubst %.o, %.d, $(TEST_GEN_PR=
OGS_O) $(LIBVFIO_O))
> >  -include $(TEST_DEP_FILES)
> >
> >  EXTRA_CLEAN +=3D $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
> > +endif
>
> I see other Makefiles include tools/scripts/Makefile.arch which would
> then just let us test for 'ifeq (${IS_64_BIT}, 1)'.  Would that more
> directly address what we're trying to solve here?  Thanks,

I gave this a try but it seems like it results in a tricky situation.
We must include tools/testing/selftests/lib.mk before
tools/scripts/Makefile.arch so that $(CC) and $(CFLAGS) is set
correctly. But TEST_GEN_* variables have to be defined before the
include of tools/testing/selftests/lib.mk, which is what Ted is trying
to avoid :(.

