Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6015D69E3FD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 16:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjBUPyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 10:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjBUPyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 10:54:23 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A669CC32
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 07:54:22 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j20-20020a170902759400b0019ace17fa33so2462141pll.7
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 07:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zkX6iRm2AD+7MKmuOp4yI60dg654Tluowxz9tFdb4Z4=;
        b=cQPW/mI24KrAtUv/zuFwrgiQji2eebp9EqEe5del3SpGILZGYnabKTEAIDLGEl9Yjr
         NR1ReoD+G7RsqlKNHuCXk/avkGCeePi+bfqgsqSxvJZMnNU4JGtDDCfS7XHVv9xRbaYy
         ilMpViMgw7inpFAXYqqPxXuXAv43pJWqGz8RnRgD0sKrgsZ5zqtl3ktEYrLKUg2By/DW
         eycrAErAb7Ne1hi9qVQvJF41EwSMjdEUHX57k+E0pP3QFokrFHnwqo7bWYtLWdjfWqyr
         hcekmB/ByUSGzdci0OyKznRsqA+bNK2q9IBSzs3MeT6rLtKLorKjcJxjYs2ij0KEmT6p
         ZqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkX6iRm2AD+7MKmuOp4yI60dg654Tluowxz9tFdb4Z4=;
        b=BKz803w6a+KzhhGdBT3JK8XOkCOtWUHS5nK8iNdpZnOd5ia3EzAB1sWuahfJ/1LBeQ
         jK6P8LOMs3kSYojj3VzR71k+N0hDX63kFcfm5Xt37AJTBI9/HpnsgbRqeVrJkM6z/Jql
         VlZAuBqRox1NUTzSWHhZyjc0uMwlVeoIZvUviDxqQ5+CfhmcNMQ9VB/GwWnn6d+f1o1l
         pRIHEHxc9umgFtkyeqszmGI9bEYtxtFclRGXqIys5H0RPolenppZhKgfVR+NlXzKfyHO
         coJAQIHa+wCJVqp42kAX3h/pTqiZmXYgpVkbW+w17E2ODQhIvdo9Cs8Pe/HyNVzuZOej
         50dA==
X-Gm-Message-State: AO0yUKUP70TdOXr9XEg12fru+GtPRKN417lYjfmO0JMQMgKnQ71VaKKX
        rO9kNF1bQq6D7yjW8899vTlNGqevnf8=
X-Google-Smtp-Source: AK7set9qKNRrLap/Wyd7WykqM23iMN59JMg6VzK2Eu6ZdhESTrzlV51N1IsWD0Ws5VQzY3JVzv/aC+HC6PM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a38d:b0:199:6fd:ecf6 with SMTP id
 x13-20020a170902a38d00b0019906fdecf6mr660617pla.9.1676994861544; Tue, 21 Feb
 2023 07:54:21 -0800 (PST)
Date:   Tue, 21 Feb 2023 07:54:20 -0800
In-Reply-To: <20230221032156.791-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230221032156.791-1-binbin.wu@linux.intel.com>
Message-ID: <Y/TpLMRiNwGt2dhY@google.com>
Subject: Re: [PATCH] KVM: x86: Remove duplicated calls of reverse_cpuid_check()
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023, Binbin Wu wrote:
> Remove duplicated calls of reverse_cpuid_check() in __kvm_cpu_cap_mask()
> and kvm_cpu_cap_{clear, set, get}().

I want to keep the checks even though they are redundant.  There is no runtime
cost, and the intent of the direct calls in the "upper" helpers is as much to
document their usage constraints (input feature must be a compile-time constant)
as it is to enforce correctness.
