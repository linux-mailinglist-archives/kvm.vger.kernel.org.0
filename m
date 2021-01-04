Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B72E984B
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 16:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbhADPTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 10:19:03 -0500
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:22784
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727375AbhADPTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 10:19:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFT1BzH3VIalFOuqOvFz2q7yWmgKDqvb8p8DDOvTK7OjYS2eK2T0tojU1/Px2YH2xs7Ig1tPJnexlrZI6k68v4ZcRXqccDdQlea4esh8+Rvc6JPTmeaz1gd0xonMwFaVi0tvGJvKH7xpxl0zDJAtYEjG65FNwNXJ8FH1nVzepmF66EtxT7RenrlbilRcm7dHq1dN6Ctcmlq9AWQ8YHW/HR6J7ymje9D6zlhqZzJEbfugEQg51IS17JyZmfbDIGDLM5eNWaQi5UmS4nPwnLK6omu6/LripBVZhkVyoXhM5NBMIqSCCHtNY9CETKC/06g1cT/AySIkhhzRPNiKrcIVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+529ZXrdpzI5ti9EzZmRk7VhLaTGsQTBuDjeGdkRfY=;
 b=B+CoGeDUP88hwdHhx31SchcsYUn+e5uJtbn62RYBvIrWtZLDSJi2mQPBXtN61GHjcqR+2Rv7/JvUoLpFgVcVsQEQiWIMmb2SqZb6PtuJrSvclUhkNqsEiK5Z1yiGceYs/zIOFlaTfs676uO6Dlx1AvID7IWKDkpgp1i0h1h5lZ6BO+3VIXRm1Ti6vEY2Suw2/3V8B/Wr7uA6QRWaYo4abVUOcnW+TCx9OgsJfcrmeRysHYg69TCU49pgEZw934GRFo5E2nq1z52WRTj08YB7v+vCEpwiHz9yWabXCJfN74FraVODg7V5sKJgWkYGUbCtC2Hj+SdZveVbwEsEuf8X+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+529ZXrdpzI5ti9EzZmRk7VhLaTGsQTBuDjeGdkRfY=;
 b=xChUYL8IAEBFeScPDHKPm6yDLsCy0PdzkDHRDISHelr/e2nj8syZM0iqCXxAyg3BQuXrTCEu842wcSg5BGWju0U4AX8ZSw7fw66CPcLr2OhkChI7R1+ZRfrqCORoWzk0jEleeAlhuSZxEroyVT22xJi7ns9+aQmQd9Dd3O1JyG8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2719.namprd12.prod.outlook.com (2603:10b6:805:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 15:18:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 15:18:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] KVM/SVM: add support for SEV attestation command
Date:   Mon,  4 Jan 2021 09:17:49 -0600
Message-Id: <20210104151749.30248-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:806:24::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA9PR13CA0110.namprd13.prod.outlook.com (2603:10b6:806:24::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.4 via Frontend Transport; Mon, 4 Jan 2021 15:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a9f8aaf-4a8a-4306-fb89-08d8b0c3efa0
X-MS-TrafficTypeDiagnostic: SN6PR12MB2719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2719C80BF3C4E198705AD14FE5D20@SN6PR12MB2719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eqa9uNHVxaNiZ3aGnxMD52HozRzoNKmNqvVo7oY/QPD+tCFvQROVyRUvRdeCduvXZc5jqboCLwwzS3T/QQFI2B4ptiXBLTaAooAbC1vhQaspwHQbFF+wLbVZoP/oioGR0rUk0AKy0hZyGamKCPAPM7PsXDK3q5y+BSHpyqYdXTCv2AzPnb1yAHnxnlxcx40G31ZyFWl/Wr5YilBmyAKA57vtlteDDQVibDHz22OTy8ekcT4I0ZaA4+q9UDKN9h9XBEeparBEzqwYPSE3or958ldwxZ9T3zxKmTkuHn6KnceNdz7vZkmYCNMsJDLfHNu6sM4gEInuoCqHuU3KTGTusWWdA3LB1OiPQDtq2Z9kBHZWgIPy+Xnm550/2XAW6pAx9ZGAjpX1d5AWWeLDNN6XMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(7696005)(52116002)(66476007)(66556008)(66946007)(44832011)(6666004)(26005)(8676002)(316002)(186003)(6486002)(54906003)(16526019)(36756003)(8936002)(478600001)(4326008)(956004)(2616005)(2906002)(86362001)(83380400001)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oQS6HOsf1pXvAQq1enkbWPr3tuhx0OT0OlwAao0XnU4+MdKmsMu8HTvdJZ3o?=
 =?us-ascii?Q?lQXOmiJHoMf3JRUTj/np0GgKrOpCDIbQgiHhXx79nro1izBw/wzy1BFKoWPq?=
 =?us-ascii?Q?0ETjqjIiVtHRmPfAajuJZFzLonCnU2BVtK3W8HsrJugfnHnFWh0u7T3UI33c?=
 =?us-ascii?Q?9sIVhsAQO9C3Hg95JueMOUBA9XUtJE7VL0LqUrD/56wYfo/DrQaUBJzG7CjA?=
 =?us-ascii?Q?xYhNUbcnkEIM/jb8qP7KSfzaZ7edCXkW+5bKLqyloXJ83g1UZ2OzZw0DsPXr?=
 =?us-ascii?Q?K20Esph620cJtdZwulV5RpP1E5N2uF/fwCo6cYQEUjeJHM25U9AWMkZIk56L?=
 =?us-ascii?Q?G6gbJ/tj7itJMRW72IxF/TDaYVV7iJB1VTatYw1cIF7oW/yRDdBYuE6fGyz9?=
 =?us-ascii?Q?ppNIQX6TCfoyuIH4Z0Js8sES3XMwlh4iAb+xx1kXDhE8Cp/0qICIOgoo5t5r?=
 =?us-ascii?Q?cn21YHmLMwAQecZ9tlEXgPDZ4AzL2zop+DyFv4ycuCOMB71FlymkcT4LuUrJ?=
 =?us-ascii?Q?nar6l6xst6BvbuWtR8jW6AmMRTlYKlncBMLB8dTt5rkh6p9MKRAulOb4wvgH?=
 =?us-ascii?Q?gTcO22UtFnYBOAbpC87lGllCOSpSZT6gsE3I0NC9eW/p/PdrPt8wFUespmUb?=
 =?us-ascii?Q?YnWJa4KOOAsKJydhQVd9pjHnxL3zQtFF4xSyKJ98A8DGdhWyCH2V8SMxnqUl?=
 =?us-ascii?Q?Da/aD/u4gAhKmKEpk1+IUpXh7Zl4PD2gAt8jPbU6Xlj1eP4qNTPIX58UvL5S?=
 =?us-ascii?Q?HWpHQNYC7Xb2ocFCZVrvpvlai5zQF9hiM84hMUvO0qeORdbyaSzZBJGfXBgh?=
 =?us-ascii?Q?SmohWLZkntSQtDH58WlKFix3kgt71al7w18CWVZhFfMsHzp+KDV8TLbnwXlZ?=
 =?us-ascii?Q?5K4oZ5uKSh9JWHGzsTa2D9xHkcEkSaJX3IlYcWhZchWy9mgqPXlQnaMfrgYx?=
 =?us-ascii?Q?vdhuSeEsXf7KZzSAn7WacFwKUcSAwtTdMSeJ3iJLUI8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 15:18:05.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9f8aaf-4a8a-4306-fb89-08d8b0c3efa0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WNVfO5lDpdOXKBMrx+P2yXSyyrHHlgojQVvoKMZUDT+aaVacbizOqKHlkwEHFoPm6kKBwkSvXuns0XjLdUW2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2719
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV FW version >= 0.23 added a new command that can be used to query
the attestation report containing the SHA-256 digest of the guest memory
encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
sign the report with the Platform Endorsement Key (PEK).

See the SEV FW API spec section 6.8 for more details.

Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
used to get the SHA-256 digest. The main difference between the
KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the latter
can be called while the guest is running and the measurement value is
signed with PEK.

Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: David Rientjes <rientjes@google.com>
Tested-by: James Bottomley <jejb@linux.ibm.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
v2:
  * Fix documentation typo

 .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
 arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 17 +++++
 include/uapi/linux/kvm.h                      |  8 +++
 5 files changed, 118 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 09a8f2a34e39..469a6308765b 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+10. KVM_SEV_GET_ATTESTATION_REPORT
+----------------------------------
+
+The KVM_SEV_GET_ATTESTATION_REPORT command can be used by the hypervisor to query the attestation
+report containing the SHA-256 digest of the guest memory and VMSA passed through the KVM_SEV_LAUNCH
+commands and signed with the PEK. The digest returned by the command should match the digest
+used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
+
+Parameters (in): struct kvm_sev_attestation
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_attestation_report {
+                __u8 mnonce[16];        /* A random mnonce that will be placed in the report */
+
+                __u64 uaddr;            /* userspace address where the report should be copied */
+                __u32 len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 566f4d18185b..c4d3ee6be362 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -927,6 +927,74 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	void __user *report = (void __user *)(uintptr_t)argp->data;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_attestation_report *data;
+	struct kvm_sev_attestation_report params;
+	void __user *p;
+	void *blob = NULL;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	/* User wants to query the blob length */
+	if (!params.len)
+		goto cmd;
+
+	p = (void __user *)(uintptr_t)params.uaddr;
+	if (p) {
+		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
+			ret = -EINVAL;
+			goto e_free;
+		}
+
+		ret = -ENOMEM;
+		blob = kmalloc(params.len, GFP_KERNEL);
+		if (!blob)
+			goto e_free;
+
+		data->address = __psp_pa(blob);
+		data->len = params.len;
+		memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
+	}
+cmd:
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
+	/*
+	 * If we query the session length, FW responded with expected data.
+	 */
+	if (!params.len)
+		goto done;
+
+	if (ret)
+		goto e_free_blob;
+
+	if (blob) {
+		if (copy_to_user(p, blob, params.len))
+			ret = -EFAULT;
+	}
+
+done:
+	params.len = data->len;
+	if (copy_to_user(report, &params, sizeof(params)))
+		ret = -EFAULT;
+e_free_blob:
+	kfree(blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -971,6 +1039,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_LAUNCH_SECRET:
 		r = sev_launch_secret(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_GET_ATTESTATION_REPORT:
+		r = sev_get_attestation_report(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 476113e12489..cb9b4c4e371e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -128,6 +128,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
+	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 49d155cd2dfe..b801ead1e2bb 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -66,6 +66,7 @@ enum sev_cmd {
 	SEV_CMD_LAUNCH_MEASURE		= 0x033,
 	SEV_CMD_LAUNCH_UPDATE_SECRET	= 0x034,
 	SEV_CMD_LAUNCH_FINISH		= 0x035,
+	SEV_CMD_ATTESTATION_REPORT	= 0x036,
 
 	/* Guest migration commands (outgoing) */
 	SEV_CMD_SEND_START		= 0x040,
@@ -483,6 +484,22 @@ struct sev_data_dbg {
 	u32 len;				/* In */
 } __packed;
 
+/**
+ * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
+ *
+ * @handle: handle of the VM
+ * @mnonce: a random nonce that will be included in the report.
+ * @address: physical address where the report will be copied.
+ * @len: length of the physical buffer.
+ */
+struct sev_data_attestation_report {
+	u32 handle;				/* In */
+	u32 reserved;
+	u64 address;				/* In */
+	u8 mnonce[16];				/* In */
+	u32 len;				/* In/Out */
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..d3385f7f08a2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1585,6 +1585,8 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

