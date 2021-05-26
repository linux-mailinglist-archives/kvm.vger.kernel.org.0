Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFE391FAD
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhEZSxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbhEZSxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:53:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A06CC06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 11:51:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11so1340312pjm.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 11:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JUQMqFWMF9OsPMjr/8zQdKceWkWn6w3pQ1sepukRIDE=;
        b=EltVmmIyDtrKcE3lSfAlwzqdZzZlvMPC/5LQthNTa/UiG2iPgNrx/OQEhIcH9RUPdP
         YmB0M477D/HWOaQAajuLvbk1G+l0rR8c1HnHWFRlnbj8OkdnnsQMDnukdIhxCSGK5ar2
         aFz7RyET4i9ZJJts6iXM0euGqAhj14p5DNt6hlLpyCSc1BBWwrK0cq1TM5L0vZnzkD8t
         3cQu+bFfUWaN9/RlaJEEb14TMXAu/EI4z9G8Jrou0li2n9e463hRhZbsCcuMZb9ey/nH
         NCwDO24ddcU1HruSBqtlmcrQftXyYmQu2D9JKOFwJXBQVwaekjmHNo6CA44B3BxNY2P+
         o0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JUQMqFWMF9OsPMjr/8zQdKceWkWn6w3pQ1sepukRIDE=;
        b=MpRl+l4E+GPr9KrULuCltcYtwZuorpCPCVfbn1apU88VwgvcqlbxLQaN3QJpWHACIP
         yY8OFiuo5IQaAVTgA+iuk1cUZu376oHj7s6nGYuU8VKJW6E+PGo34kcvLqD2CMkNB8jr
         bW+9jYUWQsrvYnt+61Z9geD8bzOVEVdlh69lDwNpRzcKcfRoJfKEl0oaaWF1p/VE3LSm
         O8nli/H5LOXhERRY1WS6aaJJiQ+9tfCjoIixmbGuAA+or69TLOok1pac+DyIa07hzi1i
         5ISuoqfmdGJpb6aSZCLieuWVRtNr8ymTG4nDw2kMN0koWDud0wMEb06q/WR15TD5KO8y
         Z44A==
X-Gm-Message-State: AOAM533X1T/oHoJp6CqXGSIBhG/1/4qBqPxoLSjfRaheYMjgPE8i4RUJ
        PmaZp347tg6EA5qIzzmDSWFLMM0WEDqCxA==
X-Google-Smtp-Source: ABdhPJzw6NTJlJLDXOtwM0Fn21BEDJBmh9TNOKv8CgcT6i65WcEHg9z4o1N36Y1EB3dYYLHKbhTPyw==
X-Received: by 2002:a17:90a:7896:: with SMTP id x22mr5404377pjk.11.1622055110031;
        Wed, 26 May 2021 11:51:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c12sm16282814pfr.154.2021.05.26.11.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 11:51:49 -0700 (PDT)
Date:   Wed, 26 May 2021 18:51:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
Message-ID: <YK6Ywl57/FXqcSR0@google.com>
References: <20210526163227.3113557-1-dmatlack@google.com>
 <YK6FdtswnFklJuAO@google.com>
 <CALzav=dsgEP6cdfLic_7ffjf22Z8R8LTrJODyVWw3HqSZR4zFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dsgEP6cdfLic_7ffjf22Z8R8LTrJODyVWw3HqSZR4zFQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, David Matlack wrote:
> On Wed, May 26, 2021 at 10:29 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Put version information in the subject, otherwise it's not always obvious which
> > patch you want to be accepted, e.g.
> >
> >   [PATCH v2] KVM: x86/mmu: Fix comment mentioning skip_4k
> 
> Got it. My thinking was that I changed the title of the patch so
> should omit the v2, but that doesn't really make sense.

Ha, yeah, the version should get bumped even if a patch/series gets heavily
rewritten.  There are exceptions (though I'm struggling to think of a good
example), but even then it's helpful to describe the relationship to any
previous series.

It's also customery to describe the changes between versions in the cover letter,
or in the case of a one-off patch, in the part of the patch that git ignores.

And my own personal preference is to also include lore links to previous versions,
e.g. in this case I would do something like:

  v2: Reword comment to document min_level. [sean]

  v1: https://lkml.kernel.org/r/20210526163227.3113557-1-dmatlack@google.com

Providing the explicit link in addition to the delta summaray makes it easy for
reviewers to see the history and understand the context of _why_ changes were
made.  That's especially helpful for reviewers that didn't read/review earlier
versions.
