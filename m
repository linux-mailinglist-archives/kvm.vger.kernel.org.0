Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163C9449CF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfFMRn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:43:26 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34899 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFMRn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:43:26 -0400
Received: by mail-ed1-f66.google.com with SMTP id p26so28346415edr.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 10:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KbVzXUK1NN9/sw3hoYhD1GHtUrylzXfXjiAM/J+Brog=;
        b=XElxIcOXlFiOTxVzejT8v77VQGmn+wziJUEUa7uBdTmVPB3GQlqrq/i+WZ+W0yfxMJ
         AGWTCUBjBFVbjgKFTlcQbGcOsdU6UlVBEIbkhv2PqCPR0QTVNlQH3HGOWsft/lF9avoJ
         yVjk3wpVIuCOyimIPxq8XjoUi73mZirgNIWY4GkTsEiN98x+RF+PCqlqPZts5nG+ZY0Z
         Lidzym2SV0+4oYyVAGoEBGYstsP1m/t55omoaXEsvzTQx8WJN3mGHuWytvioC4Ht008N
         vPv9yQ4yP4re4lDf999mFYZKd8UbkkzdBZGvJsm59K4MByM2HkTud5FoYxkBWog03a8/
         H3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KbVzXUK1NN9/sw3hoYhD1GHtUrylzXfXjiAM/J+Brog=;
        b=HsHxCzR93AbjgEawcwNaSRfDmIT0I8y9/J+/v2/wvGcERfwbWWoodhlMJoFtJrRBOl
         4JRuxgeXunjtoWLzWwkxbj9Y5BbfRb6gkMbatAKMYw9BE3iXDEAzGPKWqBpEIpTFJBmw
         iHupfWVKYeDCc6aam/TGCMPQfZCdvjCjFJYqusIt3WyXvs1TvH52QxzfAAU4liNh3X0E
         iHedQtYP7CEYIPrE7UQV2icVOFggidWrnjL+FoWTZtFrX7xU/oSejHt85hzroCQJoHmL
         lui97L5X/nmxNH0Yy5R4Gz0T7ecWnhjmHWI2CZrrmqNzGIT2RR+EyTl7ajRDgVu0qZ+c
         VDFg==
X-Gm-Message-State: APjAAAXfl38qtB/+ZvTqbW+zBw6/EfaMm+be+PVI0R0jQriivTFG2Gj7
        cYZTfx/f4ZJkDJBqt8t0tYMmKcH5HQ51322O3xwa6w==
X-Google-Smtp-Source: APXvYqyRkSAfTZEud2sjuEwtrMVjDlLXDnzhlBc4qjCpsFxZK+M8/SJe5pp8MJlhR6sctwLybD1Hs3XKTXr+1omkhdU=
X-Received: by 2002:a17:906:9705:: with SMTP id k5mr43469018ejx.5.1560447803686;
 Thu, 13 Jun 2019 10:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
 <5CEE3AC4.3020904@intel.com> <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com>
 <5CF07D37.9090805@intel.com> <CAOyeoRXWQaVYZSVL_LTTdAwJOEr+eCzhp1=_JcOX3i6_CJiD_g@mail.gmail.com>
 <5CF2599B.3030001@intel.com> <CAOyeoRWuHyhoy6NB=O+ekQMhBFngozKoanWzArxgBk4DH2hdtg@mail.gmail.com>
 <5CF5F6AE.90706@intel.com> <CAOyeoRW5wx0F=9B24h29KkhUrbaORXVSoJufb4d-XzKiAsz+NQ@mail.gmail.com>
 <CAEU=KTHsVmrAHXUKdHu_OwcrZoy-hgV7pk4UymtchGE5bGdUGA@mail.gmail.com>
 <CAOyeoRXFAQNNWRiHNtK3n17V0owBVNyKdv75xjt08Q_pC+XOXg@mail.gmail.com> <5CF8C272.7050808@intel.com>
In-Reply-To: <5CF8C272.7050808@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Thu, 13 Jun 2019 10:43:12 -0700
Message-ID: <CAOyeoRXPFgzthfO-Yz7L7ShO=jdYdsD7_UFPOrRFBtdA5jpf6A@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     Cfir Cohen <cfir@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we aren't using QEMU, I don't have those patches ready yet, but
I can work on them if you want to review them at the same time as this
patch. The architectural events (minus the LLC events) are probably a
reasonable starting point for the whitelist.

Eric


On Thu, Jun 6, 2019 at 12:31 AM Wei Wang <wei.w.wang@intel.com> wrote:
>
> On 06/06/2019 05:35 AM, Eric Hankland wrote:
> >>> Right - I'm aware there are other ways of detecting this - it's still
> >>> a class of events that some people don't want to surface. I'll ask if
> >>> there are any better examples.
> > I asked and it sounds like we are treating all events as potentially
> > insecure until they've been reviewed. If Intel were to publish
> > official (reasonably substantiated) guidance stating that the PMU is
> > secure, then I think we'd be happy without such a safeguard in place,
> > but short of that I think we want to err on the side of caution.
> >
>
> I'm not aware of any vendors who'd published statements like that.
>
> Anyway, are you ready to share your QEMU patches or the events you want
> to be on the whitelists?
>
>
> Best,
> Wei
