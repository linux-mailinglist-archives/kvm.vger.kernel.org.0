Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03927502
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 06:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfEWETA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 00:19:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33280 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEWES7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 00:18:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so2425709pgv.0;
        Wed, 22 May 2019 21:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=lt42LZxMVNKVokraVTgtQcZH1Cqg/bWugTeamCcxdZ55lar6qmQkx4jWu+M9NGiLXV
         K/Qve5Qfivw/hLt5veZoSjOYE75v0Toxq5E7IcRzx/6vA5X9BsL83wSVeJp2RYeJ5iJ/
         pbQGZ8Vv3y8t7aPUN3chim/KJT7IAGxsMOjQwGVCLrH0sy/go3P8y0T1QZBZWthrNML3
         tsZz1XUiEfjp+0HBS344er/yQYyTAHgIAqG6AaIRXUESuVLlxzkjeZzZhQiVXPxDnDov
         bKEN+H0Jzuc7FZEclrlzoapq4kUnDvrPtbfY09Zx2tAqQLYalFpnJCsgc+2ZgVPgrfFR
         t0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyIsAgKxN8tvE2hNP2yzX9LrmM9i/7FrObscEtVyCho=;
        b=Tgyl41i5F5W53Y8bEipkPOHEOAsoHvYZsaNGE9ZRwPwgMQln2SyW9KF8h9IDPBt7pP
         xKIOBkByt4qULDFOgoNOOB0Oi249V0+hiGldDpb6KxVxzfVmbXflfb30ykHMywRWLAMX
         mMmXmNnxQ3s47jSPLqIrg0h8FcMPjBkm0Xd77NWyzVWYvurBattP1pjNdkoIt0ZK3z1K
         IQ88sOarmbLBg81AwCxPmDNUl2ijYvn4NGH6K5D8rCoMaT8OJYuU1SB5QQp+o4wqaXPf
         JnxtM2oEn1AoUaZIN9VPzBLGaDHLlU3ENNYivQ9z1DHzp1TJLtbG2WG+TscSV19pwfHJ
         s1DQ==
X-Gm-Message-State: APjAAAWk7GXNnuT3uo1FEcL5esE6QY06EPRvb9iootjW4eEkuhZeVauM
        +xrnVjvxLbtvUjb655Iz0SYy4qQd
X-Google-Smtp-Source: APXvYqyFFEWEeGpZiRcf8oj4nJYDRsPQkPOrHdx7WUGGw/K7u/qi3NwY18eTeLG66qTyjqTqlBq6GQ==
X-Received: by 2002:a62:6444:: with SMTP id y65mr101400603pfb.148.1558585138685;
        Wed, 22 May 2019 21:18:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id m12sm22991427pgi.56.2019.05.22.21.18.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 21:18:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/2] KVM: LAPIC: remove the trailing newline used in the fmt parameter of TP_printk
Date:   Thu, 23 May 2019 12:18:51 +0800
Message-Id: <1558585131-1321-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
References: <1558585131-1321-1-git-send-email-wanpengli@tencent.com>
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

