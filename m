Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041452CF632
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgLDV3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:29:55 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:55512
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727176AbgLDV3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 16:29:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUOfDAJiELDA1uPv/EQkXpqwI7lN8w4yohoUe/0iOETboGuJX4JQYYwdPEUMBfl30ZUQb2JcuRqEaOns3vGDfwLay+hMW44twE80u3tMwOdvKpSd26PI+JhditjwhfT4gp4bvYzLdmf5Kdy4EzlbLHrtM3reMF39kFbiBQif1w97mzbeeS6ve6YJ+5Kip/Psy6KErcC+ecg/LhxHQgQ5YuKfLV9FjepkOJwBBB0l0smF3LMpPJqUmvFvZ705HHwOkYIhRbE/vg4PBaN8nLEMZjSfG8nBlZcCspH2wY0tXRh4IrF3mAI+vYSimimqUWWQnGyaWytI1nRY0RbPZ6GVPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+3dsg26zcWEAFfGxMccFYO1iXI3xw/02umty3122hY=;
 b=JOGqvYicnt0sRtOI2tqzH1hjOPn9nD4mTNLBNYVbvlFXmHk1/xdQ7iPRdLjPY0PzSpsaKcnMODc7YVAYWRhczGA6awgRG6lNPQi5PSu6lvt3qXEQgsTLlX2nRBToVYKOT/EjDz1lvnU30Kg3Lz40ERerSJz3WCoMa2+6AYGGkdomcoHS9DgUj5pEaltYN8nh5Lls6mYYpyEPZTFkImgpCwFtgM320Fslof6tXaDA0GQ/AI9jVlFKL6fkkmPtiHZgmbe9MldK2ghkV589QEYI24Up3k6g989yWRrlm//FhLXyNHOYjK43v/vYdQRDxRV6MrDSxuSiZpuTuoCQVsyJ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+3dsg26zcWEAFfGxMccFYO1iXI3xw/02umty3122hY=;
 b=KqatlDw2rIJBSMG8hQXC+B7gPDCWvp5kT856EClqmyciHQ83gjkrnKI24mZusCQ4Lt7Qy78Yw/uoFOil1G2LUIid0Fv9Q+/cVnxxKDIsI+/+OsCob8lQAExhiC3hzXTVKjmm7fGzfOnulE6lPfLmM7uIEDeMQ1zPaWbopKowxAE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 21:29:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 21:29:01 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] KVM/SVM: add support for SEV attestation command
Date:   Fri,  4 Dec 2020 15:28:47 -0600
Message-Id: <20201204212847.13256-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0039.namprd04.prod.outlook.com
 (2603:10b6:803:2a::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0039.namprd04.prod.outlook.com (2603:10b6:803:2a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 21:29:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c979c4e3-97a4-41ee-2886-08d8989b9e30
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384B6247DCF1A21F082D293E5F10@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJJ5qf81Cpev0/6oWnEHAK/6t8IUI4nkleXZlw31je3I7RAzBGGt6Ew7cIPaORGuZ6cftBW7kgm2qNny5fjFkSlFOM9QWWJShxRMQRA36+jTNdDZAK1GUIjbgWI8uE94u33hXfy5q1qfaETNyEQgOTgZSZlRkmJATpsgI/fuJkT9oq9q+a6NiKFm0dzEQGCjCkIHga8MNyMMHAWI2OHxqrZyR1SxxJ15QgM6MyHrmCYvY6Ycsqjb7r+PRdYTV7Ip3xncARkownBbCgt6rS6FFClLSFwW4bajWM94lybG/d250mvjpJ1HK1sUZUW9jZVfVajNp1aBB1jTFm8HSAvaFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(6486002)(54906003)(8676002)(316002)(4326008)(52116002)(2906002)(7696005)(2616005)(7416002)(8936002)(1076003)(5660300002)(6666004)(83380400001)(6916009)(478600001)(86362001)(956004)(16526019)(66556008)(36756003)(26005)(66476007)(44832011)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OD1sqorUcnJLoj10SlQCbCpBABhesB/vBNrwvWCLQiyxs/3LkWi/6fPsy2FM?=
 =?us-ascii?Q?NQjgzEZxCjGFMU54Z0xZyFh//uorwUFNt6RyCEVXwLjQDPFaneZ8oxeGbGlS?=
 =?us-ascii?Q?iz9AH85G528kqW+EtgpGWLnnqT3UcW2gvaQceROo86YBid1hU3YbT98bL7Ls?=
 =?us-ascii?Q?HdY1WyLU+1XrBrU0ziliakKNfJPmzzxEpnj1/aljw1amZ2G3YLT1V4Gbu5fA?=
 =?us-ascii?Q?y0w5ndjKtwX3T1GRDkN1bVV1R0dOP4COonDeiON7zG0U2hB6I/UDjpipBFok?=
 =?us-ascii?Q?tUOuhl+htB7fLdOuUj8QpjhMkmgDmVNploFDEotgHrQGFgXXmDDNmuVFFksd?=
 =?us-ascii?Q?S0wcisEocGXfzRW8t45BtwvyY6nihfB0zxiXe+atTUqjDBbKSbMrTGL0pyS/?=
 =?us-ascii?Q?apgfjOhdsl3rdCTjqJ41novFpBgoyo5JY3iq2InlIWB/biP46S+0NcVnpFE1?=
 =?us-ascii?Q?90ahq0no6w9hJ3YgndgZUe/oFhxez9rxYYrkGdl2ed+jxHorMLmYYh+43qA3?=
 =?us-ascii?Q?2t09C4X778iolcmMWMlw5im8q4I0AqmZG4gJSKm5QVbvcj8ei+yAC/v44Pko?=
 =?us-ascii?Q?O+y59ThWfBK1VUuh7m5DzeWg9blxFa5WTbEsd0qI583B19bf8C/wXzOOQ2Sm?=
 =?us-ascii?Q?Bj5Hy27bP2zhBLv+h0WALq1ryRzbLT9Tpk3g54/cU1Htx0uaxtLjCKunT8jM?=
 =?us-ascii?Q?5ddatL3nUJV150Ge/taBg7zW3vlV1RaTIT3HsVMi3ODnI/kP5vatUxJBDbVP?=
 =?us-ascii?Q?DgZ29lkq7dXbv178lyuXPgnQ58mDcIJ8P3VpL8OUSj2BQCCeA9kpRsK/Nkt+?=
 =?us-ascii?Q?AkTp9UtI76pAagEwwheGdkis4MhP5dXrIdMNGJu4Jjh0x5j+72HhF23o98uJ?=
 =?us-ascii?Q?uWwOLsCtDP+rIf08sKGeupJmw9pUR7S9p/Rcz0f4j0JeiQiPll7SHrfvkEfn?=
 =?us-ascii?Q?PoQhrsDXC1bnWw6NlT20m5u1wJ4J5G0VCv/N6rqDhxrPTd7x8FLssuDLuEqj?=
 =?us-ascii?Q?SiTk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c979c4e3-97a4-41ee-2886-08d8989b9e30
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:29:01.5933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghe1oi28ZUUnzUbGr7XOgqz6dsgGDxR9IDEyEIASg999IYVsvdt083bFavWPrpWq9VNUah4r3+h84KY+A+xW5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the later
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
 arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 17 +++++
 include/uapi/linux/kvm.h                      |  8 +++
 5 files changed, 118 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 09a8f2a34e39..4c6685d0fddd 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
                 __u32 trans_len;
         };
 
+10. KVM_SEV_GET_ATTESATION_REPORT
+---------------------------------
+
+The KVM_SEV_GET_ATTESATION_REPORT command can be used by the hypervisor to query the attestation
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

