Return-Path: <kvm+bounces-51592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4FBAF8E2E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D32189EFF6
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 09:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0E420297E;
	Fri,  4 Jul 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b="xS2goS7W"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster6-host2-snip4-10.eps.apple.com [57.103.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695A2EBDF6
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 09:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751620541; cv=none; b=s/ymDdbaRJ/83zZkoyh/P2FiXz1Nps+rGLFRswIPl2xud+hdAdgRyf2u4YMZUr9dL5rxUOipctGrd0kJoN5n7OpFVmCbjOP758In1Px/jJ6PhXSQSgy1gPr0pl9u9FO8OyTbE316nhzIXlDJiK2O3GiSbgyVxHvfpCBLvXjaE4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751620541; c=relaxed/simple;
	bh=Kjv69prOm8o+3r+NqxkFDhjMCJxoTAlRl95Ze5nfxEA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mog8Qg2Lur9SnqvjMz5EX9hdyekFvVDGEZu1vt4msF4A+S9DF8b4oBrKWE+w6WXqVgudWxXzvjFMdJ7hUdbQjbkPrRVBcKpk6umu+k6ww1tN4A5q6+6fpZ+smxEQZakZaowE/xrqPS6DpnF9flNJsSNVP2LDtIhe4LxjwW0ky0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk; spf=pass smtp.mailfrom=ynddal.dk; dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b=xS2goS7W; arc=none smtp.client-ip=57.103.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ynddal.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
	bh=Kjv69prOm8o+3r+NqxkFDhjMCJxoTAlRl95Ze5nfxEA=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme;
	b=xS2goS7WwTuKPCViMH0migXPvotSjFTOMJX4WC0myqeknuiudpPLpXVjjaPz8TfbG
	 4jZ5Q3HdXfudLhiiDVKU/ZoIkH0tRRGG1mZxxWlLjXQ3mJjHlU7f9sHbeWoQ28gQWu
	 9zOY1LH+5lDvA0il/64Nuf455dokswvcb1NBJlvg5W3TS3qnjl9BFIV3ytE/dXbDp/
	 7eARKqxG23myt22CRu9kgHKlkB5Fqwy2DsGg1h2RJ25f43ZIptPZPrPlQ3gJtDFxEh
	 WLFttmK9kFM9Dax6r7+hR4xH0K1V1+GCt8Ec2GEmEBP2Km2FjfJj3nxnaljhM++V6b
	 LbEIlaGpoJCcw==
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by outbound.qs.icloud.com (Postfix) with ESMTPS id 4B5291807C1F;
	Fri,  4 Jul 2025 09:15:35 +0000 (UTC)
Received: from smtpclient.apple (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by outbound.qs.icloud.com (Postfix) with ESMTPSA id 6B5D81800367;
	Fri,  4 Jul 2025 09:15:34 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v4 51/65] accel/kvm: Convert to
 AccelOpsClass::cpu_thread_routine
From: Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20250702185332.43650-52-philmd@linaro.org>
Date: Fri, 4 Jul 2025 11:15:22 +0200
Cc: qemu-devel@nongnu.org,
 =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6FE1389-E113-4794-9700-0D7F206C2704@ynddal.dk>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-52-philmd@linaro.org>
To: =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Proofpoint-GUID: zgdamnS0sfl3rAgKV2PMHfZnYsVWOPsv
X-Proofpoint-ORIG-GUID: zgdamnS0sfl3rAgKV2PMHfZnYsVWOPsv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA0MDA3MSBTYWx0ZWRfX8f4Kk4QdcsHq
 iuqkwrfRcCsFTockm9f4Gd1uhET6aMtPDjIxk2/Rdvz64WLQsoivDlHxmvy3VxKPaPfjmdFVqRK
 2dzyM8aUToEiFy+ltDmB4zK3dP7GfLlFrU+EO0TB4UjjE2Oe4IwPsNITB07ycP8e0ClpUN439hn
 OAzjYINiE47597ZxO7WVrBZ2s7xMcBd8XlD3NRPGIQcJFTZ+T3D4XpnErCFFbAg83mi4AdBpDcn
 //8gGA8ko0rdqqU8+TWuviVbzwVRyIiCHZgxuWkumOZe7Wa/TOeKUexPY359KF0ivbQlhmdzo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-04_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 clxscore=1030 malwarescore=0 bulkscore=0 mlxlogscore=865
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506060001 definitions=main-2507040071


> On 2 Jul 2025, at 20.53, Philippe Mathieu-Daud=C3=A9 =
<philmd@linaro.org> wrote:
>=20
> By converting to AccelOpsClass::cpu_thread_routine we can
> let the common accel_create_vcpu_thread() create the thread.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
> accel/kvm/kvm-accel-ops.c | 12 +-----------
> 1 file changed, 1 insertion(+), 11 deletions(-)
>=20

Reviewed-by: Mads Ynddal <mads@ynddal.dk>


