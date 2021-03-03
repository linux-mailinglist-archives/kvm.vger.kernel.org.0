Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA0F32C6F0
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451159AbhCDAac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377792AbhCCS2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79DgZpr2EmNkKjevsnbnnQniykZdHifg2JouUZY5E8w=;
        b=Aega/bjrANbwZ1gEnuAggLkzQuQIWdHAOtlcbQmd/A8Io+CELiSDWEV0reYubqHi3BnYcT
        jKBCUkoXRjlT2/IluRrM5kRQEBFu2ZSv24hwhh7bs+5sz/7Jj/ow6O/CGsPDFVF4jnTrEm
        GXJVI0Wof/qYJZwTyM4qBEXFXPBSTFo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-agH2STYMPlqEoa-sR7-QBg-1; Wed, 03 Mar 2021 13:23:40 -0500
X-MC-Unique: agH2STYMPlqEoa-sR7-QBg-1
Received: by mail-wr1-f71.google.com with SMTP id h5so4751287wrr.17
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79DgZpr2EmNkKjevsnbnnQniykZdHifg2JouUZY5E8w=;
        b=VC5BkyKG/i1KfWGa9ERXXsLUE1L/bd8Mat1KL6/pfnE3Furhd8aBEPwUA0ixZhqBdE
         vwDfMwUQCJN/CbDWNOXuHDPQXcxMCSZh0slxXLwKkq9XxGCjJKIjJUU8P8zFynEaaW7K
         yWco2/A69k7hnblZgyhQkavSKDD76rsuQbcm2cPHQiIFndkf+sn7kbJesp5tKwlWX/38
         S9Qg3k8aW9CHBqIPNA2SKcQSYVc1LS15gDT+Mm5kjzN/ZTSCCbt39XvcAf2ja8R9oxrh
         SQWivO2ChWDiUeMHTN/6R4EUZ1dxwlhPlHtvN2z4QXbtUSU9agL0G6hlskehhbNq3PTn
         UAXw==
X-Gm-Message-State: AOAM532TjTlfoALVnE/JI/Eyc7eJTjq4NGBGdBgZMgmd26iJm74Ta+lJ
        vfKIXVflUu5JIjBTF7K8mdI0k27scqgoiiSA4sy7Ls+nb8VDTEeqCndnBMw2XD4Oqe6V3anEx+a
        gDMYAxInjp9uq
X-Received: by 2002:a7b:c407:: with SMTP id k7mr292589wmi.136.1614795819064;
        Wed, 03 Mar 2021 10:23:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2ZZPhH9pI1ojwAdx3yz1Bw2buB6+u4yZQIHTFUxGfLpDaJfYOKtQLkaZHng2glOOMTYruTw==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr292558wmi.136.1614795818843;
        Wed, 03 Mar 2021 10:23:38 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id t14sm34525097wru.64.2021.03.03.10.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:38 -0800 (PST)
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
Subject: [RFC PATCH 11/19] accel/kvm: Introduce kvm_vcpu_state() helper
Date:   Wed,  3 Mar 2021 19:22:11 +0100
Message-Id: <20210303182219.1631042-12-philmd@redhat.com>
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
 include/sysemu/kvm.h | 2 ++
 accel/kvm/kvm-all.c  | 5 +++++
 target/i386/cpu.c    | 4 ++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 687c598be9b..f339be31d1b 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -361,6 +361,8 @@ int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
 bool kvm_vcpu_id_is_valid(int vcpu_id);
+/* Returns a pointer to the KVMState associated with this vCPU */
+KVMState *kvm_vcpu_state(CPUState *cpu);
 
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 84c943fcdb2..b787d590a9a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1978,6 +1978,11 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
     return vcpu_id >= 0 && vcpu_id < kvm_max_vcpu_id(s);
 }
 
+KVMState *kvm_vcpu_state(CPUState *cpu)
+{
+    return cpu->kvm_state;
+}
+
 static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6a53446e6a5..0d6376322bb 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5755,7 +5755,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     case 0xA:
         /* Architectural Performance Monitoring Leaf */
         if (kvm_enabled() && cpu->enable_pmu) {
-            KVMState *s = cs->kvm_state;
+            KVMState *s = kvm_vcpu_state(cs);
 
             *eax = kvm_arch_get_supported_cpuid(s, 0xA, count, R_EAX);
             *ebx = kvm_arch_get_supported_cpuid(s, 0xA, count, R_EBX);
@@ -6620,7 +6620,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
 
     if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
         kvm_enabled()) {
-        KVMState *s = CPU(cpu)->kvm_state;
+        KVMState *s = kvm_vcpu_state(CPU(cpu));
         uint32_t eax_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EAX);
         uint32_t ebx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EBX);
         uint32_t ecx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_ECX);
-- 
2.26.2

