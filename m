Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027003F90B7
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbhHZW2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:07 -0400
Received: from mail-dm6nam11hn2233.outbound.protection.outlook.com ([52.100.172.233]:31201
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243782AbhHZW2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD+7uAwFjQFjhz7Ud5tXjWEarlz8Jw2nboU/oM+atEGPpku4aPYdC49QhgdLAEQSJAnMXxohgi4K4XQrTFokC9UdNsec/3VL5vnkGc500sjOMz7UK1+ywQyLlHCAmU5WWfhU8r2RmatI+EhLrTPIVz3ff6RYqiwPZspWNxTtMSaw1OvMnCwkyfUpoymei08p2AI8UyE45bLENiG6Oqrp5G92n/2UFWMVcAzX6G/7CNzhKQIfcF4mrIdIz+1vp1N5a0R0N4fvngsAxyBahGSQwl9n7PCJUc0BqvX0yadZPq6oF9fQ4j8416oadQRYfFLZTqjyzv6tD6k77NTY3EJ1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tbrnU0fAGnEbABwEPtmLIcEawn8/MPqs/GziiJfE5E=;
 b=n9stnis5MOOjvzf5uyhYSmnNxqymoKI/LMm1o/IbXXW6qJcGabdt9jRkWIef5w8d5R9gnKZa8IedwzMOgESoFmDzlaNVZZFN8ohyKLk2UAZmmivaNvqpO/MMEGy15eerGrcfW2Jnm10uiXHIT8b4Wkgstmdtqiq9WyOxUJQa1x3dBCKdvrI7Ge98V0KR+2ZmaaVkSQ3utqA4K6TlKvjTot6KZ4S9/uB79TJHalj3dIyYQyG2falBwKsITF2f44f9T7nDNJtUSTrSXeamsYVPX5Pudy3Nm4JUuw5md/3c2Xf0qXb+ukx76gUwlt5dpALqIHZ1Pq6EdGkuceOHPAcOBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tbrnU0fAGnEbABwEPtmLIcEawn8/MPqs/GziiJfE5E=;
 b=ex4qtR05xFeS2TrqU0kRqQ2MMXh81ISXFXap/g9G6k6gGO5RrE6BeK/QhYAl5aBtTGmhbzEiIxxuCyO8Y4Z0yDXdcJyFyfYG9034bNpM49ebnu/lM4ffsW6RwbAOBRcd8Suta36sEypjdtskcKfhNX7C51s3O7Qf4kdPh5kPOEM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:17 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:17 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 02/12] linux-header: add the SNP specific command
Date:   Thu, 26 Aug 2021 17:26:17 -0500
Message-Id: <20210826222627.3556-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::11) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:27:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fbecdda-2926-465b-0f20-08d968e0a99e
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39251149C0D91CD2673D94AB95C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3RfVDJlwljEM0MSDJ7UqoKt0oryLsTPnVEaAW56EYV1bapiasOvn4AHDgli7?=
 =?us-ascii?Q?3lTj/U5w1+DuBFAyJvmuW8fJoZQ93u6BogcAyBkmy0F6GVkx0wzc3ZvBXEt4?=
 =?us-ascii?Q?m/HH7DYGg7lAmVbW64KV7bxr8QMafedwj8O6m5MEW9ouJTbK1a8oIIfRf3Cx?=
 =?us-ascii?Q?wKz7aZvM66i3cQn1hbhj5f9mZed6A8yhDlaG/AZfEwIzyuzZq3Vt5RfpASHD?=
 =?us-ascii?Q?fkFa++KJ2VpeXFtulCAQ3j/cKI7Cctz7+NvsaSauygAz0EWshRU02/F5Urlz?=
 =?us-ascii?Q?fG0GdoMrMH/ATP+G+IjrYO2cppxNcSsDd9kZYQ5J9Q7eJ0e93HAWMhDUINfH?=
 =?us-ascii?Q?Oq9TjJK7RvDGTuZvQYOuk4qlrEbJqtnvV+XJB6HCAVAkezXDofY1Y3QBjEKh?=
 =?us-ascii?Q?FGcxotcGtzgUJN5HyHfCmtavfBzdkyAatlrzTvJzygx2IZwKbA/NRAaJ2Gm4?=
 =?us-ascii?Q?nxJAY44wbatTPdlQYlBwl3CKSa4cGmtZkXAmls9hrRUa+/pu289LqLjiRJzB?=
 =?us-ascii?Q?+HcV/GOZjVHCk2cnyOkcPt4XEIgUCqFgSp/N5QAr1XWc1iqubDcERhU0Q0aC?=
 =?us-ascii?Q?EABd5MyOzgVUGHAUwz5NgMHyUgguY8y9wWR9+fhcgSqZTUaWlTTrHD5tWXRu?=
 =?us-ascii?Q?RPDpzb4bjyTK8hXn7PS0ztuGZs1kxd9uz+PycJojP4NDWXwtGDadTIhPrqu4?=
 =?us-ascii?Q?0bxsaQBK5BZZW1UTgP+lYvKOC09mB/ln0ni675GyoOvF+zz9OnGU07E8AaV3?=
 =?us-ascii?Q?cezobpiibdqHYF7+tgW/Uk8KdGpBvIiWUEmRf6mPcv0NFXOD67TNe93eQ2Mc?=
 =?us-ascii?Q?NiDkRoKWV7JEGCJ5OK0FQQ2gmE44hujbHs0SIZByH47y0P5d8jQg/nzBS7IR?=
 =?us-ascii?Q?J5ILf1fwm9gcvBAFAmAGeXBR/AxFNjgdz5kuyg55yYtXIjvAs7uYto0ewTG6?=
 =?us-ascii?Q?sN5H6M7itz3wA1hxkjTrCyO08U1gl2JM2mzT1SXmSL6zZzAoVrVJSb+J5vMe?=
 =?us-ascii?Q?1MQ/KvKo7xM1+gZOOI98WvcDcyGRiwmZKMEu7dIsaIBcLr0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FCAoXrfGgSVlUlXCRtJCpSfaeOxifvIDJNJaDORtfsshP7ulT3fsa/N3Kdxw?=
 =?us-ascii?Q?tqMvA0VsYroiqVoSUuLjdwQXVFFToINCINyPl4Gbc7iSWQ2GA+UZ8ilcMjCu?=
 =?us-ascii?Q?r4/NK2vgbolUulUzh4TCzQyNc+8M3dHHXLoO3Yk4WtKCV4k+bYA/ArGUh4d5?=
 =?us-ascii?Q?tCuzp39DhYuHBp/E3q2RnEkEgIbs9DRrREZarzww0S6lc8UHb+oj41FL92lG?=
 =?us-ascii?Q?OfanzvCN3KEuGzkJ2KsxC7RUqP8bRKnR9tRrl7f2/wxftmMf8pNx9qzzzeKq?=
 =?us-ascii?Q?Rha6zOWxVAkD52BolFYr6xC9Ukk5zB81sguX8yBPUl6ja4Oul0EfG/AuMwjZ?=
 =?us-ascii?Q?JUJu+9jJAXf8YSIkosmC6pWsBmqLuOwQtE0OS5fQoI9QnzuwGslWpg90NP5z?=
 =?us-ascii?Q?i+G/xx0evpHfTl6DrLf+ENI8GHNuhminv27JJlnM9PaiZiF1vplPUieoS/rg?=
 =?us-ascii?Q?fcUfUPbhkVnAhg2/bthZkUQMW0M/r/eHx1KLG6ScRv1v+5z3BnJMB4s192ms?=
 =?us-ascii?Q?+ssJAk4d1N+U3uzML4UC1NtpG+sLFsd9kduXS5YwPjDw9KMb3t13yZ80Lz9w?=
 =?us-ascii?Q?Mfu7jhQRwLQKcQUk2DCGm+J76zFDqoLrqxQWYDgyt6thAYMVEMnHW5JEUTwe?=
 =?us-ascii?Q?K0PjCPNK+dRW7V86TFJxi4edrPYgScxxHMH2ymxhNuR4wmj16W9eU1+XVP6B?=
 =?us-ascii?Q?jO8SrR2ce7Pl9rxXo949pm2+d1GeR1f7FRlHyIHkZmlQWSsXbPsaZrtYEW22?=
 =?us-ascii?Q?kjRKHLj1R+oCLaj6dSl17Vo+Rc2tMxr7+Tfn8c1i2mqrzIame8seliJzJGgB?=
 =?us-ascii?Q?+mGYsCtqhzzgUHcyBQC+VT5lDTcta0nNNE7/7v+Us7wYXAi2VWvGWDK28A4I?=
 =?us-ascii?Q?mRTGl+rKERo3r0Eym2/7b5cOPZPux5/N+eSrxJs8JyTW+98F720ez1jOX/ry?=
 =?us-ascii?Q?EpLuZjXMX+hzyi4cVzgTJgOGF1FykraLdbTd+EabN0ryaI+HOZN5gRYOdNTR?=
 =?us-ascii?Q?7r7VRG7u0IFU8/8nQtIi8UPbNKjBYEKVObgQALwGUP+qAur1yscQqW8l3l/d?=
 =?us-ascii?Q?OqIwU43/akEsYwGVy5aXNw32XdK7acqXv+/tY2shPU2/X9guo0o8wOA4nz8i?=
 =?us-ascii?Q?qk7YTsGu47PzDIZCeMbS8OOslITrcLPG6DR1eoLSDyjuEZj1IzkdyBkVmhts?=
 =?us-ascii?Q?QSRwYHTPgH1F3uZPUn6nqXPEfZLgvkcf7g4NTwOMY0vc5NtE011BztrMAYG7?=
 =?us-ascii?Q?o08ZQCnfN5RXETGRRGkd4bF4+feCM0KfyRsBTFB2HYC/V7FBZS8muYQczgqa?=
 =?us-ascii?Q?tIXFZv7fzxbyg2BrSB4X6eIp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbecdda-2926-465b-0f20-08d968e0a99e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:17.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoShWYhdFy5uThsDsCkx6cw23xSJCHfTzFwLB2eGD0MWpCws9w1gGJ75HzTIlGuffkzMssDyngCGNMD9z+IyOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Sync the kvm.h with the kernel to include the SNP specific commands.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 linux-headers/linux/kvm.h | 50 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index bcaf66cc4d..486c12b4f7 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1712,6 +1712,12 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -1808,6 +1814,50 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_snp_init {
+	__u64 flags;
+};
+
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+	__u8 gosvw[16];
+	__u8 pad[6];
+};
+
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+        __u64 start_gfn;
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

