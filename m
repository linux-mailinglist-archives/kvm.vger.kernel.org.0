Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B2078ED06
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbjHaM1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 08:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236997AbjHaM1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 08:27:09 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2180.outbound.protection.outlook.com [40.92.63.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A931CFE
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 05:27:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cphSwNLWC383dR53eWe5bgieG312GXZvIqHrt98R2iOBRJ90Y1FBBrcxgjYICF60xhBQvc+HIQGvf9GUsCuUGWwfFkkUEKmzXglzU9mehaiXh87D0ps8SIwMt/a0RpkEi3+EwZii8pTFAnEmo+B8mw/8kcB9bY6gMXe0xx/Ybqf/AtFV3YSfQkAgSdB4zlPhN6iOXwz8MrDhkpMQZRdstTaYU7zPJE561ngTKmXcTMTL8ZSBU4Z+Umfy5E4tliYJonzNkjnit7J6dAwOAP3pc7Gis6460JoQZpiS7Rv5YPcDHDP7YoMWxloSrzRdZL7MrIYrK937i5YmKFcPBmW+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wz0kGFxJFSVJ5J52iZ+dQy7KFihANeU2Hz1M+6H5XxY=;
 b=Jdh2CLG0RsUM9XivTQw6gVnwQ/n4qV9dCGUI78h9jyYUNxbzpR0N4G9ypNyptnnfWmgJFrhn3d/sVvEwjSs4w1mRNpcROGeJlu7RpZRVoWt/39bLtUYvtP/ZmY03hBu9QFiN09vO2Ka23FhOnGzTWrrCvUQvcv5N7+N/oM2zfLuznJCuy0Py5O5K//QmhB+4KevvevoPsGLIeCpv+mxMX4Wg3vdCiAhS2Rd8np5L8PTy3WOvyqZBVYISD5TWEqE1wesLMx2Cidzb0zXiZ0FXz72xAiDjjwDY9RlyLaWZ7kjxT2WUQ91LpkCT1c9/qnjaf57UY1ZaMJwwzFvzyY9YPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wz0kGFxJFSVJ5J52iZ+dQy7KFihANeU2Hz1M+6H5XxY=;
 b=G2HlNzzntMov4ORRBJZFI1Vk9CDhHLmQU39fgkjc9LTisLJxRHu6VE22YRLLpa3c4U3+EsNuBFoyii/SoTaJ2iLHyr4WwtWccd9SHO4wTEyTcP7zQN7HBmg4YQGfvBS2wwGLvJoBuKD/9jhuWynqnKCFCUyW4i6I9gAEB5uPSlnIJm8IpMfOEji+bVkX5g2SJo8/aLNXRLaha2e16zDXU+vDouGDmsA5j68rxBAe+VO6HnBibqx+g0/h4StcN9joALURs3PlVf/Bst/HwkJ18IIsm51XFGsiDGl7CHM8oENf6ccWgRuj9YSWz9/5e37uxJwriLAtxfAkYEbHWBRAhw==
Received: from SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:71::12) by
 SY4P282MB1529.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:c6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.21; Thu, 31 Aug 2023 12:26:58 +0000
Received: from SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM
 ([fe80::3684:1d09:7a6:1fae]) by SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM
 ([fe80::3684:1d09:7a6:1fae%5]) with mapi id 15.20.6745.022; Thu, 31 Aug 2023
 12:26:58 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH] Add kvm_arch helper functions for guests' callchains
Date:   Thu, 31 Aug 2023 20:26:23 +0800
Message-ID: <SYYP282MB108686A73C0F896D90D246569DE5A@SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.41.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [pOW9eWBLG6PVNxFmMj4JpVHEekn6mAJpx+ZK3Fv9IMcjNSYzzwY43Q==]
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:71::12)
X-Microsoft-Original-Message-ID: <20230831122623.21446-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB1086:EE_|SY4P282MB1529:EE_
X-MS-Office365-Filtering-Correlation-Id: 914f1d6c-d3fb-4283-a9d5-08dbaa1d9033
X-MS-Exchange-SLBlob-MailProps: 0YULWdH+7mBkQSOA4wW1Po1Bb9pHfjpyxUPXticX/iJX2aY0nVgVfyKQotG8gmCEkIKSBI0CNZEO1NSh5kF7VE40hpn9HFr+GNerPL826l9ZmesazB5Si5eRVYzYH/La4yk9Lnz/JCFwGItayZUidvXj339rDXrQbEdbaJzFYduCNUFKEykOP0Cq2H8VDmeDnAbrFmsB4Z2opYJlab3RhDOGE6wrS7H0W6LXuuAhMO4aEoIInI/PMWLD2s9CN2N6e4eGE53EYB5YB/5nPxh1GoYzXXIegyubJw8PppFt27qs0yxAo7mTehdh30YS183lgnuteyDoxqj+ox5Be/xZxoatUcMFj7/hQESafiwMXsKBZMo0s4DIS+EMf2XDSdt20JBFnRUwY2sIBBHZcRfH7JxuUKGjrffYJsdBGHrmu2rbnbpwcswT0LrmVlsUOwLZIq/k5nVQBPx/SWkc7sRWVw2UpuxsoAUveBPMG/+g7Oomq7a6U4ZbxHEtTgxARf17Ugrid8L7L7WDgRnK++PwRbv/qg/OAdjOa9WmMhbRZaBuKOK8Y5jyCr8/40mJLvbnNGfIA+6susEznkcdqBOEBQTZVi5zkUSU2ZSCrySzUVMgDPKCX4jWZJknGdWUENvc1XiMv1TNnZO9qrznMOeIsxPr2EAlaaKDXzzIOY0m5spLmxvZFB8VjwR8CKIyfEh4dLx59+/aCgc+FSR//ae+PfvLrpYE0nyNeMGoVSeO1hXIXNHUYm6t7xt4rxnGzXw1yV+srQ0uI7/kxrN0KIZp4rvDZkf15kfMl5xITlX3r4hAon2BNgku/tyOK01Oq2csWZpqJX0f5LhbJEan9EPXqkZMMnZRf61rk5uZ5JzYtRV590YbuIJxow==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwxrKbhArBg8UgGGMKFjjEgREXLonsculZ0EDE+OsMRUummCBbfEzGUGqPc2paQaSrjtaLUTPD2YupkE1Inu7vxZBxqq+kl3eia4NI1aHhi3L12TGUeRQ5uriL7QDUYYyp8ofUac/gy0OU9dD7sk/0eswpv2BLi9ITxiLzSSDNcFPO29oMAtAF1VSp41C7itKD5IaK6tCw6EwTr1aTucKethwPUZZu1JOvBnbmln8TDXAAWJIJ8Ik1ZU1Gl7v9h+FJyEVjyCxQQ5Agxzd43ETCTmEUbMVNq7D33GIjY1zBiqa2vdkHA+EL1a6efMXR8Y9tbOhzoLxqapQNUiuhgTTgwpcwTx3Wa0lIqlBtcZYH4fLLsdmpZ2ey6gq2TPqqoF/FbUOfcLgQ03VGHUvsBdWTbuLsE0Nu+rLTpWHApkg3bGeHCVCSGtzT2fsPT/kdhW+YuCra3EE3baV3WEYywop5oW3XTHwQIyjKkIHT+JcsHqXif78UTCYbyoEE2rdGr6g1WRH2RW4O0eHwO2YsOOf6JAx9Cekdap6x3iW16N8Vg9Jsq41JnV7uaC5Y5OX4jlxlLRv0S5hcuYB4XtBl17VQWcIDUd+8Kv5tPsqfcR8oo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AN5yuStmywdkK7PJQq9OwSCpsYnnt61x0qjj/TEkDhZy13lX14eBd+zWMVGt?=
 =?us-ascii?Q?STR9rhllMAdsKYHedS04SP1TCsVDoAOS6bIA+bnjf6CTll71wscowU3LTbVE?=
 =?us-ascii?Q?W8s+HGWmLSd0C5cxnJL0LQuh8Ppfa3yBF5wDvy4a8VccCqJDaSG5u0BvlwiP?=
 =?us-ascii?Q?AKuxbL/WUlWBF6inhgrR9s1QCxMp0FhoZ7ux7g/gX1FXQQpbZG+B7TSlm3CX?=
 =?us-ascii?Q?twI+UTqVogwzqpDA/64ksrzVHfQS557uKuLcqdZMRgorhIlReVsLXhpI8RK/?=
 =?us-ascii?Q?3uo+vwtlKglvo6bRw1e8r1HBeWDOX+qibcsUp0h3UIsqK5FOcM2JHMn+5jA/?=
 =?us-ascii?Q?Bot9D3Ke6lxbIGpzFrPRiSTXddmnB4cG6HlK9KY663ac3uf8gD8FhwV49nsJ?=
 =?us-ascii?Q?hPNH5ens2WGtIWLRSN6CV3lQyDr36U6YDdqFZdHvKTHazVzZXDnV6sVHRNLo?=
 =?us-ascii?Q?z+cwJF+xJCb8KHr0gB3b3ScDJa6k6Cdt3TlrA4/kBDLsLcqAgZVdQtaZX/+y?=
 =?us-ascii?Q?RRGKn5F1rMT+9Pqqc8X2ykI3mCELqUaQxqIAUKj9YAqJFkSFw6K8hKykiYLi?=
 =?us-ascii?Q?eC/bq4mDcMQ/spAIoqx1KIR/vRZUeE98sgnlJrQvp/zCe4bAPhloVytVfkBq?=
 =?us-ascii?Q?nOU9AJsIgoGqiqiqVhUYCi+z1hwyG45xBf1z9to/vfE6hXT/nwQccqCU543g?=
 =?us-ascii?Q?MbW3718WqQf7jzfXHCvqnn3Ed5XRrbifA1vn35KzFVSCtkUMsYrpgGmPEAxm?=
 =?us-ascii?Q?/SzUNfKsL1P4RAOWy1bU4/289F/ky4tHLlBRitdPfC2Y1B/Fu026z6hI+bfO?=
 =?us-ascii?Q?Gc0UgN6JoPk5tq00lgPzG0ViMGthQpnsYVSMKmdw8WrVX5nJEgUzRMDU33Wz?=
 =?us-ascii?Q?0oorbPtcc3/lCB+PLVYC6vAzF2Si3k//wFUP3CC2RsFryNlgmu7IZVv34OWU?=
 =?us-ascii?Q?pTadWIOgmMiOKkyoEL8ENmaQtdUeDK2QpHXTz0CN7XmENGmZ2/ORhqaMEayp?=
 =?us-ascii?Q?SQVCsOi+08srFRFvFZsaIqTcBrDPCL1qg9mwhygYYppeY5lRDuGuRoGumD+v?=
 =?us-ascii?Q?WCNiKEVXOr3QUMJ2XffmG+hyl1t0Xodk5gkK6zST1aVdL8ftdNqUp1ZRyhv9?=
 =?us-ascii?Q?E0/eWEpFeZ8hUo9A34OWzT0druC5yt2eBTtRvG5EP0oN4+shg3HfcHEWrmy2?=
 =?us-ascii?Q?smloIoDJfqZYpOJ6xUmlWeGtNmK9M9Q1C/D3X0MDzFPy0+Juke2JJ6CWW612?=
 =?us-ascii?Q?qyyywuWwMpuFSKSP+3eO?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914f1d6c-d3fb-4283-a9d5-08dbaa1d9033
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 12:26:58.3153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1529
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean and Paolo,

This patch serves as the foundation for enabling callchains for guests,
(used by `perf kvm`). This functionality is useful for me, and I
noticed it holds the top spot on the perf wiki TODO list [1], so I'd like
to implement it. This patch introduces several arch-related kvm helper
functions, which will be later used for guest stack frame profiling.
This also contains the implementation for x86 platform, while arm64 will
be implemented later.

This is part of a series of patches. Since these patches are spread across
various modules like perf, kvm, arch/*, I plan to first submit some
foundational patches and gradually submit the complete implementation.
The full implementation can be found at [2], and it has been tested on
an x86_64 machine.

Specifically, performing stack frame sampling for the guest OS requires
the following helper functions:

* `kvm_arch_vcpu_get_fp` for getting the frame pointer from guest,
such as `rbp` in x86_64 or `x29` in aarch64.

* `kvm_arch_vcpu_read_virt` for reading virtual memory address from guest,
used for unwinding guest's stack.

* `kvm_arch_vcpu_is_64bit` for checking if the guest is running in 64-bit
mode. Stack unwinding needs this to know the size of a stack frame. This
will be used by the `kvm_guest_state()` interface.

After the arm64 implementation be ready, I will use these in
`virt/kvm/kvm_main.c`, and add two callbacks `.get_fp` and `.read_virt`
into `struct perf_guest_info_callbacks`, which will be used in perf.
Sean, I noticed you've previously done some refactoring on this code [3],
do you think there are any issues with the way it was done?

This is my first time submitting a patch for a new feature in the kernel,
and I would greatly appreciate any suggestions.

[1] https://perf.wiki.kernel.org/index.php/Todo
[2] https://github.com/i-Pear/linux/pull/2/files
[3] https://lore.kernel.org/all/20211111020738.2512932-13-seanjc@google.com/

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 arch/x86/kvm/kvm_cache_regs.h |  5 +++++
 arch/x86/kvm/x86.c            | 18 ++++++++++++++++++
 include/linux/kvm_host.h      |  3 +++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 75eae9c4998a..c73acecc7ef9 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -133,6 +133,11 @@ static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
 	kvm_register_write_raw(vcpu, VCPU_REGS_RSP, val);
 }
 
+static inline unsigned long kvm_fp_read(struct kvm_vcpu *vcpu)
+{
+	return kvm_register_read_raw(vcpu, VCPU_REGS_RBP);
+}
+
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 {
 	might_sleep();  /* on svm */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c381770bcbf1..2fd3850b1673 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12902,6 +12902,24 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 	return kvm_rip_read(vcpu);
 }
 
+unsigned long kvm_arch_vcpu_get_fp(struct kvm_vcpu *vcpu)
+{
+	return kvm_fp_read(vcpu);
+}
+
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)
+{
+	struct x86_exception e;
+
+	/* Return true on success */
+	return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
+}
+
+bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu)
+{
+	return is_64_bit_mode(vcpu);
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..5874710f3691 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1562,6 +1562,9 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+unsigned long kvm_arch_vcpu_get_fp(struct kvm_vcpu *vcpu);
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length);
+bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu);
 
 void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
 void kvm_unregister_perf_callbacks(void);
-- 
2.34.1

