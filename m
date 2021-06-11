Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150EA3A49A4
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 21:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFKTyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 15:54:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhFKTyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 15:54:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJiLmM041271;
        Fri, 11 Jun 2021 19:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=MKZPpP2FPacwmIkZSwdfXIkRf55NoiMp8nThR3gbOfE=;
 b=CXC2WH2PvRwtOKx2skxsUlkjF2Ef337C2Uk6fkYXWCR1iwbCis88bBPf3VJmlUtvuzpO
 3HGoJHImaTvUV+vphK8KI5aUna5LBLvlxfPuSDZLVQ9MozwOAC0X65/4RJ+uijv1iCVG
 9GdeVvz7FDzLrSBKHojgWrLcexzxzH3ijpIGxwLdI783y5DzAStapU5970EAzSXTvjIe
 HDr6N+t2DpjjdfZmhqintdnHft3RmBPqHMrjC/0Z5eCj+9p6+u/k1S6Fza1R2+VaTWMV
 dyTLe39uprFRnShXfiyNvC6YnUBMbV70EANtxQgYI0eE55GX/BuN5hppxKmnDIy5FsTy fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qux3nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJpDIV112705;
        Fri, 11 Jun 2021 19:51:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3020.oracle.com with ESMTP id 390k1u6wmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvCZyg1mG2UGBuyFp2km8bBRsbJINDK/uiGEOGiHsrWbCt9tY1UNhK2o/I+bDorrDkGc+iOK0Zdc5XmYyRUtAQ6ILcoX/tH3DGvnnN0wOPDNZsKrqjYRby5V2up/Iq6w/wVlOsFJWb6P+n3K0Dp50zZ9tllAT422bK4nm/huDTGI4lsDtLJYj+sGYSrZyM5VqZd9gMl9XnRJbEYRNbmskJembRf/r0jQsw+yV2VU8bybrYGCHG8Mvfy6d4IsTII+tsLRMdesRfWBhxJ2fH5omcAjlhl5Hea5JcaRmfLKepTNRitvJs7IWsUuvI5v5pl0GeOpcUHVQ4AW+1favU70dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKZPpP2FPacwmIkZSwdfXIkRf55NoiMp8nThR3gbOfE=;
 b=FfPEtz7nTa3ei/KCOslR35QQK1w0kbvyc2Isq8NVyELJ+I+k+a13jPZtwH7S56maw4aWpOSg8kM/9gpKMJW2c0UCScDONiEW/OVddqHqN3QU1NBZggg5T/ymfmTORamvgfoQl5tO+YE/DHw5WBvsIsZ4lawkqo/VGWO+RX1pmkam9u15wrneUXjcULnmCmdUEmMGaICSxynJeQVOD1Wjyy+ipHcIF6DEq5SWJxmmAK5f/UYqnbW84dsEhaBw+/+x1+LkD6qro8ZNTgobN7YI8Hx5F+3bmLTJk44ZrVlK6mlluWzIumRNBDzqP9dj/8juAHvFBXSTE/MqZGcwsh+7Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKZPpP2FPacwmIkZSwdfXIkRf55NoiMp8nThR3gbOfE=;
 b=GFLEO3RZQWpdXpEIxN2rH/7cCI7mrKxjozyQybKycSKhLFkMKwY81vRkobQKwS1QczlY2K/jeraKNZFUuGS7EAb1ni2U+vW/xsTaE4F5+PaLfcz7gzQ3X8fdHntTeEDalky0WspvWU5zQuz1JohaQJbn7QGM8t3HA+SSmLiRuOw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Fri, 11 Jun
 2021 19:51:21 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 19:51:21 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 3/3 v5] KVM: Add a new VM statistic to show number of VCPUs created in a given VM
Date:   Fri, 11 Jun 2021 15:01:49 -0400
Message-Id: <20210611190149.107601-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
References: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 19:51:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a282c475-9623-4d88-3be7-08d92d124940
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-Microsoft-Antispam-PRVS: <SN6PR10MB29446DCEC5C2B2902F679F5981349@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EF0L7MK8cZY/H5GL+iFgfLhzt8OsfEvFypz1VaVeUxhLjcpxrhocAY8FzGxJMSOQw4+UPtwfSuknR56TDcDabYMsva6O5LLIWIerpbt5CoVio5KOi3Hzr/B8gHApV+fPGCDwKSqpPfcf94FnML90R6xTE46nL252vK+my6KH99HGiav5XId94GZ4vZnPk56yT6Qa1/UF7CSOUjOzfEQGm4IU0Akij/3mvFEH4fYIzs7USAn2cd3Ayw2H57IE1xWH5FFGvHCTVGcruicaafwQP4rn9+4gJL3WD1+P3TLVWKklYaNkBKRYOYmGr2TUZim9f0v282fyw08R0FwDyQZ/T+OLXKdR/1VP48Cs+stRjiDTiGIUl5+WZgA+cED/tbhkhpCiSGjPGrGR2wm861R2XvgPQPXBgO6ouIImav3FB3SysAHDJiMZ5F3tKjdhBtQ9LSWV7GArYpMoZSlzyeevpoC2sRBPUNnMKT5oUg5X24sCfcJlYdyT0nY41SXRs/iF+0tfJ8Jtx+SFyU9HXlj3ZudKCGhN3v+8oi4h7icBuWG/pm2koe+UO696x4uas+mvk48yz1yGqtiHxzmLPiweA1ERkYcHKdgiel+5ZlVW+upXaX0re+3M+DDaeMrlJn2wMlp3X9QxdqmMoYuIVUtylA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(316002)(2616005)(956004)(44832011)(66946007)(66476007)(478600001)(66556008)(86362001)(26005)(5660300002)(4326008)(186003)(38350700002)(38100700002)(16526019)(1076003)(6666004)(52116002)(36756003)(8936002)(7696005)(6486002)(8676002)(83380400001)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BwrEuB7pkC6vVxi4MnQat00fqveb3dj3RcSQrTvwPBunyms2GbiPbjvPXLS7?=
 =?us-ascii?Q?SJIX0ajgomBgoz866BNYQggI+meYM/47/fWO27dV6MWIhQWVr/hTd9tMRlsL?=
 =?us-ascii?Q?Z8+Sypg5zK/J9NEBG5Aji9UMjUbKS1kOTejPmldtByVSVAfvfH18oQGhRNvv?=
 =?us-ascii?Q?sC4rD4l79Hvq2ax/tQ+7fhvjjeGKhb6NFWhFNyf4sDBa1ATvj/5kmChqK4WM?=
 =?us-ascii?Q?xXuyMqov4h9xPMKrfUHv2AVX8n9l3/RziIUafZ7H+cs5HJCrCVTZll/o3vD6?=
 =?us-ascii?Q?ZOfBzOwMRUhuT311pyuhYkrFQVPFeCfIs8n+gxa2xwtKs+Y1qxQvl1+NU1oh?=
 =?us-ascii?Q?oHUtCvxFS0/q0ETgDbkdgtlI5He98Z4oPIbmK/ooV5mNRCiMkMj0MP6CSAmP?=
 =?us-ascii?Q?zvQbXfLCLdkYJKCpe0EMro6UHI6KC09n8PuHpQGm06tGyrYcliLDk4mGvNsa?=
 =?us-ascii?Q?QCtBqVFCS6t7sCqFLSJ5wF6mbnMkeA/yMina9EGipRMWrRDrEdOtb2tqNGcc?=
 =?us-ascii?Q?XV3nirzIcrOY4VRJu++of5zUUbSgrv3qkzR+jvcMDprVs504sfM5T33DVsKc?=
 =?us-ascii?Q?PIpibRy8b76/HLxogYrDwvWuESafBKoV1IDeszZWMdz4e0cTonuZFdxWe+tu?=
 =?us-ascii?Q?kYY/ty9lWCAFsrjT4qCQYisM3ZQub6rsogiXJ7sVyPfkfsHZzTTI++CHWQ5e?=
 =?us-ascii?Q?LqGu6Va2SX07byPzyJWhXFmv2a6ybsqGKs3cCYTL5EMQJQePrUgmQoGhbhN+?=
 =?us-ascii?Q?+jVioOMQLCRPxHeUbfrbgzvkAINS1aq8TRCOhyAc0xHPic00b6mSwPCjQJXE?=
 =?us-ascii?Q?JFqlDCdq6bePY06E+81AgYUYAjtgLvmMDmdGriW0poceNMpAJoWRRQJJC4Zd?=
 =?us-ascii?Q?MJPFKHhh3hXAst5//K6jKVWEPrBDh7dk+4ggPqKPVDxl8Vn6iypUJJKK0wxK?=
 =?us-ascii?Q?4IlU2eszWkRVyIXo/Tu3MgZiKCaUzoLu+aJUpDr4EAM5Rx0UPYXYlojg4hm2?=
 =?us-ascii?Q?1g0ArkqTpi/zUhUOz9qIXG1/YtHrKjYIPhMMNg6cu90JUs8/mCm37mrjkR3D?=
 =?us-ascii?Q?zO6LFuYc7HnSzxe2TkmC8gV871FTW2LYcx1xZMvstQKb6F9G93Y2cI8gQjP9?=
 =?us-ascii?Q?5sjYy2yvzwh0UIxYV1esBVBDAZev58LPebCYCd4qsjQ1JFmGlZ/ZoYTENeso?=
 =?us-ascii?Q?3SbQU2eo8N6U3U1lFmtUh5LKYoy2VcDSLmlsir9njQLf4Yr5BcAGyrbij4WZ?=
 =?us-ascii?Q?enpB5UmaLJqSCCyCVcPTdLaIM7xS/5X1iHgRDKSWOWAFzk6te3RCTUoBoh4f?=
 =?us-ascii?Q?QvAN0CfsTMxl1nfpXAIMzwmd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a282c475-9623-4d88-3be7-08d92d124940
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 19:51:21.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVKrbAtp90uboP2sa2Umk1lhp2a5RiOAh5XgdJrYK48SEzxxXXngmh0snAopP4E43RYmydrw0O/EPWh5N2J1ZLe6LQwG4kMZMoPI4+nCukY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110126
X-Proofpoint-ORIG-GUID: _NVpPfTT_3tJQps75drvMpyO08U2nxtu
X-Proofpoint-GUID: _NVpPfTT_3tJQps75drvMpyO08U2nxtu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm' already has a member for tracking the number of VCPUs created
in a given VM. Add this as a new VM statistic to KVM debugfs. This statistic
can be a useful metric to track the usage of VCPUs on a host running
customer VMs.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/arm64/include/asm/kvm_host.h   | 1 +
 arch/arm64/kvm/guest.c              | 1 +
 arch/mips/include/asm/kvm_host.h    | 1 +
 arch/mips/kvm/mips.c                | 1 +
 arch/powerpc/include/asm/kvm_host.h | 1 +
 arch/powerpc/kvm/book3s.c           | 1 +
 arch/s390/include/asm/kvm_host.h    | 1 +
 arch/s390/kvm/kvm-s390.c            | 1 +
 arch/x86/include/asm/kvm_host.h     | 1 +
 arch/x86/kvm/x86.c                  | 1 +
 virt/kvm/kvm_main.c                 | 2 ++
 11 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..e302dc2f0c28 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -557,6 +557,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
+	ulong vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5cb4a1cd5603..8b1150fdb2dc 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -41,6 +41,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VM_STAT("vcpus", vcpus),
 	{ NULL }
 };
 
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index fca4547d580f..8be58e67cf1d 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -110,6 +110,7 @@ static inline bool kvm_is_error_hva(unsigned long addr)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
+	ulong vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 4d4af97dcc88..6288f88ae8b6 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -74,6 +74,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("halt_wakeup", halt_wakeup),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VM_STAT("vcpus", vcpus),
 	{NULL}
 };
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1e83359f286b..ab0fb7fd96ab 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -83,6 +83,7 @@ struct kvm_vm_stat {
 	ulong remote_tlb_flush;
 	ulong num_2M_pages;
 	ulong num_1G_pages;
+	ulong vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 2b691f4d1f26..479f86a40822 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -68,6 +68,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("pthru_bad_aff", pthru_bad_aff),
 	VM_STAT("largepages_2M", num_2M_pages, .mode = 0444),
 	VM_STAT("largepages_1G", num_1G_pages, .mode = 0444),
+	VM_STAT("vcpus", vcpus),
 	{ NULL }
 };
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8925f3969478..868bbb6e881e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -761,6 +761,7 @@ struct kvm_vm_stat {
 	u64 inject_service_signal;
 	u64 inject_virtio;
 	u64 remote_tlb_flush;
+	ulong vcpus;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1296fc10f80c..06ec2af19c76 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -163,6 +163,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("instruction_diag_308", diagnose_308),
 	VCPU_STAT("instruction_diag_500", diagnose_500),
 	VCPU_STAT("instruction_diag_other", diagnose_other),
+	VM_STAT("vcpus", vcpus),
 	{ NULL }
 };
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f6d5387bb88f..8f61a3fc3d39 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
 	ulong lpages;
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
+	ulong vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index baa953757911..7a1ff3052488 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("largepages", lpages, .mode = 0444),
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
+	VM_STAT("vcpus", vcpus),
 	{ NULL }
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..d910e4020a43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+	kvm->stat.vcpus++;
 	mutex_unlock(&kvm->lock);
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
@@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
+	kvm->stat.vcpus--;
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
2.27.0

