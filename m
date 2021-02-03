Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4BD30D15D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhBCCTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:19:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55652 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhBCCTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:19:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132Dn6i012542;
        Wed, 3 Feb 2021 02:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ub+PU1DM2ZArPWFeODq7rhhOJtgYTCW5B+6fxPA4Lro=;
 b=cjOgk/ZGKdMdP6627D7ss6M5XDs8tv243B6yV0Y9d5aJ4s5JFVaYcqxee2ATjlCbmRMw
 PlWKm66oJIYmhH0S+A+9wxe9cyuIwceipq1vlAZn8kBCfqZmFabQXsckyzP2poJRByr0
 F7mLxt5LezYClZohDTaArvFnprQOD7NRfyliqD6r3ZXxwTkhtpcYdtSO3ltaHsLBD4Tm
 xtAxQFDh+WyYGmYwMlJj7BUb9Fdb70LzppHWn20R3KPcLgodK/1lc1ZQyxFbnhHgoaNl
 rs5KaL9+Q7s4beTk9Gh5crrdHtAoOReBtwIs2B9fTAjCJS2cAM9QIX9aiVWfElAZD7Cp Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyawwxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:18:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132FWDo092784;
        Wed, 3 Feb 2021 02:16:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3030.oracle.com with ESMTP id 36dh1q06ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyhApyz1CRHv4m6D5EhucfETnUr2ahHh0FBQwDv2+AzztQufwvWS1vjtP4OR0gLlU1XF34UsrgqOrFRne2L7Uh5+Cf7upKjBZcm7NsW6bOReygMCF4lV4cPBAC9S1RoJI69KdbfOjNVF8hsjzjJuJBDBnbvhCW3w1xY7EY463drMhWiyJIi8jgVYrRVnCf5pQLg8jDi5ie6BEwwCDL8IxQGvZHJ7CHYsX86r6bH9gyRTibiYqhheCGXwJrqjdd1divmQk+WneW1mqLoFPBhGi0RpDu+Ebik8y1ar4YLtw6S27heFDRl1tD5f1pvpn03pvm9QJSxNtlUBGFjOSJPzfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub+PU1DM2ZArPWFeODq7rhhOJtgYTCW5B+6fxPA4Lro=;
 b=FF7ViBcrWGGy/d4NVeTlcTO3/l3ONhk5GOc0g30bD7O+D4SHNQXA0JiZ5BZ7zFN9WrDaQ7cGuk0UAiMwYyHSQG2Kf8MoIJKwJjFq7Efaw+0jbaEcKELHZVPWj5HD79CL/UHXFzaEOMfKWUqExGwbkDk2FXqfJD0wXjo16pWeQ0GmQam4nrXKXXLKndaiW3B1uOzTRyVm9hFwV3aPh2My4DG+/T6vRCSF7eHZwZx+QI7/SKlM4RnA6Onty646+i8LlU3rMSZh0YJhdwnct1pJtvIHHD957ssNt0+XwdweTCtIHQLhRBtobMV3LPNE5WUfQ92kjrWWJL64PBhcTMCFmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub+PU1DM2ZArPWFeODq7rhhOJtgYTCW5B+6fxPA4Lro=;
 b=yBRl5TmdiUIo054R2uru/4e/f1TQ80YN2s1KRrEYQLnCryHpPwQPtylCjKYZRvFcCeaySWun8lIYYpcyEhQSj72phbLPdsmcG/YMn8rF4+qwkUVUffcFjyNTV8qJsAAkVQxeLho34Mrz00M42RbjTCJ6w94YofDS2gUNivvCTSE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 02:16:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 02:16:45 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/3] nSVM: Test host RFLAGS.TF on VMRUN
Date:   Tue,  2 Feb 2021 20:28:39 -0500
Message-Id: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:a03:333::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR03CA0096.namprd03.prod.outlook.com (2603:10b6:a03:333::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 02:16:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50976dc3-3d20-4999-5738-08d8c7e9c0ce
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB479303C02D7DD3DDB14AF5D881B49@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Twal9vU4em3M60kholqB4uJUb2UaedhuB+wlN+38iAHPFCwKHZTXCBZA1ywBxJAuS89x1UD3xadvXsdgSimKqQyyZjT2UfI1aPwclvAqr4tLOHkUh92xRZ9fR9GBvfUfROC+AExx9FePpmgyzqJglKBBJG9mLwvrU3Veg8Z/LicLAGOIuA3OJPqGlbg08rGDzerJv6Ggi3uHdFhefyM/PJTtq4fOk5hv758BEiRqXAka2bbYpMPGTSe00Wly38SY7rt5zyAk21mc5vbbJxurKvsJTkiSjHNaJFzC8m7HgFfBKPE1BMqNh+UNqWBRXvhZU3x4SojyO9Rd43UkvMFFpetAVm4szPWL/wUsfAsW2KpQmzkQySMd4Zhvn+vdVxxhlPdr5MsFV9zUJrIVVIH939o2AyDnjR7eSPig/cVplcZ4wfMVKWjZsMBxbWLkFE7Ij3LF8VLiIbnj90iKIoLOnETVa+Af2Vjm1fuznC+LC7cig9xsrVm1sEsVXCjJGwNFJe09SPu8t4FR2jeqC/lHLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(316002)(6666004)(36756003)(8676002)(66946007)(16526019)(66476007)(6486002)(7696005)(83380400001)(4326008)(6916009)(2906002)(86362001)(5660300002)(956004)(186003)(1076003)(44832011)(52116002)(8936002)(26005)(478600001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W9LERX7u0JgO2bsQHR3ERU4BQVkWvDXWfnbePd1gqmdekxix/tUFfGkEklJY?=
 =?us-ascii?Q?S5wmY4RmP8VRXfziqvFQki6lgSaX7/6t3mrfDFFfLIUXBdUQ4WvAFvhE2WOY?=
 =?us-ascii?Q?GW7i1PdCgO9E+2VVJz8Y2KTX+er6gP2+wkih8+Xs+M3PuRDI/BQnIbpD6DAK?=
 =?us-ascii?Q?3zE7U8R6PFx7uWEr/1gppk2MMtUFnLYFzBiRsZIaAbuP0pYzoqcsTtvTTtcK?=
 =?us-ascii?Q?ZKITQXQRK1w7JHpKrLfO2R2UKmXUueMGzkMFxTlyj+4cFXwmEtOHOFBO4zLO?=
 =?us-ascii?Q?vBWLiVQDZHUTk7AqAz8QtIYsemX5orSyQHV8Nv4ZDRpwfkYSUBWN2yiree/Y?=
 =?us-ascii?Q?8O4VjbWI5/GZHKpfWhele6FlMQ0pGf6hKzY4zH0kgTa7WCSY34pWN+5pLcEj?=
 =?us-ascii?Q?IZkw/RWhHM/Njs82LzuzLepRNIybIzTEiXYDKRq2e6Jrot1wMf9oV3G73Gqy?=
 =?us-ascii?Q?4YI/A0RS6fU4lCJKgowYGo5FweP9j8C3jjWkQ+9ggRN3X9A/d26DOEEHhO8W?=
 =?us-ascii?Q?IMP21DT37D0YX9JSYGqomzQMqySKrIUGL9M2MvQIxcUa+9xZqQmM3AhT6otU?=
 =?us-ascii?Q?D6rU4h26J8a6vTDbCLsLTm0vokrXggKcAHUTOK/uFpIZnE+xjEARaScdqhlL?=
 =?us-ascii?Q?ZstccMj8qNMB+bTAGQ2tAloEFTtyQdRpjayFATQ39ZLDwz0s77MPJ64zg1L/?=
 =?us-ascii?Q?O/cVNOal+IRYPcYoYfVH0cOt/lBs8riC8d/+fDvvJ7Q3o2C8WK2OmMdlbZLX?=
 =?us-ascii?Q?QbBbdzMK3rxTJqK7xuZ+FoQINm7spM7SXdUMj2p4ngnu5wPnxRuMNztbwH+O?=
 =?us-ascii?Q?qHEIIxmSnKrt/s2pmkXlfb9Ti6RQ533LaoTCTf7nekruSkl2sfkohvOVNNRK?=
 =?us-ascii?Q?zCQdbdKDUZsTzCI3hJU/21NMUHgqUswp4ubMJdBc5cjdCTXNDB3s72AfavLc?=
 =?us-ascii?Q?hyIe+8QvKTqoQYbecdkStSOfic67QNfqs0r+0TKOClboRkjnR8n4W2ACwiP5?=
 =?us-ascii?Q?UVIEBaa2E2gL2G7nT0HTdDtxusdHkSbqgnB1N+MUtZV+B5Njq8TLngs/euqr?=
 =?us-ascii?Q?pXLw17Wx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50976dc3-3d20-4999-5738-08d8c7e9c0ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:16:45.1319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 111vr6YQN1keKo0h30jGZPWZit8L/XAcIkTolmoRT/EGpMjsVECQV0ziU3GLeb9veKLVNmV5jiavxUEL5qBa+FqFzuH98R13Wz/F4VB8F1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=704 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=884
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS" in AMD APM vol 2,

    "From the host point of view, VMRUN acts like a single instruction,
     even though an arbitrary number of guest instructions may execute
     before a #VMEXIT effectively completes the VMRUN. As a single
     host instruction, VMRUN interacts with EFLAGS.TF like ordinary
     instructions. EFLAGS.TF causes a #DB trap after the VMRUN completes
     on the host side (i.e., after the #VMEXIT from the guest)."

Patch# 1 replaces a hard-coded value with a #define.
Patch# 2 modifies the assembly in svm_vmrun() so that a Single-Step breakpoint
can placed right before the VMRUN instruction. It also adds helper functions
for setting/un-setting that breakpoint.
Patch# 3 adds a test for the RFLAGS.TF on VMRUN.

[PATCH 1/3] KVM: SVM: Replace hard-coded value with #define
[PATCH 2/3] nVMX: Add helper functions to set/unset host RFLAGS.TF on
[PATCH 3/3] nSVM: Test effect of host RFLAGS.TF on VMRUN

 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Krish Sadhukhan (1):
      KVM: SVM: Replace hard-coded value with #define

 x86/svm.c       | 24 +++++++++++++--
 x86/svm.h       |  3 ++
 x86/svm_tests.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 118 insertions(+), 3 deletions(-)

Krish Sadhukhan (2):
      nVMX: Add helper functions to set/unset host RFLAGS.TF on the VMRUN instruction
      nSVM: Test effect of host RFLAGS.TF on VMRUN

