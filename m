Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB183FF0FF
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbhIBQRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346235AbhIBQQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 12:16:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42946C061764
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 09:16:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t15so3833294wrg.7
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IALuJS79v15vDPvWp0gEXOFVB8QcuCBujL3iQm4WVXc=;
        b=lyX2iDyZ4fZxIDfBFZ3tyjvTVxQHi5/DKPStvMf8XLdWBZf2Z4YEuBxLZ6HKfP2S0S
         9fzfqOWFn0kWTui3s6TURapTU3z+GQ8v8hJn1LfoSFOHPkdm35vCxTfT+cYkW1nrugty
         mCqdxM8mrNR5MLebQDolGLEo/7Lkgdj2gwYMGjuH7g4aAADt1Bq23c52IZGz+2AB+NL8
         GZ3E3+ftKA9QL43iXqO6Ak9f9Icd3LYBSFwdaV1YhiiVZy5M0xyjWQ/L7Ym3RUz2AJov
         QL67c+ediBlqlyYZ/UNrRKxOjNTuB98lMijtK7yEZi/9rGhzXp+Rvgvey6qwTDyAgy4I
         6qHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IALuJS79v15vDPvWp0gEXOFVB8QcuCBujL3iQm4WVXc=;
        b=YDkii+Rcq8Il4DCzKE7R+2yC19NRieqfxLdKsSHfTHbbExCCAxoVe9MAYJ1VjgJmRs
         W2OB/NFCLN2OyPXLwyTfbTjxZLMRmUBF/RTpxr/mQ/56vBk1FkFEkZsghf+AKcdINse7
         R2KM9CcdoyBxUqpTRwKS2arRLxg7ovnGd7o61dQe68zuHZNJo0r/XCbOp4RJrsVb+56z
         qYo2eix+JsKdErW06ZFWVLNoTotAFL+Ap9A+La/tWqYtknrUxPs4c6l03inTsmpV1IcF
         NmUIz0cr0u56ZTDqtKm9yq/409eIBsIXxmqr5Mwu7pos/UsgS0CNX8QXiOMUG1xPq9Ep
         xKIA==
X-Gm-Message-State: AOAM5301+OFo1lXUbyWu4LyLipOBFVBAC4qxZS09/nUNTvFJu1JqSh2t
        hJmuJQYtNVZUvmu4uTGrLuk=
X-Google-Smtp-Source: ABdhPJy7JEkr/3dMu4L49Lw+gPGY8gHw7yAaZhdIf87oRC7v/4j/f/YWrayp4BQC2KvwiDQbjRMXEg==
X-Received: by 2002:adf:dbd0:: with SMTP id e16mr4727843wrj.402.1630599358916;
        Thu, 02 Sep 2021 09:15:58 -0700 (PDT)
Received: from x1w.. (163.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.163])
        by smtp.gmail.com with ESMTPSA id x9sm1939663wmi.30.2021.09.02.09.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:15:58 -0700 (PDT)
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
Subject: [PATCH v3 02/30] hw/core: Restrict cpu_has_work() to sysemu
Date:   Thu,  2 Sep 2021 18:15:15 +0200
Message-Id: <20210902161543.417092-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902161543.417092-1-f4bug@amsat.org>
References: <20210902161543.417092-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cpu_has_work() is only called from system emulation code.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 include/hw/core/cpu.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index bc864564cee..2bd563e221f 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -538,6 +538,22 @@ enum CPUDumpFlags {
 void cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 
 #ifndef CONFIG_USER_ONLY
+/**
+ * cpu_has_work:
+ * @cpu: The vCPU to check.
+ *
+ * Checks whether the CPU has work to do.
+ *
+ * Returns: %true if the CPU has work, %false otherwise.
+ */
+static inline bool cpu_has_work(CPUState *cpu)
+{
+    CPUClass *cc = CPU_GET_CLASS(cpu);
+
+    g_assert(cc->has_work);
+    return cc->has_work(cpu);
+}
+
 /**
  * cpu_get_phys_page_attrs_debug:
  * @cpu: The CPU to obtain the physical page address for.
@@ -636,22 +652,6 @@ CPUState *cpu_create(const char *typename);
  */
 const char *parse_cpu_option(const char *cpu_option);
 
-/**
- * cpu_has_work:
- * @cpu: The vCPU to check.
- *
- * Checks whether the CPU has work to do.
- *
- * Returns: %true if the CPU has work, %false otherwise.
- */
-static inline bool cpu_has_work(CPUState *cpu)
-{
-    CPUClass *cc = CPU_GET_CLASS(cpu);
-
-    g_assert(cc->has_work);
-    return cc->has_work(cpu);
-}
-
 /**
  * qemu_cpu_is_self:
  * @cpu: The vCPU to check against.
-- 
2.31.1

