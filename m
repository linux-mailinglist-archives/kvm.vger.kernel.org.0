Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA012D905B
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbgLMUUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLMUUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:20:41 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED14C0613D6
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:00 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a3so13415393wmb.5
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39WDzgrzKw1HI9cbUqd/4nglotTqMx2ozVZiEV9EMeo=;
        b=HNeZlXVtc7YfjiBul+Rccx5JKDxdpjacjieOOVNOFISfGRL06tM3qvroTYE1jrNqfZ
         QcQZ6KXhyY8ucZpcziHxytnf1cM0TZk40qOl4gCcD0ZGmVx58ssLywumZ+c9fOCHu7m/
         PtVXnTWWnDmZapEKqWpEOAguvf/tkTkTOMpwnZ1vEYZpOk7KOwKwkrlIjfkj9yeg02XR
         49rsclJmeSCajmC5NXGljEy7aevH63eryJL068edfTaKTGUOTDnQvoa1lBKogaNAcPjv
         ZoOTWDi0x/6iJHEro0xLrcAF7PruNCGo9iVGZ9vqukZaNKkNUCuThrGHNzuoYEjeGC7d
         vq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=39WDzgrzKw1HI9cbUqd/4nglotTqMx2ozVZiEV9EMeo=;
        b=hanDPMgc2N0sc/SKYaUiiI18+8DBtm9cMsI8WZzHoVOw+Suz0L8XQhQ454myq92Bmc
         AxLRytS4kiyTWqv94qiYJl3GL0U9iF3/1CJ5Uu4NAUje9q8TUepQ7B4ymd1/B3+q0zOz
         nqDp4aMmmayY1XWkmheKqYKcfWHT9ASANAQ0pX4qDBqXdwVqKQQflANaa717qW7B1/VI
         ZGBoi6Z9Jn5TqyUA488ZqXAVXQiOYidCaqksBeWyeBt0H5xlF5iU191CzUfu/9t1cBE8
         I/lXVMw0eA8/SZ8s1TYUoC4T8oDo0I59rMXpEba650+RiHaso397FpLf26i7PriMXhb1
         1ZZw==
X-Gm-Message-State: AOAM533chhznxvZkdcNUjl4Kjpo3eD6GxKjKlvYBpC5yhgvJSelO50d7
        xahZX713TIAb4K9l/I5J1Ww=
X-Google-Smtp-Source: ABdhPJwOC+VH1ItUocY5MR5+0dEvvtca8Eo/rZUkwGTsvktz0B4ZV7qWU/u1sqZ4Y1ulDcTps9maWw==
X-Received: by 2002:a05:600c:224b:: with SMTP id a11mr24308206wmm.97.1607890798961;
        Sun, 13 Dec 2020 12:19:58 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h13sm28766022wrm.28.2020.12.13.12.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:19:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PULL 02/26] target/mips/kvm: Assert unreachable code is not used
Date:   Sun, 13 Dec 2020 21:19:22 +0100
Message-Id: <20201213201946.236123-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This code must not be used outside of KVM. Abort if it is.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20200429082916.10669-3-f4bug@amsat.org>
---
 target/mips/kvm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 72637a1e021..cbd0cb8faa4 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -198,9 +198,7 @@ int kvm_mips_set_interrupt(MIPSCPU *cpu, int irq, int level)
     CPUState *cs = CPU(cpu);
     struct kvm_mips_interrupt intr;
 
-    if (!kvm_enabled()) {
-        return 0;
-    }
+    assert(kvm_enabled());
 
     intr.cpu = -1;
 
@@ -221,9 +219,7 @@ int kvm_mips_set_ipi_interrupt(MIPSCPU *cpu, int irq, int level)
     CPUState *dest_cs = CPU(cpu);
     struct kvm_mips_interrupt intr;
 
-    if (!kvm_enabled()) {
-        return 0;
-    }
+    assert(kvm_enabled());
 
     intr.cpu = dest_cs->cpu_index;
 
-- 
2.26.2

