Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC61DFEA4
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgEXLaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgEXLaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:30:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483B9C061A0E;
        Sun, 24 May 2020 04:30:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so7545980pfn.11;
        Sun, 24 May 2020 04:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5Yk9BWAFLYIgCHybgnXqSCp+laOiF9sXxMKKTKUlR3A=;
        b=PqxJ6OmDWHNr1/8daqaY5JSMm2E9ApBCD7jLYa2eb/xsj//zZKAKoMQY74xfDXlcyK
         AoqYdPZol9yIWDpMwE1IfNYryUrfEA8XvqKex8Ha/sjuK5BYrtJuAa6aqQUf+RVPoZAj
         FJtoxlKwsiZDjrHe8ugPNg8aTCEfLXpPGVV23i7ueSqQsd+UduhkvY3A/P7K42kKMyOF
         0i2206a7EswSR4dmWb06HQxV+nd1o2r2Ayh04aPH2pl9X5J59mvHHGaWuRIgcay4wUJe
         Kjo78rLuKQJ/V2WA/4cwHpaCInwfqZQ+XQKL4IGSgKZ6EmRqvYjgOS2+0bSBy5SZtUzC
         A/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=5Yk9BWAFLYIgCHybgnXqSCp+laOiF9sXxMKKTKUlR3A=;
        b=kzWhAU2lfbs0/JDPOVQMbZC+heoqhuBz6LT5SXgI/Ix1es76Lj2ZWrahTBThoi51om
         Gbb5P+aiUTLWx/8EKBaj682FYNzY3xIuO5ax/l1M2NsEA7aR1MBlWiUTD8CV+o4fFx8G
         TDGj7RhRcwv1Ai77v0S5wqIhpV1RhXxrgUQJV0R9kTzboH7eOnA5hXkJYdj37nmuZcd6
         3L59oVI3BlcG4Wb6Wt1LMcnViW+DW3IUedpPbYu2e7WSAHibYfr8Z8R8frBn+1waAsl4
         /5Po/D12HK0L1krvyDHDsWMX3NQl0ctsSRBFsEx7Aq5Us+ZMRx4JAVbURY887jrpUsUl
         XDng==
X-Gm-Message-State: AOAM531MF56gCtyom2k9uSNFs/IRsPL0yHpJzDWaw/+l56a1HwDsKPor
        bXrFmqkr0/oRXL7VDiscjtY=
X-Google-Smtp-Source: ABdhPJy6yAWp/zGwRpNu6XSBTOVyX0DTazfi5MKs5NpFIlQB0ko/5fEyb/giHxw6USSz5anH1CEcBQ==
X-Received: by 2002:a63:2246:: with SMTP id t6mr22460220pgm.211.1590319818909;
        Sun, 24 May 2020 04:30:18 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.30.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:30:18 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Date:   Sun, 24 May 2020 19:13:39 +0800
Message-Id: <1590318819-24520-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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
index 091ec22..e75d297 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9298,9 +9298,11 @@ F:	include/kvm/arm_*
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

