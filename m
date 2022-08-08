Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B558CE4B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244228AbiHHTGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 15:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiHHTGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 15:06:38 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82327B83
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 12:06:37 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id i84so7874541ioa.6
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 12:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DfkYWLinzITcd/FJI51hf3bH49wjjl87W/fTyl+XXYA=;
        b=KnuCUT3+QBXT0EVXP+LbdiSG5CLJ3zJmeNDuR+4pqdnGPgyDrAg7SnOg8S1imSdBkf
         MtLWzaleN9Zvz8IwTnM4do1QofcWTqe8Jq2AMdRxO3aRnWuEH/Eu6rcGWyweC0GZQ4nb
         kU433WHsLh3X0wXBa9p01pHjHYZpDMocJkCxizLpVE0Sduc+GWzWGH0chtieR7/BDp0D
         cijh+MCJGYfQnXcdnARpuNT25CsPPeoklFEuhrA44f6aWpu8F5h4HZeDNymhEvYvA1dg
         Muu9xYQU3NT6ZRwXYPhgg/xRD2lfeILv6lS/N9YWuaTxTyB2wOadymrXSjFdKn7VS6SE
         17Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DfkYWLinzITcd/FJI51hf3bH49wjjl87W/fTyl+XXYA=;
        b=xhi1IYvd5P43MAZcSsp3xYi1WXoAGFqKBAUIS9f5AKOZ6DOPIVD/vOuZ6CPHrWMT0h
         VxxgWNaXOYZqLQbe5DnWCP2ZmB6jB6EC9d8Q+LCsMpaEAiSJsMmif4RDpNqYWaQvW0UX
         DAlQQTO+FTIdrLrnfscgFsJo+xOEGFbT3mT90DJ+lr/pOmJrminJkJWh0r9hHXzzSQ/A
         KYmD9n45jM8+7O69Drks8qAr4bpqNZ35THtUcTivIMqJqq1yz1NyXqnPfC4hdMnQ/bGh
         HyXzEeJUDVvPmkdRIJzCHoXnFrPrUIrXpy7H75csjANtVu3a1XvatKcpGOQ1KptAWZg/
         0CfA==
X-Gm-Message-State: ACgBeo3g1+JK0cevNMu8yevc38bmwmiMWz5AmuAlZGMdvZWp14KY9tn/
        jjIfw09FHtGAph7fNeBVtLM1oQ==
X-Google-Smtp-Source: AA6agR4juG/N3jgczX70o0Dl3DOvEQ4/ob1i7PWSjLhiBKoVD/uHlbCBcNDorCHqYK4EVygW1FnuOg==
X-Received: by 2002:a02:238b:0:b0:33f:4ccb:3139 with SMTP id u133-20020a02238b000000b0033f4ccb3139mr8959740jau.20.1659985596901;
        Mon, 08 Aug 2022 12:06:36 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id c29-20020a02331d000000b003429ee6ca96sm5380638jae.1.2022.08.08.12.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:06:36 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     kvm@vger.kernel.org
Cc:     Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: [PATCH v3 1/2] KVM: x86/xen: Initialize Xen timer only once
Date:   Mon,  8 Aug 2022 14:06:06 -0500
Message-Id: <20220808190607.323899-2-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a check for existing xen timers before initializing a new one.

Currently kvm_xen_init_timer() is called on every
KVM_XEN_VCPU_ATTR_TYPE_TIMER, which is causing the following ODEBUG
crash when vcpu->arch.xen.timer is already set.

ODEBUG: init active (active state 0)
object type: hrtimer hint: xen_timer_callbac0
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Call Trace:
__debug_object_init
debug_hrtimer_init
debug_init
hrtimer_init
kvm_xen_init_timer
kvm_xen_vcpu_set_attr
kvm_arch_vcpu_ioctl
kvm_vcpu_ioctl
vfs_ioctl

Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
Cc: stable@vger.kernel.org
Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
---
 arch/x86/kvm/xen.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a0c05ccbf4b1..6e554041e862 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -713,7 +713,9 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 				break;
 			}
 			vcpu->arch.xen.timer_virq = data->u.timer.port;
-			kvm_xen_init_timer(vcpu);
+
+			if (!vcpu->arch.xen.timer.function)
+				kvm_xen_init_timer(vcpu);
 
 			/* Restart the timer if it's set */
 			if (data->u.timer.expires_ns)
-- 
2.34.1

