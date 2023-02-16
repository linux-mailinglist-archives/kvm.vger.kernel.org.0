Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA37699FD9
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 23:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBPWsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 17:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBPWsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 17:48:11 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871CF30EAA
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:48:10 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id a9so3519100ljr.13
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KjLYIhvFWi6J2UXsmFwBH8upKcmcKxt7JAy4IIyY1JQ=;
        b=GaauzJCwVb+FnABXuywhP9dHp4vhRSaUXofi9rKMHhhBdjYe/U14shGzG9403zL98E
         LWjey7SM89S709LUugqtHzcSRFo9ebewrkGkBqQjYYyqTlpruC/Bq9HjcZl6zWfmYOWK
         YwE06Jp1Y/nkDaiMu113viDs5qlVy5smC2/MuvWRAxOiEqV/kN9Vs/fUhXHpNhD2erkD
         zIH1IdhjhUW622XvITuu7VM1qlRydLbsvkG8HmApui6QpwCxQAMkTOXRkRN3e4SlCiY0
         /h8hiNVVbMt5NsbYEW/fZjnvKCvliND+ADdkkB5IragL1r0EPwqql7h3BDpCR3Ma9U6v
         bWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KjLYIhvFWi6J2UXsmFwBH8upKcmcKxt7JAy4IIyY1JQ=;
        b=zpr02tQoKzaWWYeYjloq21GkpBQKO/sT2QU5oTW2/x3ScB+3f4hkhiScmrO0wEr8JE
         H/fssiPs/uUSU2qGmmFH2dLdbrF8dlCj4ZVI55y1dXJjLWOeCX7md1hOprWQ3rqgwiqK
         wN3hOAPqiE/bocdeYLS3MjmJkJVgBLfcQ/d8VbI7CaAB+RVdKhE6QYIbaoDfXxJPu2QA
         aAQCbF8h7gkDB7JC5n2UihRl3ZK2CNp5bt1JMdMqk2a18vPzlteTWxussxGoj8n46BJF
         eSU5vP9AO1fQpxxkeuzyLMJ7RG8NdJ7XOpuwQGWZ3UA5jHae0Nv4g/0Y47a5CoTOQuuz
         IAOg==
X-Gm-Message-State: AO0yUKUJWfEYEEHFle4nPveoX3yCBQZX6JpWSsZOO0Hgq2tbVqytC90T
        r5wC9eXzZmfQPtUh6RcDDiNklHfGljNk6hDiA7GyIg==
X-Google-Smtp-Source: AK7set9PMUmXNrpWiccTjGTSZ9ZQ5T3/QvUYw6tfSzNEwRRTMyR2QoVM3TSUt4d65EtJPGueRZDTHWAfGq6M69DOS5k=
X-Received: by 2002:a05:651c:b21:b0:293:4ab4:3bb1 with SMTP id
 b33-20020a05651c0b2100b002934ab43bb1mr1655473ljr.4.1676587688542; Thu, 16 Feb
 2023 14:48:08 -0800 (PST)
MIME-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
 <Y+5zaeJxKr6hzp4w@google.com> <c34b8753-d70b-3d0f-f3b1-c89264642291@redhat.com>
 <Y+59PX7V9qEzpuJh@google.com>
In-Reply-To: <Y+59PX7V9qEzpuJh@google.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Thu, 16 Feb 2023 14:47:57 -0800
Message-ID: <CAAhR5DEhqv_FsdGbeOQ9vvKEcVCOnkDBxCJRs_XC2zN_8fKB5Q@mail.gmail.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Erdem Aktas <erdemaktas@google.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
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

On Thu, Feb 16, 2023 at 11:00 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 16, 2023, Paolo Bonzini wrote:
> > On 2/16/23 19:18, Sean Christopherson wrote:
> > > Depending on why the source VM needs to be cleaned up, one thought would be add
> > > a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
> > > allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
> > > mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
> > > and memslots, zap all SPTEs, etc...
> >
> > If we have to write the code we might as well do it directly at context-move
> > time, couldn't we?  I like the idea of minimizing the memory cost of the
> > zombie VM.
>
> I thought about that too, but I assume the teardown latency would be non-trivial,
> especially if KVM aggressively purges state.  The VMM can't resume the VM until
> it knows the migration has completed, so immediately doing the cleanup would impact
> the VM's blackout time.
>
> My other thought was to automatically do the cleanup, but to do so asynchronously.
> I actually don't know why I discarded that idea.  I think I got distracted and
> forgot to circle back.  That might be something we could do for any and all
> bugged/dead VMs.

As my second experiment where I always return success on ioctls after
the vm is marked dead, my guess is that VMM doesn't HAVE to clean the
state using the ioctls.
Our VMM currently cleans everything automatically during the shutdown
process of the vm. Changing this behavior might be a bit tricky if if
it's safer than allowing cleanup ioctls in KVM we can see if we can
change that behavior.

I like Paul's suggestion on ignoring ioctl errors if the vm got
migrated in VMM. This might be enough for us to clean up the source VM
state enough that we can safely release it.
