Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4833F611E8A
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 02:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJ2AAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 20:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJ2AAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 20:00:10 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CDD43E50
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 17:00:05 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y72so7795555yby.13
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 17:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=84R2eYddxpxfwALxiEQNqgRaCZuxTUj2E3HhM+z6HRs=;
        b=RDmg4RwsphaSGKwI/1dWEe2nPwCRjzYIeRwrj4PGQPJFcLOpIkndFv6C6mQd5RWH7Z
         UMuDyKg60Q+pHmYQwM+oKbOVejgLPNmF6SkLSx35s1AIFuhrJilQLZ7fJPxMoi6KlzEf
         8ZDw/9jYaVNEttuGFxGPE7eU1RPahLzpnoeC7i7Rv6WDdBIR+X+o9HyDd4RhSb0VuCLm
         eEPQTh2z+kr8pM79iMWR6gstYSqCDJANNb5aHxZ1xSduXjqkRa1haPu60FC3uGKsFogX
         eK338Aipzues97NkoRALGXqU5//+pa8zYT21M3XEr5JzFU+EYLNqLKWwCPDrFwq+KszQ
         kaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=84R2eYddxpxfwALxiEQNqgRaCZuxTUj2E3HhM+z6HRs=;
        b=iqyqB8BK1GGM2EGBlzO6srevCpVUoSGVk8Mnk1pJqdYxkq7csX3+xJYqVpxNnILYdw
         BviVUvq7E1VLU6emOA4L7P68FQOZwN2rF2GcZmd5ZJQGjaBzo2JIKMkMI+/GprcTgPne
         pf47E8L61DrTHBxvDxRSIfuPEWPuONAFTenLGPC2seP+Oz6rIwon1CrMTKpUZBchfOox
         9CmItXHJJnxrxTUvmNRKO+KYnX9CXE7UYmbt4FmmCpApLsTluA1XaWV2AQ3QfX4l5DJX
         skF7MTIQf/BLGeQxUxlXIvt2L0u8BXbAtwqpMGuWJx/pIThh+nKmHlrbgM0uzy/xn6PL
         +Qww==
X-Gm-Message-State: ACrzQf00f67OufA4iAWMCrZxIeKIv2ABtZ5ySPo5dUouUJnni5fy4pCE
        FvwWbhRXlVgbTBWJIzTnp/ak8h1RKIZjJKgm062cpw==
X-Google-Smtp-Source: AMsMyM5WBCCvC3KQ9sNCRgCPXsoCb4/y7NXotPnjwcW9m2e73Yltsurmhg2a5p+4Ti18nnAj6QHltNsTPzgev59Do5Y=
X-Received: by 2002:a05:6902:68b:b0:6a6:bffd:b691 with SMTP id
 i11-20020a056902068b00b006a6bffdb691mr1466633ybt.607.1667001604528; Fri, 28
 Oct 2022 17:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com> <20221018214612.3445074-4-dmatlack@google.com>
 <Y1sX1FP4YIWRl5YU@google.com>
In-Reply-To: <Y1sX1FP4YIWRl5YU@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 28 Oct 2022 16:59:38 -0700
Message-ID: <CALzav=dVUJwSrzeeoPpL2oKdzimjyGuZtc3=i+eMJouxpDW9-A@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] KVM: selftests: Delete dead ucall code
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Oct 27, 2022 at 4:44 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 18, 2022, David Matlack wrote:
> > Delete a bunch of code related to ucall handling from
> > smaller_maxphyaddr_emulation_test. The only thing
> > smaller_maxphyaddr_emulation_test needs to check is that the vCPU exits
> > with UCALL_DONE after the second vcpu_run().
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../smaller_maxphyaddr_emulation_test.c       | 54 +------------------
> >  1 file changed, 2 insertions(+), 52 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> > index c5353ad0e06d..d6e71549ca08 100644
> > --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> > @@ -90,64 +90,15 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
> >       vcpu_regs_set(vcpu, &regs);
> >  }
> >
> > -static void do_guest_assert(struct ucall *uc)
> > -{
> > -     REPORT_GUEST_ASSERT(*uc);
> > -}
> > -
> > -static void check_for_guest_assert(struct kvm_vcpu *vcpu)
> > +static void assert_ucall_done(struct kvm_vcpu *vcpu)
>
> I vote to delete this helper too, it's used exactly once and doesn't exactly make
> the code more readable.
>
> >       TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
> >                   "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
> >                   uc.cmd, UCALL_DONE);
>
> I believe the warning is due to gcc resolving the VA args inputs to test_assert()
> before the call to get_ucall().  One thought:
>
>   uint64_t cmd = get_ucall(vcpu, NULL);
>
>   TEST_ASSERT(cmd == UCALL_DONE, ...)
>

I think you're right. And only gcc complains, which is how I missed
it. We can kill 2 birds (gcc warning + delete helper) with:

  ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
