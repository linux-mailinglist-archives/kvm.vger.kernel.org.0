Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285545E54A9
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiIUUoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 16:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIUUoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 16:44:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560769DFAF
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:44:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 69-20020a630148000000b0043bbb38f75bso3253761pgb.6
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=F7nqEMLGrJHVFbOsAdgB6YhuZTF/EkK9GVmxjpfiIZc=;
        b=YJ58h8qsV7Hl3/EvWmQZKGhkGtFrxPrHNaGeFpInokNkD9ZaKsmG13Y/A/OspaP1F5
         ZdhhwM2Ea2+soxrbkEAr7xpvlNzPm/DXVjS/BMhE9SiAQa11LGAKoFqazpZyz8WgLSiG
         9Y86fc4TpLhEIk0ItOSzre3r3LABMMOKjIx9STuSy1FGqje7aZ8z/RUVWHBScAQsiwq7
         7xUeUQU+Jiu6aK24g+Txg45/aVakL+DytkunKP4NMojfzxLoado+GRssxamGBWtxA1Bl
         ljBaOb8Ntnl6DfC6YaUoNc8ZmQtbRvK5/3OYMNU5oSUz476RlUHPE0OSXduqHA4gW7jq
         2enA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=F7nqEMLGrJHVFbOsAdgB6YhuZTF/EkK9GVmxjpfiIZc=;
        b=IvKPdeCRrTQw4lteaY5st7VBrF/T4Zzv6KQ2pIqHwrpwVDJjW4CoamArU6LaA7tRr0
         VPKtlJywcpDvcZK9nod5SHSBKokM+bgckQL3g0ubkPnn28ITK2UY7K2l5tY4KgaZNkDA
         g9k3D7MKrB0+vHWgFy8jui8hnDoXnMn9z7bjv5tsHI8zf13AjJB31zyOKrAkZfdoWENp
         yctLBjbBKA8PVUN7Ygjs7cU016m7ATQxPq/gMz7/a1NGLNQDQktJ5A2yhe4s4Q1XxoOm
         7/HzJwxctOI81Cpm7ao6GJaw0GzP3d2UVVuY/BaMQQSt/ucevyS9o/XSSN9sctwIo2q7
         8cgg==
X-Gm-Message-State: ACrzQf2fPIDImT9mSSyIulDE5wmRF4/UhQOQbFo3TzE+m3vPwfz76Ql/
        NI8nK4ITYHpnPhshzAQ6EMEpEHEgsmACw81pnB/jV50auu41HxJMQ85wrSQsW7tT3/etD08Fw/b
        ZtHuBaARLtvP9FgoVrZyG3K5b8F5oA9wX2Nwbc2k8zdpCz/JU5j5jpVCRR4nYvNA=
X-Google-Smtp-Source: AMsMyM7WHGTP9sz/FS6rLZqyJM026Jf9rbfFEGfWqaguhod3BaK5XbhrCDPA7TfQIUWHPc/rFwUGQ39SsS6YTA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a62:1dc5:0:b0:540:d8a4:a4ca with SMTP id
 d188-20020a621dc5000000b00540d8a4a4camr30753718pfd.77.1663793045727; Wed, 21
 Sep 2022 13:44:05 -0700 (PDT)
Date:   Wed, 21 Sep 2022 13:44:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921204402.29183-1-jmattson@google.com>
Subject: [PATCH] Documentation: KVM: Describe guest CPUID.15H settings for
 in-kernel APIC
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_CPUID must not populate guest CPUID.15H, because KVM
has no way of knowing the base frequency of the local APIC emulated in
userspace.

However, in reality, the in-kernel APIC emulation is in prevalent
use. Document how KVM_GET_SUPPORTED_CPUID would populate CPUID.15H if
the in-kernel APIC were the default.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 Documentation/virt/kvm/api.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..1e09ac9d48e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1786,6 +1786,16 @@ support.  Instead it is reported via::
 if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
 feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
 
+Similarly, CPUID leaf 0x15 always returns zeroes, because the core
+crystal clock frequency must match the local APIC base frequency, and
+the default configuration leaves the local APIC emulation to
+userspace.
+
+If KVM_CREATE_IRQCHIP is used to enable the in-kernel local APIC
+emulation, CPUID.15H:ECX can be set to 1000000000 (0x3b9aca00). For
+the default guest TSC frequency, CPUID.15H:EBX can be set to tsc_khz
+and CPUID.15H:ECX can be set to 1000000 (0xf4240).  The fraction can
+be simplified if desired.
 
 4.47 KVM_PPC_GET_PVINFO
 -----------------------
-- 
2.37.3.968.ga6b4b080e4-goog

