Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9072751F
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 04:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjFHCpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 22:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjFHCpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 22:45:14 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0B82126
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 19:45:12 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-75d5469c856so8540585a.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 19:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686192312; x=1688784312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=teN9p0t9Py9PEukUc7/cqagMxz/5d+anLF3de3OjgMs=;
        b=JyKG9gVIrKRNvg08FK0kze79jE+HPGg14Ppzb0B87BxKnQTHTcgU05NSJw/u+1OiNC
         qNs9ope2ux+R/3VumkcD5W8q0tVfR3vowKfKXIyOfN7+0itWGFz82ba8wHsl43SpfsgA
         WrSVxEvKOcTcsLLrIUSy9kXaMRg/QAzVS7xzU560e9WoflWDJmcgi9T6IbkfFldbM5Sy
         VIor5qle13B3gjcYydJ+71yiJYAk+0J0QSBpH2P20IdOg9F5EiJBQgWIhTahq4KIybQq
         unrLP2gYRdX9Ix3VYpjQsg7X0wyHaMqescICLJvWTkw4/Va/RAlPoR33hrl0KVfE3qH6
         SfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686192312; x=1688784312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=teN9p0t9Py9PEukUc7/cqagMxz/5d+anLF3de3OjgMs=;
        b=IS0X+ObVxsUYIqz0Ji3IInKGJAeE1C2a5kCUL6sA0vLbr2s8gFrhS1Wxy96q00+eHl
         aLW2Kp/hejUeaMQW2c0P+YrqTkzfJaDyyeT1ajhIDF1ohS7vTX/YYGVSxC+OD0+DMhlf
         7DJbN412qGJMr44aP0eSaRFE0AzeTSw1FUw7rg9kZW/eDv47GH1bSHpEnN45OhXoABhO
         bKqV15u2G8L6+i5dk0mhF9OmNAuUYTyVqguIKstetkznPwe3fogTkacJn6Ew9UbsjFro
         Dv+yVX0H9ZQoESafZ06HaBN38yTxq+lqZQq07jdAVt2bZ5iX/olg+/uET0ZUZB0kZORx
         Spjg==
X-Gm-Message-State: AC+VfDwqeJIvT4szB5THBK7lubBE9gLlQz6oj725E4BoaZlJ4nc8yTZE
        PJoli/lV7m+Wz47Jn3CTaWI=
X-Google-Smtp-Source: ACHHUZ5U53tkB/Ijo7k2JmytjfmtxBzc/YSVbJKsamc7Fx4I05POeWa4lQTTG1qRKoS80xXM2zYKRQ==
X-Received: by 2002:a05:620a:4690:b0:75d:5321:fa40 with SMTP id bq16-20020a05620a469000b0075d5321fa40mr4207972qkb.51.1686192311907;
        Wed, 07 Jun 2023 19:45:11 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id gt1-20020a17090af2c100b002591b957641sm173870pjb.41.2023.06.07.19.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 19:45:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: PPC: Update MAINTAINERS
Date:   Thu,  8 Jun 2023 12:45:04 +1000
Message-Id: <20230608024504.58189-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael is merging KVM PPC patches via the powerpc tree and KVM topic
branches. He doesn't necessarily have time to be across all of KVM so
is reluctant to call himself maintainer, but for the mechanics of how
patches flow upstream, it is maintained and does make sense to have
some contact people in MAINTAINERS.

So add Michael Ellerman as KVM PPC maintainer and myself as reviewer.
Split out the subarchs that don't get so much attention.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0dab9737ec16..44417acd2936 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11379,7 +11379,13 @@ F:	arch/mips/include/uapi/asm/kvm*
 F:	arch/mips/kvm/
 
 KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
+M:	Michael Ellerman <mpe@ellerman.id.au>
+R:	Nicholas Piggin <npiggin@gmail.com>
 L:	linuxppc-dev@lists.ozlabs.org
+L:	kvm@vger.kernel.org
+S:	Maintained (Book3S 64-bit HV)
+S:	Odd fixes (Book3S 64-bit PR)
+S:	Orphan (Book3E and 32-bit)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
 F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/include/uapi/asm/kvm*
-- 
2.40.1

