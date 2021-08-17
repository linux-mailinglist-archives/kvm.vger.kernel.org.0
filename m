Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EDA3EF563
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 00:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhHQWFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhHQWFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 18:05:43 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3FC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 15:05:09 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id x5so96320ill.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 15:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZqPgounEIER6ocdPyrnXbdW3TYtXZWjlNEg5NQfLK8=;
        b=hRJyAcxfN5jVh6JWF7HUfeYFRkenRRp99StwCAkKyZPNNfrG6a/NC4COGxHzCvLlQz
         I6UwnYV58HANPjcsP+De8UwFM5Ro/+lnePUBlXbAtenAkq9loOCb8XAkORhs6jI4ZD68
         HjF0Xog7zdzjiuNljLfPYFT4/jDtn/yRf8qCcxHpOO3ziLuB4ckrsfme7TtnCqMbiC7Y
         VtJo82ezAZwhl/nYkl5QBJzeKZOH8TlxLwSIIFupdoCetchMUzmC0kouyoQfT82UXGp2
         yRPAR2D5W993Yx9G7yITCkeSJdKh+JJ72NQnWSFLqq4CyOaaZy1o0BqO5Kl20wozqX1M
         b3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZqPgounEIER6ocdPyrnXbdW3TYtXZWjlNEg5NQfLK8=;
        b=SyOqnXw8uaNMA2UzMKFXMoe/rSthG1sM1l7XXzvOkBAwjwljssoQj4/bULXEtu/Cl7
         q/8h4uAGGSjqmAxu/4XvwuOYldydjxmGPTzavT45G1JVsWRvwPY/wOuYhUhN2oIEfcpu
         FK+3Xrk3woVMZR4EkKVnYgDcrA1faUxP4W8+00Qqg6zGtlWIHB4TPeg0/PsI3qe3wdC7
         Ejlb0VF276QhDV9pb8qOk7azWotoNjc98ATAg0GVP8204B8ZxjynqI9aHRDJyqiPK17O
         n9koD49zPUc0i5n0Lh9VBp8pWfmXGBYTWajYDcBq8F3dhILOjcjCMnPM9i/zNNASBtXZ
         HYzA==
X-Gm-Message-State: AOAM533h+kH9l72GssaJu/Pmby+VUMxECNyivN8SHHyftcegA6UKl3GO
        8J5N1avrou1V3phh7h0kmdtQbzoG9Gqjnbi9l4Z/9A==
X-Google-Smtp-Source: ABdhPJxlYq9gxQzuDtH+0kqvgJ74s7MMMkyqidnNO4T4Qi8RoJvXSbWnXgHR/zI+wGlJhp33pfEuo3XvpED6dR4bes0=
X-Received: by 2002:a05:6e02:688:: with SMTP id o8mr4088723ils.182.1629237908890;
 Tue, 17 Aug 2021 15:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com> <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com> <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
In-Reply-To: <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 17 Aug 2021 15:04:32 -0700
Message-ID: <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, jejb@linux.ibm.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        dgilbert@redhat.com, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 1:50 PM Tobin Feldman-Fitzthum
<tobin@linux.ibm.com> wrote:
>
>
> On 8/17/21 12:32 PM, Paolo Bonzini wrote:
> > There's three possibilities for this:
> >
> > 1) the easy one: the bottom 4G of guest memory are mapped in the
> > mirror VM 1:1.  The ram_addr_t-based addresses are shifted by either
> > 4G or a huge value such as 2^42 (MAXPHYADDR - physical address
> > reduction - 1). This even lets the migration helper reuse the OVMF
> > runtime services memory map (but be careful about thread safety...).
>
> This is essentially what we do in our prototype, although we have an
> even simpler approach. We have a 1:1 mapping that maps an address to
> itself with the cbit set. During Migration QEMU asks the migration
> handler to import/export encrypted pages and provides the GPA for said
> page. Since the migration handler only exports/imports encrypted pages,
> we can have the cbit set for every page in our mapping. We can still use
> OVMF functions with these mappings because they are on encrypted pages.
> The MH does need to use a few shared pages (to communicate with QEMU,
> for instance), so we have another mapping without the cbit that is at a
> large offset.
>
> I think this is basically equivalent to what you suggest. As you point
> out above, this approach does require that any page that will be
> exported/imported by the MH is mapped in the guest. Is this a bad
> assumption? The VMSA for SEV-ES is one example of a region that is
> encrypted but not mapped in the guest (the PSP handles it directly). We
> have been planning to map the VMSA into the guest to support migration
> with SEV-ES (along with other changes).

Ahh, It sounds like you are looking into sidestepping the existing
AMD-SP flows for migration. I assume the idea is to spin up a VM on
the target side, and have the two VMs attest to each other. How do the
two sides know if the other is legitimate? I take it that the source
is directing the LAUNCH flows?


--Steve
