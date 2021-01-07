Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54B12EE87F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbhAGWZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbhAGWZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:32 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42DC0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:51 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g25so5686264wmh.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcR5NfJ4bwd3GfZx+pYyGxxdnoF1o7zacb4JP8su4Rw=;
        b=SKxTZgOcgVzHj3DKPn6v+2IU+QoulCHt2RAJKbmiMqIZnukJVsAKErS3PvVBt9Q9yh
         2lGahRiDR+l/rqT3vU5Rlr7uE4D/PPsmqVuQS0ZEYVoGHODToRH8+a11bOyrVS2XLiaK
         buPBkjlqfnXvGbScV48QroYRf3Fu9qGfr+EBb5PYaoPoiSp08efBI13MZkHsVb2q4y2S
         hJLMKEQRFq9g0Jhwvyhr9Q9wUvhODDTN3rHToc+YlMJJ6WnNoOpbykFRipjrcIWnDr0K
         GVXK5Wgqq5NlSCAwwEy4jYNdPZjBfkWzipWwDxzzjJV8KNXJkVsj4zYgYn8pkBJ3CDDo
         oexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dcR5NfJ4bwd3GfZx+pYyGxxdnoF1o7zacb4JP8su4Rw=;
        b=mTy8nBWCTZPphUoPo3zg+Xpm/+TAPVgW0vmoQ52zsSWAsuXeCvtUWVGjXNhW1+kTql
         88hXj3Lphy9aYsOaEgN2NgCoV4Jj0naAZPApKjOIjgtaOhasGkUbzXP6PEQkeI8cBwsn
         uarVW39swlOwTOYNL8gdPiav1qyQWo4u5plGOyfgCkA3q9X6Qb1mZAOJOls6bMR0WsSA
         0G0UPIj/0w/J8fKNR01nXhZxNF+UCsiW32LvfQfKgC0Vb2VyITWknm5jJ+YfI/ic2Hah
         WC5x9ttLu+Dxhga10A9ZhJU5C76APdXLlKDZGbCd5JITOtQE+7bTVa6UOuV35NLssCje
         4a4w==
X-Gm-Message-State: AOAM530O6b1LNPGVfoaJ0qDcMfIzgIP41VxkEhTcDu8PSiQSIpb6/yQO
        egtlwPIUylk1TL7yJ+EwzNI=
X-Google-Smtp-Source: ABdhPJxYDqODrrjf7pdQ0Z0PcI2BySmJ6bIXEkP3iZ8g95kryCbIw8SkmdqWfWVT/ysqEfYlDJrIFA==
X-Received: by 2002:a1c:4954:: with SMTP id w81mr527168wma.60.1610058290666;
        Thu, 07 Jan 2021 14:24:50 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id v65sm5262739wme.23.2021.01.07.14.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:49 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 22/66] target/mips: Remove consecutive CONFIG_USER_ONLY ifdefs
Date:   Thu,  7 Jan 2021 23:22:09 +0100
Message-Id: <20210107222253.20382-23-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-5-f4bug@amsat.org>
---
 target/mips/helper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/helper.c b/target/mips/helper.c
index 92bd3fb8550..cfb6d82fd33 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -552,9 +552,7 @@ hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
     }
     return phys_addr;
 }
-#endif /* !CONFIG_USER_ONLY */
 
-#if !defined(CONFIG_USER_ONLY)
 #if !defined(TARGET_MIPS64)
 
 /*
-- 
2.26.2

