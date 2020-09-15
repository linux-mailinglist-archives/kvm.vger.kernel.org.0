Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A118126AFCA
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgIOVm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 17:42:57 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:21344
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728042AbgIOVbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUfJrTYUwym3pep1eiJ8JZ/hfVN2yRy2LJwBGcfTC+naq/ZAm3L8MP5ezN7EO/GpkTN9xMrz0uOyoJsyseEKraXXv1e9BI2Ts89nWFnFhuI7YD1VJGPNBqsXkSHbN5TMdziOSBqu5/GicIq7A2kZ5bupIo9fjKdpDxz/zK0Qp3xsc7NZli9YpYeUcSTfPy0FsS5jkxlC8plRLlSRz/HzrCMPu8YscqRYDNvAWF3JOJpIu955Z5h+CClKPa2Hr/5J1E+V32C3FOT77LhaeBxBa77sr1D2XJ7G8OnU90HQ9Z+ZuTw4uQy31T53G7lcM/DA/oQb+rNzM2zZkMrLDBA2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFI1iSZIUByoFPbo3zOQC+VVjUYP8EgCKTSOqArNAuw=;
 b=Wldf0+x6VTWbsaNh14ILLrUlaeq7gYUw3iyYuJmkz2u49RYHWAVChYyyFoWgfehW6MjCdMI0G+EcVY6dzmwLNWM9pnGq2+d+Vjj624Grlj5C7DeXGrhT4YjlYUeghwQxCV7L9vt0Lpp8LUycBhE5j8SvwuTiFmrtO0Z7ujIhnoKmkPG+r4tqOzOZY3xpx0TffI4/a2XVr4Q+R1bGyWkatCQyjjasK23Ka47YBIdP/Ir3UwWeVJItRyCcXonPWjaezSQzuU1LZiKgLJDKO91NU57p10jdKKvhNYHHy4ncCPmeh4jOVktG96Can78e3CfDLxkjos8WIjgYDqUMC1u1Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFI1iSZIUByoFPbo3zOQC+VVjUYP8EgCKTSOqArNAuw=;
 b=CsBYkv7JgH5zbsyhg+OtUIcBMVaAbB048mSv+lwt0nT4dKseQwc6KreDeDH0I2AL52DmwuOe3wvTWIZPZBD/aTIJ9F3Qti/wTSDv1NvtlX1VRghjDQwJwpinmtckvYTXB/n4w7PJLMPCPTbu0LNGntFua1uBPmlJGAZ52bR7goU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 21:30:26 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 21:30:25 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 3/5] sev/i386: Allow AP booting under SEV-ES
Date:   Tue, 15 Sep 2020 16:29:42 -0500
Message-Id: <9d964b7575471f45c522eea9ea3a7d84ed4d7d2b.1600205384.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600205384.git.thomas.lendacky@amd.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:0:54::29) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM3PR11CA0019.namprd11.prod.outlook.com (2603:10b6:0:54::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 21:30:24 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 889c9441-840d-4d20-bf34-08d859be8f1b
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB160704B9FF19C4EF0DC3C13BEC200@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCdx+RKlpXbUDYOOwCYqzQVbxmbxngkmdJdlld2hyegym5q+jf+UEw0qnwqQ2u0OrGdIsqkWAvnadrObvx7v2vGJ8Y2SK+D6SzqBPkkjmnWNCLYScIVUa5iEcciYZ2LuK7QcHkhKNkZUYgidLUBkVHDRChL7j8sNWJEozxnz00a8I/KPhs/4BR9qDxbNRmm4b6DpVbJ4y7HWmZWMPmYE8mlHcNY9lkLbDm2Y4GUNZyCIEx2YBwbp6aCNi156FdwWe7bOvnDByFdN5ACqfQHpdTV7PPoyeu5OWfUusrTCR8Ne0keSTdklZ0skzsFXF6smJql7KkKBbvYKoDuCE0D49g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(5660300002)(956004)(478600001)(6666004)(86362001)(52116002)(2616005)(2906002)(7696005)(36756003)(66476007)(8936002)(66556008)(66946007)(316002)(54906003)(7416002)(26005)(6486002)(4326008)(8676002)(16526019)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jbOl3VtfwWeptjhbDam0tO1idYtO54FSaLIYhwTLzU+MOsviyp0U9K2qDW21fd9IrkGcN+NHCYW4TgzpJiH7pakZm3gmFFK67UcVmnVSucpoEpDIDPuaDTzw2XFBjkH0xqxiQYnC0sOdCglbN3ZqPe7S82JpeD9aPWU+2fbSms+KHx0r6pvMmKT8o7CoEUpnEv1gD0+PxgCCmRCh7ccwVFelRxfsFvQuH/jGWNy5TG6yKFI7m6VMvK5Cw38Yu8JiMEUhluKMtlvozDTtsMHb1w3uprBTLTd7/xp9rdojgASlnMROx+5z4KXlDsBR8iJSrZfvwOd3z8CITELNqf1mJJu3fDfHpb+Lwgr93xLWLWENEmE8+Qlc7hazEWnc+caufJenUPAHkfo6Mf7mlemm35WaDkKM48rnPdDJeGtRelICkdQ3ETspLX4tkPeWRDOtNKcAjHAvJLqcKpRvJWBp883Rnum5wm5n7Hcz2gClVPjdb11En2zkzx0n865f+3mBAFTmEQM7BSuOhiBkE+rDWjmKoNDNopSFXEulhYIgGgNUGQv260VMsss2v6YCY6QjnnCUPwM11Xe0ke1Lz/WN1tru2f/mhZXZ7sHwGeMz2XU10dBRICudi2U+uiFoi0QqRowRfT3hO5W3ytrj5ZjNSw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889c9441-840d-4d20-bf34-08d859be8f1b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:30:25.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zDfGC+nKp8R6fC5MdqW+lG5cP2FUEiLzTWVAuEmE+93p6U+A8M2ZTJDKrXmG33HgbTT1XtKoqU+I19+XAA9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When SEV-ES is enabled, it is not possible modify the guests register
state after it has been initially created, encrypted and measured.

Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
hypervisor cannot emulate this because it cannot update the AP register
state. For the very first boot by an AP, the reset vector CS segment
value and the EIP value must be programmed before the register has been
encrypted and measured.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c    | 64 ++++++++++++++++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c |  5 ++++
 hw/i386/pc_sysfw.c     | 10 ++++++-
 include/sysemu/kvm.h   | 16 +++++++++++
 include/sysemu/sev.h   |  3 ++
 target/i386/kvm.c      |  2 ++
 target/i386/sev.c      | 51 +++++++++++++++++++++++++++++++++
 7 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 63ef6af9a1..20725b0368 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -39,6 +39,7 @@
 #include "qemu/main-loop.h"
 #include "trace.h"
 #include "hw/irq.h"
+#include "sysemu/kvm.h"
 #include "sysemu/sev.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
@@ -120,6 +121,12 @@ struct KVMState
     /* memory encryption */
     void *memcrypt_handle;
     int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    int (*memcrypt_save_reset_vector)(void *handle, void *flash_ptr,
+                                      uint64_t flash_size, uint32_t *addr);
+
+    unsigned int reset_cs;
+    unsigned int reset_ip;
+    bool reset_valid;
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -239,6 +246,62 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
     return 1;
 }
 
+void kvm_memcrypt_set_reset_vector(CPUState *cpu)
+{
+    X86CPU *x86;
+    CPUX86State *env;
+
+    /* Only update if we have valid reset information */
+    if (!kvm_state->reset_valid) {
+        return;
+    }
+
+    /* Do not update the BSP reset state */
+    if (cpu->cpu_index == 0) {
+        return;
+    }
+
+    x86 = X86_CPU(cpu);
+    env = &x86->env;
+
+    cpu_x86_load_seg_cache(env, R_CS, 0xf000, kvm_state->reset_cs, 0xffff,
+                           DESC_P_MASK | DESC_S_MASK | DESC_CS_MASK |
+                           DESC_R_MASK | DESC_A_MASK);
+
+    env->eip = kvm_state->reset_ip;
+}
+
+int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
+{
+    CPUState *cpu;
+    uint32_t addr;
+    int ret;
+
+    if (kvm_memcrypt_enabled() &&
+        kvm_state->memcrypt_save_reset_vector) {
+
+        addr = 0;
+        ret = kvm_state->memcrypt_save_reset_vector(kvm_state->memcrypt_handle,
+                                                    flash_ptr, flash_size,
+                                                    &addr);
+        if (ret) {
+            return ret;
+        }
+
+        if (addr) {
+            kvm_state->reset_cs = addr & 0xffff0000;
+            kvm_state->reset_ip = addr & 0x0000ffff;
+            kvm_state->reset_valid = true;
+
+            CPU_FOREACH(cpu) {
+                kvm_memcrypt_set_reset_vector(cpu);
+            }
+        }
+    }
+
+    return 0;
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2193,6 +2256,7 @@ static int kvm_init(MachineState *ms)
         }
 
         kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
+        kvm_state->memcrypt_save_reset_vector = sev_es_save_reset_vector;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 82f118d2df..3aece9b513 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -114,6 +114,11 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
   return 1;
 }
 
+int kvm_memcrypt_save_reset_vector(void *flash_ptr, uint64_t flash_size)
+{
+    return -ENOSYS;
+}
+
 #ifndef CONFIG_USER_ONLY
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index b6c0822fe3..321ff94261 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -156,7 +156,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
     PFlashCFI01 *system_flash;
     MemoryRegion *flash_mem;
     void *flash_ptr;
-    int ret, flash_size;
+    uint64_t flash_size;
+    int ret;
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
@@ -204,6 +205,13 @@ static void pc_system_flash_map(PCMachineState *pcms,
             if (kvm_memcrypt_enabled()) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
+
+                ret = kvm_memcrypt_save_reset_vector(flash_ptr, flash_size);
+                if (ret) {
+                    error_report("failed to locate and/or save reset vector");
+                    exit(1);
+                }
+
                 ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
                 if (ret) {
                     error_report("failed to encrypt pflash rom");
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4174d941c..f74cfa85ab 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -247,6 +247,22 @@ bool kvm_memcrypt_enabled(void);
  */
 int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len);
 
+/**
+ * kvm_memcrypt_set_reset_vector - sets the CS/IP value for the AP if SEV-ES
+ *                                 is active.
+ */
+void kvm_memcrypt_set_reset_vector(CPUState *cpu);
+
+/**
+ * kvm_memcrypt_save_reset_vector - locates and saves the reset vector to be
+ *                                  used as the initial CS/IP value for APs
+ *                                  if SEV-ES is active.
+ *
+ * Return: 1 SEV-ES is active and failed to locate a valid reset vector
+ *         0 SEV-ES is not active or successfully located and saved the
+ *           reset vector address
+ */
+int kvm_memcrypt_save_reset_vector(void *flash_prt, uint64_t flash_size);
 
 #ifdef NEED_CPU_H
 #include "cpu.h"
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 98c1ec8d38..5198e5a621 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,4 +18,7 @@
 
 void *sev_guest_init(const char *id);
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+int sev_es_save_reset_vector(void *handle, void *flash_ptr,
+                             uint64_t flash_size, uint32_t *addr);
+
 #endif
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6f18d940a5..10eaba8943 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1912,6 +1912,8 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
     }
     /* enabled by default */
     env->poll_control_msr = 1;
+
+    kvm_memcrypt_set_reset_vector(CPU(cpu));
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 5055b1fe00..6ddefc65fa 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -70,6 +70,19 @@ struct SevGuestState {
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
+/* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
+#define SEV_INFO_BLOCK_GUID \
+    "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
+
+typedef struct __attribute__((__packed__)) SevInfoBlock {
+    /* SEV-ES Reset Vector Address */
+    uint32_t reset_addr;
+
+    /* SEV Information Block size and GUID */
+    uint16_t size;
+    char guid[16];
+} SevInfoBlock;
+
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
@@ -833,6 +846,44 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+int
+sev_es_save_reset_vector(void *handle, void *flash_ptr, uint64_t flash_size,
+                         uint32_t *addr)
+{
+    SevInfoBlock *info;
+
+    assert(handle);
+
+    /*
+     * Initialize the address to zero. An address of zero with a successful
+     * return code indicates that SEV-ES is not active.
+     */
+    *addr = 0;
+    if (!sev_es_enabled()) {
+        return 0;
+    }
+
+    /*
+     * Extract the AP reset vector for SEV-ES guests by locating the SEV GUID.
+     * The SEV GUID is located 32 bytes from the end of the flash. Use this
+     * address to base the SEV information block.
+     */
+    info = flash_ptr + flash_size - 0x20 - sizeof(*info);
+    if (memcmp(info->guid, SEV_INFO_BLOCK_GUID, 16)) {
+        error_report("SEV information block not found in pflash rom");
+        return 1;
+    }
+
+    if (!info->reset_addr) {
+        error_report("SEV-ES reset address is zero");
+        return 1;
+    }
+
+    *addr = info->reset_addr;
+
+    return 0;
+}
+
 static void
 sev_register_types(void)
 {
-- 
2.28.0

