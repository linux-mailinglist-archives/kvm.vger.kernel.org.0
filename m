Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D161FD03
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiKGSNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiKGSM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:12:57 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D327DF7
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:11:33 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-37063f855e5so112230137b3.3
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+XR/b1ELU8/BVxOd8KJkVYQZI42Oa0wfjRxT+gnAx+U=;
        b=P2qRlGbRPeqjLnI25F3mlMqHC9MQEvfb/R1VhsDfsj+3sxStnSBKp7oW00gxieIEdq
         vwkWdCy5N5FYiNDhJTkyr2Hn3ANnmuOzvLyFsKjwghh1r8HYPVxCNY5ELwn+lK6HAfK+
         s1kW2cbdSkIL3ns2vbgiAVUUfvgKv+Ky8cWER4mn9NC2Q/Dk0bYDKDD7tAcI6pVKAHRx
         pv468WUAsasfb52N/R8vXARQN2tnVAh/w0vY4Fj/bVc0hzOJ9rp73SutEppwO5gDEPZf
         Fa5lzA0x6TTFVjpVy4ZTc+Wm2DZljleRTc8C87xscnT0llGzkxTG+GlWrlvXICWo3bQF
         HIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XR/b1ELU8/BVxOd8KJkVYQZI42Oa0wfjRxT+gnAx+U=;
        b=LAGBZqGNVLJBWbL9k+moIuars5heEynOClYRm/XuX9LRK5hVbeL2hQWXCGAT1zv3ZO
         ZQaimBXXeMFylxOQI1PfXmpHQMiZptWe9yJo7iewP5MHkIAU//29Me+2kJRQUNPTuhNQ
         CTFy0LGZUo6RjsI0rY9INmgcuZBPTf++WxxhhFkEoDpObzQ0PI5zE2PDmQFLgfXjk1A3
         FEttcoxQq6zdpzQhO/zKpNxZpDo6Zq/E2NImDcnyvUa6fe3vXFs4AEJf0M+knd5mjxZC
         AhXaNp4YdkjyTgXuEwWLk6L78F7MxjAgtuA5CCu1PFrbRy7S3d5MQyJRWBUg33Vbm4tK
         lljg==
X-Gm-Message-State: ACrzQf3Xpy0QA+dywekY/etz3bg18cdCPpg/ybOq/6cuzZukklrUSK5Q
        zAVr4xkPfRrYK4ynT/B9WeneDq7mEp7jO2nhCim0oA==
X-Google-Smtp-Source: AMsMyM4LCFaBMQSBBqMcThZ2SC66h3bgqrjpMiuecv55jF7Iu6VtJhRuJKKefxNn3lw/FHv9MNftX0YqeEpDb/8v1sU=
X-Received: by 2002:a81:8201:0:b0:370:c85:7e4a with SMTP id
 s1-20020a818201000000b003700c857e4amr48094046ywf.209.1667844692893; Mon, 07
 Nov 2022 10:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <Y1mlJqKdFtlgG3jR@google.com> <DS0PR11MB63731F2B467D4084F5C8D9B5DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qnWFzekT27rYka@google.com> <CALzav=c4-FWVrWQebuYs--vbgnyPjEwZxfjSS1aMSRL3JMbWYw@mail.gmail.com>
 <Y1rNm0E6/I5y6K2a@google.com> <20221028124106.oze32j2lkq5ykifj@kamzik> <Y1v6AEInngzRxSJ+@google.com>
In-Reply-To: <Y1v6AEInngzRxSJ+@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 7 Nov 2022 10:11:06 -0800
Message-ID: <CALzav=chUT9v4wYVVy9dSLcevhADxONaf9iCMOWQ_vUOwpkV9g@mail.gmail.com>
Subject: Re: [PATCH v1 00/18] KVM selftests code consolidation and cleanup
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On Fri, Oct 28, 2022 at 8:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 28, 2022, Andrew Jones wrote:
> > On Thu, Oct 27, 2022 at 06:27:39PM +0000, Sean Christopherson wrote:
> > > On Thu, Oct 27, 2022, David Matlack wrote:
> > > > On Thu, Oct 27, 2022 at 8:44 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > I like the idea in theory, but that'd be a daunting task to set up, and quite the
> > > > > maintenance nightmare.  There are probably thousands of file => scope mappings
> > > > > throughout the kernel, with any number of exceptions and arbitrary rules.
> > > >
> > > > I was thinking about proposing this in checkpatch.pl, or in some
> > > > KVM-specific check script. It seems like the following rule: If a
> > > > commit only modifies files in tools/testing/selftests/kvm/*, then
> > > > requires the shortlog match the regex "KVM: selftests: .*". That would
> > > > handle the vast majority of cases without affecting other subsystems.
> > > >
> > > > Sean are you more concerned that if we start validating shortlogs in
> > > > checkpatch.pl then eventually it will get too out of hand? (i.e. not
> > > > so concerned with this specific case, but the general problem?)
> > >
> > > Ya, the general problem.  Hardcoding anything KVM specific in checkpatch.pl isn't
> > > going to fly.  The checkpatch maintainers most definitely don't want to take on
> > > the burden of maintaining subsystem rules.  Letting one subsystem add custom rules
> > > effectively opens the flood gates to all subsystems adding custom rules.  And from
> > > a KVM perspective, I don't want to have to get an Acked-by from a checkpatch
> > > maintiainer just to tweak a KVM rule.
> > >
> > > The only somewhat feasible approach I can think of would be to provide a generic
> > > "language" for shortlog scope rules, and have checkpatch look for a well-known
> > > file in relevant directories, e.g. add arch/x86/kvm/SCOPES or whatever.  But even
> > > that is a non-trivial problem to solve, as it means coming up with a "language"
> > > that has a reasonable chance of working for many subsystems without generating too
> > > many false positives.
> > >
> > > It's definitely doable, and likely not actually a maintenance nightmare (I wrote
> > > that thinking of modifying a common rules file).  But it's still fairly daunting
> > > as getting buy-in on something that affects the kernel at large tends to be easier
> > > said then done.  Then again, I'm probably being pessimistic due to my sub-par
> > > regex+scripting skills :-)
> >
> > How about adding support for checkpatch extension plugins? If we could add
> > a plugin script, e.g. tools/testing/selftests/kvm/.checkpatch, and modify
> > checkpatch to run .checkpatch scripts in the patched files' directories
> > (and recursively in the parent directories) when found, then we'd get
> > custom checkpatch behaviors. The scripts wouldn't even have to be written
> > in Perl (but I say that a bit sadly, because I like Perl).
>
> That will work for simple cases, but patches that touch files in multiple directories
> will be messy.  E.g. a patch that touches virt/kvm/ and arch/x86/kvm/ will have
> two separate custom rules enforcing two different scopes.
>
> Recursively executing plugins will also be problematic, e.g. except for KVM, arch/x86/
> is maintained by the tip-tree folks, and the tip-tree is quite opinionated on all
> sorts of things, whereas KVM tends to be a bit more relaxed.
>
> Enforcing scope through plugins would also lead to some amount of duplicate code
> throught subsystems.
>
> Anyways, if someone wants to pursue this, these ideas and the "requirement" should
> be run by the checkpatch maintainers.  They have far more experience and authority
> in this area, and I suspect we aren't the first people to want checkpatch to get
> involved in enforcing shortlog scope.

Documenting would at least be an improvement over what we have today
since it would eliminate the need to re-explain the preferred rules
every time. We can just point to the documentation when reviewing
patches.

`git log --pretty=oneline` is not a great way to document shortlog
scopes because it does not explain the rules (e.g. when to use "KVM:
x86: " vs "KVM: x86/mmu: "), does not explain why things the way they
are, and is inconsistent since we don't always catch every patch that
goes by with a non-preferred shortlog scope.
