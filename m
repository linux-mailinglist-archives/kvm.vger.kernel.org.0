Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9289425799
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbhJGQTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240208AbhJGQTd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uq3GCe1ePuf4e4h9nXgJWeyky4oXCfK2GmOEpWIO22Y=;
        b=aS0Yf7/9ZNlbn9WnrCasxFQyUI6CU/K/HHP5d4hgCzkuLuUOI6v6eQ9DjEhRmXlaLyuQUB
        7DITJkVqREc9F/1JfMjuKzcwrz/oUWvlyeo8wFHH6TxUmHuG6NLaXozS8tWojqS3dNjP1J
        BfgK96DV/dqaL2sg/wYoVi/n+Qzd/7U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-kmUQOIFTPbuHoQTH7EFPvg-1; Thu, 07 Oct 2021 12:17:38 -0400
X-MC-Unique: kmUQOIFTPbuHoQTH7EFPvg-1
Received: by mail-wr1-f72.google.com with SMTP id 75-20020adf82d1000000b00160cbb0f800so4355866wrc.22
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uq3GCe1ePuf4e4h9nXgJWeyky4oXCfK2GmOEpWIO22Y=;
        b=a7/e//ta/lS8SKC13EnDWjMQ0Nt3Of5aUfmmoVzu9ELtLuo1iwn3PRnyw8sYC3EXfa
         6cal1u8adbyqCGsF8mkv+cFMgu3CTAIHpdaudotphacDUFVit4NN5TbdlaHsEQwcHHHV
         TzzJOF9UtuPcQzg0+GUgUej6tzAalmW+/KYzYWGXMavwVIzKlV3+cTh+zyYd4n0Yfhfm
         gcfHB8Bp9vDzEwhs/+bNYvR6FiB1D2XMhHih2STU0R3I5Cb7nb914q3nMeL6Kk/eUy5o
         2OemI0rls78aZBdTsmyLoKz5Ct4arfx8ZOEv2mvmOFaBkTM58fi0M327gEZPOpq67KCK
         R5eA==
X-Gm-Message-State: AOAM533/Pr/6uJ4f+ayIj+ohR0WUU7N+03xRZ9FnU9mo7mdazUI/Ie67
        M5q73XYvwKb8WEJh2EFNg9r8kjWi0l5pyim0wmhzZtSWGohslerUwGKVOajJ7iElR98cRJpc1/A
        JnDwaKxVI3Cwx
X-Received: by 2002:a05:600c:3585:: with SMTP id p5mr17715015wmq.110.1633623457017;
        Thu, 07 Oct 2021 09:17:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRrHz4LpvS4F9A81Irylf6VyS/KU+7ApS5LGF0wX1DCUn4RZ7VNHky7fCfqHI5KKojHx92LA==
X-Received: by 2002:a05:600c:3585:: with SMTP id p5mr17714991wmq.110.1633623456879;
        Thu, 07 Oct 2021 09:17:36 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id 189sm10244544wmz.27.2021.10.07.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:36 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 04/23] target/i386/kvm: Restrict SEV stubs to x86 architecture
Date:   Thu,  7 Oct 2021 18:16:57 +0200
Message-Id: <20211007161716.453984-5-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV is x86-specific, no need to add its stub to other
architectures. Move the stub file to target/i386/kvm/.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 {accel => target/i386}/kvm/sev-stub.c | 0
 accel/kvm/meson.build                 | 1 -
 target/i386/kvm/meson.build           | 2 ++
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename {accel => target/i386}/kvm/sev-stub.c (100%)

diff --git a/accel/kvm/sev-stub.c b/target/i386/kvm/sev-stub.c
similarity index 100%
rename from accel/kvm/sev-stub.c
rename to target/i386/kvm/sev-stub.c
diff --git a/accel/kvm/meson.build b/accel/kvm/meson.build
index 8d219bea507..397a1fe1fd1 100644
--- a/accel/kvm/meson.build
+++ b/accel/kvm/meson.build
@@ -3,6 +3,5 @@
   'kvm-all.c',
   'kvm-accel-ops.c',
 ))
-kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
 
 specific_ss.add_all(when: 'CONFIG_KVM', if_true: kvm_ss)
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index b1c76957c76..736df8b72e3 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -7,6 +7,8 @@
   'kvm-cpu.c',
 ))
 
+i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
+
 i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
 i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
-- 
2.31.1

