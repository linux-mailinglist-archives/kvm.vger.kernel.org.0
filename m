Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F14267F2A5
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjA1AHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjA1AHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:07:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17BE8624F
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:07:22 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u15-20020a170902a60f00b00194d7d89168so3583461plq.10
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHsr2oJUItSi3vqA6tkcnF07ysr7z0zXfg4n2h1yTQE=;
        b=J1SQgyRtJK/Zu2QQvkc7mBgYGUZiPn1Bz8v0O2XcSB0lKHhi3LH3gZPTwN9nKQ/EWc
         cLS2uKCN+6G4VUH3++bNzvCPwhsLkIVT940ggF2W/alKMiAu+HK9S9DY637ZAbUPGhLS
         eyfyJ6ZtR1hbIJo4E+NwzZpsx4zz8FIoDofnMZSk0Kmb6/v902SXxTAYs+U0cvS4Fx4r
         YYDcTfbAsz2i51AWU4rgE2hs8KvEZs7a915gH7DybFRmprvfbeydswuWjiMKijDXS/fq
         hl/rZxwjQTUFyfPwrOlim7VK94WV/F2XxbjEaHy2ekTG9oV3gSypm9HLCZrEHYJezsfN
         RBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHsr2oJUItSi3vqA6tkcnF07ysr7z0zXfg4n2h1yTQE=;
        b=CZrYkIS1OaFIU6qjHaj6kKGsCi3hXlaXe9Yg1Z4GVCAtu/5CC0yv7lxalo0Pt5QyYo
         f3OR+pfBKjuP1KoYrK3gDU+DgGlhF/UWXLBsTAum2CapbRc02Di/5o35lxw5z2FGhzU7
         wgZRxXUgnugFGaEGEAH0akok2Xm4myZQMGfmQaXbmGFN5qd4GuXosuqLGtVhNKRgt/am
         lYf7uSZysdjsCo009qgUd4CxD+GgjuCDjzAtQGA0whqstnHnr6TWKhv4hjDW0J1paGbv
         sSPHMXVQ0ERvuAfvzy6hjvHiYJ+SWHnvO3bd720Wrv6SIIgZZ6HVgDC9oqHwhjhorIqM
         DR5g==
X-Gm-Message-State: AFqh2kqvhz2OBdKwgKkHK3WSCdqxsY8ifKiNYOx9wjXe1F3qeHQm3/yN
        CAYtCuKLseAgMY61GIvDlKwoZluAFvA=
X-Google-Smtp-Source: AMrXdXuvu1sGU1vYAwHwXwDXKHxOUXsgegJAQwa8tvXvso1A8LdaRdJsA6zWArCPjuoYm/jCvqWVi0rND9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b217:b0:194:7c22:1885 with SMTP id
 t23-20020a170902b21700b001947c221885mr4493000plr.26.1674864442136; Fri, 27
 Jan 2023 16:07:22 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:07:16 +0000
In-Reply-To: <20221205122048.16023-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20221205122048.16023-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167477056207.187359.3952314052374339122.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Drop event_type and rename "struct kvm_event_hw_type_mapping"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 05 Dec 2022 20:20:48 +0800, Like Xu wrote:
> After commit ("02791a5c362b KVM: x86/pmu: Use PERF_TYPE_RAW
> to merge reprogram_{gp,fixed}counter()"), vPMU starts to directly
> use the hardware event eventsel and unit_mask to reprogram perf_event,
> and the event_type field in the "struct kvm_event_hw_type_mapping"
> is simply no longer being used.
> 
> After discarding this field, the name of the structure also lost
> its mapping semantics, renaming it "struct kvm_pmu_hw_event" and
> reorganizing the comments to continue to help newcomers.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[1/1] KVM: x86/pmu: Drop event_type and rename "struct kvm_event_hw_type_mapping"
      https://github.com/kvm-x86/linux/commit/4996f87f9385

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
