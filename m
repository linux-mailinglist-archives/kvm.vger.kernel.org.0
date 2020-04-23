Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15471B5ACF
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 13:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgDWLzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 07:55:04 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:6148
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728184AbgDWLzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 07:55:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0wqhdlRK6wajcXcZ4pJSck/KFfYrPzFXYmLrBxoC3hqoCsiRMjtS35tAl8LjKRETUnCD1mYAslwBQZFeUAvFXqI+arEQVSsf+uVjcMq0odAgmOBnCjO+bTvk2xDHzve1aX+h25hBAs9miwLjYKM5NQTOfZ2fp1AAGJWlA2WCAVzgtlPRtjkjyD2MNc4dDkO7/GQPIcryZB7s743y7SGuNdJizIJyO6GTzjqRZsCUgPNG7yj2qLBTw6CB8MRwtaXS+KAIXEEc0sipVEAB80yzlj2Iz4RDIwzuOZPcbpE2/QYvmZKj2XVJuvZd6InSDc0kHdDiBmoqtvijtrIhZR2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hd3RMYWdsXRS2su3Vh8lvNSe71o6oYSHooHzyUB2Qzg=;
 b=cJZOg5IFj/KEnUTVOoAzL3Wxcib5W+LtqPbp8tqSXUligz6W1kOFuq/tlWRnslV8KoTrs56mm5LzAayBjve7apCg80T4qCWEldryUOmWTL9f3UGr67aFvW1NIwP34JtB54s9cCcEut7XuXo7ou0h+SVdpugEL8ZiVUGgcIAsRBX5Jxb0EZj2cTJ5BGJjbjUJQBvK2gKd3S2AOX748xc9I31RAuckgLHovq7+aIy5Ba/RDI9uP/HqrDhWSkAzCPnwyK3TWHXioAFAeg7KG5Uk98rKPH0rRyripwIWSOsdCL6VSTgXcKEZ73avi32pdykqejhxsFwu6RkFNgyl6jlfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hd3RMYWdsXRS2su3Vh8lvNSe71o6oYSHooHzyUB2Qzg=;
 b=Gy2ZCptDZ1eOyRE4y1PQaA0BDaA5tBQcKaVXSdINnvkDh8tzQUVQE/JW1nUDuqarCgc7N93u4pmGsH3f281/Sig4OR7XoRoUmC5/8PY6ZuDiSVOk/d2U1uPtTrpQFrphbjfBnKHx7H2EqG+HT0axj0/CxeDvDB8rp+BRANUOILM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB2519.namprd12.prod.outlook.com (2603:10b6:4:b5::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 23 Apr 2020 11:55:00 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2921.033; Thu, 23 Apr 2020
 11:55:00 +0000
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     "Boris V." <borisvk@bstnet.org>, kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
Date:   Thu, 23 Apr 2020 18:54:39 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0601CA0002.apcprd06.prod.outlook.com
 (2603:1096:802:1::12) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:1548:45c4:8dc6:180b:453e) by KL1PR0601CA0002.apcprd06.prod.outlook.com (2603:1096:802:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 11:54:58 +0000
X-Originating-IP: [2403:6200:8862:1548:45c4:8dc6:180b:453e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea1bbb08-e928-4df5-4c04-08d7e77d266b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2519:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2519EE0EDB1913C934BB3700F3D30@DM5PR12MB2519.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(478600001)(66946007)(6486002)(6666004)(66476007)(66556008)(6512007)(2906002)(8936002)(8676002)(81156014)(316002)(5660300002)(44832011)(52116002)(36756003)(31696002)(86362001)(53546011)(2616005)(6506007)(31686004)(186003)(16526019);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpElQenPVc8gLL0NHxMzbt+L9d0QBhbyypLXGPNS9a2lS10tO+/bT1f7IAozGo2qVxl7CubnatgKcyLFGT8khisBpILYHZ5U6MO2/53pEWFNvoLZaEudMFsdDZV4V0CRwstwA3F8Oyfxk4/7m1rr2WNYjnp+FYQRXS5mrdbYYJ0j+9QEA8HDjZ9MG++tYLBr8WYmehbIMwfovoKkutiFwyyc7QDMTSLDMG5oRHWSya7fJ5uJLsZNQ7IWHFyNYxMnTy/fL4KHJ8hINAFXMjfb36x3DcCSsQmi5Wco+ClVHib0HfCOWjktorIr4reVILig5R4ngleUNzZOXM5AhDrQ92CxJ2CDvd2mgnDyXTfdP+v7GJyLHIvbVVLo3XeYNt9A5Z5fuCrfzoVX4f6O+UkosEo46FNNpV49MmUJao3iL5F6X1GSNRtugRTnCmYXGOKq
X-MS-Exchange-AntiSpam-MessageData: CwUkSJfZdEUX+Njvj1Oxo9QsqVz9bYG7k1IVldeoOD6cFogKIhSrENDVFpdBTQRCw7SF1lhFEHq9CqTq6lC8YXA5GiZi+JbWJCaH3T8O248ByxTPicT6uvf8wWa7ueF9qx8IRPHkAakGFs7x0mKhUODbnE5TBSFCk1DZMSz5hVvHfPyeFY4SsZKoWNiFmb38e2BnxODzoNXpmgw47IzAhg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1bbb08-e928-4df5-4c04-08d7e77d266b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 11:55:00.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40CR2oYUjxw6vkM74DPlCvIPTVXdJo32d4A/afEoakWF7VHBpgLPipvLnGQVS/QeH+GciP2uWTDahef0dmTrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2519
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Boris,

On 4/22/20 12:43 PM, Boris V. wrote:
> Hello,
> 
> when running qemu with GPU passthrough it crashes with 5.6 and also 5.7-rc kernels, it works with 5.5 and lower.
> Without GPU passthrough I don't see this crash.
> With bisecting, I found commit that causes this BUG.
> It seems bad commit is f458d039db7e8518041db4169d657407e3217008, if I revert this patch it works.

Could you please try the following patch?

Thanks,
Suravee

--- BEGIN PATCH ---
commit 5a605d65a71583195f64d42f39a29c771e2c763a
Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date:   Thu Apr 23 06:40:11 2020 -0500

     kvm: ioapic: Introduce arch-specific check for lazy update EOI mechanism

     commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
     a regression on Intel VMX APICv since it always force IOAPIC lazy update
     EOI mechanism when APICv is activated, which is needed to support AMD
     SVM AVIC.

     Fixes by introducing struct kvm_arch.use_lazy_eoi variable to specify
     whether the architecture needs lazy update EOI support.

     Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
     Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
  arch/x86/include/asm/kvm_host.h | 2 ++
  arch/x86/kvm/ioapic.c           | 3 +++
  arch/x86/kvm/svm.c              | 1 +
  3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f15e5b3..a760ebd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -980,6 +980,8 @@ struct kvm_arch {

         struct kvm_pmu_event_filter *pmu_event_filter;
         struct task_struct *nx_lpage_recovery_thread;
+
+       bool use_lazy_eoi;
  };

  struct kvm_vm_stat {
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 750ff0b..baee8793 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -188,6 +188,9 @@ static void ioapic_lazy_update_eoi(struct kvm_ioapic *ioapic, int irq)
         struct kvm_vcpu *vcpu;
         union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];

+       if (!ioapic->kvm->arch.use_lazy_eoi)
+               return;
+
         kvm_for_each_vcpu(i, vcpu, ioapic->kvm) {
                 if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
                                          entry->fields.dest_id,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 13a5bb4..a3d45ec 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2267,6 +2267,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)

         svm_init_osvw(vcpu);
         vcpu->arch.microcode_version = 0x01000065;
+       vcpu->kvm->arch.use_lazy_eoi = true;

         return 0;

---- END PATCH ---
