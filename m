Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9575F39A0E4
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFCMbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:31:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47980 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhFCMbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:31:50 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4F8C61FD60;
        Thu,  3 Jun 2021 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVP6+8hulKdv5ZpKFhChm+OdfVZokSsMHHxKT+AzG9Y=;
        b=S8JCnFTt7VbX1+wEiQyhX2mrey3DQyH3U2iyQ03CrfjeAqCzBjOl+rjG7N2K8a2b1Z2Knp
        OBtUAgK6LHosUvag7zxyVLHkEeGZTUmTQG4qx6AbIwCrvyglQtgtRDx5frCaMs2rU4drdz
        E1jVPE5niGOxemLJcrZTpnAgd9DwOQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723405;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVP6+8hulKdv5ZpKFhChm+OdfVZokSsMHHxKT+AzG9Y=;
        b=gwRib8c0EqG/DD0m6fnOAPQkJnIbNW+1szSH0kaM/zK/Ob6XwoDgTedk6ShiCC+oBZdc3t
        bZjRXe0uRsxUFFDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 514E5118DD;
        Thu,  3 Jun 2021 12:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622723405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVP6+8hulKdv5ZpKFhChm+OdfVZokSsMHHxKT+AzG9Y=;
        b=S8JCnFTt7VbX1+wEiQyhX2mrey3DQyH3U2iyQ03CrfjeAqCzBjOl+rjG7N2K8a2b1Z2Knp
        OBtUAgK6LHosUvag7zxyVLHkEeGZTUmTQG4qx6AbIwCrvyglQtgtRDx5frCaMs2rU4drdz
        E1jVPE5niGOxemLJcrZTpnAgd9DwOQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622723405;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVP6+8hulKdv5ZpKFhChm+OdfVZokSsMHHxKT+AzG9Y=;
        b=gwRib8c0EqG/DD0m6fnOAPQkJnIbNW+1szSH0kaM/zK/Ob6XwoDgTedk6ShiCC+oBZdc3t
        bZjRXe0uRsxUFFDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id +L09EUzLuGCiFwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Thu, 03 Jun 2021 12:30:04 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH v2 2/2] i386: run accel_cpu_instance_init as post_init
Date:   Thu,  3 Jun 2021 14:30:01 +0200
Message-Id: <20210603123001.17843-3-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603123001.17843-1-cfontana@suse.de>
References: <20210603123001.17843-1-cfontana@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes host and max cpu initialization, by running the accel cpu
initialization only after all instance init functions are called for all
X86 cpu subclasses.

The bug this is fixing is related to the "max" and "host" i386 cpu
subclasses, which set cpu->max_features, which is then used at cpu
realization time.

In order to properly split the accel-specific max features code that
needs to be executed at cpu instance initialization time,

we cannot call the accel cpu initialization at the end of the x86 base
class initialization, or we will have no way to specialize
"max features" cpu behavior, overriding the "max" cpu class defaults,
and checking for the "max features" flag itself.

This patch moves the accel-specific cpu instance initialization to after
all x86 cpu instance code has been executed, including subclasses,

so that proper initialization of cpu "host" and "max" can be restored.

Fixes: f5cc5a5c ("i386: split cpu accelerators from cpu.c,"...)
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Claudio Fontana <cfontana@suse.de>
---
 target/i386/cpu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f7eb5f7f6e..35a857dc37 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6445,6 +6445,11 @@ static void x86_cpu_register_feature_bit_props(X86CPUClass *xcc,
     x86_cpu_register_bit_prop(xcc, name, w, bitnr);
 }
 
+static void x86_cpu_post_initfn(Object *obj)
+{
+    accel_cpu_instance_init(CPU(obj));
+}
+
 static void x86_cpu_initfn(Object *obj)
 {
     X86CPU *cpu = X86_CPU(obj);
@@ -6496,9 +6501,6 @@ static void x86_cpu_initfn(Object *obj)
     if (xcc->model) {
         x86_cpu_load_model(cpu, xcc->model);
     }
-
-    /* if required, do accelerator-specific cpu initializations */
-    accel_cpu_instance_init(CPU(obj));
 }
 
 static int64_t x86_cpu_get_arch_id(CPUState *cs)
@@ -6833,6 +6835,8 @@ static const TypeInfo x86_cpu_type_info = {
     .parent = TYPE_CPU,
     .instance_size = sizeof(X86CPU),
     .instance_init = x86_cpu_initfn,
+    .instance_post_init = x86_cpu_post_initfn,
+
     .abstract = true,
     .class_size = sizeof(X86CPUClass),
     .class_init = x86_cpu_common_class_init,
-- 
2.26.2

