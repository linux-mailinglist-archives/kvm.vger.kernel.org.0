Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4B1DF5F4
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387766AbgEWIEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 04:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgEWIEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 04:04:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD185C061A0E;
        Sat, 23 May 2020 01:04:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 5so6059338pjd.0;
        Sat, 23 May 2020 01:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S4t0BAz54g44/yImMSi8RIGNeAEi5F5MA/1xaKB4LNI=;
        b=EH8q3NSFmKsA01RJO0KP7Usfh3DKXV9YIZVARPQcmtjoIDdE68s7brSRlqRd+OEP3W
         HEsR+d9XTwEcUbx1n3hNHSvHdqVhST/smCxKe27mi2KpWpT2/mZJY0gM/S1alvO/53Cu
         GdwbAcZ/lF3XgF2t5qNUbXxvozn7LcCbL9DpLfA4E46qss40qURiXaaY2PoRGZ3iVhWl
         aG57SPPE5qNlBEa7/yp7JrIJZC1xZ5VKeDsKfGJkaiAiIid/JJjMtYZfm3g+w/zjXAIq
         EpiV0jrtMhPns+31mCutYt0wSVlVC5AOzQd7g4Y2r9bQrzEQxOKiENaJceTX6jLZjRNE
         Mt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=S4t0BAz54g44/yImMSi8RIGNeAEi5F5MA/1xaKB4LNI=;
        b=S5Sku3NMN3YOaBhBzhfNAfUjCv5Nxyr+7yvg3dkSOREHM9C9vkZofG/Ij9N483Rfbr
         7aRHqgY3pVBbhgyir+7+seddyDkzvJ0ZswYDdjjCm2c48d7RD62ur95F3HZFwk9Wl0Yh
         jt9/bT6IVAWrr+I3Q2XGmodcIZDjAQPh3cjCISpJSRs/AGdFdRorvgcMyIjj/ra4j5Gz
         FuZAGVFGj8E80XptXaxIcrcou03mMQwR7/PJazrqXSfkltQULn2UpK3f+mQVTYN14Ea2
         NPJun7jeDSeHPM64xQMYwJS1i8LLVdvt8cVtJ94OHKhsu28z343aOwMFtWhXw+anSLFX
         /Ipw==
X-Gm-Message-State: AOAM531SWqlG5eH2lnuuRPoAatVjANFjG+GILAQ03Q9s4LGa4LjKmhMU
        qi2xu/AMMYL7xjLQ/9sEf+U=
X-Google-Smtp-Source: ABdhPJypUTbqDIG8zaPD5wp0WFK7Hv+PzmCTzoJ2TNJ+cPC2rvvk2F7iVcO2pOfRHlvCAUIe2CaMmg==
X-Received: by 2002:a17:902:70c1:: with SMTP id l1mr4269557plt.178.1590221063212;
        Sat, 23 May 2020 01:04:23 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.01.04.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 01:04:22 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Date:   Sat, 23 May 2020 15:56:42 +0800
Message-Id: <1590220602-3547-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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

