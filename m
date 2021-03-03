Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6250B32C6EB
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451147AbhCDAaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377403AbhCCS2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcmU4EwKx07Tin9L5OLokG4d2/Qw/rC/JleGsw0pME0=;
        b=eTXm+p6HyC5IiFjAahH/VNaruOzitGAwz+bOU6Y5ibO8jGXFyacPLJJGx8mYTGhZ1Gndtm
        G3rNvUd4eyEe39ukU472IFgmI+7kijlnlXm4vlqc8l4X5EHb9WEv1GKstAjHJ5IhA0Kk+O
        bTnUUH7nw+tRvhqKSvl2XPENlwRLF3s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-TeVkghTIPSeiIOMe4k0tKw-1; Wed, 03 Mar 2021 13:23:13 -0500
X-MC-Unique: TeVkghTIPSeiIOMe4k0tKw-1
Received: by mail-wm1-f71.google.com with SMTP id j8so2169374wmq.6
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gcmU4EwKx07Tin9L5OLokG4d2/Qw/rC/JleGsw0pME0=;
        b=LYQwA5Uo02ce3hRYVjxX105V796I0Ub0QEwZiN5XSWRrNb2Z2u2fbU5posO94C8ag6
         Wrzd5bHDi/kRDUBorC43p62puDjbLoofkc1rXEvyeguD5VCxbaf+XBysmZpdaQyOl4rj
         w6b56qHgI4lwYJ5ojlvjjc01hqKx6njij5d7cfsGSm69kGvmQu6c2uTT9AmORt9NPTE0
         WWl31BqtkS1VLFtgULFZbz+7c5zx5oBFVMx5SDHUJAJFgpdCC5Qc6LhuXA8Nuyv5jirt
         MDO2k6gPzRvLUFJwOFe2+F9V0gj73QSK7PyuEN6RnEE3msLACQWP7MIt91j1z8B0Kk31
         D7Zw==
X-Gm-Message-State: AOAM531gFMYJbYNHrIGFUBn7fS4m5oNWAfnOv5KiPxnTjij3BmNydAVF
        dRd1ei++2IsLRKzFh25IopmHoS90fGN9Mecc5QH0s89/hOrdpL5T+KHcjmqftG7B08mR3o80SH2
        ZvOQacNTNE8X2
X-Received: by 2002:adf:f512:: with SMTP id q18mr28690255wro.61.1614795792401;
        Wed, 03 Mar 2021 10:23:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsuKFTfGdNl3JrpUfwyW5A/mzww+ew2G6b3+YznKtRBqmyC0QveUl42fP3vSv4XPE27dPvRA==
X-Received: by 2002:adf:f512:: with SMTP id q18mr28690224wro.61.1614795792253;
        Wed, 03 Mar 2021 10:23:12 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id l22sm34033345wrb.4.2021.03.03.10.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:11 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 08/19] accel/whpx: Use 'accel_vcpu' generic pointer
Date:   Wed,  3 Mar 2021 19:22:08 +0100
Message-Id: <20210303182219.1631042-9-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of naming the HAX accelerator in WHPX, use the
'accel_vcpu' field which is meant for accelerators.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/whpx/whpx-all.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index f0b3266114d..56ec82076cc 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -177,7 +177,7 @@ struct WHPDispatch whp_dispatch;
 
 static whpx_vcpu *get_whpx_vcpu(CPUState *cpu)
 {
-    return (whpx_vcpu *)cpu->hax_vcpu;
+    return cpu->accel_vcpu;
 }
 
 static WHV_X64_SEGMENT_REGISTER whpx_seg_q2h(const SegmentCache *qs, int v86,
@@ -1439,7 +1439,7 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu->interruptable = true;
     cpu->vcpu_dirty = true;
-    cpu->hax_vcpu = (struct hax_vcpu_state *)vcpu;
+    cpu->accel_vcpu = vcpu;
     max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
     qemu_add_vm_change_state_handler(whpx_cpu_update_state, cpu->env_ptr);
 
@@ -1481,7 +1481,7 @@ void whpx_destroy_vcpu(CPUState *cpu)
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
-    g_free(cpu->hax_vcpu);
+    g_free(cpu->accel_vcpu);
     return;
 }
 
-- 
2.26.2

