Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A090616C6C
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKBSgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiKBSgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:36:41 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFBE303FA
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:35:52 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id b5so16987842pgb.6
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LufEymnjB/6dUVWIe7LauF7rJYuUgeUD8pb8Z6TK8x4=;
        b=ERkLmSYyPtkzzmluwaoeMJQi8ioAPCGIJPZ48Npgzdzslsow/Fa1Ud/aAB0r7f6m13
         tpsp10QvI5IQkOfxVKBZF6WBJyL/vzFHZUwRRd0htDDiAzPxH/n8wpeW8sfOnOhWlNgd
         GyA2N7BwjLZl36PCX/qW8jtOTBpidOpSTEoTN6wg9YsTFuIWSjRYaajf+QV5/7EF2j/k
         3oIumzwfGJA8C8K4YRJP73+MTR+uso7MnCLUohzVumpa0SkS/JVzYhXXHNf5dx2IzwRe
         Yf06dHh5cN14lvaf3iUlq/E7bs3PyUc6G2GsSd5wEdHj3mf7mhHgijiYgNLbHYoKYpUF
         CeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LufEymnjB/6dUVWIe7LauF7rJYuUgeUD8pb8Z6TK8x4=;
        b=xlFHyMooJ4T8vNjsyjMUxZVXJNtdFNWADoZJA9cCGvtqNFNNtIeM4s4YUsUBROPyiS
         Gct6+YsOtTRqsh+ZGMsUnHhAjPXf0evEvf68kgm45kLXYwX4H4LwdlHJ4pzZzuGQp6ER
         iDigJQfcm5kDn/X/k1LXue1s/nJLzsdJm8b6yS/K13ZYkX9DBGpeoIFM8sMqW7c2x1Dy
         APW9osjx6AH6mH54RDLlTwseSfZ9cExYWPvDaFOesNtXNsdSK4qN3MquXi7DmF4qVN0/
         Acefye9XfUUi/8SnXPIUX1oatMVk9AdFC0sKPVlD7yZQwOM91oPAzFPQi3ixln8zunHs
         PAwA==
X-Gm-Message-State: ACrzQf3sj9I6QvBFx7zhdXKgQxI9N/TxW6VQw8calGAzzvwDFaBkKyj7
        b4RapgsS6+7+fN58351JiCkZFg==
X-Google-Smtp-Source: AMsMyM4gXYNQEXNjjqDrghpgg9zTOF1npqfGx7vs/T3f0M9YMdkl/2SwJWrf4BF8a4zd74APThNvdg==
X-Received: by 2002:a63:d24b:0:b0:454:defd:db65 with SMTP id t11-20020a63d24b000000b00454defddb65mr22396636pgi.203.1667414152018;
        Wed, 02 Nov 2022 11:35:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79ac5000000b0056bdb5197f4sm8794554pfp.35.2022.11.02.11.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 11:35:51 -0700 (PDT)
Date:   Wed, 2 Nov 2022 18:35:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 00/24] x86/pmu: Test case optimization,
 fixes and additions
Message-ID: <Y2K4hHmK010F3vfO@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Like Xu wrote:
> The patch set includes all the changes on my side (SPR PEBS and AMD
> PerfMonV2 are included, except for Arch lbr), which helps to keep the
> review time focused. 
> 
> There are no major changes in the test logic. A considerable number of
> helpers have been added to lib/x86/pmu.[c,h], which really helps the
> readability of the code, while hiding some hardware differentiation details.
> 
> These are divided into three parts, the first part (01 - 08) is bug fixing,
> the second part (09 - 18) is code refactoring, and the third part is the
> addition of new test cases. It may also be good to split up and merge
> in sequence. They get passed on AMD Zen3/4, Intel ICX/SPR machines.

Quite a few comments, some which result in a fair bit of fallout, e.g. avoiding
the global cpuid_10, tabs. vs. spaces, etc...  I've made all the changes locally
and have a few additional cleanup patches.  I'll post a v5 once testing looks ok,
hopefully this week.
