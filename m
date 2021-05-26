Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC9391E8B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhEZSBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 14:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhEZSBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 14:01:44 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA6AC061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 11:00:11 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id v5so2804483ljg.12
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 11:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ptbI5tz9XBdYPftEDY0qKo9MsngePWT8iban+TeYECw=;
        b=fgzFyIbUvpimtFixrGScYC/0WaJ29GeETd9J3p5j2wpRLZhACzkwvZI815YnS80gRf
         rgnuLDyvQINnLbWyvO+BEcxdf8+bXBg4x52eMN2BGQCC4VA+c1tXaU8WBmGzgbB8Tw1+
         zWqjVgyCO4D29KvaTzA9tlRK1HQserL4lAqsruhWU4IJkzR4MUumBwx84jVIzF+BmBSm
         6+R6M10VtrDLSEKgIU6kDld1Pv1C2pBahzPRjGiirkk0JvLIKjE9tkrhC5dy8k//D4ok
         6f4nZyBkY2AI6czrBJwn1+/BtCX44yx6T8QN0VF+39bqv7FXXRSNj0qMGhGfBbm99jry
         EO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ptbI5tz9XBdYPftEDY0qKo9MsngePWT8iban+TeYECw=;
        b=YowLKo+5gSguN/PSzVVsL/9zeYnq/DsQ7umeuvlIisB8PuHwH1+K4jeQYcV+lDXuKA
         63lr8lGfZlf38N+pu2Z+inKA+6CEGDVA85mx4Bwi92gRXNCJIO3nV2lgSLzlgLk7Pu/r
         SlY/F719JdFd8TYpZ/LkWeo5tFV+O+Isj6gl12XasrQ5shpkQFH0hFhro7m1qJHiYO5u
         1BMIaFzRivCGcHxXXEPC2u9SiC8CandhETq0uh9TA/iu+pVqpeOxGWqNQmkGs1qZXquo
         xJLPCmY1oEdXEbjiD4fyDaXsd1elA9J8TJOQINAXEszCAFzMi0E8oBKrKwAf5NGrdnuC
         RG1A==
X-Gm-Message-State: AOAM531j3oMDqNNO8dc9uWepgQGjbEzYJOKvSsm8O2UkO2JAOkoM6TrZ
        YMQ3qQolU3Ld+qSjwme7RHfmJaaYT5hQMYu5YZkCCA==
X-Google-Smtp-Source: ABdhPJzRzLHFNHKe87i+8KaZPBdGEPN7vGbVPE11i9FMJXjoAzSUTCK5vMu1I5LH/hTKKE6eaW4P+XpGNqgCKRX41u0=
X-Received: by 2002:a05:651c:14c:: with SMTP id c12mr3258998ljd.72.1622052009944;
 Wed, 26 May 2021 11:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210526163227.3113557-1-dmatlack@google.com> <YK6FdtswnFklJuAO@google.com>
In-Reply-To: <YK6FdtswnFklJuAO@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 26 May 2021 10:59:43 -0700
Message-ID: <CALzav=dsgEP6cdfLic_7ffjf22Z8R8LTrJODyVWw3HqSZR4zFQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 10:29 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Put version information in the subject, otherwise it's not always obvious which
> patch you want to be accepted, e.g.
>
>   [PATCH v2] KVM: x86/mmu: Fix comment mentioning skip_4k

Got it. My thinking was that I changed the title of the patch so
should omit the v2, but that doesn't really make sense.
>
> On Wed, May 26, 2021, David Matlack wrote:
> > This comment was left over from a previous version of the patch that
> > introduced wrprot_gfn_range, when skip_4k was passed in instead of
> > min_level.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
