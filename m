Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F02319E1
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgG2G6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgG2G6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:58:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25A0C061794;
        Tue, 28 Jul 2020 23:58:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k71so1447089pje.0;
        Tue, 28 Jul 2020 23:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/JsaGu+DqLCjdkb9eKuS4EjLjFTs3Rqu+dpqawZ+3vA=;
        b=O6wd3+sUiXuCF6ZFmWlYhG/FZWJHlU7QWquI2h3/4crIT47Rm5NjHnOGIkfQvKVoyV
         21piSz8fHE5GESvowTyZGC/aAf/Cvs1nGfHKfLrOzHd4b/L0Mg7e+PvTmofdAf26x7Qc
         yKvmeEY1bktMlbYQj4zMWgOsPBvJ16z7gA7ZgB3WFLWYD7BeNKaYEQA4qSbWk/oDaElU
         eF0Glg4qKlt/Jzkad+TxHnUZCZJpoUt+AC+vebnsWV0fQ33uP+BY5A+urxPL8/99xZg4
         HBDNGWYORyzHXcr7F7EO+1FiAkcpwSvp7eKC1PbVgLzAVJbNa27nqMK92Kri90Z+h7kp
         UYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=/JsaGu+DqLCjdkb9eKuS4EjLjFTs3Rqu+dpqawZ+3vA=;
        b=oQhwwYs94rbIF7MyZhlDcsscW0hoanad7u10luxtpAtjIPmnswhWAdl4B3pYkaASAw
         cYd1hiCUF1An9dbh5JMTBQhDqeUH5fFLzxz2C2VtCLdvTYMxi7SFYutrUVJk3660BnPf
         9QHbvRzn/RIbvsyAUl7tB9tWHe/9VfEAGfKZ2o1A9bYgJ6ZkmdC7MCSpw/e0gktxGgmS
         b7Hxl9Z2rxTuMI5jLAyz7Ghpd15xjqW5u0UOJDLef0CLYEIxmSPjqEHvPrm6AeIMAskj
         UShg0azXou/h3sUqJGMK04rvkjQECAEU3LaEM5kTjeZmXP2D4CwlljpCQwG/UZX1+aFn
         3bqw==
X-Gm-Message-State: AOAM533gFBh9cPk+/fCwtRmBx76Js7t22fJLVTaijLMfnPkgNP5TOekb
        uIDT2EsgumRLY/Ykb3zFF0Y=
X-Google-Smtp-Source: ABdhPJzS61vhIwx3YrLNhEbGfz5Ey1EWmr4zBvdVYq2KgaYRgaNkLzqohYxSj3V3whqO+r4gtvhpcA==
X-Received: by 2002:a17:90a:338a:: with SMTP id n10mr8687482pjb.50.1596005901278;
        Tue, 28 Jul 2020 23:58:21 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 127sm1207202pgf.5.2020.07.28.23.58.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 23:58:20 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
Date:   Wed, 29 Jul 2020 14:58:39 +0800
Message-Id: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
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
index bddc79a..5f9c2fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9441,9 +9441,11 @@ F:	arch/arm64/kvm/
 F:	include/kvm/arm_*
 
 KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
+M:	Huacai Chen <chenhc@lemote.com>
+M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
 L:	linux-mips@vger.kernel.org
 L:	kvm@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	arch/mips/include/asm/kvm*
 F:	arch/mips/include/uapi/asm/kvm*
 F:	arch/mips/kvm/
-- 
2.7.0

