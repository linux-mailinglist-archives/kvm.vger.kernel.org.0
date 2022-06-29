Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990EB560B35
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 22:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiF2Uks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 16:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF2Ukr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 16:40:47 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92E18E39
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 13:40:46 -0700 (PDT)
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TKXsoa020052;
        Wed, 29 Jun 2022 20:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pps0720;
 bh=E86g9OTi+9GSwfglC6D+sQ1dmzDovgLH/QYZj84UJuw=;
 b=H8TEdWs1YZ22WF6oETmM6/i73FZvSrjgNdfV3axSX9VISG9ZpzjKj11Pi/07za/PVOhu
 gAgown6iWhQ51Sq1HzMJ0G5+TwgxF0arRwkXh5pudcfZ6YlzCANz8VtLY+mhcHq6NAeb
 nnBysHdxnX8JrC1ztPqJti6mGIEaaffvXIMv6J8sZFMbE9qThO7yk3Q5hYpxIxgWraj/
 Y7ZAOm/TO9B/GvOy6HEPLhpubcy5BuRNy0qr3QrpIgO1oPnxWFxLYJ5HgImYjce+NBmj
 jLHBMw+wOty8Fp7FRDwrgZUc1AGa/UPV2HGPuYKo5WlXVhSywo+L94S9YpSmIJSco7Nf 1w== 
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3h0wkvg7nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 20:39:42 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 1BBC680020D;
        Wed, 29 Jun 2022 20:39:41 +0000 (UTC)
Received: from cat.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id C4FAE809406;
        Wed, 29 Jun 2022 20:39:40 +0000 (UTC)
Received: by cat.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
        id 1B5D595217; Wed, 29 Jun 2022 15:39:40 -0500 (CDT)
From:   Kyle Meyer <kyle.meyer@hpe.com>
To:     seanjc@google.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, dmatlack@google.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, kyle.meyer@hpe.com, mingo@redhat.com,
        payton@hpe.com, russ.anderson@hpe.com, steve.wahl@hpe.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: [PATCH v2] KVM: x86: Increase KVM_MAX_VCPUS to 4096
Date:   Wed, 29 Jun 2022 15:38:24 -0500
Message-Id: <20220629203824.150259-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <YqthQ6QmK43ZPfkM@google.com>
References: <YqthQ6QmK43ZPfkM@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: FbU_7HazLKfe-6kKmSct4P5Zn54vttM3
X-Proofpoint-ORIG-GUID: FbU_7HazLKfe-6kKmSct4P5Zn54vttM3
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=900 priorityscore=1501 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290071
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase KVM_MAX_VCPUS to 4096 when the maximum number of supported CPUs
(NR_CPUS) is greater than 1024.

The Hyper-V TLFS doesn't allow more than 64 sparse banks, which allows a
maximum of 4096 virtual CPUs. Limit KVM's maximum number of virtual CPUs
to 4096 to avoid exceeding that limit.

Notable changes:

* KVM_MAX_VCPU_IDS will increase from 4096 to 16384.
* KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 64.

* CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX will now be 4096.

* struct kvm will increase from 40336 B to 40720 B.
* struct kvm_ioapic will increase from 5240 B to 19064 B.

* vcpu_mask in kvm_hv_flush_tlb will increase from 128 B to 512 B.
* vcpu_bitmap in ioapic_write_indirect will increase from 128 B to 512 B.
* vp_bitmap in sparse_set_to_vcpu_mask will increase from 128 B to 512 B.

Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9217bd6cf0d1..867a945f0152 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,11 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
+#if NR_CPUS < 1024
 #define KVM_MAX_VCPUS 1024
+#else
+#define KVM_MAX_VCPUS 4096
+#endif
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
-- 
2.26.2

