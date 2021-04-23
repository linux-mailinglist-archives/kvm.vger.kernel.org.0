Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D1A3699F0
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 20:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhDWSny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 14:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWSny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 14:43:54 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A5DC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 11:43:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id v6so73942825ejo.6
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 11:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nThaKi7pBhQZxo9PnCVU+4eBQtw/+h46XoJqncqmlCs=;
        b=UaLzSillqM2R0fqxvzMvaAWbAEbF7UHPLt/Q7eX8RfdpZpa4IbEfDui6ObpZILLSkR
         A1X6yb3uOVlUJv74iodZqN96+d/NoOLa7KgA004Dv6huhzYvClZyZB4xg1tfgU2P7lyQ
         ZaI9zpwwnAzdjF4hY12iAl6bG80cO4WHFtCEku64jt+xyd1iroSsJdKJIXlfXs1Ju6qA
         WHG3sGKNinwfEqSnQxP1FI5mCp3YG91pMAH52CmfaYkxfGR9PymeTuq8E3KhxB43Ey2H
         CeG2ufEtVZrKyFRfxiWZMAiWvmWGgMA1tB07ieV/0lMO8DZpeTg3j81iNGW4qrhZ+DF6
         0IyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nThaKi7pBhQZxo9PnCVU+4eBQtw/+h46XoJqncqmlCs=;
        b=LpRs8pWx3xkCpK1IJkMRMjm64FHbpDjfGKLlPVyYK34CsbbtZWb0st/K/svxj78yjc
         leuGS/emDBCdGVQjvacuhVJ/3phpKYkKu26Co1e9nATVUI51kAtN+NL7WnzrZxd4wwXr
         8EI1H4JX8If227KxgFwXxEsurTrBlGmD1UGg8abVkfdq6BJu9KMjlYvNiwGNDYJNq0Cq
         dJ45L6mi/ZKF2OWR1QwFmwETHryiUqJeqmbGBYsdhlOefrmbnU0cm2ynCmLnpQ672wsu
         vsq6WoEISPauFWIc7fRBqDZqHbuidYufJVFNEpf6klN68GL0fgPLcQ+nFNYmF1hQK3mY
         nsCg==
X-Gm-Message-State: AOAM531aDkvJB+ZOFEjnXAETO6COeIATxVVJsMumbqvFlvCBPRXSaA2p
        GR3TPP0NI4lkq2ToshUufb8BAPSc8ot+V/5ZMAa6qw==
X-Google-Smtp-Source: ABdhPJyUqJ/agr+V1kUSUI6YVxqh70RMuhSMuTxJU/3t3oaF3VN378mnTat5aWztIu60Og93j4mo4s9kJnmUf/hxA24=
X-Received: by 2002:a17:907:75d9:: with SMTP id jl25mr5650433ejc.420.1619203395094;
 Fri, 23 Apr 2021 11:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org> <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org> <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org> <YILo26WQNvZNmtX0@google.com> <cunbla4ncdd.fsf@dme.org>
 <YIMF8b2jD3b8IfPP@google.com> <cun8s58nax7.fsf@dme.org> <CALMp9eS5nT2vuOWVg=A7rm1utK-6Pcq-akX5+szc24PeY4NDyA@mail.gmail.com>
 <CALMp9eTfSSmzL1qqv7p9Zz7pHNuBy1TGc0Pp3O8oZqeXUWBdKQ@mail.gmail.com>
In-Reply-To: <CALMp9eTfSSmzL1qqv7p9Zz7pHNuBy1TGc0Pp3O8oZqeXUWBdKQ@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 23 Apr 2021 11:43:03 -0700
Message-ID: <CAAAPnDFLhfP0fNNHd9q-GgWfCk9m=NGU_htP2Z0_V5x9WH7kyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Jim Mattson <jmattson@google.com>
Cc:     David Edmondson <dme@dme.org>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >
> > > So is the conclusion that KVM should copy only insn_size bytes rather
> > > than the full 15?
> >
> > Insn_size should almost always be 15. It will only be less when the
> > emulator hits a page crossing before fetching 15 bytes and it can't
> > fetch from the second page.
>
> Oh, or if the CS limit is reached. (cf. AMD's APM, volume 2, section
> 15.8.4: Nested and intercepted #PF).

To sum this up as I understand it.  I'm _not_ going to clear
'run->internal.data' to zero.  I'll leave it to userspace to clear
vcpu->run.  I'll copy over 'insn_size' bytes rather than
'sizeof(ctxt->fetch.data)' bytes to
'run->emulation_failure.insn_bytes', and if 'insn_size' < 15, I'll
stamp the remaining bytes with 0x90.

Let me know if I missed anything.

>
>
