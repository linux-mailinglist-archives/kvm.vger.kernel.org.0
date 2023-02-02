Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CEF688740
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjBBTAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjBBTAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:00:05 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A803F23DA9
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 11:00:00 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id a1so3449302ybj.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 11:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zucP5W+kwXs2wiOU2Sh4NohAzbi8BWE0Est2e19KOc8=;
        b=oyfQ/DxlBU5iqPI5J355NstJZiS/2w5w667LGC5Pq/jckdlknwRq2GUEw7hhl4s3F9
         mzgxDsyuuFC0dxSJG9B1ITkemEZt0sw+TdDz2Zz/+uQsoy0kgvO2pz3pP8Z2eYrto7AA
         jU82FkHc+WgVaEJ9OcJcKXMQMZaNiOr/wxXegsL5aMpteM4lKaaLCs5IMLQyMKvP+LJg
         2b0GRzBHlq/JwR1yHEEE7o0wEJXPkQokCPKG4x+76CYUnfNqNL9JqgmFY22ueybAsGHM
         getdlATwZMjtHGL2kWD92LjTOXstd2W0HCWPf+6PjY0viazt1iHfoX/OtNEruIY0SpX8
         f6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zucP5W+kwXs2wiOU2Sh4NohAzbi8BWE0Est2e19KOc8=;
        b=l6BskEQU7Pt8pWDlkll2lHPpBGcDVbgGBEPeWvSQFWSIGu1wiKObU8YFMUHeEy/1/V
         mzDmnCh4Cj9GXU6fMF/i+V1eqg1X3tEMxr5kcbjszXUfPstOX2YCP+yzLiafp0kODaFJ
         BvYk/D+VAuJeladVsaONmWy6Rsj2U6sTOzRPGdZLlsE/cpChCWqim/yOXgeFnTot2kkn
         anJPNQzfM+GDWDSspZpzLYQDHGlsImi4oy8mVDOQUEZP4nR40jH1zI3zbepLj47RoSyP
         91v6xm3lHUtTLuziUmLPLoSCfWLLNzJoYt4kQk9y7EE2axOKqaqlP1o58dy2Hn1OHw6T
         UQrA==
X-Gm-Message-State: AO0yUKXlX3FTXYzQbzX0n6ocp5iWhF9q8gzaMsKcKne1/7HkboDdCbbC
        UHJs1f1b6r3TWnhrYkTSZIpdaLoiYvG/VuCwOMjY8w==
X-Google-Smtp-Source: AK7set8Ytzp0jBxVYOcrX38K1GrWjc9umSJtTBsYYTDsmEjNKL4yKxif7vSXGi1MSwilFo2BtIJo7NtzBxYb16fdJbE=
X-Received: by 2002:a05:6902:10f:b0:80b:72cc:3967 with SMTP id
 o15-20020a056902010f00b0080b72cc3967mr878863ybh.123.1675364399629; Thu, 02
 Feb 2023 10:59:59 -0800 (PST)
MIME-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com> <20221212183720.4062037-13-vipinsh@google.com>
 <Y9r0q9cuK/ifu+OW@google.com> <CAHVum0fEmEAQSxozb1BTTy-d3UGrsvhjt8V5FXQPrX5wOYqpPQ@mail.gmail.com>
 <Y9wGQx89zI3TMU1Y@google.com>
In-Reply-To: <Y9wGQx89zI3TMU1Y@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 2 Feb 2023 10:59:23 -0800
Message-ID: <CAHVum0dFG6gFTQ=JzMkX5Yw-BO7jtUEQyVww6TpN9wk_hQMpqw@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 10:51 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 02, 2023, Vipin Sharma wrote:
> > On Wed, Feb 1, 2023 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
> > > I love the cleanup, but in the future, please don't squeeze KVM-wide changes in
> > > the middle of an otherwise arch-specific series unless it's absolutely necessary.
> > > I get why you added the macro before copy-pasting more code into a new test, but
> > > the unfortunate side effect is that complicates grabbing the entire series.
> > >
> >
> > Make sense. So what is preferable:
> > 1. Make the big cleanup identified during a series as the last patches
> > in that series?
> > 2. Have two series and big cleanups rebased on top of the initial series?
> >
> > Or, both 1 & 2 are acceptable depending on the cleanup?
>
>   3. Post the cleanup independently, but make a note so that maintainers know
>      that there may be conflicts and/or missed cleanup opportunities.
>
> #1 is rarely going to be the best option.  The big cleanup is going to necessitate
> Cc'ing a lot of people that don't care about the base arch-specific changes, so
> unless the base changes are one or two trivial patches, a lot of people end up
> having to wade through a lot of noise.  And aside from annoying people, that also
> makes it more likely that someone will overlook the cleanup.
>
> As for #2 vs. #3, #3 is probably a better option in most cases.  For broad cleanups,
> odds are very good that there will be other conflicts beyond just the changes _you_
> have in-flight.  E.g. in this case, any new tests and/or asserts that are in-flight,
> sitting in other trees, etc., will suffer the same fate.  I.e. whoever applies the
> cleanup is going to need to resolve conflicts and/or look for other cleanup
> opportunities anyways.  For a scenario like this, a way to make life easy for the
> maintainer applying the cleanup would be to provide a script, e.g. single grep
> command, to look for potential cleanup spots.  That communicates to the maintainer
> that there may be silent "conflicts" and makes it easier for them to resolve such
> conflicts.

This is a good idea, to provide a grep or at least provide hints on
how one has found places to edit. I will keep this in mind. Thanks

>
> Posting the cleanup separately means the two series/patches can proceed
> independently, e.g. respinning one doesn't screw up the other, maintainers can
> take the patches in whatever order they prefer, etc.
>
> There are undoubtedly exceptions, e.g. if the resulting conflicts are really nasty,
> but those should be few and far between.
