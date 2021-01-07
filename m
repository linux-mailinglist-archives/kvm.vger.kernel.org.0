Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC62EE895
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbhAGW1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbhAGW1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA01DC0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:04 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c5so7110477wrp.6
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vGDQCmouQR39Ws4zTMOXUe5wAq7PwBxciYPsXSjmS+Y=;
        b=PkuBl3lb04zyWZdMBpLwuScolwvuKUnKvhkn7zD/l1du3iZt8eKlyxOCB+AYSO4rfO
         lBToD/pc5OPbF8hW+jy8ibDlKDagHpEQo/ser32bizeywzTiMddYk1piUy6D+CC/HeWX
         tjm82gg+9AU45tlca4UKBwPuftY26vyzf+a7iGkPGXo+5JKCUxP+GcBhY4iq95V20RLy
         SfI9DGBiK24HkabUJaNZKWD/HVUYGs6LzyuKVu4Ft8SYydls5sNNDDekU86nvWaNyE4O
         PhAvQBjGBPyU/9lf7hE71lGuVHweh/nfuF8QD2HwbmkaDcrsqSMOJRCtypjzHleriPXL
         wjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vGDQCmouQR39Ws4zTMOXUe5wAq7PwBxciYPsXSjmS+Y=;
        b=Dbsni46NYopKBhbpoorQC/s9KGzsDhZxMcAgCiJAq182sgWhcmfyLOP0bRuXFtxJkw
         NBVBvy/h5dQymKVR0Dz+glAK131n9zCbJbA9KZavb/6B+GKA/NcAO7L9YcYSREMdJ/Oj
         5T7Pq5qU9JBLWFAiT+WJ/zoqH1KiV4ipqf0zLweuxfz7SLNmN5P4WRY6KIkdqdibGb/v
         2s/qCPPNWzRjWYWg/EsLW/0P5srEsg65I1x4rHIxbDcMiFqHXkf0wB7mo36Zw/wVJ35E
         xhZDh2whGLibEj6uNAjlpwC2ktB5zPMXBxXC5imftsIIecFMDHeIiPw9QJdqKj4DsB2Q
         9NNQ==
X-Gm-Message-State: AOAM531QzsZDDBErxi5z04shmSYEx5+hGm9Ur6xiTyJtRidD202xnmQD
        e78K58ALIBRMHrenDdEL6SvU2n69y4A=
X-Google-Smtp-Source: ABdhPJzp0E8rR0XLj17MQAkJR1Jhd02p2WUxwfz8QZdk4Gi2vxmkF7nlOa4S8saYY5O/4n1//CmgXQ==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr660098wrp.401.1610058423399;
        Thu, 07 Jan 2021 14:27:03 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id a14sm10131057wrn.3.2021.01.07.14.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:02 -0800 (PST)
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
Subject: [PULL 48/66] target/mips: Extract MSA helper definitions
Date:   Thu,  7 Jan 2021 23:22:35 +0100
Message-Id: <20210107222253.20382-49-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keep all MSA-related code altogether.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20201120210844.2625602-4-f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 target/mips/helper.h         | 436 +---------------------------------
 target/mips/msa_helper.h.inc | 443 +++++++++++++++++++++++++++++++++++
 2 files changed, 445 insertions(+), 434 deletions(-)
 create mode 100644 target/mips/msa_helper.h.inc

diff --git a/target/mips/helper.h b/target/mips/helper.h
index e97655dc0eb..709494445dd 100644
--- a/target/mips/helper.h
+++ b/target/mips/helper.h
@@ -781,438 +781,6 @@ DEF_HELPER_FLAGS_3(dmthlip, 0, void, tl, tl, env)
 DEF_HELPER_FLAGS_3(wrdsp, 0, void, tl, tl, env)
 DEF_HELPER_FLAGS_2(rddsp, 0, tl, tl, env)
 
-/* MIPS SIMD Architecture */
-
-DEF_HELPER_3(msa_nloc_b, void, env, i32, i32)
-DEF_HELPER_3(msa_nloc_h, void, env, i32, i32)
-DEF_HELPER_3(msa_nloc_w, void, env, i32, i32)
-DEF_HELPER_3(msa_nloc_d, void, env, i32, i32)
-
-DEF_HELPER_3(msa_nlzc_b, void, env, i32, i32)
-DEF_HELPER_3(msa_nlzc_h, void, env, i32, i32)
-DEF_HELPER_3(msa_nlzc_w, void, env, i32, i32)
-DEF_HELPER_3(msa_nlzc_d, void, env, i32, i32)
-
-DEF_HELPER_3(msa_pcnt_b, void, env, i32, i32)
-DEF_HELPER_3(msa_pcnt_h, void, env, i32, i32)
-DEF_HELPER_3(msa_pcnt_w, void, env, i32, i32)
-DEF_HELPER_3(msa_pcnt_d, void, env, i32, i32)
-
-DEF_HELPER_4(msa_binsl_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsl_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsl_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsl_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_binsr_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsr_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsr_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_binsr_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_bmnz_v, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bmz_v, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bsel_v, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_bclr_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bclr_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bclr_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bclr_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_bneg_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bneg_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bneg_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bneg_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_bset_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bset_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bset_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bset_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_add_a_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_add_a_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_add_a_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_add_a_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_adds_a_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_a_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_a_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_a_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_adds_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_adds_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_adds_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_addv_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_addv_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_addv_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_addv_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_hadd_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hadd_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hadd_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_hadd_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hadd_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hadd_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_ave_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_ave_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ave_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_aver_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_aver_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_aver_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_ceq_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ceq_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ceq_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ceq_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_cle_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_cle_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_cle_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_clt_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_clt_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_clt_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_div_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_div_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_div_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_max_a_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_a_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_a_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_a_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_max_u_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_a_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_a_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_a_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_a_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_min_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_mod_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_mod_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mod_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_maddv_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_maddv_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_maddv_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_maddv_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_msubv_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_msubv_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_msubv_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_msubv_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_mulv_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mulv_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mulv_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_mulv_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_asub_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_asub_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_asub_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_hsub_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hsub_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hsub_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_hsub_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hsub_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_hsub_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_subs_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_subs_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subs_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_subsus_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsus_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsus_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsus_u_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_subsuu_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsuu_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsuu_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subsuu_s_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_subv_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subv_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subv_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_subv_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_ilvev_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvev_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvev_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvev_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvod_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvod_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvod_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvod_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvl_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvl_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvl_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvl_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvr_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvr_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvr_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ilvr_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_and_v, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_nor_v, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_or_v, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_xor_v, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_pckev_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckev_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckev_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckev_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckod_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckod_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckod_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_pckod_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_sll_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sll_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sll_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sll_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_sra_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sra_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sra_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_sra_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_srar_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srar_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srar_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srar_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_srl_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srl_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srl_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srl_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_srlr_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srlr_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srlr_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_srlr_d, void, env, i32, i32, i32)
-
-DEF_HELPER_3(msa_move_v, void, env, i32, i32)
-
-DEF_HELPER_4(msa_andi_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ori_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_nori_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_xori_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bmnzi_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bmzi_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_bseli_b, void, env, i32, i32, i32)
-DEF_HELPER_5(msa_shf_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_5(msa_addvi_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_subvi_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_maxi_s_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_maxi_u_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_mini_s_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_mini_u_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_ceqi_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_clti_s_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_clti_u_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_clei_s_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_5(msa_clei_u_df, void, env, i32, i32, i32, s32)
-DEF_HELPER_4(msa_ldi_df, void, env, i32, i32, s32)
-
-DEF_HELPER_5(msa_slli_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_srai_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_srli_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_bclri_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_bseti_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_bnegi_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_binsli_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_binsri_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_sat_s_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_sat_u_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_srari_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_srlri_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_5(msa_binsl_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_binsr_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_4(msa_dotp_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dotp_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dotp_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dotp_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dotp_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dotp_u_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpadd_u_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_dpsub_u_d, void, env, i32, i32, i32)
-DEF_HELPER_5(msa_sld_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_splat_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_vshf_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_5(msa_sldi_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_splati_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_5(msa_insve_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_3(msa_ctcmsa, void, env, tl, i32)
-DEF_HELPER_2(msa_cfcmsa, tl, env, i32)
-
-DEF_HELPER_5(msa_fcaf_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcun_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fceq_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcueq_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fclt_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcult_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcle_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcule_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsaf_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsun_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fseq_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsueq_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fslt_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsult_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsle_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsule_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fadd_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsub_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmul_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fdiv_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmadd_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmsub_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fexp2_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fexdo_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_ftq_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmin_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmin_a_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmax_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fmax_a_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcor_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcune_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fcne_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_mul_q_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_madd_q_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_msub_q_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsor_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsune_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_fsne_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_mulr_q_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_maddr_q_df, void, env, i32, i32, i32, i32)
-DEF_HELPER_5(msa_msubr_q_df, void, env, i32, i32, i32, i32)
-
-DEF_HELPER_4(msa_fill_df, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_copy_s_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_s_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_s_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_s_d, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_u_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_u_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_copy_u_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_insert_b, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_insert_h, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_insert_w, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_insert_d, void, env, i32, i32, i32)
-
-DEF_HELPER_4(msa_fclass_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ftrunc_s_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ftrunc_u_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_fsqrt_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_frsqrt_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_frcp_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_frint_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_flog2_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_fexupl_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_fexupr_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ffql_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ffqr_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ftint_s_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ftint_u_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ffint_s_df, void, env, i32, i32, i32)
-DEF_HELPER_4(msa_ffint_u_df, void, env, i32, i32, i32)
-
-#define MSALDST_PROTO(type)                         \
-DEF_HELPER_3(msa_ld_ ## type, void, env, i32, tl)   \
-DEF_HELPER_3(msa_st_ ## type, void, env, i32, tl)
-MSALDST_PROTO(b)
-MSALDST_PROTO(h)
-MSALDST_PROTO(w)
-MSALDST_PROTO(d)
-#undef MSALDST_PROTO
-
 DEF_HELPER_3(cache, void, env, tl, i32)
+
+#include "msa_helper.h.inc"
diff --git a/target/mips/msa_helper.h.inc b/target/mips/msa_helper.h.inc
new file mode 100644
index 00000000000..4963d1553a0
--- /dev/null
+++ b/target/mips/msa_helper.h.inc
@@ -0,0 +1,443 @@
+/*
+ *  MIPS SIMD Architecture Module (MSA) helpers for QEMU.
+ *
+ *  Copyright (c) 2004-2005 Jocelyn Mayer
+ *  Copyright (c) 2006 Marius Groeger (FPU operations)
+ *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
+ *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
+ *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+DEF_HELPER_3(msa_nloc_b, void, env, i32, i32)
+DEF_HELPER_3(msa_nloc_h, void, env, i32, i32)
+DEF_HELPER_3(msa_nloc_w, void, env, i32, i32)
+DEF_HELPER_3(msa_nloc_d, void, env, i32, i32)
+
+DEF_HELPER_3(msa_nlzc_b, void, env, i32, i32)
+DEF_HELPER_3(msa_nlzc_h, void, env, i32, i32)
+DEF_HELPER_3(msa_nlzc_w, void, env, i32, i32)
+DEF_HELPER_3(msa_nlzc_d, void, env, i32, i32)
+
+DEF_HELPER_3(msa_pcnt_b, void, env, i32, i32)
+DEF_HELPER_3(msa_pcnt_h, void, env, i32, i32)
+DEF_HELPER_3(msa_pcnt_w, void, env, i32, i32)
+DEF_HELPER_3(msa_pcnt_d, void, env, i32, i32)
+
+DEF_HELPER_4(msa_binsl_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsl_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsl_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsl_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_binsr_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsr_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsr_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_binsr_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_bmnz_v, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bmz_v, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bsel_v, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_bclr_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bclr_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bclr_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bclr_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_bneg_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bneg_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bneg_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bneg_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_bset_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bset_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bset_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bset_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_add_a_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_add_a_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_add_a_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_add_a_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_adds_a_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_a_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_a_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_a_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_adds_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_adds_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_adds_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_addv_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_addv_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_addv_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_addv_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_hadd_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hadd_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hadd_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_hadd_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hadd_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hadd_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_ave_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_ave_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ave_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_aver_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_aver_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_aver_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_ceq_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ceq_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ceq_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ceq_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_cle_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_cle_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_cle_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_clt_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_clt_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_clt_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_div_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_div_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_div_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_max_a_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_a_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_a_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_a_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_max_u_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_a_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_a_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_a_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_a_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_min_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_mod_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_mod_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mod_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_maddv_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_maddv_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_maddv_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_maddv_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_msubv_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_msubv_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_msubv_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_msubv_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_mulv_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mulv_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mulv_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_mulv_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_asub_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_asub_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_asub_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_hsub_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hsub_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hsub_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_hsub_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hsub_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_hsub_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_subs_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_subs_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subs_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_subsus_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsus_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsus_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsus_u_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_subsuu_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsuu_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsuu_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subsuu_s_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_subv_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subv_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subv_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_subv_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_ilvev_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvev_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvev_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvev_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvod_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvod_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvod_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvod_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvl_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvl_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvl_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvl_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvr_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvr_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvr_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ilvr_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_and_v, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_nor_v, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_or_v, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_xor_v, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_pckev_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckev_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckev_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckev_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckod_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckod_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckod_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_pckod_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_sll_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sll_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sll_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sll_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_sra_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sra_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sra_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_sra_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_srar_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srar_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srar_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srar_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_srl_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srl_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srl_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srl_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_srlr_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srlr_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srlr_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_srlr_d, void, env, i32, i32, i32)
+
+DEF_HELPER_3(msa_move_v, void, env, i32, i32)
+
+DEF_HELPER_4(msa_andi_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ori_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_nori_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_xori_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bmnzi_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bmzi_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_bseli_b, void, env, i32, i32, i32)
+DEF_HELPER_5(msa_shf_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_5(msa_addvi_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_subvi_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_maxi_s_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_maxi_u_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_mini_s_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_mini_u_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_ceqi_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_clti_s_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_clti_u_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_clei_s_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_5(msa_clei_u_df, void, env, i32, i32, i32, s32)
+DEF_HELPER_4(msa_ldi_df, void, env, i32, i32, s32)
+
+DEF_HELPER_5(msa_slli_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_srai_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_srli_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_bclri_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_bseti_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_bnegi_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_binsli_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_binsri_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_sat_s_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_sat_u_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_srari_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_srlri_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_5(msa_binsl_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_binsr_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_4(msa_dotp_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dotp_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dotp_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dotp_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dotp_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dotp_u_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpadd_u_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_dpsub_u_d, void, env, i32, i32, i32)
+DEF_HELPER_5(msa_sld_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_splat_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_vshf_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_5(msa_sldi_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_splati_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_5(msa_insve_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_3(msa_ctcmsa, void, env, tl, i32)
+DEF_HELPER_2(msa_cfcmsa, tl, env, i32)
+
+DEF_HELPER_5(msa_fcaf_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcun_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fceq_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcueq_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fclt_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcult_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcle_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcule_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsaf_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsun_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fseq_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsueq_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fslt_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsult_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsle_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsule_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fadd_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsub_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmul_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fdiv_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmadd_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmsub_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fexp2_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fexdo_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_ftq_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmin_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmin_a_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmax_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fmax_a_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcor_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcune_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fcne_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_mul_q_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_madd_q_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_msub_q_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsor_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsune_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_fsne_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_mulr_q_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_maddr_q_df, void, env, i32, i32, i32, i32)
+DEF_HELPER_5(msa_msubr_q_df, void, env, i32, i32, i32, i32)
+
+DEF_HELPER_4(msa_fill_df, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_copy_s_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_s_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_s_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_s_d, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_u_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_u_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_copy_u_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_insert_b, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_insert_h, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_insert_w, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_insert_d, void, env, i32, i32, i32)
+
+DEF_HELPER_4(msa_fclass_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ftrunc_s_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ftrunc_u_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_fsqrt_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_frsqrt_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_frcp_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_frint_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_flog2_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_fexupl_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_fexupr_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ffql_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ffqr_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ftint_s_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ftint_u_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ffint_s_df, void, env, i32, i32, i32)
+DEF_HELPER_4(msa_ffint_u_df, void, env, i32, i32, i32)
+
+#define MSALDST_PROTO(type)                         \
+DEF_HELPER_3(msa_ld_ ## type, void, env, i32, tl)   \
+DEF_HELPER_3(msa_st_ ## type, void, env, i32, tl)
+MSALDST_PROTO(b)
+MSALDST_PROTO(h)
+MSALDST_PROTO(w)
+MSALDST_PROTO(d)
+#undef MSALDST_PROTO
-- 
2.26.2

