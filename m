Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5AF8CCF2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfHNHfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:35:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33307 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfHNHfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:35:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so53082350pfq.0;
        Wed, 14 Aug 2019 00:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XzmPhJrk3sYccy1T+84Jue9XGrfBlOC3sGHKCIWYcCg=;
        b=sQbs7r1b2D+Kq8SFmmp6Tq4Y/1VTSjplkiPwRdIRIIPI36MeSHuWmRxgnuZVj3kFP7
         tALzRClwk3QBrhIGnXrVTXgFIqYh3p/SxuGPVG38P5e+ynCK6/1IfM1Oa43hpFPHvamY
         yLVKorcchtEyJL5QxyVPgPikmaN1GlqUvMyNx71HCIdEFDs9Y475LPwcV5pnYbiZ3aIe
         NPrnvTnaiZQQUQ/O5te6dAgNZqbR9YsvApD7zj0XxdIE0noLzWyFTNVLA6idyf/fl42r
         nEsG53x0qXSPwluLTjEb1Cot5gHmWGWne6TQC6ixt2d8wXq4/1/VA9E717tvag+6Sxgp
         hOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XzmPhJrk3sYccy1T+84Jue9XGrfBlOC3sGHKCIWYcCg=;
        b=aPvcRTRr/KNHrshGiSXXmRJbuq7RxfaTPQGkmZnMnu/f+wVOAxNo/Qm9vpQD09z3R0
         y9SIOOhD63PkctsTdpSRDnB/Qe+ZHwhzYSC4mZbYNym4I2B6YP7xnUVIeDK/PdSnI2Dp
         631uYPvFKRe0MPvKCr35RC3t3WogF484duH19jFGKvP4g1/Jpen8JPdgrMty5ygGIb0f
         c9DWVERLFSyjWsr/Xj7fRXNwvwuOvJqVNlMw8VsnVdhj5PQNF/HCe6+ft6UfWCL8FaS5
         JXlcMlUQO+4SJDueA9iXS4woS9b+LhHbNg/uAVUmeZbuRAO5ZJDJGafvAJWYg6CkS4TR
         a0Vw==
X-Gm-Message-State: APjAAAWOPXOjV2yLpqegH3i9Mt+YvDszjOT0GFfFbH/a0xQbT85TUqjs
        qYKJe6lry0DsfjiIbTmtaCuhQsMiAho=
X-Google-Smtp-Source: APXvYqwrs6kJ8CBd0U4BvfEuwVzIZrSas0Zn8ar7FOWmS9h87vrbWuRMKBS7vwvVIcXdEf9hxJtrpA==
X-Received: by 2002:a63:221f:: with SMTP id i31mr38531448pgi.251.1565768102666;
        Wed, 14 Aug 2019 00:35:02 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id v184sm109639230pfb.82.2019.08.14.00.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 00:35:02 -0700 (PDT)
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
Subject: [PATCH V2 1/3] x86/Hyper-V: Fix definition of struct hv_vp_assist_page
Date:   Wed, 14 Aug 2019 15:34:45 +0800
Message-Id: <20190814073447.96141-2-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
References: <20190814073447.96141-1-Tianyu.Lan@microsoft.com>
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

