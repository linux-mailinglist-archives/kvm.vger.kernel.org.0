Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ACD76D943
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 23:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjHBVMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 17:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjHBVME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 17:12:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F026AB
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 14:12:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d27ac992539so217006276.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 14:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691010722; x=1691615522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0p0yEIzRim0dAJzv4cvo4xUxAql8N+5yPd28VmvQmM=;
        b=tA6hk6rt/sZ0gzS/QtHZmiDhiz/ozOMiZBbFHARXWovhe8S6odoIIL0oEBFsPnN+D3
         0RRiFn+MpP1A2sjDbE5oFaSpZkTh5mNOJi+Gi2Ok5dAj4H1L/zCyOlPZE+KEy+0L/G37
         YQhyqBPmUK2Gb//rBWUl1zPBgVGonoYS4ZtMK3jz/Es32zck6NsYH7iGTkd2d14k9zHi
         xHsAnQE2/liZXfqrQmilvfZL/UqfBKA5QS6xhSz0pEhZJMGUACzwDOWlhlpU5ip8ef0T
         F+s37InE/MwwI7JLCausTqlMtLD1eb9oKcRVNvTV4pojV1upGgPWNWMjRp+CeGY79e1L
         FoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691010722; x=1691615522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0p0yEIzRim0dAJzv4cvo4xUxAql8N+5yPd28VmvQmM=;
        b=D7WAlZcwkE7TNRsWUpF4mKBWIEHCdeES0kSs1HvAChu3yBtPi+tyS4yUAoA4zOCyLs
         z97SFKXWztFvGiBlbPBwIJMBI+72nlNBe6+zY68xg/EFb0JtWK+DtJ60P+rPuR28I8Au
         cU1v93ygb6n0INdto92/pxiMZ2UFEAt1iCQaoUmsKPCZrG43tnFRUomC4YR7B9ztupls
         UzS7aylimHgoQtXI+yHc7wXUut0CzQXg2mWNw3xTXvATDA6xXXMbuxMp887TFjHUHtlP
         GH7AqRJqLxGrEXzv4nihyY7NZzBlVCB//S05zMM8l9oWS5Zj75K6U5HmuTkUXAdAVatk
         z+1g==
X-Gm-Message-State: ABy/qLY/VH7WPQ8ejhJVwxOJ9dc9K5e4vcXvGMaEygOXAxgvqFR7SBSJ
        aMa9Ko4sgiEj1PJ1awSPW/sTGCAV/6U=
X-Google-Smtp-Source: APBJJlE0UpAj8QPCOauNfmd67hYtykGLEOcvpIdTxaQ9xHW06ICLpBWZ8ZXToBUrb2/1EN5U53ZOEU2H/qA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7341:0:b0:d0b:ca14:33fd with SMTP id
 o62-20020a257341000000b00d0bca1433fdmr118184ybc.8.1691010722283; Wed, 02 Aug
 2023 14:12:02 -0700 (PDT)
Date:   Wed,  2 Aug 2023 14:11:49 -0700
In-Reply-To: <20230731022405.854884-1-maobibo@loongson.cn>
Mime-Version: 1.0
References: <20230731022405.854884-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169100955679.1738452.11040795142369096451.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: use unified time type for comparison
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bibo Mao <maobibo@loongson.cn>
Cc:     Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 31 Jul 2023 10:24:05 +0800, Bibo Mao wrote:
> With test case kvm_page_table_test, start time is acquired with
> time type CLOCK_MONOTONIC_RAW, however end time in function timespec_elapsed
> is acquired with time type CLOCK_MONOTONIC. This will cause
> inaccurate elapsed time calculation on some platform such as LoongArch.
> 
> This patch modified test case kvm_page_table_test, and uses unified
> time type CLOCK_MONOTONIC for start time.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: use unified time type for comparison
      https://github.com/kvm-x86/linux/commit/b859b018aadf

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
