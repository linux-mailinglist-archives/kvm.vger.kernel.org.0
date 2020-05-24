Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC87A1DFE80
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgEXLPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgEXLPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:15:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F364C061A0E;
        Sun, 24 May 2020 04:15:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so7243497pjh.2;
        Sun, 24 May 2020 04:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bj0wooED+Wjyt9Sr8B5IGNuRbFEUUY0ybuUX3ztY4HQ=;
        b=GtWTkARt/DtMby30Vwg0O4lZidcpPSu/cAWdYQvhHSyhntXjbfm64U60aGd37HNR1M
         anL6SfEEFFsDQkQYixuVSf+rWAXztcVrwSHMNShw7BOM1bgFtmYRY7j5z1LDE+OjoIJ3
         or1GEeD6BP7+/F1/1oYgHR/dM+zSR3uriyGH4LjZ5Z7+3rtd2mbmKehA9Ka+TIuRy82B
         977bU+UiuhGH2MSWC9LgvNmTfawVi36o+Ew3DT866hnO1/izCbDrv2z3hB4qaN7C8aQ0
         fLm+v+Cozj+Scw6P10GchScq/Dv5Ci+WI0+w/Zb8sG3uuJjfg0wFXgVK/oD+3bwnXvLy
         jDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=bj0wooED+Wjyt9Sr8B5IGNuRbFEUUY0ybuUX3ztY4HQ=;
        b=LoRV1bApUL4w7RZ1bH2V8pGDgTy9a7TwrLZoGImXlPoTZWRkdDVuKRdtBvhc1DD4Cn
         zInc/f0bsweUocZbZDDi52f2BSOnzr8dvCHEyR/ZaEihxvlghi2t5vb9mppGvzUxJhUM
         6Zp9F0GLn6sEUKILyFzB74xHKUE+yNP/4+87yNzkw/zIpRbmBymWhzbGecu2D8OdABP/
         osz/VvaOC97ycmiqzqlGVqcR0ZSxcGjQSew3w/THkEQvuM/Ah99t2xdohaW1ddyG1TRX
         txxrTXYe/iSQySDfdjsaxJLypBcwcRIMyCV96bKilzTOL3NdaHDY2rr0Nug7CoXHXSte
         40tw==
X-Gm-Message-State: AOAM532j2ZWTLIisumef+9lmQ/ov6P//Da/JtjSe8xmA3o8MZFDMziHs
        WiWlKUKoeMsxaPySrZld2mU=
X-Google-Smtp-Source: ABdhPJyk5c984oRn9AWljnmxMLpu4b2eoViSNXcne6XXAGz40MxZETWg3vM96PxZ4ZR5SbqX7JHS/g==
X-Received: by 2002:a17:90a:a43:: with SMTP id o61mr15135044pjo.179.1590318943673;
        Sun, 24 May 2020 04:15:43 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.15.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:15:43 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 03/15] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Sun, 24 May 2020 19:13:27 +0800
Message-Id: <1590318819-24520-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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
index 31c84d8..bee9619 100644
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

