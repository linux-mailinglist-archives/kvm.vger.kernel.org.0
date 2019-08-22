Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDC996A8
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 16:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbfHVOak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 10:30:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42535 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732001AbfHVOak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 10:30:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id y1so3565592plp.9;
        Thu, 22 Aug 2019 07:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oI7D6WyA6/0Ot6DL7sm+Im0+wd1osEcKoYF4hLt/A6Q=;
        b=bqTEvUnG9CkxP0I0rRb+w5sdxJLU17GgXMeLehe0ZeJLc1H8Q+A/G63lfshJ7dSmBs
         4QuzgmIPwYM/yc7IJm1Q/tyT7TvUu76f+teotVFE79psBYuRFKjV59gMb9fVnbK3/Lav
         Yugy/a96E6FUTbV55wqOr2NI4vUXMd+FHoa/sdzrQ4E5k2IZiw4Vbxrm72TgaOiqrIxW
         j2kQOyLzNDZ4T8mvNIWwJkFr01XmjHI8ACD8VpJ99URVNWHAxtDsTRealke7jl3RLMNA
         ST5FqTS7Lo8hxUERZMN0+LZX8djDFwjOElp1UyDs3l75RZXCugFq+S5jae5G61u7XKnL
         5pMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oI7D6WyA6/0Ot6DL7sm+Im0+wd1osEcKoYF4hLt/A6Q=;
        b=VW37oEMPF/rJlmz4ekRezqVZvylWaGnz4SCnDS0I9k5xxHmmBB2Ayv7xtApWnzzTsK
         AU4YbJ62gm0hSwi0qmKUancqEVQwDwe3ILHMkDYJqtChkywUfCCM587atThm7+V2yCTy
         ZiIsUWYyhwOkYMYgOKlU0dkwhxFxBiRMbrN7s69RyG0N6gipiowwFeXmchC0IAO3kByK
         CkCfikmMnXWxvQv1k0lo+3/UQVpZR1wqaOgWa2Rr3ZxuSkzJGaQF+vYBius5MqixBIOv
         y1VfMP4VtYGt4upNsukrI3PY+WVo3/M62LSJZAn2Bz0v4vi18WMD3nQOGLZb9TdoUVdq
         brrw==
X-Gm-Message-State: APjAAAWhRVgWg5xO4aWKY0ALz6XeTC5ZnjJS3gjDTm3H0wxqb6CK6j8P
        +wGF4dFlMa2tJ1SMgrbSYtA=
X-Google-Smtp-Source: APXvYqx/ED9fclzrzlKYk9uUT7m5f+KXtvtU5E2+5f5yuk7lBLyiPkGogN/krQ53jkucRpYQSLrw3g==
X-Received: by 2002:a17:902:9895:: with SMTP id s21mr25242438plp.255.1566484239694;
        Thu, 22 Aug 2019 07:30:39 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id r23sm32263161pfg.10.2019.08.22.07.30.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Aug 2019 07:30:39 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: [PATCH V4 1/3] x86/Hyper-V: Fix definition of struct hv_vp_assist_page
Date:   Thu, 22 Aug 2019 22:30:19 +0800
Message-Id: <20190822143021.7518-2-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
References: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The struct hv_vp_assist_page was defined incorrectly.
The "vtl_control" should be u64[3], "nested_enlightenments
_control" should be a u64 and there are 7 reserved bytes
following "enlighten_vmentry". Fix the definition.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	- Update changelog 
Change since v1:
	- Move definition of struct hv_nested_enlightenments_control
       into this patch to fix offset issue.
---
 arch/x86/include/asm/hyperv-tlfs.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index af78cd72b8f3..cf0b2a04271d 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -514,14 +514,24 @@ struct hv_timer_message_payload {
 	__u64 delivery_time;	/* When the message was delivered */
 } __packed;
 
+struct hv_nested_enlightenments_control {
+	struct {
+		__u32 directhypercall:1;
+		__u32 reserved:31;
+	} features;
+	struct {
+		__u32 reserved;
+	} hypercallControls;
+} __packed;
+
 /* Define virtual processor assist page structure. */
 struct hv_vp_assist_page {
 	__u32 apic_assist;
-	__u32 reserved;
-	__u64 vtl_control[2];
-	__u64 nested_enlightenments_control[2];
-	__u32 enlighten_vmentry;
-	__u32 padding;
+	__u32 reserved1;
+	__u64 vtl_control[3];
+	struct hv_nested_enlightenments_control nested_control;
+	__u8 enlighten_vmentry;
+	__u8 reserved2[7];
 	__u64 current_nested_vmcs;
 } __packed;
 
-- 
2.14.5

