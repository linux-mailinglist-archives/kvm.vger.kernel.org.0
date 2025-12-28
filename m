Return-Path: <kvm+bounces-66732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 07DB5CE590F
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41CE8300FE11
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 23:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF86113B585;
	Sun, 28 Dec 2025 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="NUTq8IiE"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host2-snip4-2.eps.apple.com [57.103.66.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E292285CA8
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966148; cv=none; b=QZyLYzhZWLcO1IT+ESsafpV2allPWDgUW9CO3qfvC7sdIhMCEmk/6o5cja6Ejvb12DGfdQfbdiu92I6JigQ1OYsWgCRoBzFxmKhlKy2+atZhWroIdaI6+AHhQJ1qjlVwAuGztnfw6UHD0ZfBAIPjYjE9p92MIRkvVPy61+zKP3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966148; c=relaxed/simple;
	bh=Std8vhl5XVqnH6KDZNU5jTMgCSlZUu668RDV5S6M6M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFksWdCm0vnwDMeYZ6jFH+Ow2NRb6d9MUIR6vimDxwU+JMKM/Cjnm7a2uyoczgp7WbZk8nRbMyfvxzyvPB9s74tqNKiVNItT7BzSnsJfFaa4cDBJ7YINSAN6hoHRsoo/xJMqMPdScP0Hi/2OfJG1LY0ijQo8/HrbptO3+9q2lew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=NUTq8IiE; arc=none smtp.client-ip=57.103.66.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id 307A5180015B;
	Sun, 28 Dec 2025 23:55:43 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=lE935EhSo6eiiRGBTf1TCzdO8HBh375WWDyS664DB/c=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=NUTq8IiENXuXg33x+OZ06YbUXbdW8TqrjQDhtVa64u4BQW1SK+lLNlOOIQrC0dfZU39Vup09miq9vghrXwn50ZAE2xJNGgHHSC9hGQTbofthSNo3ZA9Ya7DmYVLVyRmomPSACV/ucK8AW4g5P95esl2m/7S+/r0OBj3+a3LoSFnCg4ZiPYwgnk97N2WxySOzG3dbbvq5R/QiCUM8EJcpVz9HZAL5/Bj+7s3HBj3jdgZ11L4JS0cuc9THJym2KCx+1LJRrwohl/8oOJm8fbWtn1aTcuX3Zk95B81I8gPmxl6fO/hb79y5vqMt3MNR3WKrogJLY/AvEgK+DSj9hdnLWA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 3ADB11800755;
	Sun, 28 Dec 2025 23:55:38 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org,
	mohamed@unpredictable.fr
Cc: Alexander Graf <agraf@csgraf.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	qemu-arm@nongnu.org,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Cameron Esfahani <dirty@apple.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v12 03/28] qtest: hw/arm: virt: skip ACPI test for ITS off
Date: Mon, 29 Dec 2025 00:53:57 +0100
Message-ID: <20251228235422.30383-4-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info: v=2.4 cv=aNf9aL9m c=1 sm=1 tr=0 ts=6951c380 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8
 a=1t8nasy7xzbR8br5Zw8A:9 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX4veoBlSlau7S
 X/EK76yLhK9HBf9Rltiu8l49mP8jzx1OjGWwxG5FO0o2iknbZhrt3dD/8RBRGdRSizwczAmwI6i
 PWF52JeT6ppSFjdyFAdqSG9mNE9ikxi8PHyE5yXVfDkVOL/B4yaZfLB+ifbjMa8e38gL/G1LwPq
 oTcmeLcMeLj9dTFlnrCr5VbT9kTDgQajjeQM8IGcD5FD+LkQrc1+1fu00Nds7Ce4H9vN3jkj6X2
 3qLd++nvXiobX4Wb2vAJnVqNERUrDqAH+eLaWWv2yVMt6/fpwxwj17ltVVhpcSkE0lxbKKFSrw/
 AdEq+fCMYOAHv2vh8ml
X-Proofpoint-ORIG-GUID: BO4dTnxI7MPXiEQel8doq6bcBsigBof9
X-Proofpoint-GUID: BO4dTnxI7MPXiEQel8doq6bcBsigBof9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=910 clxscore=1030
 malwarescore=0 mlxscore=0 adultscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAAB6ujN0HzKfP1mxylqRawFQH98olFt1w7OZSP5birJjbpfjDMzDJX9c8+6VZRZm7Q0iufF0wA2N70PBKEmqY8kS+XNdN2NQww8xElh6fk7Na6WwcJQjQYtoWlnA9JVha2/sNWgj+VseLLKHwfhsZqMWuTNq5aGuXDd6uQRLUAor+dpFpZn2L2GTBC19IZF2nNDokdzIfkFB+xtnZFIkIve3lVYS2fTuRPXnglxdFZuvjnMknvr2tlazFDpanfDNce9PHchUyLr4k1EKbKEMh3OlNUz1m4BmebaE8AHSmRvH1rQjW/E3MpACISCaFu1i7r9WKsNGqnJKQir9SHDGw5JmcBnQx11cs+4tfHE1O0Os+szahKHhuoYn9h/aWNGWwre9jOfWh5Ygxa67G7AhqU7Sln2/1D7ELajlFOxjPmjzk0Zf3Z31WsA+MCmvnTd/qcq5gjj2vVsClOPcsmDnb7LN0dj1eeHc48e6nj8kqetOYW5dEvs1jN/ocPB4JEEEYCt78QNQ/cO+4Z+wXQzgsrGkNaYrODzNuQq5rQtqu7o6cV4cV/5WPLiFTmM21eTfjSkxD6+HARwTmVmsDmgKX9uOHG8NMRTFekgedwF9UFdBhrfexg+fYZzEWP0LU9cacmfp6ViAYoCPSsrg7dVh6cmbU4sc2o76ejVB0DTH0hNrvMJj0TbP7r9q7IFcAt9i6FAjOmMOUgGYaCrOlxrWabLgf6yk4o3jNg3l4n5eazCdLckcpI7o/tBbMHe3iV0w50aWOdUmbHNgJLzFZmQ1EyozaJXdcHuqbP+T5ybNg/r9F7zifrEhZDRVe7MyJxkvWZ6/+LAYpnVf6XiYchgyuMp2u+xDqUnbfNOZhIXsAp4VHDzXaTPdwAeiojo/ztwjNhJQfCm181h7w20+IJR8SEYYGGzOyWrZqtJch5P3OHF+mXp87fuc94zIF+l6/bZPfmIn2lLpsZ82vM=

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 tests/qtest/bios-tables-test-allowed-diff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index dfb8523c8b..bfc4d60124 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1 +1,2 @@
 /* List of comma-separated changed AML files to ignore */
+"tests/data/acpi/aarch64/virt/APIC.its_off",
-- 
2.50.1 (Apple Git-155)


