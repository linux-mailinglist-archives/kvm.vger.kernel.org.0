Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348A064D0FC
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLNUTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiLNUSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:18:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A23A31ED7;
        Wed, 14 Dec 2022 12:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLUU7EeRmMR3p8waKF3UpHxz5/KI9Ya0oUNz50N0e6vA2nUkSXbGEa+i9knTlnJF+qOBizcUGuLKXWSxtoFnwo2VSgAgZMbnlRHy/D5NLDqUFp3ar10O+o73I/c9OG3F2xFmyI8mSOLrzVOqPUwmIl9TaS7uZ0fDdREC6WkmHeh0rZrWXHHcfuZINrtM99XbrJwSdov/sZ4Bo73garvrMkVfbmTUizcqmJAJql6M9RtbIkqTT/XxNtbZZN2UKEKg2JZgtvm4kEdaxNw7a5QIj3i7uOuXRHhVTN2jy3cv/JzBYXTrs+0Q3VrCkdayHlfiifcpxGzgGjJ7CqJl2LX/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZz9P8qmQHvOs6Uopb7Yc5wo1GarzMrIlTPJE6hd5bM=;
 b=YgRS4mEkHZRUr9O2MSEDShWtWZGW3AC2fkY+qp4cN3GWNrhn3qj4aEb3GNKD8iZBBc4/72xM02HzAUmoJkII3i06bgR97y9mhYzGlPWludJJgxOVzAAf/xCCN4hgQydsjBqTX7PsO2QQVS2BLjsO5hW+yID9pW2J0DHwqtCaJtQQNNg3T3nn/reJR9X80dGCCtlBpWIkB2yqM5Repq9ERBP5kdhuzlH0mQOwlgM1o9T6saGst6jlTBb4RJKnwG3kjU7BJ68YPELs/PqXKyCTDXAOgfDK2k1zSqrOytpWGDbbWAkwhSHUcvFnm2RKsNZ0bqJqmGUatWip+94iqqnfig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZz9P8qmQHvOs6Uopb7Yc5wo1GarzMrIlTPJE6hd5bM=;
 b=UBimAGV7OuAJFuc1Y9Iin42E4mtyM2xLqHfMit3FVdFSpJs5/hqhXpQP3BKZMGTB/dnLIiSTedinoqnEWeXhjg0z2jup/53pCcXaBXWImeCOKaFGgtRir/04yLmyskavhQbg2T0NwUjql6l4qP+ayeHY1df9VJ7NTKD7qAp2+Zo=
Received: from MW4PR03CA0090.namprd03.prod.outlook.com (2603:10b6:303:b6::35)
 by SA3PR12MB7973.namprd12.prod.outlook.com (2603:10b6:806:305::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:07:24 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::93) by MW4PR03CA0090.outlook.office365.com
 (2603:10b6:303:b6::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:07:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:07:23 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Subject: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Date:   Wed, 14 Dec 2022 13:40:54 -0600
Message-ID: <20221214194056.161492-63-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|SA3PR12MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d01ac9e-efd6-4ea7-2f3a-08dade0ed109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g09cJr1qUVgRLbcdJs2W3PpjccxXzB4XIsyVh7NmjE+dI3ngIJJMjoi0Ya5/MUdDs6tlhxtpG5GnoqkZt9kt9P7+aq4yPshHVWFTjxpQIKyZ/FrsJIkt7MjkNyRV0RzbPkspFyNwqQLLNMEPtUOnDQuLrOetHQbEi6Jp6eFgnBC835FcTynipKLs3OavKSrdR6ZedR/IFj9g+pB2R9gTzkqb9BKyY259pSr6dk1aju2YfOL7vphB0CjIk1Ez72jIvPvlUZ2GzF62b9aQZTrbVecyc8wl0Rpp8pIjpMsJtpdoRLqLld1iD0Me/2q/5cDY2Dq7Ogw0IUIdFxTIK1/sDr1s/CI5SS2dp+V5XVIHsq6rR/xRp1LHenQEp8UKQ000Q0Er3WycD1BnJ91nzyHrxOdCmSHLKNIZPb2Mcn5+cF2JzalUGbVabcnDfapcqpyxltyokRYT2gzr15qtv+2L2sLMb7oDFQNFMqDl5O4GiYlDVUOqJ2Fz5uK6FCNGLpIavYLY48itI/1uZHdu0tzNgJNN2FjLOokLOJDFmED62CG/I1WT2H1iw1z574SJjCCJJKWzsZOBppoS705iHHrf9vkL27Qe4PRej2LpAJxQUZ+AIbuDxlth6IbnaJaWG1btsnGZo9Dk/RL6iHxh4aU3xxlAPepz/DOcSRive9bM7OszOusLUaXPH+nK64l6uBY9cdf7n3ucLcEYG1Dqn3DTnuEbRPMM8Wi69knYtQLEigM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(7406005)(8936002)(41300700001)(4326008)(5660300002)(70586007)(44832011)(70206006)(8676002)(7416002)(36756003)(16526019)(1076003)(478600001)(54906003)(6916009)(2906002)(316002)(40460700003)(186003)(336012)(86362001)(2616005)(6666004)(426003)(26005)(40480700001)(83380400001)(82740400003)(81166007)(47076005)(356005)(82310400005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:07:24.2576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d01ac9e-efd6-4ea7-2f3a-08dade0ed109
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7973
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dionna Glaze <dionnaglaze@google.com>

The /dev/sev device has the ability to store host-wide certificates for
the key used by the AMD-SP for SEV-SNP attestation report signing,
but for hosts that want to specify additional certificates that are
specific to the image launched in a VM, a different way is needed to
communicate those certificates.

This patch adds two new KVM ioctl commands: KVM_SEV_SNP_{GET,SET}_CERTS

The certificates that are set with this command are expected to follow
the same format as the host certificates, but that format is opaque
to the kernel.

The new behavior for custom certificates is that the extended guest
request command will now return the overridden certificates if they
were installed for the instance. The error condition for a too small
data buffer is changed to return the overridden certificate data size
if there is an overridden certificate set installed.

Setting a 0 length certificate returns the system state to only return
the host certificates on an extended guest request.

We also increase the SEV_FW_BLOB_MAX_SIZE another 4K page to allow
space for an extra certificate.

Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 111 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h   |   1 +
 include/linux/psp-sev.h  |   2 +-
 include/uapi/linux/kvm.h |  12 +++++
 4 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4de952d1d446..d0e58cffd1ed 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2081,6 +2081,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	sev->snp_certs_data = certs_data;
+	sev->snp_certs_len = 0;
 
 	return context;
 
@@ -2364,6 +2365,86 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_get_certs params;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	/* No instance certs set. */
+	if (!sev->snp_certs_len)
+		return -ENOENT;
+
+	if (params.certs_len < sev->snp_certs_len) {
+		/* Output buffer too small. Return the required size. */
+		params.certs_len = sev->snp_certs_len;
+
+		if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
+				 sizeof(params)))
+			return -EFAULT;
+
+		return -EINVAL;
+	}
+
+	if (copy_to_user((void __user *)(uintptr_t)params.certs_uaddr,
+			 sev->snp_certs_data, sev->snp_certs_len))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long length = SEV_FW_BLOB_MAX_SIZE;
+	void *to_certs = sev->snp_certs_data;
+	struct kvm_sev_snp_set_certs params;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			   sizeof(params)))
+		return -EFAULT;
+
+	if (params.certs_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EINVAL;
+
+	/*
+	 * Setting a length of 0 is the same as "uninstalling" instance-
+	 * specific certificates.
+	 */
+	if (params.certs_len == 0) {
+		sev->snp_certs_len = 0;
+		return 0;
+	}
+
+	/* Page-align the length */
+	length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
+
+	if (copy_from_user(to_certs,
+			   (void __user *)(uintptr_t)params.certs_uaddr,
+			   params.certs_len)) {
+		return -EFAULT;
+	}
+
+	sev->snp_certs_len = length;
+
+	return 0;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2463,6 +2544,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_GET_CERTS:
+		r = snp_get_instance_certs(kvm, &sev_cmd);
+		break;
+	case KVM_SEV_SNP_SET_CERTS:
+		r = snp_set_instance_certs(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -3575,8 +3662,28 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	if (rc)
 		goto unlock;
 
-	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
-					 &data_npages, &err);
+	/*
+	 * If the VMM has overridden the certs, then change the error message
+	 * if the size is inappropriate for the override. Otherwise, use a
+	 * regular guest request and copy back the instance certs.
+	 */
+	if (sev->snp_certs_len) {
+		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
+			rc = -EINVAL;
+			err = SNP_GUEST_REQ_INVALID_LEN;
+			goto datalen;
+		}
+		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
+				   (int *)&err);
+	} else {
+		rc = snp_guest_ext_guest_request(&req,
+						 (unsigned long)sev->snp_certs_data,
+						 &data_npages, &err);
+	}
+datalen:
+	if (sev->snp_certs_len)
+		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
+
 	if (rc) {
 		/*
 		 * If buffer length is small then return the expected
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 38aa579f6f70..8d1ba66860a4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -102,6 +102,7 @@ struct kvm_sev_info {
 	void *snp_context;      /* SNP guest context page */
 	spinlock_t psc_lock;
 	void *snp_certs_data;
+	unsigned int snp_certs_len; /* Size of instance override for certs */
 	struct mutex guest_req_lock;
 
 	u64 sev_features;	/* Features set at VMSA creation */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index a1e6624540f3..970a9de0ed20 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -22,7 +22,7 @@
 #define __psp_pa(x)	__pa(x)
 #endif
 
-#define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
+#define SEV_FW_BLOB_MAX_SIZE	0x5000	/* 20KB */
 
 /**
  * SEV platform state
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 61b1e26ced01..48bcc59cf86b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1949,6 +1949,8 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_GET_CERTS,
+	KVM_SEV_SNP_SET_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2096,6 +2098,16 @@ struct kvm_sev_snp_launch_finish {
 	__u8 pad[6];
 };
 
+struct kvm_sev_snp_get_certs {
+	__u64 certs_uaddr;
+	__u64 certs_len;
+};
+
+struct kvm_sev_snp_set_certs {
+	__u64 certs_uaddr;
+	__u64 certs_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

