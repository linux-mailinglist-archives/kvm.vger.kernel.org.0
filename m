Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5222E3B6696
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhF1QWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:22:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60678 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232907AbhF1QWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 12:22:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SGB3q9016415;
        Mon, 28 Jun 2021 16:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6VoXMlKil26r7xTs3ggUvsVBlwfjWBLC2ubXF8nksIQ=;
 b=uAwQY8qRVE8AJ2DxaSbTAC+CgSh6P2seUduEwURpmSr/z6VKsK9jXjdVZoCU6fXQu1ox
 n28TKC64tldl+GJ/cjMes2DFJf9Z81BZAHfpnc3VJFimUUQX9cb4TBBsSJUXfBaifcJI
 PWffTS3AmzyDS0/M53gur+4WAUx/kMSmAt71lTxnv0nbgQzjw88shJkoYSeC6+ebkADS
 n87cz/G2oeLZ+PfKGFeHvF80DiH6okGCG4h9II619lyrP5O6Fb8hQjPUe1yt/L4yw9aX
 aY2BADIW/FctFQpJMrla62l82bu4wmRVppx9m1NFZtDkABVI/IkWpNya6nnuz/cT/Fvq rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3hfd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 16:19:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15SGBpmV129148;
        Mon, 28 Jun 2021 16:19:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 39dv23wvjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 16:19:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWwzaUx1pVPlLrukJavgzgxdFaFV52VuP/F2sPDhsiRDhd+WQlohCFUSw5EoK83f/VEig89Zb8cdT00cYDYUPg4wPzG9WNa6/XNCQakyAQVlGbrQDC9oBDfUcg82lp8Hyjc+tvL9w6RR20vd4FK+kV39Gm0T7w/jje7DxsbtKbhmVHOIfKZBXIErSHfsIsK1RjHP38GCA5gEhfy0Jr6SjcZU4mCm2qqeHLKUVn9sIkQZZQ9Xth8TRvubNb8gXRPFLAsuXpCZvQhN/ICEQvWDVLt/ptaeqehQvv7KW47sVeFNnPnPZQ9fDKNXWgy6Xz+G9Ve2ZfoIPI/elt9Wn39upQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VoXMlKil26r7xTs3ggUvsVBlwfjWBLC2ubXF8nksIQ=;
 b=XeqeF6VuaTfK2brXlHwDt46QifKDEtijP57X6qQ6GRgucnpESCBpOfjTWQb2LOF7PmKI/wylgbeI855U/UbVq70rLf2V/tKxfVkAyawovVWB7KSkSDJST0oJAZqR0vnm4kYg/07Jtcm3B+++QJUz6VYKFiZTo/EwIfZJtTiEuu9WNU1VS3iqXh2zpNCixOMDhs54Ywsm+cNdtsIW9AmGZoKvjqnpF/M7Wk7ntg1y+lt70JJiCCmgGfWhk8kkk+rxENy/fTRoyIAJwVb9K5gh6c82WnU+VKb/nbxe8RYosipTwFE5vKcJ5QKpdGiZho2WIHYPKjU93FjtmR1pG/CeJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VoXMlKil26r7xTs3ggUvsVBlwfjWBLC2ubXF8nksIQ=;
 b=I1E/eKYEH5LJgXBwicKbY8i1oWGNrX/QDIbgF5ajLtjgIvyOSuEsTd+FI94ceR5/ye6ExNtlSztgtJW3L03XC9o3MmfIE95fuzuOstdjK5gyRc9jZdFt4satksUX4uk4UVG0liRklk/KbZnQb4TszQcpMSglXCwiFg6IryI5gHg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB4005.namprd10.prod.outlook.com (2603:10b6:610:f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 16:19:35 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6%9]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 16:19:35 +0000
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     konrad.wilk@oracle.com, alexandre.chartre@oracle.com
Subject: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
Date:   Mon, 28 Jun 2021 18:19:25 +0200
Message-Id: <20210628161925.401343-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2a01:cb15:8010:b100:76dc:8169:72eb:62ac]
X-ClientProxiedBy: AM9P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::9) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.nl.oracle.com (2a01:cb15:8010:b100:76dc:8169:72eb:62ac) by AM9P195CA0004.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 16:19:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 057fe2f1-c01e-4a2e-67cf-08d93a508522
X-MS-TrafficTypeDiagnostic: CH2PR10MB4005:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB400521BDD0B3C863058DD3C89A039@CH2PR10MB4005.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWeaBar3NYo7gbcMr9Vk7zgHoljO54IVPh6zvRTmZIi/S5we14iLnVmu+eFpXXCWPDoukH6A80tjGbWwstRiIuAQ955yKVPU/nASDiHr27MezDWUoqyI2NiHKkBHx7kTkwQAH0pZNsPEsWVxVSP9lxoXOPD8Rbt7ZQijihhGR4seWdsqDnBTLWyuQY8F5lfW0eokNI6QmA/BjBt0R01S4iYmKwGD0/qJUtLCWbkM/AhBOsyGZWS4yI/oWsmnj5Frk1KHdzNdEQKQJe0ObM+pzO/j1YZxnsC7WgvCHR0Sd8vpyVcA80yHlYQ0cEQQnXedrc+OywxupZGwTSgcw91pZAzAQmSakpPT+CBQ9GiKGykx6QWiIkKii1NIYjxHw/ahjrwtfZ2d25W2LbYzuLDYMzTBfNNXHA5Eu0lK+3UClL2BYmixvLIjtrVz3a3M5Z8PXD4vZt0kl21IqJTqZeL6gozUxWidrQ4xh3G0MAZpY+kSwNYEmgrK6qDAHjpB8tmQeuM/U53HkRRdKUR6z5uZQKOV4TikABtBVA9FWBFR4JwEzNCpTGkObjMu//wotDEXE4WayjTfj9jmr1d0igS9n9RXbBs/7xlE9ldKzKJ0vAhVZEOyF2sutbGfeMW8+s0Z2XtopxtWZTv5xGbbZf4l5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(136003)(346002)(44832011)(6666004)(36756003)(2616005)(38100700002)(86362001)(316002)(1076003)(6486002)(5660300002)(83380400001)(107886003)(4326008)(16526019)(186003)(66476007)(66556008)(8936002)(2906002)(66946007)(478600001)(7696005)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lyxZ5HnR75YQnYPJhlBeWlEkHK9A6C00BygYATVIRbrRjnNOfJYfSwOhepn0?=
 =?us-ascii?Q?hJ5C9ZbrqKeh0aVA4MqmO7BPyMaV71C4AkfrWJLCzySBI1F7cGuYjPTvOMyU?=
 =?us-ascii?Q?DDMCWC9IxzZUzms4N0XvCE00x1gfPGeYa0XTp3x14N2F9O/1ctptjth8NRKr?=
 =?us-ascii?Q?9ET2hnxMxg6mrMC2TCFx9BcnlEy8A4GYItrPC2r3esO451K456EbICDnHj7Z?=
 =?us-ascii?Q?PsHa2p5N2YRqm3EcfHueXWar97PBGG4i4oFfVevp94btAfWjDUVrkumnDbDG?=
 =?us-ascii?Q?W+ll6+1gQOSk064fE5WMaZ361vczodWnDnS/eOR21ad7B45WLiplI2RA0b/Q?=
 =?us-ascii?Q?DBdk17wi7MuALIxkNzyi2w1JjX49NZbIYiGGdR6YcoJsU/8zC4uRJh/L6We0?=
 =?us-ascii?Q?0BeJkaolXRGGu/piH/ssnIKnoSesei7PWWcv2Osf7cqhmyer/9der9VgoeB+?=
 =?us-ascii?Q?hl+dW7UdgwWvWdJdFm8/qhYHgjTCam/cDJtVGXkbZwyUTzim9YdBFDrA+ZxR?=
 =?us-ascii?Q?mqXLb52CuIK5ZgdGu5FInJrIvWI+YpAqkapvn1oVSjiqmL97lbEWeawWgRNS?=
 =?us-ascii?Q?KcmR2Ztn/G1AADTQOaSK4c427FTeRegwKRLYth1bN2Jl/P6hDsLwykknhrNA?=
 =?us-ascii?Q?KcSMsjvrn+nXbnSjMJB3OXfqCiUC/QUb72K+TfMprbQO65e4h2nhSaHpidFW?=
 =?us-ascii?Q?GKQjJJ8nkhX2kJgL1M80xPVlUMP/9rDREQr7yezR2XKpoO3ICB4eOOnWRW/T?=
 =?us-ascii?Q?tT+wwyWLekpPGZm0nUFdD0IHD4mDeGHY+j9OohifB/Tnf7QGPYletPYDA3+9?=
 =?us-ascii?Q?5EyJGwNvkJShfq4rANAFqhIeFbd40fH8RbLQkF1NMK8rPAPVCJd2Lm8CcV4/?=
 =?us-ascii?Q?rkx1IIsoQmMDqXFK/CC+mHx3scciCUVELKYzWofBqE15sBvDNsfLdgtQ1Gr/?=
 =?us-ascii?Q?rzJnDCoIK8O0zORUmX1BGIdEgGbWbzgutUOfdz/66015mMOs25f8ow158K9p?=
 =?us-ascii?Q?pJL2LKVdIZ7W/NIFJJNvH0euJ1B9Eq59CbVpWuVZ5yw8u+0t/GGSnnbAE4PR?=
 =?us-ascii?Q?tvHa7kN+pp0VqRd17f38RIEbfAiQh30rKGJUt/bHI4M5a+ufcij+UXx/p34R?=
 =?us-ascii?Q?flDCZArUSxp76duw6nyJkZBs4mxyeSJfmzSit+TwitsiUxsH2Ll5CAvIS45h?=
 =?us-ascii?Q?wfx5FkDQe1q48bGKSDDYC5ejprn/GSDgzqD51QFOUZZe8eDK7XSr6IkMyQ4Z?=
 =?us-ascii?Q?haBXtwK1w6IwcPw2XSE3xANvo4zCQDBEeqaYBOdn/y6N1p1nKYzZkSY/Z+6z?=
 =?us-ascii?Q?tTTHn9LcZzyaPNImMAdpXJEuFMhPdc9ZG4Ey/rd8krqBuam9UGHx+Rs0RGRI?=
 =?us-ascii?Q?hkeXd/Dq4mJgqeZPZfo91OqWB8hq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057fe2f1-c01e-4a2e-67cf-08d93a508522
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 16:19:35.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F11b0KpSalg96dTGcl0UbtKc9D8TUKMSy9pYj8Zt/BkL6vqunEp6MxM+Wert0MBoeQEvjEuZ/+i2/eKL/N1Lr71PBqzYRh0ZoHVKFQB6nGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4005
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106280108
X-Proofpoint-GUID: -YyG5dX00GkeqBlGvYI4iF4-gbNURfTC
X-Proofpoint-ORIG-GUID: -YyG5dX00GkeqBlGvYI4iF4-gbNURfTC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a KVM guest on ARM, performance counters interrupts have an
unnecessary overhead which slows down execution when using the "perf
record" command and limits the "perf record" sampling period.

The problem is that when a guest VM disables counters by clearing the
PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.

KVM disables a counter by calling into the perf framework, in particular
by calling perf_event_create_kernel_counter() which is a time consuming
operation. So, for example, with a Neoverse N1 CPU core which has 6 event
counters and one cycle counter, KVM will always disable all 7 counters
even if only one is enabled.

This typically happens when using the "perf record" command in a guest
VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
uses the cycle counter. And when using the "perf record" -F option with
a high profiling frequency, the overhead of KVM disabling all counters
instead of one on every counter interrupt becomes very noticeable.

The problem is fixed by having KVM disable only counters which are
enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
then KVM will not enable it when setting PMCR_EL0.E and it will remain
disable as long as it is not enabled in PMCNTENSET_EL0. So there is
effectively no need to disable a counter when clearing PMCR_EL0.E if it
is not enabled PMCNTENSET_EL0.

Fixes: 76993739cd6f ("arm64: KVM: Add helper to handle PMCR register bits")
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fd167d4f4215..bab4b735a0cf 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -571,7 +571,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
 	} else {
-		kvm_pmu_disable_counter_mask(vcpu, mask);
+		kvm_pmu_disable_counter_mask(vcpu,
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
 	}
 
 	if (val & ARMV8_PMU_PMCR_C)
-- 
2.27.0

