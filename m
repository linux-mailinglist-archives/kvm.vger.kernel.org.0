Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3305F483178
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 14:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiACNiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 08:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiACNiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 08:38:18 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2508EC061761
        for <kvm@vger.kernel.org>; Mon,  3 Jan 2022 05:38:18 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id u21so41762236oie.10
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 05:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FD1ZmMFhS+qUrrSOxnb+UqMmZ3J0+5ZPilSel+beKWg=;
        b=lsX6wqRd4zBPFvV4mwJf6IIcyqmwFfi5t8d/lmGshHal8JmmFQyBj/oFoFjM90Tj5L
         M+3LEM+zxcmZS0hZHWqsGW6UVzjtiKAE4LaHZcOMDpXq324n4nZONGmGaMcGDSa4kffs
         q9OmZRh0t1HyawyNKV9eusZIpNB+ZPKH8I3Pl/6YttsrqseDUSiOSsd9h3Kx9C5ixubz
         Mbo/AhXuOvvgH7Z/g1g7mkWAgvmdNq8BQ4GtfwGiczdE1nrN8V6InmFxW2fWg9fCOIRE
         Ux+ssG0mXw3exxhqcFyt1P5kKX7+Kqvt5ESxh7YqsY153IJGzWho1wihLOIdsxQxZIFJ
         mKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FD1ZmMFhS+qUrrSOxnb+UqMmZ3J0+5ZPilSel+beKWg=;
        b=4ywNv2BJCvPk0h9k3gbk5+f2ig8AyR6H5vM1a5zNj8LjcI3zMRU9nDLMuYlSYoLOcY
         f0+1jmzpbK91jGwXYdko+4VlhefGG79/PIrOWaqkI7bKK3r0f4ssGNgeFU3WRtAyq9JN
         rsMY3Cdoh9syt0h9iqsf7sCNzd2iJg93w7wJHrjhPO7G9nRXH+2pOvevBaZ+w6DC1OKc
         WTiYiw+ftVNkMcSM2r0E9F1RhsaBPEV2TjuLJJPLIZlM1Y0FEs7/Hv4pjccRGjmb+xWO
         UAhiUhh6N1RAA86gujfIa5HaRms/4aRemvvNUrkGzfKtlmURsgtn0cQq8NCbr0utIR/6
         0AjQ==
X-Gm-Message-State: AOAM532bvM5AxRn2IdgTl/Qb7hPxLCGPOQ9SosemJt9QbKDaQ2lxsrng
        fh5ZgWr2hKOUGHPM4PVj8+kIVA==
X-Google-Smtp-Source: ABdhPJyfG/Xw2iZw6I2UvhVuymj+VSlEvk6nhBJMk/v0H8M0txzIh068DZ9LN1PNwXfvTPB9ywXK5w==
X-Received: by 2002:a05:6808:f8c:: with SMTP id o12mr34833308oiw.50.1641217096986;
        Mon, 03 Jan 2022 05:38:16 -0800 (PST)
Received: from localhost.localdomain ([122.171.53.133])
        by smtp.gmail.com with ESMTPSA id a12sm7679978otk.35.2022.01.03.05.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 05:38:15 -0800 (PST)
From:   Anup Patel <anup@brainfault.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <anup@brainfault.org>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org,
        KVM General <kvm@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Update Anup's email address
Date:   Mon,  3 Jan 2022 19:07:59 +0530
Message-Id: <20220103133759.103814-1-anup@brainfault.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am no longer work at Western Digital so update my email address to
personal one and add entries to .mailmap as well.

Signed-off-by: Anup Patel <anup@brainfault.org>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index e951cf1b1730..f5d327f0c4be 100644
--- a/.mailmap
+++ b/.mailmap
@@ -46,6 +46,7 @@ Andy Adamson <andros@citi.umich.edu>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@free-electrons.com>
 Antonio Ospite <ao2@ao2.it> <ao2@amarulasolutions.com>
+Anup Patel <anup@brainfault.org> <anup.patel@wdc.com>
 Archit Taneja <archit@ti.com>
 Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
 Arnaud Patard <arnaud.patard@rtp-net.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 3e8241451b49..aa7769f8c779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10443,7 +10443,7 @@ F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
 
 KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
-M:	Anup Patel <anup.patel@wdc.com>
+M:	Anup Patel <anup@brainfault.org>
 R:	Atish Patra <atishp@atishpatra.org>
 L:	kvm@vger.kernel.org
 L:	kvm-riscv@lists.infradead.org
-- 
2.25.1

