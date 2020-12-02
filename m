Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18CE2CC5BF
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389671AbgLBSpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387949AbgLBSpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:05 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20381C0613D6
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:19 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so5987948ejm.0
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hSmpcykzQuwwBLpIogaztVYhDMmVTRhRVKKuYZtdDSM=;
        b=SVSB1KC+hLG73tSP2ktuBU9FVTjcMVJQSxO2zO2nSySCYqzVqvU5A2jPqKw0sUXS6p
         KmHD7HWpAbY4xRfkZeTV2oxmAE7biDy682X9pgCT+wbiSZTHO0RfdWQGAnpGKKHX09gd
         pA6l4PaJDuO6pjrHrS0QwXniR8QBSOaVowQWK5xwFL6o368ihmeGge4YORLBvdMn7e4p
         pncwytAK6D87mvxdxfqYhgp+Ixn27V2uMS3JZaBwUHZZIggqpqoSBpr6cJwf4Dc7YKuR
         OXOtnfF3GUquxVdbcJBZXsDsAsAKYSujFeoPr5ZsoGi/C3s1EslRFirRLfTDu95/+Eax
         3XQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hSmpcykzQuwwBLpIogaztVYhDMmVTRhRVKKuYZtdDSM=;
        b=ptNo1kO2wNggyT3ilYC4J3KNcH95YEtjaHu+2J5FR4tytXuIN/PCbcrJ8BJY4N39ZY
         aj6WAqRVXJRhL21CqoGXhIMiyDqnITyG/yt4Gpsvr6xOmQMXtb/FMECc2XN89uY/UgF1
         5PwB7A524+0kzVQh2joQ4e2XzvwfOncXCmK4pj2n8aHIBtSVHkBU3izYGD6n+tyOZpTz
         D4R3QdgNy775xvpLl2fmAhQSykPgX7rOXgJNyx9wqJ3cs8bZDJSFcP5xQlPw4xKexjXr
         e65aarowNJyZpMI2U3gah9s0/77TL+jYxNe7DpsZ7ao45z31HX5Sy6paDBusY2QaOpDy
         qHEg==
X-Gm-Message-State: AOAM533JfowBJvaC0yk3xRmmHS3aRZeYouRdxnmCNp/dBKWHfCys+oqB
        zP/iFTN7zBAz7ytdsvYX9Vw=
X-Google-Smtp-Source: ABdhPJyMzmZLWgyOOwxUd5Hd1ctpDEn79myeWV2W2IRWp5zvyADTWvznxSaLvFUQwKcUI+zGbLf60g==
X-Received: by 2002:a17:906:7aca:: with SMTP id k10mr1086857ejo.215.1606934657806;
        Wed, 02 Dec 2020 10:44:17 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id c25sm474794ejx.39.2020.12.02.10.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:17 -0800 (PST)
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
Subject: [PATCH 0/9] target/mips: Simplify MSA TCG logic
Date:   Wed,  2 Dec 2020 19:44:06 +0100
Message-Id: <20201202184415.1434484-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I converted MSA opcodes to decodetree. To keep the series=0D
small I split it in 2, this is the non-decodetree specific=0D
patches (so non-decodetree experts can review it ;) ).=0D
=0D
First we stop using env->insn_flags to check for MSAi=0D
presence, then we restrict TCG functions to DisasContext*.=0D
=0D
Based-on: <20201130102228.2395100-1-f4bug@amsat.org>=0D
"target/mips: Allow executing MSA instructions on Loongson-3A4000"=0D
=0D
Philippe Mathieu-Daud=C3=A9 (9):=0D
  target/mips: Introduce ase_msa_available() helper=0D
  target/mips: Simplify msa_reset()=0D
  target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA=0D
  target/mips: Simplify MSA TCG logic=0D
  target/mips: Remove now unused ASE_MSA definition=0D
  target/mips: Alias MSA vector registers on FPU scalar registers=0D
  target/mips: Extract msa_translate_init() from mips_tcg_init()=0D
  target/mips: Remove CPUMIPSState* argument from gen_msa*() methods=0D
  target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()=0D
=0D
 target/mips/internal.h           |   8 +-=0D
 target/mips/mips-defs.h          |   1 -=0D
 target/mips/kvm.c                |  12 +-=0D
 target/mips/translate.c          | 206 ++++++++++++++++++-------------=0D
 target/mips/translate_init.c.inc |  12 +-=0D
 5 files changed, 138 insertions(+), 101 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D
