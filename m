Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01271D0B2D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbgEMIsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732413AbgEMIsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:48:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C045C061A0C;
        Wed, 13 May 2020 01:48:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so6563556pls.8;
        Wed, 13 May 2020 01:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NgUT9tq84isiHIXicXZD4qnZY4zEu1E8jGhDqHL1drg=;
        b=MIaiTeg8t4YhI7Wa/z44iXQ2USRtJfhXvSrkaQFJmqdGxciSSZEBJ5lUB/O9y/L2P4
         SZ5O2NrbkChwDdVZWv43DT1AMnwdcxrwdq6SJrgK7KXOjeSoG6mutlXhYddluslP6oYO
         vrxj6kF/Sdoqiiz43PD15CgycQAn9A3eDNL58GppILPoEYBH2l6yv9TaVqnNgOL3xsxI
         dvLsBuPsTfpC5RBA6pOVGYPF0J1cnJEEXDZk1Ilenv7Ne3oU+CgfrVEIw1fNjg1GRuye
         C4iwFbQUdt+LWjRn9+URbsxLdAB7FqSDSa8bkRhoE4ToYoE9qSvM1pArZg5TmaHabH/G
         3YIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=NgUT9tq84isiHIXicXZD4qnZY4zEu1E8jGhDqHL1drg=;
        b=kfO6dfRvHvzEX48xtBXP2W4ZV9TLzZdJ8IiVTbzSdAq2yoHcd4Z7LkVPX+ljFpd7kf
         qmPeYX+aK9J9yCGAxpi2WPIzYjSyIGHM0dQxACb1QdVtrVgO1J7cbOeOGBg+4j5Bc7rS
         KRwtgJodHRAWoH721nkwjUEudv5DJThqiIire4k1caMIW12Gz6WCc4lcZWrA1j8yFdfz
         Mwow8AkDEFBvm84BQ0eAhRDwzqEoZrZj4m6o80FIzWWKuoAe2QojfwrCthtHtlTUatVY
         VUgdpimMI0O+TD5KTW4mvo9FBEkLFfQjdOBCMkuwYmB4zau4vosifaW7HHZwGDyObpJD
         Hq3A==
X-Gm-Message-State: AGi0Puafb2LEow15B8V7nnfGU/JNL0DCPnegE8biNA+lxrKuKPr4JEHU
        dR0oVphRqNErTdgcSS1VIUc=
X-Google-Smtp-Source: APiQypLmtLeQhmID80+wwXma8IdJGa0cPkdiN1oqwror1mwDzN3chVhlZsBgaaQYeBClV+kDsuebFQ==
X-Received: by 2002:a17:902:c40c:: with SMTP id k12mr24925809plk.238.1589359699735;
        Wed, 13 May 2020 01:48:19 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.48.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:48:19 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Date:   Wed, 13 May 2020 16:42:46 +0800
Message-Id: <1589359366-1669-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

