Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1897F9C01
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKLVVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:21:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43703 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLVVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so20125355wra.10;
        Tue, 12 Nov 2019 13:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=NSDF2mQeYak+83dw/wmPKuy5slDrlG6su9Tyo7wtlR8=;
        b=XhpS9BhOVWB0COzdL0N3YwAHGyj1EUwQyhz44Dak67GDoQ7QY9BdznY2jUNusx9q5P
         RlMzcO8s8cEVC2IOTCFYT70T5DmGkJ/REgeL8rXcQBAo9n6KhwPDzWf9SYLDW85xTQFu
         RJg1KyQww26pFHWW28U30d96pu3MOPyPMS9cuAZr+zjhtfjKOLPhV8PpVJSjf1jkuiEu
         m0vMEZevuUnje712M1bDca84KB8zl5f1/axuLuhcPl5USZx0Z3T3BFQIDkyQFWWeys4v
         IAk0Z5neD8Y1BEUdB71oDnSAMI/e5b89HaH9W8FC/Uv9gX1IGmJ8NFNHDLRZ6tn3Enlm
         GeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=NSDF2mQeYak+83dw/wmPKuy5slDrlG6su9Tyo7wtlR8=;
        b=dAWFCJhmYAQYMGFAS/uIGoXTG7aKP6Ped3o4nAdOFX8wmfPCMOC+I7tkmUA17UiEHG
         0qO+ugaWfFSHiISuFMU491TdK7h3Vc4UXZ+sH3Wq5jKnYgk8G8t3NfHZllU0Hw4pclvQ
         Ko4GVcKIWsDviqXeFvDDgBGXyxgQYHDXs/YAzOdxDKKXxjVynIBhzIUKmW47QVnlo2B9
         cELTJ37bUmo0J3ZbndS9GPKb2NNivnlEfHzaxmv4ZXN/iHbe0aK3UNszBdQDHznPB0NN
         q0e/mZbuI8+mgcAaoNy0tyX/OBiyNVs7vrrbr3T94Q0FPw7oAEmlpq7vryxeyTRp6WPH
         l24g==
X-Gm-Message-State: APjAAAUbS2Wlr2PC0MqSgUFxw8e7nhxU+BOUzuAobIQHfmneUowhM5oM
        DY+KPhTS5zBhb8KvX8Nr26MHxnbq
X-Google-Smtp-Source: APXvYqwS0JaeVjNzcn3ESMD2RJdpgA2kVHEt65kMbnoNXokMjh/lPm31ydMaCyV6mPRFWH6uolvhBw==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr1112334wra.246.1573593700701;
        Tue, 12 Nov 2019 13:21:40 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:40 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/7] x86/cpu: Add Tremont to the cpu vulnerability whitelist
Date:   Tue, 12 Nov 2019 22:21:32 +0100
Message-Id: <1573593697-25061-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Add the new cpu family ATOM_TREMONT_D to the cpu vunerability
whitelist. ATOM_TREMONT_D is not affected by X86_BUG_ITLB_MULTIHIT.

ATOM_TREMONT_D might have mitigations against other issues as well, but
only the ITLB multihit mitigation is confirmed at this point.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d29b71ca3ca7..fffe21945374 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1074,6 +1074,8 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 	 * good enough for our purposes.
 	 */
 
+	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT),
+
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-- 
1.8.3.1


