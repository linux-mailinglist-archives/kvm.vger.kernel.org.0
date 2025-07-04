Return-Path: <kvm+bounces-51593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8838AAF8EB4
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9465D4A0D6E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 09:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E872DA769;
	Fri,  4 Jul 2025 09:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b="w2Lqw+F6"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster6-host6-snip4-9.eps.apple.com [57.103.85.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A602882A2
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 09:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.85.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751621536; cv=none; b=IcJB8KC4m2qgpD73EwCmtPm2HUy4W3AIbOE9ncpY+qaZe4LJlT6oL1V7jWsJxXjoawf26ebD7UCAJfavVVbX0RoCBUlsi7dzyt58rYZ36MZ/MyRU5UbE5xsttf4xjxCegrRxTaceq/++K1G3/0IDOrKokYanq8VXrlrnqkpLoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751621536; c=relaxed/simple;
	bh=6GQiI6gDa5hP2KLYK6lXnX7ShiYxf8ecJfJTEChIFz8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AdFsAqE5wljBF5c20ybYChY3c4xo1MQztkcGqCw8NlhaQ8MezXFlAJlY6vzuGCGux8jo4KYiUADB06xFwehqVLDhKH7HhUlUVOoW+ak2Zu+7h9cCbRbSxXktfqCK3YCjbx2isvVkniaKv+u1w5csnh/ueeMiMDvKvAhe7tgCcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk; spf=pass smtp.mailfrom=ynddal.dk; dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b=w2Lqw+F6; arc=none smtp.client-ip=57.103.85.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ynddal.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
	bh=9rEB08GrSiVE+mWLaqMpZs2n04R7skd7dXhDs5UY6I8=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme;
	b=w2Lqw+F6bxlrqGCYvmq8zo0WeLS3eRG69CjSsLO6LLcVikMY0oAvWusWaICebwIIA
	 d/owEDdwYKFOEY0SEcGYbNvfL810oF6M5MtGN42owYij3Ws2awsWi0+Nl0MddkfcNP
	 LrZ0YFuPb7i+f+o9qEAB10Zxzx+wH+h4PtJLcN0WnKWi3y88UMpG87gjjnhjVKJWiK
	 zlTuTYY6v9hFvHvezvq3r3EE9oNHWhC7SQWqNMx3ZkyMHKzdsmecxnxJCtzGmhvktj
	 qOds/ZxNTC2OrcL4t5t3ygKW1Q0cdqGuL8o/JxXxiz/Vf2qsC/V1fB19CugUajqSfv
	 Gec9AHcyOFazQ==
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by outbound.qs.icloud.com (Postfix) with ESMTPS id 09BCE180016E;
	Fri,  4 Jul 2025 09:32:09 +0000 (UTC)
Received: from smtpclient.apple (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by outbound.qs.icloud.com (Postfix) with ESMTPSA id 1E2D21800162;
	Fri,  4 Jul 2025 09:32:07 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v4 59/65] accel: Always register
 AccelOpsClass::get_virtual_clock() handler
From: Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20250702185332.43650-60-philmd@linaro.org>
Date: Fri, 4 Jul 2025 11:31:55 +0200
Cc: qemu-devel@nongnu.org,
 =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Cameron Esfahani <dirty@apple.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DAE33222-93C1-4B29-A224-7FA6A4F0344C@ynddal.dk>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-60-philmd@linaro.org>
To: =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA0MDA3MyBTYWx0ZWRfX7ooy855ftlpJ
 382CqUnUzm9dvWFlJ4w3bZfbYCF+MOcu5YUJKVmNOQpMuB4hfyDeyYm012SCcxKjAoJ2iYF5NSI
 uirMv84bFEsrokKwUyE7eZorMGGObQZQzT6Inhhr9LehDsMZ1d1NY+RZTif+jvTs5FmpsQI199M
 sVsCd61OOzoBpfVIKqo3XaY74UAmhzazAduwUmWFJZpb7RSDpO8ottAZc/q+sjsCWln8q7BT5rU
 oW4o1oxFfr5sSbP3gC5XOoUOe0VJ3zhCKD4GAn8XrRsTgOFSWSKtJrn77XxbyXc5UG5CdariU=
X-Proofpoint-GUID: yZKEds9rpVCqOGHR4JbLjQYUEdwGwxVu
X-Proofpoint-ORIG-GUID: yZKEds9rpVCqOGHR4JbLjQYUEdwGwxVu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-04_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1030 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506060001 definitions=main-2507040073


> On 2 Jul 2025, at 20.53, Philippe Mathieu-Daud=C3=A9 =
<philmd@linaro.org> wrote:
>=20
> In order to dispatch over AccelOpsClass::get_virtual_clock(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
> include/system/accel-ops.h        | 2 ++
> accel/hvf/hvf-accel-ops.c         | 1 +
> accel/kvm/kvm-accel-ops.c         | 1 +
> accel/tcg/tcg-accel-ops.c         | 2 ++
> accel/xen/xen-all.c               | 1 +
> system/cpus.c                     | 7 ++++---
> target/i386/nvmm/nvmm-accel-ops.c | 1 +
> target/i386/whpx/whpx-accel-ops.c | 1 +
> 8 files changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Mads Ynddal <mads@ynddal.dk>=

