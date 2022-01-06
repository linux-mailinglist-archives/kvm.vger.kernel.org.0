Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F4D486953
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiAFSBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242478AbiAFSBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 13:01:20 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06EC061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 10:01:20 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id t13-20020a4a760d000000b002dab4d502dfso845719ooc.6
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 10:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yd72dqLGjywYZ5iurvaOMSLfaNBW11uoIMA6hBdzT+w=;
        b=Ix3i8LiyqKdcPsMVObpv10gDeddenlWw1CHrRBunNHwQS5LCbLhaXIl8WaWSMYlGUY
         dC5EQeiJ/7xdSOF9JcQVBOYNnzBJuLAZWmZfWv5JGSzgXRniyow7HEWeRQu10Txkuanz
         17spWXZt+ul01MTwowzgzrkQ6RRcpS5SXUYaUSWmDSj32G4GB8ZD/Zv6+sCnu5bXyPcC
         vDmOgnHBW3YCC9egG/Str4FgSdAhWcQkPG0mDBPiCJvRDkvoFskfhbNqm+YkRxWqi6B9
         pEUj9CcSQwFyufZuyld70+9awo1aSY+frJfP8NL+fV44qXsTcnQH6Dr0payE780n1Ds9
         7TcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yd72dqLGjywYZ5iurvaOMSLfaNBW11uoIMA6hBdzT+w=;
        b=bjC9WPHXHOuewVK+klBHwXIHhHKZYuzXS95ZguZ78YL6lMcMRNXhfOkmegLQ4ZA2nA
         GzGLE+FfUT46W0byPbFfgFT0/FztD8/Zn7SeHMg7Y516BJLV5s0+Dd+YNYVf+EqK+lnD
         Mih8ffu1y8pKG49tQTNgQQfMH1TaImOpPHT4Oq1X+uITca8idxuNwX3f/LORiGIQtKGM
         bURneJ/9W2A2UTFqmABBnfTvUxkqP70+/He+DxeQRgrgvCDbGwjqC3Fzq0KBH68m2kF1
         T4sLLxiAiNDW7BU7YOYlDlmEHNeAOtd6TYumXU+7CbI6wbilF3blHirxHj+qWsCo9ktx
         tzpw==
X-Gm-Message-State: AOAM530HjNp3sBdDHVjajDS0vjAl04YG/rIKnVCB5P7rgETZ2S2ADh+E
        gj2sprAugCMP0L8ISBeaeJm+ZRdQMpZHxBz1iOFE+A==
X-Google-Smtp-Source: ABdhPJyruBzm9/8La0+52GslZWVrbis9fZrQAm0L5We+2hwsH+ZB9RbSZIde7gM5agGitMuOTFOyk37AI17MI50O+vg=
X-Received: by 2002:a4a:ac0a:: with SMTP id p10mr37659104oon.96.1641492078304;
 Thu, 06 Jan 2022 10:01:18 -0800 (PST)
MIME-Version: 1.0
References: <20211222133428.59977-1-likexu@tencent.com> <CALMp9eTgO4XuNHwuxWahZc7jQqZ10DchW8xXvecBH2ovGPLU9g@mail.gmail.com>
 <d3a9a73f-cdc2-bce0-55e6-e4c9f5c237de@gmail.com> <CALMp9eTm7R-69p3z9P37yXmD6QpzJhEJO564czqHQtDdCRK-SQ@mail.gmail.com>
 <CALMp9eTVjKztZC_11-DZo4MFhpxoVa31=p7Am2LYnEPuYBV8aw@mail.gmail.com>
 <22776732-0698-c61b-78d9-70db7f1b907d@gmail.com> <CALMp9eQQ7SvDNy3iKSrRTn9QUR9h1M-tSnuYO0Y4_-+bgV72sg@mail.gmail.com>
 <bf7fc07f-d49c-1c73-9a31-03585e99ff09@gmail.com> <CALMp9eQmO1zS9urH_B8DeoLp30P7Yxxp9qMwavjmoyt_BSC23A@mail.gmail.com>
 <212cea42-e445-d6f2-2730-88ccaa65b2cb@gmail.com>
In-Reply-To: <212cea42-e445-d6f2-2730-88ccaa65b2cb@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 Jan 2022 10:01:07 -0800
Message-ID: <CALMp9eQck0dPHU9qyY-kDE+mQWK4PUuhpkEFW7PH5BbCaptJ+g@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU frequency
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Thomas Gleixner (kernel-recipes.org)" <tglx@linutronix.de>,
        "Borislav Petkov (kernel-recipes.org)" <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 5, 2022 at 7:29 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 6/1/2022 6:51 am, Jim Mattson wrote:
> > On Thu, Dec 30, 2021 at 11:48 PM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> On 31/12/2021 9:29 am, Jim Mattson wrote:
> >
> >>> At sched-in:
> >>> 1. Save host APERF/MPERF values from the MSRs.
> >>> 2. Load the "current" guest APERF/MPERF values into the MSRs (if the
> >>> vCPU configuration allows for unintercepted reads).
> >>>
> >>> At sched-out:
> >>> 1. Calculate the guest APERF/MPERF deltas for use in step 3.
> >>> 2. Save the "current" guest APERF/MPERF values.
> >>> 3. "Restore" the host APERF/MPERF values, but add in the deltas from step 1.
> >>>
> >>> Without any writes to IA32_MPERF, I would expect these MSRs to be
> >>> synchronized across all logical processors, and the proposal above
> >>> would break that synchronization.
> >
> > I am learning more about IA32_APERF and IA32_MPERF this year. :-)
>
> Uh, thanks for your attention.
>
> >
> > My worry above is unfounded. These MSRs only increment in C0, so they
> > are not likely to be synchronized.
> >
> > This also raises another issue with your original fast-path
> > implementation: the host MSRs will continue to count while the guest
> > is halted. However, the guest MSRs should not count while the guest is
> > halted.
> >
>
> The emulation based on guest TSC semantics w/ low precision may work it out.
> TBH, I still haven't given up on the idea of a pass-through approach.

I believe that pass-through can work for IA32_APERF. It can also work
for IA32_MPERF on AMD hosts or when the TSC multiplier is 1 on Intel
hosts. However, I also believe that it requires KVM to load the
hardware MSRs with the guest's values prior to VM-entry, and to update
the hardware MSRs with newly calculated host values before any other
consumers on the host may read them.
