Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D940D3A49A2
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhFKTyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 15:54:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhFKTyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 15:54:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJi2hE089880;
        Fri, 11 Jun 2021 19:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eVdkIBmbUBiynCrnhi1xezlxBnixCF5Fu9kXxLGJ2Mg=;
 b=UQ6JHCPannRxNwnzzrHiMkOgoylrZELF7aampXQ+ytV/fiozYbfN8pZIydG+kluWTzbr
 CesJb62rqWbb9YXljDWEHCqQg16calzvoUi6HHXT2NeOnJLWV8IOYHrLnbd9NeQbkWS/
 UhcZwOzQHFrC3QqbkbmYDw5OLnPIZZIc90Yp8XEzUi151IMNjKwbmhhIL3+TmIoia+wz
 xHMFG5U/vU7dsI1XUDKYO/VIgOgikf8bfx8h4X1MZmUGJQW28UyjoW2XQYQojKx3li/G
 vznEnOtCOFJixAqVCR74FHAhBpw3PalfkcI8Mn7zQgXnp1kdoBSFy8VMwCXO5qa6ssvx KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 39017nqjd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJomsP048061;
        Fri, 11 Jun 2021 19:51:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3922x3ecgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZL1NkKiGOMgbpoEWPu5mHY8oeOGvfCZLwqgR+Gwva0TpRt0HZwqJwEbuQ1iX9I1g4Zxs4U0nM+ZA/DJS/esIiXtlAX+wSSe/QbQetKbnI78NLfuT+Oqwn+G9bht8/imoqmI2Cl0oqY9dtIskh1gw8bSd+r5MESo0Co//Ic8lHr14I9arvD3B9zmPLi9mZ+zLsokwrXRw6NUeOusAVr22C1VaD+vvon6xc409+esxcmSpDMOXCKNYkLn0PLZohRhFhZyI/aHDPbxZ9W4KlaIyxJWgatvHaPF5XmDGNMJRyDr01Hvg3lA1+5LJrUfHFrj0hnkJK3S9Cqp7AYEYMKYQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVdkIBmbUBiynCrnhi1xezlxBnixCF5Fu9kXxLGJ2Mg=;
 b=UHnjCqQzikY6lGodd3FIAc1mNdY/fzrjSqGO1geaWO5H9X8mO5muYphTcFy4+S++lF4n5NsVdp62VsTTJ/EOvNDKrhzNKceIVOY+AF5KRpl+bcDDOXdJVjJcGJoxDQ7OdApReCWD+sinzuVVk20zsagujZLa9TMIZFLKBQOh1T3uHMVO4S6BmuRztvjmxvH3koIPZbNbO90bbz25j+8Mku0h509HqTonseUKtS2p2zx7n8R+OH492l+W2lmstktKoC0pNVRQ8CoOzXeeDjxn1ZetCa1TVW58Qi9s2Lc0YQWh2mHsUTV9/v5AhU6mGTiuNIrv/VC0vyvcuCz5kyOxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVdkIBmbUBiynCrnhi1xezlxBnixCF5Fu9kXxLGJ2Mg=;
 b=s88ASuI21dJ9rFG2ioclL+y8aXC72Qbcjad7j+unom+RQooBcOtaMt5IY5tI4y0u8412R85SOMApGt5W5oV5vrT8obM9tLiXOCgqRTL5IKdT2d8HmP35EHfXOnEZZAW+AQQn6lm2NDrH9QMx4LlF9n9VtcbQC0YYVOGhge42eiU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Fri, 11 Jun
 2021 19:51:18 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 19:51:18 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/3 v5] KVM: nVMX: nSVM: Add more statistics to KVM debugfs
Date:   Fri, 11 Jun 2021 15:01:46 -0400
Message-Id: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 19:51:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53ec664f-0355-49a6-beb8-08d92d124786
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-Microsoft-Antispam-PRVS: <SN6PR10MB294401270A83144AF6F7D49081349@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/cG/xf3b/5hxglKHmSpMhjKxoQIPBsiTUVENProV++3Fd61GC2AohiNaUiXO96lVppPOhtEtDbPbRASyq6rhiudSQamxSeSEVyeAuQXSF7zP4EFL4OOaSx7qbisv3Tz+gkQEFeEjRLy7zB2XOnYd/EycBy28qc0Um/ERK8q1GeiUr50lGXpymKuLJPB6maOHDORSGWnFjq47dAEqxNQECWJRBx3emBHxCFkoGxx/pH/ut8UP94sXjGoNmishBEBY5a8i0DmwyS2j7JzUv5JrdfipEspVXFsVFbByJ2XRtMcjUcIOIYI5XxuxHy/5dsLj6x4COqt1xXnQC25JU+fy+03nllfoPB5ZB1eTI8Ps+Trzi5P5Gspw/l8DNTnv/5pESVrSnD6a2rOXDcCLfqbaJx7obk66laGTtM2Vw6xq9gwCYp+KP7wBA2Wr3rdQmfhs7+tDTjC5gVQ5coDJFYVqI+E4QyNQN7/4KNUBccRE5bYPL5O++gBuG2HpdGyw8KLA8OjjiNS133FmJ+hHw+DcGjtnKgSSk189ka9596WuzhwE4m4WT9NnydUBLLbGWYdYj55UytFpugOz4T9yf4co1G139REhBIk0/za6ke0/F0Rbh+RQtot4sjN8rlO/kDiqE2ph2J4O1UthU8Po9zXTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(316002)(2616005)(956004)(44832011)(66946007)(66476007)(478600001)(66556008)(86362001)(26005)(5660300002)(4326008)(186003)(38350700002)(38100700002)(16526019)(1076003)(6666004)(52116002)(36756003)(8936002)(7696005)(6486002)(8676002)(83380400001)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y0MLOkcSv06a5js+vxWYMlE6pXLgoGCpLGU32FB71G7nG3zNN2Lo0bsnGX9W?=
 =?us-ascii?Q?eOhAKq9R+CmjaW0cxow4DH2HXJeKM5s1bEli/hQt6K5jLXARZOqPNUzHV4tR?=
 =?us-ascii?Q?o1zv1HKJleHE1/g0pDkN3DH4sxmYg0nnaf3aBtc9i9xDbdw7fxUZnmZkRwEB?=
 =?us-ascii?Q?Cj262FZISL09XM0eIOGfK5096p0wi145lzpGuhd71TxSMYeLesr6WgvAxdRm?=
 =?us-ascii?Q?tPbzxwjTAn4mUE3w4kdY58LQnCyvRmY5ayvXzD6qVQY9VoASvEZ1gC4o4AnO?=
 =?us-ascii?Q?bSlDv0eogZDMDNGhpEx15F0lOQ8Xl9UDoyaPncA5H2+B3weMGr6RF31S8lnq?=
 =?us-ascii?Q?R5XrFRQ7yEkxRmhjxulvcyyIXy9MUOiRq/LtNK+S6an+ybVuHIMbQ5896Sml?=
 =?us-ascii?Q?EhkKWDnlSl6hmNWyZaScG6ZfbL3FvMtvY8PAa26KNNTgJbaVywELCbagZxsF?=
 =?us-ascii?Q?7eBW1WVyZ9kasjah8BOq1qFvurg7MMXG38ICfbXAMD2qdAD868H2mIVzWySl?=
 =?us-ascii?Q?Cx2S5Go51hEnKB4aTdQvXr3H/Rt/BEYjbSKTQzAaoQgvwILOVW65rreFjMF7?=
 =?us-ascii?Q?whSkvN18m23mcec9bZyG+Y200b3ADx/1AJE7l+WEvlXlirPtYRMDlULr1m1Z?=
 =?us-ascii?Q?ebxfaBA1h9LDbdzWkzQEHeuDlQcYUeMHIJwMvsqTAoU1RCPMMVMIIVrpqVDz?=
 =?us-ascii?Q?RPX6TKWKjD3DDkNV0/JSUY49SefuOKGGHBN8K8dxEeSB+9IA1xevNPDMEOGN?=
 =?us-ascii?Q?LH+wMos+lSwm7v26Xi/RtnCIBelSVfIQXAlV/F5MEGVWCiVcoJdq0HXfJa9k?=
 =?us-ascii?Q?0GBczhBFzqQx/ysmB0q/6l8rW6ZcKCoxXBebz0/S7juBz3GValvG2oY1Gv9q?=
 =?us-ascii?Q?7+ALpMwcJsz9g6Cj0xVqJU/m2XXkwxF4l2Vwj4/gfiGGLSNaDaScoM0FUgkG?=
 =?us-ascii?Q?BmQq7Dl0Hfw8Lzu3j3+/UxrfO798eDIstAZxn9IDC0tIUeIkgGShjnRFVaV/?=
 =?us-ascii?Q?WRR3SJwM4n4qrT1nXJhfWdL6nsed2GdYq63F4R6mwBRuzXieByF9fPS4n7xS?=
 =?us-ascii?Q?/AZEU5FdHzzhCSEInx5jjGUxXBl6nNoEnDGQuIsFVsvLyEPNLoCeJWjig1tL?=
 =?us-ascii?Q?fJO0sdN/GAEFWiWeR1jrARV/+2m/A2AyGfherazEfLH84UIWPd+TGG6XL5dd?=
 =?us-ascii?Q?wDYx7x3qkPFDqLqI0/TC2ZnpIMALUxhW16fRBf99YF27qEpmEUPhpAEXxf7o?=
 =?us-ascii?Q?UyhxX0/C2P0SQA7g55Pt6TlpdLdbJx5MUCVSjfyoumrtAZsBczI/IIY+pKUR?=
 =?us-ascii?Q?X4gE//e/z3zVoxqHUpyKU0X8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ec664f-0355-49a6-beb8-08d92d124786
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 19:51:18.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wk8HWt9kx/5PHX8JyQ5s1iN/rWPmaqUR738G2gRCPGMYD/JHvYEh3IXip3yXj4FrnolIfbiNiwkS0/gEHyxv3w4fkCew6haPJeLPEeU42+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=567 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110126
X-Proofpoint-GUID: WRJs-MkVcvZ1-8xSwsnQrYtRptDG5My5
X-Proofpoint-ORIG-GUID: WRJs-MkVcvZ1-8xSwsnQrYtRptDG5My5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=745 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4 -> v5:
	Patch# 3 now adds the statistic to all architectures.


[PATCH 1/3 v5] KVM: nVMX: nSVM: 'nested_run' should count guest-entry
[PATCH 2/3 v5] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU
[PATCH 3/3 v5] KVM: Add a new VM statistic to show number of VCPUs

 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/arm64/kvm/guest.c              |  1 +
 arch/mips/include/asm/kvm_host.h    |  1 +
 arch/mips/kvm/mips.c                |  1 +
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/kvm/book3s.c           |  1 +
 arch/s390/include/asm/kvm_host.h    |  1 +
 arch/s390/kvm/kvm-s390.c            |  1 +
 arch/x86/include/asm/kvm_host.h     |  4 +++-
 arch/x86/kvm/debugfs.c              | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h       |  3 +++
 arch/x86/kvm/svm/nested.c           |  2 --
 arch/x86/kvm/svm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/nested.c           |  2 --
 arch/x86/kvm/vmx/vmx.c              | 13 ++++++++++++-
 arch/x86/kvm/x86.c                  |  4 +++-
 virt/kvm/kvm_main.c                 |  2 ++
 17 files changed, 48 insertions(+), 7 deletions(-)

Krish Sadhukhan (3):
      KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
      KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
      KVM: Add a new VM statistic to show number of VCPUs created in a given VM

