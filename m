Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1192B3480C5
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhCXSjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbhCXSiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIO2YQ185544;
        Wed, 24 Mar 2021 18:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=InJGGPe9Kvj8qXOwTe7kukGFSVDP3QHi59gv0PQ8JME=;
 b=O3C6DBfuGh3E+tCIoKbfhngt1yciscrxmFq/AXcMKxRw8ku2uQsLSYy6rXeBjbesTEsP
 VoitazO0XWErae2qImg2aHYYoGG25dtQP4pjOTH3Mq9GjykptF802FBc5Pz/NDUdH/RY
 3L6BQEZrfJwxHv+UsE18n576qNEu2rmAt0AreOCQUa1P+mn8Jode1y5KzGnvK1h6LZAI
 epR5lYJiRi2rpLRDZkIBAIWnqJOxqq6Isx/UdWUuu9AAH+xF62+dlwtGmdYhwEoITBtL
 7Fd+u/CtLgN0bbyqvkiRkozmMONo4JzbkbfYFhFbwMo5DF+JN3STJc8DMbt4SfJpl09g 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pn3sfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIQFPZ167563;
        Wed, 24 Mar 2021 18:38:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by userp3020.oracle.com with ESMTP id 37dtttpj74-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ml9JabzP6Kt8JaI9fh+FT5YNxz9AIVBnNMNggRkYDqRuPi/1NkATPYuxS8uk7oBpAKxhLIQZPqhoWiFt0ChHBq/t3w68ns4/ZEhUrKSYTNPbISMatF7M3QdrxDHC97wd005OIWoELUTtXx+XCFkkwH0x6OjR8oQoyHQ1aGAlKSv25bmUqk/joqJJFgyxHduQx3QjBdgbl/gZBoWb6L5Oa40y997IynkDkIlctImzdwcmwwfpALjymur+ATkvfjwxdG2gX4ADS6yqAaLHB2lDvpKUvUbD41e/3dHTZk+q7Rpqn7bgwn++pV1YEklJG3ctaMvZJe+UBC1UouWv5KH2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InJGGPe9Kvj8qXOwTe7kukGFSVDP3QHi59gv0PQ8JME=;
 b=h6J9QF5CZRMd/sROofp/FGkprNdLLrsgQTx67j13JNK2TwFH6ZmiTyWfR/XWw+rYnVxlvs/ORZbkxKIE4x/XK/5keuZcmHVqrZuMQ+dV/7bXGHTG2X+S4CgqyN7NCHqTHv/0FwMikasUADCwReAta6bDiA9nif7rlrblaaIVrzHIsHjKl8DGiHyu50Ur8wdU5Q4K4bU1eKO08MEu1B3Ni/pf8ZUv1+6Ana4Ei3VE9r20hh3t5Up4h9OLnEDoDhXJOhkZXQSh+IUj6Ptc6bmSb3bUmgi+WIDJFYeXxN24TUPmAW5xc07zbEPza1T+l+EPaaJIvdBXAE5fTP5vfIJIzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InJGGPe9Kvj8qXOwTe7kukGFSVDP3QHi59gv0PQ8JME=;
 b=Pz9CEOwyb/4RwMAz7fzhysGcV7l/o6D6XRlWrkDkcz6dcV80wOXNW5tmBOueXoQR22VJ3Iu+mjTeaSDPoyhFbsiiupYnWqduojjycgI5nQMnM7A/NvGoUvs5YAHo5ufMTudjsFv8yWNdMdGfKiJwuSP4BNlXRHm+Dl19AzRk9ik=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 18:38:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:45 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/5 v4] nSVM: Test addresses of MSR and IO permissions maps
Date:   Wed, 24 Mar 2021 13:50:05 -0400
Message-Id: <20210324175006.75054-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15d212c8-6404-452b-1c65-08d8eef40e5a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442577CBED365C94709C3EFB81639@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cRCRzuIatbNaFssOOPr1TiwQ78tB3UXb5gi6s7kRE/kYbIm0adOHF5jYYTcl+jEWOV21nRjJtHy82UDxzG7daUheHK53+Ox4ZJaLRWbTTig12zh9eYQ48TivMfLW9p0DaEWvOdcjWC0E6nZ7QCflOtdFbG3pjgLxCHXSCrUnM/ST41qB5MZqNKsRR+NPatzzLdYz3oPbmILpyTBja/BgdR/TNihw1GchTbQ9tLb/ScWSett6VM8sSuOXKbwUgtQlCp9hj4Q94AFCHEYgTXm4dIlsyG3bVObD43HxSDDQb1QHJq3iInI1E6tM+BWmF/i445vF5bDzJv38EKsqfMHZPzzcObd7m2fbNetjr1tovF12e9JZA7nQ0SHGDMrnfgiCfYasO+ehey0JIaMI8XKcMb33vSuB+Va3QcVBCcGdsrAzmDEfGSXcWXemHCKhK2a+he1Cl4zDkJzcP0AN6bgx1fYlzHo+eh5OoZJZ9b+JuQhlFmN/GlFpZwRejxDy78rgjU612MFWs8KIh39J0qY9ixjh2/zuc/QEFZBO8mrVnxuuktRRIyIMDY+TPDKcSpMJ2JgGD0jq824RfSS9haLwUR8IRv6xTNIbeNVh8FReTM6Eaxh4HpB7zQEjNqn3OvqTaR/kuS/stvkK2iYndAXqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(38100700001)(52116002)(8936002)(7696005)(6666004)(36756003)(1076003)(5660300002)(6486002)(66946007)(66476007)(8676002)(66556008)(6916009)(2906002)(86362001)(26005)(956004)(186003)(478600001)(44832011)(16526019)(4326008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CgmJmYNu8rnhjyAM2NqFn3oaj0AR4PRD37iH/6CbYXelSZijY5v03fUAC9ND?=
 =?us-ascii?Q?LbXzc+5BNDoj8iB2R3EQMJlZEzWdc5g50XhaARnT15Z1tVO1krDFIrZS3sR7?=
 =?us-ascii?Q?3h94pqaazX/DmyeLrnWSrCmbSH/vxbMxefy1s1++StrqFcNs9FtcRCUc1SNZ?=
 =?us-ascii?Q?niOlaP4EvzSIWWd88Vp1eZIqBcPl07IjJymbvyhXyl0CmOdD1OJ+grMWi2XQ?=
 =?us-ascii?Q?0dGujIMV/15SMYo8x13d1EjVdlJkCh6TiLonkPP8E3nOJFpfXLmTB2NqA1/A?=
 =?us-ascii?Q?K/kBAMln9cphc/dtPD+RHUq28/OHCYKtqQiml3QooZSBlnmv+R6Cfwia7BSI?=
 =?us-ascii?Q?Vy3TgIciODFup2cyKfm9E5T7unCdPx7Ba/8UoSOKSn9w6AxRDq50jMWM/rgc?=
 =?us-ascii?Q?1wD5WX690+Mu36ZTzTg8gmHMDReEZELKtPz3ZmpgR6uusdFilCLUZkHsLRZ1?=
 =?us-ascii?Q?ocZoNZSblM3DDXStrAVaC/vhfbgT5DZOvY/AfGXQV/WSObGgWuIf9v96Riwt?=
 =?us-ascii?Q?rMnR19quYrpoDmf0J6t42d4S9/55blwz1JpB+7skonNpJpvPOzFFAVvCK4Wq?=
 =?us-ascii?Q?VY8YRykd5tUJTHmhg8rXiiJKLf/TBNDkRkBxRgEPgv+r4cd938mV9LTtFqTQ?=
 =?us-ascii?Q?ztipSYIABPOUYdCasJcA8PyNc7zzE2oIwXRVcitNLUXfcA+cO3QUmHLm2dOH?=
 =?us-ascii?Q?8t2p1NANrpAnwCJyxnnMWFjphyXV3nAkS49FzoFUrdSWtd/tk6eTOfa2yPJO?=
 =?us-ascii?Q?z7fSxH+Ed0JcGBv+9DfEr/vwHzsn/nO9X6/GLHtejJh82Qaz2UsvDLWuQZHZ?=
 =?us-ascii?Q?B6I1GkId9adLYnfoizmBsU5dHlO5mLIADlyH/4Xb8LShTVWHSiRm0ikh02wh?=
 =?us-ascii?Q?nerd0edKNewT3yEmfMHTLXNDyS+ZePGguputC+CCwW9cSzyYRHg24JqXeKgY?=
 =?us-ascii?Q?nbTcBwGbFXC4i8LudMQ26qlzNNPfp4G1nYL3hcp/9GZJGQejJ5wuaFhFU7ju?=
 =?us-ascii?Q?b1KPvBfcQcmxBlhLSWYDT2tsRrr09Rhb3neTevqP6UwBzPLMl7+raQtAYmpD?=
 =?us-ascii?Q?+WSgvfcvXukadp5wjbtolwRHlwv2T75TovN4VlWhmIv4LwTIADHCbRar7VEw?=
 =?us-ascii?Q?JkSfl1H2txIPFWYJL42MKapvNSjbSBa8TWvH3T63iuHkC5njJPz8D3mcQ8Wp?=
 =?us-ascii?Q?OdVoJZrZWhJHh5KM5zVf31pDSkczzXvk0dgsBIIq4czD2fPE/nmvRHfYZx4j?=
 =?us-ascii?Q?WH6imo81mNBVcTAAJyTfj6h9U5I96ijCLzpVtNB/jxt664rP8lUESuzDaNEF?=
 =?us-ascii?Q?xzb+d9pqo801ElmjTAu/TAhN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d212c8-6404-452b-1c65-08d8eef40e5a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:45.5341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bE55O/5en8sZBgLeEwG9YBhGRydqaPmVUQbekR1aHIMs1HsiGgfQMovWYHLqSkqVRhlu8caHGOXp3hiq5DvRj4iT3YjKX2sgLgtb99+92sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..70442d2 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,6 +2304,33 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * [ APM vol 2]
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 addr_spill_beyond_ram =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - 4096);
+
+	/* MSR bitmap address */
+	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
+	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
+	    addr_spill_beyond_ram);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+
+	/* MSR bitmap address */
+	vmcb->control.intercept |= 1ULL << INTERCEPT_IOIO_PROT;
+	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
+	    addr_spill_beyond_ram);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_IOIO_PROT);
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2313,6 +2340,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 
-- 
2.27.0

