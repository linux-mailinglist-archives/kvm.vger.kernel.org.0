Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870F824DF01
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgHUR6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgHUR6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 13:58:45 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A952C061573
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:58:45 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id t7so2267506otp.0
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bx9yhqP2gv+RFOLI6VWLOFMjuyjMjx8ZOz5ZO3M3oAY=;
        b=iDXp9ZPaUtK6rxm11RoGxpNCxPudL3mXij31SFNuxIsU4df1q2RbWz/++jd/SLxbRk
         yDkxm5LyLRR8y9q0MFTnvegh+OAZvQtljRBalfGy0s1n6wReI8YtTtJAO3QBtOOKfCvR
         0s2syLG9L+Jw+98IhgyETZyMTcKr2x0kM5Y16KHDVh7W5e+jr7N6l27v7Ee3VcfSLsKG
         gIAr09QUzZZcZ06aE6Gl8FBwj2IEfA7zZe2Jt1knxaF8xlR4ZxdbFHTGMbTVaHHiBT1y
         oUHuua/sFudXYgatKNNn8adLL8vi30hRVobv4ceNccdVT9Rd9HWuMzCWS09U02ezhww6
         XXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bx9yhqP2gv+RFOLI6VWLOFMjuyjMjx8ZOz5ZO3M3oAY=;
        b=eDngIC+aqFF34dh/9fasw725XNFSThyRj8UpCp6fnLsdHNNq6oSV1wkgNHzk4G9JV0
         s2udWNUoSXyCOvxLOqgqjrgsLOVLeU8DCMF41MIHblsYtokijZ736gvPtb2LyyBJPvsE
         rzWBjR60dEON4RrfgKtbsR1p2XA6cOPx+4DW4//KZVxO13ijhqccPyf2JE3fElU1bKXu
         dkadlgzfJrggZMQy8lhc7rx8Hz7rpeYR55Z1PF3g9aovE8lmWkaW6KMQFCI7LEptHN2q
         DRXJ0vCMzNd5QA1S7MoDxUvle9LH3mY3h6C5Un4JTEuVgKNMDt2Ce58usC5w97VdFXnN
         uHsg==
X-Gm-Message-State: AOAM533T3ZTKtMAKQ57xCE1TXFqORwy5N+MAhHpWC/2c+9yOy0dWj6vP
        5g4nXh7ComwHPCxT6MfsE7LFaeRMur+Di5iJgBL3jg==
X-Google-Smtp-Source: ABdhPJy5u+cPFdDCrX8DltlVzF/nafE0RcHj9jHpLCnhm6O3GXL+9h3Yz3lzb9W6QxYmMKveZSV7+6UNAfRJXWJq9hg=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr2743035ota.56.1598032724041;
 Fri, 21 Aug 2020 10:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com> <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
 <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com> <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
In-Reply-To: <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 21 Aug 2020 10:58:32 -0700
Message-ID: <CALMp9eTUV9Z7hL_qtdKYvqYmm8wT1_oGaRLp55i3ttg1qLyecQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 3:55 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Aug 20, 2020 at 2:59 PM Alexander Graf <graf@amazon.com> wrote:
>
> > Do we really need to do all of this dance of differentiating in kernel
> > space between an exit that's there because user space asked for the exit
> > and an MSR access that would just generate a #GP?
> >
> > At the end of the day, user space *knows* which MSRs it asked to
> > receive. It can filter for them super easily.
>
> If no one else has an opinion, I can let this go. :-)
>
> However, to make the right decision in kvm_emulate_{rdmsr,wrmsr}
> (without the unfortunate before and after checks that Aaron added),
> kvm_{get,set}_msr should at least distinguish between "permission
> denied" and "raise #GP," so I can provide a deny list without asking
> for userspace exits on #GP.

Actually, I think this whole discussion is moot. You no longer need
the first ioctl (ask for a userspace exit on #GP). The allow/deny list
is sufficient. Moreover, the allow/deny list checks can be in
kvm_emulate_{rdmsr,wrmsr} before the call to kvm_{get,set}_msr, so we
needn't be concerned with distinguishable error values either.
