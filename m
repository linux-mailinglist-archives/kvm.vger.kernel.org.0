Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB0C52FF64
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 22:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344488AbiEUUbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 16:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbiEUUbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 16:31:25 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709D32BE
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 13:31:23 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24L8FnNp030493;
        Sat, 21 May 2022 13:31:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=YsQbK54wLZFiJJr1Civ5ve9nBaNC1DfaSfWmV7WdPSA=;
 b=lFx47AZO6/uXKguZusYuYhhNBQ1YiG8EfvoEdyTk8+nEdkfw52bYmFUTCzqa5q3PkINf
 xHTebSNe2kFVbCC3LInEk/zU78w/SqT4nxspqCc5D6bzkWCfrWMunk7A4x1yrfaTuFmw
 7/p1oer9rHKKNw4nCbk00ly3BEylIS3YubgyaH3zzetCu7cxXPGP2C0MM+kaB8XXOEt2
 xFWiOVm/8weiM3jT4Vz+fWzGb9ADqkz+9+uuA268/wB3TFjoGXZGcUAM9cFoOywq7Z1t
 TEVbqsU58pmEwnTipHUY/xva23jTt/vQEFpZxMs5To8YeOfjcmZhbm+CKqTxgleenBBV jQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g6vdrgpd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 13:31:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM9vyG/riNPmHVi5jkDmMxnzMzN66Cr9FReTeFxTZdRKI40XJbKDd1ndPUfwu5TPw/tRg8E5MAoT/y8ZVFKpd94YpdJSJ49GClU9+xOCiDutocn2fCs1HbHMHVBEjcrF/UyK8n44Rm1q4EDaDoj/0jCSzJYwAGDMVM7UQPSKvtobTi9ggdH3J1EaQ5RXhr/P6DW7PrKaNV+kuXxmklt00GMul9rsfo5jF86HDzpuos0ZXoR8BKohammPz4xI52z8rCmBNB+PJqOV/aWWeOOTkPnmysyr6F+tOEYeXbiVo1v6IiajJn4oZKyprpw5GLh6jkVvfQPkszTktqGBbUpxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsQbK54wLZFiJJr1Civ5ve9nBaNC1DfaSfWmV7WdPSA=;
 b=RIQTSpJ9CB7dl8h+VCLLRKAZls7zGDshQaPS+pr2Ol5rvMJdayp7FON2KwDG+8My7ArHlY4gDnJUDLMmpSceIARvt6VB0NXz5ZvF7bAQEURKUM4EWlh0PqalfPkx0OolA9pVeBRhr0Vx/6wvi+Sp668m/pIsVTQYftLwIhA+UHiKnDDbwPs3zfdJ8aFAXzAnSzFig5JPXYZ69xsMkrt/QfXgo07Mq8t5VTt4enkRJsdh2SvLz5dGiYBXbMj7Ai1ZhnV6zVdg/6d1/Ej3xzc0rByoGsTgKOFMNdLHKkkBdS+uhJcBs+nOVu3/p+qFUUK6u0xGAY+7GmQNVz0c2cDHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 20:31:10 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5273.021; Sat, 21 May 2022
 20:31:10 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v4 3/4] KVM: s390x: Dirty quota-based throttling of vcpus
Date:   Sat, 21 May 2022 20:29:40 +0000
Message-Id: <20220521202937.184189-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6fa8ff8-bea6-475a-47f0-08da3b68d749
X-MS-TrafficTypeDiagnostic: SN6PR02MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB4319B2F020DDB3E72C16C85DB3D29@SN6PR02MB4319.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d74NFZICKevUmtLbkKIWkU1KBLSsn1ODVIwiAsQzIP2es9e7ewApE8WhjMq0kazGtEKVu9f6MvbCRJTrcwIVA6hgNXfhtAA3pXTlS1mysxoVMTLumpKQM2OANosGJqX6UKeFWqyVJjrAtDjjtRY6MJUZT/UBXAAKTTfvUIq8GMJwADVPN7zFnAbeMEb7vFMlRMQ3YPGqwuODfbhjQrvOyw3PG2Uf8NaPy1GcEey120iVZhpC0/5uHpEWiXuVJelr62xuf/1IsA+JSNTgCuw+bd/bgQK/UCRwSuJOjTxTcA/EgoTzNj8RXilOP+tWL6U3K7Oj0EbnFe2Gf1sv3qls/+VqGpeCwaG8FfZxJxrdDV/MmZ0rB4ZA+L57Rzyk0XeKyaG057JoD5kxucX/cXH//De5f3PGe/I8705aUCLK5t09L6L5OaYZDaF3ZNRcmY8R3uqHranFZItoh7hUipcYBGqXZib9RVWKObswI/o/XlKLgXzE5mAwJzTgnkq+0y8nG/JugjVm11cY3XT0cogZR9vHD5wMLMz+a4s0mMEBSqGvaEkq4xBe0yNlMcAmqnw56PgpM7qeC2SaOeBpsHGnOFntrvIk4v2mo4er4zEH7nwiDs0J1I2rqiI7zwMzyL3Ujopjqa8RQ8Wbbf90FdRc7EraL1dCk6h4IJrCfwBRswqlCjCWV79d8E3BH4UQ1kmHqjNLvAxGx8L/ZUS26vX15SIXL2zKxpHozyI6xdn0CEM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(52116002)(6666004)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(4744005)(508600001)(4326008)(6486002)(36756003)(86362001)(8676002)(6506007)(6512007)(316002)(54906003)(1076003)(83380400001)(107886003)(186003)(38100700002)(38350700002)(26005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uICS8DbKO6Z0SsaYwXniZTYBVW88yRcxv3FTe56Vr2WPQK1dGsv3HKiAVzz6?=
 =?us-ascii?Q?lZZ5NyuGxJlzjsc06YxcPZ739YBUyh21iIekhA9wADL41D3Vu7/J2cftnkrq?=
 =?us-ascii?Q?3L1Am+xzX9QNIU8BUH6cVK5kcb7+MfX2SzA28pAmLnoulE9XLYofnrPZAwBS?=
 =?us-ascii?Q?hGh4HxAuSq2t4+0D/tj9EI6u94k9jAvwz1UpLOVhhK4guw9nIygNbJhukIDu?=
 =?us-ascii?Q?4Su1CgGGpjX4IGr5ZCQyAHnTM/FWq2uELLVSTU07AQNmoyLKuda5PuSG9oHF?=
 =?us-ascii?Q?bn1RZWISOdqlmjJqmSzwzPwiQJ5TcQANgKmKaZ+SaExkxlEs9d4flWtqE7DL?=
 =?us-ascii?Q?lnyo0wz903HJRpIijOolGNs9MAYHwd/m9K0EKQ8MrFjZSA6+LN7dMQXERZFK?=
 =?us-ascii?Q?E9IKxP6mVMOUFMjxwDPdNtMnidsMNgZdKuIR6VRbmtbI+wYUzMg06bVOMyN5?=
 =?us-ascii?Q?lUitAs2z5w5Qs1UPvJA0ZYEaMfjYKsWeHR+36D7iMT3s0d9OaIyWHMcwjONs?=
 =?us-ascii?Q?KIvBJ7KZBK5sulwUy0xmfU1VngfInf/djz9Lf9mqvwlCX8oeGQa2ADdAIsVt?=
 =?us-ascii?Q?f1R/mGEsxeaGOmr/iDpNOt5/fyWCkpFNIyxWKbMVdMwPeCglONF0RIYhb+jI?=
 =?us-ascii?Q?w0tLFcoJFuwhcsMFez311mRb/9lU2H97RCSsnWXhTSNpfRyMxOVqbEjML+dc?=
 =?us-ascii?Q?ttAyu7x04nSgs17VxjBkg8x7vyO+FbQq+XXyMdwDVaqecH6HUvEJQrpWhndL?=
 =?us-ascii?Q?j6B3+B1F5RrNapNeQGce2BPes/C07514g+DKMFarQq13FMXH6pvX5tWQXvNC?=
 =?us-ascii?Q?ugOFdzArHcfYccM+yKTGIkgkQ4R1J8mVxbhoqGFsuJePy/pDFE9Z869hpUOP?=
 =?us-ascii?Q?ZyELl7kaPUT7KkPp/oPa1p1/f73Sy5gZfs+ci5xePyHwQ4wkTxho/A2m6K63?=
 =?us-ascii?Q?338xWQGAaWpAtLBbHRbvVWWZGD59sEPcaCIM4uxlKBI/Z+WnZWr+VTdIBVGy?=
 =?us-ascii?Q?FF8S/pSZTaIID/y0VkstF7pyaqLZ/2GjRC4zkYiqxHQq9CQw7iYkV63BkMZk?=
 =?us-ascii?Q?iWHHJBx9AtEX0rjh8q631mF/btOncERKQRNbZ7wX2Oy/Q6WcQLiJHLPqW6kO?=
 =?us-ascii?Q?7XaqarZtA2VB/KKHGM8K2s/k1eLesVCkgBRVSpEWlReo1XyJ6LG64aBgfu/k?=
 =?us-ascii?Q?Cpj+37JX3gFS0Zv0NY1K+98K48T8ADuVO5BsxOPl1sNapyOngDv36cTGW0n1?=
 =?us-ascii?Q?Zccy+QhGRRp8r3moTc9ZQjqRvCzDTOpeaw9Pmd4SncMyKIDxAAtssmNle578?=
 =?us-ascii?Q?FDHPqblaLgSHFK/LAQlPIKNRxkDkh3k4ZJ2reSIpxzdt8GC6fw1eVsdXmKZq?=
 =?us-ascii?Q?OS5f++UBgRZjOybfgjbG0A8em8IKyA7CjY7GUGN3yCv1sICQulafid/zONXY?=
 =?us-ascii?Q?pGxp7ASwkNMMm3JZD+I6hFMToGLsiTyZwXokM8Y+k/9zA9y1lndiWvpnsiow?=
 =?us-ascii?Q?BBYwRzR+yCKfAb4CxMLvMpO7ogU3WU3XQv9PP2F31DkM3rIN56htILoAuItk?=
 =?us-ascii?Q?ilALK4CQW0aO91az0DpO7E8rGtn1ctdSiqaIpf0bxvwanisRbIXcwUipVX2x?=
 =?us-ascii?Q?0nZ1V3Z1NJYuincBlg/wT/EC4q74cjWvR0BpD7jpTlA6s8gpZMUJCBvbM654?=
 =?us-ascii?Q?Ini6+95/h4Nlrq8ycCYy8MJzdvKOo7K0g14HgEKsaiA+z9l70dn0mPX7BBgn?=
 =?us-ascii?Q?Q0TI92Sn/I0JmelaIdxgMDtJ9Rwiu3Y=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fa8ff8-bea6-475a-47f0-08da3b68d749
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 20:31:10.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +izceogRmafFS/OdThoRAkht5DUkWXRmXbCzxzSMlj0DQVQ6Vps21JSEgXKz6P6KESVpayz80+tCLRMZHbL+1PBk9sKdUyo1UMBtkhPlqkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
X-Proofpoint-ORIG-GUID: RvCFuyj2QsehRjmGUiWNyFMeyruvz8-s
X-Proofpoint-GUID: RvCFuyj2QsehRjmGUiWNyFMeyruvz8-s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-21_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2296b1ff1e02..9cc0e0583ef4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3994,6 +3994,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
 static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	int rc, cpuflags;
+	rc = kvm_vcpu_check_dirty_quota(vcpu);
+	if (!rc)
+		return -EREMOTE;
 
 	/*
 	 * On s390 notifications for arriving pages will be delivered directly
-- 
2.22.3

