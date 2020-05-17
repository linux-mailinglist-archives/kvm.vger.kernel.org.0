Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B9B1D65A1
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEQEKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgEQEKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:10:06 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77601C061A0C;
        Sat, 16 May 2020 21:10:06 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w19so905359ply.11;
        Sat, 16 May 2020 21:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S4t0BAz54g44/yImMSi8RIGNeAEi5F5MA/1xaKB4LNI=;
        b=cCNQfyRvCAPTe96NmvKICg63Zvu8gXnVmaHJ7Ao+gbsbYDDUqqcofKQBCS1Z6+RK+r
         g5VVgkXSkOu74HikuuC3ycaMSN+oaZdTWdkmWZFcTRn6fJ7Mh/q3aEDLAk2Qu96pHKZH
         BewLw7+v1zaK21WL+nmUT2araAy1N8GvTRUVdW00uC82YDygLSBbQSL1dekI+DnpX7GQ
         O/2n8cGi7rZu6ztULRlpfki927AR0S0bQae1oCvKUxbu16L3bxZPQkyaLJQgzYm012az
         bub+VHRYskzTH69XvCb3P17GzYqvn4gkRR+pFYrtYivifri1kSeTZ4tLBcTRyV6pQ0Ya
         QnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=S4t0BAz54g44/yImMSi8RIGNeAEi5F5MA/1xaKB4LNI=;
        b=a5MCfBXi9wNPMjPWIvx6WyyMoIQ5E88LGnI8hj9BcFXw5SHlWqnjPlU3BM9Oucc0+x
         HRuv2G01/wHcZFy+qiPh0V9Czm9hFzhoNjyDOAE1eLllmpIcXZx+wksANbcdPBZ/o666
         jIlXAwQEgJJAjQU7Z4cJdkIX9sc4V4Ae2qWxO1aYyCpKspaRwJtNyBf8oTZZv272o2uE
         dzhDmMcDiQXMue31VAleOJKxxBnxqvEy74R5lYAuVxbx486Fs3UBhdaCaZmYF/5EgEIL
         SrvD1BTEBFL3wipCvAyHlzZYtg55FfJaIHd0N/M1++c06FqHh4jd8zzbc4DCb2bdmGYv
         kKJA==
X-Gm-Message-State: AOAM530m3hXlM+Vf6iMBnEeU8j8/gHSixeg+qNfSMhOYzE+DPAJERzOK
        yjatM9MYXJiZ47gNx4txqHk=
X-Google-Smtp-Source: ABdhPJyiLnZ22F+Wdi9lOVPEXyJe4BCSv3OeubOnlRSNqd8ec+YA+v7PeKs7WwALAykS1Cy/5p/LKQ==
X-Received: by 2002:a17:90b:614:: with SMTP id gb20mr12804973pjb.211.1589688605998;
        Sat, 16 May 2020 21:10:05 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.10.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:10:05 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Date:   Sun, 17 May 2020 12:06:12 +0800
Message-Id: <1589688372-3098-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

James Hogan has become inactive for a long time and leaves KVM for MIPS
orphan. I'm working on KVM/Loongson and attempt to make it upstream both
in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
made some contributions in kernel and QEMU. If possible, we want to take
the KVM/MIPS maintainership.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e64e5db..59b3f43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9302,9 +9302,11 @@ F:	include/kvm/arm_*
 F:	virt/kvm/arm/
 
 KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
+M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
+M:	Huacai Chen <chenhc@lemote.com>
 L:	linux-mips@vger.kernel.org
 L:	kvm@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	arch/mips/include/asm/kvm*
 F:	arch/mips/include/uapi/asm/kvm*
 F:	arch/mips/kvm/
-- 
2.7.0

