Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C33CEE49
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359085AbhGSUdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:33:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52570 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383541AbhGSR4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 13:56:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JIV9d4018174;
        Mon, 19 Jul 2021 18:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fN0UqnjgPYbUjRjHzs4vRpA81OuMceAe4fI1PQHwpi4=;
 b=ElFRaw2TyAGwWSGpsEQGX3tuRv3+VHZVGVGSOp5y4UjvB8CHPipzbiRF0XoO2rGwYlvR
 xzchlNnlKfJpERSus8iczsHPJkUiXXOlEUtfG84cmyLHnCmNpyfQoZjX2aAfHZfGs+2Y
 NC/YZ5RMRR1DH4zmnpa46mIe9f0qW94ONO2MvdS85vD0HVGSxaj6bLdWgyEX6+zs26Da
 CmjWzWyseVQRSozH2JTvC8T6H4I0CqHyyNDvuduuziKc0qY3BhdMmefs29IIDvpd37mI
 qErBxzChk75g8BldNKjzPxt+vXL51xP5HB3yTwCxC9QjkUhLK0vym4fovFsv6znpOLzU KA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=fN0UqnjgPYbUjRjHzs4vRpA81OuMceAe4fI1PQHwpi4=;
 b=ymd0LCSWf2yqov1s1FYQilMfv94JYkZtQK7VwIDQwQiFfxHw7DM070vFK+BbtqoZpijA
 I03+6uSiIYOhc9qMeP4J6/J7zLLNYAISGSd4L9Q5Fvx/DTIX8Pk06P1t8ZYFM9hQd2WW
 TnP8/Y5yWdogBNIOSZOsQsVJuY1+A10YEQuUrEBcRU6crcj8eHwEmtOPHPBV0B7eeKQS
 J8sbOhMV/GwyRshyXY8CD4rgDaoFEa+L8OXX9zIqrBVgT9FNf1JoAN3E6GFUK9/WWHeY
 ePWwsgAx4r1CDGU1ZPx0OQICpAnCeFBZTTR1c2tYJdpdNcJUoht8glgZjCWpxrcmnpIQ PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83crxh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JIV3T4136392;
        Mon, 19 Jul 2021 18:36:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3020.oracle.com with ESMTP id 39uq156kk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG0K8w0uQObRcvMNqcHJ/8yJ6T2XPPLGaoaqOC9Kre9C5SNpBQyX8+c484NaBbkxoORhLwMn01QZ+C6+NKHeEQICqop6o9nACDCGrw/5FIJaRJKYmWPCaiSYplT9lz8wOclBhw6f4+mkLYsrlyhuR5ek8Ht1Ltkc8/aXcyfoV6bUcq8IHzhgebj+1AUBbzXwZYsbt1SjmfX9T9thImgAC7TuvUa11tk1dNqUcbOgcXf3MSGV/sV2Da85Lg4S/pbKQ7kV124TUgKsvXBzBqP59z/AMQZbpZmqcOthXF0jhQ38/k1nJq8QAYbMWxc7VNnsmCrDcXlbYQvLR73/Uj+VVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fN0UqnjgPYbUjRjHzs4vRpA81OuMceAe4fI1PQHwpi4=;
 b=Pwuq88JYaGpgLQmt2j41MU+D44CrQYzjkd6B950fclSGz+8r7govZLZTd2iILgTAyMB4nwl2gLGCvwqS3U0GsicKdQo13yB+Y5IEFOzX0SsqbCVrv6QVkNS5qGahPBSsEJRbgTuJspWgjq5Q+F2EI9/ADH+mCys1cPWttCzwlITjAtEPd9cMS0QY59qnjfFW8z4ZckXL1juVqdmcAaMY82CyZqRJRoBrSH9VRoFCMg6u0TGqHs9ylBvFm6A9NHGdCCK1kXSjMkQrzjlN13jmLu7adyZAYMGiqsp2CHIqHoZUJBIJXOxkNdiQTAlRKW9+7goCW6N6ZL3xtoS4GR2FMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fN0UqnjgPYbUjRjHzs4vRpA81OuMceAe4fI1PQHwpi4=;
 b=dxvigxlCPapMabWB2rHe2BdzJlG71VTUp1RvloZuqhX1G3T6O2N0fgEr86gCsMVGpguPY1jPGgoCdilZ7LTB/iyzdOv+vf6ZUp6LMdyzdVmKtgOI3a9NEblAxsbgvJTzxtwLxzkTqgz2vWDkefpo6eBm9ARfhrGEr4Qgm84AXt0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 18:36:14 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 18:36:14 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/2 v2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN
Date:   Mon, 19 Jul 2021 13:46:15 -0400
Message-Id: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) To
 SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 18:36:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8685df-039a-4b7e-3881-08d94ae41655
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4538A7DBB7D7AC6FAD07912D81E19@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nArlTNmcDbupr0JKmEPzB0VkA4py0dUCGWrgmBGqf1vv5Or6T8sj7BDtTvN2OeWx8mhahZsUh+ovqPd0uUCgoTFXTT85Ku2DNpmcxYw+h5iybZ7ExBroWZ+7VQFLDhalqb9Ff0vALEuM5hC3nKxzUYarDKtM6wtohcS6IWN8HaFr6s54CP8KxMLCLgg0eywS9Mkjq1CK4yKoAAM+sLvCIo/OYPIh91Lq/Up3GYlmCeUaOQpYfWkIJWw24ebc2HBZrpYqMUKnANdbnt1IIlXcMcpCZ60yhSWIKD4z7O4wl9O1kKlbGB17DBIad6eW9258bMGicpSZqo/xIuVB+TJKKq91RQPxMZ+W69qbIagIbsPteFyWlNgnW60DJk87Jsn1ScRQgvm6xVHSJFpraNq6Wfqt+RuReB6DZeIeR3bTW1NZjQoGJciFsSRwWKVSxE8jK67sz3FSMQqjdIZ/jdzFLOesRkqjmvy9NZtqdNfY6kx6CFFXBkj/xXZFQI36Bc7uKHrSR6GC01bRku0mjlJpFA0sNOIL59lHEg+BYywDawsLVuNqnUDDhDIt6I0TMqpn3/iWXuijOflHiADxCVwOQEw0h7MIAyoO0WS5zpfrhYPPaqP4RcyNSGGLQJoIFFIjJNeeR8m1XThUB6KwVBOamFy47Z5V2tLkwgiehnHRAxeCElFXcJvxhOU4xCUpZ9lIUyMHc3Ux8NuP6pvIhI1kJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(478600001)(52116002)(38100700002)(316002)(38350700002)(8676002)(7696005)(26005)(86362001)(4744005)(5660300002)(1076003)(83380400001)(186003)(4326008)(6486002)(36756003)(66476007)(66946007)(66556008)(956004)(2906002)(8936002)(44832011)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXyKSBTArbdUwqGyH8NxRhw5UGMReSD2kwMyUUWDRxxfIhRX6S5nc912hIAf?=
 =?us-ascii?Q?Dw7u0mEdLz8XEduLd+c5ZOKJS+7oBLElnRS9+IuEBpbc6+brpSlV43MHQqt3?=
 =?us-ascii?Q?kdlv6DeafnqfhLtzjzkv+/YTZ1ONmhenDZ+t+LevaIEDegIG4YO/n00m729F?=
 =?us-ascii?Q?iPD/c3TNbMJVcnyJMFAczy4c1t7t2yLqEkICDzQqystOWrzs8KLiOw58T3qj?=
 =?us-ascii?Q?oK0PGSdnl7XVLmX8qy6ZTi5JMehVW1mCwVtG5kYIM6fC9uRq94DTyphGC/3m?=
 =?us-ascii?Q?Y43g4GIBKTBky4u2jIEHhH1Y7ibLnJi0ygWCqA312OhcfYCz950Deo57BDiz?=
 =?us-ascii?Q?4vXaCmkh7/xLSNR0PQh7aMFymDO/u9qU6JK/r4Z2NaYu0OnPGK0yX6eqkl5J?=
 =?us-ascii?Q?p42L08ZozHp5jtrSgDS8/L5JctcBj+/UkOYEU8GheETD22Jtfo/M8ATm0dtd?=
 =?us-ascii?Q?3KFhjIjs1IztnJmx++sPm6Vp1ByqGBRdzVoKq/IM+0l2p1mV4HzyvbL028t4?=
 =?us-ascii?Q?PFO6F0CPlKHs3MgKinmTtESf+5EO8oURoiLR7dcl5BvTKebvkojF/wh5WhPd?=
 =?us-ascii?Q?eW4RbimW3MKzFvzgx0/PZF544fee5tgw+NbKP9kmminV245IqMkfSQTedUMM?=
 =?us-ascii?Q?Xs/RvUZ6epyl0B5G+uvcMQn9fyS66nDP0GLOh96UDubpi88IwsXpAoX4SZaZ?=
 =?us-ascii?Q?m9NSL0xHGFGJB1K+TOWkZto46jZmeZ9t+HcILdM4J7TD1YwPmwzII4EtlGxC?=
 =?us-ascii?Q?rGfnTVvmD2KHJPEadJ2+BhsMKlKuAgdvUXYjrNAWRr30Ayu/X6ZMYJdq4Iwr?=
 =?us-ascii?Q?WFKs8kY01LR5zUfh7K0iWLYRjBP1l7d0+ezg8pGDdc7eOVJApG56MdaKY7+O?=
 =?us-ascii?Q?ZY3ipDbRDiu6f50QZhvy+N6mtil4yD1GVL/NnL031I86awa+/+yzUYCTvIMp?=
 =?us-ascii?Q?9MKBWDyG0dtIl4rkbqFWcw2DguDss7tTxE8HnlBZBzylBhrKwBfWSNvfc5fA?=
 =?us-ascii?Q?9gl9D63M8E8Rr5Uzzucy2aoAQRckfYSGT/z4bda/sF7MtbbLbOaUnmn4b8cT?=
 =?us-ascii?Q?p80g/agA6eMUUwgcPXCtjjzRp+1egtlmzH9d3gI7wfaL6hwRxxEzIZdRbiO4?=
 =?us-ascii?Q?6poe0/TgVWew0lFleTTMt6ksu+0zQrmb5bgDqrx/C3iEZDLceCPQa0TqaFO6?=
 =?us-ascii?Q?FVzf/bEsOjFNit+8OWJfe/4JZXajSSJnEQIPUshMJHYJQtqSaPSPRrHSvjCB?=
 =?us-ascii?Q?5nz2rtSW7jldA+QJITt857Zu2fHuYpn4ZeNcoUgrxGtrHVMrEpTT7ai1ozZw?=
 =?us-ascii?Q?2eFixdqrleRon5hOPeqhU8Tb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8685df-039a-4b7e-3881-08d94ae41655
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 18:36:14.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTWt6a6tbh1U7nhgraCSyvyl3jAHsY2mme32oPLwf4+py/tVJKbMeGK/8hK74X3j0qXBZ2Hvn8Efd1SkncJLlyP24HUtwZpHXeWXYq89Srg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=916 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190105
X-Proofpoint-GUID: GbHeD0wSy1OXCCEEcuBLpcWfeEtHDb3s
X-Proofpoint-ORIG-GUID: GbHeD0wSy1OXCCEEcuBLpcWfeEtHDb3s
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	In patch# 1, the new function is now called __svm_vmrun() per
	suggestion from Sean. I have also adjusted the commit header and
	the commit message.


Patch# 1: Adds a variant of svm_vmrun() so that custom guest code can be used.
Patch# 2: Tests the effects of guest EFLAGS.TF on VMRUN.

[PATCH 1/2 v2] nSVM: Add a variant of svm_vmrun() for setting guest RIP
[PATCH 2/2 v2] Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN

 x86/svm.c       |  9 +++++++--
 x86/svm.h       |  1 +
 x86/svm_tests.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

Krish Sadhukhan (2):
      nSVM: Add a variant of svm_vmrun() for setting guest RIP to custom code
      Test: nSVM: Test the effect of guest EFLAGS.TF on VMRUN

