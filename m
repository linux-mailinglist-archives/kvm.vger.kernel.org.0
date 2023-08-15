Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C1877CF55
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbjHOPjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbjHOPjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:39:20 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779979C;
        Tue, 15 Aug 2023 08:39:17 -0700 (PDT)
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FFb6E0013496;
        Tue, 15 Aug 2023 15:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pps0720;
 bh=jEC+TeNUiwrzFlSotmJp3Ft/S6A3M9dB0/gWEsBM/Mo=;
 b=OtmsK8THelaPgutZy/y/bahiLYySRHT+nWIKSZElQ2tG+R8k1TCxxyXBOmcnuB+yBPLP
 DZl01ZdatM/RtkZk+0M40X5ppwxPrrMsPP9MsOzc+grmuqX7rNcmkQ507kE4RSjpVn0C
 wfidFNfsV+Ku5xuBIV+wLUvzGBwwHwYJE6Q/jW4ZnyIpmMN70vVfulAk6DRCDC9rlX3F
 weAjexpkY0nS8erdegNGYLm8uCjgQAr+aLmXzavDk3sASKM6eZQxWVX+E+Oy0c8a9G4g
 wuLc2CZVrsyw68p3JAMNeM1T4mjUTJBYK/9Mrvc1MPOEzl1+VBw/p/I2RsSnBvw0HPJ9 Ug== 
Received: from p1lg14880.it.hpe.com ([16.230.97.201])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3sg3d7m763-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:38:44 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 5FA0E80173A;
        Tue, 15 Aug 2023 15:38:43 +0000 (UTC)
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id 11BB080F05A;
        Tue, 15 Aug 2023 15:38:41 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
        id 3D20C38174D; Tue, 15 Aug 2023 10:38:41 -0500 (CDT)
From:   Kyle Meyer <kyle.meyer@hpe.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hasen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     russ.anderson@hpe.com, dimitri.sivanich@hpe.com,
        steve.wahl@hpe.com, Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 4096
Date:   Tue, 15 Aug 2023 10:35:39 -0500
Message-Id: <20230815153537.113861-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.35.3
X-Proofpoint-GUID: 6Qly369R3V1TXJloQGeEWqv8sWF6sTgc
X-Proofpoint-ORIG-GUID: 6Qly369R3V1TXJloQGeEWqv8sWF6sTgc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1011 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase KVM_MAX_VCPUS to 4096 when MAXSMP is enabled.

Notable changes (when MAXSMP is enabled):

* KMV_MAX_VCPUS will increase from 1024 to 4096.
* KVM_MAX_VCPU_IDS will increase from 4096 to 16384.
* KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 64.
* CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (0x40000005)].EAX will now be 4096.

* struct kvm will increase from 39408 B to 39792 B.
* struct kvm_ioapic will increase from 5240 B to 19064 B.

* The following (on-stack) bitmaps will increase from 128 B to 512 B:
	* dest_vcpu_bitmap in kvm_irq_delivery_to_apic.
	* vcpu_mask in kvm_hv_flush_tlb.
	* vcpu_bitmap in ioapic_write_indirect.
	* vp_bitmap in sparse_set_to_vcpu_mask.

Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
Virtual machines with 4096 virtual CPUs have been created on 32 socket
Cascade Lake and Sapphire Rapids systems.

4096 is the current maximum value because of the Hyper-V TLFS. See
BUILD_BUG_ON in arch/x86/kvm/hyperv.c, commit 79661c3, and Vitaly's
comment on https://lore.kernel.org/all/87r136shcc.fsf@redhat.com.

 arch/x86/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..91a01fa17fa7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,11 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
+#ifdef CONFIG_MAXSMP
+#define KVM_MAX_VCPUS 4096
+#else
 #define KVM_MAX_VCPUS 1024
+#endif
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
-- 
2.35.3

