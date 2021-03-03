Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E989F32C70E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhCDAa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1386548AbhCCS3a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4K8ZUs7Kh4DBTFlI/pvongtlyoWjFjhXN1UWmJlGpA=;
        b=faDYIXuiaJrXVU4Uqc6mEpOx4V/zOAZsfVJ8NLpGCHB8vxtScmdkrSkqpXrh6/Y0RatGw1
        B27AmFUg+arMsK1sq/QWVOWirL94MtpPVI4s2VPijyr+wCyX5DuEe+ogR0gBsU40emFSHr
        1XWiDwOIp9gEOvsXJX5UlP85Un6upP8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-AmsrDZOCNLaB7-Q_qdJbgg-1; Wed, 03 Mar 2021 13:24:02 -0500
X-MC-Unique: AmsrDZOCNLaB7-Q_qdJbgg-1
Received: by mail-wm1-f69.google.com with SMTP id p8so3390865wmq.7
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M4K8ZUs7Kh4DBTFlI/pvongtlyoWjFjhXN1UWmJlGpA=;
        b=V789GLvcpknrWYGoZr7NG5gJuGSf5gAQMZh1+Q/Gvlat5LlPAGQgNlfdN3ULxVM9Z7
         QKqRN16zrB0a8Z8/mbwjNCeC2A6DQSSLveuVZWOznOLoCPDKgZbQYPIxDYELg/8XZTSk
         6/yJRw3ovy1lVzbyh93rvPD9U/XlL9O19DR9hIVt6FCIIRUZ/ZjdWjXvIH4or4DrOWt8
         DlaWSHFgZE8Es9RaVwN6l1E5c9AYJeVe6sQ8BFjh9AJ166d2wUPUDdtplhOIb7ogiMyv
         VXG8ZI6lOEjdaUsXhlbx0ntAvnq4BUQz3l1lnlJ3A5CXcxR0irTlKug7glRIYRL0oToA
         duew==
X-Gm-Message-State: AOAM533tIj5SYg29+xJpQD0atDaaBrlUUxZxLPZZ/ts33vQqmj/e+vCo
        +K17ElrLWQE+wegUPBiJTFYFZgX9JDeVqHx2dn1IgzxmHMAFnlV6qks3Gxmbsg3O+7o34k9/Q8d
        0P7xjGd1XUL4A
X-Received: by 2002:a1c:2049:: with SMTP id g70mr261171wmg.7.1614795841811;
        Wed, 03 Mar 2021 10:24:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKNSRqR8zLkOnVmlcq5ZuBoN3wSOkgPWh5iTNFfiCeOZ6YvIytWpn9Bxp5s21C1pEsD2GscQ==
X-Received: by 2002:a1c:2049:: with SMTP id g70mr261066wmg.7.1614795840433;
        Wed, 03 Mar 2021 10:24:00 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id t14sm34525941wru.64.2021.03.03.10.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:24:00 -0800 (PST)
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
Subject: [RFC PATCH 15/19] accel/kvm: Move the 'kvm_state' field to AccelvCPUState
Date:   Wed,  3 Mar 2021 19:22:15 +0100
Message-Id: <20210303182219.1631042-16-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/core/cpu.h    | 1 -
 include/sysemu/kvm_int.h | 1 +
 accel/kvm/kvm-all.c      | 4 ++--
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index ca2526e6a23..4f280509f9b 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -415,7 +415,6 @@ struct CPUState {
 
     /* Accelerator-specific fields. */
     struct AccelvCPUState *accel_vcpu;
-    struct KVMState *kvm_state;
     struct kvm_run *kvm_run;
     int hvf_fd;
     /* shared by kvm, hax and hvf */
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 3bf75e62293..dc45b3c3afa 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -18,6 +18,7 @@ struct AccelvCPUState {
      * @kvm_fd: vCPU file descriptor for KVM
      */
     int kvm_fd;
+    struct KVMState *kvm_state;
 };
 
 typedef struct KVMSlot
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 1c08ff3fbe0..737db3d3e0e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -437,7 +437,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     cpu->accel_vcpu = g_new(struct AccelvCPUState, 1);
     cpu->accel_vcpu->kvm_fd = ret;
-    cpu->kvm_state = s;
+    cpu->accel_vcpu->kvm_state = s;
     cpu->vcpu_dirty = true;
 
     mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
@@ -1985,7 +1985,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
 
 KVMState *kvm_vcpu_state(CPUState *cpu)
 {
-    return cpu->kvm_state;
+    return cpu->accel_vcpu->kvm_state;
 }
 
 static int kvm_init(MachineState *ms)
-- 
2.26.2

