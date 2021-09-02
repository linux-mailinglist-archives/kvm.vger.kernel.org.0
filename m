Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ED73FF103
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346223AbhIBQRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346248AbhIBQRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:17:17 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDD6C061764
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:16:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id x2-20020a1c7c02000000b002e6f1f69a1eso1857570wmc.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RYRVLsfl9Ob+8zW8ulpQWg/n0bsy9p4rFkeC3sRFgzg=;
        b=cWSYDAq5Jp0McvzKfoJCBhOUKIrlk33QHDkz+m47acNIlb9JOx3tfp5kB+KXf5dDO/
         w4+OyKHGR2RiqPyFa7V7bzZyYSy6kLYW49zVrZ6Hy8QBCbCerYOKfrGjd0qNffHf9SpP
         r/Kq+8mSo19dNZRUfW1WN64ERD6JetVYvf41b1e1tWlJwcOL4P63Z/Mm9sSwkJyaYePZ
         Jroc0woaa+Fir71b0dp9xMglTvA3smVf5tzo/uq315Y7Ji+qHpf638YaJjs7F9y6JQ5A
         whXUesQqAhIyuS/27l3cznkFQWzDOa9H8TavWnRll7U6TXlgZEUv2l8XPpV83TA8h9zC
         OFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=RYRVLsfl9Ob+8zW8ulpQWg/n0bsy9p4rFkeC3sRFgzg=;
        b=b2rLs3IDpCuQuaDyZno0PtTmhfhlnIT1E/xXebnZiXotpxY8ejryWLeINjC3x8T5cT
         Kt4f8SmWbDSaA5BCe1FLvj1h16kdmGlWwzRSYVB77gLnQXD0gBPV7zLymd25pkKziqt9
         QjWz10h86gsXpWqkHexQCELrwtKZeK7R/sCsjxdHYF2pQLu+vDkAeyvaPIw5p3H7dusX
         Ly6b6Q6UCkaX9rFGPoV4LBAvxlEvn+I9usqLH+Db31bLbVtlYz8jEflMrEx6d2Hk3hmf
         87a2TPl6DQT1jLWBX+Nt7iVj1yWYzD+0ERWcAx+xLR4akchtNRsUim6NQzTV25PG8YEA
         KZwA==
X-Gm-Message-State: AOAM531y+7UMOHPyvDxdsj97nFjfVltyAHFB+UvkCJBWqbcR0hOOfPdU
        n1cWAtAGfwQ/GXJDlnCaF7U=
X-Google-Smtp-Source: ABdhPJwPjYjbwvv/6b7qFrtZZvNxWFscX+KmwH8SpAbQsTLfx+OHgnzX3KJXi3XGsfieLbi9LeXPtA==
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr3953111wmh.161.1630599376931;
        Thu, 02 Sep 2021 09:16:16 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id n3sm2097857wmi.0.2021.09.02.09.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:16:16 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kurz <groug@kaod.org>, haxm-team@intel.com,
        Kamil Rytarowski <kamil@netbsd.org>, qemu-ppc@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, qemu-riscv@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Chris Wulff <crwulff@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, qemu-s390x@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Durrant <paul@xen.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        xen-devel@lists.xenproject.org, Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Stafford Horne <shorne@gmail.com>,
        Reinoud Zandijk <reinoud@netbsd.org>, kvm@vger.kernel.org
Subject: [PATCH v3 05/30] accel/kvm: Implement AccelOpsClass::has_work()
Date:   Thu,  2 Sep 2021 18:15:18 +0200
Message-Id: <20210902161543.417092-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM has_work() handler in AccelOpsClass and
remove it from cpu_thread_is_idle() since cpu_has_work()
is already called.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/kvm/kvm-accel-ops.c | 6 ++++++
 softmmu/cpus.c            | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 7516c67a3f5..6f4d5df3a0d 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -74,6 +74,11 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
                        cpu, QEMU_THREAD_JOINABLE);
 }
 
+static bool kvm_cpu_has_work(CPUState *cpu)
+{
+    return kvm_halt_in_kernel();
+}
+
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
@@ -83,6 +88,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->has_work = kvm_cpu_has_work;
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 2a61dfd6287..3db7bd4eb4d 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -90,7 +90,7 @@ bool cpu_thread_is_idle(CPUState *cpu)
         return true;
     }
     if (!cpu->halted || cpu_has_work(cpu) ||
-        kvm_halt_in_kernel() || whpx_apic_in_platform()) {
+        whpx_apic_in_platform()) {
         return false;
     }
     return true;
-- 
2.31.1

