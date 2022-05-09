Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E9B520259
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiEIQaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239028AbiEIQaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:30:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC64A1FC2F0
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:26:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y14-20020a1709027c8e00b0015906c1ea31so8506025pll.20
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=24ZXTLzrcb04Vr94e2BinqljFa5PLSd+pPp++TfBpV4=;
        b=P2MUNiyZ52zkfiPjcTS8SbrOv+J4pIHeiuXQFaZnESg+NLVcCU4AR/+fuZgpSBJHvE
         rej/pBP0q29OlurWs27cZq38903lkbwzGDQrWMriEBwcQEe3UtVPAayTBp96OwiKgap+
         LxnYhTuP4ZWRpIebRHdev99As+Py+mvlCVMd3D2qN5Qmpq8aghskctCe/hfEfC249O+L
         3n0gWT+eovPuEaB24iPZEmL9XqbtVwLE//FTCfavnJqsLwR6eOuJ/ZgMEPsWRJFbX9I8
         dfcd2f2RR2knl9FJNgaSc9pfkr2xrKpX4HOJPcQnVcrbmwKGZvCTvtme2vs6Y1WphhFs
         dGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=24ZXTLzrcb04Vr94e2BinqljFa5PLSd+pPp++TfBpV4=;
        b=C1pK3KY7gqQbS0Bbx34ph0ky5+8m1Xk8BOOpMZrztBbtX4i7RPao5VhuVM3ZNxWlYq
         +EygkDdQJfnAxcC7IpC5IEB3ypAiwBljAxfQP0xxNU5nHGenXSaKLAymIVvEkByn/kRs
         /R2+sd9tuhZZaRIn38XQ6BQEh0phBl7O0gO+WBkIeDC9eWPGhiWirSDM+JAdX8XPk7Y3
         YeFrvIVXc6+G69kziK3E3FSCrzq9FbP9XYHanlfekHo/DXpUZ/U+pqpAX7gJc8FGlxKH
         DVc3VmJhxQZq4RpSc8HtOXHG0lk+bcrUJTNWAG0X0LymA9iC3i6VpXhw/MQiJERHUfHK
         CiDQ==
X-Gm-Message-State: AOAM532PkVKNJDaR+bDxL/GgfqthemMPJX2n7gDcKs2LH8pU0e2MoTof
        KCAhr22/VBWTnpsIF3xq/yh06R+D1g4=
X-Google-Smtp-Source: ABdhPJw1MOqIa/OCx3HluxWiZNUBlyVCmiV5/bxnPcSifyQh0atyvanFNrvtWw7hQl7rFciI7mrRmNlka6M=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP id
 b14-20020a170902e94e00b0015b22a7f593mr17113726pll.148.1652113573120; Mon, 09
 May 2022 09:26:13 -0700 (PDT)
Date:   Mon,  9 May 2022 16:25:57 +0000
Message-Id: <20220509162559.2387784-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 0/2] KVM: arm64: Minor pKVM cleanups
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com, tabba@google.com,
        qperret@google.com, will@kernel.org,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was reading through some of the pKVM stuff to get an idea of how it
handles feature registers and spotted a few minor nits.

Applies cleanly to 5.18-rc5.

Oliver Upton (2):
  KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
  KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE

 arch/arm64/kvm/hyp/nvhe/switch.c   | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  3 ---
 2 files changed, 1 insertion(+), 21 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

