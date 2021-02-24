Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A038C323F92
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhBXONf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:13:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhBXNcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:32:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODOCej099751;
        Wed, 24 Feb 2021 13:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=QsOl/ZWq+C0rYDx6LT5TVbQuH5juUzIx8UVAJVBw1pXpsKLs5cFltln4w8yO6irvnVLP
 L7gEu+e7V3Yt5Xnhr950uNNL/vBzVJxOjIBiqKr89V464sv9kIQTXp1BQqAmUt9XvWVW
 XiRnW43Gbq/qBie+iuZ9j4rPKUCSQF7n8FiwJkyknz/pySxWAVlyBVRpexMvfxEiwTSW
 lIQYh0eHJQho46o1OqFkXadlQ6n/SkFxfzGv0kr7CVjsYuYLxdzV1U0ftUF3AnAGU1Km
 vz88PO4qaZ2Fk4FA0yQ5arKPE5t2URCjWERZujFtvK79c2WozsoI/VwgtQdLcO+GYzpQ Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ttcmaw3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODQBql184325;
        Wed, 24 Feb 2021 13:29:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 36uc6t4rmp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3b8bDgffb+T+E0MxYPqTbZiuh3dhGrEmWu38PBa6CicI7Hd0+UI56+24TEF1EzbiakeYTa7woariH4hB0v+7CEtjZXiS56tducLh0+xKtYrCRqQSUnJ8cTYl6lZZZh4deWuJdJTctYzlbzIZVSCGVSrRrrleIS7EdLRyO3uvzNlPF4Fa7Id+KGLy2jita4FziiGMSo5fSK5PgRpSwwZnya26bfKUU7nVHGi8UTO5LyQRJxsDg3I7xqEUZZp0pAloAk2w5R9U83sNIPLykwNdvIRYfKvxPPWQVjrZXlZDC0kNiWvDZJEqY98/oPIQfA9xPAlqtVgH7Nm3bBPuRQGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=chGMivhCfs0z9ruSCGAP3pHbMXuvX2pgLohRJnjYMLcJRihz+n6WCZNnCOzg/B4ZRww6A137SdCx8g2e8iQKa1ni1B24E28rdUwXin5Eu1ZDTEX7D2lSGEZgp8ZXavyQzlsSuNJ4z1FOU89k3etUUKgnL1SZAJvBcZ1zay08svT2y8qsuQ/5qRG8y11+OTYWLPeJBGTZKnH2m2zizNg9mI50+xv3URu2CAonHYvb7QMW6TvjXgFvrkA/fsWf6lgy5j+Rtxln+TACFUP6tAz6Zwp5RbRrRjJr/Lb0Cx+uBcK5rwLK8B4YbMusH2rHMAOphijJ5k3CoqZxJT1ehnfKvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=LA9H87mj7JidCqBmy3wZCZlZ7Pm/DEsxqIKjWtWwLFnxOIYm2hY6a+2/6UI6TJ+f+SF7FSHUIpJapnJFDUzwXMWHmURP16xawnVXr3eQSOvql2A2LY72+Eg3diDwH1A9n4RsnI2+neqoojRb4PLlzKkH+aGQ1D4ddsiHGcJWqMA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 13:29:29 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:29 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v3 3/5] KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
Date:   Wed, 24 Feb 2021 13:29:17 +0000
Message-Id: <20210224132919.2467444-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224132919.2467444-1-david.edmondson@oracle.com>
References: <20210224132919.2467444-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0181.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::6) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0181.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a4::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:27 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 34ad29ef;      Wed, 24 Feb 2021 13:29:19 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e33c3c78-703d-4c17-c61f-08d8d8c8367a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3146:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3146251339AA7F8CC84502DC889F9@DM6PR10MB3146.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GS0PKvA1pkTZ/NaLPNXahwA9HnjzcouT+HlvGGaWUKKaUNnthbSTTSctaFCAMWrhdgbtbmC7oe2s+bFwzuQLCc1XtdUEHadTNRMeTofF25CE3ITt5njJqbt8ZYzpZc9W1p/mfZQhNsT7f2OsqR0SWahu6XfqRLb+TS/2192GsBXHcHjjSCpnwM9ZNgzJIHGeMQ6pF835F7mkJoZxuAYXH9H1KpEKpS+deMWtvF0LXsyHpvXz9BtqqQwlLIfZ7+jrVgTqU5sFQnUI9NPlnSRjpTzkpi8QdjJTXHU0ciZ6kI4ozX3jbAHqhp+dUIDpVXK8fDNNWVnIn/R1MuwP57isl3ePBmBTSOz19YH4/Y1rH9SMKyDYsmemGvqoyxxIcFg8ZfsFE6VyLBhxo2ysFEdbmm3iWb6L8AJO9CV4ObNe2ewHwaNMbTS8EB6EDkm+SMbruXKFvYQu5DJ5yJ1W6tzYmFVr4DeOUktSNekinvSrdI68QoF5JxblKYymyiDbFa26fVBTTuhrMfpfAHDaNfk1Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(107886003)(2906002)(44832011)(6916009)(4326008)(86362001)(478600001)(8936002)(2616005)(316002)(7416002)(54906003)(36756003)(83380400001)(186003)(66476007)(66946007)(52116002)(1076003)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?L8v+PuZbvhz8/hXCBmZFlaOKks71q+drVcG/smG4flArv8NiGOONcfA+KGuq?=
 =?us-ascii?Q?+Ze7CoFom1ifDmmoCEOFnfbkUDojLw3/tB1eJjFA8gfbxvpy1ZwCfCybIi9I?=
 =?us-ascii?Q?EXH5TFuxEOLh1YtC2tuFs0KBH0zwHjJQiJleNNK1E1cvj9XDorTO015BarFY?=
 =?us-ascii?Q?IwXTRvIt/VTTE2n9s47gmx+OJ1MNfb9ojuk45rsThSJ1boVsgZav295j7z9/?=
 =?us-ascii?Q?5I3F+GqKiMn7QW+LYBpKY6LaH75jrflwSYa0J4sbIs5VJPwBtlOoS0EYe1xG?=
 =?us-ascii?Q?tMG7EN7yUCks9fLS+0bR1RC4ooCsYs79zDw8VIBiehwxlCyas6e4orF/0RbU?=
 =?us-ascii?Q?owpojB8N9SoFWyzX9UBX3PyL48k2SSpcotVmAYIrMOox19ysFYb8snbfHAaQ?=
 =?us-ascii?Q?E+ZGX9LJnRKu1lkvEfe5HujGvaOqOi0jgW1cXoKyJruCgIuOOcdcpCSpv0b5?=
 =?us-ascii?Q?UIA6GaU3kqIpShcAxHS0apqmqVcYkf3GsBv1eAcXFjOVeXeb1hoXHtySxD+C?=
 =?us-ascii?Q?8xwK0ZiWXik98fpMKluonvyChB8HVkuqwwcbymGKClRTsKyExaJ7cJb7l2IM?=
 =?us-ascii?Q?WfeCfASov1w9q/7XIh1xnvlJhE7VtpAvxFdSOaSJ6/TEKXPKNVPrkhwmUkCk?=
 =?us-ascii?Q?QTdGIvseAtrgb1yQlNqv5QGSsbOl8Gpha/2oSgj3PuTqa+32P/B7H2pMU5Zc?=
 =?us-ascii?Q?VmNQagPd9M6DV9/IJFwgqmOmVuOzG8WIKAUWRS+emKJMRbs776SOMe0RLHNJ?=
 =?us-ascii?Q?4UfpWO0moTBNchtHNaOy2aJzx656eqTWsyFihVeDpXKY5SmUwedAoTpcqWI6?=
 =?us-ascii?Q?ZHjJDZ700RlISSRcTVEMmcQZS/LXB0cxcxnOpF/QYeekoYyg6ns1uiB3k5Qr?=
 =?us-ascii?Q?kQ9JbCSOfJsWPIAJ6s+kjaEwNEhNlfx645wQTomuroCuLyMx4LNvi4RKFvB+?=
 =?us-ascii?Q?D3Vuu1D1pzCpT62MOVXYeg1ZjaOMN2EdVMQTiscbSBCzNrfm40QDUO4THPUo?=
 =?us-ascii?Q?aH4UJBJmqmFdlmxtVlMTxkTOEf1dH31K/TFXamvShdf6GfUmWtAVeFKuZU+P?=
 =?us-ascii?Q?J5wc5LLk7HKGipbOPXdh6HuNGV8XmIXvcnpkYcBFIfPUpR+T6KRvc++dUSt5?=
 =?us-ascii?Q?XXCUNn/996JFEpbg6X/JtOMXv88Hnc1tq1/tuZSpPJw6EG0o/MYw4q158/i7?=
 =?us-ascii?Q?aLpjqVIHr0JjxZ6LV0IFeHesAuC/lr7J8yCbJcQdY78oaI8IQwrFTvuwvtWN?=
 =?us-ascii?Q?cgVVqY5KWD5pq+9rW9x2D+QIxUxXDcz2uI9qTpks1ipWJEaZuBeFxO5xRq7w?=
 =?us-ascii?Q?G8GpxBkR3LcC+KlRKJwSfMJtFK9hgyV2VBVkAfI4gWRuXQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33c3c78-703d-4c17-c61f-08d8d8c8367a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:29.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qS7O1M5+lFAopXeKTfQboBoehh5JTQU0UlQx13CeMTwPYShIOS15c7F5+DJ4OgpbKcVEPJbxbfBlj7KfW+o0yOxs9sfbwd6zQhcbqMWBdpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When deciding whether to dump the GUEST_IA32_EFER and GUEST_IA32_PAT
fields of the VMCS, examine only the VM entry load controls, as saving
on VM exit has no effect on whether VM entry succeeds or fails.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 90d677d72502..faeb3d3bd1b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5860,11 +5860,9 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
-	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
-	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
-	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
-	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT)
 		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
-- 
2.30.0

