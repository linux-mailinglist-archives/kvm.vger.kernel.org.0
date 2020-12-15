Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041812DB6BC
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgLOW7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgLOW7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:23 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DDCC0617A7
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:36 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so30079006ejb.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74tnrNw+u4pr5iFSEHUsfynOPkwscuzwVbsLeoiPrug=;
        b=RtfvwoVk7Mzw/dylvxtjrTqWQj3l6D3IVMuqLvrBYihy6Ky+DdEmPh7kYq9vx/u4+9
         zrpqzx+QC1+jQmK1h6xKi+rxA0kdSPUsmFkcrJjEHsRFgXBy74LRRWKgbd2BlFilLz9b
         h/KiTiZDcnf+SM/rJ86ct5rK1PkmaltZeKTzz5+HkBObcgtDtMioCzbjhm/f0pKqlD3f
         JipOCfLPSPCxZ2FkbiQ8isFK1BvJY8Idyl1LHTHppeFLyVUjSjXN3fueMgPcVLssER6o
         MfdBM69UQgqGzA6zRw8eWV9+QPSP0EteFg6aki6wdZiEh7NjKFCLiGppVEs99VHCFxoG
         y+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=74tnrNw+u4pr5iFSEHUsfynOPkwscuzwVbsLeoiPrug=;
        b=GreAYjh4856yRoIgTdLWlUsVwzF8PqCTwEtE9Apg6lfX5Jd+1NUmJkjlzlP+w/yBDy
         v+oo5cJ2JvcKoYBTApgN4fKkX41sH8dNHCcavsKG6wMX7fCZnyhjHQWo/XJr8fVFkkXz
         KLXSFmAsoGU8TB3pXynNVrMb2B7JllIgVdcafl4q45z+0V9uwQOnG5HpBWYYRPK6QMkS
         QS4ZrQsCcrZJQtSUXB9G9bjvkbwX47xz6DcfUsr/v3Ajx4HKOvjT1UZ2lSuaquCWfohW
         yQe6McqBpDBvKd6Oah2VuWU2hzc9FL6HqaAZ2+xbc/ho39fzydOdnBHq8yMZ1CljVqQh
         vsXg==
X-Gm-Message-State: AOAM533WSpAS8RPveviDOVsshTbkXjjiMth0JW/W18iUO7/uHmV1ovth
        6h8wIovCLplOBeb4+TRvYhA=
X-Google-Smtp-Source: ABdhPJyHJfU6cpbNmDQETSsJGW3gJhXZe5NIxiaFlY9+UOp46AEFZAvVF2OyKmVq3Soh+D7y3deHsg==
X-Received: by 2002:a17:906:814a:: with SMTP id z10mr27884807ejw.96.1608073114782;
        Tue, 15 Dec 2020 14:58:34 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id p24sm16660815edr.65.2020.12.15.14.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:34 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 06/24] target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
Date:   Tue, 15 Dec 2020 23:57:39 +0100
Message-Id: <20201215225757.764263-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSA presence is expressed by the MSAP bit of CP0_Config3.
We don't need to check anything else.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 968a3a8db8f..1ab2454e61d 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -378,7 +378,7 @@ static inline void compute_hflags(CPUMIPSState *env)
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

