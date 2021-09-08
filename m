Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88154031C9
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 02:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344993AbhIHAMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 20:12:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28326 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234396AbhIHAMM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 20:12:12 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187LTuEg025789;
        Wed, 8 Sep 2021 00:10:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=/NT/ZY81gdzIIiPqbv6RXOLC9l4wU0YyECCbQGoDzoc=;
 b=ZcI4b6drE9Mdf2RzNi5/1lI7PVVjPZ2cnFw2ixoDLFGXZlAQqXQ5NjpO5pmfokSDA6y6
 tdRA26WAPIOn0c7YLghK2npclBQMToIschRzIySYb4bWMmUMMMGuNmtONhi3Kvktv+mK
 84wjmpH+mwS0aOwNcRUR/9UI76FqycPfnHyuqnkoYInq0KGpKRYLtBO1J/QHBgDw50oI
 Ekg/3+4fJKKdE6E6trXeh6uvNQOkUWqoRmq+xOiC9Scax1LoHY81MIEMmMe75qgtinVu
 uhg5IwGS/Efkqbfq+h5izsNadePPNNAOQataIZpTnoJHg3oz7lA6ZdN1gVgxj1vwkYag Ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=/NT/ZY81gdzIIiPqbv6RXOLC9l4wU0YyECCbQGoDzoc=;
 b=qxc+numGuSfku2MQWDAwmIUaqTM0g0Ipr0S4IxbdZfjIL5QmgGmsSn16y+w+r1dJXkXy
 2QOe27MHdd6kcS/b8r20YP1kDbKwPwI8lhvNJY9QIPn5z5a2v5YuzZ3anYsijwfXTcm4
 20dqH/DW6Mbq0Ft4twaloWoIQidC7KlolQhwsVp7fv0kXdB5abPaDzlgSqg6uFQU7Q+W
 GrQ7aMHPm3kA2QOhFlSkzyp2GYkFRSTT6k9O67uB6mYxrCuOv3MtZGa5SAmJ7CXV33vp
 K7CqK0jBMDAezJ1pULMwwr9fFWSVrDjpDbjLrEuaaz2zQw+xyS+hSRrE/NKS6rg27oBw wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd8q0s36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 00:10:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1880A1wv050613;
        Wed, 8 Sep 2021 00:10:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3axcpkeg8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 00:10:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0d7Rb8aDf3axgUIRiW/rJmSdZi5caVyZSGzlRdN3zSVWLbhDeGzZnH3yS3qcLC6+/HJR6FcWjHjCPXzzyalr+x7Ak28lsTTIZBRDzcrbiwCo7ukvC9dkgRxXX9lu/KzgaozthiZ//wtUS6EZ2a1SDs3emgWSv7yH8Q+Hb1RUV25H7KpGyoOW0/YV5N62lIb7KKa5Qv7sxVW3m0MMWTjO/aechQifDeeruzQO+y4W1hYCQq1XXdwQM7VAwrXVuHxEPTnXC28g+iXng1HrDGKCAslZ+n7IZeAU1zuecSAnBeKtieJtoetZfKcj0MY+r63oQ+1WZSl8XCvV5ZsHccT+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/NT/ZY81gdzIIiPqbv6RXOLC9l4wU0YyECCbQGoDzoc=;
 b=eGWeYdIzbgoovvLgYF635pJkWhnvnCGty7BruipnjGvkQrH5t6AAboll5wnJ9D/Exrv3asQnZIUkd7YLsYqgvZ8dXBicCN8Rr0OhZ3SoBgCOV0/kG8o+RTx7PfBWGvI6kUNMNsq0ioW/Kot+2VXZpcYZ+QfMDtrEDGxWIDd6fY3vP6LBJMVBpSBsgZH47XIU2xur31I04gppgM/ebSQnf8hl6TZfAhe0RNz2IU5dPFE+8pTeGS79QYRJB0M2RyDzh4QqFXaYYNPQC2Iw3Jhnyl6iJRm9U4/hEcuZm+zySq41X0aYINoscTb0KJh3H/oEKkD85BDxYRBzO/dIjYxFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NT/ZY81gdzIIiPqbv6RXOLC9l4wU0YyECCbQGoDzoc=;
 b=TnkBJn9zyT6xXgR9rwWvGxsAWDrS7IQd1gEwfj1Vr5WHDHWGQV/YwLJyvUNiZqfnpQ8X6WBtr1fUthujakNKUcxtj5SJP3yFhfGTU/wQ6h3Zz+NyqU90FSArO03Rv19HwFDWIxSugaa6ZzaYfHr76HTD9yQg0T5kNk1r3WGHKEw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3095.namprd10.prod.outlook.com (2603:10b6:a03:157::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 00:09:47 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64%5]) with mapi id 15.20.4478.025; Wed, 8 Sep 2021
 00:09:47 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: [PATCH RFC 1/1] kvm: export per-vcpu exits to userspace
Date:   Tue,  7 Sep 2021 17:08:24 -0700
Message-Id: <20210908000824.28063-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:805:f2::29) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
Received: from localhost.localdomain (138.3.200.16) by SN6PR04CA0088.namprd04.prod.outlook.com (2603:10b6:805:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 00:09:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5752a06-a0c7-43dc-8ea3-08d9725cf7cb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3095DC4179175CC121A3557EF0D49@BYAPR10MB3095.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1hLhVYJmDhof5p4t3o44EeDymmFMbqshiKeGDm/+RsJLyaftVTuOftv/er2AVBohfAMjQehZpmqRGglk8h4BGjbP+mfIyL630P1BHa8mJBjGzUwCCzwU02fwVbS0KmqX/bcxlIlpBU8sXXDgC2zqzAZeR/E0Oc4+ViXEhsPrD9CuhAx1LTChMsUviYWlKJiRoiCPOuxo2UdOw0jHrxeot2CaC1dKTW0bCx9FibQHnAMvN9Bu/mu97/23rsa9Yadu9Aaw86wpBYeiK76faiv4o7ElAYjHoK2BrTZ7y712r+v5zlpN+I5QQpmSs+Chx2fbTg/u41JJ5Qbht7a8752HFnK6/H2LOvepjjjZe6QpV7XoZ2NS8RE/HeXlNQWIXKSfzNczQvmcbwA1rgvYNpKkpA61WanpWXscVD73L7hvgn3e1iHvchneMsak4KjqnrZlhpC3ktqRXZB7JSrUJcRu2NxJ9sxEs1SuuuAFg7Ye592fZql12fTIPIuPKRoRWTbcEOQSsKwbyDXC1GKDe3p1Gav1gTHC8QRy3Yl+OKrPVDtLvn5U1pM+xbHfm0tcnEbnHh79oXkBwngW45joQK/MCvy+js9LRWjPBYgnYN6gmjrS8GhJkAeTY7nQbbaP/gKJ/Odis+JK4KT5AgVP1VuGKSBTCw07pSWp58N8VF2rBjsEl8DNusOA/MTh0BNdBYoiC4I45u1D6L/TgnSd8o7dJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(39860400002)(346002)(66556008)(7416002)(956004)(2616005)(5660300002)(478600001)(2906002)(186003)(38350700002)(38100700002)(8676002)(107886003)(44832011)(52116002)(86362001)(66946007)(6486002)(8936002)(316002)(6666004)(83380400001)(6506007)(1076003)(4326008)(6916009)(6512007)(26005)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0sPnspfnLqJKIHrLH8QReU9XGQhptVb7oXzCrfBab1yQYo8jj9QBwhQl2pX3?=
 =?us-ascii?Q?IFwI0nyPln5TAI44QVAd+HtbPyyDZbKlG/LAyBeE+vtTtFTqie/QJ7m+QveQ?=
 =?us-ascii?Q?sbybecAC/0wajnRArxHYN988+bq+u9qICKtKAT2ljlTtMnQJaQo3pi6zs6Vn?=
 =?us-ascii?Q?UGNNKqm7TnyJOS/7mN/s6MtDe/SxpaB3RY7WwTvcmPDKb+aEYjUSPXf79PzO?=
 =?us-ascii?Q?Zm4bGAgkjEbUO5CgaoeLiqk3OPNIpD9QsKVlcWmwnutd40eLKx4xSKnmaKGS?=
 =?us-ascii?Q?G4SXJUHVV4wnVCRFnb/wX/AjJUisrKlmI/xmbqjKU/qxSD3f74iw9jgvJJHp?=
 =?us-ascii?Q?KDpYnQR+LFlg/0z1mqK00+68Yau1NPkD37i7wvOpzQG3f5UrmCHf/xIV1Shp?=
 =?us-ascii?Q?LS3Fo0I+x6RTjoAEF+Zd+YmxduwYfQS0CUBgpdxzq/FGfeJyFMT/ryWdq5uy?=
 =?us-ascii?Q?wPEpdrQ4WXXA/TD5SL1MO8yrh6uByQUwvXlO3DkpMUoP5cy5OYySFTGuhjGZ?=
 =?us-ascii?Q?1tBrklHZ78iZjjninQL7wwnwAZfdIdtCZGQFdMw9F7dkAQNGr3BPG3Xd3H4S?=
 =?us-ascii?Q?4rvmuAhHkCc3FKLonakeMAUrizK5tR8k7F+PWYHbQA1EQm9yloZxsDMF6uJs?=
 =?us-ascii?Q?uqQDpXgGqzprlfkCwfbmxKy/3glhlcJsKLdJN2HTqvoZpnqT+0Fa15RZ7uuy?=
 =?us-ascii?Q?mjLfgBsuKYGnGWpTxFXtvXncvaVWs5sFU6jMAzUc+dU1/3l7s8DDo1xBpivR?=
 =?us-ascii?Q?H+RqRLl8I2bzbigbY7cEly3ql6UVKdNnOeMCmaCSDM+ilf7QJ0vS8QE7M8H7?=
 =?us-ascii?Q?EFRATYAFFvXR/15YYgSYFexm+ozNWY8bXiCPnFaQ0QUUsytUBHuA5NOwxuG3?=
 =?us-ascii?Q?afxfdUhHavlnyjv8y/p5+aEhDkHn/N0CvakWFVLlj183CFgGKOk4iMrLyV4O?=
 =?us-ascii?Q?BjrQ/Fm4VFg1ey4LqcaAtp4CuBvDtXLfmWkV3wyxHtWn4jDbBW0Clg+qAKbA?=
 =?us-ascii?Q?mjIZCfQnk2qCaBfQh3ddYCD8TFEt5RFx4g+XSAz4hw5oIbo3OQQAQQRqluK4?=
 =?us-ascii?Q?HhNPtNcfY/T25Xv+UqUiydZBNvUI3aCtW/6q2EpDMXfLKeXOXsp/L/DwqojI?=
 =?us-ascii?Q?tXjKmm59ILUCN/Yu7l3Hn7QpbaUQUeJh82khcN1R7IGX6f1tSqNc6HUB3FVH?=
 =?us-ascii?Q?KigCHhDWfZOIFm12y+4f7bev0pLE533xiYgMAEfLNePukDa6R3xEXQJYzhAj?=
 =?us-ascii?Q?fHshAQuFZzEVKXvSjRw1twSJID8bykNh5h4apf6ygZRnGWotHfF4hzge5ivK?=
 =?us-ascii?Q?ShHEn4J2q6h9qxtzrquDVtsW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5752a06-a0c7-43dc-8ea3-08d9725cf7cb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 00:09:47.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rL3BxFX6eBLriYuhGlUk9j0sS1jBWDzD44RmcupVplTygvWjf3eXKGhj5Z+vblAIrv9ZLQCyyRKPMco8SkGaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3095
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=847
 adultscore=91 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109070153
X-Proofpoint-GUID: uNalZaTThXArb-4VwJ9F6V3jfALOUyPS
X-Proofpoint-ORIG-GUID: uNalZaTThXArb-4VwJ9F6V3jfALOUyPS
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

People sometimes may blame KVM scheduling if there is softlockup/rcu_stall
in VM kernel. The KVM developers are required to prove that a specific VCPU
is being regularly scheduled by KVM hypervisor.

So far we use "pidstat -p <qemu-pid> -t 1" or
"cat /proc/<pid>/task/<tid>/stat", but 'exits' is more fine-grained.

Therefore, the 'exits' is exported to userspace to verify if a VCPU is
being scheduled regularly.

I was going to export 'exits', until there was binary stats available.
Unfortunately, QEMU does not support binary stats and we will need to
read via debugfs temporarily. This patch can also be backported to prior
versions that do not support binary stats.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/debugfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 95a98413dc32..69ecc06e45a0 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -17,6 +17,15 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
+static int vcpu_get_exits(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->stat.exits;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_exits_fops, vcpu_get_exits, NULL, "%llu\n");
+
 static int vcpu_get_guest_mode(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -54,6 +63,8 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bi
 
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
+	debugfs_create_file("exits", 0444, debugfs_dentry, vcpu,
+			    &vcpu_exits_fops);
 	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
 			    &vcpu_guest_mode_fops);
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
-- 
2.17.1

