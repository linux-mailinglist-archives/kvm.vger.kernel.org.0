Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D695BD783
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiISWgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 18:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiISWgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 18:36:35 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A284F687
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 15:36:34 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 3so712901pga.1
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 15:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=r3sDBcZVTmXyLqjRDhyLwuUw1XBhehVC1GJwDEO38UQ=;
        b=pAtD49X8BQhpOmtOEQejYPQKn4m++niixoo/oF0wcoGn/1cXG8LptjrOLbRa9Je6CJ
         HEoq/SSIlNjvou/uYgW+OTw5L8rxeZgMM0slyuWsRkUK6495kjm92aZ8JZv5X5wvxLvL
         DjIdEpKJaok/6E2yMbmtypDlK3/jJf6xUEZCu+BTT6rR33sSb6xpyHCzYo89o6tHcPSq
         DC9eF5N09L+2PzcTb8C8xu5IqmkE0zpVxHwv2+YBXP9bm8WAxczg3wUkKv7Yd3Fm77YH
         cAW+zi9R3xHsLlzk/CITQ8lAQlvTrkxEQJTzHbX2XgDSXNqJrw9AA+v1XF8fCo73hOV6
         V78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=r3sDBcZVTmXyLqjRDhyLwuUw1XBhehVC1GJwDEO38UQ=;
        b=XMJ7zzsL+GvcQbUaza4mp2fPyrIHWNfGIdIat4RSM0lNyJzI7T/2jwvqQUbj9302tY
         g4HE0Y6xyvfK79grFLMXVGJlnm7pMNtrMPRg7Z/RcizvXohFWT7BbBD1DCJauaKXX+LN
         b6Qw2/lb5B70gfYvqivi9IvteMm12tAGEh8Uw+h2+N/U7T8YSYQBykl8BrKY2ht7t3Se
         SV7qe0rsVRLqAM3WwtXMYub28EPTvWCnQQbEqxwTnw4ymZJGOmGHTl5O7NZqY5HCMLsv
         5nGJLPhcUrblhk+XZnG4K2hdPtm4pzsMTqGbWEtpEiLDTTIu/QwnmBbo84SmDivaKPG4
         Yr/g==
X-Gm-Message-State: ACrzQf3wyVCiqNGcAjC1MC3EO/eQKJBCv3c4T6LgyLGhwllwamuFtAyy
        BjdlO/+/fuOiTzDxY0niciu19Q==
X-Google-Smtp-Source: AMsMyM6UsSk8Wty4pvt5booP4OZGFctqlwp/jjmU5iEMWHpWeeg/yMJ/34JhgDoXn8+4dfdXk9ok4w==
X-Received: by 2002:a63:9042:0:b0:438:8ef2:2476 with SMTP id a63-20020a639042000000b004388ef22476mr18150137pge.55.1663626994365;
        Mon, 19 Sep 2022 15:36:34 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b00174ce512262sm21532867plg.182.2022.09.19.15.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:36:33 -0700 (PDT)
Date:   Mon, 19 Sep 2022 15:36:29 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 0/3] KVM: selftests: randomize memory access of
 dirty_log_perf_test
Message-ID: <Yyju7VPTgV5NHior@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195849.3989707-1-coltonlewis@google.com>
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

On Mon, Sep 12, 2022 at 07:58:46PM +0000, Colton Lewis wrote:
> Add the ability to randomize parts of dirty_log_perf_test,
> specifically the order pages are accessed and whether pages are read
> or written.
> 
> v6:
> 
> Change default random seed to the constant 0.
> 
> Explain why 100% writes in populate phase, why no random access in
> populate phase, and why use two random numbers in the guest code.
> 
> Colton Lewis (3):
>   KVM: selftests: implement random number generation for guest code
>   KVM: selftests: randomize which pages are written vs read
>   KVM: selftests: randomize page access order

For the whole series:

Reviewed-by: David Matlack <dmatlack@google.com>

> 
>  .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>  .../selftests/kvm/dirty_log_perf_test.c       | 55 ++++++++++++++-----
>  .../selftests/kvm/include/perf_test_util.h    |  8 ++-
>  .../testing/selftests/kvm/include/test_util.h |  2 +
>  .../selftests/kvm/lib/perf_test_util.c        | 39 ++++++++++---
>  tools/testing/selftests/kvm/lib/test_util.c   |  9 +++
>  6 files changed, 90 insertions(+), 25 deletions(-)
> 
> --
> 2.37.2.789.g6183377224-goog
