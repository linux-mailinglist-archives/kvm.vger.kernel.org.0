Return-Path: <kvm+bounces-47795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E01AC51E0
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 17:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68EE13B29ED
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 15:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D5A27A926;
	Tue, 27 May 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="rcEtGqvT"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.ms.icloud.com (p-west3-cluster6-host7-snip4-10.eps.apple.com [57.103.75.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67221E48A
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.75.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748359346; cv=none; b=oUad+AvgtSiwotMJm36Y62mU7L/H/wM8m4oH+xm71lNLQTGUzM+mowyDs8sTVU3YyKsXASdgg0cZrc5/pVtJStoiQFq5OUw1dgFziwTp4EIFbAt6UNpKRYEJoHyN3Fb90wDxlY2GgayBqR6ZMqTvJIiyV1/gckI+57ILFo1EzS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748359346; c=relaxed/simple;
	bh=1wnjxghz1VyaDYZG1OJx1HqawgRnMvLbQcHMrh119h0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cGkMnaAKrwhnD3BfdeVqaPFePceX1wd6DqdzxnJE8WfYxJV2SfJG1i0zj58hMiwdonAawta4VqyM8bUzjtpAkyLsTulywSgOa29HOZc8BsqW12dF/KumWLECfoUTEdXLJ5D894X6Yl3qHjXzYeJmn5HiZkEi1JS4PuvNiAtVbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=rcEtGqvT; arc=none smtp.client-ip=57.103.75.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; bh=qpWNtoHpHDvcf7sMaFf0EMW/jeoBO90YBaJzoFKooAs=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme;
	b=rcEtGqvTtzwsHj8owtLFiUrWNKFNbo8odUblv7G56UbqAlk/Q2QkrO+cEP/3gmXS9
	 i/morm79L5ByVqgxYCsvY5BeBGLSFyzF0qyjaREUT9Ym45hlyLhgySVnuXnkTv3ySy
	 EOaaGLJoLYm5gOlHCXK2B4UVD7uPzA7nfhz+HqpfHmZBxNo7sx7rV1bqzQGssWRm+e
	 zhw1EZkCyg4Pt/sQ4x4YJ+52zcUJ0wMIoBRW3JmTyrWlmBO6lA6WSPza+j0lC13aov
	 fCSrsTAa13exJkGPTQwJOj/Ttp9znPBh8CyJS9U/etU6cbcVE0JyR15k36a1iASqT8
	 2lAb3KhMO3WBQ==
Received: from outbound.ms.icloud.com (localhost [127.0.0.1])
	by outbound.ms.icloud.com (Postfix) with ESMTPS id 1EA5C180028F;
	Tue, 27 May 2025 15:22:22 +0000 (UTC)
Received: from smtpclient.apple (unknown [17.57.154.37])
	by outbound.ms.icloud.com (Postfix) with ESMTPSA id 4A91418002B8;
	Tue, 27 May 2025 15:22:21 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v7 0/6] target/i386: Update EPYC CPU models for Cache
 property, RAS, SVM feature and add EPYC-Turin CPU model
From: Jon Kohler <jonmkohler@icloud.com>
In-Reply-To: <cover.1746734284.git.babu.moger@amd.com>
Date: Tue, 27 May 2025 11:22:08 -0400
Cc: pbonzini@redhat.com,
 zhao1.liu@intel.com,
 qemu-devel@nongnu.org,
 kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
Content-Transfer-Encoding: quoted-printable
Message-Id: <75B808AB-38DC-4B5B-9A7D-F4D0AD3225CB@icloud.com>
References: <cover.1746734284.git.babu.moger@amd.com>
To: Babu Moger <babu.moger@amd.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Proofpoint-ORIG-GUID: eqgXYJnvJmEg47ijZppIX0S4nFlJs1Mm
X-Proofpoint-GUID: eqgXYJnvJmEg47ijZppIX0S4nFlJs1Mm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-27_07,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2503310001 definitions=main-2505270127



> On May 8, 2025, at 3:57=E2=80=AFPM, Babu Moger <babu.moger@amd.com> =
wrote:
>=20
> Following changes are implemented in this series.
>=20
> 1. Fixed the cache(L2,L3) property details in all the EPYC models.
> 2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
> 3. Add missing SVM feature bits required for nested guests on all EPYC =
models
> 4. Add the missing feature bit fs-gs-base-ns(WRMSR to =
{FS,GS,KERNEL_G}S_BASE is
>   non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin =
models.
> 5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and =
EPYC-Turin models.
> 6. Add support for EPYC-Turin.=20
>   (Add all the above feature bits and few additional bits movdiri, =
movdir64b,
>    avx512-vp2intersect, avx-vnni, prefetchi, sbpb, ibpb-brtype, =
srso-user-kernel-no).
>=20
> Link: =
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/progr=
ammer-references/57238.zip
> Link: =
https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-=
return-stack-overflow-whitepaper.pdf
> ---
> v7: Rebased on top latest 57b6f8d07f14 (upstream/master) Merge tag =
'pull-target-arm-20250506'
>    Added new feature bit PREFETCHI. KVM support for the bit is added =
recently.
>    https://github.com/kvm-x86/linux/commit/d88bb2ded2ef
>    Paolo, These patches have been pending for a while. Please consider =
merging when you get a chance.
>=20
> v6: Initialized the boolean feature bits to true where applicable.
>    Added Reviewed-by tag from Zhao.
>=20
> v5: Add EPYC-Turin CPU model
>    Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel =
support for
>    these bits are not done yet. Users can still use the options =
+eraps,+rapsize
>    to test these featers.
>    Add Reviewed-by tag from Maksim for the patches already reviewed.
>=20
> v4: Some of the patches in v3 are already merged. Posting the rest of =
the patches.
>    Dropped EPYC-Turin model for now. Will post them later.
>    Added SVM feature bit as discussed in
>    =
https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.co=
m/
>    Fixed the cache property details as discussed in
>    =
https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
>    Thanks to Maksim and Paolo for their feedback.
>=20
> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE =
bits
>    to EPYC-Turin.
>    Added new patch(1) to fix a minor typo.
>=20
> v2: Fixed couple of typos.
>    Added Reviewed-by tag from Zhao.
>    Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of =
https://repo.or.cz/qemu/kevin into staging")
>=20
> Previous revisions:
> v6: =
https://lore.kernel.org/kvm/cover.1740766026.git.babu.moger@amd.com/
> v5: =
https://lore.kernel.org/kvm/cover.1738869208.git.babu.moger@amd.com/
> v4: =
https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
> v3: =
https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
> v2: =
https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
> v1: =
https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com=
/
>=20
> Babu Moger (6):
>  target/i386: Update EPYC CPU model for Cache property, RAS, SVM
>    feature bits
>  target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
>    feature bits
>  target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
>    feature bits
>  target/i386: Add couple of feature bits in CPUID_Fn80000021_EAX
>  target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS =
and
>    SVM feature bits
>  target/i386: Add support for EPYC-Turin model
>=20
> target/i386/cpu.c | 439 +++++++++++++++++++++++++++++++++++++++++++++-
> target/i386/cpu.h |   4 +
> 2 files changed, 441 insertions(+), 2 deletions(-)

Hey Babu and Paolo,
Is there anything outstanding on this series? I didn=E2=80=99t see any
further comments.=20

Anyhow, I did step thru this patch by patch, LGTM:

Reviewed-By: Jon Kohler <jon@nutanix.com <mailto:jon@nutanix.com>>


