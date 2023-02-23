Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77DD6A1004
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjBWTCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBWTCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:02:43 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3674DBDB
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:02:41 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id d7so11479742vsj.2
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BehNjNr/+dUxmpuFq2DtkAvQP7yK7v98nPDghIFQheY=;
        b=qBTuRujlvCa1VgF13+Ud5voDEv0Q9s+atY0zVj2JYk9FiZWoLxhWXRpAJXyIzrim5w
         f+xS7avGfjvvGDxpRiJfIop5uZFSmQbUhiuEHUwLF8lmT75u4h6jwYfZYix0l5oKm0n8
         01JZrrnbVqjuYQeeGAqe+qGSzs3xRAnVpo0FM0OQEyk76yvi0N68VRkv3yDf6aS8eKYM
         Yz5hQW8ZjbU4RJ+5Rgvt8ZQpO6vql2HM/mJBiV/J+VEhgrmp/S+g+H88b6V/rs8lo71z
         djQQH1BHv98oah+DOIANnbXcpil5WQ0qSt5u+yI6+vaPMHi3OyELJdFhefr6sUFfgv9d
         FCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BehNjNr/+dUxmpuFq2DtkAvQP7yK7v98nPDghIFQheY=;
        b=rt8MfgC+YxjSbh/59FXUkVD7Y+rI7fIxr6UV1LHPxxJT/5U7u+cFX2x29lsGBRfoOT
         k26cgw48jkzHPg1HSDuHWPyZGuKeO8EE6+A5EusFRcykMjE101tk+y8q8rrJqdyB5l3D
         gU/xhxHH9fEpi41mlzCbP4k/hXuIEVDmLOWHDVq9hkoP8uq/rOqrovJo/Trtv+rvc9ys
         9uXqvkNFKKMcdoiAqKsR/oHxth6zBd1kefqYPgoZajp5tWAAXLqMXnOMviybOtwJzfOr
         l6WCBRUDHMgIaDlX6uqgU3bvkNRs6VSXgZVoPr5CMUbtSa6egZqjNKBexu4m0/0/tgnS
         uDFA==
X-Gm-Message-State: AO0yUKUdKY5xbcM7vmXCUUNAOU0pC3q3l43J5erC+1E/javStkalxGN8
        xYESYQMlo/6k87psm4JtG0As98oNrq7L7xwKf8VTqg==
X-Google-Smtp-Source: AK7set/Hhw/cCSkdxYcIh8mHlA+djGYcnBHqhr6GbdkbHFHfRZfMKdXhnPCa3oQXStWL9Hm3w7gevCyr1XzyoL4fUiY=
X-Received: by 2002:a67:c597:0:b0:402:9b84:1be4 with SMTP id
 h23-20020a67c597000000b004029b841be4mr587075vsk.6.1677178960791; Thu, 23 Feb
 2023 11:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
 <Y/evPJg9gvXxO1hs@google.com> <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
 <Y/e006bZOYXIFE/j@google.com>
In-Reply-To: <Y/e006bZOYXIFE/j@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 12:02:02 -0700
Message-ID: <CAOUHufbhKsWzXZP_VgOTVkKgZhU=LaXJBRKcaAk++d6sLk1ktA@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 11:47=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 23, 2023, Yu Zhao wrote:
> > On Thu, Feb 23, 2023 at 11:24=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > > > I'll take a look at that series. clear_bit() probably won't cau=
se any
> > > > > > practical damage but is technically wrong because, for example,=
 it can
> > > > > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just=
 fail
> > > > > > in this case, obviously.)
> > > > >
> > > > > Eh, not really.  By that argument, clearing an A-bit in a huge PT=
E is also technically
> > > > > wrong because the target gfn may or may not have been accessed.
> > > >
> > > > Sorry, I don't understand. You mean clear_bit() on a huge PTE is
> > > > technically wrong? Yes, that's what I mean. (cmpxchg() on a huge PT=
E
> > > > is not.)
> > > >
> > > > > The only way for
> > > > > KVM to clear a A-bit in a non-leaf entry is if the entry _was_ a =
huge PTE, but was
> > > > > replaced between the "is leaf" and the clear_bit().
> > > >
> > > > I think there is a misunderstanding here. Let me be more specific:
> > > > 1. Clearing the A-bit in a non-leaf entry is technically wrong beca=
use
> > > > that's not our intention.
> > > > 2. When we try to clear_bit() on a leaf PMD, it can at the same tim=
e
> > > > become a non-leaf PMD, which causes 1) above, and therefore is
> > > > technically wrong.
> > > > 3. I don't think 2) could do any real harm, so no practically no pr=
oblem.
> > > > 4. cmpxchg() can avoid 2).
> > > >
> > > > Does this make sense?
> > >
> > > I understand what you're saying, but clearing an A-bit on a non-leaf =
PMD that
> > > _just_ got converted from a leaf PMD is "wrong" if and only if the in=
tented
> > > behavior is nonsensical.
> >
> > Sorry, let me rephrase:
> > 1. Clearing the A-bit in a non-leaf entry is technically wrong because
> > we didn't make sure there is the A-bit there --  the bit we are
> > clearing can be something else. (Yes, we know it's not, but we didn't
> > define this behavior, e.g., a macro to designate that bit for non-leaf
> > entries.
>
> Heh, by that definition, anything and everything is "technically wrong".

I really don't see how what I said, in our context,

  "Clearing the A-bit in a non-leaf entry is technically wrong because
we didn't make sure there is the A-bit there"

can infer

  "anything and everything is "technically wrong"."

And how what I said can be an analogy to

  "An Intel CPU might support SVM, even though we know no such CPUs
exist, so requiring AMD or Hygon to enable SVM is technically wrong."

BTW, here is a bug caused by clearing the A-bit in non-leaf entries in
a different scenario:
https://lore.kernel.org/linux-mm/20221123064510.16225-1-jgross@suse.com/

Let's just agree to disagree.
