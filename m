Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C2A5715BA
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiGLJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiGLJaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:30:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467618CC8F;
        Tue, 12 Jul 2022 02:30:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c15so1938437pla.6;
        Tue, 12 Jul 2022 02:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KSWKtf+HOXEP2Iy9qbz9E1JdXsJZP2Aba+49oBaWWkM=;
        b=iRoE7B2VQSel1PTmtQjL2Ip6l9klnV5wHDsH+FspryhHVv4h3dMyCXsmeSXkS6Fd6F
         HsDnW/en31hYf7uolkN6SYDPNAg5lNMM9A688ITzwGi7dVe6085wxS+Lsn73IQQZOnhf
         zxQcPWewCEaoc5+SOlE8pVgfnnpSStHRGQrsmnI55ENgTC4vXiB7AL+VcdexGQ9dEE3h
         LT+z//BmoS7c6dMk+aVqewFayfDO1ob0KEEqzau99gBXT0IkAZIm3fdg4D8OsglATSsv
         JXxv7xgga9pTK3C0+zETXvD++GFfg58qaSY6iC0X5Rxv9LOpNrnflKoMdDhtSJggQbPk
         EeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KSWKtf+HOXEP2Iy9qbz9E1JdXsJZP2Aba+49oBaWWkM=;
        b=fC+AEGQL10HgkNCRH0D1Pmkxsqt/bZJEp4650+cBA+Dh/EKHRlYZZdvEbZx2py3plv
         OkZh7nDAKpitLBz5RPScPSiInTcf4gJwVJ12WN/eq9qKdShsdoNXBVeviIsvxQD4tDFx
         1jOM5RvlHxKs3cD5U+HtS+hAWmHXuLYIDsGIW+K7U42q75tjv6ZuR6n+2mo8/OP0ToV6
         kVyM5pWnn1pQlQe3/q7F16RkAyy0o5x7TpNuPHjLXZrKtxZ6xBV2c9T2aZ/voo1C/WVJ
         SEkat3OQhx0VmxF/SodpSHa7PA+ac7dYdhBxr6/oqR3PSQ0OSB+oAfpmSXsz73q7NFmA
         /ULQ==
X-Gm-Message-State: AJIora+teX/xfIzcjaPxLiG/Stxc1i0XAPUfcZeY19UcCRZpbPSWSwim
        rHHUcgXvoDkUfMcj9Upti6MVWh/KZmk=
X-Google-Smtp-Source: AGRyM1vYHASuN6dD+nTPrkbCU2e/DP46HinfkU5OQJy/G0bvrFrajB6piNmd1yIdnNYwABRPnhDmSA==
X-Received: by 2002:a17:90b:3910:b0:1f0:2e50:6f3f with SMTP id ob16-20020a17090b391000b001f02e506f3fmr3260396pjb.233.1657618204823;
        Tue, 12 Jul 2022 02:30:04 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id o21-20020a635d55000000b00415320bc31dsm5656763pgm.32.2022.07.12.02.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 02:30:04 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 2BECF103980; Tue, 12 Jul 2022 16:29:58 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH next 0/3] miscellaneous documentation fixes for linux-next
Date:   Tue, 12 Jul 2022 16:29:51 +0700
Message-Id: <20220712092954.142027-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here are documentation fixes for recent warnings reported in linux-next.

This series is based on next-20220611 and Mauro's cross-ref and doc fixes
series [1]:

[1]: https://lore.kernel.org/linux-doc/cover.1657360984.git.mchehab@kernel.org/

Cc: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org

Bagas Sanjaya (3):
  Documentation: qat: Use code block for qat sysfs example
  Documentation: qat: rewrite description
  Documentation: kvm: extend KVM_S390_ZPCI_OP subheading underline

 Documentation/ABI/testing/sysfs-driver-qat | 37 ++++++++--------------
 Documentation/virt/kvm/api.rst             |  2 +-
 2 files changed, 14 insertions(+), 25 deletions(-)

-- 
An old man doll... just what I always wanted! - Clara

