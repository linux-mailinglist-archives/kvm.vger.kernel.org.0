Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC85F2AC35
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 22:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfEZUth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 16:49:37 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:38801 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfEZUtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 16:49:36 -0400
Received: by mail-lf1-f48.google.com with SMTP id b11so4173908lfa.5
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 13:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJg/yCjfVM3Ozhpb5ZCNN4WebegqjDbfI7FMAeP5e48=;
        b=GD3ZVbCtAZQtaJFSDPqrCMmGJBcOkN8aadPzlAK4DlrCkWV1mtFgYPxuS4XgVoIFNB
         07DttpIS7YSA6RHknmleBz7ZadImeyD5hn2YsmsOhxL1gJeJcYNAfteCCxReSzZW5Sy7
         HXffCAFYiq7pFrgWGoGWbWSP6Y+fjHTJprbE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJg/yCjfVM3Ozhpb5ZCNN4WebegqjDbfI7FMAeP5e48=;
        b=X+wMyVS54MyJGA3JEI9wx0EhFQvt4+GPPrLo6SYNRIx7f6Ju+WQdFScisWxOtx/v4A
         e0T5m0GUShhPVwT9sAOiMiEnSkBwyWyvZgZikoEefBy4FRwJJHZm0veEtTBVSmBGSjCI
         um5tFUEmQC1CsXd+Uus2XotbKGdz7Cul6/8mSxFwwHtPULK6HBHqMTqNqeZQLdeDN8Ap
         /ai+e3cSiJkCoREQ7xhTokJFjqhbEtGsEz0PwMFPt1QPOt+99aDNNd2P+R8OfvvTpvTz
         wvAa9UwwIA1abTOscVTBxbhHj01C0zkYI0uBEjPC/yU/muthA+JprkPToWnxd5/uopFE
         Fqvw==
X-Gm-Message-State: APjAAAXTBSqu4b7jwDkpIElJ8PTLn0vIAM8esauMkcQqidToN4M1SFSo
        l9W+LtGwwvM9EasmIS0AaqmuRyg+yvc=
X-Google-Smtp-Source: APXvYqygSwh83QeXQ8N9gTuaiUrSzAGxV9Btw0MYB2/XWexJkDJUed6JIKxbSpwPEYw3NPccpmCXSw==
X-Received: by 2002:ac2:5961:: with SMTP id h1mr6228386lfp.183.1558903774113;
        Sun, 26 May 2019 13:49:34 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id v12sm1839172ljv.49.2019.05.26.13.49.33
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 13:49:33 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id a25so724644lfg.2
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 13:49:33 -0700 (PDT)
X-Received: by 2002:a19:521a:: with SMTP id m26mr10136807lfb.134.1558903772902;
 Sun, 26 May 2019 13:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <1558864555-53503-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wi3YcO4JTpkeENETz3fqf3DeKc7-tvXwqPmVcq-pgKg5g@mail.gmail.com> <2d55fd2a-afbf-1b7c-ca82-8bffaa18e0d0@redhat.com>
In-Reply-To: <2d55fd2a-afbf-1b7c-ca82-8bffaa18e0d0@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 26 May 2019 13:49:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgzKzAwS=_ySikL1f=Gr62YXL_WXGh82wZKMOvzJ9+2VA@mail.gmail.com>
Message-ID: <CAHk-=wgzKzAwS=_ySikL1f=Gr62YXL_WXGh82wZKMOvzJ9+2VA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.2-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Junio Hamano C <gitster@pobox.com>
Cc:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Git List Mailing <git@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 26, 2019 at 10:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The interesting thing is that not only git will treat lightweight tags
> like, well, tags:

Yeah, that's very much by design - lightweight tags are very
comvenient for local temporary stuff where you don't want signing etc
(think automated test infrastructure, or just local reminders).

> In addition, because I _locally_ had a tag object that
> pointed to the same commit and had the same name, git-request-pull
> included my local tag's message in its output!  I wonder if this could
> be considered a bug.

Yeah, I think git request-pull should at least *warn* about the tag
not being the same object locally as in the remote you're asking me to
pull.

Are you sure you didn't get a warning, and just missed it? But adding
Junio and the Git list just as a possible heads-up for this in case
git request-pull really only compares the object the tag points to,
rather than the SHA1 of the tag itself.

             Linus
