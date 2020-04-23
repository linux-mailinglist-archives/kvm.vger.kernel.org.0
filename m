Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9F11B5F16
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgDWPYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:24:37 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:10485
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729152AbgDWPYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:24:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbpSgPo3FbFFnW40apscAaNlKg/QWvfZOrc5rpLcxnREJQ1G1MczGmdxXApXIEeSAYC5fV/282m2G3IrppRdCOeFoCPSAyIMo5xToT96+mL2QywvAlzI4JgaGZqvhfWWWEQwWwW8PVQgwjOoBrQTL+4qXvdzkgD6LhrqeEqO+LKuJEoz7l50N5rXBBgoC50XSHaesfvgYJ4y0Sbs6f+1TLDdMoS1LU7BIZT2v9Dnfh09Q/MkZsEZgz/WxDuE22YiXwcwW14WfSvAu5twUoY3uk/OAgSXa/AE0sfwGHipVPqgBi32rUh/OB6SiLZd7kdXhSH6hSTs/L7bO5l0ynoc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiyDdcewKqQdfPS/aQehQwnwEd+DRpklXiSdsSapetw=;
 b=AAHm6nf98L4vFUEGqj684Y2v/yAoL/y/cGtHy8KuZUS2OgwS6zFKexLiCuBC0w/2o0pbytgBUFQhDu67NnpKPHI7ehAOqPIPnTcy74PP/EEMdyjxJ5JISr7EVUSmjNuOB1HZ6I8jiN/HNlHfqIsL3bGsTKCtTDygar+PxOIVnQj52uD599V89OdFurYuDjLsW1l5Mh/9+mcAt2KKpRVUKzyo0zzOT2D3jj4Ydua0PKfCckZEBq6E4sHL5vw6W3Te6sH5afNoKtaHCk9ClxuXIANTT47JaGNyh7+2QENNhlNxREP69L0DxjE/jpjsjhk/Hlg3ARJdpkzfmki08GVcJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiyDdcewKqQdfPS/aQehQwnwEd+DRpklXiSdsSapetw=;
 b=WQmrB/5HU/g653bxSknpJMzqb+u+A/oNTswBGj4oG4R+1/mDU+pzoOufX8yDJOdHsiyivVknZzqIKumfWGd6GW4kK5J1TlqCG42SJ1K5KS03FO3qg5i4EzhKusB0HpBswxPheyieMCNVUNjVHffxJrfQiYFNOVp1zu6Nz3S5l0c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Janakarajan.Natarajan@amd.com; 
Received: from DM5PR12MB1226.namprd12.prod.outlook.com (2603:10b6:3:75::7) by
 DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.27; Thu, 23 Apr 2020 15:24:33 +0000
Received: from DM5PR12MB1226.namprd12.prod.outlook.com
 ([fe80::e549:aba2:a697:2b3]) by DM5PR12MB1226.namprd12.prod.outlook.com
 ([fe80::e549:aba2:a697:2b3%10]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 15:24:32 +0000
From:   Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, Ira Weiny <ira.weiny@intel.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: [PATCH] KVM: SVM: Change flag passed to GUP fast in sev_pin_memory()
Date:   Thu, 23 Apr 2020 10:24:19 -0500
Message-Id: <20200423152419.87202-1-Janakarajan.Natarajan@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR1401CA0016.namprd14.prod.outlook.com
 (2603:10b6:4:4a::26) To DM5PR12MB1226.namprd12.prod.outlook.com
 (2603:10b6:3:75::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jubuntu.amd.com (165.204.78.2) by DM5PR1401CA0016.namprd14.prod.outlook.com (2603:10b6:4:4a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 15:24:31 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbcb5e80-e49c-4142-ca1a-08d7e79a6c56
X-MS-TrafficTypeDiagnostic: DM5PR12MB2391:|DM5PR12MB2391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2391C32D9953D7C50905E1A5E7D30@DM5PR12MB2391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(36756003)(66556008)(66476007)(66946007)(2616005)(5660300002)(1076003)(956004)(6486002)(8936002)(81156014)(8676002)(7416002)(478600001)(6666004)(7696005)(52116002)(26005)(16526019)(186003)(86362001)(2906002)(4326008)(316002)(54906003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ng6LnkN1MSQRpHnsMtgu5kcSVkrCaEghyJxXYMrDxcnz/qzru1EXJ7YDvcl5qeOXJSJxx0tnEINoGj1IuH8aVd+tRO54u4NIa0bp4XpJ2fof+FdcxYFU7zK7/IQ/G60+MK9iPR54IbYtsoH/akKfv8khaBZ4qgisM+zyaENclNPLTYoobOUN25s6XiTT0QWMKO/RjEBs6ODPoMywvrE8/SpsGVgqBtL6kKn0rf29EjVDjSvjdpYomaX6eQThv1DNXqxKgvzeduzhT+XVAsIaZN38+e2fbflCOxT8ed8n9rqVLpvC4osi550FMwZ6F2rpAGs8dljYmJuoXNTZJbk0rAWvcKcfrW719eQvtI7LUoVTuPx7/sbprGl1qQT69eAa5610pPn+VGfc37Jt+HkonqctykwewX+TYf9gbXSk632ItZG1kJvPzqOrSIqHGM/
X-MS-Exchange-AntiSpam-MessageData: GUke2vFzBervHXdyj2Pb3QAtsEu78nTUrffjC2ttL9VJLIzYGRR9xk1264E1P8VgmCUmyRxNOnJcV1jLR87MfkXzA+zGIaWJ91ezVgEUoWV+IQUwgjWaOvfrxNgDlvJoxPvdJFzi3S313Yp+2+qLGw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcb5e80-e49c-4142-ca1a-08d7e79a6c56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 15:24:32.8260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5g0mtvCpLeGLc2fc/3rzqfbAi8P5Tb15YRO42aYd9OZ5gv4fUkNddM++7l3N7HWfLd73ibOly2MHT4h9okKFWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When trying to lock read-only pages, sev_pin_memory() fails because FOLL_WRITE
is used as the flag for get_user_pages_fast().

Commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write
'bool'") updated the get_user_pages_fast() call sites to use flags, but
incorrectly updated the call in sev_pin_memory(). As the original coding of this
call was correct, revert the change made by that commit.

Fixes: 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")
Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cf912b4aaba8..89f7f3aebd31 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -345,7 +345,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return NULL;
 
 	/* Pin the user virtual address. */
-	npinned = get_user_pages_fast(uaddr, npages, FOLL_WRITE, pages);
+	npinned = get_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		goto err;
-- 
2.17.1

