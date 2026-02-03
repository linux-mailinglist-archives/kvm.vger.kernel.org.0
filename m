Return-Path: <kvm+bounces-69963-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBw1Od5NgWlMFgMAu9opvQ
	(envelope-from <kvm+bounces-69963-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:22:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB74D356E
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D6854300612D
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 01:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E994022CBD9;
	Tue,  3 Feb 2026 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="qZ3naJov"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B1221F34
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770081755; cv=none; b=BrfdFadKzuK/eAUTxKIrmUwUP4ubb6YCrUEmWSSJXKTdsHzVgDfP6uK7elBHCy6nvfT44hevkSSN7wH2Po0FFZfO0uxIjkeAB6k6Krjvx5SXoyOJ64V+RoL3i+B9qW8PWOtB/HpFx1SK/nj2+JdAH1NkhIijCRlUyWNRMM2R1uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770081755; c=relaxed/simple;
	bh=0ihaOCOCi0TtYTywQQ7PQ5EeQHpvVkR5/KEKBqLKb74=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nobFsVIZMBXhAGqqJ6QfEKuv8RUqhZKoQe+ixJ93QjHQqU8vlDo6p79DgJBNDjeVWOiq+sjKa5XrGEj/8GRadS0k77E5PGik6TIGJG8xDYzuwT+nGfk6WQJ+bnbPIiCAJdgYuUN98zRTHjokDc42ujB/WEyefN/eFUZ98lGJydY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=qZ3naJov; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612MM8ME3891012
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 17:22:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=F+V+8Jpn+P9xEzO33GYn
	WR123CrNUWJRUiQ/pM5RrWM=; b=qZ3naJovulPxJOMxdCex0tGtOB+Fw+0kKyYv
	b4vdDomR76QVZyZpuJO73nju0aYOinAI9CEboRIITWeM8IdmVKsxMMD7Tp+s3Gwy
	ZwRVjWEqEJ2vQpTsqvtlatsS0VSvqTI2JZAbv5Yr0Qwuwn/dAeXFufircnmii2zJ
	ky+Ct19rd8avRfCM1AElFonP/RKLY6ewOh1iErKVaYze+8jbDxub3GixhsTfNdJZ
	383mRzgvCIu7vmOTnshlU4BbQHRiW7HsGWXCBb+OOmWGldPBw+Jllejwp46lOKra
	n85BkJz5s5pyYAc9E9X7z0e++KksnMeJBfAE18nGRieXng3e+Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c30d2cynp-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 17:22:32 -0800 (PST)
Received: from twshared18212.03.snb2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Tue, 3 Feb 2026 01:22:30 +0000
Received: by devvm6375.cco0.facebook.com (Postfix, from userid 721855)
	id 964EE10B1DD0; Mon,  2 Feb 2026 17:22:18 -0800 (PST)
Date: Mon, 2 Feb 2026 17:22:18 -0800
From: Ted Logan <tedlogan@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] vfio: selftests: only build tests on arm64 and x86_64
Message-ID: <aYFNyifxe0vC6A67@devvm6375.cco0.facebook.com>
References: <20260130-vfio-selftest-only-64bit-v1-1-d89ac0944c01@fb.com>
 <aYE0QUnXYq6OYvq9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYE0QUnXYq6OYvq9@google.com>
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDAwOCBTYWx0ZWRfX8HBZdcPzX/50
 G/Rs+B6OHqhXPqBSqf/ozpIKjmy4wXohhsuAP4+OsqGbllKHMm6Hhqf90skOlcqUiV6GBiV7C15
 sGStU5/dwFvZd9LgdCWftFo20uJaUZ0qrmDB4pSjcXQGFzH4UeAgqUub83t/7BDZjvR/hcnb5+8
 Hu0uXEmd95mztdP93C/T/SFdYl2tpq+gXw23IR9h5dbMzZQ0LqpdOjkfEPLHaxoC2YuR1aZcEUO
 IARnxyItKdIiXVqZb+iBNtJkbqjDffuQKVrglQU9Xu/V96H1dYpnzevupO9h3Ruj4Xqlqo+mF17
 RYTc+Krz4AyFuXu41/30FROQYlyp/spVgIGjjTyJQOBrPnexU64+1+PZQ1Q6V+nNUBqqlXCUo7D
 ULZ98iE1VXdaH04Sac9VMwHSuB44w5myyssCGnFYMI1n2TvfnIlz1UTYiGJcpZSVC/sRR4VzfzB
 R8MGp6GoNJD2lEl0yqg==
X-Authority-Analysis: v=2.4 cv=J7mnLQnS c=1 sm=1 tr=0 ts=69814dd8 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=FOH2dFAWAAAA:8 a=rfWWMxf4HL6aVLy8pKMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 3QMX5nwbv5JVizNaDGnAfZjVOgCS_Fmu
X-Proofpoint-ORIG-GUID: 3QMX5nwbv5JVizNaDGnAfZjVOgCS_Fmu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[fb.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69963-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,fb.com:email,fb.com:dkim,devvm6375.cco0.facebook.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tedlogan@fb.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 8AB74D356E
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 11:33:21PM +0000, David Matlack wrote:
> On 2026-01-30 04:02 PM, Ted Logan wrote:
> > Only build vfio self-tests on arm64 and x86_64; these are the only
> > architectures where the vfio self-tests are run. Addresses compiler
> > warnings for format and conversions on i386.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@intel.com/
> > Signed-off-by: Ted Logan <tedlogan@fb.com>
> > ---
> > Do not build vfio self-tests for 32-bit architectures, where they're
> > untested and unmaintained. Only build these tests for arm64 and x86_64,
> > where they're regularly tested.
> > 
> > Compiler warning fixed by patch:
> > 
> >    In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
> >    tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:49:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
> >       49 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
> >       32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
> >          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
> >       26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
> >          |                                              ~~~~
> >       27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
> >          |                                           ^~~~~~~~~~
> > ---
> >  tools/testing/selftests/vfio/Makefile | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> > index ead27892ab65..eeb63ea2b4da 100644
> > --- a/tools/testing/selftests/vfio/Makefile
> > +++ b/tools/testing/selftests/vfio/Makefile
> > @@ -1,3 +1,10 @@
> > +ARCH ?= $(shell uname -m 2>/dev/null || echo not)
> 
> What's the reason for the stderr redirection and "echo not"?

I got that from tools/testing/selftests/arm64/Makefile but it's probably
not all that useful. I guess the idea is to allow for the possibility
that uname could fail, but I don't really know if that's really useful.

> I think you can just add the following line so that this is a valid
> empty selftest Makefile on unsupported architectures, without having to
> define all those targets:
> 
>   include ../lib.mk
> 
> Also I would recommend spacing things out a little so that the
> unsupported architecture handling is more "off to the side".

Thanks for the suggestion, I'll post an updated patch shortly.

- Ted

