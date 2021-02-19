Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBABF31FB36
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBSOsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 09:48:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBSOsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 09:48:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEiRhf128083;
        Fri, 19 Feb 2021 14:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=dxyjeu3JKw9yt7fZClQY/ky5GyInLZU30fclDLgUwlc=;
 b=DYsAnvsA9eSuKO8kF7xWgGA3ngr4sVuUOZK7Enoc5wblou4tlFmmZveMbGcOfdGc/WZL
 9yQ2Zxp4d044XRj9DJXqKl8BWoIx0+nh6B9kPDsEcGhpksnacl2WbjVi4oGtdjSthVJ/
 +S2T2+pbRhSGJR5eCrUBksirDrjtec/eaYYgTMhIRhjQ5m33sGSNemVoxo3KR1Q0t5Ie
 Ga85r4oQaAgqKyNmI+MP8YwYW0gv8y3yV7qkU+079ubYKxVyxW8/SwVlSC2ZiU7jQtAO
 WtBv+1KrNPAq1VesMUOz9Jz2ZzkohgBoX955gJKoxprV3dLyOK7955rS1pu7jmaGXCyF QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bhvqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JEkL59112548;
        Fri, 19 Feb 2021 14:46:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 36prp2yfu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 14:46:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1tgNyNW9QsGj5hvgv0KCsn7kja8rRGqU83hMN5Luj5ZpwbXToCXvZlflxT6DxgTfjEnUwMYT9XxrszmgjFJwKCK2dTeYHIZjg85hFi/MoI2i5tXjpkl4S1e7hsgWnR2FOrVWzAhITyiJH4ldWHjNct2NQtDhNZ62qXr+EVWO9TPGkkEzjr/aK6PF7/T2l2VMcdv8nQv8DweCNokQzirLEZ9rJuG4PDYgTjjuLSWlu5QAFJ3GZDcYAO5sHXicduTHPmV3A46srJMmSkw8HGEu4Yxl4/R49OrQoy9mCipUloHnXOk/E+Dn1H9fu3t8e8sPa3kd8wkCQqvf6Vl5OaVzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxyjeu3JKw9yt7fZClQY/ky5GyInLZU30fclDLgUwlc=;
 b=ZwsVN6Ok35Cki+69BGLadHg+kx3vd77eFCKIoaoigw2WYns2ECWXDGtQytU+EFGop/tugvDRzBT6vxqgaEXXfpjhrBj1JR6mmUe0y5areUmAAJaF6mrPz44cJ3f1Edseoa8kI2oy4Wd/Da6WM8ba05muBPYhY0YrEJVpHPowl5RmrnOy8IYJn6WmwzKdBPg263E9SkMef/k8TIF59QMkiB6A2mvuPRg5TXee+wUWoP75cAfPsEZgfvNB44I47wgyzMWWc0kwP6cT7li7m85381e0U/sdgEOJ1BHrD9KTFEkNUW5sygFXubj83LYdqVQgZ4FtJPb9vSGz++hd3f5zcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxyjeu3JKw9yt7fZClQY/ky5GyInLZU30fclDLgUwlc=;
 b=iMZOv5hTk73DGsPXXttLYkzqNyiOF2i6lDHJW9y0cXokc6cQtFgmNB4eHdUWPN+Yj3t0wiSvpGOnS+Qd4Lm0ybAd3oKVHljH46m4AUPmSCX3CRTqJLnTmG4gBmQcKf7wY7OzADf4Z/TWxjdpXsaHiQQG5THKwiLTtM9FW6sIlyw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3466.namprd10.prod.outlook.com (2603:10b6:5:17e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 19 Feb
 2021 14:46:46 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3846.027; Fri, 19 Feb 2021
 14:46:43 +0000
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
Subject: [PATCH v2 2/3] KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
Date:   Fri, 19 Feb 2021 14:46:31 +0000
Message-Id: <20210219144632.2288189-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219144632.2288189-1-david.edmondson@oracle.com>
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0496.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::15) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0496.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1ab::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Fri, 19 Feb 2021 14:46:39 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e21329c6;      Fri, 19 Feb 2021 14:46:32 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3409b1ef-03f6-482b-735a-08d8d4e52b8d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB346655C363DC2B2B35502D4488849@DM6PR10MB3466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXIV4J5AJkRQPz8LHXeeJxN1nffPmK5qmdnuMmgunDKzK7OBd+ha8F8iLE8DDldqhRfk4NK/zFTAfF7JG196q8B1hu95z86FE0NIswcSC2pJI5wUqViwWdKDR4Da/EpgtIQzq+m0mdAhAdinxuodqI2Bqxxs/gFwlo8V45LGvYYuKq3jFg0xk3VVuPcuE8VNIxY5sPGN3PEDJi2+hMPRkLNsx1oa642FLykkw/2Z2PZniTxJQdoVdQ4surmPwk0xAhHhVw5+hd9QLYaNfkOQDqpTOA/QbEl6Vb83AuUwKXakSnjZTsgdvzKSh0xkb18lG7AnkvRf0AelOYcSEXHcKZAhSWaYjqpDh2eoO2vDrmPO88lBCLn1VDsdhaHp0mNr6wSJpniYZqE3U/i9/K/xlnx7UbUQnOqBxTidedSxwohVI+A6ybNc3FefHDXtCA0xGG/Cs4yKoinK1T0F7D2x24RPQReAO6clGOP6egt147942GxtVZQAnEckutGOIfPSRQHkaFl5fRyYp3Bd68DJuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39860400002)(136003)(346002)(36756003)(316002)(478600001)(8936002)(4326008)(52116002)(7416002)(186003)(54906003)(44832011)(107886003)(8676002)(83380400001)(66946007)(2616005)(5660300002)(2906002)(66476007)(6916009)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?58zySEZsnk9bQRsU6N36ABma2lyMTfbPtSgJk1/AjDwFqOvLzWzqaDSQqRuT?=
 =?us-ascii?Q?dBkOB8PogmhkVYf2UeThVIb0WsKUeCoxeNwWPQ3UChqQ4a6NgGfaB9t0U3Bs?=
 =?us-ascii?Q?2/4jXJvS4QvLo06/TCbHOjvGmKbn8oSIkHLQdqGunRvyuszfDpzC7QV183BG?=
 =?us-ascii?Q?RGiyzs88NZEtewycEEaLejghfFy0V+hSBBsWhvfLYCz6jTB48fWTd9+g/Tpf?=
 =?us-ascii?Q?bndFJmVj24/ikOUcQSJtIiuTK7KypdbtRqxpQAO1k/S8yApVpr7ymw/nUrp4?=
 =?us-ascii?Q?aWunAMuXGXYdmpQ5bx4i3XcHkYSUFkQot60hvTmpFSjIOlLs6KEGp0GcGtNM?=
 =?us-ascii?Q?z+IBvIVkF8tangWqiypu+WKzbJHJbGEbnj6hPONZTI6teyStqNxP1g58v33r?=
 =?us-ascii?Q?y76hXpgpaxd4RxH6PLI5tbop8mIgJkF+T3KN3dy+O7gMUQVff4b52B4K8mWG?=
 =?us-ascii?Q?Ph8zN8pi1XVsDM4yQuuC0tdmTP3fYatqM+W1HIPlfiOKzJNSGuSGIpLiXcYb?=
 =?us-ascii?Q?X3mtvygynLPw5NXQnkxDSe+bPUyQkpLm4LEwIOXt5E/z45XP4R8jV4v80UHp?=
 =?us-ascii?Q?+dA1HnFYony+/3AvAVlK6zUsGPqATT6lKM90HvrJPBExLQCrvUaacl39qOk0?=
 =?us-ascii?Q?pu3AN3rn/JjdsnP8N1CPLmVlLfFBRDDz/N1USl9LOnkQmH1PRO2keaPyhzzv?=
 =?us-ascii?Q?BXK0DQ+3Kr7aj5QVxe3UKFWBET0Mb4NAHD84aKsNcbDBO06SImSBZSFi6BxZ?=
 =?us-ascii?Q?8SvoobnQY3tZ8JS2DsxNofNPqFUf38g+kz7rjXY9ew4PEE17NwXI/qFMHvCz?=
 =?us-ascii?Q?I0F4VXnh6SJ437FTUdJ9so1/R/rEd1SCwOooIz0f5ZcObHxRkaUFNW/zkgK2?=
 =?us-ascii?Q?5I0vfTJd7xi8vGmb9V4As+thlTGrH8lL3FozCCZAfCSOaakUKujeUifjkfHx?=
 =?us-ascii?Q?ZXTmuO8nUbYNfzXsHm67DaT40dQpa3iYd0ULpAD0+W1E1vJWp/cO08OmP1GV?=
 =?us-ascii?Q?MZzTz2jqHa2JSm+9AF9QxbgQ3pqjpIDLd2gXxotkBGlz5ARqOp4RrucZ8Hed?=
 =?us-ascii?Q?b2l4AjsQffG61qTWsiHJiuwoJ27ybKc+tpau/TZ5lSgjlRbktkiaHnxWXJSn?=
 =?us-ascii?Q?v2g7mmuJ47mn0N/bgVkIDqRgf6COJ0EfspjVtGaBzqmwlXdfK1s/sXxBx1dS?=
 =?us-ascii?Q?Iu36CsdfOxY4/8N98ygZairVBpFgRXfeQj+5FmdVZV71YtZHlCDzOSFQ8kRS?=
 =?us-ascii?Q?uXf+TwuCGrIiopAS+d4xLbZOC9DMeN14Ei066Yjbz9XllBtHVGYA3mNsjQZg?=
 =?us-ascii?Q?6p9IjQypEoCaXb2RS2dZ/D5EDWaBbxXWn+I7TQXpoJEmTg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3409b1ef-03f6-482b-735a-08d8d4e52b8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 14:46:43.6663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvMs12NMRauluwpSjDGAJZdaH/x2yyrET0q7OsF7UHHpGyAE2Q4lHdAxdCm5Alt9YltiukCPBKs2OEwXV0L6zvYNQz8kardhKj+M9pqV8U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Show EFER and PAT based on their individual entry/exit controls.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 818051c9fa10..25090e3683ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5805,11 +5805,12 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
-	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
-	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
-		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(GUEST_IA32_EFER),
-		       vmcs_read64(GUEST_IA32_PAT));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
@@ -5846,10 +5847,10 @@ void dump_vmcs(void)
 	       vmcs_readl(HOST_IA32_SYSENTER_ESP),
 	       vmcs_read32(HOST_IA32_SYSENTER_CS),
 	       vmcs_readl(HOST_IA32_SYSENTER_EIP));
-	if (vmexit_ctl & (VM_EXIT_LOAD_IA32_PAT | VM_EXIT_LOAD_IA32_EFER))
-		pr_err("EFER = 0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(HOST_IA32_EFER),
-		       vmcs_read64(HOST_IA32_PAT));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_EFER)
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(HOST_IA32_EFER));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PAT)
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(HOST_IA32_PAT));
 	if (cpu_has_load_perf_global_ctrl() &&
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
-- 
2.30.0

