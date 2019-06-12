Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A0D42133
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437643AbfFLJk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:40:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32976 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437638AbfFLJk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:40:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id k187so8128115pga.0;
        Wed, 12 Jun 2019 02:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=aeRDCbTpzSaeLvHkLXMdJ9mDGh48mUtrozAhm4VPBG0ztWEHmGWOqQfIW7Kj2kJ2Mx
         0CrQ4uwsXXzhJ4mUG5eVY/MbNF1ZWA3AXJ4rKIwzVhZ60FWAcOb7Fr/HkPl7UIQGnQKZ
         1XM3rAZ6QND2S+nJNOD+3n0L9hXd0KdW2v8YotCYVka8DDFx8sVaF3EJ0muccJytGReC
         g+y/4QHBb3ulR6Gbn4zLU3IPmgeDAGldGsqPK1PnMV1z+m47ZxCYXrFVKUjIGAT+5gnS
         5wZIIIWTYNOncfSoed8w5Ih8sTduHpTq4IbSVsr2o0dA4KBhGZgjcxjnIUUnxYKF1i5y
         bOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=tbXNy9lBVBk2dSReKHKLtmlhwHci/2QUoNb0m7ci4wl5ZMDOM72NDM5rqPrcLmYsoz
         bnpFisQw8X0N7tyzdg40t4FDZhAugX7MHf24+Is12OALdIc7/pMb++fKsiRjAEWsCJ02
         WlUoUkKB+mnEthJxUGd5elQ9Y82Bm++r4UihvOJO4vEtnSe41uUWYmnvGzKMwzcB7Oaj
         o4Y2MT+ZeabgyTgdigLAxNIezVHYfbZc+m08vh0ywhpNu9UaKMSmrDnmGLyStG5+f0uK
         8OZeU5U/7ddBRmWq+4RVZ8bMprV2Yyo7aXII8SgvHVbXS96dd4x0jeptZFtCA1hFLW0j
         UrkQ==
X-Gm-Message-State: APjAAAXNivJZ0IgvyqZX4knnEX/ahRmFWmO95wc7mUEb86njOOReO/he
        EMuWBYkteGYtYrG61QfmQAZ2iXKl
X-Google-Smtp-Source: APXvYqz2PUdiZ58BZRnD7I+FMT+w9mQcyBF/A05Rngk7C8bmI6RqmVn659y4jM8SeRwgNPzJ6ZDKJQ==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr12661350pjg.116.1560332425832;
        Wed, 12 Jun 2019 02:40:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k1sm4706993pjp.2.2019.06.12.02.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:40:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 2/2] KVM: LAPIC: remove the trailing newline used in the fmt parameter of TP_printk
Date:   Wed, 12 Jun 2019 17:40:19 +0800
Message-Id: <1560332419-17195-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
References: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The trailing newlines will lead to extra newlines in the trace file
which looks like the following output, so remove it.

qemu-system-x86-15695 [002] ...1 15774.839240: kvm_hv_timer_state: vcpu_id 0 hv_timer 1

qemu-system-x86-15695 [002] ...1 15774.839309: kvm_hv_timer_state: vcpu_id 0 hv_timer 1

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d47a26..b5c831e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1365,7 +1365,7 @@ TRACE_EVENT(kvm_hv_timer_state,
 			__entry->vcpu_id = vcpu_id;
 			__entry->hv_timer_in_use = hv_timer_in_use;
 			),
-		TP_printk("vcpu_id %x hv_timer %x\n",
+		TP_printk("vcpu_id %x hv_timer %x",
 			__entry->vcpu_id,
 			__entry->hv_timer_in_use)
 );
-- 
2.7.4

