Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22CDF3CD
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfJURHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 13:07:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38697 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJURHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 13:07:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id v9so3610352wrq.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 10:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oz5guTpCU+BI0skIIQHdlX4fd7KpDc/8V5k4nfR1aRA=;
        b=OAFoDQlSjTcKTNgeHLPnodG/40JaarX+hMqGz9GhIMo/JhcV4OpE/TMr8k+xK/IGUV
         azcwmCzpqUEqTAmXVi8BY+5pZ0s2Wv4zMtFwqtfr/oPB6jDzVbZ5r4P+gg03jBG//n3r
         15gG3/wAkSBRdR1Ny8eNDdSD4d4GrpR4f5i1YJ5HPiZsMAxB6xFF6mhUNILF2ZdDQZoc
         R0VUAEUq9LUeKepz5xvy4RR7JVk1FVOAg1KJblgN4ERufw1o2SYDzZBPZpB7TwElbeiW
         p8Eq54nZ1FG/nxAsZbhddyDYNP6X54qBiRUC95SsEJX7HH3Mqb54qs/0NqQKJVwPBqbR
         bDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=oz5guTpCU+BI0skIIQHdlX4fd7KpDc/8V5k4nfR1aRA=;
        b=iXgag/HAlE060lP8Dgz8NG1EThTbAD4h1SZfJdsGmaSwgkYOSRBEAjOggV9zrsz/6w
         TfBfLRTsEjbeFkTezUKlFKks7O6QEAwuLGOquBeJpBAvO7+OEHXLQ7f7/oYGSugEdag3
         JflJmBsL4PesNlzGlBhoaeFUpt+yvfVqnPYD3VZ+froCoWEj71ZBjtpErDmspDZYKUjd
         HHVoO3DICn4r9ARudzxIh+KmyhVVtFXuKyP5kOm5/8YoaeAQjQDvpMDnRVKyPNRYG6/E
         FHjjpFaHaK1xaoghnzrvz3R5+x7ZFANY41XocC6ZB2oJedzLRBc5Y7VfApPOn3y/1MEX
         DO2g==
X-Gm-Message-State: APjAAAUhsujfk44Z5pgzTVP2HO4KpTO15RUkIiK9mttxZhAA8RQYILV3
        ZB0X+lWkXu8s/gsUmGzp5et5PwhF
X-Google-Smtp-Source: APXvYqzDGGzdYOLWNVUyofNDNjidCspPssY7nDDwQSKnzAswWIKWBr08i0pasP9aLvPbosRH9LQveA==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr5416486wro.257.1571677655710;
        Mon, 21 Oct 2019 10:07:35 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id a5sm482619wrm.78.2019.10.21.10.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 10:07:34 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com
Subject: [PATCH kvm-unit-tests] x86: realmode: use ARRAY_SIZE in test_long_jmp
Date:   Mon, 21 Oct 2019 19:07:33 +0200
Message-Id: <20191021170733.16876-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the code a little bit more robust and self-explanatory.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/realmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index a1df515..5dbc2aa 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -606,7 +606,7 @@ static void test_long_jmp(void)
 	u32 esp[16];
 
 	inregs = (struct regs){ 0 };
-	inregs.esp = (u32)(esp+16);
+	inregs.esp = (u32)&esp[ARRAY_SIZE(esp)];
 	MK_INSN(long_jmp, "call 1f\n\t"
 			  "jmp 2f\n\t"
 			  "1: jmp $0, $test_function\n\t"
-- 
2.21.0

