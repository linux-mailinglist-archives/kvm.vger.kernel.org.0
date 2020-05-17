Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E658D1D6588
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgEQEHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgEQEHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:07:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD91C061A0C;
        Sat, 16 May 2020 21:07:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q24so3065082pjd.1;
        Sat, 16 May 2020 21:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=lImB1xMcpkK7dZ/lrb5YuEbXAPDvCnjvrPRhpYe1Cig+2YPx6yMNa8eSwBrjAhMPS7
         /RS9rsx2jIC6q0ufK3dfSu0CU1u7ei5bDmYO7rxdiM6D92sXN87QXpsrNm8DknSLfLRK
         YbIaRZQPZK5SHj9Q0lOx3UqP9RuGIIiAhgo+W8J+whajRFkcu1C1n7/q+Q/M/Ko5iSY6
         DAjQc4EAz9X+kS8q8p0mESzCpA8ploueG7D008Z5E+tf8RjsQQ9nPbiMqa2R+A3QH6W7
         VhZ3YCVKbn/kMPa494kQQFb5O4Gus6ePbt8LIbFvQ5KQojswYciaYIf6J/SbpA8pGApi
         q13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=fjBlf2MDvE6Bvjmu+XyR0b6QodeTi62QXwF83Ec41CNRpyvk5+NeI2assPYX+6qcTP
         eH/m8vH5s4rc5QZIryHdEyhYuSblODU6TZUYyhJeRPI1tbXslApvRNbkkP7eMZAhxzvR
         melgaC0z+QRgmN/ldMwcUiEQPYNjjwtl8LQt4YpM5k5NgKiFgjeovos9yoVH1rDQAUQA
         lcaq2/xmRc26uW0Iwt4P70snvibqjzCZHWwAOhJs51eG/XqZMW4FnpxMrvohVl8UhaxO
         KbuDikMqOQbbYI8l5kLSDEv8ddsU6JS/xiAYly94OWUl9rOXhX+ZUtNhxPHcgIkE4uPB
         6cEA==
X-Gm-Message-State: AOAM531h+mFaKV473M3gmP/py/pQyhHWoXK3q/Ip/ijnHE8tKVtUo/bs
        w8Xgh5VspJOOH9zJfz+c7Vs=
X-Google-Smtp-Source: ABdhPJyjU35AWkYJnRIyXi0J5Ehxc6v9Px3rJ/wMebmrZSMz8vOAgmsXNhWNu9d8V9q+TDmXy+IwFw==
X-Received: by 2002:a17:90a:f493:: with SMTP id bx19mr1950037pjb.45.1589688456880;
        Sat, 16 May 2020 21:07:36 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.07.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:07:36 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 03/15] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Sun, 17 May 2020 12:06:00 +0800
Message-Id: <1589688372-3098-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index caa2b936..a7758c0 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -78,8 +78,8 @@
 #define KVM_REG_MIPS_CP0_KSCRATCH6	MIPS_CP0_64(31, 7)
 
 
-#define KVM_MAX_VCPUS		8
-#define KVM_USER_MEM_SLOTS	8
+#define KVM_MAX_VCPUS		16
+#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
-- 
2.7.0

