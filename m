Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF206F33A4
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 18:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjEAQva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 12:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjEAQv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 12:51:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2057D10C4
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 09:51:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a7ddd9aceso5472714276.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 09:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682959887; x=1685551887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2rfiEmWDajPuoi1PDzr0CcD+6OVfLG8SyOWiFJYlOo=;
        b=NhrajK9MpJwQZo6Gx74SY9Ltv4xXnVecOUxhE1EV8+iAg3B/ZIvvbc/FDeFXXDjq4+
         PoA2H8u+H96wStPyKw9mtJetPYnatI9rm9MQOGgvU3QfMhMGirbWsEvNpkNuSZzqxMNX
         mDdqSzaiKWmdDDUgDVZFVCCyqX4Q+nOG1lJXrRzmBGs07VnIlhcjDaAO8GoyVJdgsrbC
         GiScw0nDtN91lRt31cKmCjUmuz4IkeiycLLvJ4PR1e//fOLTLes3NM82gdEPUkGZrNTM
         BcuI0MdiJyKI3H9f0PZx+dRXPHWO2xRAvgNWsyE5fhjNufYQhXBesZBy/Ph+oFNjlqjc
         5b/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682959887; x=1685551887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2rfiEmWDajPuoi1PDzr0CcD+6OVfLG8SyOWiFJYlOo=;
        b=Uw6/b9CYKhrpoDoIWAfwBVZIxHUiNkwNq/PyVb+dSqCWQltx1UDtVBzE2U7Ox+fAmE
         1obXeKwqetggTgs+pWBa0CNIwV2u91S8fmYeH+tzMMO7F9kBoNK7IQz2wku7BR3dqoj3
         BwMZ173X/DnjyRdnafYka+nDVntFfBmIRfZFElQ3Ds6KNcKY3eGHBqLYE9BXWKelq7jL
         UTrlW+KC9aL37KW4fx6rvMIPqD8lUtXwTykUojMFf3ygnyIEbsrXqotOBiKHFJ+Rpr0l
         1Okb5mO13d++PquFGvAmqeqW8Jwm2C8Lw+SdA4/lf0ZB8KiPp/igXwxP6x4+Onu0W+yl
         ddSg==
X-Gm-Message-State: AC+VfDz7MDVFQ1wEGoHx0hJpJUhUg0Vl5HAUiPBYvVujiIlivGmmMHUb
        5meDp4WXGNEXC8ecD9TqZQnshKrH9Sc=
X-Google-Smtp-Source: ACHHUZ6kOfYcWCuAHhXf1CyoEH7OyiUtQBZYequOpzcpklhI0P2OXyILWSt+76V1UZX6M3zPHlfPIV75kjk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2c8:0:b0:b8f:6b3b:8a0a with SMTP id
 191-20020a2502c8000000b00b8f6b3b8a0amr8156781ybc.6.1682959887273; Mon, 01 May
 2023 09:51:27 -0700 (PDT)
Date:   Mon, 1 May 2023 09:51:25 -0700
In-Reply-To: <bug-217379-28872@https.bugzilla.kernel.org/>
Mime-Version: 1.0
References: <bug-217379-28872@https.bugzilla.kernel.org/>
Message-ID: <ZE/uDYGhVAJ28LYu@google.com>
Subject: Re: [Bug 217379] New: Latency issues in irq_bypass_register_consumer
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 28, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217379
> 
>             Bug ID: 217379
>            Summary: Latency issues in irq_bypass_register_consumer
>            Product: Virtualization
>            Version: unspecified
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: zhuangel570@gmail.com
>         Regression: No
> 
> We found some latency issue in high-density and high-concurrency scenarios,
> we are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net and
> block for VM. In our test, we got about 50ms to 100ms+ latency in creating VM
> and register irqfd, after trace with funclatency (a tool of bcc-tools,
> https://github.com/iovisor/bcc), we found the latency introduced by following
> functions:
> 
> - irq_bypass_register_consumer introduce more than 60ms per VM.
>   This function was called when registering irqfd, the function will register
>   irqfd as consumer to irqbypass, wait for connecting from irqbypass producers,
>   like VFIO or VDPA. In our test, one irqfd register will get about 4ms
>   latency, and 5 devices with total 16 irqfd will introduce more than 60ms
>   latency.
> 
> Here is a simple case, which can emulate the latency issue (the real latency
> is lager). The case create 800 VM as background do nothing, then repeatedly
> create 20 VM then destroy them after 400ms, every VM will do simple thing,
> create in kernel irq chip, and register 15 riqfd (emulate 5 devices and every
> device has 3 irqfd), just trace the "irq_bypass_register_consumer" latency, you
> will reproduce such kind latency issue. Here is a trace log on Xeon(R) Platinum
> 8255C server (96C, 2 sockets) with linux 6.2.20.
> 
> Reproduce Case
> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_fork.c
> Reproduce log
> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log
> 
> To fix these latencies, I didn't have a graceful method, just simple ideas
> is give user a chance to avoid these latencies, like new flag to disable
> irqbypass for each irqfd.
> 
> Any suggestion to fix the issue if welcomed.

Looking at the code, it's not surprising that irq_bypass_register_consumer() can
exhibit high latencies.  The producers and consumers are stored in simple linked
lists, and a single mutex is held while traversing the lists *and* connecting
a consumer to a producer (and vice versa).

There are two obvious optimizations that can be done to reduce latency in
irq_bypass_register_consumer():

   - Use a different data type to track the producers and consumers so that lookups
     don't require a linear walk.  AIUI, the "tokens" used to match producers and
     consumers are just kernel pointers, so I _think_ XArray would perform reasonably
     well.

   - Connect producers and consumers outside of a global mutex.

Unfortunately, because .add_producer() and .add_consumer() can fail, and because
connections can be established by adding a consumer _or_ a producer, getting the
locking right without a global mutex is quite difficult.  It's certainly doable
to move the (dis)connect logic out of a global lock, but it's going to require a
dedicated effort, i.e. not something that can be sketched out in a few minutes
(I played around with the code for the better part of an hour trying to do just
that and kept running into edge case race conditions).
