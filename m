Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853DA323F9E
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhBXOO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59048 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhBXOHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:07:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OE4sWt017955;
        Wed, 24 Feb 2021 14:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=H+wP1GcZxZfeErzlXnCcR7gdg6vlVEoZwfoi3So9ghs=;
 b=jFIHLaNNdwUWEBA9z5qEHOXpbYvMNsNso/9b8hQze5S9/r9HLyjjuy+iFy9QKAzAXrTC
 Zn1l5IQ9izrvV2tuOufqERIIuzc7AMYnF5rXsMUXv2cbpqtKeGKbD9IdHUOUC0n85mbl
 xEIKwURhsvgirsuK0Lnoo+aRoemz41YLzgJaZPg/rFNw6hXoDxv7/3QQj8ATLWriMai1
 ZxFlKExVr6/SxuV/Oj238X/cOZAlIFVVHzMHWCchaq4bY62jyEx/6BTxRmCFp7ZbbMZF
 RKWS+p694jF5umSuWbjx+N5XHZpsrz3CGeGIbPy/mSdpmeHwe79tXNp9V/7eZMMnYbqM 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr625bwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODuBpj117099;
        Wed, 24 Feb 2021 14:05:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3020.oracle.com with ESMTP id 36uc6t5ytk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih3q5yqHQlDncS3ci3oVhN9dngQpd3nO/KGenKlFcyCEqgsXggBVnByWoajJsd0Yu1/cal14+HuIjjB6zf9qvUAzEzzDb2cvt8XTS+XcOeoAnHpQ0k0R9GWd1cyHSuOZyV12y/0nhsF+XDTlbzjrNfaz2lPHr8idBCUS+v3Vx2k8ri5T5kED4wRvplZGRTyLBLgTkpohexIQNXBb5f0c2nNgIXaDQWgRN371kvqNuOBABpritx0P3Dl5IFF30INrgpy8ZER4+w5us7X6kCCG6zUxC/oW7jesmtv2NObuHNjphlfaC/dhmLe6fqqzgGVXZAboeHFNDOSUJ+fjidzyHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+wP1GcZxZfeErzlXnCcR7gdg6vlVEoZwfoi3So9ghs=;
 b=ALnpM0dESpaAfbZ9d2P8tvDu63QgEihuc++EtuRZerBW+2hn/tPdEqH/aVB2U+xCs9cZgIbKyY3DzDZ3CkH4MzcszKA9o/yGwmWBdX6XNLSIJIgMvJb8jEOkzUin/XV8yf/ipmD6+iUhX++WsHYAWA/DrT2rKeNltYuM/YQluCu4mFs8p3MHF+JKeqN35mh1bqY74sD82CZEWqXkPodZ7cJ0OY8ecuuGD3CykebbhQXqiVCB4MpJTVTRd8XTByRP5MjWJuTN+USOV8TiqE6JCSLbDJkO14JyO6GfTnIgkf4hUZKS9jBJ+ctoi2CkqwY34uzasqJhhotGbGdD0aSTlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+wP1GcZxZfeErzlXnCcR7gdg6vlVEoZwfoi3So9ghs=;
 b=RuvhYBHyrCfsSnmAZa2mGayfNZwJIpeABXXKvLBt7tSIE30GZJIwG5guWwAHUgncaSp77zVDR6L9DP7j/Oe6MpNsZdbOW9X1B2H9IznNzBvL8RdcaZXJIzz9ywmyJVBV1t9TXTj8vp5Z3TyqR0AZcov2I5pae8X0KwdWjf/33H0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2153.namprd10.prod.outlook.com (2603:10b6:4:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 14:05:02 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 14:05:02 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v4 0/5] KVM: x86: dump_vmcs: don't assume GUEST_IA32_EFER, show MSR autoloads/autosaves
Date:   Wed, 24 Feb 2021 14:04:51 +0000
Message-Id: <20210224140456.2558033-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::20) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:189::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30 via Frontend Transport; Wed, 24 Feb 2021 14:05:00 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e3609277;      Wed, 24 Feb 2021 14:04:56 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d34080c8-e91f-40f2-6596-08d8d8cd2e09
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21534C830BF0CBFA58729158889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCkuAwlORRP/1wpSCw3aN2wlr3MpCzjwpJKPVQaHfPShJEBIn4GLhyDlGYnBDsGx4wZVlnEnSfjALge/J9qLjOH1HIzfvO6pVKUPfHSGoEz84x4wtst6F+wwdj3Ua1aCrq/pQVNFOcim8t5tQ2QV4rQzA2YQbOaoGf0XdKG4/u6+FnyVWCVbGkaKdVvl6pd1LvWuAHS2exbjn8/K4ypkSK4rsJP1216e78bREYB5Z4ZLdomjp97aa2oi4rj6dGssgiL2lvJvjiY0IOXSSAb86rw3FBMImkrZ98FlUDdZu7awzpQSPQ3cjC+Qjr5bbDdK/64QZZDyVIlZwteIShKyg+Be9Lkk2tHlLxhT/Q2dX2415CRClJIg7g6JvxKvFLf3/rvv0haNG2N7wFFn2XevFyjJj79BJHP1xFVavhgC2GCJfrKddxbzcNze2zVZfE3pYCLQMdiDxPRu9YplHvKZctFOC/CsnUgJmiQ4DXBEoU9ylYQ0E2KfNZH3Wpqlq3iA8v2SsyQ/I/RQTChDJJSPaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(6666004)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?98zKLZQW7khdLvopnbGhHlVQZhVm80AacmzaG8gxNVmdlgkeid2boINELnBa?=
 =?us-ascii?Q?oKrk2Em4gkZhm++CkH4c3zpUUIHKmolwqNQHsMmRAZvxQtEk0VPs+F80ZA+6?=
 =?us-ascii?Q?EEKVZpxAsurjMWzWwUUtdlBaKcrr1SE3ycNX6pn/RBvXvkWm3fTJlTrhsZMT?=
 =?us-ascii?Q?+km+sI2LVyf54SGGKCJihk2NaM40ZAigs505w66MoXVZpN4LVTZlo6NN4LPh?=
 =?us-ascii?Q?NqHckLowin8h5C0rlmtXPKiRGj9Pdwk9w2jbGz0X+36humSkJViYdkiNBckl?=
 =?us-ascii?Q?R+t12bp1FSW4m9lr1nuWVJwlEXDt++J2hDFuSJFBgQP9Z+aMG7LMtXdRya25?=
 =?us-ascii?Q?mGEfISsIfavwEryk8hxX9o/av9tOeG+Ttb8XKUGgnhoxbdFQnTqU/qG6tTXO?=
 =?us-ascii?Q?cfWxNWE7WgO46G/5aW8xa5fweO/g1Bhsf8t2X0kgRfT4QEuWKPBdaXISGzxp?=
 =?us-ascii?Q?IkLF9/MIQuVQijxqd2hUeNRLpO58UPgezLv3jgUXC6gQvfogtTDeAXLrIfJ/?=
 =?us-ascii?Q?P0fSoWWAoX64hSGe8Lpm5svPhve3y8H5UXDaR3gR+LnLwwozcwtcw0TkyEOM?=
 =?us-ascii?Q?2WJqRZnoY0qNCMnPN0GFM0UZDNv4Ysv7lVJUH9xOXPl3rufCYKDC3PGMOXgX?=
 =?us-ascii?Q?zZEYi2nVC1yzTClGTabQ8ZZBliOb1ek7uVRUeAlBZ7cSeK+EAvsB3UuV0ZAS?=
 =?us-ascii?Q?yJj8fSCCp4hI+GAiCNjaf1jjNMtQ6QaDK60oC5EbkVopRLHtzPMeGQX1hGOX?=
 =?us-ascii?Q?I+O91XdRtO68kkErRGrAFtinuNpF2mAf7zAi+flc+a9grJSrcwT916KNlCiE?=
 =?us-ascii?Q?C8dqrpEkBr0UtpkRT3XU0Jk5r6CXGlUWSZvFE3XJg4caG1NzJD8gsf+uEdMP?=
 =?us-ascii?Q?76oE6hh1HPsGGwjdtrfWrz1ivcd62l2TEIfrDczsO6Wp2FNin3twZDCljtbq?=
 =?us-ascii?Q?5PkSV7WXXHvNGGniTvrLH4n3aARnwiz/dwXwkWbMwYHqugeaLWh8BolFTt0S?=
 =?us-ascii?Q?4/nmcvOqlMaFj5ZiS+ZBM7SUq20Km2atO4n3P/ySEXLgJTytcBmyfO+VRQfU?=
 =?us-ascii?Q?J6A3c5rT78Z/qvbDFyq0B9MfWSNCj0ArJ8k/UaMmXYGi0iZrG1yR4JqVa3Fx?=
 =?us-ascii?Q?v1FwwvIvta5cCGS4ZmyPUsTtRRYuSCHq2pqkjKy/26WAujQIMzshpORRYED6?=
 =?us-ascii?Q?aOipqHOzpSiHgnGbNZqqzyBZxwgagljsvZ0uWMshwOGZKUUN3jkFaGrmA9cY?=
 =?us-ascii?Q?lC1ztoi7P4PowhqWZUT+4LxfvTTwMb+t5TOvc/VWxor24ThHJZH5Xu9+Zyxl?=
 =?us-ascii?Q?YepFFVrjBfVzQjk8jVn8EiStqcNrhzbdH8XknP8glE2qeQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34080c8-e91f-40f2-6596-08d8d8cd2e09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:02.7187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9G0H19pBGh9gYrZTwztgUYKXQhNvmLuM35fQ0o9ck3BO/N7iOVxqsa+Crol5dDq84Yg0+3cX1cmgsFftDgxCLpbw5ASWMWlu3SaYe7UA0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=730 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=965 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
- Dump the MSR autoload/autosave lists (Paolo).

v3:
- Rebase to master.
- Check only the load controls (Sean).
- Always show the PTPRs from the VMCS if they exist (Jim/Sean).
- Dig EFER out of the MSR autoload list if it's there (Paulo).
- Calculate and show the effective EFER if it is not coming from
  either the VMCS or the MSR autoload list (Sean).

v4:
- Ensure that each changeset builds with just the previous set.

David Edmondson (5):
  KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
  KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
  KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
  KVM: x86: dump_vmcs should show the effective EFER
  KVM: x86: dump_vmcs should include the autoload/autostore MSR lists

 arch/x86/kvm/vmx/vmx.c | 58 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.30.0

