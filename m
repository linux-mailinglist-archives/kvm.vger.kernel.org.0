Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2347974FFC9
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjGLG4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 02:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjGLG4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 02:56:52 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93141709
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 23:56:46 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R17nm69dNzBR5lW
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:56:44 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689145004; x=1691737005; bh=ME+14FPzHJvO2DOIGZOPDwe7CdJ
        /x6/pUpF5TJPDMTA=; b=U5oMjVByBxSQM1Vvx3RTPFbejSMoKyIl0kQ8iWEb7ba
        BJKRrHReR3HaFncTz3e1VETipauvSylsAiGlf03c/pOQeIeIqzxnNWcv1v7G3sds
        K/3CF1eTWIRv49jBOr4TOcaGKbKdqE9NWQtQ1i6FNKJmHm4wT8W0bf/pZW9TnXCC
        bPGXCeQRoQ0gZqXGsUJpVTfQ6jdf3mHwhZp3pQ99EVCyHUjZHOvpGMIdmulLAIDf
        t4RvvU/Bs6TGvcr29tg3iFTxNO3ZdWXG8FPJlf0lBsKxzZeIAGEYSrb2L43L9bgW
        KtUbSUzQ59C+qJl9lN+nJ9WA2EleM4V3EkEY2XfWp6A==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oXvn1QCSoRiQ for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 14:56:44 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R17nl2qYyzBR5lH;
        Wed, 12 Jul 2023 14:56:43 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 14:56:43 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.d, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix warnings in kvm_cache_regs.h
In-Reply-To: <tencent_68C96D2AD6D16593114698F6D388FC86BF06@qq.com>
References: <tencent_68C96D2AD6D16593114698F6D388FC86BF06@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <a82cd82f9aa495c45ce0ac3806f92547@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warnings are removed:
WARNING: Missing a blank line after declarations

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/kvm_cache_regs.h | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h 
b/arch/x86/kvm/kvm_cache_regs.h
index 75eae9c4998a..0e3808b40974 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -151,6 +151,7 @@ static inline void kvm_pdptr_write(struct kvm_vcpu 
*vcpu, int index, u64 value)
  static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong 
mask)
  {
      ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
+
      if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
          !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
          static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR0);
@@ -173,6 +174,7 @@ static inline ulong kvm_read_cr0(struct kvm_vcpu 
*vcpu)
  static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong 
mask)
  {
      ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
+
      if ((tmask & vcpu->arch.cr4_guest_owned_bits) &&
          !kvm_register_is_available(vcpu, VCPU_EXREG_CR4))
          static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR4);
