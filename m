Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAE8523B10
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbiEKRCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 13:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345276AbiEKRCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 13:02:36 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAD464701
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:02:34 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q8so3399446oif.13
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92HACkAtpm+S9HD4vacJRmdSPxUsLtz6krm6JrWPD9o=;
        b=HYZRgYUy9T4am+mfv7XpCglNJT74NqxKeZPy8VHjrmtUofesPAsFtwwgw09QKLbyKE
         GJFFEdWRprZTppoKAXI2AV5hvt1SJIWsgyhgtZdTYKdC3dgu3zJhxoCad9YRHpzqRDpn
         EBWUmyfKRI6VeXgjKx5QWMGesV0rE4JmgjHAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92HACkAtpm+S9HD4vacJRmdSPxUsLtz6krm6JrWPD9o=;
        b=awIWyJpsLucj+G+OfqW3AVKIaXvadeKgrKgPhVlEjXZ7pb7M6tj4MThoid3Gvnz9Jk
         DwdtcCatsTTRa/peC/NWEC4rfG7TZnZT6JVItiA/r9MpKzs1m6wJdHCXvQWaDwaRDLLN
         oj1BI54N2v/pe5oTmH5JMO4XbXZmFYV7nIW7Z9ZNLsFnLrfgmSu3zmZLRNbGSQUWQi9C
         SXUCangY0UufHayFJU+Bz3hULmuATr1NwjWd6/r4gxeuscJcG4M0+G/amfuL03VUnaZr
         KpSv0YdGfB7JWJmvIyh/wzrgEXf1JCjNMVlSSgiYxIF3zrFqiWOK8wDQ2KN4b7BL6Rbk
         72Zw==
X-Gm-Message-State: AOAM530slahrJVwu9Zu1+oSCaFKfSQs6kuVqXEzux9y/BQ36jz+FEE3W
        3mudXS41ebd2KrDhg4qlseR2gHE7HKAPSWXtLxKV8g==
X-Google-Smtp-Source: ABdhPJzPaIDWkMKk2eTHgzHAQPLfUDaMyVAsRWhWm8nlkmWw8wBpL7aq4Q7/u4/QvEx/2tVxf4UKT5D2CHFn8lXSYhA=
X-Received: by 2002:a05:6808:199c:b0:326:a498:b638 with SMTP id
 bj28-20020a056808199c00b00326a498b638mr3132791oib.186.1652288553486; Wed, 11
 May 2022 10:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
 <YnvBMnD6fuh+pAQ6@google.com> <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
 <YnvFN7nT9DzfR8fq@google.com> <CAJGDS+G+z9S6QDEGRatR5u+q-5X_MAiWqnTsjf4L=4+PrThdsQ@mail.gmail.com>
 <YnvQd5zvDlop7oRK@google.com>
In-Reply-To: <YnvQd5zvDlop7oRK@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Wed, 11 May 2022 22:32:22 +0530
Message-ID: <CAJGDS+HRzTTSy4SuVtt-dzTzWXHZ0n1TJdDxKO+jOtGdcrX0Yg@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you for your answer, Sean.

I think I now have a fair idea on how to proceed. I will re-inject the
#BP into the guest from KVM and see what happens. I'm hoping the guest
will handle the #BP and continue execution without me needing to make
any more changes.

Best Regards,
Arnabjyoti Kalita

On Wed, May 11, 2022 at 8:34 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 11, 2022, Arnabjyoti Kalita wrote:
> > What could be the various ways a guest could handle #BP?
>
> The kernel uses INT3 to patch instructions/flows, e.g. for alternatives.  For those,
> the INT3 handler will unwind to the original RIP and retry.  The #BP will keep
> occurring until the patching completes.  See text_poke_bp_batch(), poke_int3_handler(),
> etc...
>
> Userspace debuggers will do something similar; after catching the #BP, the original
> instruction is restored and restarted.
>
> The reason INT3 is a single byte is so that software can "atomically" trap/patch an
> instruction without having to worry about cache line splits.  CPUs are guaranteed
> to either see the INT3 or the original instruction in its entirety, i.e. other CPUs
> will never decode a half-baked instruction.
>
> The kernel has even fancier uses for things like static_call(), e.g. emulating
> CALL, RET, and JMP from the #BP handler.
>
> > Can we "make" the guest skip the instruction that caused the #BP ?
>
> Well, technically yes, that's effectively what would happen if the host skips the
> INT3 and doesn't inject the #BP.  Can you do that and expect the guest not to
> crash?  Nope.
