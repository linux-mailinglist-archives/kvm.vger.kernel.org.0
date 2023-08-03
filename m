Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CD976DBF6
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjHCAGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjHCAGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:06:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B83C38
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:05:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d05883d850fso318585276.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021134; x=1691625934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtfYC04jsxx/hmk165NEuwbBR9Bronbgn4CnQDbpM30=;
        b=PdTp+xpsG7YJPitrbqM7SPSA850ncGJ+tNK8CCDMJkjswu4Dv5/F5dZuFtStn3Cp6e
         kDPhqtOvgbHPlRrnYM8mUBAJhveKNf13N5EhQdQd5o5yFKMs752uxiCezZRkXeW+muge
         8Nr1mVk2UsqyGT3c9dkEfihcrSBPedcyB+0KssmKOZo51AKz1heY2tUPaPXkEXMt6ZSa
         RtQrcP+0AcwyILBYXRBeVRrCo0Md0dKXXwFA0/MTOWDKp/CPNkIAW8IlZCgRqKiFuKQr
         M+bbnzTU6nnMy+OcNgrKuSElDGZBQkexirJfspGmL+5p6sA2fnNq/CZWFqYzX8Urz5bb
         PClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021134; x=1691625934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtfYC04jsxx/hmk165NEuwbBR9Bronbgn4CnQDbpM30=;
        b=dNnpfH4uLKoNNewwi8L7WC4GgoDGSatzm1zMKVrE4NRTfJZeLwE8VtmbZsX9L3Y2lQ
         M+iSnPUKg8oKxNCM7YKh9qiphYt+WMzeySSKQA5SaSBN87XDsD8qG185+E+JPtrwnD9X
         iocoXBw1RW6XRjlDNS/QJ5vTa2l87mPvxE4iraWSKvMLw0m+QQzm4wBzGEQTZgl95VbE
         0YbKZy0+05zoNGk9VzkyxsMpGf3IX7N+STbg5gHH1QhvaG6d7tyFBscVJHloiKlsM1QI
         FlauF5/7+7T/BYf2l46nOwhh8zsdpE61n6HeGeOLQp9zf8mqS/qBtqTnDCXvFLjLBgR0
         iYNg==
X-Gm-Message-State: AOJu0YxDvpm6chuESFmAPJsG6nN6EuMzmnXECY9gxYIeVkrxMAijoZoK
        R3koo8/GHQDBEYNZRaOr2KGrgocxf3Y=
X-Google-Smtp-Source: AGHT+IFDcnRjGudQotbkKT0UwYsheCZVBpeQ+quvbMFdVkqz2DAemHJrCowECmkMgfhSG5/xmMCT/wFfbk8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9392:0:b0:d3d:74b6:e082 with SMTP id
 a18-20020a259392000000b00d3d74b6e082mr29538ybm.9.1691021134273; Wed, 02 Aug
 2023 17:05:34 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:05:24 -0700
In-Reply-To: <20230607203519.1570167-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607203519.1570167-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101982757.1829784.5172834389286123693.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: SVM: Clean up LBRv MSRs handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 07 Jun 2023 13:35:16 -0700, Sean Christopherson wrote:
> Eliminate dead KVM_BUG() code in SVM's LBR MSRs virtualization by
> refactoring the code to completely remove any need for a KVM_BUG(), and
> clean up a few others pieces of related code.
> 
> Sean Christopherson (3):
>   KVM: SVM: Fix dead KVM_BUG() code in LBR MSR virtualization
>   KVM: SVM: Clean up handling of LBR virtualization enabled
>   KVM: SVM: Use svm_get_lbr_vmcb() helper to handle writes to DEBUGCTL
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/3] KVM: SVM: Fix dead KVM_BUG() code in LBR MSR virtualization
      https://github.com/kvm-x86/linux/commit/d518f8cc10af
[2/3] KVM: SVM: Clean up handling of LBR virtualization enabled
      https://github.com/kvm-x86/linux/commit/41dfb5f13ed9
[3/3] KVM: SVM: Use svm_get_lbr_vmcb() helper to handle writes to DEBUGCTL
      https://github.com/kvm-x86/linux/commit/a85cd52d7205

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
