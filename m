Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292543CA8C6
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 21:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbhGOTCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 15:02:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20158 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240660AbhGOTBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 15:01:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FIvdhi024069;
        Thu, 15 Jul 2021 18:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=3RgndGgs+hGx53pbhFR2U95K+tyAjcF/Tws9JiWa5qY=;
 b=uQoz6aybEH6lI2Vj9mbU4dE1HzKBzlrVObK4rVTnoLS91qb3Hggh88zYMOCO8IfWU6YR
 jryUJRfuGjNB56loEMCvCSHMFQaPfi5pZoMtOpzcU2rHO/KRCu/EDvwx+wmCDhwUI4id
 k604BgRyO8Wv8Xz4v8tE6bH8YcAsWFCb/4z7aqER1e1hV338Xo4YV+QWB1ocnVYX6+Br
 bdj0vz0V+SLVv+5Oe1ePiuCXt5KF+EyqUqSQxL5ogt9lt43qVQw08HPCtAo6zNh0He/c
 toJQHWOYJ4cKz42IlY/XClQK6PTlVr/J0+CHeoU3uix9cG4G58JLV4VGTbBInML/Yk9E DQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3RgndGgs+hGx53pbhFR2U95K+tyAjcF/Tws9JiWa5qY=;
 b=GPLBB3C3rzQEMuOeVb+DAKXu22UVjor7Jt73AU670f2gMxGfu/MVtP9H47TPugFh4Nc9
 xx+9cionUqRNT3Wqb0AaZ2KuS6UG+g2Z9t7/X2EDIYpwS/tldk+oJ5IFaTquZ6oy+Wu/
 UH+V7cPjgXrSji+G3Ar4cbxeV7i7LtdF+laamjQMQkp1ne29s4VqRmonaOOTsGw+W64d
 UhvsC9onXGx/W7u0YmkZ1L7xS4OKPaiwIvDwzHxYmGvuUg3oSMOISqT08HeaIqqTl8ud
 uMrbIeMBmtLhD+rjLNwBq473F+ktbRqFW6ixDSO39056l1K6M/0tRK5aRbbyTCbg2Dcm Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39suk8upee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FIsouj050707;
        Thu, 15 Jul 2021 18:58:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 39q3cjc79b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 18:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtfXZQkpMPIWoDnMfEbWlWQ8LKDKYpTMUJZpRuZR52Tk9LJIllgo9Bu50cte3R/5C+JOqD9KJkmqx0bxOza6hgpqWtsqVUPdesBTCPRYHuF4yzqNYJWUNgM6v+F33N/4zAKpUWgnjMd6Zray1NLyMXjXMDR9VYaT8gFTjb5S7tZZ0j5FVu9sAvOUa7FH7XpC4Uv+8j1+jJ3y9EayIbiCVKBnhxBs0tY1VlAMZ7NGN8f4lCTMjxHGFwNK2tK4swG8B2Gz9EzQjNtlPzCJsuRcH22UpYUDrOBfDD+UQmu3vA64C5xtBZtMaXyS0o6zEjLQ/HkKh8yvPceP5XIyMbmVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RgndGgs+hGx53pbhFR2U95K+tyAjcF/Tws9JiWa5qY=;
 b=iNTv/PR4Htb+W6vI0bvSQxa9030tQPSL8xjl7KsDLBqc57HAPgdHsyG67sv7uWqvNfq12NJn0lUVDcZgiM8di7HevPCsUqcOmd71WHgEARhVUWqs+R7D5jBKDMP8smXppBbQKijLof/6JqNPu4SYVD/x+WA0q24PmRgBk/9V3cpWRfiYuNbfsLYsdKhO+9H9sEdveyTrkGz7W7ow25lKYO+XYhl3mwyDF3R+iRGvr0oYQOEyXQzQSToOvbMAc+8zxiEY34bnJi8tUawE2nVAEh8ZfgxotC1QfnrqYPQpkq8abj5045dt9oaS/6MfeuGkzPddR3nItPAMmtTAhtg/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RgndGgs+hGx53pbhFR2U95K+tyAjcF/Tws9JiWa5qY=;
 b=XqxcnHV+29GVxVDs6cy3CMeoABuAsmoJ2TJV3Lj6HCT453Q5bNZ1DG3z0CEYXhumdMpcy7wrrHc1sxW+t1/6AubHnb6NN/cj2FE37T/ZtClvVI5vpgEf8RWlKLpjZ5sDiFI5RkRfX5SOHsvESLk0otTq4K2FADIO3ptPJZ4Vhow=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2558.namprd10.prod.outlook.com (2603:10b6:805:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 18:58:17 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 18:58:17 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/2] nSVM: Add a variant of svm_vmrun() for executing custom guest code
Date:   Thu, 15 Jul 2021 14:08:23 -0400
Message-Id: <20210715180824.234781-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
References: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:806:122::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0114.namprd04.prod.outlook.com (2603:10b6:806:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 18:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01d248de-c10e-417c-4b31-08d947c281a1
X-MS-TrafficTypeDiagnostic: SN6PR10MB2558:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2558C80C8B5A0CEB71BBB75881129@SN6PR10MB2558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYLj+JEt/DCu5eVIe1LidIWskYlQ6iuealaEd3fp/1SNqM8/XOcALtHatWNarbHMtXko7TmBUKM7qCzU39tTCTncRfgMzTfqd7CzZzLbHwG+58h8lDKU3Dp6fLZtXellGq2dlzpfC1j6AEpQyRKJq4QFCDc5zXTrqxPxWUH9imSdI9hkFMM0JDwvKXED6QkRd2fiY3m3goRTOoW+oeqqipNq+/Hm1acLePRwge/S5Pxb1a+6c2MzOzz7cqjtwmUbm6pGKq92EGyAUyciVWb8MUQWW8ICSaBmZqkJOjP9+T3L0FfxSu4wMapl7sfjf3lxqqdKPw9C30zHwr6Rmqg9xHBQkO0GHdxl/QI6zxU7mD/I7AcF4Q+d2Xtj8v8kBLB0t7XgsXlnn+ZNXYWRC3ETwfg8/gP0cedgytj6w5813fjG5mxPYoH4RGT2CmVFuojoRlpn6jLX4tsokokGUbj0H/8Q1i8kNkeEbEMymQ287SSAIK4ibIrE7Aqbf4qXpFXlAX2vOkR+ROQs3Vcwz3iyRbqK2keMGzj7OdSxcGMpKiAPNRObOaPPyfYr7usyptWYxSLIKovHlRHzISxcQhRLubUlBOQN5INzbRl0hR/4XJIdVmLfXs6U6cuf0XP0l4d6BPKY+/CDuEUc3TkAfLm9VIv98D8BkrWlfNJrjLqiOLphnbzivNNuHYrAn/Zs7NKXhZ5Bdbt81CYKQVs7IZc7Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(396003)(376002)(136003)(38350700002)(2906002)(6666004)(86362001)(36756003)(38100700002)(1076003)(4326008)(83380400001)(8676002)(6486002)(6916009)(186003)(478600001)(26005)(44832011)(8936002)(5660300002)(52116002)(7696005)(66946007)(66556008)(66476007)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?94g+/4THpOgXYB6RoinlQU3V3eAEmCtPGAtd+bOt15rY0Qal6oSe18tzzSh2?=
 =?us-ascii?Q?uvbIoDVcBoQTSmZysZRzfp9xJzXEhS2yMOGL6ACfv5oAcFe5q64ZCk9SOiBc?=
 =?us-ascii?Q?njbIg1QXZnIsI8O/gyhJb62gPwPCGU5ev83GUCwdujHMBh7N4nKhqzEWmWZj?=
 =?us-ascii?Q?MEdG3+TEhMFZuLUfxuiF2Lz50WpFGYksESr6g1EZMGv7fig4SsMUKVQFFiGb?=
 =?us-ascii?Q?D4KOvQpnimd7DZOfwCCODRfkOD685s/YEYl8hfqMuzNw64sQ7SsptWICgEQW?=
 =?us-ascii?Q?zZdxuN1VGvLvmLR03zPL9jOEnYVwnZ38a0MYNBbg5I99YjmyZnLH/1bjyWXZ?=
 =?us-ascii?Q?x4Hki5YoNyso/UXnY52EbPM82BL0CHFhJ2Mmt14Y93ojxNkbewe4ZxtSKFMx?=
 =?us-ascii?Q?7BgliRyedDAp6ufQhHpWqjQ73yx7ZO51oER55fIvw2b1MJEy2BHtu7W0YQgz?=
 =?us-ascii?Q?a98RpDsEro/8KKzaTiCY58dK5Cljj7Wtn22E0uYEZ+kfViknypwP8+TfiNQD?=
 =?us-ascii?Q?Mj5J+iR7jRBQ6oGu5NSWyLvD1MzncLzVaHxFqcwLXLYJwaBFmVpDLHOv6MAI?=
 =?us-ascii?Q?OI5wb70htZqBbFGJPxYzNFNFtNuSLgsS12ulWVsZeuwq3KzBTcHtEjQbn8/W?=
 =?us-ascii?Q?9W+0WrkCZjejHKDHX6q9CP+i2bUUeUZ8ZpTjdS1IL3NqDjUrFhoeGuqE/oYT?=
 =?us-ascii?Q?rFFzdjg2h0Mpxp/8L2lPuiJLuqm7G0GOXDKNJuxjUDdLA8lzFTwlRp86y6cS?=
 =?us-ascii?Q?sr1Gaorcpb14tqYnZS864Cpj4DhYiPg1n5lnVP9blCSrJPWuFmzlJzxxPkuc?=
 =?us-ascii?Q?TEP7CbV5Czd0uwf3q2QBo5sAwrXqEphFD935rncg9l5e+zEsYWPPM4APdckO?=
 =?us-ascii?Q?Chu+bPjw2pWmCYQ+FCMT5VqQ4Y0+WIHRUzPTFJwrHwbNVLT0gadSvdV633b+?=
 =?us-ascii?Q?VobEDresnPDzoNqmhdg9oBe3QpM8gJaVJSbgeoOntNwWAqQGj5qQ9dOldOos?=
 =?us-ascii?Q?7rpWMTFJYLmEBHYSaHTnSey8Ss1T+G7uVtiyW6yByXZmQNXl99xUPfKk/U1F?=
 =?us-ascii?Q?Kb2kk20IknyComXGPwAbuMFtHmSCgFi3xdeD+MyHpbdgnmNfY+rfi8AriIcx?=
 =?us-ascii?Q?j53T3SuwHYd3jmJOoFTLhr5yfs/tNJiye1td84JDzTw43IYYOexUC9bgbx9i?=
 =?us-ascii?Q?CCmNvtHprE7PBxSQGf9MlqMJJn0ek9LOr96C3shd/Xq7j7oshnv2wUIDI33s?=
 =?us-ascii?Q?ROt9GTDUyXeWpO9KoJLLMwf3Ip5ArCYMRpTRcz4rYDB3/IpXiPqZoDktufR7?=
 =?us-ascii?Q?yXFKst7ZP4JIF+QDd3VyDB9J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d248de-c10e-417c-4b31-08d947c281a1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 18:58:17.5503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOE5d+AO9/zq+gG29Do1KXAXw513fCZTHXgTnP4uyRh9uTtlo47WVAm8nSyo35hPfoMAJsVmUka03rRucfPNAuquSmPkqZZc14nszpyQLHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2558
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10046 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150129
X-Proofpoint-ORIG-GUID: rxia0m1XUR9VeaSiGJS0GzHFfMKDYwmX
X-Proofpoint-GUID: rxia0m1XUR9VeaSiGJS0GzHFfMKDYwmX
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation of svm_vmrun() and test_run() sets the guest RIP to a
wrapper function which executes the guest code being used by tests. This is
not suitable for tests like testing the effect of guest EFLAGS.TF on VMRUN
because the trap handler will point to the second guest instruction to which
the test code does not have access.

Therefore, add a variant of svm_vmrun() that will set the guest RIP to the
actual guest code that tests want to test. This will be used by the next
patch in this series.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 14 ++++++++++++--
 x86/svm.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index f185ca0..50b6a15 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -227,9 +227,9 @@ struct svm_test *v2_test;
 
 u64 guest_stack[10000];
 
-int svm_vmrun(void)
+static int _svm_vmrun(u64 rip)
 {
-	vmcb->save.rip = (ulong)test_thunk;
+	vmcb->save.rip = (ulong)rip;
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 	regs.rdi = (ulong)v2_test;
 
@@ -244,6 +244,16 @@ int svm_vmrun(void)
 	return (vmcb->control.exit_code);
 }
 
+int svm_vmrun(void)
+{
+	return _svm_vmrun((u64)test_thunk);
+}
+
+int svm_vmrun_custom(u64 rip)
+{
+	return _svm_vmrun(rip);
+}
+
 extern u64 *vmrun_rip;
 
 static void test_run(struct svm_test *test)
diff --git a/x86/svm.h b/x86/svm.h
index 995b0f8..3753e2e 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -409,6 +409,7 @@ void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
 int svm_vmrun(void);
+int svm_vmrun_custom(u64 rip);
 void test_set_guest(test_guest_func func);
 
 extern struct vmcb *vmcb;
-- 
2.27.0

