Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F57323F99
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhBXOOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:14:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57164 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhBXOHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 09:07:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODxM2F101307;
        Wed, 24 Feb 2021 14:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=LJNcX2Oss4F8zqP+M+Et6Gv/+GS7tuRJEyIZvekbq7eyYxSk+EKDKAKJw2vA1994rrka
 8ccmCW4ghtTc+ggFHu2gvOdp1KE0KVbh/WXTlfBDCJdOYmbt7qJaXeIIeeWCqotl+N+R
 6aWYk3JbKLP5YY32syjPuT8czO/tpgS17P6dh+nBosORky0fpW6+ilFRrqddl4lovX2e
 nid1KEIoVR0FQDDH8jbvIMXjPC5RiZ+6YJlF+02JjJOIuqwrKocCyWsNnQy7T7UGvCf7
 MRkf8GLPMDRZF3KcY3m2+A5ahniaT1fPBI8WFFJXG+Y8GLycz7sZWQVKi3s8BJYNrY6f ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur31us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODscsl012587;
        Wed, 24 Feb 2021 14:05:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 36ucb0sbe5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 14:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoBqzNiZkAtaUrnZJb0RQOgmC1gTFfGyWwfA0vsDl0Lq6PkJps77EvQATc80i6VDlycMWHoF6sSVOHneUzjl4i8WdZyIybVHQuBmkQJU3IbmoHOImTF7ONpLdY04yMcYVL9Z3ABDAmggQM9DponJuDsvfwNTzC6aETWmLB8fSZbOrESESg6Mtb+gjOtwdYFfY96n7F6FavGAwlYtiI1PWsG47rZ7t2xP5sAlKzdCYZC29BgdE+W+nGuTEpxIpchsKkvr0uU4SDRTOeME0SxUFdRqWRtAj0rgpD/hyu0qq0Bs/k8THOMppL34NYbxDn2VZrsK3wb2IuyrhyaS8y0awA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=mGTXsxmslbmWuMwLAIRgAIzmow5eBf+RT2N6MhS/ELFwU5VzUPeT98+OloE6rvg+WrwvOIME0sWJlaDriDQ2MQ3oJipZmQjWRWleuQ3anIa5lMEwEBzT82WZQ9gIKOlW3IjXTG7YmjZHx2neaFbFNxbR8p4ilDT7G84UV5Pc1CcGh96PdbFGZYOaZaLHUJUvFIJ668KlMmQ1/6LvnYqFPWKDpi3GKIhtb/8sJx0QIst1mwRErONxQwFvQN1TX7v0UGQL9W1vANodg2vxqfDW2FUrBE/Ju11iK+wU6LkW0zqqfYBmb/zw4HvIFnzDMY4AssIWid9DrjVq4Lq6R6ElkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7jHoxULYNkvYJ3IUGDkH0gVV6qT/WpX1EUS0pOtzr0=;
 b=gZDWOStG/iDnTxEiuKtWUhGxUZbi/sleCrPAQ3ZMQsF5DCvMmqEaFzk2bUBd++0E6nn0LNidl2nlXEFetCr/EoOW2e3UFEQ5WrraCzaPY63dsRfeyCMjMkYBgst1ZnbpgstKGHg8S2EXjT9hbNcDxIYhXEzE02dYbvNCCs4Vk3A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2153.namprd10.prod.outlook.com (2603:10b6:4:2c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 14:05:06 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 14:05:06 +0000
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
Subject: [PATCH v4 3/5] KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
Date:   Wed, 24 Feb 2021 14:04:54 +0000
Message-Id: <20210224140456.2558033-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210224140456.2558033-1-david.edmondson@oracle.com>
References: <20210224140456.2558033-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO4P123CA0256.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::9) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0256.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:194::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 14:05:04 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id deb71382;      Wed, 24 Feb 2021 14:04:56 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f38bf87-174e-46cd-c3ac-08d8d8cd3041
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB215358B2A9A6A48AC743478E889F9@DM5PR1001MB2153.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPqeS+6ToiFEZuVYTSf0IqZ+/ZoemTy5VSQmDBNHqTEYdcNu7/mrWrOiCl2DVO3RAsX2Rp90sfhxanVfZ47mXCfK/wZXGkhiBSddOAquveAGJ/JL67OJxsVEKG2SSKq/y2GYpldaWtrCNkg15hgltYf0ngz3MDjZkSmlEdXQFfEc8R95TMGJp0xA/OsU/ew6O9elXdHdis5BYxQ+fRyL5pZbAIDr+MPOBKqAp88v0tVlXfaT3noR4KKiXsrHrr3yjetkSJr9ulOYHoMVlSQLRb50VzOctOys9IMt8pzOPL0Ksi0xntR4F7OIaTq0JDGFcmKDQxAsgS0y6eyLxpz+M4wuqiNVOw82gyjgRFByy4iIzzW9n7lEr0mUCo95tOLgYidSlAUXobAXnCXv3bEE/IFNqRt5PssOgN7HorW3MBILHo8oDhT2GInJHIl/zSmoVaFUrLw9eHDcGDBf5Kb4olkpVeViZYIr6WyQ7A2F5xxVjdRWRQsv0FQCft8ssWlrf7Dnjzp+PKiQ9Cebv7+r6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(83380400001)(316002)(66476007)(44832011)(8936002)(186003)(2906002)(86362001)(7416002)(8676002)(66556008)(52116002)(36756003)(5660300002)(6916009)(54906003)(1076003)(2616005)(4326008)(478600001)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bIKOIn97McR3uY5OYkSG5mxiOkvmVKpocPOwRxOLevhfd6jnsf2yxQUi3Jnz?=
 =?us-ascii?Q?zWe5NdKXogzg447Kgp7l6chfN7HMdiL5/2c8qvfz3z3idzOH2DFWMEF6S1et?=
 =?us-ascii?Q?Bj3QpSBZMYHguEkpDHth02KKOiy4uW+hR72DzHh7RzLZK+Obj2MyqYmg8FJJ?=
 =?us-ascii?Q?C9tPEYvzYKnjiMbO38T2+DuMXOVEy187d94+SWCsWZboDCQDtOe0u7f5bq0A?=
 =?us-ascii?Q?RWV770HbEDYkAfG2pp1Uiw+klycvpWp0uyxhsY7yzZbnYVQ9BNKr++wjTBkI?=
 =?us-ascii?Q?wGX7mYevnkBD4FLZ6cn1buzIN9/FFHcf9NtGdG8QhfgOxbMIQtwB05DzLlaF?=
 =?us-ascii?Q?FNQ+jVRj6r1x+1fUZmEGL5PqpLa4sqsLpB1+OxRvXP4MnIenKGxSNbCwyh+c?=
 =?us-ascii?Q?7pEKH1JHDVkHvlQiUo1HtQk5O+ASsIKJ4gq5G2fGtOIbA3OZnpoQM49Wvszg?=
 =?us-ascii?Q?dEnsAXu7VWNYegdrJ8X/kbowTyX/4Ufr0dR6N2mH0S86haWA0S7KNVwWIEil?=
 =?us-ascii?Q?mv2LVBVDR4FHvRL/ku1VvJx/qk1A28oQ8OhSAl4xGGhTO8COL1jS68faQzB6?=
 =?us-ascii?Q?/3W0qGYmx/AoSO9Q/xeStqaU9tjQW+R/kNsrN+DgX3VRc7Lbtg+Lsqk+br2Q?=
 =?us-ascii?Q?t37a/zg2rUHLwrTKk6k1pA6xp9506XgQYLmheWK0RdTugz28fnTsXWdfEGNv?=
 =?us-ascii?Q?YlTGmoSgntYWl501jdGYouK650vrUVBDe7MfnsKrmTFA4WxsBzx05NzOh22z?=
 =?us-ascii?Q?HpkGLfnmlIbH/xOFd6SCjiDbrx8SLVrBDnI2Ry3MNkoZity7Xm5nqw0a2vg7?=
 =?us-ascii?Q?yrzEZJeZca6O7hY576dY2e51F43wWKT/AImd9DjWiXINW+ufDgOF58qgDUFZ?=
 =?us-ascii?Q?fS3xpSiasF0MYKz5G1lX6JUFVs6Nw4ytknrSTCSgG+6uqwIzAPnkPhSNZM7G?=
 =?us-ascii?Q?j9HNXS7OgP77dYAuWvRVfrxzOd5zi1P0NPLDp4H43058iArAiEDAYwY/ieqL?=
 =?us-ascii?Q?yjMvEj/ynnAg+QjkvANbB2sY7fwhkjkaE8Rz797Ru52ZwnLrTGr5p4uwsLDa?=
 =?us-ascii?Q?9KVWbHHN6pqdVDoqUQThdpVAOhJEk1ZPl/X9Ii7Zuh1Nxb2yl7lSV2EURa4Z?=
 =?us-ascii?Q?dCBaymTzYBLwSyy/pGExMjMcshiA8U982ZxOiKgmzxi1nWNrTH7hGh4pzw6n?=
 =?us-ascii?Q?mWALxLVnMeQFYq3zlRz38hyhStXwWMqn54KcJGfaOd0bTA+FG/RLchIyOLyS?=
 =?us-ascii?Q?Cjhq6QuF3hrcd+jqhifApIXGKsgdEbbhXiqvlQcYZzTySVxUvnG+b84REEcK?=
 =?us-ascii?Q?TuI4qBtDmhWU0ROZUh7xhz0UczGaR28JQ9/5ugv+06xXOw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f38bf87-174e-46cd-c3ac-08d8d8cd3041
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 14:05:06.4275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4V98i//vRWz+NMn040OL0breRYto4WxK5b8ylk3yc1LC7dGmUC9re3seWG5QQ9o7zdHa6vPtoLDAF4mhl6X1tJ2G5gmKbGe7KvE5KXoAiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2153
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240108
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

