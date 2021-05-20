Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE586389AFB
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhETBk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 21:40:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhETBk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 21:40:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1ZAsh154701;
        Thu, 20 May 2021 01:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=sMG0Iz+/KrHas4gPDnIyWInsxe60Kluur3VniuLogy0=;
 b=DrNSN0D5cTzf5X5wvGXnQ7kFX5zLOssZR8QX3ojVP21xau+MpwK9k0TX/SNUs3N5GF+l
 gt9gbKIVWRVfaOghFoDtjCM7/8UkMXPsRqFzsF9hgCzKfsCHu/Duyc2Dy3fXiO6MfCBS
 ZImih4eU8pzRZGcy5iLW5CFWPOgutQdP3kXuMOod491/5I8T0Ec3/k1s+TCYPM41AZ3I
 wCCPu94LbqoZxTkccgDYlriulynuSxnvKtPbhYQaKtgJYZW7KEHOYkyw3F/MMsJMQH4z
 VzURlidgdOBh5pC3+He9PN9X10EUd8Y44cPbBehx2ZeTfhuktX5gTIGmII86Z98QHnCh RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38j5qrb930-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1ZNZ8034122;
        Thu, 20 May 2021 01:39:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 38n4918ajc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bp8boXGDt1vVQxi3cKlAC2f4gGGr6B+s4oT+f3/TaehLo8MhdO1viD2T6Dt4gjjtxOFCCY9N18omuUa9vtCRJ/a0a4HX7VgR6nTG3dk8TvX8ruANywUtf1O5jOAfmX8xEhE/gP8agnBAxjIdrCBO8vRAloi+OIVAp4Fvia6TmL6PT/cxolGvxIBzp9QGgrz9JZdoGvMTB/fkso8z9uML6cuHjrDTWDbuVrNfMKDGKvuRUyfc/NQ3doSxcSQM62n9qLRPUUDq1ZBgjZXvFZobFNW1k950+jvxUfq/PiIIJEz2h6myFjmoI+9S6xQ+vIBgQssz2uuMBZOf6ztjIYkF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMG0Iz+/KrHas4gPDnIyWInsxe60Kluur3VniuLogy0=;
 b=EaZ722g5tmg1Ak1riAPYNmffPLdDD+ZRujBu+u46e0o+1Djvck+WrdgKFqyo3C9mo1Y8IezB+vxWiO8fzXBS5f3zlLBGHl8u1x/7ocF6wIp+wk58Fh/Lecpn6Mz0Rzo67yXNCRffAH+QQpYaDwPDC/8Qi90S6rIJWPboJjuqIw3dkra8mYMlsLzTWbsqkhql2HXE2nFiT2T2NctW9z4E/wQIc3KqwB4gRJzfa+OD6AX6Jewqik/J644uM/BP0Aoik5XVjl08+r3YmrlsINd2UqRrmN8KF+H2i0J59q5jtC7NLvMKLgiufswhVUn8LyuxtaNBvyqqSIQSvN+63zMVfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMG0Iz+/KrHas4gPDnIyWInsxe60Kluur3VniuLogy0=;
 b=N/LLT0z9l7Gi9TKgERrtim6m8lf6vwxu28Jfxq3NLiXk87D32kvmzKXAmVwMQBzikNeqTud8d2qDFzTbKofS0A2fjmlqR1l3TCy3QCDmINbi/0I0KgoX1K8NSQcWJBFAmFauTDGUS5ZTHEVMMlYnp6il9qKOpBx56y+sCqxFJBY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 01:39:30 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 01:39:30 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/4 v2] KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM
Date:   Wed, 19 May 2021 20:50:12 -0400
Message-Id: <20210520005012.68377-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:806:a7::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR10CA0003.namprd10.prod.outlook.com (2603:10b6:806:a7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 01:39:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8adcff9f-610f-4196-7d2c-08d91b301cd9
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308837D53C20787981E71277812A9@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IPWZowKqPOaaU8E8thL+6QcVCu1Jnlkjhddn5gfX8K8nXC5ToXExb48fOUcKL3L2fXFTLUup0+u0l+ZQeN0T4NBx3qDs8NuQkHOSgc7c+G2pBNBa0Ma3bpIwEs5TO722CRyR/tha1veKi5T1CZ3RT0fXkJKr5awpEfA8HSg5guND0W8pVeUbMR4r0rHp43NEYaDXq8ut4DSkFutoC8QUkPGRGIsxVrpuZTTw5GhNXqumUid8SbjRNYHG46Zai3hXXUpxg1Rmxunhmajli7505nZ5Xtl0qemfjtoAIFe/SsS6eNz16MvqDSb3x0E6gPisDJyX5UQ0UHGnsgSOiFZWv3bXNy2tJowlsaAp1ViiQGA6Xb57iydypX9HIszXKMMABVOSrc/s3KRu5l3lailUOaycFBssstO4Jfc4HdOte0VKUvj/B0h6bGwCuCaNqqmKVx/rg4epjpXl7sqbUfgxo1lUmg5zZBvunXKQ/XFv4ONykIknO58seki0SpimpRzo/wsyRGAOR6BjDMPP//SCvkZo9dtNd20Q6j3scDGLW+t1whQ6UzszG5/LU2qOzrj8fvxLcIlD9z/4kvsCKPC63ZXqsaPMIuYoQ7GAkP132zrFGUNAwu+8HlrA8H8MmPp9Q1P10v69C+NLb7kTyAnQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(83380400001)(44832011)(2906002)(316002)(66556008)(8936002)(66476007)(66946007)(4326008)(5660300002)(6486002)(36756003)(86362001)(6666004)(7696005)(1076003)(26005)(38350700002)(478600001)(16526019)(38100700002)(186003)(2616005)(6916009)(956004)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OZOrvSLB89qMuew0JUTF525f1LIHURDFI1EzwOz/torr9WRl8iplQobB//FS?=
 =?us-ascii?Q?6R7Xzj8TjQJdeAkbQ2odM+4ro7vUmv/Uju1E+XhWPVrobpHSqLPr1e3MlpjU?=
 =?us-ascii?Q?Qr68dkw38Oh0g1i72nMt8pNj1VXkbW8sWwvHiFzdwVl7uW98CVcX28fF0NOV?=
 =?us-ascii?Q?p3OweBKeHAcOrBwDyyWsttlzixKApO99Za6i7uGu6Le+jC/mxy7rW3Li1EiH?=
 =?us-ascii?Q?nciZvAfOgdXC449VF2DbdwdOQGQqzPMX5ZWE3yKW21fJqBZsSvJ6KK74H3rv?=
 =?us-ascii?Q?R+7Pu31B/CKlznUXWAQb7TPn7LPL7Pkf3sPOITLH1xq/jsdPTp96lYMETAY+?=
 =?us-ascii?Q?rc+5SVnalabqzeCfK8X1p0nuG0dAMaNJZ2moLl1ZxcJUuPgBwHT35uAZBoTs?=
 =?us-ascii?Q?aEPiRN5PVD5VDwKhTre7hBy3Q5zvwlTbJ+7PhVIEk8AEUKtnPfARqrFyi1t3?=
 =?us-ascii?Q?nsPU8s/O4ySgPJnLGBAA/8jTDeylgR/u3EFXC45PAzRhp1bkGjvM8r4GEc7y?=
 =?us-ascii?Q?G5HwFFoonTr8cq39REpyHQXkDMqWpIhMXjGH30MnbxhuP5YqkN2fSnUitS0N?=
 =?us-ascii?Q?7D3Ut8Ue0BI4mWPzPtur1tpdRtUOYaqj56fqaiMu7q++c2h/Y+5nGe2MNQkg?=
 =?us-ascii?Q?r3uADwipygFNYY0mYVgkMw4Ysgbz7XAVB/+efR8WuXufcKOTt+tHEyXkz6mb?=
 =?us-ascii?Q?hHb/fxPO8NiGaubQspLWf04uY1etmINcWUbC1hXzB/aZKLHfhKlAn3DLpllh?=
 =?us-ascii?Q?BnowlX8F47r780iNMLtgsxjFYfTlA6+niw9NYqlx0YQW5VxKF1e47XRcPnDp?=
 =?us-ascii?Q?LfaDPaRpQ/nagyq+HElRgk2wwwA5RHWBulRUj3dgRSKjMIOcaHWU4bxyMpp3?=
 =?us-ascii?Q?xENHe3Yy8iXXXgE354XCNQSju91pSdNh5KtP17pMWfTGvwapjTonkffef+uU?=
 =?us-ascii?Q?QgjxpIIiouv/zOWFAO6HN2ydXBJjAgCqfTko36x+dlPZ8XJmw6VYfDNW2QHI?=
 =?us-ascii?Q?HFytRebOw64duPdK99ecwC8asjRDpMZHaRe4DO2kiGyQWP7JMJSZKP1UcYjM?=
 =?us-ascii?Q?Z3+gjQz72Ci2dZkOoGeHhQrv2pIj60MfAhAu7ao99OWD13lzjsMRRiUpUhDZ?=
 =?us-ascii?Q?t8S5W5/DsKo2jtGyn5Qo+gB5LxBoDrkvFrWGXVNDsSRkrSgefr1eU6t/0QDk?=
 =?us-ascii?Q?PMFpXYKC1twt5Rc0tX/3qzkzq5rbjh9gP7sk9ETEgSMWL2tXoECSqSKEPls2?=
 =?us-ascii?Q?Iog2DeDI/nT6t1ikycsTAPCT+wokP0+4R7Y9hKnM2HJIeM7Z8SKJZT+19/LY?=
 =?us-ascii?Q?kwzmBDbY2gKuaCgW03+IEgTs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adcff9f-610f-4196-7d2c-08d91b301cd9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 01:39:30.7870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBJt3Sop59Cu+cBoW4UYt1AM/an06sJWXvPIXbNq753ef/OcH9+kSZZau8OzVVePIz4wObhdlwEXo1YaHT8U1FJciUFN18i8mAA72dFRfQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
X-Proofpoint-GUID: 2QjDaFEBh1dyaTIqgbbnQhPNVC053EOo
X-Proofpoint-ORIG-GUID: 2QjDaFEBh1dyaTIqgbbnQhPNVC053EOo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm' already has a member for counting the number of VCPUs created
for a given VM. Add this as a new VM statistic to KVM debugfs.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 3 +--
 arch/x86/kvm/x86.c              | 1 +
 virt/kvm/kvm_main.c             | 2 ++
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a19fe2cfaa93..69ca1d6f6557 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1139,6 +1139,7 @@ struct kvm_vm_stat {
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
 	ulong vcpus_ran_nested;
+	u64 created_vcpus;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1871c51411f..fef0baba043b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3875,8 +3875,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
-		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
-		    svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
+		    svm->vmcb->control.exit_code != SVM_EXIT_ERR) {
 			if (!vcpu->stat.nested_runs)
 				++vcpu->kvm->stat.vcpus_ran_nested;
                         ++vcpu->stat.nested_runs;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cbca3609a152..a9d27ce4cc93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
 	VM_STAT("vcpus_ran_nested", vcpus_ran_nested),
+	VM_STAT("created_vcpus", created_vcpus),
 	{ NULL }
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..ac8f02d8a051 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+	kvm->stat.created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
@@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
+	kvm->stat.created_vcpus--;
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
2.27.0

