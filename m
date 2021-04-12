Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3EB35D364
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbhDLWpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51658 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343843AbhDLWpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdott178396;
        Mon, 12 Apr 2021 22:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Hj91B3rP8y20bx09vOpC6s55LGxBookWTFt4g9Xgeqk=;
 b=j/U9GbJQM9MZxfQQojD+En0v8v9yXGrAGOldfw9XdndcgoLbeeCAC5E3qHBaaH/IMY0y
 srpLPAMpmm90NF49XQscxfR7iVyr0DFRO7IXknsjJok7WlnsfGqReF+EwkH6idnteffn
 O34JWXONccsCJO07DXheojffv0gGLF/i5nY0Kzdu76PeETbl8PEZfAJqFNyqJ6Q+RILG
 J5MrIP2nuW2RaTAfT2Zicy/4P3gnrNnuvN2bldqZbAd5Y+v5QWnyU+6MVPJHTmShC0xs
 DmF+UhIB0sYJlldmahuir6lBwjFvUkRwuRErGoV66g2lL+B6NU+S+KEldS94hfUa/L9X Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnd9nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMfSgK009379;
        Mon, 12 Apr 2021 22:45:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 37unsrhcj2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsKWZkjhZuqSAj5mR5/vpm7qLPv7XBmp4HBGNHKp7a94k1Io/zDv0RsqSwFB1qvnwad5FAkROL2eHPpU/3VLIwaJTA8Tqbee+LtmqHbG3+jVa6p1FgSceuD0RTXC9BCvKYoqjdCzIhEEmk0y/oSXPAyg7bSH9pt3ybC1yVLr/VMjk3bOD9zYxIn86acEESPfFZlCJGCRB5m0wE5lmjp2s2YuQas8DPwctbnp3qnp3voX1hmKvXRTfVcQsXyg61SMNEeNwsYgPgmsWGtdV4XZ/Rw5BaD5z7EVlTWlPNBui/Igqv/aMEIthhnD3k/kqxWvND7dwiIjV2qQm4miWyKvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj91B3rP8y20bx09vOpC6s55LGxBookWTFt4g9Xgeqk=;
 b=LOwl6TkTnlRs1PHeyNoPjI4hUP3l66uSUo6WCzaeITYFVud1zTUDLR7Qk1T6QDM9yrJQUGfgnvAjJ777tM3DrsDfZoFyq/pbpQdOdhTOndRaCWdHnTiBZOWUXiq6g99YO2hF2vHWWx8z9cuG5/UUj7S2mSVqhe9ZuB2I5Ov9BNDh7QHvKWVz0HybkKNpvtcBkNnf8btK+JCKtvUI2XDDDCR0Tr/ounWG/MK89yC46Qfs54vI9v7DcJ3TxP8+2hcqwRwnZ2DoSVNntrXzWgPuC5ytvzVEiWzuNDH8GAsVklbkpBwWIs4hmVC+QkPbnSLnBP8V+VcrWgfRDriit463bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj91B3rP8y20bx09vOpC6s55LGxBookWTFt4g9Xgeqk=;
 b=eK5jmsHVsuf1QcOI4T78sMfKCoMLCqjkpR6BsqFdeP4vB6KG9WxXiKGHQ+w0wc/Cdr9mrsq6DJgov8/x5ef/mTz42dBOInTJA8p7fH245/GCVxPi0fAPOiBs1lyOVKsBdXHnGAmFQSM2U4riQukLP3f7DAVC0azhOomZBCc2rts=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:06 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:06 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 7/7 v7] nSVM: Test addresses of MSR and IO permissions maps
Date:   Mon, 12 Apr 2021 17:56:11 -0400
Message-Id: <20210412215611.110095-8-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f502784d-af41-4bdd-5d4f-08d8fe049e4c
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308886367F36287DD361225581709@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3Yd7YHaCKoDDWUn4yj9foaxUsBzBohjU29Df4h1H5+sOdZeFt53a/EBJ8jh15edwU/sQukaWdUH62whJutPGIGn/khKDF4E1rCjvOTIhvDVY16XnNthJBRtuE0mwIIg9JThQ6ojZnopKjJGIuJefhCULKy4/4ZmBzXJHM0SkZnaLuDpTsmafr8ljmHx5MiYUAJ/NBLVkmTCVZSEntdnzCP557Z4sqvoEX8EVnBf/shlM4AeKKRA2gtWjouBsJgn+z2u8ZrXuxCrjlAwnvqyQcwcNG6cLEMR+p2x3PX/L03RExvPQdRhe2hoWFVfa7DLwlqhRmkUYIzkLNjDeMe9DMSSF0uVlUVLjF0NfoZxXSnb/Tqg+SlxCg6BCKfLRONV27CPiXVaFJS+mZN7ZMFSKBNPUku5NrQlOQpGnzb0MQCjzTaEZivf1QGN6ifWlsJ3xhWGNSO68rqk6FtyAWU6DBNYphYWKouqLM/xUtnFWx7suXnL1V8+eY3JUgWOkhDpoCYlxaMwOO3u4Pq9uqYhnMwPb63gqr1buG1cBCadB1KwS09vVbx/yllM02Kdp1pYintraIy5YyuP1J/21qeDh83SPdn4Al0OJcZldsIhBSxm5BD5y25pCBGvKtYSvWB6a9amD2Wx+6cwY31Nyg5cNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(83380400001)(86362001)(2906002)(956004)(316002)(1076003)(6666004)(2616005)(478600001)(4326008)(8676002)(7696005)(36756003)(6486002)(52116002)(26005)(5660300002)(186003)(16526019)(44832011)(66946007)(66556008)(38100700002)(6916009)(38350700002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0xy30FNePtMUT0Up109CPN97ts0NvP3xWMJKPE0mGQzVVZrwiL/PX48W5Wh/?=
 =?us-ascii?Q?ryd7QIAsqfoD8U7XR5233GuEw+HcJuSgZ6vQdqtpTQsqxER5Fa/dWFAtgyJo?=
 =?us-ascii?Q?7e0oQBfY+MyhmrjadzLe7NODjdX4S9oRQqe+YKha6HZoankEiaNOk0Ee+s1C?=
 =?us-ascii?Q?Cf8Ujpr7GarlIsdcjK9Bcj04Ay2CynnW/Wyl2b/Koj0qk+0t6r9GHpDRLlpW?=
 =?us-ascii?Q?Zc5e3fkONuBKu+mLFW4RD3+0nHNXH0bEDHpv4zVRNVCJ+0Hzu8cltcJe3xq7?=
 =?us-ascii?Q?mwUP8fiBjA3DPIz3AXdlOWWpYdsILFe5LYViLSYEU+Ycy4SP21HdPaNPJzlf?=
 =?us-ascii?Q?kkdo8o24nigjt+Biik4esxJoshRdGWMbp3srGrgXtcER6dBVMybWUfqP1UWg?=
 =?us-ascii?Q?OZQpzNxEKtWGKx028q5E0gA+SqpRpjnnmtXYn7wAyY24R4Ekeq70sn7geJPU?=
 =?us-ascii?Q?pYn4cxTIvKCBGuc9wju4hdh6DM5Od4sc+KsGv8JjSASNt8cyTy37UBmmEkSD?=
 =?us-ascii?Q?IabG3xdgRkHv9u3waXNo+7AXy4qUYgzJTTQF/JTAPoUR+2bnLazaWQv8HE6p?=
 =?us-ascii?Q?KfMhZSdvXIdE/rNH7S0YPixMHatbrB+x0dsF3IZAeTsHp/i1vwDqtTysf4JB?=
 =?us-ascii?Q?m4mPi9Jrnqz0TkDSRb7KrO2Q4lbWN9V4c4hsb/Tu4sLuyqRJF6pQUzJbLL9x?=
 =?us-ascii?Q?3H2jrO0ufYdNP7wknKaO9811NPVY2nrPJ65L1nRikYeFpdQa6d2vpHA1SYpm?=
 =?us-ascii?Q?SuKhzbA493b9tjIBYHtPkjYSJrDrOtGk+KRSk6t/z02wB6XTYW3Ktso9Fu2F?=
 =?us-ascii?Q?rauGPZ6bCrlH/snul3UkR7P1o0ecsz33xD8qhcs52J1BQKqcFMkmQhCErTr7?=
 =?us-ascii?Q?VWSQLttLZYZHqfO8QnnpitdjZqo1ES2lSe5VhkhwIk16tblutOIgMTS+HA60?=
 =?us-ascii?Q?B+TtBvSnN65qxS8WtYkqjveOfMvPyTlvT/OsMp2DraxtPNcyjHe+9hqE7DZA?=
 =?us-ascii?Q?DFUJlzMkm5b+nDrbGI5muPx0hdSYtm/36emAKGd8j3vcZVysXe0JpagcHsUQ?=
 =?us-ascii?Q?+DnkuHwrLxUbqD2o0inUq07LuB0F59vpKBjr/tmnklCDdZ31+3IVS9y8710p?=
 =?us-ascii?Q?05OKuiAbVdwzsqDybxG4Ht3KzqGYwP6ZhX1kaxY9deYxYL62/LJriMQwLd+D?=
 =?us-ascii?Q?9o9Fzl78HXJpRAPHa4RWuG2jJSRreZ7G+XssxuYupbwTkW7OUgex61uVjIvO?=
 =?us-ascii?Q?EBsoFFgw3+venRQA7KRA8VRN0R8VsJ4wRev1H7y3PHr+5Q1hX6uqmwYDU2kW?=
 =?us-ascii?Q?BrvOaHYPWQEoKcghPdmq3/Jd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f502784d-af41-4bdd-5d4f-08d8fe049e4c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:06.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSiyCKDpql5Jzh5rLhUhExrakdK71MPPXX59ierrrzSPG6gv0U/nk/uAmfyDcbrqZK/gfePA43M5mcgJGuQzO1ttlHLKli2CRL+WRaq5Luc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-ORIG-GUID: 2SeKjnWVSMyXmIW0jL4W6SIp6zyvf9O9
X-Proofpoint-GUID: 2SeKjnWVSMyXmIW0jL4W6SIp6zyvf9O9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address.
     The VMRUN instruction ignores the lower 12 bits of the address
     specified in the VMCB."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..15be8f5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,15 +2304,91 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+#define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
+			consistency_fail, msg) {			\
+	u32 exit_code_hi;						\
+	vmcb->control.intercept = saved_intercept | 1ULL << type;	\
+	if (type == INTERCEPT_MSR_PROT)					\
+		vmcb->control.msrpm_base_pa = addr;			\
+	else								\
+		vmcb->control.iopm_base_pa = addr;			\
+	exit_code_hi = consistency_fail	? SVM_CONSISTENCY_ERR : 0;	\
+	report(svm_vmrun() == exit_code &&				\
+	    vmcb->control.exit_code_hi == exit_code_hi,			\
+	    "Test %s address: %lx %x", msg, addr, vmcb->control.exit_code_hi);\
+}
+
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * The VMRUN instruction ignores the lower 12 bits of the address specified
+ * in the VMCB.
+ *
+ * MSRPM spans 2 contiguous 4KB pages while IOPM spans 2 contiguous 4KB
+ * pages + 1 byte.
+ *
+ * [APM vol 2]
+ *
+ * Note: Unallocated MSRPM addresses conforming to consistency checks, generate
+ * #NPF.
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 saved_intercept = vmcb->control.intercept;
+	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
+	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
+
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_ERR, false,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR, false,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
+			true, "MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
+			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR, true,
+			"MSRPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
+			SVM_EXIT_VMMCALL, false, "MSRPM");
+	addr |= (1ull << 12) - 1;
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
+			SVM_EXIT_VMMCALL, false, "MSRPM");
+
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			false, "IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
+			false, "IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - 3 * PAGE_SIZE + 1, SVM_EXIT_ERR,
+			true, "IOPM");
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
+			addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR, true,
+			"IOPM");
+	addr = virt_to_phys(io_bitmap) & (~((1ull << 11) - 1));
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
+			SVM_EXIT_VMMCALL, false, "IOPM");
+	addr |= (1ull << 12) - 1;
+	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
+			SVM_EXIT_VMMCALL, false, "IOPM");
+
+	vmcb->control.intercept = saved_intercept;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
-
 	test_efer();
 	test_cr0();
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 
-- 
2.27.0

