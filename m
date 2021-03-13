Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAE0339BF3
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 06:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhCMFKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 00:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhCMFKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 00:10:48 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A99C061574;
        Fri, 12 Mar 2021 21:10:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x21so1939158pfa.3;
        Fri, 12 Mar 2021 21:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rZiHATcqAxSVuhRyTi2E5mTS4Xv1o3Mg3eeyKP3UZ5g=;
        b=V0LnVckIlEb6217KBYOSW05AESkEojvfEcUII/Z6pX0szMiyJ14AWYcYTWmqKRNgyW
         3+QuyBv4rbEV/DgVbMST/DLbSBUCRI46Ohluk+jzDpZlNywrZ7ZvSXOYVJT8CU0phqJa
         DvzcHXNMFzNm+cUPBU7yvwci1Ran08HuWWvyVYqiyeo7OMmeWNvC76TcqLYyWV/kNRSI
         iTRwlOnFjLKcDXa9EbqQV0KyILtNabSO6ppH71SEMBRM7rQ84xTanzotSexSaU9cVGrN
         kjWeJosqxiluyOdp2OmhG1jt1bF+ai7QsI7n85E2tR5cgFqQwNGYOqDWHMxLfH3RVOax
         sxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rZiHATcqAxSVuhRyTi2E5mTS4Xv1o3Mg3eeyKP3UZ5g=;
        b=gITQAuBGsjgZeqzMxaEHPoneuznKKuZyAqDSdV3YaD+uPX3ztnvs2HN6rIAgcwYVlw
         PeFVmTZDlOVEspxGW4em/XUwstVas9mtKSZsi/7xTxAzjF0o9BOA+nYAGhkFfG41GpGG
         AVLJ2aqtcKCbvlmjGTxUHtQ6ZFvGhc5HT+qsXeOZfEZfbFUabTkpaLtENIK8TgVoHZY2
         GdCzPcNev7hCw6MDx+OMIUuqIPMgtuTnSF4kinxBt5oTTb7D1AVT4na/oyTGSz6tfn8E
         /E8nnBvXJodsi1yGlfRzepimmtww+alOUQvaYPZSWMMnChzSsRxvtudC/ma9N+zqbyBR
         Y/Lw==
X-Gm-Message-State: AOAM530bUeiLrOEv2zhEEzB7IlW+hbFYtSxI9gncLZMWyqyIPCdS23RH
        nHIFZmJEtI3MXx7KET+zWHX+ZoVXWQ==
X-Google-Smtp-Source: ABdhPJwwEf94/agw3SzyxHDnvwR/nCGIQ2OtwLhM46quNqQcjW29ycjh2H/lL7kY+uf03ZjkO0Dd4g==
X-Received: by 2002:aa7:9ecf:0:b029:1f4:f737:12d6 with SMTP id r15-20020aa79ecf0000b02901f4f73712d6mr1562865pfq.8.1615612247490;
        Fri, 12 Mar 2021 21:10:47 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id q95sm3541430pjq.20.2021.03.12.21.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Mar 2021 21:10:47 -0800 (PST)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: clean up the unused argument
Date:   Sat, 13 Mar 2021 13:10:32 +0800
Message-Id: <20210313051032.4171-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

kvm_msr_ignored_check function never uses vcpu argument. Clean up the
function and invokers.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/x86.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 012d5df..27e9ee8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -271,8 +271,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
  */
-static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
-				  u64 data, bool write)
+static bool kvm_msr_ignored_check(u32 msr, u64 data, bool write)
 {
 	const char *op = write ? "wrmsr" : "rdmsr";
 
@@ -1447,7 +1446,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	if (r == KVM_MSR_RET_INVALID) {
 		/* Unconditionally clear the output for simplicity */
 		*data = 0;
-		if (kvm_msr_ignored_check(vcpu, index, 0, false))
+		if (kvm_msr_ignored_check(index, 0, false))
 			r = 0;
 	}
 
@@ -1613,7 +1612,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
 	if (ret == KVM_MSR_RET_INVALID)
-		if (kvm_msr_ignored_check(vcpu, index, data, true))
+		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
 
 	return ret;
@@ -1651,7 +1650,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 	if (ret == KVM_MSR_RET_INVALID) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
-		if (kvm_msr_ignored_check(vcpu, index, 0, false))
+		if (kvm_msr_ignored_check(index, 0, false))
 			ret = 0;
 	}
 
-- 
1.8.3.1

