Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD759A9F1
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245042AbiHTASC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 20:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiHTASB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 20:18:01 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33962C579D
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 17:17:59 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id l19so2711520ljg.8
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 17:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=CNep9ry1VvhvpUTMySVEmMbXzxdlarH1IuCZVDew7EY=;
        b=STdhnd7FenS1b/9kx+ca0KEU2L2sOkn+b8mag93WCl0qPu+9sR9XYsxscrOUHLFIXW
         GKJ5YreWlZJNDH/GvF0kNzSLpKrGAgDGa3yeNCHlgddsdT12mr4MTuWH4aMH0LNKyvyo
         T8YLdvUt+8pTVs4RzpUBpPNCbiulxOuR/0E7pZ1WWnIqfwHNVtEh2OsQNHQb7/xVLf9V
         g4LmhTHvSXx9LTNeXZZYNYJnHdZLZqfkkQqePE29BoKzdNONUG62mQRE/fO53EwXs06V
         /VoRUErLHTspzFL6Ilp0d76nDYnZwMshMeztaiSPzoKN2oujvwDqeAKwg7LdE+Mh755G
         +DPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=CNep9ry1VvhvpUTMySVEmMbXzxdlarH1IuCZVDew7EY=;
        b=jpLOwrwgy/X7MSfhh/nOBZ7ow1mO/EMs00CGQH06/gl1yQnR0l6397gGagUc1pq3ns
         iiVfm5ndJ3jrXXkFH8rvFP+eCxvwJ1VNuXlwAe01o3j2aINh0Dm/fmJoF31WfqCh7BHp
         oTDGxhJph/3CXo+gLLMtuDjTDR5xHr+ET5l5HkQh6CJpDM4vkQeotXcB0zfQjJKl5d9u
         vq1IZ8rLlxvXQ1y6R5+bMpk0tCRgtRRQdwEkWYVAUCbXcP+QusY2vL/vTdZ6dHqg6z+Q
         BS69H7OXZr9inNjI2aMSQjMpHZwC8q7KuKU9A+CzA5UmUv/n+i7HXphH0EIaasWDurcK
         ik1g==
X-Gm-Message-State: ACgBeo0Hf0pJGWIGl4O2eoLbVQ/xfXgPqHBRBHHWjmpsX/KTRd+dAneb
        GjN4Wpl336qTNTs0nCp8n5/XMxvblzKhQcZhqKeSOA==
X-Google-Smtp-Source: AA6agR5vCpHra8bkWNKsBarpRm/oSNVSjlDC+Zg1UudxOWjm0l3lqikFaBMsBhmkIXCM5+ltokH4zlNOfJo4A1apOxc=
X-Received: by 2002:a2e:84ca:0:b0:25d:77e0:2566 with SMTP id
 q10-20020a2e84ca000000b0025d77e02566mr2983018ljh.78.1660954677321; Fri, 19
 Aug 2022 17:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220819210737.763135-1-vipinsh@google.com> <YwAC1f5wTYpTdeh+@google.com>
 <CAHVum0ecr7S9QS4+3kS3Yd-eQJ5ZY_GicQWurVFnAif6oOYhOg@mail.gmail.com>
 <YwAP2dM/9vfjlAMb@google.com> <YwAVzzF2dZ2tKOUh@google.com>
In-Reply-To: <YwAVzzF2dZ2tKOUh@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 19 Aug 2022 17:17:20 -0700
Message-ID: <CAHVum0cLUH0j1ZKEG-fPrh52xand4fQqR2heF0j5c4LncTFWOQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: selftests: Run dirty_log_perf_test on specific cpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 3:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 19, 2022, David Matlack wrote:
> > On Fri, Aug 19, 2022 at 03:20:06PM -0700, Vipin Sharma wrote:
> > > On Fri, Aug 19, 2022 at 2:38 PM David Matlack <dmatlack@google.com> wrote:
> > > > I think we should move all the logic to pin threads to perf_test_util.c.
> > > > The only thing dirty_log_perf_test.c should do is pass optarg into
> > > > perf_test_util.c. This will make it trivial for any other test based on
> > > > pef_test_util.c to also use pinning.
> > > >
> > > > e.g. All a test needs to do to use pinning is add a flag to the optlist
> > > > and add a case statement like:
> > > >
> > > >         case 'c':
> > > >                 perf_test_setup_pinning(optarg);
> > > >                 break;
> > > >
> > > > perf_test_setup_pinning() would:
> > > >  - Parse the list and populate perf_test_vcpu_args with each vCPU's
> > > >    assigned pCPU.
> > > >  - Pin the current thread to it's assigned pCPU if one is provided.
> > > >
> > >
> > > This will assume all tests have the same pinning requirement and
> > > format. What if some tests have more than one worker threads after the
> > > vcpus?
> >
> > Even if a test has other worker threads, this proposal would still be
> > logically consistent. The flag is defined to only control the vCPU
> > threads and the main threads. If some test has some other threads
> > besides that, this flag will not affect them (which is exactly how it's
> > defined to behave). If such a test wants to pin those other threads, it
> > would make sense to have a test-specific flag for that pinning (and we
> > can figure out the right way to do that if/when we encounter that
> > situation).
>
> ...
>
> > Yeah and I also realized perf_test_setup_pinning() will need to know how
> > many vCPUs there are so it can determine which element is the main
> > thread's pCPU assignment.
>
> The "how many workers you got?" conundrum can be solved in the same way, e.g. just
> have the caller pass in the number of workers it will create.
>
>         perf_test_setup_pinning(pin_string, nr_vcpus, NR_WORKERS);
>
> The only question is what semantics we should support for workers, e.g. do we
> want to force an all-or-none approach or can the user pin a subset.  All-or-none
> seems like it'd be the simplest to maintain and understand.  I.e. if -c is used,
> then all vCPUs must be pinned, and either all workers or no workers are pinned.

Combining both of your suggestions to make sure everyone is on the same page:
perf_test_setup_pinning(pin_string, nr_vcpus) API expects (nr_vcpus +
1) entries in "pin_string", where it will use first nr_vcpus entries
for vcpus and the one after that for caller thread cpu.

In future if there is a need for common workers, then after nr_vcpus+1
entries there will be entries for workers, having a predefined order
as workers get added to the code.

"pin_string" must always have AT LEAST (nr_vcpus + 1) entries. After
that if there are more entries, then those will be used to assign cpus
to common worker threads based on predefined order. perf_test_util
should have a  way to know how many common workers there are. There
can be more workers than entries, this is fine, those extra workers
will not be pinned.

If this is not desirable, let us hold on discussion when we actually
get common workers, meanwhile, just keep nr_vcpus + 1 entries and work
accordingly.
