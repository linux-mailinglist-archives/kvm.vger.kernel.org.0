Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57EA268801
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 11:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgINJMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 05:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgINJMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 05:12:02 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6066CC061788;
        Mon, 14 Sep 2020 02:12:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so11007339pgl.10;
        Mon, 14 Sep 2020 02:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ypxASSpGv9RIPFq+dUkv+nkukyOjiOQi2ZMQ5W1mvNk=;
        b=Uurm7Jd47CcO0M+kkGP0tmTl8T9VQR/tQQa1rDxBBvHy82vEyY3rqxEpnFLxSMnvQu
         7qIlSd/7ctImd9YmtQB6m0XJNOXZLgEwArVoGLDNdExMuF2NEg5FOKL/nTN7KJ2DUNGv
         31rcOaRlSzCsJnm+alV9aFYc/AQYkdyMcgXlt3Val9V+3ma/PrdvlWkgjDcTTBALLV13
         lj9vFFAQ/vXNu6cbNmHj/KmfzHhm97h0a450AG9A5aZQLNVuWmdSJVbreQtBnpZmbfm8
         kCub3VTlDnnnnYewjCJC7bpie/qfBs+OBTXzX8BazvkK+R4DmBlISUS+l4/nFw/khP9R
         tJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ypxASSpGv9RIPFq+dUkv+nkukyOjiOQi2ZMQ5W1mvNk=;
        b=nAuhy+t+1rIRw6qKoKQKdqilYtrpr2S3FQWL7rkIwtdpWGFyrqvGknDWCa0VXABHWx
         FAs6cJ43aa+SRCm9LwLsIDmpCbaVKz73rwkGFKDtTXhNpa+zn6kVzrYaXATnVuEIOvLE
         aDV4F3kSswksPm9MaTsGA7ItPJrXpDLtdgioD7RhFeLUDdXgnnAXC6rZwsVHZKgGuukZ
         1pFmucepwbjXlat4meOceXyKZZGVnHRhpd3JWiTAxxNGWSNqewmsH7XlB4sIDHL7KgZS
         qVwiYCoIc5JGvX8tI+kAjp9885OnfiMFsR0jOHch8CRsuuEiJwuO4bu9mzSaMyZwC1SN
         Ianw==
X-Gm-Message-State: AOAM532xADwSizGpNw3AV7VgDTYYZvb4nx/3MajjAHveO2Wxlgs+Z+sO
        ck7UkP3jfq4l0N1Zb4MVDP2/RQk47rhc
X-Google-Smtp-Source: ABdhPJw3LSalbk6bdlfVzuY79OzxpwkR1KzT5aX3N76A2GkC//bQUISzqr0TMsDOQCG67FaFcx8a9w==
X-Received: by 2002:a17:902:8c89:: with SMTP id t9mr13290222plo.66.1600074721684;
        Mon, 14 Sep 2020 02:12:01 -0700 (PDT)
Received: from LiHaiwei.tencent.com ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id m13sm8765179pjl.45.2020.09.14.02.11.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 02:12:00 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, lihaiwei@tencent.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/2] KVM: Fix the build error
Date:   Mon, 14 Sep 2020 17:11:47 +0800
Message-Id: <20200914091148.95654-2-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
References: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

When CONFIG_SMP is not set, an build error occurs with message "error:
use of undeclared identifier 'kvm_send_ipi_mask_allbutself'"

Fixes: 0f990222108d ("KVM: Check the allocation of pv cpu mask", 2020-09-01)
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kernel/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1b51b727b140..7e8be0421720 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -797,7 +797,9 @@ static __init int kvm_alloc_cpumask(void)
 			}
 		}
 
+#if defined(CONFIG_SMP)
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+#endif
 	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 	return 0;
 
-- 
2.18.4

