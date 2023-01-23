Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1587677B71
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 13:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjAWMrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 07:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjAWMrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 07:47:08 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2090.outbound.protection.outlook.com [40.107.6.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B526E193DC
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 04:47:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNIAx82Wy8cVQO5sD6TyDyI7YYu8rI4K1bc6NmibGFjucZiOAJvCHbhnKBkkbnlcYBnzlq7AhTh3vIz1byz6qiRZlEkq+Yq+GiTpJ0yWSYpRI1HAGd9cEwDss/e+ORL8MpGZ9G7x3Mr5L+lY291do8PeVjjItH66EMevQnDt+ICYg8yYPLil2/XVfBzK53eUuRJmgAm2nCPm3aCRay9DserhXj+HvtJUE5LfJQlDueb1wyp66plI/XUdFzrRObTOj/AxHy1Q9PrP2pm7Q6qOtPKFxvG2lesZnq3UMwm8JBug8BcLolerKvEsy2JZ45BHCFAf+ateHVRLFHho3B635A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zigxAARXbggF6ZBnZe5CFsk44eQM5fTu/prOISve+IU=;
 b=MQzMo1feyzwXIhtpuAB8P0INNyPh2F3qpiQpxA0drHC/QXjh0RHaoQLgiyLF8fhXP9BaugyzUmJuZ+6Y7/9KxgmMgH4ITo8s8J/l/3kp2WYiP0wWqAswxfuKlCLcZZLZdTWiiTmIT4t9Iem9J8pKrvsC2UxDyOy9+hCwXWJjlSbPa2WiuUULnz1N71KPxke1gVQngRzVluAPpE0H/zOj/iD9FAsldlaC5HCsUWQuAyA/u9vzEpSGtOnWu30fSi+9EqqXMt+LfkAM8Uf34BIXw8RyUuCkoT5rK3qykNKiLe8VD5iSy74HJi6kiHL6Ov3F6IPr1OEttjrIVOWTeaguvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zigxAARXbggF6ZBnZe5CFsk44eQM5fTu/prOISve+IU=;
 b=kysx4ZDhpy+48OnX7bJ0nrwgJefvLGqYgvH++yyFZX+OC00gmaDUXaSA39iyrT9/VlG9RurIUYH1WfHLc1oZvxj+Np9r3ePqai0ppD525iYS8nRnM9xhjFXmM2FnbDIzIC5aLl1wnIgkl4MH/t7oK7F1ZOxwEVbSVFO17sBGG3bw6eZIh8YKInkTcURCzfLF5clCSTMogYEqWlPQ+lEcWV6tG8GHWniyFtj7h9Z2PnwkB5l/S2Qk1hvFfjYATQlZlsH7aLBv2TivpQtc03Dbmpefg1HN7bQB6vRI1Um+K3eptzWONmhFGHhFymbb4its3aK1W6gXMhVhS7s8zXdImg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9401.eurprd02.prod.outlook.com (2603:10a6:102:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:47:00 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::e4e:96d4:38b1:6d%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:47:00 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
Date:   Mon, 23 Jan 2023 14:46:41 +0200
Message-Id: <20230123124641.4138-1-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0088.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::14) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PAVPR02MB9401:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a34f16b-485e-495f-2326-08dafd3feb38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szBwC8wfDTKMB/MJgSvFAo3s9Z8G+Do/ncjEKc/ty38ibh4Z0O+3aVN2bniEtVEvMMfzUoDnN5qcs5o/ZwHzvnxX9vuSrEc1O806Dm7OXAOyQxRo6kWLFbCL2wAKdZueOKBTY8Xd5qNvx9NKbx1mV2t/zQT0qRzY4ZNo2CdG4xj2V4mWUcLYXcT0mBnmJhxi8VGO/XVvXEwGypLLXeKMe7chKs+XrHp0Xvw5JbE4JNkpnxjxzYO/WoYE0u1vjn8NdsyMszDjY2aCGB94LBAKaChTUFwupFk+3prx5wd/bswBoSSyg6qid+tRCRPuCurSD+VOaL1empYEYjP5u/t3CwgjAFTdWUIsokk+xFe/ZDDPI8/p44uxP/A2z5Tt9uDG6y4awO3fvdPm2gkacLjdhaCiVVEFQPy9aYC/iMzH449VT4yDdFATAbFYYtoPct0BbqqfFSemIZ4tvExjEmsFhLomAmFA0rYoJ2KUcTa+YNWZAWmeTms53DykP5AZA3pLRFS+WnrdMqf/PphgF8/LgTOjXWabvsVddyCWgFgYBmcYS7ln1YXYydELEtqcaIp+DfB1mHkjY5tLQKVxx0gXr4vxpvGMTVUcMlSEdpqjcmE48RFz/sqAnu4aLRFnS+/eJr75HuxeC2GmD5kHkHmzXOTtpeXmSVHL6sbYcFaVWcA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(83380400001)(38100700002)(5660300002)(86362001)(2906002)(44832011)(41300700001)(4326008)(8936002)(6512007)(186003)(6506007)(8676002)(26005)(6666004)(107886003)(1076003)(316002)(66946007)(2616005)(54906003)(66556008)(66476007)(110136005)(966005)(6486002)(478600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a3WQA40MFYwWW3gcG1kNF+ZfNnp+hEAo9frj4tcOnIxeb5ZVcqQ9KxfmWc1T?=
 =?us-ascii?Q?UBOyIfLSLxsr8JoPiaxXTvRy8wSXuLap0J3mvyakH4UzahJZbNgfqozxnmyZ?=
 =?us-ascii?Q?OSsedbR6tp89PJVCUghvIBHQoRd9tUVdyQEtLTBysLzMeAC2iGbQnXWbYSNs?=
 =?us-ascii?Q?HpGVwd+Ilh8/2kNlUwFT5W8JK8T9qiMaFZThwzpD9APF11px5kRVWAVAiU5z?=
 =?us-ascii?Q?UVhwruZFXv+6XckweVOzLx+CW3HcQfG3q/NvbW/5TdoYdHJgYz/5KQlxZt+a?=
 =?us-ascii?Q?0NSjWNovTZ6MYt4FvFOCycgY1YjYuHNap/i8pJjjoYEex/LsY7XTWsVCwToU?=
 =?us-ascii?Q?R8nOx2jdiuk07szw+ZCPGDXDQrP3O6/bRqVR6yE1XAGJFZqM0cYZFCT1lklA?=
 =?us-ascii?Q?ADZ6nFHvximFvDstevHMpsdE8TkGmmnBAEWD2qZVd1QlbCxTQfYO6r643YGK?=
 =?us-ascii?Q?aXSQ6ngRe3cCKYSUVHkCruOcqyRMdJIRDfHGyw8PEty4fDMLW0A9/KquiOTR?=
 =?us-ascii?Q?o0GlEfre4OW2Lt8HdKic3wwOyk4pLrKS+hwApj9tnAQO1/ZbinIqBxQRt6DQ?=
 =?us-ascii?Q?XeMV7PiOdwFPwu0STEfocGKDRGnLwZ8lYoLWPYcqv6mOVusEAwPLcQ1RByKv?=
 =?us-ascii?Q?iYqEUkwZj9wQt5KUgE9Us3MBjpPuPzh7o3kRxPkd6J5p9jb06P89r5AtPScU?=
 =?us-ascii?Q?ZYUsxJiEL3cdJtMIqj6W73i7lkH4kJO1VV5dD9bfcNdObINEQMWChjHoMDF0?=
 =?us-ascii?Q?HXwFMjofkoqJ/FmSG7vOXJ6YSMMpZaDUnnwwka8n3KPBcfRLDkq6H/tCWI8x?=
 =?us-ascii?Q?sQu2xlwrZobDMdFe7aOUz0omXEFCR+cCQ0pVFI4+ua8LbrCyHqtnvhdFVuz8?=
 =?us-ascii?Q?S8MpxbRyz9s896fJJMxHzTbQaUCzgWyPlGdryynRnKKyAWzJf+1ICFhETT8H?=
 =?us-ascii?Q?mx1F903pkTSdxvmNFqBWlMMWeVV/pdeEL9mZ9AgZ1hopgXgLH2IACX0tiRmX?=
 =?us-ascii?Q?Ft+31/1EUr12m7AEFO2rYrkiYMc/t9Yx12oApUXT0y+zd3SYdBj1h6VcIYKI?=
 =?us-ascii?Q?V9/JxNzhHaYwUiOq2JM2WPOuBfWhc2oSEDkoyYd5rbB1kNwAfr/SxKLblvTe?=
 =?us-ascii?Q?nI0zHHpU9M87kJqsMyfKj/BHUx1YXQgOxg2kswM8pkap/Pc2vYl4G3LTl2gF?=
 =?us-ascii?Q?0EvIk06w0Inj3jVKg3ZUFEOP5IUQ8TUeKEdKtp+IImX9VdiUYILKW22k81PO?=
 =?us-ascii?Q?rhn7mEWwj86TQaR7FazLwL1sSk1cxoQIJvoDY3F3LJFOa4R5QBRzjZQoWTPs?=
 =?us-ascii?Q?cb36z9R4I3nBOZE6wonTnedvXNYrNT0+WctJQJoW38S6GGOtrL/dw9SFz1vs?=
 =?us-ascii?Q?DZ1x79lk554kO4TmpG1VRepK2zVWgM7L7hLlzF+WjIbGhPGZ1jS3OXa7HOMF?=
 =?us-ascii?Q?m4/dekZ/sj001TiTGp9oOlfn2oX3aiIrplNiZVePF76nLHyupXBYpEEsitAr?=
 =?us-ascii?Q?AoapR/Hha0KUbRVozPhiTICrQWhykUUieSk5x35T8QuoqPzasP0sQwjFlHE5?=
 =?us-ascii?Q?zAd6akvvzhvotJQ+lb8jZzCEPYCriiKg+JCnsNIK/DIqPCuc2AHs6QEnLK13?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a34f16b-485e-495f-2326-08dafd3feb38
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:47:00.0250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOVkq/6kR5YDAHR4tYDcb+mHZuXx56v5Dfc5RloLodSvFBIc8DS5UHX/nLPnfL+OGzHZgHDXcvFXrrGBqnjKFo12f4c0uQtYvPaZ0ARWwOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9401
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
that the msr bitmap was changed.

vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
-> vmx_msr_bitmap_l01_changed which in the end calls this function. The
function checks for current_vmcs if it is null but the check is
insufficient because current_vmcs is not initialized. Because of this, the
code might incorrectly write to the structure pointed by current_vmcs value
left by another task. Preemption is not disabled, the current task can be
preempted and moved to another CPU while current_vmcs is accessed multiple
times from evmcs_touch_msr_bitmap() which leads to crash.

The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
solution is to use vmx->vmcs01.vmcs instead of current_vmcs.

BUG: kernel NULL pointer dereference, address: 0000000000000338
PGD 4e1775067 P4D 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
...
RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
...
Call Trace:
 vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
 vmx_vcpu_create+0xe6/0x540 [kvm_intel]
 ? __vmalloc_node+0x4a/0x70
 kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
 kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
 ? __handle_mm_fault+0x3cb/0x750
 kvm_vm_ioctl+0x53f/0x790 [kvm]
 ? syscall_exit_work+0x11a/0x150
 ? syscall_exit_to_user_mode+0x12/0x30
 ? do_syscall_64+0x69/0x90
 ? handle_mm_fault+0xc5/0x2a0
 __x64_sys_ioctl+0x8a/0xc0
 do_syscall_64+0x5c/0x90
 ? exc_page_fault+0x62/0x150
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
v2:
  - pass (e)vmcs01 to evmcs_touch_msr_bitmap
  - use loaded_vmcs * instead of vcpu_vmx * to avoid
    including vmx.h which generates circular dependency

v1: https://lore.kernel.org/kvm/20230118141348.828-1-alexandru.matei@uipath.com/

 arch/x86/kvm/vmx/hyperv.h | 16 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 571e7929d14e..132e32e57d2d 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -190,13 +190,19 @@ static inline u16 evmcs_read16(unsigned long field)
 	return *(u16 *)((char *)current_evmcs + offset);
 }
 
-static inline void evmcs_touch_msr_bitmap(void)
+static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01)
 {
-	if (unlikely(!current_evmcs))
+	/*
+	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
+	 * always operates on (e)vmcs01
+	 */
+	struct hv_enlightened_vmcs* evmcs = (void*)vmcs01->vmcs;
+
+	if (WARN_ON_ONCE(!evmcs))
 		return;
 
-	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
-		current_evmcs->hv_clean_fields &=
+	if (evmcs->hv_enlightenments_control.msr_bitmap)
+		evmcs->hv_clean_fields &=
 			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
 }
 
@@ -219,7 +225,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
 static inline u32 evmcs_read32(unsigned long field) { return 0; }
 static inline u16 evmcs_read16(unsigned long field) { return 0; }
 static inline void evmcs_load(u64 phys_addr) {}
-static inline void evmcs_touch_msr_bitmap(void) {}
+static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 #define EVMPTR_INVALID (-1ULL)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..2a3be8e8a1bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * bitmap has changed.
 	 */
 	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+		evmcs_touch_msr_bitmap(&vmx->vmcs01);
 
 	vmx->nested.force_msr_bitmap_recalc = true;
 }
-- 
2.25.1

