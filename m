Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FF76A0BD0
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 15:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbjBWOWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 09:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbjBWOWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 09:22:42 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6A798;
        Thu, 23 Feb 2023 06:22:36 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id cb13so6007920pfb.5;
        Thu, 23 Feb 2023 06:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Df2kcb9Fa+/xlXDRcFOVdiKkKZQ4UA4GN+Niz/IaFGY=;
        b=dDDb2iwNNGaMTeIc1qMo7svx2r4R+utlG6gTR7e0Xw32OkSbgxC24UQZUKiPfk8WjC
         53cc0NzaSzJPunKpBS3l2mljrXPWSniAMhbJJO537xm+0msdx/seYZ+NhILDMZIFzpUg
         ZflWJDLUUrrIeu7iZTlYo86fpUa+MSEGFI4hhrA2owqdaSeLDFf4mndjK+zRXXy70KHA
         N2mU7a0gTFc4NeJqcu9igBf2S1Ap93I5MmoPqGBaJIYAcy5ALGXyfjq3+LYzfBCukCiS
         RX7kM1gPMT+TaLWRZZABBGRJk2VxO26U1AowLs7iBQc0VbjnMFAymrUJleHyA0kYPNED
         ccfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Df2kcb9Fa+/xlXDRcFOVdiKkKZQ4UA4GN+Niz/IaFGY=;
        b=gMSERteqhY2G5O0OH1neluDqUFyJdGARyjDeHrgZt9sIwGkbDCyHH5mRylk6HROQ4U
         7TegSktZfwhfXwjFVavCMJZJ0Sg/FNwU+toG6KNok3kmW+NlYBUt87Qruvvs3XH0xKqC
         5ziT5kn6pHAIef1v59GexOZZo6KHDsokg65WSRLgALnQE3jdSRxefMGhYfW/n+1W/Lda
         sVfwu+FS0zj3BT/Hw+n1FPNAx8e8D4fZwHfkI1olJgCNSNxyw6gEsAeNvGvzZ09T8cQd
         f7x0yokmP5/sDfQBQeZJ8dpamD7j+Zxmr4zpjmSnaESDueKpjbZLJcwEgegqphxFCEUj
         HcFg==
X-Gm-Message-State: AO0yUKVMPwtlge8p6AxyDvI+C543GTn2FOSqivdw6NnZXJVcz0phySdP
        cUcutrA/cHSzWebHr1FzNYLg1rOfzQE=
X-Google-Smtp-Source: AK7set/zoYmzVaHcTkg857OZuezh2/+lfyOqvAaSI1g0rzTElQyXGlqmfLgBFKbImpD58rxqjF/GMQ==
X-Received: by 2002:a62:1dd0:0:b0:5aa:6125:dbf4 with SMTP id d199-20020a621dd0000000b005aa6125dbf4mr9746988pfd.11.1677162156222;
        Thu, 23 Feb 2023 06:22:36 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id h23-20020aa786d7000000b005cc52ea452csm5346193pfo.100.2023.02.23.06.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 06:22:35 -0800 (PST)
From:   Quanfa Fu <quanfafu@gmail.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quanfa Fu <quanfafu@gmail.com>
Subject: [PATCH] KVM/x86: fix comment that should be user fault
Date:   Thu, 23 Feb 2023 22:21:30 +0800
Message-Id: <20230223142130.2338972-1-quanfafu@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The content of comment should be user fault not read. In order to avoid
confusion, fix the comment.

Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7eec0226d56a..3c1012039517 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5668,7 +5668,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
 
-	/* Is it a read fault? */
+	/* Is it a user fault? */
 	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
 		     ? PFERR_USER_MASK : 0;
 	/* Is it a write fault? */
-- 
2.31.1

