Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0885FBA28
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJKSNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJKSNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:13:13 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ADF6527C
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:13:11 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id bi15-20020a056808188f00b003546b897049so3900773oib.5
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dmOQFuqsJlxRDJeJVaOD+Dhfddv9bvhCkQxMMW8he7g=;
        b=PWHgdYwY4AaN3p7r9Cx5T4z6+E/Xt/cG6ubH4ZFA7eXrA/JjwlPfnb3mpjFI+vjjiz
         wvAM0YEM3obZlkNm4gytn/Wg2tkmDbJt+if1dOnYC5cl3xnuMz8AmvR4sUxDpaNG0d5M
         /kN/f24q57I7Bp8VrFSeG3vl80nZSU/T+UcD/ogpvWaS+NVBp+f1ohgv6p8WPU9RBtAq
         +w3Zcewcb0OePBMn+tdbROgaz1s4V69Li6SwBG3ZFbjmeQ/7Uyrc2Q5Y5m+Hd7COlErE
         XQoBUgVHousVvIYxt6vHuWJqDprGA7X5rd+hy959pddPnoM4OQMSkFBzxPzk+L5MDFkp
         q4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmOQFuqsJlxRDJeJVaOD+Dhfddv9bvhCkQxMMW8he7g=;
        b=MahnbZpDM3ePlR8VrLs3DuTsNGw4fMsiGRoR2vzJ7qLyyA1AjzMKSdFQbayeHZaX6B
         CeKcgvzGwe8Sq3qJ5F3BUdWZTekwTopzMf9QNh8lD/yloaSzw4iRgzew8MTYIYw7H3f9
         dzafcJd9ErDAzvCsMkejZsjp9c1nz0n13cKQiRELBVhEi6fvQxatiJ+R2laDqTbTSMY3
         nnzRIlJcjAZ3ugkJ4Tx71BLh6aH1pRFuSHQ/cpxauwBnHLxqmo4vGtgokhT3LnsXOdjj
         X+FOexG9UUJLtUO2aZnIb0lftX0tt5zOay5OdjZwk8E/SIy5E+kL5S9PYVCRBjjDPRzE
         Ggcw==
X-Gm-Message-State: ACrzQf1me0TBC1y461kcgRIKhH8L+HotEzmUEoIjQ/TRIes41tzaQuku
        hlHM83bLWEAmFxdWLO43jUJe4Zxv1L4EelEm+g==
X-Google-Smtp-Source: AMsMyM7y/WpNh4mYbFI30u4eBGD2lw8tNJ3IPE+a9hsFVT+3FVN9XOO/Mzza0FYspULRVVD76ODJ8WO2pJEJ3lsvRg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6871:71e:b0:132:b77d:42ce with
 SMTP id f30-20020a056871071e00b00132b77d42cemr264961oap.65.1665511991147;
 Tue, 11 Oct 2022 11:13:11 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:13:10 +0000
In-Reply-To: <Y0Rehzc6VbnOGIwF@google.com> (message from Sean Christopherson
 on Mon, 10 Oct 2022 18:03:51 +0000)
Mime-Version: 1.0
Message-ID: <gsntczay2pqh.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number generation
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Sep 12, 2022, Colton Lewis wrote:
>> Implement random number generation for guest code to randomize parts
>> of the test, making it less predictable and a more accurate reflection
>> of reality.

>> Create a -r argument to specify a random seed. If no argument is
>> provided, the seed defaults to 0. The random seed is set with
>> perf_test_set_random_seed() and must be set before guest_code runs to
>> apply.

>> The random number generator chosen is the Park-Miller Linear
>> Congruential Generator, a fancy name for a basic and well-understood
>> random number generator entirely sufficient for this purpose. Each
>> vCPU calculates its own seed by adding its index to the seed provided.

> Why not grab the kernel's pseudo-RNG from prandom_seed_state() +  
> prandom_u32_state()?

The guest is effectively a minimal kernel running in a VM that doesn't
have access to this, correct?

If you meant for the seed default. David Matlack specifically insisted
on using the same default every time. And a selftest is a userspace
program that I don't think has access to this either.
