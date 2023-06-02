Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09E471F7C1
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjFBBXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbjFBBXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:23:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4D51A7
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:23:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25658dc0cdaso659324a91.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668984; x=1688260984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fDgd2gotor4ZR8cqfCrVsmiIAEV2vs7BB2zp4kNLJPc=;
        b=pWAmJFh3nGZ3XxQM7dBmf1+v2k6ehvlxXGidXMvm1s19HS+8M0tAvhMEdMZen45J2p
         o89UsftScXkJZ4xodlztX7r7J4Vo9/ZeH4lU1YGROBA6svmK5gjcT2HIHjhR3InifNMc
         FOw2LbaXrMaoCLaUcp56oriTt9toCPCKa+OgV8l90PhxL06KA/36NeNJAr1L1LIB3MOS
         TZ2ecDTpi/lora9QXFE5xtlLgjukbnjBGCqQDm2Qcg9ha2yHnTMRzW6LSvu7QF7KWvOs
         w1tYW4udIMl7d8TIs1CDK+lhshz2+PoOm6YI2heB4Egws2T1Hprc367aAhhkMXwgLmtN
         hDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668984; x=1688260984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fDgd2gotor4ZR8cqfCrVsmiIAEV2vs7BB2zp4kNLJPc=;
        b=AcSs/Julm/tYsHnnvih9qKYVgSzdo58gyjAu+5Ow36ypAUwtAL56nxGGgyPQ3F7jYO
         028CBcrFhAcpb+IDDzQb2wXJ9A96B+xI/pPX0l7D8r7vJYAt5PXUeC/fZERJxgClLbft
         MagJuGTGc79ghQBZ9FruKRLpPtKVka+8Xsl2F2Xtbj16sTh8YpPicKTONKyTg5LLUQHs
         xql3NtGABZzlXFu/5jzdUjq3XbOJJS6vuq8vHdnUKFoKFuPLLziMIh1ffGP16bJO/FNl
         3zQyssiHumqc6/ZvQDov+z9Ptarqb8r2gcZlTKTJg0+9hUuLk/GEMlHCFic188D6f8yH
         qLPg==
X-Gm-Message-State: AC+VfDzRyJGy0dVNi70ZjSJZDtXjB9gqGivshpzEhu9WP53aHYFbIokZ
        z+gU8xzydM64zcA08W7Js92oV/FbDhY=
X-Google-Smtp-Source: ACHHUZ7GsMl3I2PpWKbVoXSOY4KCC/lrrEZQrsLdYeTQdiqA5ZzPq8LJKKq1EFalDbkuvSb/Gd9V+tDR+zo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:11cd:b0:255:7a07:9e63 with SMTP id
 gv13-20020a17090b11cd00b002557a079e63mr201828pjb.3.1685668984352; Thu, 01 Jun
 2023 18:23:04 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:22:46 -0700
In-Reply-To: <20230425113932.3148-1-ubizjak@gmail.com>
Mime-Version: 1.0
References: <20230425113932.3148-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168512497255.2748559.4747399178242270011.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Apr 2023 13:39:32 +0200, Uros Bizjak wrote:
> Commit aee98a6838d5 ("KVM: x86/mmu: Use try_cmpxchg64 in
> tdp_mmu_set_spte_atomic") removed the comment that iter->old_spte is
> updated when different logical CPU modifies the page table entry.
> Although this is what try_cmpxchg does implicitly, it won't hurt
> if this fact is explicitly mentioned in a restored comment.
> 
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic
      https://github.com/kvm-x86/linux/commit/12ced095956a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
