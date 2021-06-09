Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187063A1D3C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhFIS4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:56:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46344 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFIS4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:56:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159InYHQ195200;
        Wed, 9 Jun 2021 18:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=lVmyFU6lZXsatD8QaYMwKr26GCjoFkHIlKoCRsMQc0k=;
 b=Iw/2Moz4jF4EGCxIFxxCB74HWJkHMDH3kFRPXPNbYAgb95BriZWjFsAgLtbbc6mv1Ecf
 t+EwjB8Dz7M5F9bxVcIgMxFZiIm6ysaRABqTMmwKHAySp1N8dCP4S5NGF246jkXYgfMN
 tBxJXdHm4VhejsHHXeYAAY06qq37JjXynW1wHqp1tY9a1UdkPuBsQ/8EdPoemWB06g0V
 j8yjYy24Hgy8+Gn5NxkkGQMOq1yv8LC1Smi3RXDzp402XXcGifsPdxYQuoDgqbIijAvh
 a+XzFoX143BBO0u/4QXIc/o2BuMoEsAEowyNngUmZDD5rt13KjkjkhuEWI6rp4+7XmXo RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38yxscj2r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159IoRVr175377;
        Wed, 9 Jun 2021 18:53:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 38yxcvwkpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8VgUAtQ21iko07/js1/DjUk9oa1vfTGTKku3TfEZMJ84Xhqq+J0/tgCgy1hJurLEbAla+CK+yatpLiwelrzRkfBwCCyooWN0VbK6HwjYIKExt0fqD4lWjlIqhPSXct78mOj8z1Sxvsq5EXtCf/0juh4NvBwOl2QrxMisXini5FO2N6DPULBK/Pah/4vt/LQiEjEM3UfOEY+4UXpJEnffctconOcsKjRrm0KkZXpK9ptxcp66YL4yyixKn6/TqAz9cxoS++TZ485bgRP0J2b4xOK9zf8ebzjOHdlsMzcgEC1Hl/L7ckQ4jqXHfcJkaA6x33EutgngRryM1ntcnLz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVmyFU6lZXsatD8QaYMwKr26GCjoFkHIlKoCRsMQc0k=;
 b=ISbWu8knCiat87aH1Awg92zzOyeucsIhxba9HYlQHsW8wX6Mds0YbDHNxfkh4XJTkeHLdTsyxn+uJpojkWTteelNiLIBOxBfblmwGFUgbyGVXnAtyqtjfTN2yoOpeiTq3+geQYn3JKKyen/zPrs1GtQCEwFrQ7GM9YoR/jKnuImZYUKWiqZ5LnR9WmARGgf1ra5CYHn5GS7afL7BB9AjbYQ1V4uK6NAXezY1a8GxCCP8l5x3FBs4SOReHhmo5d0o3nAmyjHDD8vQcPPhXLfqrtc7zB7jKMFAorrvW1i3jWJJqddBaE4TBq5qaHOItlVA65mcjZ9SbfLl4u6kg8kt6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVmyFU6lZXsatD8QaYMwKr26GCjoFkHIlKoCRsMQc0k=;
 b=lrow3MS6wgiCG5vq7n55fXojfqcZPCLUr3GHZo93hxwm3IMU0kdV11iXMLQHSTvZS2WChSJkYIdxtbNiLN27nYqtt/omArCpoXpVEyv03QWipGMbZrL9miG094Q8ZAnqHoAqdk4kA89w+NJNQvKnWz8fAg8tY7U4sDVfqE5wh+0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:53:14 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:53:14 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 3/3 v4] KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM
Date:   Wed,  9 Jun 2021 14:03:40 -0400
Message-Id: <20210609180340.104248-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
References: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:a03:117::32) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR08CA0055.namprd08.prod.outlook.com (2603:10b6:a03:117::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 18:53:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1adfc4-aeef-4605-1d1a-08d92b77d5f2
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25106CC224291D280D628E9781369@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkvBNQxCEWQJe/ZRGeokrifwF3A4OF6CUvvZVf1DkHvKVXfNd8ZLgJrMt+BpNIG1BaV4po0nBUv+pfyFjoc6ZrTLnbrD5lt8MDCUXjivMttxjgCLamj4VERdbariZF85ivZiF8/51J4y+NNQlIevO4qgWWJzmbYol1dmF5Tdx/nhc7zVKXMgyR88kCC9LT7s2NEYsiQDMFgq791yDG80cbTLmw605r++miDxgGCjQD5K8GKiTEmV+FhBL+W2pIRQ2sFtu00M6FxpCBkPtXCNmQKStHN7UEE85et2HGHE8j/GtVOieI/yOeUlOm7JJgtUaepAMgmxmpP4wxJ1tyOLPVYaM2oorCKnreU+IqARbRNUgXaTMCVlr8pFM9zq2ss3bW7oofemt9T1X4ANBy//vtbOrNkiWWdWNxVHhoH2FGUoKJHOBnwfruwrPYUPo3PHKgi9VfLhyz10A127iv7ooFMbX/iMpVSttQZtcBu6fdY7xcj5QtmWawnkHSELRVyOMJ5ndt2JmBXSrNdObKPJp2FcVS9Mz0Y4sIHNPwP+0HkongmdzMvN+XtdlpbgIUaHITTnrEroe6/1irtbiyBO084qHLf8aWcdjPX+CSgRhalKOFA+7IWo4e3Nb+rpBnvQNDr1v+onSsZX6kuACEFaMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(52116002)(2906002)(6486002)(8936002)(36756003)(7696005)(38100700002)(38350700002)(8676002)(4326008)(956004)(1076003)(16526019)(26005)(186003)(2616005)(478600001)(316002)(66476007)(66556008)(6666004)(86362001)(66946007)(44832011)(83380400001)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7A60K3+6OM8fYhfhjSM2F5pTrcEeVXXdniNppE1f2a7gFAPgxCSDpaPQmdeU?=
 =?us-ascii?Q?Sa4D6MgAIRvGXXUQaXPcG+Sa3naRuCgfKd1PdVf5mfuXqCPpsUYK6c92aIxt?=
 =?us-ascii?Q?brtOpUun3vZohTm1L/qnU48lXHRGwRil6nu7OsNcq/HW/ZYpteyvR/I8CYwt?=
 =?us-ascii?Q?alyxefpU9lXiju8NJ20YdlEw83zn6Y1BOuP0qWHiIHuYRSkir7fIMA68SFFb?=
 =?us-ascii?Q?qLRuKIcPbpkT0MD7drhAJ9s6mdFsQuJkwUSEHCray65H8xsxez7YilZtjUgL?=
 =?us-ascii?Q?+hUuGUdffQ2eg4W39RSPSA4S2i6Dix42iNFBt/3x7cuwIT7XLT/cDB41btPS?=
 =?us-ascii?Q?8stVUzZsnQgIxEokAru8kzTfNbFZ5kQTDCMOOdr8iONvadvC38OrqKOD+kWN?=
 =?us-ascii?Q?1kjKGXClXqt1jPFa6QJW8hjs/Wgydvkgp7K4yJflAROo8HIo040HsVUtxddB?=
 =?us-ascii?Q?AlehpHLzv8/TCtyxhvdhAUkdlncoXBrvFn1nX/7LkTINeMFIaj/BAxNaWyeG?=
 =?us-ascii?Q?EI+KhmGLhz39yQh/6qqAZgaAGS9OKyXN8pAP2vMgo+Jig4/qS3EbkcRkhVGs?=
 =?us-ascii?Q?uiv5xbo3zcIG01NaOXGBvVqiggupXuqa90hCz0cQhsBYb8QBzcUdbVm/E+z7?=
 =?us-ascii?Q?PP0mGataoAtZOl38TdI0TY7CZJlsg5hI3tw1zHoR88eQw1O6tRSE8BiRkcpb?=
 =?us-ascii?Q?EIQuQFIZEzBOLnuxIltyhia1A7SDWWi+SdWLxIZo+wxHiYc1QpVSlO2/hbSK?=
 =?us-ascii?Q?Ef9i2NAPXGZFzIfThfEwmRbmbOIzY+j0SCU16fANs04QlvI+rShMqRUiEF/a?=
 =?us-ascii?Q?xN2guh3tpQS5Sdm5MmrPH6ZZJfomHt7LbBhCiaX36Yi6HzQ3+dlErtgl21jV?=
 =?us-ascii?Q?Bc4o6EwL12pTxX9NhecTFihZmeJyx/uG82tOREwPr4YEqAWgZp+a4A52iT7g?=
 =?us-ascii?Q?bE6V4MCMjfCSpkyELuDmh76K0eMi6xJXNAQzEqK7+A2kHHc9IRGIY+wxvhrv?=
 =?us-ascii?Q?QR/hZPzdok18fX7mdvB+dzjh1Dq0kkNNeQ5TDqqZAUT4y8oLhAnH5C/ACZsX?=
 =?us-ascii?Q?jqahZ4NlwGg5DFS5WWHsv3+FzvYd0Q/3qGVX+HNcqrlKXQEk5DrtDDW7g6Uk?=
 =?us-ascii?Q?dFU/nXXPlnlPQL5QiT63uzaER4hNQaSFGk3H93MJtmprrgB+bqkc87SzFZry?=
 =?us-ascii?Q?6jaZx7/Q76Z5IUJ6/KnybjQnp8OH31vjVx6b0FhWojM5jeYJg/ys+oGZHmS6?=
 =?us-ascii?Q?L40gFzDOF/BLXUDv1E9dAvl/V0sz4iv90zqLL8t2D0B7FLeSz6oZDT2mz2M/?=
 =?us-ascii?Q?HT56+a/t54wjvJrdYSjPUxhP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1adfc4-aeef-4605-1d1a-08d92b77d5f2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:53:14.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzambFODyVFyiScWG7TLvTOVboBn4eoU2ISe+bnpjQoP8mFZg4LpKlCvWmIvHfZAzqO6LUQ3k9R8wpn489JfxUk3xkzT8DyB6xjxJ3d2Wc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
X-Proofpoint-ORIG-GUID: qoyXXVZmmSCVUxOoelxCQFnSvZXmwFbq
X-Proofpoint-GUID: qoyXXVZmmSCVUxOoelxCQFnSvZXmwFbq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct kvm' already has a member for tracking the number of VCPUs created
in a given VM. Add this as a new VM statistic to KVM debugfs. This statistic
can be a useful metric to track the usage of VCPUs on a host running
customer VMs.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 1 +
 virt/kvm/kvm_main.c             | 6 ++++++
 3 files changed, 8 insertions(+)

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
index 6b4feb92dc79..a129a6734965 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3318,6 +3318,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+#ifdef CONFIG_X86
+	kvm->stat.vcpus++;
+#endif
 	mutex_unlock(&kvm->lock);
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
@@ -3394,6 +3397,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
+#ifdef CONFIG_X86
+	kvm->stat.vcpus--;
+#endif
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
2.27.0

