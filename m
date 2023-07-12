Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228927500E3
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjGLIN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbjGLIN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:13:28 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BA135
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 01:13:24 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R19V94znlzBR5lR
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:13:21 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689149601; x=1691741602; bh=cNcfxK9dXcCkj+rw5iyDLfxZk4R
        VhrDL/EdmfTA64mE=; b=jnE8enGd5oC1LCdWYWLJ5kmhi7kidfbQhuxShgADZBD
        E3F3Rif6SgfFhz5F/TO5h5RpP0JL3u8fFb7oIt0AkMxNM1V0EVaIU1h8Jc7Uz4hf
        f3gIT6FnYolr/ofjMPzc62rwTMhPhj/K1Enm6pt1SW2aXqc+Zi6m06Ss1yvYgDaq
        lZ495wAtRGlGq4ZIhr3WXXUEpIdVEez05yAlkKb8rLq8HXScj8mfXdlF+DbsoCKE
        J1zMgj6JfspO31S5q/Genl9O34ODMl8cJNRkPtAXovh52r1BC1r6zIjAvqlI1/Vr
        OsRIcwF0/j3cAcgCp91nudm2GOOp45LZnnTBWTPG9jg==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l0ZAzdujYALp for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 16:13:21 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R19V91xZXzBR5CY;
        Wed, 12 Jul 2023 16:13:21 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 16:13:21 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix warnings in reverse_cpuid.h
In-Reply-To: <tencent_DBF42EC58C9AC22E9F96E4F5FCB76FEBB009@qq.com>
References: <tencent_DBF42EC58C9AC22E9F96E4F5FCB76FEBB009@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <f1dc314d0ec59e41cee17d5a36452c73@208suo.com>
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
WARNING: Use #include <linux/cpufeature.h> instead of <asm/cpufeature.h>

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/reverse_cpuid.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 56cbdb24400a..07a0fff2b27e 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -3,7 +3,7 @@
  #define ARCH_X86_KVM_REVERSE_CPUID_H

  #include <uapi/asm/kvm.h>
-#include <asm/cpufeature.h>
+#include <linux/cpufeature.h>
  #include <asm/cpufeatures.h>

  /*
