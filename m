Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714401D6E9F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 03:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgERBbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgERBbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 21:31:50 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE165C061A0C;
        Sun, 17 May 2020 18:31:50 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z15so5911575pjb.0;
        Sun, 17 May 2020 18:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XbbeOrIKm/c92sezKdJ+YKW0B19HCAv4ShgmKI4t9O0=;
        b=C1uMgafZPLI1CmiPPlSGD+j1w/O21KhGp/nVMAUmZZahlntQ5AImgRwjcMimEWKMZd
         u0EX2GnlBDgoRTg2L94uXyc3ec9ZUSvy/BUeUdOuINT7VY4X33OkOMLv6we0KszbVwg9
         PBB+o/r2xNf7uWDkIKU+qz6yFUDScF2RXb+J4sYVvf0In5utQbm9hCyBvdMVGlyu6rUL
         z1TY7JqZ47uWoq/edbQNoG/Zj2N5vi4nOEEI27V9ZtV2Y2223zCl0kEQXVoGl8dfT38S
         z2GJ93Ct6slq2RHWDIlxEOohkDR+OHzgP87JCT2MTrwixW1s/GDK87tGt58c6VbWLcLM
         AZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XbbeOrIKm/c92sezKdJ+YKW0B19HCAv4ShgmKI4t9O0=;
        b=sFveExF/rm3ntVxYD9//pVlAorxShfGnnFT4seA2EtCVC2vmpUf7WdYydyTR+h4DBe
         tDl4NqjGDVjpUCg802KdXIoF/7jv2tnJHOiiPNqOLDmoh2++tW57XqGQXXAvKeZfWz0k
         fn8QMEoC5t24YbBSIxNRshTsc9mVr7BUdHG8/5FTgrKgTIKFBwHuwNLFDX5YtrcufmDG
         IKVaf7XSMtzTDzann/f07Gmhcrn/GMsVSsVjPZrH/l2leOAG98M/pgYT/rKJpJndAMm5
         7iWovl05yPX4a5ydMrin+jPUdf04SHdBg6/0fgLM2gZLU9mcOf4vsp2h1IZQtR2FS+S/
         LZ6g==
X-Gm-Message-State: AOAM5307WYauFfn1bvyXknB2wcqtItb0+/brmc3WPW5cnIpTUbScrBAh
        CcgMTWhL/h8Ma9vDQVGVuQ==
X-Google-Smtp-Source: ABdhPJylnx5A4YEXQxyR3b8JnxFKlIooqc0aPcvyT8oydsJLmZID07Pk9PloLJVNByonA1GpFLRvfA==
X-Received: by 2002:a17:902:32b:: with SMTP id 40mr13783259pld.73.1589765510189;
        Sun, 17 May 2020 18:31:50 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id h9sm7121572pfo.129.2020.05.17.18.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 18:31:49 -0700 (PDT)
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>, wanpengli@tencent.com,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, hpa@zytor.com
Cc:     "x86@kernel.org" <x86@kernel.org>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: Fix the indentation to match coding style
Message-ID: <2f78457e-f3a7-3bc9-e237-3132ee87f71e@gmail.com>
Date:   Mon, 18 May 2020 09:31:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

There is a bad indentation in next&queue branch. The patch looks like 
fixes nothing though it fixes the indentation.

Before fixing:

                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
                         kvm_skip_emulated_instruction(vcpu);
                         ret = EXIT_FASTPATH_EXIT_HANDLED;
                }
                 break;
         case MSR_IA32_TSCDEADLINE:

After fixing:

                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
                         kvm_skip_emulated_instruction(vcpu);
                         ret = EXIT_FASTPATH_EXIT_HANDLED;
                 }
                 break;
         case MSR_IA32_TSCDEADLINE:


Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kvm/x86.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 471fccf..446f747 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1631,7 +1631,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct 
kvm_vcpu *vcpu)
                 if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
                         kvm_skip_emulated_instruction(vcpu);
                         ret = EXIT_FASTPATH_EXIT_HANDLED;
-               }
+               }
                 break;
         case MSR_IA32_TSCDEADLINE:
                 data = kvm_read_edx_eax(vcpu);
--
1.8.3.1
