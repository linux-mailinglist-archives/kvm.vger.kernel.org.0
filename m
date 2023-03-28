Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402446CC6C3
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjC1Pk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjC1PkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:40:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DBD12061
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:38:40 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e14-20020a056a00162e00b0062804a7a79bso6099120pfc.23
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680017919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JDo1hdn5PPYA/BrPBDKPiwkCmQEtXcPTBkl9kbEB7w=;
        b=N1K0ep+qcbJsWJSGLJ6sqlco7+rngaXdVrOQ757dytJc1rQ8cuTmz0VmZydmLrquaE
         EsGgi3hnWZTxfwgIznBbTKLjp8565dtlZYmjhoWPijnwp6cn80KUt8/cK6m7rah0zAy6
         Cde2SPQGQkVjY4QsuCXVlC7qBpN4CAEi+yeSla1NzWfVa54CPzYbK4ccn11etIFdcBlw
         dGobkcQh8haH0G8J6pVjyo74mqrGKdAwV3+FGI1dYAe+oLD596ZOObp0z9VI8TLATDEd
         pSygP9pVe+5nAS7temcXYnxzJIDTeZodeFq5nswCJQwo+0qOkORXqMG08OZIZeOjYxZ4
         yzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680017919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JDo1hdn5PPYA/BrPBDKPiwkCmQEtXcPTBkl9kbEB7w=;
        b=YYR7n+FqK1hi5R8NcGa/kD44CKKmjo1lvfsbea/Kol29BNgbRhb1UUaysLb11O4QOZ
         eCJBRoDdPwruHMDkeK4tu4HjM8MXJaE9hPaPSVEOoUGyR9bzKKqdS9FNZ21LZkKH/fAE
         GZFJmI6CkuQ500U+V9fZzLAyhRvPQMY0tf/1vrArdXhmD+iodptBq37kQWy0G5qHtw9Z
         BG56EY2Fp0S+iI4bbo9LLYxTiGQL6HPrKJzvMsKz2bmcjhjUp4KJzHxBv2DxHwHk3DVX
         divEN1oqSABl9TWEInJFJRO2a16ZbwdX0W4P/hrmbyAIkhjBXo4OYWu47u0oewWh3kjp
         Emng==
X-Gm-Message-State: AAQBX9cNCfV+/3yqx+mh52cXdCNNQnx3keN6NrmykpQubUfFfPJachvx
        ZGcpD8iGyV3PQMsQuHOeo2jMQEMCUoQ=
X-Google-Smtp-Source: AKy350ZtM0+MuyO2MvFrK+NtTn7mCYiV3Vn25cfenMOsn75V1ItnkrLfG/3fWkJ1V3/8SRO8wxrg6TuHOik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d381:b0:23d:4ab8:b1a3 with SMTP id
 q1-20020a17090ad38100b0023d4ab8b1a3mr4950708pju.1.1680017919114; Tue, 28 Mar
 2023 08:38:39 -0700 (PDT)
Date:   Tue, 28 Mar 2023 08:38:37 -0700
In-Reply-To: <86r0t9w5jp.wl-maz@kernel.org>
Mime-Version: 1.0
References: <87y1nvgv8s.wl-maz@kernel.org> <gsntfs9xdipf.fsf@coltonlewis-kvm.c.googlers.com>
 <86r0t9w5jp.wl-maz@kernel.org>
Message-ID: <ZCMJ/Vs3t63rU9z3@google.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
        shuah@kernel.org, dmatlack@google.com, vipinsh@google.com,
        andrew.jones@linux.dev, bgardon@google.com, ricarkol@google.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023, Marc Zyngier wrote:
> On Tue, 21 Mar 2023 19:10:04 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:
> > In context, I'm trying to measure the time it takes to write to a buffer
> > *with dirty memory logging enabled*. What do you mean by zero? I can
> > confirm from running this code I am not measuring zero time.
> 
> See my earlier point: the counter tick is a few MHz, and the CPU
> multiple GHz.

On x86, the system counter (TSC) counts at multiple GHz, so we should be able to
continue with that approach for x86.

> So unless "whatever" is something that takes a significant time (several
> thousands of CPU cycles), you'll measure nothing using the counter. Page
> faults will probably show, but not a normal access.
> 
> The right tool for this job is to use PMU events, as they count at the CPU
> frequency.

Out of curiosity, what does the kernel end up using for things like ndelay()?  I
tried to follow the breadcrumbs for ARM and got as far as arm_arch_timer.c, but
after that I'm more than a bit lost.
