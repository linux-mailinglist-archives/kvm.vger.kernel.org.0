Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36E186FCF
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbgCPQQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:16:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55988 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731924AbgCPQQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r1sJ64QkUjojSCH6EGfhYUMESaCKLhSIpdoia+8OdJA=;
        b=Y8pcIBYPiaPQvfm82U6HsC+KWv9Gn+86vVgo1gU/djhRobrRxjSVluTXkj9baINRW+A1Z6
        mT4BLFHBeKIGwXr4SoI1knS/m+tY85Q9BvZG1mRZ7WfTkvyAhkQh3WpjMIfSg3wbxHFfWg
        MTslW17MH0rDk7cIkt4YKbswzmxWhrc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-ltVIQjEtMFyN7mIPM5wqgw-1; Mon, 16 Mar 2020 12:07:39 -0400
X-MC-Unique: ltVIQjEtMFyN7mIPM5wqgw-1
Received: by mail-wr1-f70.google.com with SMTP id b11so9233295wru.21
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1sJ64QkUjojSCH6EGfhYUMESaCKLhSIpdoia+8OdJA=;
        b=rcXqeXjG+shZqgxwTvS4vFOTINBr2EBdYNXALZzHEcbV5NJEMVY9gOyQSyl5rAbpvx
         JRfZXvc7WBFDpniNiTx7wtzFap2RMbZSyt+ifZ7OjkQygJ7D78cannnjQSRfpYa/X5wp
         UsM8opOmwlSh8IVPIy1NAdQA7CfzBcrKPWP+6MAQduzqyEFrj3jSudYqfeF5/4yNl9Yi
         LNQATr+6egu2dMLF1XiCI1LLCqNR3P2k/QrWyW7nxf+uTyj1gQvlQX/hKOnOTjKDgeoc
         jDS0Dnts1uflaXFtSsCpnKaC9B/V9bTwmGvJiEijrqgvp1Wd3px3bIpdCcQxaDkLYxjS
         4LWA==
X-Gm-Message-State: ANhLgQ0BRtdXeI7nKt06qw7Xp6fVPlYzXokuDHd+iy3dkQBfI2sE9qdI
        NCylOVcKbyX6+hZGPjpmlGZq3pvsUEsae1UhewqOAMiACkVQjSbWBw5bqIz7WXHVVn6qjh2AGLv
        Mg1KM+aqIDIKM
X-Received: by 2002:a05:6000:d0:: with SMTP id q16mr77275wrx.71.1584374836479;
        Mon, 16 Mar 2020 09:07:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuudPESzx7lkwiv+yf4OA/xliD4IQtL8C5kEgXeePSGNU/JOytk/Z7I5CpK3n1RCITbf/5TOg==
X-Received: by 2002:a05:6000:d0:: with SMTP id q16mr77257wrx.71.1584374836307;
        Mon, 16 Mar 2020 09:07:16 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id y7sm22973551wmd.1.2020.03.16.09.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:15 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 07/19] target/arm: Make cpu_register() available for other files
Date:   Mon, 16 Mar 2020 17:06:22 +0100
Message-Id: <20200316160634.3386-8-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Make cpu_register() (renamed to arm_cpu_register()) available
from internals.h so we can register CPUs also from other files
in the future.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Message-ID: <20190921150420.30743-2-thuth@redhat.com>
[PMD: Split Thomas's patch in two: set_feature (earlier), cpu_register]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/cpu-qom.h |  9 ++++++++-
 target/arm/cpu.c     | 10 ++--------
 target/arm/cpu64.c   |  8 +-------
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index 3a9d31ea9d..29c5e2f2c9 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -35,7 +35,14 @@ struct arm_boot_info;
 
 #define TYPE_ARM_MAX_CPU "max-" TYPE_ARM_CPU
 
-typedef struct ARMCPUInfo ARMCPUInfo;
+typedef struct ARMCPUInfo {
+    const char *name;
+    void (*initfn)(Object *obj);
+    void (*class_init)(ObjectClass *oc, void *data);
+} ARMCPUInfo;
+
+void arm_cpu_register(const ARMCPUInfo *info);
+void aarch64_cpu_register(const ARMCPUInfo *info);
 
 /**
  * ARMCPUClass:
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index c074364542..d2813eb81a 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2698,12 +2698,6 @@ static void arm_max_initfn(Object *obj)
 
 #endif /* !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64) */
 
-struct ARMCPUInfo {
-    const char *name;
-    void (*initfn)(Object *obj);
-    void (*class_init)(ObjectClass *oc, void *data);
-};
-
 static const ARMCPUInfo arm_cpus[] = {
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
     { .name = "arm926",      .initfn = arm926_initfn },
@@ -2869,7 +2863,7 @@ static void cpu_register_class_init(ObjectClass *oc, void *data)
     acc->info = data;
 }
 
-static void cpu_register(const ARMCPUInfo *info)
+void arm_cpu_register(const ARMCPUInfo *info)
 {
     TypeInfo type_info = {
         .parent = TYPE_ARM_CPU,
@@ -2910,7 +2904,7 @@ static void arm_cpu_register_types(void)
     type_register_static(&idau_interface_type_info);
 
     while (info->name) {
-        cpu_register(info);
+        arm_cpu_register(info);
         info++;
     }
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 622082eae2..e89388378b 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -728,12 +728,6 @@ static void aarch64_max_initfn(Object *obj)
                         cpu_max_set_sve_max_vq, NULL, NULL, &error_fatal);
 }
 
-struct ARMCPUInfo {
-    const char *name;
-    void (*initfn)(Object *obj);
-    void (*class_init)(ObjectClass *oc, void *data);
-};
-
 static const ARMCPUInfo aarch64_cpus[] = {
     { .name = "cortex-a57",         .initfn = aarch64_a57_initfn },
     { .name = "cortex-a53",         .initfn = aarch64_a53_initfn },
@@ -816,7 +810,7 @@ static void cpu_register_class_init(ObjectClass *oc, void *data)
     acc->info = data;
 }
 
-static void aarch64_cpu_register(const ARMCPUInfo *info)
+void aarch64_cpu_register(const ARMCPUInfo *info)
 {
     TypeInfo type_info = {
         .parent = TYPE_AARCH64_CPU,
-- 
2.21.1

