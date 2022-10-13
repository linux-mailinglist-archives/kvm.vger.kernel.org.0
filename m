Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4225FE471
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJMVtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJMVtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:49:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE2196B68
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:49:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pq16so3195141pjb.2
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=5x+e0kGznGYIc1lBTxzEAmXIbJeWo1iHQIPY8fnLHag=;
        b=0mBWLYAlyeQZAzYd9aLsjmDwL6zq0liKCzyVZwNRMKGuBMrLp/Ck9erOLWmXKdbhYD
         ols/nGEA7H58zzk9c5eV8TzNlsz8P4n1E5/Rbz/uSgeTlOmNkaFd3k7xh7bLaPaloSLS
         o57Msr1XadL9E8Fd/kzSCKiHWG1SB/57HlfCZ8I+I5j/5Mh6aeCfiiZ3g7Nlrb5qDjyM
         w0+IJ3F2HQt9Mx1tjrn0JBRjg6R63oSnpI3Fc/+CIzsvHuFF1oJm8EgyTQFeL24D8CPh
         iFM4VguN15D6bW+2Pl0xsQpIMd+Sp9sRh1lvMPIGmMlvP3Lm1R1EscAYsgcIh3Qey18c
         snwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5x+e0kGznGYIc1lBTxzEAmXIbJeWo1iHQIPY8fnLHag=;
        b=jVPp4w59IPWZ5fEc36TvQLwHK9p/h8Sw5NHFCARt9F6jQWfhAXJ8XN7I8sO79m2AAf
         pSPgzxHosdAw/Tmy0Qnrf7j1bZzRtSKxsB+zNYXKP2/SAdiauX/sDwX4KOmXAbmwLBXN
         DczEKO3BH+bmSrFk6eH1nCG+Qc1fIV1zL9dQJHntCbjHtI1qO90Bn8V6Y1CRzZWxmTu4
         zbalj11MlBD3A8wps1BFjMp7zeQLw9hdcU8GPblMreHuzCKPtS09o8ESOQsCk2mW6iU4
         f/4fxd5XxUE1ixCr3VpVJK8GwYXBOLeMgKX8CWFk5GQAXtxfwADntVUWIo0QSvFiRq0e
         VLsA==
X-Gm-Message-State: ACrzQf3meQ6vXr2zgRAt3TlxuoDKdvE0oLQmYCDuBgESgzsmsOjl7w7V
        RKhBn1B2p1KLhz/lXqyU986SRPVBU7XEaIme
X-Google-Smtp-Source: AMsMyM4zLbXgFjIuDY268Sco/RrtUbMjJZOAo4Ghadn1zxYD4ESurYvRL+wj010yF8IvrczajpTF4g==
X-Received: by 2002:a17:902:820b:b0:185:b9a:8ac1 with SMTP id x11-20020a170902820b00b001850b9a8ac1mr1948346pln.111.1665697751971;
        Thu, 13 Oct 2022 14:49:11 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902d04400b00176a6ba5969sm314528pll.98.2022.10.13.14.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:49:11 -0700 (PDT)
Subject: [PATCH] MAINTAINERS: git://github -> https://github.com for kvm-riscv
Date:   Thu, 13 Oct 2022 14:46:38 -0700
Message-Id: <20221013214638.30974-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:        linux-kernel@vger.kernel.org,
           Palmer Dabbelt <palmer@rivosinc.com>,
           Conor Dooley <conor.dooley@microchip.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Reported-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
I've split these up by github username so folks can take them
independently, as some of these repos have been renamed at github and
thus need more than just a sed to fix them.
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a47bd58a330..d103b44fb40c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11156,7 +11156,7 @@ L:	kvm@vger.kernel.org
 L:	kvm-riscv@lists.infradead.org
 L:	linux-riscv@lists.infradead.org
 S:	Maintained
-T:	git git://github.com/kvm-riscv/linux.git
+T:	git https://github.com/kvm-riscv/linux.git
 F:	arch/riscv/include/asm/kvm*
 F:	arch/riscv/include/uapi/asm/kvm*
 F:	arch/riscv/kvm/
-- 
2.38.0

