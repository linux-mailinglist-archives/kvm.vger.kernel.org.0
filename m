Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E13A6C8727
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjCXU73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjCXU71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:59:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEC419C5D
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:59:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ip12-20020a17090b314c00b0023f7dfb7d7fso934665pjb.6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679691562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/wfEpo5f5kAfQ9Hdkj7UPSkqYUR2PzHtc4Ov0QKsgjY=;
        b=VlNJxFJ4zcwTRL3ROh0NjLc7Ggh1aIRu8ujdGALp6iBzVYn/rAPpVy0b15WcD5HBDK
         eC1/exh0aNZZq0uvM9ap95WAPTTKAHkO1aAS45Lfmc6Op8rAbX7T60s6gAwmmWzBcTR7
         8ZQv24o5Trp/fgu1OUqioL+CVIY53+gysyFsZ2CmAkljgKzHRYMKeXpHJ4GrdExgs4DR
         T3P9Iombc0Pv9V8Z4RNaF/9r0kM7omSitIoefJUU90F6Wjv1Lx9M/QiLCQd6mToGWqOV
         S/kksN3XmylHOTzTUDfyTW+Nxf/zEXYwkKQDpnHMudHaFwuklAbeUKhp+vcQGnCfLwgI
         RG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679691562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/wfEpo5f5kAfQ9Hdkj7UPSkqYUR2PzHtc4Ov0QKsgjY=;
        b=4AauXjmWe58I6RvQmuymEtyXdW/D5UqNC1jfq1zBJVq3RYImw6e8lEZ7d2swDGRzqH
         9sTcDp3iw0H3i8jJgyJY2rpB4fkcIxPKCMDJxq+XDDfYaS+kFI620XhTDKITe4T5UBmc
         r61bIarstl3fFR32MgUmGUut3o8x1RBxAyEPFFua+sKquK5A7EQdYw6fNf/JeAXVS10v
         YbMcOcSiQOUJea7RVgWQ3+QIROhF5Iro+MuWzjG4eKV9khzlfZmXxv7rRKn2pRGWj5H1
         2y4ozlQ5WnorEu0A2vgbA7rNuaXvKmVsJHp8i9bdRuurLr+NjxqDaph9ZgOmhSSgy0Yv
         4kjQ==
X-Gm-Message-State: AAQBX9dQ4IXJZJ/V6kbMw5afpSWydlI9d//RBmU/4gFx2PVu4pfncs7q
        mjWenlJ2Cq+WnRwEXIZEMW67N2eRCp0=
X-Google-Smtp-Source: AKy350ZfKKHxq8j6AEi0IBVVpk3Ikw1f0Uaj0olPDDuVsMLhagm/rB2pq+hzWTSujtrhUMWXIEbZdI5pAV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:eb09:b0:1a1:ffc6:de9b with SMTP id
 l9-20020a170902eb0900b001a1ffc6de9bmr1365950plb.6.1679691562679; Fri, 24 Mar
 2023 13:59:22 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:58:50 -0700
In-Reply-To: <20230214084920.59787-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214084920.59787-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167969136143.2756283.9405259236021680651.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Report enable_pmu module value when
 test is skipped
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Feb 2023 16:49:18 +0800, Like Xu wrote:
> Adequate info can help developers quickly distinguish whether the cause
> is a code flaw or a platform limitation when a test fails or is skipped,
> and this minor patch-set is doing a little work in that direction.
> 
> Base: kvm-x86/next
> 
> Like Xu (2):
>   KVM: selftests: Add a helper to read kvm boolean module parameters
>   KVM: selftests: Report enable_pmu module value when test is skipped
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Add a helper to read kvm boolean module parameters
      https://github.com/kvm-x86/linux/commit/d14d9139c023
[2/2] KVM: selftests: Report enable_pmu module value when test is skipped
      https://github.com/kvm-x86/linux/commit/6cf332e8eca6

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
