Return-Path: <kvm+bounces-67197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2B9CFC1A6
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 06:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34E1430A4273
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 05:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155C32676F4;
	Wed,  7 Jan 2026 05:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lgpjCCZY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fZS1McJy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89216265CC2
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 05:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767764357; cv=none; b=F83WICPefOj2I/DICLnvV9ughJ58rQj5JdgvPo28e93mpY3LgobIafSOFyEK0ktJSv5vWZM1xPdxPRb0t17h94raPJIohDd8BB+2jPwp5lKhsFqm0e1Z2hA4JSA+RC/P0qJS2oMySi+Txl5gvl8o3+V1zjlQxWCslCN1cwAN2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767764357; c=relaxed/simple;
	bh=dS/1XwuM3soE4zMznpdoY9Pcwg3cH7gIQnm86dDsTnE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AHGE2E+u9sbXxJk5dhlcBjdspHqODFcxoR3HiWSC0ABi3J705nbKBafS0+bpj44XsFtj74+zxZhFm4xxKWEpPnjKkmjQ+5xP8Twms29H6X3gVlBERaRGTbK0hlUR84fMfJZmabYMfkP8Atk+AMXsfVnot5gUW/oaveT1VWC1Q4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lgpjCCZY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fZS1McJy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606LL48G4048524
	for <kvm@vger.kernel.org>; Wed, 7 Jan 2026 05:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=nAF4cmlQB74fEG5mGg5TgnQuCtp9YvyxuRe
	TZpZX3Rc=; b=lgpjCCZY8d3JmcgYSiQ+SqgGMznI4E+U2Jye7xLB+aYkg9QWA0j
	ECXaG6Bhk94vHg43D9mMkA84tFWdrhPizg0PPAW+XkqFSnhNABg89S68UIuldEMd
	egPmVz5B/LozxRlDCyPEAsh5DqXvfycMoewnWq+XOzbNvFM7aM7oK9s7odYX280x
	Kw2N5FLxRDijWy6+jmijh/UMzGy0GMVA5etpgowBYfI8hbJ88eqiobu/bwFwRhM+
	Oc2NoIQPZx9rjiH6mvK0W91UFCljg4Py30JYZwAnZS8/pwyBejD4LMKL6Tms6tlA
	Hk24zt4ZBiydARsxie0h0xLQWilQQhAK7Fw==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh25rtttg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 05:39:14 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-11f3b5411c7so4924926c88.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 21:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767764354; x=1768369154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nAF4cmlQB74fEG5mGg5TgnQuCtp9YvyxuReTZpZX3Rc=;
        b=fZS1McJylUt/OPJv+3RcHye8Orwkh8ymN/yEbCW7czTCpDH85zyM76g2lwQ25PMeLV
         XFVSpbZy7XzzHB9PpOalMU+HusZU5a+AUnCXStxkea+3BhO23Dh7ZXtJMfV1XKWFhc6v
         LlloVPwaGL1Ba52XpH4Pox+wz0pEPBrEENzrWHY8SlxEAGyyEgwTNhhcsMiHXtwEqkeR
         //iaCHDHkjAobG0cXTjyz4XgJ4psY1uS+g0zE4YbAvUQVMa9h4H1ckClIHPZ7BD32z7M
         sVehqqNsTKYK6mISgi/gLyZY4pwyWGDCGF8LeGk+z8v/KWq6scLdQHdPjY7Toh4tAnyp
         20Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767764354; x=1768369154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nAF4cmlQB74fEG5mGg5TgnQuCtp9YvyxuReTZpZX3Rc=;
        b=YYgdrwcGK8h+mixJnfbkgvfJp4k5BvWMw8YfY4jmiZlO2myiI13pDSFu9oKFbD+Czj
         fEymSvezVf+Zy1/7BRm8x5sw2Mm/ZG8ssmRpy0nM0FUfx8m6NofL47APipppGeakdqWf
         Ite2vDEoT0ooTrBgfFopX410QFh3PeZ+D1MKZogx2QkT3qzcven1QKcpwxWDaeeTHV29
         v0rukgZbiewl9PHJLtKZPGSyhg5zEBTj98x9vHIa5WGfSSq8nzsS19fS8co65z0VIpI+
         S2+gKsQ4/hipCa0Latnu9MPLkiCwXsqgHj/Dg1jGlctr0fNb4qWyoxQYCN8Dt19OGrNk
         lalQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqL2dUYIHhTtJOwNxJgEdgpYXAehjrdIV0gF+krCEP5/AZwlAOTi4/ErvjBMgy4HFWlbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwWK8Q7HO2zRtGWZ0Vi5q1Mn7maOI3Ij44JddGDExFQUPyrsgt
	3NpZLxX+SfTW7TZ0+P4CVxdifEV3MQf3kf+MiCTXdIdJIsBodkBb7Ci9G7xe5ZkxR67eb737DFB
	y+NGirbR/7JrTVbmi/MXWtO2biFcxKtqDiuCf0afDxsFhMs4Y247RhT4=
X-Gm-Gg: AY/fxX44qPvRycWZYpvyf8hk7xAyUD/Wkw2KUzM7olHlv39TbZlxl7Ec3YxS/keB14h
	+qyFReWM8cB8Xe3haq5+XxfHukfILt/Xy0DqFdv1C4sKaS9I4nBA1SQXxLG0YpLJ0JjO3kXIm+w
	9+vM8RzW2jvmAIX/7wOhLbMvCA4QW2v1kIq0Du8XdzuMsODxq3c00Ao3vSSs/qEd2Lput7cEov2
	71suEciJHyORcQoiGitdvEee29pADHNEPZVa3Q+PVOPHlms3O0RSt0udHMc/oncbXTEDRnf7cr7
	kUCRHLHdeKbqI2VjK8EvoEkFOvryihmRn0OBQhjWOuvnOHheSS3hJ7/Q9P9v3xOypC0QxZfPZ8m
	XpgLYPLS/JI9QES7CQePnKkQcC7eKjIpfYdYKtI8ycJqd2jQRAU+fLF4=
X-Received: by 2002:a05:7022:440b:b0:11f:2c69:3e with SMTP id a92af1059eb24-121f8ab67dcmr1318360c88.6.1767764353987;
        Tue, 06 Jan 2026 21:39:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZ4EiGgfSX4Rs6euarnnkwl4nNgaFxGA2YWd9xO1Jenw2cQpcKoyKhKpEXWv2Xw0QZL3aIiw==
X-Received: by 2002:a05:7022:440b:b0:11f:2c69:3e with SMTP id a92af1059eb24-121f8ab67dcmr1318346c88.6.1767764353340;
        Tue, 06 Jan 2026 21:39:13 -0800 (PST)
Received: from hu-liuxin-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f2434abesm8685251c88.4.2026.01.06.21.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:39:12 -0800 (PST)
From: Xin Liu <xin.liu@oss.qualcomm.com>
To: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xin.liu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        jie.gan@oss.qualcomm.com
Subject: [PATCH] selftests: kvm: add boundary tests for kvm_create_max_vcpus
Date: Tue,  6 Jan 2026 21:39:09 -0800
Message-ID: <20260107053912.516913-1-xin.liu@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: K1GmLzhwI5DQfyrLXiLCpF6KyZQIb0nr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA0MyBTYWx0ZWRfXzjzGz1sHiTV1
 RNyAHCe8MLD8GLsm41EXObVwrAb6NyGSw5et65hNiQBDpzMFSyQXoT6yEKLi9IrCkKNf1lDg972
 +mwlBWwIFynkAVcZm5e2BlViy2V/3ctka2E/HdAZmxrllmcmZkAi3DxdhztWeGSas2xwC4JT7O7
 dcjxJZ+Ai1Gm8U3VoCR4TceyUeBgllF/RgjRFWxqV+eCfkcmyNk+3VE3iPwnxbrsNLB4eo6ANwP
 ZXlpuiCrFQIfAQ7iOKDVBGch+YzDj8ygaSs2QJ/lH022V5FJgHDda3+eU+2GB0zdQddtvOrkcuH
 TMi3c60V3InbZEthdFRWjKTFCWuH1BFodk/ab6BDzHrEEz+R2b2A1ftoe6Yxu2s3M2JYRapPIGc
 svY3VTjwXBWa5UtMU1fTnC1e4K0gjhf8F3vzENuBoT0oPvAyIDdyA5wTYOz1pgqefNOqK7VFuaT
 qbORJ72lwSZdPIjGUQg==
X-Proofpoint-ORIG-GUID: K1GmLzhwI5DQfyrLXiLCpF6KyZQIb0nr
X-Authority-Analysis: v=2.4 cv=G48R0tk5 c=1 sm=1 tr=0 ts=695df182 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=uMqdHpgDjcpMDGccECEA:9 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070043

1.Allocate extra vCPUs beyond max count, assert creation failure.
2.Create vCPU with ID over max ID, assert creation failure.

These tests cover function boundary scenarios, ensuring correct
behavior on vCPU count/ID overlimit.

Signed-off-by: Xin Liu <xin.liu@oss.qualcomm.com>
---
 .../testing/selftests/kvm/kvm_create_max_vcpus.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index c5310736ed06..42c88c249192 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -17,10 +17,10 @@
 #include "asm/kvm.h"
 #include "linux/kvm.h"
 
-void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
+void test_vcpu_creation(int first_vcpu_id, int num_vcpus, int kvm_max_vcpu_id)
 {
 	struct kvm_vm *vm;
-	int i;
+	int i, fd;
 
 	pr_info("Testing creating %d vCPUs, with IDs %d...%d.\n",
 		num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
@@ -31,6 +31,14 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 		/* This asserts that the vCPU was created. */
 		__vm_vcpu_add(vm, i);
 
+	fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)(first_vcpu_id + num_vcpus));
+	TEST_ASSERT(fd < 0,
+		"Expected failure when exceeding KVM_MAX_VCPUS, but got fd=%d", fd);
+
+	fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)kvm_max_vcpu_id);
+	TEST_ASSERT(fd < 0,
+		"Expected failure when exceeding KVM_MAX_VCPU_ID, but got fd=%d", fd);
+
 	kvm_vm_free(vm);
 }
 
@@ -56,11 +64,11 @@ int main(int argc, char *argv[])
 		    "KVM_MAX_VCPU_IDS (%d) must be at least as large as KVM_MAX_VCPUS (%d).",
 		    kvm_max_vcpu_id, kvm_max_vcpus);
 
-	test_vcpu_creation(0, kvm_max_vcpus);
+	test_vcpu_creation(0, kvm_max_vcpus, kvm_max_vcpu_id);
 
 	if (kvm_max_vcpu_id > kvm_max_vcpus)
 		test_vcpu_creation(
-			kvm_max_vcpu_id - kvm_max_vcpus, kvm_max_vcpus);
+			kvm_max_vcpu_id - kvm_max_vcpus, kvm_max_vcpus, kvm_max_vcpu_id);
 
 	return 0;
 }
-- 
2.43.0


