Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885766A0F89
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjBWSfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 13:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjBWSfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 13:35:12 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BAC3B3F3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:35:10 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id m10so15100577vso.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 10:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3aoaYb7nna45J2CiXmr0/OoCloNPGdL3kFyB1h4mtg=;
        b=jCj+dZoFxxzUaMPmvj5JpARz5KC7OAzmfEjBubRdgSgpZo0gPgbIIaMDk8TdKd6ac2
         1u/B51AGOkz6IDZyF96vCHj9MWL4W8T8cCEfO1KDEv652fn8V5t294GBY+/Y9lJyetLN
         GAnxFpn2GsWeExejnqMX0i/qSBTWbgzLOY47ucp3r/0Q7IWIyGfs+oyPY6FmIEHthFxp
         x1V6a3CHzQXzc/AiUlVpspoHDTQ52AKGsA7RaEhRwMTWU5QbHFFJAg1qM6/m/E8iGAA4
         zRRqE9AWRBrMW/CVP69peHcgoVq+PjLM4Q2whQa/QhbAIhXI5S9sJDYuZ0HNey8baXK5
         PyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R3aoaYb7nna45J2CiXmr0/OoCloNPGdL3kFyB1h4mtg=;
        b=sw21MYeA1ZUeNzznS6srVm1sWIeN4ou9JWwdI42D5+g2KGH95ssdIwhgKFnz8T4IzT
         4UczR/oxC6KEUh1OhN31r8UaeC+IdtwHqI7fgQIkuKZB1MLcrat2mDvoz0kSO0e9SrFl
         Qd8Xq6MFsCWsMRvF5+PgbpBSKi/R7B4NPFe8Vy9F0J3cF2Ef4+HOvkVTgDigFlwSJbTB
         JWt9MCIcwhEBZCsyKQ1+rZwpTAidVuYMXjbKG+j0CPAr1El3ICY4zRjc2P0+pxX6XVZe
         xSgq2UZ4ObeWiFTnYmFOqSCabjrHgimWzmCITTt77lBzmVTSdzy+54Q9wxKOle0K2XoE
         +sIA==
X-Gm-Message-State: AO0yUKVSj6YHmHX+25pDDgMnY5+LZ8/lwTel2VgY2RCMjkN9gAUESqUB
        z731UomnRItE2vxiTReli61+6NGJoMsqD2V7/CGISQ==
X-Google-Smtp-Source: AK7set8MziVNDnEwhirxCtSzQkzlR2xXTlIFkFvt+M2EKaxLcFqsJW8+RDdsr+GQsS2XXD8mHYrFd1HoPptf+lvr4nU=
X-Received: by 2002:a67:fdc8:0:b0:402:9ba2:bc62 with SMTP id
 l8-20020a67fdc8000000b004029ba2bc62mr510076vsq.6.1677177309518; Thu, 23 Feb
 2023 10:35:09 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
 <Y/evPJg9gvXxO1hs@google.com>
In-Reply-To: <Y/evPJg9gvXxO1hs@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 11:34:31 -0700
Message-ID: <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 11:24=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 23, 2023, Yu Zhao wrote:
> > On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > I'll take a look at that series. clear_bit() probably won't cause a=
ny
> > > > practical damage but is technically wrong because, for example, it =
can
> > > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just fai=
l
> > > > in this case, obviously.)
> > >
> > > Eh, not really.  By that argument, clearing an A-bit in a huge PTE is=
 also technically
> > > wrong because the target gfn may or may not have been accessed.
> >
> > Sorry, I don't understand. You mean clear_bit() on a huge PTE is
> > technically wrong? Yes, that's what I mean. (cmpxchg() on a huge PTE
> > is not.)
> >
> > > The only way for
> > > KVM to clear a A-bit in a non-leaf entry is if the entry _was_ a huge=
 PTE, but was
> > > replaced between the "is leaf" and the clear_bit().
> >
> > I think there is a misunderstanding here. Let me be more specific:
> > 1. Clearing the A-bit in a non-leaf entry is technically wrong because
> > that's not our intention.
> > 2. When we try to clear_bit() on a leaf PMD, it can at the same time
> > become a non-leaf PMD, which causes 1) above, and therefore is
> > technically wrong.
> > 3. I don't think 2) could do any real harm, so no practically no proble=
m.
> > 4. cmpxchg() can avoid 2).
> >
> > Does this make sense?
>
> I understand what you're saying, but clearing an A-bit on a non-leaf PMD =
that
> _just_ got converted from a leaf PMD is "wrong" if and only if the intent=
ed
> behavior is nonsensical.

Sorry, let me rephrase:
1. Clearing the A-bit in a non-leaf entry is technically wrong because
we didn't make sure there is the A-bit there --  the bit we are
clearing can be something else. (Yes, we know it's not, but we didn't
define this behavior, e.g., a macro to designate that bit for non-leaf
entries. Also I didn't check the spec -- does EPT actually support the
A-bit in non-leaf entries? My guess is that NPT does.)
