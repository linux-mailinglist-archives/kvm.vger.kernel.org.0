Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6876DBF8
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjHCAGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjHCAG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:06:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF14202
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:05:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb97d27d6so3274705ad.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021147; x=1691625947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GlCUVKX6yHmT83rCLHSwZjnxDTnktIg6Wv8CEdATqYU=;
        b=UgsX2266duslCIx7H3KbGtKnmIzKzMCIYtbXnwjfD/gAa8Y796aUmREyFBNdZMULn9
         1JqfIWtERU07Kniq8B8S9AbP61PJu+BmkkaUor4mkzQNIlqiGLjYgOCgTNf2sIJUptr0
         jNiX9Q+IKHjC/zKCYh+RwGjsDBd20DR5IRj/38vx1X79kjC8DgxiV6EJGtWEEPMCNcBL
         cdD+uHJmvOao17hnMdAQJeGB/ZXjhuBlmLiNR4rx8Gh29qmiDzVrbd5/cI/U8lkQoqel
         4RXwosqn/ZhkYRhAIi8NjoPL7bSgeOkAN0qJTlKpWSW9V4oYuJcqIjiDf7CC/b484HRL
         xsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021147; x=1691625947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlCUVKX6yHmT83rCLHSwZjnxDTnktIg6Wv8CEdATqYU=;
        b=gpZ5l+sHZm+WHAEjThxUpV8ieq+wfKX4SZTVyb/ngmSv9Sw3IIi+tChyaLxaVO7xbm
         uM5SMKuIfmdB4hFxv/zan5oOZi5YzkgSWys2GQy3F0/Sfjz5c1lAsqblGktuaXG6bjdZ
         95v/fxGZHeud0FCdLQ3XizXdMLZntUSiZgws3LPs9gRNg3z79KObjhR8rbc12Y7uGEBy
         zxQ3MvNU2VzE4ZlmHBgfYvrC4EtEtznTuyqivk0y62YXifyjXi9nLN/6JFVXH9ZL4FiP
         dZEG6penG0S0wOgaHojQEh7wDkzhlgevPecdMiEDovyGyFmor7yIjzpRrI8Eg57UcTQY
         llwA==
X-Gm-Message-State: ABy/qLaiYWWG67t+t3R7oc70yO0voUIFB8YO+1KclpXA3r3trcZQAxcH
        a8ASL1kcb/MDNY5i+aIWAtD78Z7V8JU=
X-Google-Smtp-Source: APBJJlEXUzqIMppSTa6zA2UipB6qgQTTTzx9gWZ46EnoosI8YXxuzK1t/AWOOzBrtqw92VXwvZMD9O5+quw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea09:b0:1bc:2547:b184 with SMTP id
 s9-20020a170902ea0900b001bc2547b184mr59465plg.1.1691021147078; Wed, 02 Aug
 2023 17:05:47 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:05:42 -0700
In-Reply-To: <20230607010206.1425277-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101994485.1830375.1891135489217943647.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86/pmu: Clean up arch/hw event handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

On Tue, 06 Jun 2023 18:02:02 -0700, Sean Christopherson wrote:
> Clean up KVM's handling of arch/hw events, and the related fixed counter
> usage.  KVM has far too many open coded magic numbers, and kludgy code
> that stems from the magic numbers.
> 
> Sean Christopherson (4):
>   KVM: x86/pmu: Use enums instead of hardcoded magic for arch event
>     indices
>   KVM: x86/pmu: Simplify intel_hw_event_available()
>   KVM: x86/pmu: Require nr fixed_pmc_events to match nr max fixed
>     counters
>   KVM: x86/pmu: Move .hw_event_available() check out of PMC filter
>     helper
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[1/4] KVM: x86/pmu: Use enums instead of hardcoded magic for arch event indices
      https://github.com/kvm-x86/linux/commit/0033fa354916
[2/4] KVM: x86/pmu: Simplify intel_hw_event_available()
      https://github.com/kvm-x86/linux/commit/bc9658999b3e
[3/4] KVM: x86/pmu: Require nr fixed_pmc_events to match nr max fixed counters
      https://github.com/kvm-x86/linux/commit/6d88d0ee5de1
[4/4] KVM: x86/pmu: Move .hw_event_available() check out of PMC filter helper
      https://github.com/kvm-x86/linux/commit/6de2ccc16968

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
