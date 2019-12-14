Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F0811F2B2
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLNP6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:58:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28290 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726814AbfLNP6W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 10:58:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFyYhSJaR8h39Rbqagf85ifWXxR+w0L7k4hKSrlfago=;
        b=G9YbJwNp/9mPd05ITp4rG3PhAx2NjKBAUypWRGHQS1KiMTAhEo7lFaLCXGm1eOkTGdZ5kx
        iIUTmuCFGVqvc3BKeAl0MPRDvc2BakTrJMSV7UwdY2bJSTZ0CyXEtOgxwrwoS+3tFCoqwB
        9W4mLl51Ued0l5a8KQCaQfC6WaQSqL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-GKZmRrbXNv-VBjqVcGU-Mg-1; Sat, 14 Dec 2019 10:58:20 -0500
X-MC-Unique: GKZmRrbXNv-VBjqVcGU-Mg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AAA1801E74;
        Sat, 14 Dec 2019 15:58:18 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E18B066A1A;
        Sat, 14 Dec 2019 15:58:05 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 8/8] target/i386/cpu: Use 'mr' for MemoryRegion variables
Date:   Sat, 14 Dec 2019 16:56:14 +0100
Message-Id: <20191214155614.19004-9-philmd@redhat.com>
In-Reply-To: <20191214155614.19004-1-philmd@redhat.com>
References: <20191214155614.19004-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The codebase use 'as' in variable names for AddressSpace objects,
and 'mr' for MemoryRegion objects. Since these variables are
MemoryRegion objects, rename them as 'mr' to avoid confusion with
AddressSpace objects.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 target/i386/cpu.h |  2 +-
 target/i386/cpu.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cde2a16b94..1e5ded6e84 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1713,7 +1713,7 @@ struct X86CPU {
     /* in order to simplify APIC support, we leave this pointer to the
        user */
     struct DeviceState *apic_state;
-    struct MemoryRegion *cpu_as_root, *cpu_as_mem, *smram;
+    MemoryRegion *cpu_mr_root, *cpu_mr_mem, *smram;
     Notifier machine_done;
=20
     struct kvm_msrs *kvm_msr_buf;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6131c62f9d..b5d22740b8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5983,7 +5983,7 @@ static void x86_cpu_machine_done(Notifier *n, void =
*unused)
         memory_region_init_alias(cpu->smram, OBJECT(cpu), "smram",
                                  smram, 0, 1ull << 32);
         memory_region_set_enabled(cpu->smram, true);
-        memory_region_add_subregion_overlap(cpu->cpu_as_root, 0, cpu->sm=
ram, 1);
+        memory_region_add_subregion_overlap(cpu->cpu_mr_root, 0, cpu->sm=
ram, 1);
     }
 }
 #else
@@ -6471,24 +6471,24 @@ static void x86_cpu_realizefn(DeviceState *dev, E=
rror **errp)
=20
 #ifndef CONFIG_USER_ONLY
     if (tcg_enabled()) {
-        cpu->cpu_as_mem =3D g_new(MemoryRegion, 1);
-        cpu->cpu_as_root =3D g_new(MemoryRegion, 1);
+        cpu->cpu_mr_mem =3D g_new(MemoryRegion, 1);
+        cpu->cpu_mr_root =3D g_new(MemoryRegion, 1);
=20
         /* Outer container... */
-        memory_region_init(cpu->cpu_as_root, OBJECT(cpu), "memory", ~0ul=
l);
-        memory_region_set_enabled(cpu->cpu_as_root, true);
+        memory_region_init(cpu->cpu_mr_root, OBJECT(cpu), "memory", ~0ul=
l);
+        memory_region_set_enabled(cpu->cpu_mr_root, true);
=20
         /* ... with two regions inside: normal system memory with low
          * priority, and...
          */
-        memory_region_init_alias(cpu->cpu_as_mem, OBJECT(cpu), "memory",
+        memory_region_init_alias(cpu->cpu_mr_mem, OBJECT(cpu), "memory",
                                  get_system_memory(), 0, ~0ull);
-        memory_region_add_subregion(cpu->cpu_as_root, 0, cpu->cpu_as_mem=
);
-        memory_region_set_enabled(cpu->cpu_as_mem, true);
+        memory_region_add_subregion(cpu->cpu_mr_root, 0, cpu->cpu_mr_mem=
);
+        memory_region_set_enabled(cpu->cpu_mr_mem, true);
=20
         cs->num_ases =3D 2;
         cpu_address_space_init(cs, 0, "cpu-memory", cs->memory);
-        cpu_address_space_init(cs, 1, "cpu-smm", cpu->cpu_as_root);
+        cpu_address_space_init(cs, 1, "cpu-smm", cpu->cpu_mr_root);
=20
         /* ... SMRAM with higher priority, linked from /machine/smram.  =
*/
         cpu->machine_done.notify =3D x86_cpu_machine_done;
--=20
2.21.0

