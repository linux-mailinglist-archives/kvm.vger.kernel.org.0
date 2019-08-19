Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2192492
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfHSNSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:18:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46324 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfHSNSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:18:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id q139so1152152pfc.13;
        Mon, 19 Aug 2019 06:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XzmPhJrk3sYccy1T+84Jue9XGrfBlOC3sGHKCIWYcCg=;
        b=EwmiWA+hMiVVdcUocJGviVtaq0225spUIo76LJuwgcpx01tyfVJe8AYY1oXwjJXzVS
         RFSFU2O1oIXTfHlusUiBSxdsy6CBXdObNE9vMoyKC+7juhjSUy+ov/qAbyIojpVuDJdu
         lwx/SelwSMFMmdgXqyI2jAqEzrHW8AXJEHD0JzMrqyp3gmj8yaZ6OuwhWEHTwilRCOK2
         yMTxg3eMItGQhTVEdE0fvwzQgJ3fk8fs9tcTxAaYfMyr5BhIYNFPe4wHbnoTTuBgv6K0
         M61AIQM1xoItEIx69C7IhWeVTjmBZwn35TjWN8X9Rx1MgCDMLzfYPP9/DGzyLPNwnExP
         AcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XzmPhJrk3sYccy1T+84Jue9XGrfBlOC3sGHKCIWYcCg=;
        b=lnalLXjsPdqrFeYE0+e7bBU2pl+HI6Ippij8teFiAhohhM7zvA2v3bY74nM8XOf0tP
         u1DkRrhnw41fCnLOFQfEfWGfLLX+5AB4wa7SEaC8iu+4DEanIVNHaNhDSVKdwtOaa2Cd
         fLHZndwwVhSqMPDc4FZVire5CXMNWfOFKnBOnsOIfP7bXBm5Ju0lua/NKyHrexK35vLo
         VwjlPNujFu1xIvDUnG3VjuelmtfatP+Flz0+gpstHlxKJZMNbYCX0zMmQ10BzW9XGbuq
         1aUG3LQICjpQPwJNehH/NYA8c0IRQCLKZt2rpjekCM5kAQr6ZEFnr2BKbGP15Umt7pi0
         8yeQ==
X-Gm-Message-State: APjAAAWxZC6gIp++KQCxyvUKytRkuuT7UjHBD7hx0c4yC6oZ7TSB4WG8
        dCb//vanYPuVfvksLH/ONRr5xIIv+3A=
X-Google-Smtp-Source: APXvYqy/HXajUqBsSoG9hyffw5Qkz2hHTI71+UcFam797hR5va8vvK79kyFh0x3JMjkmVT9aWrVgBg==
X-Received: by 2002:a63:e610:: with SMTP id g16mr19472362pgh.392.1566220686554;
        Mon, 19 Aug 2019 06:18:06 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id h20sm16184329pfq.156.2019.08.19.06.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 06:18:06 -0700 (PDT)
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
Subject: [PATCH V3 1/3] x86/Hyper-V: Fix definition of struct hv_vp_assist_page
Date:   Mon, 19 Aug 2019 21:17:35 +0800
Message-Id: <20190819131737.26942-2-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The struct hv_vp_assist_page was defined incorrectly.
The "vtl_control" should be u64[3], "nested_enlightenments
_control" should be a u64 and there is 7 reserved bytes
following "enlighten_vmentry". This patch is to fix it.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
--
Change since v1:
       Move definition of struct hv_nested_enlightenments_control
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

