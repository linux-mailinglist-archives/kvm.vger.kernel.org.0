Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F05CF597
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 11:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfJHJEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 05:04:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39164 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfJHJEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 05:04:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988hY9d149324;
        Tue, 8 Oct 2019 09:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=IGWEYxl9bWVz7EM8e449J5MsQV400hBu8xSSmkfuH5Y=;
 b=Ug0V9g2/xFiWAJ9gcJT8JwES+xE+q3crBqwiDt+3vEZjyAEiYxPiOJCW0sL7jN4S7hcH
 9aTMssjDRoIPNznIfnd81gstSNC5WWpOb54GtDMRMvPL6lPjF96gJIyHmlwUXTAVJ4ID
 HyBRfAEfQftQ3Ew9mNEpv17J4iBx+y/9AJ+oXvGO64kseVDmURntDsqKi7XA7soTVPyL
 yWRJ50BYI2Vo+VBkcQoOPjGyx623d5GY2TzhIZ/HgcGJpYfmOdxeSBVxN9mT0JZJrtqO
 Z9+ZKU4M9UOCp/aAQqxfWSg4qkVAwvk07DSVnVnCMxAAVUOxXMxeW/CHUjM9KQE544jO ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4qc3ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 09:01:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988hvL1027599;
        Tue, 8 Oct 2019 08:59:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vg205ur7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 08:59:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x988xtpe023595;
        Tue, 8 Oct 2019 08:59:55 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 01:59:55 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v5 1/5] Revert "KVM: X86: Fix setup the virt_spin_lock_key before static key get initialized"
Date:   Mon,  7 Oct 2019 17:04:27 +0800
Message-Id: <1570439071-9814-2-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 34226b6b70980a8f81fff3c09a2c889f77edeeff.

Commit 8990cac6e5ea ("x86/jump_label: Initialize static branching
early") adds jump_label_init() call in setup_arch() to make static
keys initialized early, so we could use the original simpler code
again.

The similar change for XEN is in commit 090d54bcbc54 ("Revert
"x86/paravirt: Set up the virt_spin_lock_key after static keys get
initialized"")

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/kvm.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e820568..3bc6a266 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -527,13 +527,6 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 	}
 }
 
-static void __init kvm_smp_prepare_cpus(unsigned int max_cpus)
-{
-	native_smp_prepare_cpus(max_cpus);
-	if (kvm_para_has_hint(KVM_HINTS_REALTIME))
-		static_branch_disable(&virt_spin_lock_key);
-}
-
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
 	/*
@@ -633,7 +626,6 @@ static void __init kvm_guest_init(void)
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
 #ifdef CONFIG_SMP
-	smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
@@ -835,8 +827,10 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
-	if (kvm_para_has_hint(KVM_HINTS_REALTIME))
+	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
+		static_branch_disable(&virt_spin_lock_key);
 		return;
+	}
 
 	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
 	if (num_possible_cpus() == 1)
-- 
1.8.3.1

