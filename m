Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD96172F15
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 04:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgB1DDT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Feb 2020 22:03:19 -0500
Received: from outbound.smtp.vt.edu ([198.82.183.121]:59664 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730569AbgB1DDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 22:03:18 -0500
X-Greylist: delayed 798 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 22:03:18 EST
Received: from mr5.cc.vt.edu (mail.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id 01S2o00C019644
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 21:50:00 -0500
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
        by mr5.cc.vt.edu (8.14.7/8.14.7) with ESMTP id 01S2ntAd012834
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 21:50:00 -0500
Received: by mail-qv1-f72.google.com with SMTP id cn2so1444552qvb.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 18:50:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version
         :content-id:content-transfer-encoding:date:message-id;
        bh=TMxAIoujXzqS3798HgNWfd0wXc3IAjXqWU595ApRFSw=;
        b=oxOnJz/hnvKBj0svZUOy8bOCo+sP8YFpYZMa4+TnKrNvd8EyA+QUT24gNrMD147q7l
         XClrwXtHitljc6wq1jTLcD7ekXrQevcpu/K1k+Pn6cDW9Vz9t1Qho3HKu9hIhDpbn+db
         IqfrIO9GfMcjF/opFQB1H9nqtFgr0PHwKYi4fbRfkV0ZEkQGUJFJOS5shfb54Ph9bLT3
         RmFKl60QIiuBSl5DSmnfcezeHeMgzyibgSC87pHLpbQYj2cqg0KjFjB/CEI0p2oM0xbM
         xHknkzB7nWH3a1kxpJonlMJ4L8XpVuaF6dZh7AcYCpxP9vanjLLw9TDHXFlUtKuP4kjl
         y2hQ==
X-Gm-Message-State: APjAAAWOd8m21ualukE1YQLBv5F3XrYARGx71rVwRkljOO5qGdQo0BZ1
        GesJJsnGIEU3MWpAtqgXM1rPFLLD7sgs3kApbAYXLtFZIl9PLzobtY+BneI0FYisJ8pHP08HUkC
        QNQTvptkYpB77A2V3juFHpVU=
X-Received: by 2002:a37:6111:: with SMTP id v17mr2544755qkb.210.1582858195018;
        Thu, 27 Feb 2020 18:49:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqpvtFlPmXpm9FoxRteLLKVlXXhcaTG1YqTU72QLXMBBhjrUVYf45oDs0UAE5r0eZa9rO8Kg==
X-Received: by 2002:a37:6111:: with SMTP id v17mr2544735qkb.210.1582858194753;
        Thu, 27 Feb 2020 18:49:54 -0800 (PST)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id t4sm4300738qkm.82.2020.02.27.18.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 18:49:53 -0800 (PST)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: allow compiling with W=1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <263440.1582858192.1@turing-police>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 27 Feb 2020 21:49:52 -0500
Message-ID: <263441.1582858192@turing-police>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compile error with CONFIG_KVM_INTEL=y and W=1:

  CC      arch/x86/kvm/vmx/vmx.o
arch/x86/kvm/vmx/vmx.c:68:32: error: 'vmx_cpu_id' defined but not used [-Werror=unused-const-variable=]
   68 | static const struct x86_cpu_id vmx_cpu_id[] = {
      |                                ^~~~~~~~~~
cc1: all warnings being treated as errors

When building with =y, the MODULE_DEVICE_TABLE macro doesn't generate a
reference to the structure (or any code at all).  This makes W=1 compiles
unhappy.

Wrap both in a #ifdef to avoid the issue.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40a1467d1655..5c2fc2177b0d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -65,11 +65,13 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+#ifdef MODULE
 static const struct x86_cpu_id vmx_cpu_id[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_VMX),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, vmx_cpu_id);
+#endif
 
 bool __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);

