Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A563AD42B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhFRVMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 17:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhFRVMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 17:12:23 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF5C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:10:13 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 102-20020a9d0eef0000b02903fccc5b733fso11020620otj.4
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9rQBy07hR6h/8YnMO4aW8n22/m9321T5uhKsZivCN8=;
        b=Z96Dp3+oG7YUNnMI39IlXqu+AAgrlRfkEgVZZUCPSxIhtiOYuOOwVCtfZzIqGuoq8e
         oAFenqxL/CLwD1UwLBWzlggnIPo4QNg4mvUo+PHnioMdgW6rZC3HRRMw0LAt0C1ppa5+
         ouCw3zP2pmT026y+8Vzng0INt9FtVOeuqdVDUTFS1opKQaO7AeO/s2T5Z1JCITfwxDtD
         YV8CAEi5+dY+irQe2YuXBts5vkDcLatXZ13MFETf0YM3Gh03bIcEClzXyYEGOyMJ0/oL
         lV4T8/Qwd9tKxLJxaKi7WwWfWGRz5PLR5+bp3uCqoyYATxmdu4AtcDtDM4o8e9+hWcZb
         7yzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9rQBy07hR6h/8YnMO4aW8n22/m9321T5uhKsZivCN8=;
        b=pRsZ1rYVdson8sfDtNEj+DIAYPPdntFf/V7mUboVh2cOR9qEa0Pvb/8J9vSE+VVI8Q
         nsXjbZfLWYyP8VgqZNszxh2j5JmWykVxtM0SIwi5WQVmCOpvebNbP4iOq/mXaHodjPne
         PevMhS4d/qVAoYjozVFnCnQfAVzS9dGd+7liSDHl4BM7Sa69ITDs1qp7MAI70WXKD+qo
         n0sWzhpI9hMClZYI0011T8PR/LUsfDLvEK+wLF7SVlDzhOE0uQU4QoZw03vcqXBWFIIn
         RygYNqGiY2NXWWmXA8ITVeujmxYahmoiYu2dFX9JVyy9fOPy3i7vW9sjON4VTeC1b6vr
         g+Dw==
X-Gm-Message-State: AOAM532gCxVWOC/8ipHTUqunjtFQHQeJ3h2IHL9VEST7sywWq0wlMH0Z
        qF7C8BpWg+ZBhL3daGD1eYNOiubNlG+090isoT6TMg==
X-Google-Smtp-Source: ABdhPJzN65M0+HD/1EuDG+OGMis4z5mWBVest3uMBh5BtXv6aSoh11V4fq53QbJ6Ey4X1mFoIAlro6pFHww+UNml5lY=
X-Received: by 2002:a05:6830:912:: with SMTP id v18mr11311659ott.241.1624050612325;
 Fri, 18 Jun 2021 14:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210618113118.70621-1-laramglazier@gmail.com>
 <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com> <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
 <CALMp9eT+2kCSGb5=N5cc=OeH1uPFuxDtpjLn=av5DA3oTxqm9g@mail.gmail.com> <CANX1H+2YUt6wF7P=jNBpfzJEnjz7Yz=Y8K_hWTwvYYbNb-vV2A@mail.gmail.com>
In-Reply-To: <CANX1H+2YUt6wF7P=jNBpfzJEnjz7Yz=Y8K_hWTwvYYbNb-vV2A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Jun 2021 14:10:01 -0700
Message-ID: <CALMp9eRDkfHHmRuRuRabRLcNBhudJwb+mhE=WD2tVR016Yq58w@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Lara Lazier <laramglazier@gmail.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 1:57 PM Lara Lazier <laramglazier@gmail.com> wrote:
>
> Am Fr., 18. Juni 2021 um 22:26 Uhr schrieb Jim Mattson <jmattson@google.com>:
> >
> > On Fri, Jun 18, 2021 at 12:59 PM Lara Lazier <laramglazier@gmail.com> wrote:
> >
> > > My understanding is as follows:
> > > The "first" test should succeed with an SVM_EXIT_ERR when EFER.LME and
> > > CR0.PG are both
> > > non-zero and CR0.PE is zero (so I believe we do not really care
> > > whether CR4.PAE is set or not though
> > > I might be overlooking something here).
> >
> > You are overlooking the fact that the test will fail if CR4.PAE is
> > clear. If CR4.PAE is 0 *and* CR0.PE is 0, then you can't be sure which
> > one triggered the failure.
> Oh, yes that makes sense! Thank you for the explanation.
> I will move it back up.

I think this may be subtle enough to warrant a comment as well, if
you're so inclined.
