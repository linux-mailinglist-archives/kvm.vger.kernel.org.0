Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40A9733D6B
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjFQBcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFQBcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:32:17 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0CA3AAE
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:16 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1a98cf01151so1457247fac.2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965536; x=1689557536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tqEygQDd/2w/8+707JUmZL/5BF87rV1WGy9Ueb44VpM=;
        b=JCLwscTKzfcVxAy5zZm1Uwi9WPvvVjpssPDYmR+iXIfe3lxChTgO27ay9kFmoGRYsV
         Ei7cxSX3WBX255+8y8e7wTXQrLNM/W38xiyJmei+7fse8mYTxezZvsVWNMTJS6wmk4nm
         lfCGAkt3U3H4qSGCOLP1uIwcarT4VOjzpBbyAm/Y7aASbKIKfTR5k92tYSql9CVe5peC
         VsJxe8RH9vkj7iKdceWXMQukN9ioJlvQsNJ/KE+AUA3HlY0SuP+hPU2Y0wpOOn6K+yfa
         aTCCMlRRa25uuc2t3LrMJQrFE9VXtrGF6ZdY6+QcAP5kPXyMj7gEuSaeiHnOHrh5/pVZ
         //Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965536; x=1689557536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqEygQDd/2w/8+707JUmZL/5BF87rV1WGy9Ueb44VpM=;
        b=NUMmP+tur52Kp2ENXI6IMzgef8Vz/K0z0CII9DPcR87HGGUfUfLWFuLxgod3nVNShx
         wM6679z+k7JJTN7OfjdXNRdaYGZWwC+vXpwMjs9ofO9MArSza4k+zIhtiyelQ/tB+Vi3
         RqbUbHb+ZAq/BHj4vhPkkjXTaOfIiRJQJSAnrirUobZFEGDyrHErzkys5ECHleAxqAa/
         KmrfOsCZEO+IqO00jpQCxbbIqS6KFEui5FFiLrrhUylZEQyaCN4h6zD+ePFszBthm3CN
         ehloXGfNjRHyBSUElGlFe70U8gv3bGR/FOvu+D9RoArt3q7iFDUzFG7YJqVwvsMtFfEn
         snkw==
X-Gm-Message-State: AC+VfDwnwdYYrH2Yo8nVr4glmwg5vaPK6v0ebZXjnRFhwx2J0SkO4d7U
        u0rgAcokMc2hiVfPoJlIJpE=
X-Google-Smtp-Source: ACHHUZ6TUzAkqbGGl+QY0n9VxR6rYU0/GThwRScpy9nQCD4ODsQ6sEoE80yD1/FJbdgJw/8n9+MYFQ==
X-Received: by 2002:a05:6870:d341:b0:1a6:a6fc:f6f1 with SMTP id h1-20020a056870d34100b001a6a6fcf6f1mr720666oag.26.1686965535669;
        Fri, 16 Jun 2023 18:32:15 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:15 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/2] arm64: fix paging issues
Date:   Sat, 17 Jun 2023 01:31:36 +0000
Message-Id: <20230617013138.1823-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Two more arm64 fixes, besides the vtimer ISTATUS fix that I recently
sent.

The first patch fixes an actual issue I encountered on my setup and
caused tests to crash.

The second fix is a theoretical one, which I found while reading the
code.

Nadav Amit (2):
  arm64: set sctlr_el1.SPAN
  arm64: ensure tlbi is safe

 arm/cstart64.S         | 1 +
 lib/arm64/asm/mmu.h    | 4 ++--
 lib/arm64/asm/sysreg.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.34.1

