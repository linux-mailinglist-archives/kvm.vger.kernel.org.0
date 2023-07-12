Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DA774FDB0
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjGLD14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjGLD1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:27:55 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943F8E5C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 20:27:53 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R138k04XPzBR5D3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 11:27:49 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689132469; x=1691724470; bh=IhEkEJFU0er4sX2VoeEpte+McQK
        BkP6T/TegxX68EuI=; b=JMdK+LMWPlqYiswSju07mre69ybChq2wCe7apWadSH6
        hHgMpUKiYzBXQEjrkeKGCwcTzwTOJ+4ytx+EYzZHoWNjPucXc/TOmlmpZ5ZKHRGN
        ZdPVYJ+wwI/4ZRKIzrdQXrPArTyFjw5OkNCHYQBajcKzsiEDPMDpOzqtK1uZ8Ewv
        VvHgiX8pNqsjGQ3ffD+gi0IEfgKHxmOaXq38KNcfxb1eY7xsGezZGPw5W+V9Gu2y
        Pt2b7HXUQnFFa6J+YdInVr6jkQnUMhZKBihORquARXykFI6oz6ehx6+OTF5o5e0G
        a0xmH3JdrF3KWCJPl7qONlBKiW1/04i7/9ZETiblm8g==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id K8ESEwpmtxhp for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 11:27:49 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R138j2lKXzBR5kb;
        Wed, 12 Jul 2023 11:27:49 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 11:27:49 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86:Fix warning in cpuid.h
In-Reply-To: <tencent_338AFC84BFDBAD16D6D1E5B0D16558DE5306@qq.com>
References: <tencent_338AFC84BFDBAD16D6D1E5B0D16558DE5306@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <ae64e0c7c49b4189c6a7ee1f1fa2a863@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warning is removed:
WARNING: Use #include <linux/processor.h> instead of <asm/processor.h>

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/cpuid.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..65188baf00be 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -5,7 +5,7 @@
  #include "x86.h"
  #include "reverse_cpuid.h"
  #include <asm/cpu.h>
-#include <asm/processor.h>
+#include <linux/processor.h>
  #include <uapi/asm/kvm_para.h>

  extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
