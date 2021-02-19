Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1248931FE0A
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhBSRke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhBSRkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cia92nKBjrGhWlmymfB9YbxEpc3m+J7hFEI/efRN2yM=;
        b=B4hXWITd3MjdLXlv+hDENzBkDbtF1k/RhVVeqq0EQHFIg5KW6/GDY7YCXxmHMWtp0LfMbF
        37i31N10OEciZT/BSHw4ryts9n6RJRCAi66FBgyRndsVPHMJn0/5AaHxX+6IfWkwqNv0Ql
        i3PmLrBdebVcPlgX+3xBrlzsZ65Gpcs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-VrzUK3E0Po2Zf9rn7dw1mA-1; Fri, 19 Feb 2021 12:39:04 -0500
X-MC-Unique: VrzUK3E0Po2Zf9rn7dw1mA-1
Received: by mail-wr1-f72.google.com with SMTP id l3so1135130wrx.15
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cia92nKBjrGhWlmymfB9YbxEpc3m+J7hFEI/efRN2yM=;
        b=pcR5OeT0JsTDtDanIUOGpHqQhiJ3jJuWngAfVV4WqDdQpsWsbWAvjXeb496Vl5VQtq
         E0zxAmv1P4/Hoc+om9xd9nwC7ba6ABlLLzV6uw12qsXghpVf4TT41o7aO+YKMPhRmqB8
         PAxALVzB1vlGJ/lWcPAtwYfjT3jSDtihp4Yob4iA+dG0d3ZFmt+Gt4w6BbXys+kswT+A
         305fMBo+YyHixco0K6X5BYpJPU/1fm7ir9VR0mjQJSeB1s76IP4X/aQq05WOkZjZogX5
         MtTrQKq89bMSSSvhS2jhAk8iKeCO08TZWVy+F1I57yDX4jvyrWZmU85SpW32q/DyF4Rn
         WusA==
X-Gm-Message-State: AOAM53257e+fuXXdGw0LApZ63yin3wcBx0X2hG0NqTZBNniYEhvErA2P
        EjGmigxG+IbwyOSklhjRzej6RBsWlVDU5pxCYDgyfCYx4MIs+ETS0ADuMjWXWKBMT+Jblg1so5A
        jTerc1VRghlEU
X-Received: by 2002:a1c:dd09:: with SMTP id u9mr7417300wmg.183.1613756342440;
        Fri, 19 Feb 2021 09:39:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqNL2hop6t3K45dchD7vTDRIpUNwjlifOUsXeOhz1mjGEWf1uUBOU5I8vzusScCU0mSzJMIw==
X-Received: by 2002:a1c:dd09:: with SMTP id u9mr7417287wmg.183.1613756342265;
        Fri, 19 Feb 2021 09:39:02 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id u7sm13826375wrt.67.2021.02.19.09.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:01 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 02/11] hw/boards: Introduce machine_class_valid_for_accelerator()
Date:   Fri, 19 Feb 2021 18:38:38 +0100
Message-Id: <20210219173847.2054123-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the valid_accelerators[] field to express the list
of valid accelators a machine can use, and add the
machine_class_valid_for_current_accelerator() and
machine_class_valid_for_accelerator() methods.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/boards.h | 24 ++++++++++++++++++++++++
 hw/core/machine.c   | 26 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 68d3d10f6b0..4d08bc12093 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -36,6 +36,24 @@ void machine_set_cpu_numa_node(MachineState *machine,
                                const CpuInstanceProperties *props,
                                Error **errp);
 
+/**
+ * machine_class_valid_for_accelerator:
+ * @mc: the machine class
+ * @acc_name: accelerator name
+ *
+ * Returns %true if the accelerator is valid for the machine, %false
+ * otherwise. See #MachineClass.valid_accelerators.
+ */
+bool machine_class_valid_for_accelerator(MachineClass *mc, const char *acc_name);
+/**
+ * machine_class_valid_for_current_accelerator:
+ * @mc: the machine class
+ *
+ * Returns %true if the accelerator is valid for the current machine,
+ * %false otherwise. See #MachineClass.valid_accelerators.
+ */
+bool machine_class_valid_for_current_accelerator(MachineClass *mc);
+
 void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char *type);
 /*
  * Checks that backend isn't used, preps it for exclusive usage and
@@ -125,6 +143,11 @@ typedef struct {
  *    should instead use "unimplemented-device" for all memory ranges where
  *    the guest will attempt to probe for a device that QEMU doesn't
  *    implement and a stub device is required.
+ * @valid_accelerators:
+ *    If this machine supports a specific set of virtualization accelerators,
+ *    this contains a NULL-terminated list of the accelerators that can be
+ *    used. If this field is not set, any accelerator is valid. The QTest
+ *    accelerator is always valid.
  * @kvm_type:
  *    Return the type of KVM corresponding to the kvm-type string option or
  *    computed based on other criteria such as the host kernel capabilities
@@ -166,6 +189,7 @@ struct MachineClass {
     const char *alias;
     const char *desc;
     const char *deprecation_reason;
+    const char *const *valid_accelerators;
 
     void (*init)(MachineState *state);
     void (*reset)(MachineState *state);
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 970046f4388..c42d8e382b1 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -518,6 +518,32 @@ static void machine_set_nvdimm_persistence(Object *obj, const char *value,
     nvdimms_state->persistence_string = g_strdup(value);
 }
 
+bool machine_class_valid_for_accelerator(MachineClass *mc, const char *acc_name)
+{
+    const char *const *name = mc->valid_accelerators;
+
+    if (!name) {
+        return true;
+    }
+    if (strcmp(acc_name, "qtest") == 0) {
+        return true;
+    }
+
+    for (unsigned i = 0; name[i]; i++) {
+        if (strcasecmp(acc_name, name[i]) == 0) {
+            return true;
+        }
+    }
+    return false;
+}
+
+bool machine_class_valid_for_current_accelerator(MachineClass *mc)
+{
+    AccelClass *ac = ACCEL_GET_CLASS(current_accel());
+
+    return machine_class_valid_for_accelerator(mc, ac->name);
+}
+
 void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char *type)
 {
     QAPI_LIST_PREPEND(mc->allowed_dynamic_sysbus_devices, g_strdup(type));
-- 
2.26.2

