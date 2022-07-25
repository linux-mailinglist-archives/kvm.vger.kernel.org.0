Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5155E5807BE
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiGYWph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 18:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiGYWpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 18:45:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A312AF2
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:45:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o12so11668698pfp.5
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BWR3PC2E+NWAez9RNUFH7ja26G33bUIrKBrg5nulkLs=;
        b=jkqMw/vMRMgdyTZKMsNuUTqk2KU4PTGhcQM3RDtipvzj794znW4J/5rx70uVVPmlW2
         Z4dWfpIVaNtSHv/AYpNLSsxC8k18Dq5/z3rzLm20doOjYXdi1PIU+Bnt1KESOSAL0rHs
         EjHWo2Udq891InMXvdhVOeVawiUvJmeMX0dpJGFDvHyMEKWQmFa2PuEIhBIBT93rB5a5
         mNn1PPL7lBnmzjku4ITJPu4wnt6tnshlHTQTBTgK7y2+btqAuvdRSSHKR1Z5Ocg8V3k/
         p0KmISjc8BJvOUvR087zSGwOGFRXo9AJ9YIrSu9RECTIP9iBiLe+njY6UosuntdmOV3b
         TO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BWR3PC2E+NWAez9RNUFH7ja26G33bUIrKBrg5nulkLs=;
        b=j+OIqPygooNhweZFt5bAIL3LzNrJQ2CYpJ2bZj9pRywBDqwD3KqI5rn17yn78kCGQb
         UqWd9lLZNDSZxj4cecKCvGKlsLfftSJ31ixpG1EoQqD7tV6O6EMorQxc8DsyyuWfITc3
         8OudClbpKreMuRQg57NtmnTDSJWwA8GueTvEDwS1+zYnzu60UHKr/VdGATBZU8hA84Kt
         bCstGZ5cJVeRdDLoEUN2IGsHw0ob/l1vNuVu/s9LdKWgzuksHRTlWUJKvu804P+qiYsc
         sk2Lt3QdxAfcc0yzr4DDpRSuxEX/Jq0NiJTwo4kcvyns9VTwuxgqnum+QK7rdxxLtc41
         dzHQ==
X-Gm-Message-State: AJIora/l6PO2C6OrRAVWiDyvAXWZCV4VAqDIemiJDSEk0/pO/JAC/7bq
        RYf8ji9ziPcxJRqdBkB2ROUqQl910tqHPw==
X-Google-Smtp-Source: AGRyM1teZj/r7AUIv0YTuFTzohVT5Jiy8UxgQHvXcc1LAYshNvWuUNpe11TqA9fwk9beqjDlON92jw==
X-Received: by 2002:a05:6a00:150d:b0:52b:1ffb:503c with SMTP id q13-20020a056a00150d00b0052b1ffb503cmr14804589pfu.44.1658789102145;
        Mon, 25 Jul 2022 15:45:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b0016d95380e8esm570552plb.140.2022.07.25.15.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:45:01 -0700 (PDT)
Date:   Mon, 25 Jul 2022 22:44:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [RFC PATCH 0/2] KVM: selftests: Rename perf_test_util to
 memstress
Message-ID: <Yt8c6gklsMy2eM5f@google.com>
References: <20220725163539.3145690-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725163539.3145690-1-dmatlack@google.com>
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

On Mon, Jul 25, 2022, David Matlack wrote:
> This series renames the perf_test_util to memstress. patch 1 renames the files
> perf_test_util.[ch] to memstress.[ch], and patch 2 replaces the perf_test_
> prefix on symbols with memstress_.
> 
> The reason for this rename, as with any rename, is to improve readability.
> perf_test_util is too generic and does not describe at all what the library
> does, other than being used for perf tests.
> 
> I considered a lot of different names (naming is hard) and eventually settled
> on memstress for a few reasons:
> 
>  - "memstress" better describes the functionality proveded by this library,
>    which is to run a VM that reads/writes to memory from all vCPUs in parallel
>    (i.e. stressing VM memory).

Hmm, but the purpose of the library isn't to stress VM memory so much as it is to
stress KVM's MMU.  And typically "stress" tests just hammer a resource to try and
make it fail, whereas measuring performance is one of the main 

In other words, IMO it would be nice to keep "perf" in there somehwere.

Maybe mmu_perf or something along those lines?  I wouldn't worry too much about
changing the number of chars, the churn wouldn't be thaaat bad.
