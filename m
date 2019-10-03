Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D46CB0EF
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbfJCVRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:17:55 -0400
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:24420
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732620AbfJCVRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0y9zX/SOp9u3sMNaNjLckGMKX84NTIwif9lM4363O1VcCdCsogKn0o+gk53Up/Qit436nOIk73f2tlxl56qJA9Bn2/X/E9OidT4pgE2kG1sCH+FbBRntQNIELw2NpwfOK1QHdrzhx0GQz5hIq5I++LT/PUTxNBduIfY7LGaC6I4Wjk+ahQ3CeuyvQQAsYXyc6oW+RK6zDm2RvmL0GZ1AxTOxM310ZKJ3/qqzJRTWhgIG25QsVMcKn7oIbV1izq7FQ3pa3X9Lm17+9h192pkeyhWRg+TYHYHG5JQNKT6wxeafe1TzDKsIxXuOWRwZo2EX/CuntbtBUcVLPsq9rVEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyJf1KdBbSUvblEvwfPl2U5j2HmwLT+6k3b4MTCywu4=;
 b=kDdO6w1yWMEhA58cxrcOWF71XNFe7RqjfpbfU2HvwryrmPvJgFBc6Wy6tG7dHLyQlhdezuJy9d9rQItg44GDb/FwExSsHm01V0AtOddXJs/GkI4Jz/RE13Iiaf/c0cQXlUwfiNU245VDcRm+nHlDveL/mBvJhR5RrE6iTdOWOjsygpPPJ7mSXyQpbohWu1jJ6LoNcRdn8aKFOZHq0D89wvSuD5KSYHPYmutJvXc41LFPeukOJN4w19bJrS9VOkhftZvmRxSOOCGcCH6VY9zq9Ovlu+WtkuohbrlixIqLp2t3xfw/qqJUnwy45w63PnqXUuS7eNvuN9M2mC16G2wD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyJf1KdBbSUvblEvwfPl2U5j2HmwLT+6k3b4MTCywu4=;
 b=yic4M2zD6uG2ApJl/fvnyWwEhy0D1cR/g6OHIMBR/zzjydd8f4JQHSV5WRQbxA2Cxbc4TQQyXQ3hGtO+zMrZMmVlF11bAgNndLbQzyDVp+rMSsvSZ5ZeBZBT9kopLfoFAoJ/4hmt/5wMWTlOiuZiyO95Qs1CTAUQcb2vKvz5uAU=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3115.namprd12.prod.outlook.com (20.178.31.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 21:17:48 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::85b7:7456:1a67:78aa%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 21:17:48 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 5/5] KVM: SVM: Reduce WBINVD/DF_FLUSH invocations
Thread-Topic: [PATCH 5/5] KVM: SVM: Reduce WBINVD/DF_FLUSH invocations
Thread-Index: AQHVejABu7TxOkHqz06XkkvnstPrcA==
Date:   Thu, 3 Oct 2019 21:17:48 +0000
Message-ID: <cbdecb2f953c78f69ac5dc37c6f1cb0d42ddd5e9.1570137447.git.thomas.lendacky@amd.com>
References: <cover.1570137447.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1570137447.git.thomas.lendacky@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b2a0915-4fd7-4550-da49-08d748472434
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3115C16D22975D00BF23C9AAEC9F0@DM6PR12MB3115.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(26005)(256004)(14444005)(186003)(2906002)(102836004)(6512007)(99286004)(66946007)(476003)(14454004)(6436002)(446003)(8676002)(81166006)(8936002)(81156014)(478600001)(2501003)(11346002)(50226002)(71190400001)(71200400001)(36756003)(6116002)(76176011)(52116002)(86362001)(3846002)(486006)(386003)(6506007)(7736002)(316002)(25786009)(305945005)(5660300002)(7416002)(118296001)(66556008)(66446008)(64756008)(66476007)(4326008)(54906003)(110136005)(6486002)(66066001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3115;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OK92kZRlcHU66/9lNjgjWImWdKmoEMAtl6ouSCY3uYq7n6/IrfPeZHSQP3fUBfVo4K6GfbyLs7rjQYikvaWaJryWZTLlXuX0cBIfthhgu4Sdv0IZzfOT/rdGRZ3yyv8t8ym6X4ESK/o1DCi7TVN9n1a8Iw6GHnhhO74nEARsZ+hC1Ifh+jqb5kvZtVnQ0mX+edjTDgL+l2x/m38HZ2QX+Fp53PF47hxJTgN2i2qJWEUbPtf1PXYqW7JdQA1nEI3Gi6Tj0ycTYv/bWaZdfz1OpTNATEcvYseVLeXPuVTezI8YXIsRZcORPPN5jExzkdklHBPgT9Gr0rFyE0CjnEC9LW4f8AaNwX3GeH9KRkxlqPhVHgEbQx2br0XsmZKCMWttD5Fx6ESrltWDr88EmxJQzKY5MdwqWl5PCsrNeGKIdZU=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <6C26C122CD6AD64789333264AD925D58@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2a0915-4fd7-4550-da49-08d748472434
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 21:17:48.6534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UMO2j0imvZbtXouuX9nB7wVpbkui/y1ddajT6Xh7KIc7JdLCEmbicySaVwd6gOmWjQaDpccdZTb2YkG6sjRrUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Performing a WBINVD and DF_FLUSH are expensive operations. Currently, a
WBINVD/DF_FLUSH is performed every time an SEV guest terminates. However,
the WBINVD/DF_FLUSH is only required when an ASID is being re-allocated
to a new SEV guest. Also, a single WBINVD/DF_FLUSH can enable all ASIDs
that have been disassociated from guests through DEACTIVATE.

To reduce the number of WBINVD/DF_FLUSH invocations, introduce a new ASID
bitmap to track ASIDs that need to be reclaimed. When an SEV guest is
terminated, add its ASID to the reclaim bitmap instead of clearing the
bitmap in the existing SEV ASID bitmap. This delays the need to perform a
WBINVD/DF_FLUSH invocation when an SEV guest terminates until all of the
available SEV ASIDs have been used. At that point, the WBINVD/DF_FLUSH
invocation can be performed and all ASIDs in the reclaim bitmap moved to
the available ASIDs bitmap.

The semaphore around DEACTIVATE can be changed to a read semaphore with
the semaphore taken in write mode before performing the WBINVD/DF_FLUSH.

Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm.c | 78 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b995d7ac1516..62b0938b62ef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -419,11 +419,13 @@ enum {
=20
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
=20
+static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 static unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
+static unsigned long *sev_reclaim_asid_bitmap;
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
=20
 struct enc_region {
@@ -1232,11 +1234,15 @@ static __init int sev_hardware_setup(void)
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid =3D cpuid_edx(0x8000001F);
=20
-	/* Initialize SEV ASID bitmap */
+	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap =3D bitmap_zalloc(max_sev_asid, GFP_KERNEL);
 	if (!sev_asid_bitmap)
 		return 1;
=20
+	sev_reclaim_asid_bitmap =3D bitmap_zalloc(max_sev_asid, GFP_KERNEL);
+	if (!sev_reclaim_asid_bitmap)
+		return 1;
+
 	status =3D kmalloc(sizeof(*status), GFP_KERNEL);
 	if (!status)
 		return 1;
@@ -1415,8 +1421,12 @@ static __exit void svm_hardware_unsetup(void)
 {
 	int cpu;
=20
-	if (svm_sev_enabled())
+	if (svm_sev_enabled()) {
 		bitmap_free(sev_asid_bitmap);
+		bitmap_free(sev_reclaim_asid_bitmap);
+
+		sev_flush_asids();
+	}
=20
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
@@ -1734,7 +1744,7 @@ static void sev_asid_free(int asid)
 	mutex_lock(&sev_bitmap_lock);
=20
 	pos =3D asid - 1;
-	__clear_bit(pos, sev_asid_bitmap);
+	__set_bit(pos, sev_reclaim_asid_bitmap);
=20
 	for_each_possible_cpu(cpu) {
 		sd =3D per_cpu(svm_data, cpu);
@@ -1759,18 +1769,10 @@ static void sev_unbind_asid(struct kvm *kvm, unsign=
ed int handle)
 	/* deactivate handle */
 	data->handle =3D handle;
=20
-	/*
-	 * Guard against a parallel DEACTIVATE command before the DF_FLUSH
-	 * command has completed.
-	 */
-	down_write(&sev_deactivate_lock);
-
+	/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
+	down_read(&sev_deactivate_lock);
 	sev_guest_deactivate(data, NULL);
-
-	wbinvd_on_all_cpus();
-	sev_guest_df_flush(NULL);
-
-	up_write(&sev_deactivate_lock);
+	up_read(&sev_deactivate_lock);
=20
 	kfree(data);
=20
@@ -6274,8 +6276,51 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+static int sev_flush_asids(void)
+{
+	int ret, error;
+
+	/*
+	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
+	 * so it must be guarded.
+	 */
+	down_write(&sev_deactivate_lock);
+
+	wbinvd_on_all_cpus();
+	ret =3D sev_guest_df_flush(&error);
+
+	up_write(&sev_deactivate_lock);
+
+	if (ret)
+		pr_err("SEV: DF_FLUSH failed, ret=3D%d, error=3D%#x\n", ret, error);
+
+	return ret;
+}
+
+/* Must be called with the sev_bitmap_lock held */
+static bool __sev_recycle_asids(void)
+{
+	int pos;
+
+	/* Check if there are any ASIDs to reclaim before performing a flush */
+	pos =3D find_next_bit(sev_reclaim_asid_bitmap,
+			    max_sev_asid, min_sev_asid - 1);
+	if (pos >=3D max_sev_asid)
+		return false;
+
+	if (sev_flush_asids())
+		return false;
+
+	bitmap_xor(sev_asid_bitmap, sev_asid_bitmap, sev_reclaim_asid_bitmap,
+		   max_sev_asid);
+	bitmap_zero(sev_reclaim_asid_bitmap, max_sev_asid);
+
+	return true;
+}
+
 static int sev_asid_new(void)
 {
+	bool retry =3D true;
 	int pos;
=20
 	mutex_lock(&sev_bitmap_lock);
@@ -6283,8 +6328,13 @@ static int sev_asid_new(void)
 	/*
 	 * SEV-enabled guest must use asid from min_sev_asid to max_sev_asid.
 	 */
+again:
 	pos =3D find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_sev_asid - =
1);
 	if (pos >=3D max_sev_asid) {
+		if (retry && __sev_recycle_asids()) {
+			retry =3D false;
+			goto again;
+		}
 		mutex_unlock(&sev_bitmap_lock);
 		return -EBUSY;
 	}
--=20
2.17.1

