Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD24D31FB32
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 15:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBSOsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 09:48:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39166 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBSOsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 09:48:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEjQEd029382;
        Fri, 19 Feb 2021 14:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YMJqVqao4ydj1ukxOpSEj8SNvF7Jt/Ioka1r/ab2XRw=;
 b=gadFsUe9LLKdH5pH0cQJMOE9iWs9ennMJDlGQxc09zlB36s7b2ErEywUXkWaRY/ElSOQ
 JPWe8aIIoCgCFIEi8jjwqgv2+aIQ7NFi2LV+bZ5s0cvGAN8Cx3j6L0s8SYDjrjKwSbBn
 LqYp6dlVMRJIzCBSPXLHDNoLYqXGmJQpv5eicskITqqdqZ0E6SBoaeL4ISPhmNP/EU5E
 gLuer3ge81OXdxPoDrpOYL/exY3NKzayLoLmRkmdnBm63nnmBtXQW4XbrLw3JYuoegZw
 HOl/fC7plqc7lRvUVWlPNfKpIqEbibNz9Z8MdWLUvYr1aC+WmtbZqMCT4QCyl/BF19cB +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r9r5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEkKfS112347;
        Fri, 19 Feb 2021 14:46:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3020.oracle.com with ESMTP id 36prp2yfrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHlqz1b/qszlJ39dCbMPu+tB9MH5aPqMjxAGCdGt1lPM+o0suYMFatJG9uFIv0xCPw5FVPuGIujBsnA3P0QQPLsbob3rK9qmDVDKStZxiKYltLA2AVICvZ9bJn7nlv4RCoQ1ZnaMVSIuZdnoI7UXxX4OtaVZvxeup7dR5gKktxllRfKgxlSV321FVhjmN+MxcUZxGaYM4+bMJNBC1IpcgIXOly+f/9sv2VMp4IIB+hSxL2kPM3QBPI1WecZaAYx+XlehzzRST8IXKPd3T35UtA7h1COqDF2HrI+Fs2JW5Ofwy/m70RwFAHPRGtiJhGNXjRFiJf9R6chE21B1gWJjAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMJqVqao4ydj1ukxOpSEj8SNvF7Jt/Ioka1r/ab2XRw=;
 b=hvqnsDYSn9FGldzN54d4u52iX9W6UDGyfPHC3nieJmov7EkxUOANJLgPmh5aK7ienZ9TrX4XJnS6Y9creb42aj9kMmBarnxAIBW/YXnEoMT4lmAH1i3oXrwHp70iC7zzgVNPUCeAS6qT2YviCeWHaO0scu/55PhzpTPMI5kygID4aivvFuw/RhIXj2a2394oLgybJ/koqu/kA4yZGEzg8p6HFbblo/t3GRy1mG+FaeGjkzd1HuD8lgK9b9prAqeThrJ+W83VVrscVqigj8kv9hVE/dglqXc5zZP/m5T8908ToN9ApqmrdI6IE3hYFuqUM4KMurIxamJKScRy55ryTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMJqVqao4ydj1ukxOpSEj8SNvF7Jt/Ioka1r/ab2XRw=;
 b=jV3QFJ6Us4feUbWTRtqURZkJcw60veMy3muo1fQXZ6QLi3DSmfrR/cMtmhhtiAekJNKODbo27iUTQdi/+kmAMlBCbpbl+43GCeMKxdpISS4HtpHROmvGO84WM0PRcowT1lXtVZSfR19Fn/B4cN3Ls9hR5m30BXWQaiDueWsvRBk=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3067.namprd10.prod.outlook.com (2603:10b6:5:6e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 19 Feb
 2021 14:46:39 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3846.027; Fri, 19 Feb 2021
 14:46:39 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v2 0/3] KVM: x86: dump_vmcs: don't assume GUEST_IA32_EFER, show MSR autoloads/autosaves
Date:   Fri, 19 Feb 2021 14:46:29 +0000
Message-Id: <20210219144632.2288189-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0496.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::15) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0496.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1ab::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Fri, 19 Feb 2021 14:46:36 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 98123fb1;      Fri, 19 Feb 2021 14:46:32 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17cd4398-b5e6-4042-435f-08d8d4e529a9
X-MS-TrafficTypeDiagnostic: DM6PR10MB3067:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3067BEE0D143916AD255C81188849@DM6PR10MB3067.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+udt5Gw0z8n7Z8SdPTHzQnSu1X8HvoxFQlZfTFMby4UExILAgslWDCsp6vXhRjg89levh/Mm28kDBBU0PgRI7EjpI2j+X2OAoIrCIEIUXu0L9aPqvjimv8Oe+zDFQ7F9qi2r+Bsy5KXGMPZ/m+MLpaOyexKyX6M2lP5vsoFM7fSm3clMI63lW+Xz6oWrJ3tGo88vGUQtqSab525f+z9ozWdHnOUIcWMIWeNlLGO5hyYpewFuBlk+w04cwZjoYH5sBhyvX0n8IhERba0gxracPbNzAFj1AWwbEOCFgUoKAmAjFh1ZGMrICq5K7gwN5+gJ8HZdgYMuAlDajXDW1tGuHPCo2XXfspsTBjRH5GJHSPDo/eekAEN9FifjPzInjjQMC2TWCWFZQfqrkiS6cSBfNF+h+g03xdvNXF0YwlPEl/e+0iC6lOLkhRIsBO8LADLJAYTUexAoEJPOeR3aq5+hus3zLfJ/S4Hn8fqzuMTtHRRLyIIQEaoAqoNmKsN+lfFPm1PCWl1qH5mlo9v6tOXaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(366004)(376002)(2616005)(36756003)(5660300002)(316002)(6916009)(83380400001)(186003)(66946007)(44832011)(7416002)(4744005)(2906002)(8936002)(1076003)(6666004)(478600001)(86362001)(66556008)(107886003)(8676002)(54906003)(4326008)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3XHmd7yD+72FgeLv6pklhbIGNzjkh5qCnj+EGuS/7Foz/hy9sY+kH3Zk/+Th?=
 =?us-ascii?Q?+ZIuKHCG0IDCSi0sXlCoKETINwNZmLGAuP8i91ZPjHFFLzxy4mi5RUJEd9d8?=
 =?us-ascii?Q?o0McC8iiINV9rqxyqVLYp+JVaq3b0WL3upUJkcOqKQNzkblc1l1htQyjsYB+?=
 =?us-ascii?Q?meO9yuWas3Zc6rzD/uofEEzbMBQOL5jyfouMW3cuzKa5Sry2p669dXPduesB?=
 =?us-ascii?Q?5IoTT38EL/JWy2k4n+DcYtTS+k1TWcmVjs9FuWzuMzK77K1YpfKRAJhUSAm9?=
 =?us-ascii?Q?7GtdzHm6YkoMm84zkpWUQA9vj7r5z43ocomZ4DO4IqkaAd/YrNwi9uhs5QWw?=
 =?us-ascii?Q?tMaEH9kZwJAn0FzNvS0t9N8BSaJ76XKTpgla7JyAa57lafgodr7Rg/9Vl6CS?=
 =?us-ascii?Q?FIfBZGwJmOM5Qz4R+2nVWZsAQUQJdiOdj9t01asGRAbFYETXSMyf0MRSnqjK?=
 =?us-ascii?Q?kxrhqAKOUx9mefc7MU96Vn2tFKoLKwfv5obJCGE5hCCurOecCyRhZQld0+KE?=
 =?us-ascii?Q?KN5PccKHaPT6ufHSZ88tHCNQJX6b+qyTe1u2V1YurG1lJZJWYLK06TLFNiLD?=
 =?us-ascii?Q?D0QjKoNUTu1BdxhXWiELyHnKE4+zicOIPlJGVAdWZXR7/5WFr+TlUd2O4q1W?=
 =?us-ascii?Q?boLkx6D+dKGAiY/1lsea0bWv1FaWSWCDvtEvzYr1DJ6Z+o34VrCC1XyXp1mA?=
 =?us-ascii?Q?C53qnTzOL3jtPvKTyaP+KxT5u2szzueBIY73oOecd8sWAJBBnZOgbE6379PJ?=
 =?us-ascii?Q?ZFT1W34rYDEFkSgEAPkChv4gaB27Hzj3itloGQBVMbcOPDb0Du1wDe00zvdR?=
 =?us-ascii?Q?ry2lacaxmFHeYJ62oNeSwJOKNjwlcdTflgken0QiTcCMJ8B1m0bfnNpQd1+v?=
 =?us-ascii?Q?bZoAnGK41CsA8rysRx8r293nsjqVZdVfkCzqJTdFnL9iFRsAagD3aP+nFYQ6?=
 =?us-ascii?Q?eqeWHtEvrfG2fTO9EewSuFlwNNUG2bO+ggPhsBDgGy+kp0dprRjfSKpFyv7+?=
 =?us-ascii?Q?cXWSr7YKWHakZYWKqoIw7FRSljlOEu8Dy2MdIZaNMQNsNDP2qWsUEYk32UnV?=
 =?us-ascii?Q?QSswK6OPiV89wylzE/vMTnScqKMytR1mwDPL0EBB/uOxJaVwf26BU3MIizl2?=
 =?us-ascii?Q?WS06PYa23vHR/g+CbuDqRezKRwgypYGfyVhqNUFndHCi5tA3Tv2szPBAsww/?=
 =?us-ascii?Q?oA1BajaCasfWMlHfwn45vd2ud4YV7kjs8zw/odt72M/bANEj5OFjw3m/1K43?=
 =?us-ascii?Q?EzIH1VFm/VjzZFiwV2vlvac6WCaYVFZyfQLG+P2xWOUYUclYNrW/LdjXLKkl?=
 =?us-ascii?Q?832AA9Ytu9H0chU1bxzZntACggXTk5wCeZfkMUYVc7GdZw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cd4398-b5e6-4042-435f-08d8d4e529a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 14:46:39.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X90W9Fed8ZmcbMT6ET4KVbDEI2TPgaAgPTW+0f7oh1hWhwhGirsBQwPlWKEP8zvEL3MdnKUoScrRtLEEpf4xiLWtDbC/6YiuektjD3gitjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3067
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=778
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
- Show EFER and PAT seperately, as appropriate.
- Dump the MSR autoload/autosave lists (Paolo).

David Edmondson (3):
  KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
  KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
  KVM: x86: dump_vmcs should include the autoload/autostore MSR lists

 arch/x86/kvm/vmx/vmx.c | 48 ++++++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 33 insertions(+), 17 deletions(-)

-- 
2.30.0

