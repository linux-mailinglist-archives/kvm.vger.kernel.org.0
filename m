Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12A05AF87D
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 01:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiIFXri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 19:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFXrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 19:47:37 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499CB91085
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 16:47:37 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id y1-20020a056602200100b006893cd97da9so7916936iod.1
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 16:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=osNBQ7ONotxsEV0KyodnFKn08qq/4vRcVukED3XI+B4=;
        b=R2DR+vffmoiCBriFCS/D/crQhPLJjONtm+BVK/vB3slzh+qWZNC4KwaCYHWPGpe66H
         oaThfrkncprqmc7tNBaYcrmZrH+00GBdHeFtayu5lrz1ohWXFwRvacShRQkGnP5tk7MD
         G2tRv41uEufv539QAjZeLfNu/j01Z1Ceq0OAqC0xfYde1YnqSHADvZx6kzEx7QL6j2Wh
         0up/pM9FnhvgRE1bL4BG49lEVMnvc+2akFsgzT+Tbp+WagMAbrX0VPy4orogzPCuppHV
         lVHA9F5/CwSx2dhj6uH+X1AP7qMPGvDdJp5f4eFNliZrsjgLH0O5C0EUn8/uQOF+3zJG
         ZA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=osNBQ7ONotxsEV0KyodnFKn08qq/4vRcVukED3XI+B4=;
        b=Bh4xdhuS0L4T914F2SxfLWMeJhQ9LSSrX/Bok+2eLSeocOMYZ03GBPm4qn3LtvHfpb
         gZCsW5Wg/YXUwonaFA7pAgBf3kvH6ITk+wJRoHwd74R4HzQ/VCEyNYTQ3UUTK3cWP7Df
         aefc/IRHVfBKy6A0yBFD9Bq/XgjecuUpSSZOxnWyJw+tNI/Vgek0bXa6/JJDEWdfTXWs
         ltiHWS/U4mkNLMQcAPCdP4nw5J/n72KeyVpV2LCFQodL96FNGh/ieb5yhcH7pv2Hs9hz
         lVBKuwR6QuvxRuBwrNAK4w2qk6AN6Nk7MijzwTFQJPGmEQG+BopOx1r48+U1iFS2Fe+6
         jr2Q==
X-Gm-Message-State: ACgBeo1499L/xxQgQyPzRfH4a8tPF1OIiEMd2tRZjAWQxlOUer0f1Pub
        Tw/8lE8vm+RNMBgM0p3eogdDGJo6D5KbKWKJDw==
X-Google-Smtp-Source: AA6agR56eaLHeY8lK5RuvuWYvDuZkO5WrgbRdX4Pks55x+Cwuyzk4fNchvutAJB1AhuDInDBvDVaW8tZlvqr9oMSMw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1343:b0:67c:aa4c:2b79 with
 SMTP id i3-20020a056602134300b0067caa4c2b79mr485253iov.172.1662508056611;
 Tue, 06 Sep 2022 16:47:36 -0700 (PDT)
Date:   Tue, 06 Sep 2022 23:47:35 +0000
In-Reply-To: <YxeaxaxGS5dsp3hl@google.com> (message from Ricardo Koller on
 Tue, 6 Sep 2022 12:08:53 -0700)
Mime-Version: 1.0
Message-ID: <gsntv8q0oyjs.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 3/3] KVM: selftests: Randomize page access order.
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:

>> +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
>> +{
>> +	perf_test_args.random_access = random_access;
>> +	sync_global_to_guest(vm, perf_test_args);
>> +}

> This can be merged onto the sync_global_to_guest() done for the seed.


That seems like a micro optimization. I'd prefer every perf_test_set*
function have consistent behavior.

If needed, sync_global_to_guest should work on the individual field.
