Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D80788F10
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjHYTCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjHYTCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 15:02:02 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9082126
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59263889eacso18969327b3.3
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692990120; x=1693594920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RyMCkowoFoh51PbgSYPZvcUalHfUnDZNt71FcGUibhg=;
        b=Ti6XzwoLejVQYFu/bmE0VAxSEPggzkpXvx2hk6po+ngZVSPkFmq/T6OsQklaUZuOcG
         jEB+eObBgtW3JD0Las95bTGS6UhP9dxNNfr6ecYeMk5kpW7915QwOO35+CxC5SzAf3Vm
         SzjhqgnUv0UBZiAd/83HG/LzNy04HCV409Yqx+K80v1egVU5Lcalxb+PGNc3g2R2rID6
         De2A37wDS6vRTMTm/XPcLCVzTXA3GvC0e3zMhvtDBiJmwpjepFwUVpXEAYkg2lQLsbA7
         VLmVDD+yoMZEXeQ9Uwi7G9jU6V6pq5HZEgvK+Q8y9D881Gkv00U5+FCprOSeRzgAuufy
         haaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692990120; x=1693594920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyMCkowoFoh51PbgSYPZvcUalHfUnDZNt71FcGUibhg=;
        b=SNPcjh1lbLe0okMXUsIDwR7T4q0BZXsnMHogoYy+JBnyxTWBEeMO0EIR0iE7SgBKdl
         /PRC4EI3J7SA130YV/Iohp0V2qu5agR6LPRBkZBW8wplLxHUuvrucrcDRSoNRw2ydKCb
         qzM5XXETIOKXTxbnvrLC8JQ/pGYY9PjQ0Q0rBJaBh2uhsB6QJpP1NZTpV3GbqMKzvtjX
         GaitNPdyhXb8H2Uf9o6auqzQP1+BDrHElB8KQOVeIc1nW96XHSZOrDntX45AubJCatCR
         gkslcZ205GV2aXbAj3vK48MNSd37qJ4kYSSUZGS+BmbC3hMh0+aZtNjFuMt3+S4K3gZ7
         YVmw==
X-Gm-Message-State: AOJu0YxalHYOLM4RjTYWGj2sFz2LoQRexmon0BPF7qSrsSCu5KOZd1/v
        nObo4UL0FNWvx95vk2enhlTnJ13kENA=
X-Google-Smtp-Source: AGHT+IHoTvYhYvqWYMjTqQ9ls9vIUTjx6O6S3MWgMIr+KhXvzw3l4ofMqbvHrSViFNofaKfrhdWH2ckt1jE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af4d:0:b0:586:896e:58b1 with SMTP id
 x13-20020a81af4d000000b00586896e58b1mr491511ywj.0.1692990120101; Fri, 25 Aug
 2023 12:02:00 -0700 (PDT)
Date:   Fri, 25 Aug 2023 12:01:43 -0700
In-Reply-To: <20230817234114.1420092-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230817234114.1420092-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <169297947911.2871633.8687913256656277100.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Update MAINTAINTERS to include selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Aug 2023 16:41:14 -0700, Sean Christopherson wrote:
> Give KVM x86 the same treatment as all other KVM architectures, and
> officially take ownership of x86 specific KVM selftests (changes have
> been routed through kvm and/or kvm-x86 for quite some time).
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: x86: Update MAINTAINTERS to include selftests
      https://github.com/kvm-x86/linux/commit/c92b922a8c52

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
