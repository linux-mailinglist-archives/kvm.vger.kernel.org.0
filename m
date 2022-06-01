Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77096539FDB
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349812AbiFAIvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345084AbiFAIvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:51:36 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5867569729;
        Wed,  1 Jun 2022 01:51:35 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h19so1254547edj.0;
        Wed, 01 Jun 2022 01:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=U/4uwHbN3kTeOBlqC9MtcT8Zh6UZytYx1qP79LPgSd4=;
        b=KplaBvFsTVLv0IqD9M3SRA1T8uWUDOy/owGLewCaeOD9l1E+4/5fI72BAzMypMEyCr
         mFkrCA0pmXVxT4hgvHYsWrkDEk/mIE16NkQIj/BZecW8IdHJ59IUx7VegWouURPucjIU
         yLHHSmqqY6JmZn5XW6Y4YJqcus2G0No89u0ImXeEbNmQrx0gqXVTHTMn2ZnX1cUptsFM
         wFt/Xsrgss5kgU0yEPame4MuS1AAO8V+e4a/Q/ETlpXxapTsPvMH6sIoScfeMO2DjJ/u
         6jeaTAjz9xU8xL2V/g+EpI7gtLieQIxBa8FwPeQ0GF7nzfgRuR5IJL78EQWW/i/dTVAu
         S1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U/4uwHbN3kTeOBlqC9MtcT8Zh6UZytYx1qP79LPgSd4=;
        b=5ZsX7VBfzcdP4NNmXcALKnqgrDNpkTHiJEbOOCwtiVypMtg/T3Kfnv3mstnTJ6WVMk
         wqWbcib565S61hLpCq4z75aESIAxrVUZGezBOmJLgVIMDKiWgfKB/ULhNfxlgeSaZnyx
         BnAWDV0mpPoPmx6Ul1zpxSdvpc9DT2OGGKUnci/82jmOMH/MJifl3WrkyplciM8ZfSTS
         pxshv3VvYoO1on0MXUOgDG0wEAV6+XlTMRN0DzgRJ2UijCLVa3B0fvXIlZG1nzJHS6iP
         zefPZo4jn7AODc2umtnShWegWJot94RC+h04c6B1L7A5JW4R3tdxuP6ZhUNDjlLMy1Pv
         fftw==
X-Gm-Message-State: AOAM533G97UCgtnOcht2cZ5zR30I4V/62aYYbCe7NiSRz9SVv68onDnN
        7PzvW31tDdpOlkYgDkPw9Fw=
X-Google-Smtp-Source: ABdhPJzi3J/9s2Bj4RLOaibco+6hWCvjhIAHxvfi6zd/54MSyh/912AMfWa6u4p7Qpatl1i5Wzw1sQ==
X-Received: by 2002:a50:fc10:0:b0:42d:cbd2:4477 with SMTP id i16-20020a50fc10000000b0042dcbd24477mr18330933edr.363.1654073493766;
        Wed, 01 Jun 2022 01:51:33 -0700 (PDT)
Received: from felia.fritz.box (200116b82620c00028af88788fa7d286.dip.versatel-1u1.de. [2001:16b8:2620:c000:28af:8878:8fa7:d286])
        by smtp.gmail.com with ESMTPSA id fg16-20020a1709069c5000b006fe8d8c54a7sm447918ejc.87.2022.06.01.01.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 01:51:33 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: Limit KVM RISC-V entry to existing selftests
Date:   Wed,  1 Jun 2022 10:51:22 +0200
Message-Id: <20220601085122.28176-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit fed9b26b2501 ("MAINTAINERS: Update KVM RISC-V entry to cover
selftests support") optimistically adds a file entry for
tools/testing/selftests/kvm/riscv/, but this directory does not exist.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference. The script is very useful to keep MAINTAINERS up to date
and MAINTAINERS can be kept in a state where the script emits no warning.

So, just drop the non-matching file entry rather than starting to collect
exceptions of entries that may match in some close or distant future.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Anup, please consider to pick this minor clean-up patch.

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 36eab5ae237d..a8eee9d2aea5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10863,7 +10863,6 @@ F:	arch/riscv/include/asm/kvm*
 F:	arch/riscv/include/uapi/asm/kvm*
 F:	arch/riscv/kvm/
 F:	tools/testing/selftests/kvm/*/riscv/
-F:	tools/testing/selftests/kvm/riscv/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
-- 
2.17.1

