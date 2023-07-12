Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F018C7509B8
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 15:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjGLNjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 09:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjGLNjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 09:39:31 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F05C19B4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 06:39:28 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1JkN5lN5zBR7bH
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 21:39:24 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689169164; x=1691761165; bh=/UeUJ1f7hroFyIuieneXVutLeIx
        IgeB0rY2bsGxmm5E=; b=IYaEUMUe1ZFauc6hj1TuFr9o2tMxm0uf6N0RUuw3r14
        hg2E10eXAEMmw/7DrJKoOkN8iZLlIyNZZexZxV3TEgSo+TxK3YHGJ5gmt4Zee4Gf
        L4cForHjiIdv4wJ9MtODBe25P8Cf1RcHVFWda4UPLcZhXqK0Sdc4u8d2oTbcBDg/
        MT0NyhwR+tcEipfApmJcMjZMa4g1RlrEId3iTojMI2iJ4FKzG4h4ZcR0LbBDgHuQ
        QMAwflO/hUmcGkfYnd0yAAGV1a/kL7K4m8exFn7tWdHnKy0dnPcQSv5Y6RCVEUTR
        PX7IJjsULm2I1/zqROVnVZCUIS9++XCgZ8tQ46Ujmhw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M_rSBpn42c4M for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 21:39:24 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1JkN2dtFzBR7b8;
        Wed, 12 Jul 2023 21:39:24 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 21:39:24 +0800
From:   huzhi001@208suo.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SVM: Fix warnings in svm.h
In-Reply-To: <tencent_B97FAD99B25D9BCC5AB9EA89BA04061D7B07@qq.com>
References: <tencent_B97FAD99B25D9BCC5AB9EA89BA04061D7B07@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <e541a2b2fe55ade4277f34fa64953683@208suo.com>
X-Sender: huzhi001@208suo.com
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

The following checkpatch warnings are removed:
WARNING: Prefer __packed over __attribute__((__packed__))

Signed-off-by: ZhiHu <huzhi001@208suo.com>
---
  arch/x86/include/asm/svm.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7..7ecebccf8a83 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -119,7 +119,7 @@ enum {
  };

-struct __attribute__ ((__packed__)) vmcb_control_area {
+struct __packed vmcb_control_area {
      u32 intercepts[MAX_INTERCEPT];
      u32 reserved_1[15 - MAX_INTERCEPT];
      u16 pause_filter_thresh;
