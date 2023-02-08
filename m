Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBACF68E5D8
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 03:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBHCJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 21:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBHCJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 21:09:29 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C99F36FD8
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 18:09:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y8-20020a170902b48800b00192a600df83so9055478plr.15
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 18:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9R6i368bX1p849gE1Usu7WAjgq4Ub0gfVeMtWfRcjzA=;
        b=Hap38k/vCDD6jEcVV65WsU2C9WTQMvVFijFta+m1gB4pmOkv+l+rnvcT7CYDEF6B8q
         EwyF1c8z68gIA2tAs0HrDgMq+Il3oDz+O6/znlZQ9qwt9ajngi3VrMK8sLFJd989BoDb
         rtfgewlSADwP6Ou1P3GAoC8LPY/I1BZL85heCRNhpAIwiNGJ0zS/XooG2Dl9sF+3bxwG
         15po6xWjLL6gToM1Jd5LnMzrt6ag8B75zyTqJdtsj0qXFjxDCPYbYnM/s/7/TmFgQml5
         CCdxF/Co59Di/O5WjGR0nH2JFMD+AluhM1Wjz6Y90LJDjr9j1knDcthtsrnQkpXz1o0D
         NnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9R6i368bX1p849gE1Usu7WAjgq4Ub0gfVeMtWfRcjzA=;
        b=LjtLoTPac36PPbGIgZRDQf6R/42Xdabu/wmaRydIdaiP1xIUG73UL1H4wAxECxogJK
         gNjo+xpq6flveiPM2t9XiQWGPhCNDWXsE+lIYHpj7jIXNlblTXfrIXwKG40XMa9sQTwN
         ApROOcCSNSHdCJX1bCjRBlmhtSkrYazl4vvVfV+xBnSgTCNwAelmrSwCgKMBS/N63y2a
         Tw/1jhYNs5jNkkGsKBZpsNY01zgzM5xGHjZfJQNXLkKdls6m0UCuhWEd1qsIOfcOBDns
         FO06ud+RlpBB1rJsWMMONKsAEgQyagp7jwo2kCqu0Y+LK07y2M/tWZnVtmDqEeR/hPSM
         hweA==
X-Gm-Message-State: AO0yUKUZqyYY1UKT8lOzztbAZP+omH2JSxIyREW7RItLC+dF1U8Js0ud
        jt5VuxJqnyRgoMF1A6OKjvRfm3afbkE=
X-Google-Smtp-Source: AK7set9qjHoy/TeNBxOlxDL95PZFcs98K7Jgu7lq98HYUboHtbNzlG9/3n6cSa+Anl0sMt+i0cNJqQst9AU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b88:b0:199:1458:6c67 with SMTP id
 p8-20020a1709026b8800b0019914586c67mr1459889plk.28.1675822159753; Tue, 07 Feb
 2023 18:09:19 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:07:28 +0000
In-Reply-To: <20230206202430.1898057-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230206202430.1898057-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167582135973.455074.10130862673762989635.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Clean up misnomers in xen_shinfo_test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, dwmw@amazon.co.uk
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 06 Feb 2023 21:24:30 +0100, Michal Luczaj wrote:
> As discussed[*], relabel the poorly named structs to align with the
> current KVM nomenclature.
> 
> Old names are a leftover from before commit 52491a38b2c2 ("KVM:
> Initialize gfn_to_pfn_cache locks in dedicated helper"), which i.a.
> introduced kvm_gpc_init() and renamed kvm_gfn_to_pfn_cache_init()/
> _destroy() to kvm_gpc_activate()/_deactivate(). Partly in an effort
> to avoid implying that the cache really is destroyed/freed.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Clean up misnomers in xen_shinfo_test
      https://github.com/kvm-x86/linux/commit/5c483f92ea7c

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
