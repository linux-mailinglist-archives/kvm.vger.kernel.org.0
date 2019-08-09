Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DF787692
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406081AbfHIJuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:50:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46213 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfHIJuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:50:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id c3so22637288pfa.13;
        Fri, 09 Aug 2019 02:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7v0ZD4FYjg+FLfVFwXErFZLQw9JsPi1WdJqMJoDQ0Kw=;
        b=h6eqP/nxme/nZg+0hsUYCcZRnSHf8WbQUAHog3lSQRpBom3rDrlXJqX1pTDK12paRq
         8dWJ5+pbjSdEm2n2z7uHFUBdD0pSP5aBP2fOmwDfg41Yftp0fC8yK8HInLzaRWvedu93
         D+buGG6pQKrkV/tyyRw8e2HXD2Gx/XM5BzcTVMfqhts3OaqGBzslQjiWV+NOck4tD18n
         A7aJSN15EhJE8mEwGDRmDBk/NgVw+erBPgAMXN+J9CNII0xkuWD9qM3oreuk6ro3zLgQ
         WwwttAGA15oXzkQnc5ep7RTrNx3ytDujwer033FjqMBy5jLy8dLTZyXmO84Lafw3YFSy
         67vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7v0ZD4FYjg+FLfVFwXErFZLQw9JsPi1WdJqMJoDQ0Kw=;
        b=FwJ9/OLZfiw/6l7hOLt6/j/E4rPCb2S+fUAYJbZCoyOg0AOXizVtZYIZYAv661n/pu
         vlay98WCvPYgReaoNOsPUvlszn8RDe6JuP/CqJ8bi7eW4UyUmELBxZRTnpxD0Bzjc/Co
         CbtgiNQSki+IfFk4IXYw/hpgLDFUp9O50qu/i2gQm5F2wV054o5NlBv65vv/Ranfpicu
         WFCjipE7Td5a3v8RzwrcvzN0a6f4Gl4W3t9M/iewXMf00AA4iAn5BjsD3GsZFIiwzZJZ
         4RXF2j4ekTkarY4Q86S4o7SQ2mRRYM8N6BoSQjRl3lk6GknwUoLjYJ+p/Yi3WVra33PL
         QnQg==
X-Gm-Message-State: APjAAAXKR1xrSi1DlDrNisafC4AHlVIhlQbUYw1wsCBx+k7kndf6Ntad
        QVGpzbVFWLsQ+HY/kaDkAQk=
X-Google-Smtp-Source: APXvYqzJYTLIIenoOenCuRR+DQnHHmHD6but+0dBLC+f7ZT2ifGPMWCBbfe4gry2mBwdZvuOsdfexQ==
X-Received: by 2002:a62:e806:: with SMTP id c6mr20676847pfi.158.1565344210665;
        Fri, 09 Aug 2019 02:50:10 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id b16sm159653631pfo.54.2019.08.09.02.50.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 02:50:10 -0700 (PDT)
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
Subject: [PATCH 1/3] x86/Hyper-V: Fix definition of struct hv_vp_assist_page
Date:   Fri,  9 Aug 2019 17:49:37 +0800
Message-Id: <20190809094939.76093-2-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
References: <20190809094939.76093-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The struct hv_vp_assist_page was defined incorrectly.
The "vtl_control" should be u64[3], "nested_enlightenments_control"
should be a u64 and there is 7 reserved bytes following "enlighten_vmentry".
This patch is to fix it.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index af78cd72b8f3..a79703c56ebe 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -517,11 +517,11 @@ struct hv_timer_message_payload {
 /* Define virtual processor assist page structure. */
 struct hv_vp_assist_page {
 	__u32 apic_assist;
-	__u32 reserved;
-	__u64 vtl_control[2];
+	__u32 reserved1;
+	__u64 vtl_control[3];
 	__u64 nested_enlightenments_control[2];
-	__u32 enlighten_vmentry;
-	__u32 padding;
+	__u8 enlighten_vmentry;
+	__u8 reserved2[7];
 	__u64 current_nested_vmcs;
 } __packed;
 
-- 
2.14.2

