Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18AB583819
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 07:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiG1FJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 01:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiG1FJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 01:09:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC4A4330B
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 22:09:30 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b16so1231951lfb.7
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 22:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6yrB/ZBc4AaM3PTfukDFFQkMrZq8R3ioHC18SLmmnCE=;
        b=SFbshZNfUR6fj3yOlseyUXmASXN7Ndx1R2N114OGFVKoPkMztestZ8+XD0sQ8vwgbT
         NNC3vqpUnhH7bkcbj4maY6IXvwePDvlrKkLUrjvykaK3iTUGsv0aAL7LWQzm6+terH77
         xxToBOr6pza3KlooBagacWXTgLIyaz+TGKQfKxcMLyfQS1b3zbRISM7lYte8ubSx7s3H
         hebKfPmgsldIC5ZtXBUmasGm1Tneynr/dyp58j3UdEEj12QffQcZYq1+3Is3iVzBbPkA
         lyvpmc51URJu9nZX6yp6sQ6i57IFy5MKRCncvHuHhxCx6eiKA5RB0C+ZwPrEbPBezUk0
         oiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6yrB/ZBc4AaM3PTfukDFFQkMrZq8R3ioHC18SLmmnCE=;
        b=h5ydhs4hRiR1T/6s/Ja4+ixX78yjppRc+gsckLQY+GhnyJx+O/bjx4qOuq4OTamd9o
         Y6XFn8+3yY2QAMTysCHbxbhF0iq+E4JIHPCesKytXradkwsw+37bdm/iK51NM4+RsxY3
         E80yyEBXjJHSxE7HT+HwcY6H3QxH/qE4QhKB9FiuEjPlcZXgHlbVq2mPN69ZfP59gJjq
         ABY7+r0Jwi0kfmw5/NwqPzbqF+0zrgAkOSm0EDQCmAyxYeejbry9+9Ya1UcIK7qIPk9v
         vNvk7GR+srb4g4XVp4EIqH+4lb0jZ0i3NYWs0DmtV8QJm+JAwrHja5sVnQmlKLlGMzFj
         nmhg==
X-Gm-Message-State: AJIora8dNgbstvwCWItL/J963s877/BhXWnZ5TLk9DkPEi1nKoob4Iid
        9xf6BOiP3pUWQv3vNDqSjqJKMg==
X-Google-Smtp-Source: AGRyM1ukyRHrsKJyCxB1lHW61Pb2+N2oTKS6DJ1xfcjXT7zFr/hyTS5v2MYD/uVnObDEvnDV+pCWoA==
X-Received: by 2002:a19:6715:0:b0:48a:be20:6ffd with SMTP id b21-20020a196715000000b0048abe206ffdmr1652390lfc.383.1658984968405;
        Wed, 27 Jul 2022 22:09:28 -0700 (PDT)
Received: from localhost (91-154-92-55.elisa-laajakaista.fi. [91.154.92.55])
        by smtp.gmail.com with ESMTPSA id 3-20020ac24843000000b0048ac922aba2sm6419lfy.103.2022.07.27.22.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 22:09:27 -0700 (PDT)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Harald Hoyer <harald@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog
Date:   Thu, 28 Jul 2022 08:09:19 +0300
Message-Id: <20220728050919.24113-1-jarkko@profian.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As Virtual Machine Save Area (VMSA) is essential in troubleshooting
attestation, dump it to the klog with the KERN_DEBUG level of priority.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Suggested-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0c240ed04f96..6d44aaba321a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -603,6 +603,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	pr_debug("Virtual Machine Save Area (VMSA):\n");
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
+
 	return 0;
 }
 
-- 
2.37.1

