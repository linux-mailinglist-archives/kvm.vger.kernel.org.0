Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51BB76A56D
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjHAAVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjHAAVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:33 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2112D19A4
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55be4f03661so5207964a12.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849291; x=1691454091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2V2qqbRtJdIF4yKoul1PG5FvBTRojVE4noGz8EUUEGo=;
        b=b4gXIVWX4cTKAZEBzuS9bcuTAIwnIpR66S3yHkHBzJg6Pqk6/twID1GBjAw9sqMNEe
         sr8t7BYV6mty7CFn9oOUry++ndP3gel1ZBA8n433pUcnMmtKavpQiAYhxdjtq1zNP+qW
         A8K77tu+LeGtGiHgEOpdG7tDsHmKWquXFI6tAAxOsBTLMioIR2PHsAOh+VW6BFFxkxcA
         9CrK1F/fby5iCi3/bzHMc/edGX33OcDpyrk8Q2FoI/Y4wqcJJHZfuATFIWdUgbI2RS9R
         GNpOA/tcOK68CMq2+Z/xSUQ1C7Fa6o9a9EpLwQSaxRB1rwWII+JOkwVx5V2Wyx1Ewdl/
         ZR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849291; x=1691454091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2V2qqbRtJdIF4yKoul1PG5FvBTRojVE4noGz8EUUEGo=;
        b=TGJZKAMhwCKminEJkv/rUOGOQtCHPTbJoDX4StxQ78CjYa/D+hM6cMiBXC1AUb5kHC
         RYPyHJafZBtYN35cI/rIxTZMNpot6kiWCyAg/zwV6CaBSxRWsIoZjE2sCm10G1Tm4joi
         tkUdbC5prNhaODcjcMmGSvQSykxykTYcXUhan02vcDnLhW22/lm5z9OGdfk/dXIuQMaq
         Ns1ISKF8iNn7r+26VpPk7qF23OCuH/O7XWdEePVoX3ne6JaPhLMqxxoXl/nZhqpXjeYE
         kvAW8Bswuob3cBfhlX4z66+pfGlfvY7EuqH7QcEWLMLjdGBvVyfm6Lajhah5zpNcjUdN
         IPCg==
X-Gm-Message-State: ABy/qLYLbOqTk85PO/C9INwlsYSdV46kl0UpY/6qtqZYYxx8lbxUacKN
        1p8WS53vPFj0l2rIgJgwBpET1KeMChQu
X-Google-Smtp-Source: APBJJlE2zNXDzrG9zPFf9F8B6Qrdnzu1M70NsJqVru5PDje4e8hKGj6bKUmauq0mTOtpQsX6jWWyA46aK0Ss
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:7e54:0:b0:564:f85:c822 with SMTP id
 o20-20020a637e54000000b005640f85c822mr66706pgn.8.1690849291659; Mon, 31 Jul
 2023 17:21:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:21 +0000
In-Reply-To: <20230801002127.534020-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-2-mizhang@google.com>
Subject: [PATCH v3 1/6] KVM: Documentation: Add the missing description for
 guest_mode in kvm_mmu_page_role
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the missing description for guest_mode in kvm_mmu_page_role
description.  guest_mode tells KVM whether a shadow page is used for the L1
or an L2. Update the missing field in documentation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 8364afa228ec..561efa8ec7d7 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -202,6 +202,8 @@ Shadow pages contain the following information:
     Is 1 if the MMU instance cannot use A/D bits.  EPT did not have A/D
     bits before Haswell; shadow EPT page tables also cannot use A/D bits
     if the L1 hypervisor does not enable them.
+  role.guest_mode:
+    Indicates the shadow page is created for a nested guest.
   role.passthrough:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
-- 
2.41.0.585.gd2178a4bd4-goog

