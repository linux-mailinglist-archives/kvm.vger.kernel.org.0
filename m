Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10497110D6
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 18:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbjEYQXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbjEYQXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 12:23:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F5C10B
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 09:23:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51b743d592dso838507a12.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 09:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685031785; x=1687623785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HdBiYHXb0t/eYfGc/stu36RyqTGN6i7PmYRLl38sM4=;
        b=Ms1EfGgkWfjHyAEkYKEt1EK1c0RFGrAyO7YlB5VADfKnqvkE/3Q90TA52bwGi+C54/
         4z+1IXDYFa69QOgk9+iEezTtPmTRTiYRMdTcWoaEhiekfJZ5qanq/KVZ93a35S65Jy1j
         WpqPDkqSkNnqysAT/nWNmhFVZwb1W5f3wWjc82SXAd7yE53jFxhChegmF2f1mZSgvdYT
         2PjlMucBTIcEebTxQCHwZcOH/9IqHQZmKPDhGcGs2h8YJtbrrgclLGN8ttUXYsVvTJky
         PZgij3I8YJ2FZ/t6PC1NhWFH/yMM80DI+lHqqpwW/F0KchdCmxRw0s/1euxOMEabHbgj
         fvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685031785; x=1687623785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HdBiYHXb0t/eYfGc/stu36RyqTGN6i7PmYRLl38sM4=;
        b=dQ1ZVkOSJzYOAClJqvGUywmTMsLHQkeMLjhXuvlwAMUS5o6G/U2V9/5iytl0dVR02r
         FNSbeE4ybJCksUdPpVYbThc2Fkip2SBiIpKiPU+Y50+DDhCaEq4NjDCQsabsQS2BwcHM
         SVkcUckYFy8Zru11EIOWSxvlV3T0+iGumonuvqimTg35YjB1jafqdc8gyKxrleYe1vbQ
         1JlTTm4oI8e5m86EgNWAC32HBGcQXxfcZhSsxS6Z9ycWhPs7Z1kERO7kJk8GlY/wau5J
         sMJIcHVatF3T0jtftsfyg57DTyhubCNSP9WU+WrRqSsLoWOjiOxV3F4ukHJDG944fkgk
         343Q==
X-Gm-Message-State: AC+VfDwWGMVgKumu0RGgN+Rwmao+5ILFym7/vUvax2WJ/SvF1iBXD1p2
        3VSbnpBgWQDtLRtmIs4nmTKfAC1359E=
X-Google-Smtp-Source: ACHHUZ4eMNRNmPGVNI0d/g62J6qYg9y69eF3HSc+XqALVPDfQutlySlqNuJtdiVOrOZz4FeES2slvW+AmvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e847:0:b0:524:fba4:fd51 with SMTP id
 a7-20020a63e847000000b00524fba4fd51mr741353pgk.3.1685031785184; Thu, 25 May
 2023 09:23:05 -0700 (PDT)
Date:   Thu, 25 May 2023 09:23:03 -0700
In-Reply-To: <20230420104622.12504-2-ljrcore@126.com>
Mime-Version: 1.0
References: <20230420104622.12504-1-ljrcore@126.com> <20230420104622.12504-2-ljrcore@126.com>
Message-ID: <ZG+LZ4rATc8elt38@google.com>
Subject: Re: [PATCH v2 1/7] KVM: selftests: Replace int with uint32_t for nevents
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Defined as type __u32, the nevents field in kvm_pmu_event_filter
> can only accept positive values within a specific range. Therefore,
> replacing int with uint32_t for nevents ensures consistency and
> readability in the code.

Not really.  It fixes one type of inconsistency that is fairly common (userspace
passing an integer count to the kernel), and replaces it with a different type
of inconsistency (signed iterator comparing against an unsigned count).  There's
already one of those in remove_event(), but I'd rather not create more.

Passing an unsigned int to track what *should* be a small-ish, postive integer
can also make it more difficult to detect bugs, e.g. assertions like this won't
work:

	TEST_ASSERT(nevents >= 0);

If this code were being written from scratch then I wouldn't object to using
uint32_t everywhere, but I don't see the point of trying to retroactively change
the code.
