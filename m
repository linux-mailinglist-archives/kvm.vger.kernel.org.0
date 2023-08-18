Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E10780295
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356616AbjHRAM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356703AbjHRAMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:12:45 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E40C3C19
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:12:11 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-565aee6e925so549333a12.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317513; x=1692922313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPl4LNQHUuYPBKoWp14fjFNSu32aPPLiDSlmcfPKJ8A=;
        b=JznTqMtEzmQUpvzxAeOJ+URNBx980kBQ4vc0LdnKrjEc19VWnJiCU38eui4i6TArjS
         7ZhgZVYQjvIo52Mz7VK6tOFo5eqohOkOnmGFLoCz750X0rviRMFw3NzdLqGW8e2XYT+9
         pxoMk7qxmoPHcu9LHZC+7h2nB3BKFGwRcH1NmPLy9NTLqrD8Lw3sGMzP6JCXZrgKC47o
         wyNPfyls2X3+R2pu7QtVAP4eacvazkrk86BCCA9yzNgx7sA8Yapqf2gcn96vNbyNJYdh
         BEL3EbSmJfgchwlGeEUasfi7a9N3OhgtCZrfH0vS7cO8d0FrOK9jRFG07KWdbB3m062A
         2JZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317513; x=1692922313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPl4LNQHUuYPBKoWp14fjFNSu32aPPLiDSlmcfPKJ8A=;
        b=hPzaDi6AKc4pC+NQFVffCNc4QDFFVxI9prToZ6pVP52M4Mlbcczs+imXjlxTmW5L93
         nhVJhEDTGhIXv045TnNRaH6hj+Vit1IHPHM6vrQg2IT86fCgWjkIXuqq7Lig0v2oHfwE
         01m2YrsKwr+z5MZroMLZ4th82F4sZu8kvZOs3V0m+4lyoAlEtis779GeNEGeROlEorLg
         zWJlp+12LqQQzILdNAizb4REAt4PZlq6DT9N5xSTN4E6LvhnN3fDL7PbVW2Qn5oN9ijF
         O3eoOSUVOYFiJ/v4rgEyf4KDsEVeGBovoBbqAwEZAyrrtyf4tIs14FkR4aLVuiZAfNQs
         t4mw==
X-Gm-Message-State: AOJu0YwQM1AWtKOWsrG2vZKKZRqOqX6shJWB5lHo+ZAok8iWzbpDFKMR
        yuF6xGMXoYhgvmSuPkPPMusJZOr4pso=
X-Google-Smtp-Source: AGHT+IEUbEaPpMUd9ploMFkNUzOB2RfG+JVpgWbB4ru411GZmnjNq0FGbZ+un+mRaarwm34FYjVP3o8fKJ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:340d:0:b0:564:aeb6:c383 with SMTP id
 b13-20020a63340d000000b00564aeb6c383mr149033pga.1.1692317513383; Thu, 17 Aug
 2023 17:11:53 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:09:27 -0700
In-Reply-To: <20230817002631.2885-1-zeming@nfschina.com>
Mime-Version: 1.0
References: <20230817002631.2885-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229733356.1239924.3834338159427286812.b4-ty@google.com>
Subject: Re: [PATCH] x86: kvm: x86: Remove unnecessary initial values of variables
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, Li zeming <zeming@nfschina.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, 17 Aug 2023 08:26:31 +0800, Li zeming wrote:
> bitmap and khz is assigned first, so it does not need to initialize the
> assignment.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] x86: kvm: x86: Remove unnecessary initial values of variables
      https://github.com/kvm-x86/linux/commit/392a53246257

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
