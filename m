Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07A97307C5
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjFNTIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjFNTIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:08:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F2B1BE9
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:07:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-65592a7cb54so6618999b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686769679; x=1689361679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4oGXHbJy0nScfl9DUrXr2aiFTxNn0y6vjEBgrD4YHY=;
        b=nOGHX1VJJGIvmuPEYJLThOxBUNYD8p50ORrVKKbBVCFp+RH5oBFXjH+xznFg3oqCa8
         xb8VEcdYAWoX/WXiUXIJi8x/EunCDAJ5WJvYtu55mcNKj25XFU23lbP8VgCAZeApXtPY
         X5/5uXytYr/SprRnkU2euA+CJ1Wy4Ai+PakcLnr9/dF9E7t+tvGez4qYVYdEiAoHs5PN
         +nMR+cQYNfByy8QinHcoI10a0LyvV9twr6lJxXo0xCg/dxjXWHjYA1wUsnYUWW/0m3XC
         H3ksHLjWjc1yYPyaRjVle585qu30bJ7GPuqZrK+KCB6nFeXu1gM17XUjgMiHyAUYS9WQ
         Xv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686769679; x=1689361679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4oGXHbJy0nScfl9DUrXr2aiFTxNn0y6vjEBgrD4YHY=;
        b=OCzKjqV4oZlyVQSOtKnT/OUjYJvRz6KhQD+PgxX2c+hPqW0/zwvsgZLWs3lsEjIg3g
         sBI9NuNKmDlKQ16CxcGJ26UmY0MdPmrrfHTDqCc0IqOyJTVr29qIhJK8HJ7YYpnowblR
         UaOvt9YyHMSB8LL9/aGxTkli0XMeNpCJ3CYU5sDx7PFgSOK94WDI0tWFGbS38bMYxaP/
         PVgMfH1mZSWb5X/LBCJfDBnFIs9DBHNGc8Ot+NDw2I/WxZPcW21/2GHPrVkYUjjwmJnG
         8E3UXmUNSnVjV1Dp0V6yYWDJM88zXF8Z92tF5HqyCbsqtzCdZbNWvXlUMJkXuACpez1a
         EK2A==
X-Gm-Message-State: AC+VfDwAOqZDA/MnEj4GITSt0feHUlA1aYkXz7/lpLNHDL65F6Q3rrKb
        b0uJ13VSvjg12GRTN7uy8OMQ0CsfZxE=
X-Google-Smtp-Source: ACHHUZ51wQ/2Dxa+sgAhbPBB11TqxtOBn8DzwfspQDh9sz2PfijpF6oDOmxPzuT9ZPQOc58r5fog9k55rDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8ca:b0:665:bd58:c93e with SMTP id
 s10-20020a056a0008ca00b00665bd58c93emr798632pfu.1.1686769678715; Wed, 14 Jun
 2023 12:07:58 -0700 (PDT)
Date:   Wed, 14 Jun 2023 12:07:57 -0700
In-Reply-To: <abf509a2-ebfd-7b5f-4f7a-fdd4ef60c1de@amazon.com>
Mime-Version: 1.0
References: <20230602005859.784190-1-seanjc@google.com> <168667299355.1927151.1998349801097712999.b4-ty@google.com>
 <abf509a2-ebfd-7b5f-4f7a-fdd4ef60c1de@amazon.com>
Message-ID: <ZIoQDbte/uAiit9N@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Luiz Capitulino <luizcap@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023, Luiz Capitulino wrote:
> 
> 
> On 2023-06-13 19:21, Sean Christopherson wrote:
> 
> > 
> > 
> > 
> > On Thu, 01 Jun 2023 17:58:59 -0700, Sean Christopherson wrote:
> > > Add a "never" option to the nx_huge_pages module param to allow userspace
> > > to do a one-way hard disabling of the mitigation, and don't create the
> > > per-VM recovery threads when the mitigation is hard disabled.  Letting
> > > userspace pinky swear that userspace doesn't want to enable NX mitigation
> > > (without reloading KVM) allows certain use cases to avoid the latency
> > > problems associated with spawning a kthread for each VM.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 mmu.  I kept the default as "auto" for now, as that can go on
> > top and I don't want to introduce that change this late in the cycle.  If no one
> > beats me to the punch (hint, hint ;-) ), I'll post a patch to make "never" the
> > default for unaffected hosts so that we can discuss/consider that change for 6.6.
> 
> Thanks Sean, I agree with the plan. I could give a try on the patch if you'd like.

Yes please, thanks!
