Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53179605F19
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiJTLj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiJTLjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:39:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB255050D;
        Thu, 20 Oct 2022 04:39:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so3169115pjq.3;
        Thu, 20 Oct 2022 04:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iXYBiVeIg3bXe+RYeJHWLJUuTYSz6XkSd7JNsHDAMGo=;
        b=chmc41O8+WmHf7G+cUG7F27mqVOj7PoODYmu6lGE56Ra5gBxrE8Ad6z0tdkrlmyu8o
         9ahJpklzOhQC7ZfN0PqvY1GtEJ5Rhem6AyExC7KDJAwyidvNR+LzPB0MOjf7zMb2ZVVF
         X3Df716cwnyJqlVRSknYrxnAD47LkCrXPw6h3goJnKSg7VnMg/MRXbaHXtdPUdRLyxsu
         AxPF52SX4s+wD4LHxcDroXl+AGrgvscEpZkSlKDZVOdYTwrN8R7cxpkIHcc3741g5jXN
         DUaGBGJbzEZ/C67XqcbR2BeN0M4Ju6SSmp3rjlIYMDPRe04u5YH1CxSRfWspijMKSon/
         tfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iXYBiVeIg3bXe+RYeJHWLJUuTYSz6XkSd7JNsHDAMGo=;
        b=nPBBLrI1yc3saFkWA0YhwXdzPMMxgvpoW6LyEy/job/6x4PEFOgqI89T97vd+wtci2
         v2gwgvVOVXPyDKWLVWc0b4lqi/lOa/pTUdHDYo1V3P5cJwte06kZw/jaG1QeXh4JXsA/
         8gNXpG+uOv231RZrxD+hfiG7DQAxMQgtzrkOjmS5rYUQTE7gV9+S3vmnY7qnttdR7gdz
         PsycVq50wkU9FWYfPuprGeCAIqj6J0B+7h22W6IP0hgZX6EZKCw/pvhYOLE465Z2u9zc
         2ptljX1cu047o2S589aCwkHwipEPiHf/WCfqB/0Eny3KLZ4JUaw+gPQKKwGtz0Yd+Iwd
         J1aQ==
X-Gm-Message-State: ACrzQf2px7Oq5I58rs4JcW2e0nSAllUxa5MgHF5avZztNYJJ9sBtHHWl
        p9wrDsKW/q8CmquZxfYz8LY=
X-Google-Smtp-Source: AMsMyM6I/p//Yq2IUqoQAbMzsWmjSpWgigpC0lROq+l83R5CRa/wdHccm7x151LjlsO19qGV/mMjAw==
X-Received: by 2002:a17:902:f791:b0:17c:c1dd:a3b5 with SMTP id q17-20020a170902f79100b0017cc1dda3b5mr13332042pln.141.1666265989512;
        Thu, 20 Oct 2022 04:39:49 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902680800b0018661acdff5sm1394981plk.142.2022.10.20.04.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 04:39:48 -0700 (PDT)
From:   yexingchen116@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: [PATCH linux-next] KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()
Date:   Thu, 20 Oct 2022 11:39:43 +0000
Message-Id: <20221020113943.400103-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Avoid type casts that are needed for IS_ERR() and use
IS_ERR_VALUE() instead.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..1c260f716c3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12414,7 +12414,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 		 */
 		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
 			      MAP_SHARED | MAP_ANONYMOUS, 0);
-		if (IS_ERR((void *)hva))
+		if (IS_ERR_VALUE(hva))
 			return (void __user *)hva;
 	} else {
 		if (!slot || !slot->npages)
-- 
2.25.1

