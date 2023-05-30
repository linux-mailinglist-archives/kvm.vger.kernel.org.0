Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAA715C10
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 12:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjE3KnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 06:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjE3KnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 06:43:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C48EF0;
        Tue, 30 May 2023 03:42:58 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3094910b150so4318795f8f.0;
        Tue, 30 May 2023 03:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685443377; x=1688035377;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EMngjdaC1cmXnO92t13ixHPmzh14q713TwRNHCOvkO4=;
        b=n/tZIfLkvAmhBcu/GtiLcNnBZ80AeN4YOTzUd0gO/GDgxbTDIqvPPTQ4fUNWvBwEiW
         VB7LXyEzBVbeqDhK/nDHSJnXsw8lcco+qlByuWGEH6vHR3Xjio+JBWK61BYhrweprOaM
         BrZuB7aB3gOMu5vzTitg6hxx20UQLNIjG7pOHuXIxt8uRkeu002r6xWI+pZQNqySRyE/
         2R3RQ5O08DcvL2kS/Faz0qoKHmCpDH2NpF7281gQbr7zupVdyopbLBvHZjz3D84X/q8n
         JBvFfIAFr1QRjSGlyas0VSwul3/T6E32+A5D6WkJEpVD0hOY72FQQ8QAN6LH5gRz/K2b
         Q5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685443377; x=1688035377;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EMngjdaC1cmXnO92t13ixHPmzh14q713TwRNHCOvkO4=;
        b=TZIkNZMJe/W3pe3qAH6TgzNKoD9PQ8KsB7FYCjpUZMT7u3fJ5AEIyRUUKvrhzbsmJU
         AGxONMjJrhkiTgvmWJZtnM4TwB68KvMOXbmyS/8U4mvEGvR5dLBeNNBhVJi13Du7o+xz
         F5xygsxUpBtgQ9n3cat66sNeSclFBAT2kNclWbPaRyprHEWieoMIBzaBFpDL7KCHlZEb
         Ie3FDETIBjZMWTZhgjPlY3EzGQlziqJ1DqPFtAQc6Z1urzE6u4OK85PPManoDtDmAXnh
         WNMRi0sUvmnKzi+3qo5P29O079w8yrnCoxaWYXXSpJY4uVdBnzl/9i0L1VNLcicQJkYj
         kh5g==
X-Gm-Message-State: AC+VfDz1VbF+bqmIw2XEJ2mCTLxTxZlk9DlgsSWvsI9GrwtHFlAUyx5b
        47l6/Ajmj6GMQk7qvEkMRJE2vW0Okpgr3y2zLddXETTXPubQtA==
X-Google-Smtp-Source: ACHHUZ5H1Ssx816UXvIgGlTH4ABSGNqs7PdJbj/3LYVn0/wuOcXrJa/wiTRuIumAjBJ7bKuZhbA7KedJHrMOG7hRbzM=
X-Received: by 2002:a5d:42cd:0:b0:30a:ebe2:5e44 with SMTP id
 t13-20020a5d42cd000000b0030aebe25e44mr1131518wrr.67.1685443376733; Tue, 30
 May 2023 03:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
 <ZHNMsmpo2LWjnw1A@debian.me>
In-Reply-To: <ZHNMsmpo2LWjnw1A@debian.me>
From:   Fabio Coatti <fabio.coatti@gmail.com>
Date:   Tue, 30 May 2023 12:42:45 +0200
Message-ID: <CADpTngWiXNh1wAFM_EYGm-Coa8nv61Tu=3TG+Z2dVCojp2K1yg@mail.gmail.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        kvm@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Il giorno dom 28 mag 2023 alle ore 14:44 Bagas Sanjaya
<bagasdotme@gmail.com> ha scritto:

>
> Thanks for the regression report. I'm adding it to regzbot:
>
> #regzbot ^introduced: v6.3.1..v6.3.2
> #regzbot title: WARNING trace at kvm_nx_huge_page_recovery_worker when opening a new tab in Chrome

Out of curiosity, I recompiled 6.3.4 after reverting the following
commit mentioned in 6.3.2 changelog:

commit 2ec1fe292d6edb3bd112f900692d9ef292b1fa8b
Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Apr 26 15:03:23 2023 -0700
KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
commit edbdb43fc96b11b3bfa531be306a1993d9fe89ec upstream.

And the WARN message no longer appears on my host kernel logs, at
least so far :)

>
> Fabio, can you also check the mainline (on guest)?

Not sure to understand, you mean 6.4-rcX? I can do that, sure, but why
on guest? The WARN appears on host logs, the one with 6.3.4 kernel.
Guest is a standard ubuntu 22.04, currently with 5.19.0-42-generic
(ubuntu) kernel


-- 
Fabio
