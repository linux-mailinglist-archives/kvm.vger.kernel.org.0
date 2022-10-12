Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A135FCB6E
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 21:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJLTVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 15:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJLTVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 15:21:34 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEACDD889
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:21:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h10so17155880plb.2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a41mvOH/dMb1FChOmQlxdRbAadjUxOePX+DshXMW4Bw=;
        b=EKtK0cGGsFB8JnW2fxKbiDZ/OHhT2wfhsRwTHuhScvqj17HTTh+3SkWgTGm33ewmW/
         zGavnhWJWKnN5qWS/gmHThR3MjsLauzRaMJh6lX5Aya1SNNzA5QAFjo5Kf28v7BJ7bxM
         isz8HjH6k8kWL+3TbxAqr2Zws1WdueHoKYctZwufQziF2V1Kwy2BG7vCuJ1MJeQiWt6q
         aEwwXosRzMmpiRIo7LMY7Fn8j3wFGtSi8oTo90Uq4asKZsAGCWQdcb9X1JJKue2iGG1+
         Ej5qwqBrtEGUH6If3ROt63IfHyxEF8bETRhUuLUNHm4gAPhverZysvXtsujExpU2QkNN
         c3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a41mvOH/dMb1FChOmQlxdRbAadjUxOePX+DshXMW4Bw=;
        b=atI8US8CPM7OTtZbx0fyGkx8HOzgc7VJmxNOuUb0L6n7lu35yrP5HJrNLE15wd2MZb
         azOhCyQIhTAunm4CzQCaNwnuknNiJBxO0FUCF+EsUN3XASoYtMp0isLyzIyMG0vHn3/Q
         X3B9Zs2uRXg7gEmiRNMmQBFYDEmChFeRFpWFXeQD0UlOUZgSbppSagIv1V9IowDOlbw2
         i7lJmgoUQU1X3bDecEvUQiifU17HU9yfVFxGnjowS1tPUpXHhebGUnp6QJiNdNqFLhTY
         SgjjcfH4kYBrqN4/CWE2lTiIrOHP15ncAUmj2hfa7bHsbAsuB+zgwtRGtvwnfB9bpdTL
         heoQ==
X-Gm-Message-State: ACrzQf3MYnkR4MU2qo/xoIxQp+9e4MD3PG+hO4ZcimNDvyPl5zHEUldo
        ltr6VY04kFAtArK192kRZQF/Lw==
X-Google-Smtp-Source: AMsMyM5xMyPF8/WcO3wU/08HUdFqIX3aWXXkjuFOeXaOj8XVIsXbAm9IwC24WBMF4XoZZmdbcMhTIA==
X-Received: by 2002:a17:902:b417:b0:181:d0e4:3310 with SMTP id x23-20020a170902b41700b00181d0e43310mr20575045plr.134.1665602492553;
        Wed, 12 Oct 2022 12:21:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n9-20020a170903110900b00176cdd80148sm11033649plh.305.2022.10.12.12.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 12:21:31 -0700 (PDT)
Date:   Wed, 12 Oct 2022 19:21:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 1/3] KVM: selftests: Rename perf_test_util.[ch] to
 memstress.[ch]
Message-ID: <Y0cTuKbeWoGSXPFT@google.com>
References: <20221012165729.3505266-1-dmatlack@google.com>
 <20221012165729.3505266-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012165729.3505266-2-dmatlack@google.com>
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

On Wed, Oct 12, 2022, David Matlack wrote:
> Rename the perf_test_util.[ch] files to memstress.[ch]. Symbols are
> renamed in the following commit to reduce the amount of churn here in

Heh, "following commit" is now stale.  This is why I encourage using ambiguous
phrases, e.g. "in a future commit".

This should also be phrased as a command, not a statement of truth.  E.g. in the
extremely unlikely scenario that symbols are never renamed, this statement is
wrong, whereas something like

  Defer renaming symbols to a future patch to reduce the amount of churn
  here in the hopes of playing nice with git's file rename detection.

states only what is done in the context of this patch while still calling out
that the intent is to rename symbols in the (near) future.

To be 100% clear, I'm not saying don't describe future changes, there's a _lot_
of value in knowing that a patch is prep work for the future.  I'm saying don't
explicitly predict the future, because occassionally the prediction will be wrong
and the changelog ends up confusing archaeologists.

> hopes of playiing nice with git's file rename detection.

s/playiing/playing

> The name "memstress" was chosen to better describe the functionality
> proveded by this library, which is to create and run a VM that
> reads/writes to guest memory on all vCPUs in parallel.
> 
> "memstress" also contains the same number of chracters as "perf_test",
> making it a drop-in replacement in symbols, e.g. function names, without
> impacting line lengths. Also the lack of underscore between "mem" and
> "stress" makes it clear "memstress" is a noun.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Changelog nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
