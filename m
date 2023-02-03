Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3767B68A5D5
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 23:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjBCWLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 17:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjBCWLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 17:11:39 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8526BB3DF5
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 14:09:38 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d132so7994921ybb.5
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 14:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w6DST1msg//zK6dqyeoLsLRtE2+Zc6NidDMAyM3y9l4=;
        b=b7STVl52IVA9hkjASfhfcXCUlfa/SPSFSi9vp21EkIFJnD/dktb8krAwZczgf2oE59
         Q4aGScOqwoNq6T99frVjRBWEhngy424X7jQ3nPPQFP/A3ri8C1D6xX06CY0Y5gBilCWT
         UPLbJtWci1TypWVcHBmh+AzKTuORzwWhNt8OqYmPYsQ7/GTXEs4xeDdr2QfQWGZjh1zn
         vp/syqO1Wq//OeM+JpwWxOef/mMWrzMDGNxK4zmYEsUdF7+HBlIFNxkCW/LHwkefJXOW
         0k+hJtMN0uzn6/aN/ymW5mOONqS842ZhaZCCrQ3XVbc2oUlC/F4khqT4i3Fgz1WO+0ug
         N/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6DST1msg//zK6dqyeoLsLRtE2+Zc6NidDMAyM3y9l4=;
        b=S2Q8QqAOqlmnzVU+nUAEuStlI5BQPOcfXlYwyFbj+WLUQCOy02M3Z5UXF+ZlQYMV+N
         pqZs2Z3tfYgM0PyC/+WR5WX3LLSlKL3DVke67of8MlJB7d5atUxl+JJ46Wq9f3BgeoSH
         xOxjf4KFFdpATmeYPUds4EQ3Oc2aYDtRYYgO+/QtPYZVBCxGaBl7lbJfvU1qpS+wSj2u
         FVKohmEir39E+2z49pors2xPHaCKyeDw0gL29Fg1x1bsk+5zBxwqrbct1TJU7ybAYRbJ
         SeAXYT9z5I5umeikgLK0CvQjHinruKyq5mG5MX+loLG8T9noWaKWuDqTrAan1rm/RgSQ
         Y61g==
X-Gm-Message-State: AO0yUKWooGnuSLvMeGT6j/poNojWv2wVozMg1Z1e9ygUq7bKCkSNor98
        vIxjj17txp5d53efS7zro3CpGSv18ydViWUpjUv07g==
X-Google-Smtp-Source: AK7set/dYbftPq3C5etClfX4WoO8g9dNllRTOgBQiziRssFh3DeIdQGLyRovOAPyjbGGuqBDH3ZJ05/Jr8WM2IjR0fA=
X-Received: by 2002:a25:dd04:0:b0:80b:69f5:3966 with SMTP id
 u4-20020a25dd04000000b0080b69f53966mr1312029ybg.519.1675462142547; Fri, 03
 Feb 2023 14:09:02 -0800 (PST)
MIME-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com> <20221212183720.4062037-13-vipinsh@google.com>
 <Y9r0q9cuK/ifu+OW@google.com> <CAHVum0fEmEAQSxozb1BTTy-d3UGrsvhjt8V5FXQPrX5wOYqpPQ@mail.gmail.com>
 <Y9wGQx89zI3TMU1Y@google.com> <CAHVum0dFG6gFTQ=JzMkX5Yw-BO7jtUEQyVww6TpN9wk_hQMpqw@mail.gmail.com>
In-Reply-To: <CAHVum0dFG6gFTQ=JzMkX5Yw-BO7jtUEQyVww6TpN9wk_hQMpqw@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 3 Feb 2023 14:08:26 -0800
Message-ID: <CAHVum0cDxK=wmd+UB9meZVm5h3tcGdkDJL=fK_jx19NhfikBSg@mail.gmail.com>
Subject: Re: [Patch v4 12/13] KVM: selftests: Make vCPU exit reason test
 assertion common.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        m Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Feb 2, 2023 at 10:59 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Thu, Feb 2, 2023 at 10:51 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Feb 02, 2023, Vipin Sharma wrote:
> > > On Wed, Feb 1, 2023 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > I love the cleanup, but in the future, please don't squeeze KVM-wide changes in
> > > > the middle of an otherwise arch-specific series unless it's absolutely necessary.
> > > > I get why you added the macro before copy-pasting more code into a new test, but
> > > > the unfortunate side effect is that complicates grabbing the entire series.
> > > >
> > >
> > > Make sense. So what is preferable:
> > > 1. Make the big cleanup identified during a series as the last patches
> > > in that series?
> > > 2. Have two series and big cleanups rebased on top of the initial series?
> > >
> > > Or, both 1 & 2 are acceptable depending on the cleanup?
> >
> >   3. Post the cleanup independently, but make a note so that maintainers know
> >      that there may be conflicts and/or missed cleanup opportunities.
> >
Small question:
Will it be fine if I use the current kvm/queue head or do you prefer
if I take one of your kvm-x86/linux branches?
