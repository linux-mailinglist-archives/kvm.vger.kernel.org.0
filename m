Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179E9371E42
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhECRSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhECRR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:17:57 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63607C06138B
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 10:17:03 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso459460wmh.4
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 10:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rrP1AGyxKsa+ORBfD+mOvtRMENmltFb1LCD+9ApmG0=;
        b=gXKonJqka8sqoJObWITpaycdkvshAufcCfDxLc8W98tG27c4CUdmMTVQMR0HN/0oAk
         kMMi8HuZ9xPD5wcqG7wEIcCX07bsY/RKlHElhcD3tC0CGPd5ebXIPh371iGvj2kaddbY
         qn7eXtPA+l9288tNAE3a6sox2UQcFdSiS7i0dKX69AOkz8CwJremrUuUKN/Cq0oLjfgn
         BL3reuKxc5XFaoe0QgvAQG/h7xx3klU4Kz9iMn2iy+4K5yRVo3sYvDtXjH6rDnp/eGOg
         GZLSx/DGfrkPOIeMCkmR/fRQ5xXX1OdDqD/c+plOfrS2mBlf5lA+3rvvYLSmeuYK3Opc
         fxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rrP1AGyxKsa+ORBfD+mOvtRMENmltFb1LCD+9ApmG0=;
        b=pySdyRd/ZURAvJN13TmA44FrXn2uhZJvqhbAtNxVcIKe1jwy2pqzUO/PHS5gqKkGe5
         zpfWBdQbQ+YM7AT0Ob0sOekZCKr5L3XURHLjigdshHlFF4EDBKGppbJ8k0KTgICEduZI
         viX9ZvQZPmnXkh4jkBGOQjTQUeWihabFXrxyOnkfLoXDQL2QUUXdeS6ZogVZPg+KJf1V
         vCKuWC0VG6Mbat+hXWH3O5ogj+939AC2xAuYMMiJDicIPlzePklLteI0YmiuOeMCOdvf
         +MnyfOQFsbvZrs7m5HHZB3pTBTafcJOeD84EHDVWAdC8jA6hLD/8PV+cEjSTBGWF0vbS
         WUsA==
X-Gm-Message-State: AOAM532YtMFc52eHEN6zglFqyYDRxcghg1cnvsx/sF3Nmlj9w8NO21gy
        +OYyxXI60Wp8uBMn6Ca+OZT1zr9ReQzLbyERK+k7ag==
X-Google-Smtp-Source: ABdhPJyXdJUj84E7Uv4uu25254Z3uDOLGRy8E03EaLYTmVw+l6NFgHRLcNSv0kEIbIqINvXWZlqNA2g8jPSSr11hp4M=
X-Received: by 2002:a1c:9a8a:: with SMTP id c132mr18953323wme.48.1620062222096;
 Mon, 03 May 2021 10:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210428230528.189146-1-pbonzini@redhat.com> <61aa0633-d69c-f1b6-dc9f-6ca9442fbbab@redhat.com>
 <20210503152554.GA1697972@xps15> <a09e313e-83f2-b9df-f2f0-468a283be07d@redhat.com>
In-Reply-To: <a09e313e-83f2-b9df-f2f0-468a283be07d@redhat.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Mon, 3 May 2021 11:16:51 -0600
Message-ID: <CANLsYkzvhA41kzVymE7HR-6LULOXRFvgDRD6TXN2ROAANBKNYg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM, AMD PSP and ARM CoreSight changes for 5.13 merge window
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 May 2021 at 10:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/05/21 17:25, Mathieu Poirier wrote:
> >> Mathieu, can you confirm that your coresight branch will*not*  be sent by
> >> the ARM maintainers as well?
> > Confirmed.  Marc's tree is the only place where the ETE-TRBE functionality has
> > been added.  It was specifically done that way to avoid having the same code in
> > multiple branches and prevent merge conflicts.
>
> Thanks for confirming!
>
> Generally, what we do for x86 is exactly the opposite: the basic
> functionality is committed to the x86 tree, and then merged in _also_ by
> myself.  For example, this pull request includes a topic branch provided
> by the cgroup maintainer and one provided by the x86 maintainers, but in
> both cases they _also_ sent exactly the same commits to Linus.

The above works if all subsystems are pulled-in directly by Linus.
But for CoreSight patches flow through Greg's char-misc tree, which
would not have worked for the ETR-TRBE patchset due to dependencies
with the KVM/ARM tree.  As such I don't think we could have done
things differently.

>
> It works well because git is pretty good at avoiding conflicts when the
> same branch is present in multiple branches.  Instead, cherry-picking
> introduces lots of merge conflicts.
>
> There are other advantages in doing that.  For example, in this case I
> didn't (and don't) quite know what ETE and TRBE are, beyond what a quick
> Internet search tells me.  Sending this functionality to an ARM
> maintainer that is more acquainted with the feature would ensure that
> the new functionality is documented properly in the tags and therefore
> in the commit messages.
>
> This is what Linux was mentioning when he said "Pull requests need to
> have explanations of what they pull - not just because it needs to go
> into the merge message, but because the maintainer needs to keep track
> of what's happening".  In this case, the maintainer was me; based on my
> own workflow and due to the lack of commit message I assumed that the
> branch was also going to go through the ARM tree (and doubted my
> assumption only when sending the pull request to Linus, i.e. way too late).
>
> I am also guilty as charged of the "Merge branch 'kvm-sev-cgroup' into
> HEAD" commit message, where I should have pointed out that Tejun had a
> later branchpoint from 5.12-rc than I did, resulting in conflicts.
>
> So Marc, let's heed Linus's advice and document all topic branches that
> we merge into the KVM/ARM and KVM/x86 trees, including whether they also
> go into other trees---which they should do almost all the time.
>
> Thanks,
>
> Paolo
>
> > Let me know if you need more information.
>
