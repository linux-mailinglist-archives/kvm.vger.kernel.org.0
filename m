Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E06749B151
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiAYKE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiAYJ7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:52 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB7DC061757;
        Tue, 25 Jan 2022 01:59:51 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id u10so14717391pfg.10;
        Tue, 25 Jan 2022 01:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2dd3yWlp7t7pUwagBpLgmf/wkJEyGPWss2ymxB0oGHo=;
        b=jC4Sm+nkUlDMgAPZXuN73FYNW/Z4JlUQZx9m0wPJtOe/TIjnoTDMqt+a32QpKq5zv+
         RPjWRCKyBpMNhwI/EQcLAUbM6OO/EDb7Rygw+0+W0nHcTjx/LXlbG4rXcfyrw0gYOasU
         B75qAj6TeLYa34LX+x3qhcGu2p9HvuxfOQKkhl3kTVwqnScorGnRY5R8pO/Mrpc8h9Ib
         pqersKjlq/BzCdmq5erlJl/bSDqV0cZQHuJrCPO2Gx6ezIo0oQ279edHM0y6bv9IaY5+
         300Q6s8byykPqIGAQmEsJuDWhmgM6dVVa3keXi3539+EJW8RkCAxYBQ+MreBKIOL4+Nh
         J+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2dd3yWlp7t7pUwagBpLgmf/wkJEyGPWss2ymxB0oGHo=;
        b=OdxQwgo+uTXLJAEeAiFOGnqzbn1a7gNIHFh8qCd3nO+pev/hcJFuISrFbqCAyY0fhb
         6ZnTbSnujV1dN/O5p5LOkrpNT8FcOQi4ofVAU+uwlR+vZu9+OPzu4CgFeQyh0jSz/UyV
         DBiFiu11pWQZr8vU6wP6FVWN6Wd+JgzGM2uZ5kxrlnYjHQOUFia2xrwbyrRq26qhNbDW
         i0yDNKDoyO/evG0c/f2sbvG+bPw1yx6XlTI1XhlpPy8rXrkyuK3ED/n2MqxyDoMN0Yhk
         Q7AVf5DHIwjdiokXO2DlqumUHNlGJEjRaxIQhkhlLSUWiIp+EQhHnfJ/uodQp7VdVbOL
         qVlQ==
X-Gm-Message-State: AOAM533rr3OFJe/HbnqqmHKuT703lZyLnJdZY04Ywk/LfSdAMv4liMMP
        k8nrCEuyjPo9q+jcB384lyY=
X-Google-Smtp-Source: ABdhPJxyrj6nMBx1HXE+BU8tZnWfLwnZQtbPsFDyqQr6OzRIaEDbRM13Gm24MEqImq8PyzBv8bvTjA==
X-Received: by 2002:a05:6a00:a92:b0:4c5:90cb:71e4 with SMTP id b18-20020a056a000a9200b004c590cb71e4mr17548664pfl.1.1643104791447;
        Tue, 25 Jan 2022 01:59:51 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:51 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] KVM: x86/emulate: Remove unused "ctxt" of setup_syscalls_segments()
Date:   Tue, 25 Jan 2022 17:59:04 +0800
Message-Id: <20220125095909.38122-15-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct x86_emulate_ctxt *ctxt" parameter of setup_syscalls_segments()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/emulate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 166a145fc1e6..c2d9fe6449c2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2608,8 +2608,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 }
 
 static void
-setup_syscalls_segments(struct x86_emulate_ctxt *ctxt,
-			struct desc_struct *cs, struct desc_struct *ss)
+setup_syscalls_segments(struct desc_struct *cs, struct desc_struct *ss)
 {
 	cs->l = 0;		/* will be adjusted later */
 	set_desc_base(cs, 0);	/* flat segment */
@@ -2698,7 +2697,7 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 	if (!(efer & EFER_SCE))
 		return emulate_ud(ctxt);
 
-	setup_syscalls_segments(ctxt, &cs, &ss);
+	setup_syscalls_segments(&cs, &ss);
 	ops->get_msr(ctxt, MSR_STAR, &msr_data);
 	msr_data >>= 32;
 	cs_sel = (u16)(msr_data & 0xfffc);
@@ -2766,7 +2765,7 @@ static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 	if ((msr_data & 0xfffc) == 0x0)
 		return emulate_gp(ctxt, 0);
 
-	setup_syscalls_segments(ctxt, &cs, &ss);
+	setup_syscalls_segments(&cs, &ss);
 	ctxt->eflags &= ~(X86_EFLAGS_VM | X86_EFLAGS_IF);
 	cs_sel = (u16)msr_data & ~SEGMENT_RPL_MASK;
 	ss_sel = cs_sel + 8;
@@ -2803,7 +2802,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 	    ctxt->mode == X86EMUL_MODE_VM86)
 		return emulate_gp(ctxt, 0);
 
-	setup_syscalls_segments(ctxt, &cs, &ss);
+	setup_syscalls_segments(&cs, &ss);
 
 	if ((ctxt->rex_prefix & 0x8) != 0x0)
 		usermode = X86EMUL_MODE_PROT64;
-- 
2.33.1

