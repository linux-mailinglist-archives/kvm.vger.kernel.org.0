Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C1A308D0
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEaGkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:40:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40555 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfEaGkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:40:23 -0400
Received: by mail-pg1-f193.google.com with SMTP id d30so3464511pgm.7;
        Thu, 30 May 2019 23:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=guZjTG+yhohBK+5xRV/yJB3edatmqAN0OGnFS6I9WnODM4oT7b9UMVx0lTa8IJbgrI
         TzeOmbyhxW38/q6iieyz49n21t1mcc9OFwxbbrDO7E2PRiXvJ8MAopEWQzO4l8dORWKx
         dJUAvKnY+wBfm2id4OCuXxU6tfJLwhjsarEEG8Ketjrrg7GHWGiZYfJ2Ddw9YQgUQqvT
         qNsczuHBE/V54e8b0Jd+DJgO8fJH5Ta+cSTLR+xU2btmAb32t2Muhu5fjyGdFnrMGSxt
         5iIbNl2/2FCstPyXowcDCP316VdmWxfbCcjovTywKNcncnRQb5hCmKXY+phsoOitB9wz
         cZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=oxds6pd/ggBwjFy3SmP7UVMwFo27zdr9CbBmt0RllnZ+gMD92SBOzyGusmTtuwmSHn
         fTcQVH9Kf5d/KSdxjbc0wGUKPa/qMpIDaSxZkhDJhEfJt2jktKQYn4uhjAu/cTg6FoFK
         jmDOMQxx0qfm4dC+ujxHEMxhhgzbcqzZ1TXUq3grlJhu3MQzITROte1gH7qeJiMo0JJ3
         fY1jJ0dGI6+/Sl9FbJee6w/oDdFQ62lY0qFkeELc+YKlBxqqg8qvF8zKkQxOF/aAkaun
         3FdurfIYXeE2leR/qx4TgxEQpXPyoqKenyGNU3TRGo6y0qphnGuLVf+zgEQhuBHfD5zs
         oejw==
X-Gm-Message-State: APjAAAVAniMvArFLFjITN+aDm1+If8wghvmueQvlUJRaFlb3Em2LFoBv
        K0b1mYbwka1WWKtiFJabX7y19SDi
X-Google-Smtp-Source: APXvYqxHVrOkl/WFTQ43mZ1YUEIwlqHJRUWA0gUKOqBPkl9xdHk1ZTY4nApHdURiYgfCoqeUhSgvFw==
X-Received: by 2002:a17:90a:17cb:: with SMTP id q69mr7358642pja.106.1559284822040;
        Thu, 30 May 2019 23:40:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id w4sm4658574pfi.87.2019.05.30.23.40.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 23:40:21 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 2/2] KVM: LAPIC: remove the trailing newline used in the fmt parameter of TP_printk
Date:   Fri, 31 May 2019 14:40:14 +0800
Message-Id: <1559284814-20378-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
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

