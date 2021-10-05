Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC942339C
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 00:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbhJEWmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 18:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhJEWma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 18:42:30 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754DC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 15:40:39 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 66-20020a9d0548000000b0054e21cd00f4so657870otw.12
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 15:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PV7cJ/hxhLd396eXQZjH9+vBEhfECef+V1xwYvjoe7w=;
        b=gtCDdtbRgxQvORlfSsMbh39VpzD0nz5I4u9BvT73X5wiuDpHlpgWMuWmig2igaAdNq
         YNtsqTE1PgiGBzBSEK65tFqy0zUqwihBRZFUpvrhIhICBsuW+idA7qrZU7qy+27KiED6
         Ra17CtjdUBrZB3smTzuW9Dg4Xvl72fe07By7q4t9cy5WeBhqDzdbAsUvnECYXTiTbqkw
         UJa8C31pSn0UYoI8/NZ0/unuNzdSoXQ4awn+jtmeUbo2mZX7ltBb5o01JkNsXNiENvRm
         MVNmC46NV7wpixc4NV2fEb2/omrILP9vs3vIsTvV1Td4MP725CPMEfDfSXxwvkRemwxH
         4yZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PV7cJ/hxhLd396eXQZjH9+vBEhfECef+V1xwYvjoe7w=;
        b=d4kBb1Fyw6mTwf6Ls96Mgk7VLzShvNBPHvd6ZYvYLFj5SPWZZfiWiNVQw12/+yIHQJ
         agq8f7tE5SKJlN4n4XhoqkH1GvOZn2072hEMMqGmg4DgLstF8Oq7p5/NdX1k5Rv9Z9rw
         gnO7SIK1h449p7jeu2rEztR795jLy9wKbYkqMYNVK90I+6i/d2op9Bf7k+D/sv8R4Xrl
         hFU3UB6iznfDCif03ViJgF1SsEdazKld9X8lc1tc0UAripoQcAIkouOusUZXLWhUKLIn
         D8Tf0+5ppXZ5NlLt6pcnzT8JAXq6zkwot4nlrEIgcgGwLNHv/APlbIdIj23k1Bs4zceK
         gLOQ==
X-Gm-Message-State: AOAM53294RqHVjSAnN5pUz1umicrFLOHlchINF4b7/DQWwsmmAiH8arG
        90t3hzT28L0qaBiIMaf92ufmbNIencv7uux99J1OJzXzaQE=
X-Google-Smtp-Source: ABdhPJxNptgiYM8csaURKvTFVkdNqMyFdlgnAGmnxfBgjnAm3SFSv8iNznfcGt+JsN9ucZvy7aNM5Jjz9dio++z71gs=
X-Received: by 2002:a05:6830:31a7:: with SMTP id q7mr16486682ots.39.1633473638520;
 Tue, 05 Oct 2021 15:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <YR2Tf9WPNEzrE7Xg@google.com> <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com> <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com> <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com> <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com> <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com>
In-Reply-To: <YVy6gj2+XsghsP3j@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Oct 2021 15:40:27 -0700
Message-ID: <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 5, 2021 at 1:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 05, 2021, Jim Mattson wrote:
> > On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > > > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> > > > > >       You also said, "This is quite the complicated mess for
> > > > > > something I'm guessing no one actually cares about.  At what point do
> > > > > > we chalk this up as a virtualization hole and sweep it under the rug?"
> > > > > > -- I couldn't agree more.
> > > > >
> > > > > ...
> > > > >
> > > > > > So, Sean, can you help converge our discussion and settle next step?
> > > > >
> > > > > Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> > > > > the proverbial rug?
> > > >
> > > > Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
> > > > hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
> > > > unreasonable for VM-exit statistics, so maybe I've got a warped
> > > > perspective. I'm all for pedantic adherence to the specification, but
> > > > I have to admit that no actual hypervisor is likely to care (or ever
> > > > will).
> > >
> > > It's not just the memory, it's also the complexity, e.g. to get VMCS shadowing
> > > working correctly, both now and in the future.
> >
> > As far as CPU feature virtualization goes, this one doesn't seem that
> > complex to me. It's not anywhere near as complex as virtualizing MTF,
> > for instance, and KVM *claims* to do that! :-)
>
> There aren't many things as complex as MTF.  But unlike MTF, this behavior doesn't
> have a concrete use case to justify the risk vs. reward.  IMO the odds of us breaking
> something in KVM for "normal" use cases are higher than the odds of an L1 VMM breaking
> because a VMREAD/VMWRITE didn't fail when it technically should have failed.

Playing devil's advocate here, because I totally agree with you...

Who's to say what's "normal"? It's a slippery slope when we start
making personal value judgments about which parts of the architectural
specification are important and which aren't.
