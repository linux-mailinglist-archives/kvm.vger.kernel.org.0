Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92CE2CC5C2
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbgLBSpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387681AbgLBSpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:31 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A805C061A04
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:35 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id q16so5062551edv.10
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b+Fxow+oEWbA9tjXcJhsn1mux7Y5BxnpxnFopCv/eKM=;
        b=cSkNktiztvfwPcj9TDhtlpU0QAlBiEme6zG8hSJcre7bL/ueRjM25Ez9ZSMsY/dFRv
         2eD864BfOuCJXrIj8nWLQUsg1zQKecHrC5QwDVcrSPmkDFOqN3YLVJnmlIk0U7xSc6aM
         aRNISKDggqfYo8TUHXgY4EvUeUw3hFs1H2D9OdMsWI9I7e7x29y72rBUR7uKysbY1JUr
         S37URkEsXMr48P1xKmcrAlDlL55Ap0jN+6ZlPl+N7vDWZq8nZXo1lSVWntkRePN9180X
         E9is08RpfODNm40dc1a1EMQ3z8hRzd0JlgWhO6sV0WMQONg4tlQCEq4hqJMlR8Dn359B
         Iq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=b+Fxow+oEWbA9tjXcJhsn1mux7Y5BxnpxnFopCv/eKM=;
        b=BejqM98tVrKj6rbIew6OWH8KNJvYcrfKn74B/YuEDGnx9kqmkuOsvZiRXiJbiLYufI
         +SerXGcc4QjcrbIxU+RRuauMlhP0ROrAvBFcgneRYSrWsdceYHtd2yWP9do3MxIPBhr3
         EPC48cXZ84BrGmkKN2Agy1kJZ6X8yltTnV9mGUYSgVshpVi00ppCiEnh0g5kY++UtIQH
         64oJaIhH0KLIhZ8qN9S/HzlkO0084xfhl5I4ISsghB9JsWlgzjK2pCcli2DRjNOkn8bs
         CervdxJoSehjZHHnZIFPoTp718ET/J+3P1TBtqJQ2/8/N2+7RrJdiWCFh50RUdjxTQGx
         ZFfw==
X-Gm-Message-State: AOAM530Gsd2jJjU0A2ov3EFK+AslR7Jz9PW2UOP2BLh6FE8G+N0lbXZw
        taM91JBIS04leCuponkJLJM=
X-Google-Smtp-Source: ABdhPJzyBCo/fleK9MKte6zyYGXYyVa/HiaUOmGcqj9QDuopKYgN6NjtRhKkEgMnlAYPgNx6fS7OEA==
X-Received: by 2002:aa7:dccd:: with SMTP id w13mr1277839edu.385.1606934674152;
        Wed, 02 Dec 2020 10:44:34 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id e20sm538625edu.25.2020.12.02.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:33 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 3/9] target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
Date:   Wed,  2 Dec 2020 19:44:09 +0100
Message-Id: <20201202184415.1434484-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSA presence is expressed by the MSAP bit of CP0_Config3.
We don't need to check anything else.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index f882ac1580c..95cbd314018 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -433,7 +433,7 @@ static inline void compute_hflags(CPUMIPSState *env)
             env->hflags |= MIPS_HFLAG_COP1X;
         }
     }
-    if (env->insn_flags & ASE_MSA) {
+    if (ase_msa_available(env)) {
         if (env->CP0_Config5 & (1 << CP0C5_MSAEn)) {
             env->hflags |= MIPS_HFLAG_MSA;
         }
-- 
2.26.2

