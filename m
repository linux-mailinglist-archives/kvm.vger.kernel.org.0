Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2DA2C9299
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgK3Xc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:32:56 -0500
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:9217
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387524AbgK3Xcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:32:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDxWx+SJrJX7YswGRR98ciqIuSGN/z4KyHT0OWNYxZaXiivgYxoEDqdPk1DtGo2uSesb8/tOiocYjLakqkSROr+Duis6bYFam+2vysLnh7sJB6tAaMtZAHaCRl+CLiAqEsnyKFkGOJG6NOldXBRRHaLVpJVJBVWuQtI8IYVf8UbVO5WOQmz7SGLb5aWaWDl2yMmD9XG1VHhgw/hyaFb29fIVdUteX1kUJSM9XIO2P4sef9Odpc3wZC8OYwidHYJh/P87FwVDVyGi3VaoYQun8iCdzp2XrbQTw6aXYkBj2xHSsUX7ICBei7Ca0bHsv6pR8bop1TXfnzUDLfwFlMqnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=g4fBt5DbqnLX9IRc4HWjt8v7NpWRE8wxBJz866zqOIGJ/iaNRG/TWoXNd+iQ5BtZGryyk6gvHzJhFN2Ykw19lfEDkoQ09KtDkr2RvpH9mVbVo05eylROfn54OzERMsARdysw8q3kIWl02hYve5zTIqQCXbwWQboPkCBJGx5ZQfy40FBEl8nonCkTsdgJpN+KhrJfi+1YPiuV7OQKiuqiU2Ztwg62Sq0xA9S83EdBRvNERxF87QTOfZizVL4wrxTrPXTKX+M6qT7Lvrd+nHuD9JO0YDvXCkIBWAEoOurLVIq5KZpX6icxBhyZdGuXNGS5WrxeFGKdzN7F2aHyVxqeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djYOIZIAe+UUpzeBZtr/RMxOzG5cL+NruPXwZsscQuI=;
 b=UtQBwLjXckQQAd2MmOeaLPkhKGP1uhEDEkiXJt0foJenL85tH58fliENWlXe96RrWv/7IPtd8m+Epc4xOkh7A7pukYMyD+y2jjnsK2gEYySzKMrt2yBHObkOJgyJHuGKYPZINElZf8l/RGjhL6U3qxFyUK2EyISQ64ZzbyJ70B4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:32:01 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:32:01 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Mon, 30 Nov 2020 23:31:51 +0000
Message-Id: <07e95f9e92673dc6373e7664f24db6c82ea596c9.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0115.namprd13.prod.outlook.com
 (2603:10b6:806:24::30) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0115.namprd13.prod.outlook.com (2603:10b6:806:24::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Mon, 30 Nov 2020 23:32:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3f9c834-53f8-44f2-0ecb-08d895882379
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509068A5218F55B59FE75378EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbfZkGFZAa/KC1a3OoqPtuRscmOGfzbuLm8ryCFc+GgOc1hY04Gt7vzolNgqaDY1C5ONcBJt6V7plEGV1tkzz8te04+fAFkLn9j78NLXnoaff0brI0YNAvPbkQVbeTPsAN18g+70opabBGk7qi1EuIFODGUPCIcZLOagTT8hVXZ+EkFWQU+/85LDjV9Oogq7TbMsFpLnWaR1sX8hRCSo46C0My/MGMgTKoFvOd/eTUcTIBCei/YYgAnEqpTttKRprh4bkGVKUFLpqPNf3e7mbmPnJj0nP89K4jgtPzbaTxAF902SspECY8xR2j8T3WPSUB/KC/e6i8evW56WQsVdxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4ohkbZHLXIkdiksEUkQmKv2eJQXc+l+dgsY2mYpRqIe2CkXiazVUIQsKLzNO96LLhM+gNZAsqbe8Met4molsrNTVMxbAqtywYpgWOQ7xCqjHN4bxi+BfqoplarA5jUIcFD6xlnqfV8BMMLVE9E6DVJ+OchHxUnn3WC0di8wnibH1aGC2uDeZEbP19NObXrpPBu86g0ZHar0jIRu5JJyanwMhmQRr1qxFkjXCL+11eq1k+E5E1aRax8VqVmylOruAkGmS++uJNI8Y7R1rlTnFzxmHLCDGAZmID+LIH80iQmP1mFFRGecxrL5+mv/LITeYlvA11BIXWDak+6Rd764oBGK+YIfdkNs7QQ8Et/RPznDKOAYjCTBxptephowJ1b92OsxHbE6QgvY3uR47nVcv6pR6rr4QhHHQ7ToBHAFz3/MUIfr5w/WW67YfDmdQTo4GX4ihk8j2qlMowYHC0hJLzfIJy3j3adr6vHGBtiVW+2RzSuDYi+4Xt5eUXT8imXqSp/HJoEDUpJWOqIYypU5jng8x68KQO0c0PKdTzNM33aByLoHvRz+7lvwR1pggQ7T7izK6Vguyreriv/NLLOGvCnBVZsqsAzqH+Qk4WePsYNQDRumcTKUhhAuHQL0kvw2fsATSPvjABeBbccIbVw9hvnpNivKqq+A2d+fsbSb/X+QkXazAVfmO5aTSi4sHLeWp3/eayKNu40f88xS9bhNgKXrJ8LHKqd7lLBMOZEPV+CBCKfKmqjaqWhLFo6uX1ysZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f9c834-53f8-44f2-0ecb-08d895882379
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:32:01.7841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAqT6RRRSHJqTM4qFSxaVensdU7yRYmmZLCc9RTCsaigSbo3kymkh2J76MiHOIaf2iqfWojx3AEYJSH0HUa/kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
will be used by the SEV guest to notify encrypted pages to the hypervisor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..bc1b11d057fc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
+				      unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("vmmcall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
-- 
2.17.1

