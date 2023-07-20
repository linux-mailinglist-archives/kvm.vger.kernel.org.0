Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7A75AABA
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 11:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjGTJ2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 05:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjGTJ2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 05:28:13 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43876D881;
        Thu, 20 Jul 2023 02:14:20 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-57026f4bccaso6480967b3.2;
        Thu, 20 Jul 2023 02:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689844459; x=1690449259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AqcliHaF/X2rsoH6SIbvP8MSE536dI0mI+IfCi2VH/o=;
        b=SYePtDrBDFLA2TLZD31sbGiudHb0dQnGlwyfqVwP7YPnTUL1oxk8HK7eb9bxQvjLRX
         MhXe1S2W5uWASEqJaERZvCPZofX85Hv/TPBTl89HAGnCwsxs734Dpv9EVSvMPLfVdDxW
         HvmxJz6NaiNtquMLZAl6P9xF8wiawnX71jjQZcAWcHnLCi28uY/ShUbqYFSARbN7qwrl
         PT7cNQ4uv2KNuem1JWko1g19ouOOyVEX8BxVx+REe61RoQ5HOOyx2T44vK9JZRuQDKYo
         Ar912uP38MNK1nzDlwxN7jLjXHiPWoh8sIj53byMyV7lBc+sA6xduNHvQuRTQ5yAvmjn
         c/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689844459; x=1690449259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqcliHaF/X2rsoH6SIbvP8MSE536dI0mI+IfCi2VH/o=;
        b=AF9YCoGMqff8OZ7lncpsgNcXNn8PeC0vX329uBplp9c268avcQleZK5vPywJXiveKW
         TbzQCzcFjXWPrL6Ff+o8XX2E2IbA1lYAj0dvtQugcPtpkuloybSoCrloROLo9jwWaUjV
         P3nW86/NlA95NBc/hUnpF0Am3PbuCDTfK3ieECwXZXNFUtngz6fq4q73qvNuGhC8bYQx
         Q/q64bfLdJgQa9Ymtk3sctHQog2JXQNLmELCiGJOFPNIetj7MJw+9L4tSywbRNrZcgCL
         0oRjJvL8ysvvgAmF0msVhav/29k+8Yk98stS4W3f6fybNg81oyEfo2ca/Oo0OZtjck1x
         MtbA==
X-Gm-Message-State: ABy/qLaSQQj0LSkE3aKfbPKX4dhDsAPzhqWey+6Nb19JtZa4C1zYu3KH
        /4OJ6de3meNb8x2Mxm/1vbQ+Wc24naD+C4f2UVo=
X-Google-Smtp-Source: APBJJlGKWrHE+2wGqP4oX4d8mnZGWkQmsZ5pPerU9i6GhyJMH2MHOjbTgsQ1qhCozIc2mJmkDgzhFeyQIbrATzKWiso=
X-Received: by 2002:a81:6d13:0:b0:56d:1f62:7793 with SMTP id
 i19-20020a816d13000000b0056d1f627793mr1651543ywc.46.1689844459258; Thu, 20
 Jul 2023 02:14:19 -0700 (PDT)
MIME-Version: 1.0
References: <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com> <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com> <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com> <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
 <CAM9Jb+hkbUpTNy-jqf8tevKeEsQjhkpBtD5iESSoPsATVfA9tg@mail.gmail.com>
 <20230720080357.GA3569127@hirez.programming.kicks-ass.net> <20230720080947.GA3570477@hirez.programming.kicks-ass.net>
In-Reply-To: <20230720080947.GA3570477@hirez.programming.kicks-ass.net>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 20 Jul 2023 11:14:08 +0200
Message-ID: <CAM9Jb+gBha3kgJ=Vgzh73EYXh22-UuXctZt2c6GftQq3rFUgXQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
        binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com,
        john.allen@amd.com, Chao Gao <chao.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > Trying to understand more what prevents SSS to enable in pre FRED, Is
> > > it better #CP exception
> > > handling with other nested exceptions?
> >
> > SSS took the syscall gap and made it worse -- as in *way* worse.
> >
> > To top it off, the whole SSS busy bit thing is fundamentally
> > incompatible with how we manage to survive nested exceptions in NMI
> > context.
> >
> > Basically, the whole x86 exception / stack switching logic was already
> > borderline impossible (consider taking an MCE in the early NMI path
> > where we set up, but have not finished, the re-entrancy stuff), and
>
> SSS
>
> > pushed it over the edge and set it on fire.

ah I see. SSS takes it to the next level.

> >
> > And NMI isn't the only problem, the various new virt exceptions #VC and
> > #HV are on their own already near impossible, adding SSS again pushes
> > the whole thing into clear insanity.
> >
> > There's a good exposition of the whole trainwreck by Andrew here:
> >
> >   https://www.youtube.com/watch?v=qcORS8CN0ow
> >
> > (that is, sorry for the youtube link, but Google is failing me in
> > finding the actual Google Doc that talk is based on, or even the slide
> > deck :/)

I think I got the link:
https://docs.google.com/document/d/1hWejnyDkjRRAW-JEsRjA5c9CKLOPc6VKJQsuvODlQEI/edit?pli=1

> >
> >
> >
> > FRED solves all that by:
> >
> >  - removing the stack gap, cc/ip/ss/sp/ssp/gs will all be switched
> >    atomically and consistently for every transition.
> >
> >  - removing the non-reentrant IST mechanism and replacing it with stack
> >    levels
> >
> >  - adding an explicit NMI latch
> >
> >  - re-organising the actual shadow stacks and doing away with that busy
> >    bit thing (I need to re-read the FRED spec on this detail again).
> >

Thank you for explaining. I will also study the FRED spec and
corresponding kernel
patches posted in the mailing list.
> >
> >
> > Crazy as we are, we're not touching legacy/IDT SSS with a ten foot pole,
> > sorry.

ya, interesting.

Best regards,
Pankaj
