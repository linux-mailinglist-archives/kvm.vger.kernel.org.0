Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3975A41B6E3
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 21:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbhI1THZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 15:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242218AbhI1THY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 15:07:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28375C061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 12:05:45 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id s20so28755594ioa.4
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 12:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LYaPMO4zSUN63L5x5xUSR1CDiXdGr7bJrgBZxfWWnRM=;
        b=SGJcdHCygArkZYEIETz/wT+50dTV5xtQ1lZdrl9rOa78dS1YvLlQOq3YOhDQdB97q1
         zo8M2ixafgU9SNvjwIFhI1+ygeNugw2tAsCo1DtZ9Ns6CFBTlUYmpgmZbNEO8VsSohge
         qr7r/bBX45IiZeZC78iRqPy0U2KLBmJgPya+Hj8/CIo4U221V03qlABGqt5MjPF1O7Te
         a3MTnKC+oOm0rCt+xLVcKP8X84tunJnE0eu2WPvm/uyOSlzgrEh6u702TQ35iyneOI4b
         Sq2Y06PbIVovlsYid4ZzH/6ZdKBPO7LUN76gbJWOg/6+4RsAFF9vK/0dTYWDpAOkGyK/
         jvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LYaPMO4zSUN63L5x5xUSR1CDiXdGr7bJrgBZxfWWnRM=;
        b=ihIbl2iBydzu4q22Y/2PkApgbcRYhmEHBjFo/N6AKK+lOf6ZdWS50XIF68N12QHZqw
         4hBcYikexIVKOHSTCuzO3/4T7MfwDkFHICqPFDiCGToFQBoWXxb3SDvrAw0NRDXwyDe3
         s9ARyi7VHpiAUc042uvtPfiNdJn0jB49mG70URruGki2ibQrMBH2Oi5EPAZsdy0RjH1G
         uh18srjRHy6guLK2Kc1G9oA3LuB/OlinHh5VQXsvQpHCJPti2PT9id1b2UrfK4GWOAnI
         pZr6MJkIAWwAEzM2jS979s6cCM5/TZTJmYULHQg4aTWh6QWtwBRWyUCd8Y2Om9y/b8FU
         5saQ==
X-Gm-Message-State: AOAM5318aQz3BKS23DrvLBMzWsoI97WbiLFYr/wDc2GpYKMfy8WJOnh5
        tg675rbxDsVm9Sm0BzGv5VIJms8rWjHSN9djookoxQ==
X-Google-Smtp-Source: ABdhPJye2c2rTcBY5maCu7+X+UzMZCbOkZHYNLHHfukiFlEG7A9xzy/JQd4I8fBvuBH8ndBmeHVokOpMGnvyAvT8xO4=
X-Received: by 2002:a02:5444:: with SMTP id t65mr6164748jaa.42.1632855943923;
 Tue, 28 Sep 2021 12:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629726117.git.ashish.kalra@amd.com> <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com> <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com> <YUnxa2gy4DzEI2uY@zn.tnic> <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic> <20210922121008.GA18744@ashkalra_ubuntu_server> <YUs1ejsDB4W4wKGF@zn.tnic>
In-Reply-To: <YUs1ejsDB4W4wKGF@zn.tnic>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 28 Sep 2021 12:05:07 -0700
Message-ID: <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 6:54 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Sep 22, 2021 at 12:10:08PM +0000, Ashish Kalra wrote:
> > Then isn't it cleaner to simply do it via the paravirt_ops interface,
> > i.e, pv_ops.mmu.notify_page_enc_status_changed() where the callback
> > is only set when SEV and live migration feature are supported and
> > invoked through early_set_memory_decrypted()/encrypted().
> >
> > Another memory encryption platform can set it's callback accordingly.
>
> Yeah, that sounds even cleaner to me.
If I'm not mistaken, this is what the patch set does now?
