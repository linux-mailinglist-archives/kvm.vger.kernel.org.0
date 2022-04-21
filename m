Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9141150A447
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390157AbiDUPfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 11:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390130AbiDUPfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 11:35:38 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF09ADFDA
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:32:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t6so3791670wra.4
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7saXZ0wD/Eiz7Q0Lij9LYsBuK9XeQWJt4sfDjnXCwG4=;
        b=kWjl4CCPwIixJSgXB9ws/rkGP08rPz7GqBRiC/x5Zq28CKoLC2pNNSTAOU7uifTtiT
         MHADrMrPWSik9D+shnVD8R3BuqQLEI/06tU42iUWv11J0l8P8vCZYn2gGq/llzZuv4w2
         JnADsQMCNMyWwKSRQR/fjDXs8ADSVTz2jbrlnkh59111TLWEZdXEsXJhTg1m0g+bzfFn
         8Q69XpA9bqxqx7qAkEZA2uiotTgspyE340Bo7prGw0O1QURv7OnLBswXP/AV0+AF94gi
         hEJNNNI+xsWsLiY9mxWwvCb8m/b1+T7i4lgvkWsncOeNd5ICYKde5b0FfXNzAFzE85ko
         l2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7saXZ0wD/Eiz7Q0Lij9LYsBuK9XeQWJt4sfDjnXCwG4=;
        b=qL+WDNYDsmLuCZBNUb7PdV4Zx6tw1nmojkW4+lLIg9n+JjoypAQA39s2ReFHkXwPwJ
         hi8TVFSwgzwtm9PCcDvirwoVUBsHmDP2fwgvQD3M72+rBkgysiaEYzAJxTdM+hFdKmXS
         tUwVzgCEgAzW9df4BpjdzFmWBmyDrnkqombKeoDiyaDH4vUGGsjeFQK85p+JMNg0rmGs
         tDvobLaMLOGOpk32eUwd0SRMPmMwlCPymVe9QUlL7uqITzea9wc97cA3mg9+5W7u3IiL
         LY/eTy3/FtZT13gsgRzRRdnP9gIe6ZFkpIe5DlxwSjnyWdmkcOJf3VGkNq7CgPKseFn1
         p9eA==
X-Gm-Message-State: AOAM532KyhKKvpwEiydrn+9C7asADqFUMOBqsLzz5YafJiSjvsMLsUIs
        Y+EWGHkXf3UrQ/YiXItb39BQaQTevhUnjOmAvWpsiA==
X-Google-Smtp-Source: ABdhPJxTYUyl/g+eiiAqhsKTukCWfkqpWCDJv5k8bbK0tXT6TfssjfdJoR7ALTaKcKSn4TNsP/Gg7e10uIM9LsHO7OE=
X-Received: by 2002:a05:6000:1e0a:b0:20a:be21:a20 with SMTP id
 bj10-20020a0560001e0a00b0020abe210a20mr251438wrb.214.1650555166230; Thu, 21
 Apr 2022 08:32:46 -0700 (PDT)
MIME-Version: 1.0
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 21 Apr 2022 21:02:03 +0530
Message-ID: <CAAhSdy3io3CdxTDGRVCijO-R2V=GBOukOEs+BH6wYnkT2_iPMw@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 5.18, take #2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

This is the second set of fixes for 5.18. We only have two fixes related to
extensions that can be enabled/disabled in the isa ONE_REG register.

Please pull.

Regards,
Anup

The following changes since commit b2d229d4ddb17db541098b83524d901257e93845:

  Linux 5.18-rc3 (2022-04-17 13:57:31 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-5.18-2

for you to fetch changes up to 38d9a4ac65f204f264b33b966f0af4366f5518a8:

  RISC-V: KVM: Restrict the extensions that can be disabled
(2022-04-20 14:24:32 +0530)

----------------------------------------------------------------
 KVM/riscv fixes for 5.18, take #2

 - Remove 's' & 'u' as valid ISA extension

 - Restrict the extensions that can be disabled

----------------------------------------------------------------
Atish Patra (2):
      RISC-V: KVM: Remove 's' & 'u' as valid ISA extension
      RISC-V: KVM: Restrict the extensions that can be disabled

 arch/riscv/kvm/vcpu.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)
