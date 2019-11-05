Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33FF05CF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbfKETTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:19:22 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48640 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390878AbfKETTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:19:22 -0500
Received: by mail-pg1-f202.google.com with SMTP id q20so3148938pgj.15
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X4a0tiRiKuTwKKaD0bjI7X4v1uWCRl+63mSdCrFaD3o=;
        b=S3gsOIZ4mwIwfT/aWElNMrK7SlnI2g3LRc2mURyIe5osjKIj9CdbiYh6lJg83ZSCjj
         7C46t/MrCW6pUoySNRPvP8QtkEXYGHhjMfWWqQS+yO2KuCgSTS3hrc+Z1Km118pFqV3b
         8/7WGMRb+DPpJBQ4K7k1LdR566nYaUidYt00aoaUzAFD6Kh5kXw7pUf6LIiZoGQFP+6T
         J3WGzsrWOHC5r33LvS+gRfUF0m8sxwHU41YyKBZ9CpZTi6/pj84hBlZRgoSmmTDLc6N7
         A4DY6XlwFqDbPU3oVF32qNHHGxj3ARxdkx5DN6ZEyaL8KJLwbwmQH/TjaRH6+6mS5Ue6
         Db1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X4a0tiRiKuTwKKaD0bjI7X4v1uWCRl+63mSdCrFaD3o=;
        b=NkRfNiCbdV7KEKIDDDR2iQuRmVK+d90lB+5Jvt8xbvZyik4sLbET5H6exRgAtPhVAs
         vNHZgbcJdc2M46teSEQ+KtAfSLMDgE5V6lATdwqq37m2Ox/QayTCxOmXTcgxzywE9iUh
         djxk83eqiZzaZsw4cLGL1KmOUfBF7SPqHIxvCmNJa3HY2/cRzkTRihDCMLZUNNvmdW6F
         s3r7BlpW94oood5/3ebtRw2Mtw5C5KfX0tbB9GpKRqyysJtMIM1345+lEZ6+S/yzPGz0
         bZVWT0GQo33Izz0YvwpvuNkhQqNo2c6s6UMiLWpHg2zVMSLU59mgeOsCCJVCjOXkp8aT
         znyA==
X-Gm-Message-State: APjAAAV94fZeeBeSJf+QGzHkHXdfT3JSUCG3WBaZuh2Ik+fKKY8KqlIi
        F/jZKF3JVu3gf7XohpDzxsN44p2rnVkwxIYVq6VL26OEJUoJO35ov8ZM5ineoc7ngtERuaxAP6e
        ltTtWRxtgaXoBu+laXgFjOqHGNEgTFrWqjv6vprbiwcqu7EnjXKrGet7wL2bfgyjkfNoU
X-Google-Smtp-Source: APXvYqxVHB4CibG2BC67DF5gtVqqdR4T94SOstC30L4fy5eHku08KEoRBT3GJll08NianydNouoFVl8nAltdFLlD
X-Received: by 2002:a63:c411:: with SMTP id h17mr16151703pgd.360.1572981561121;
 Tue, 05 Nov 2019 11:19:21 -0800 (PST)
Date:   Tue,  5 Nov 2019 11:19:08 -0800
In-Reply-To: <20191105191910.56505-1-aaronlewis@google.com>
Message-Id: <20191105191910.56505-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v2 2/4] kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES.  This needs to be done
due to the addition of the MSR-autostore area that will be added later
in this series.  After that the name AUTOLOAD will no longer make sense.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..c0160ca9ddba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -940,8 +940,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	if (!entry_only)
 		j = find_msr(&m->host, msr);

-	if ((i < 0 && m->guest.nr == NR_AUTOLOAD_MSRS) ||
-		(j < 0 &&  m->host.nr == NR_AUTOLOAD_MSRS)) {
+	if ((i < 0 && m->guest.nr == NR_MSR_ENTRIES) ||
+		(j < 0 &&  m->host.nr == NR_MSR_ENTRIES)) {
 		printk_once(KERN_WARNING "Not enough msr switch entries. "
 				"Can't add msr %x\n", msr);
 		return;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..0c6835bd6945 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,11 +22,11 @@ extern u32 get_umwait_control_msr(void);

 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))

-#define NR_AUTOLOAD_MSRS 8
+#define NR_MSR_ENTRIES 8

 struct vmx_msrs {
 	unsigned int		nr;
-	struct vmx_msr_entry	val[NR_AUTOLOAD_MSRS];
+	struct vmx_msr_entry	val[NR_MSR_ENTRIES];
 };

 struct shared_msr_entry {
--
2.24.0.rc1.363.gb1bccd3e3d-goog

