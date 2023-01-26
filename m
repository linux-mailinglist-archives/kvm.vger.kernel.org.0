Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A164567D96A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 00:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjAZXMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 18:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjAZXMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 18:12:08 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62B16813A
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:12:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y15so2624963edq.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9LFXa2PlUiluAxw9v2Lp9fRg0TKwZi7Il2FLTW8iHNY=;
        b=bqBGg/V9is3o8VI/lM7jiQZsvPDUZNgj8CG353W3FKYyzqRbrFs175+aajvWs8inWC
         0K/VFzZLF0s6EHM3hjIbyxo3DRkRQPv36i95WY5XpppLMz1D2NVqs06LQR2gZfaD5790
         Li3kwy7UN7ZYyP6OTud65d6P62cPtVmYwi7JiH1SPYeq5TBRs+oohoF8T8xs/2ipRRPL
         oIbEhzt/N9FuqWhOnwevrAM9vapJqxhCy12DEfoUWwndVXJ3G0D4E/vsHBWC5Ongenaf
         hYt3jSu0O8Hj4JtQ7Xu6qew2EEykrDLLa7E+aMJ+sihGxHoFue1ungnopflAT37GV3Wv
         egOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LFXa2PlUiluAxw9v2Lp9fRg0TKwZi7Il2FLTW8iHNY=;
        b=V++fMYIKit40eHxQDNXLXz5sblWDickU8WdHHsbZgXQQPHzdLnSHeTwHUgPERY7mgq
         JH3AGKv837Ct840pV/8Sf32g9B/9jFAAgfRFQa7DWzmOuPUMpyjYI7/dmsh5h36uIsFg
         lPg5Vf32H+YHhOMEt4Fm5hfTNDbjG83RfwdHNimHE8vy62VLWWwcJKLRFiIqyYp5EUXa
         0NTsKUMAmrYJ14bSGW8ohu5cVLEjpXN6ROB1JLmFVez51TeP+80uQqgIxsiriW/YYJZY
         wAW32K7gzZqaqYfMWuCVEJCnLBHWUsVFoMHMNZ3B6sBmM97WRk5wrsSDBf8dKLA3yCeo
         NaRQ==
X-Gm-Message-State: AFqh2krZH+wDRcYNXgFUb20eLkbnV5kRcP2T7ZvKYsOdEtCicAjBDpqw
        n+P+mgzDQ7r6GUjFW1d6CgYM7NpiD7IoQB/U4YKeSg==
X-Google-Smtp-Source: AMrXdXt9wDKEURlwnuwvbCVx62WUzh8aAanaLY9EhCKHZi+AdtcSZreR4BRKbFPvanvwgfKYopac3JVqdz2AqW4ZOmk=
X-Received: by 2002:a05:6402:2946:b0:49e:45a8:4a4b with SMTP id
 ed6-20020a056402294600b0049e45a84a4bmr5680900edb.37.1674774723963; Thu, 26
 Jan 2023 15:12:03 -0800 (PST)
MIME-Version: 1.0
References: <20230125182311.2022303-1-bgardon@google.com> <20230125182311.2022303-3-bgardon@google.com>
 <CAHVum0ex4=X_iD_hKMQAkNVEcVzZSNUb_V0ApjPKxpCX+oFV6w@mail.gmail.com>
 <CANgfPd-7Yb05BYBW7TOg67qq=_vSXqrRQ_XF7WUfstQjXgyPww@mail.gmail.com> <CAHVum0eepF4wNp84eb2mY+Wyw0MGhyDuOu_81pvrYDbAWn2UXg@mail.gmail.com>
In-Reply-To: <CAHVum0eepF4wNp84eb2mY+Wyw0MGhyDuOu_81pvrYDbAWn2UXg@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 26 Jan 2023 15:11:52 -0800
Message-ID: <CANgfPd9kzBYe0C-aVnx3dbGH=MPoJrRkZ5zx=cqBzQnvH9sNQw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] selftests: KVM: Add dirty logging page splitting test
To:     Vipin Sharma <vipinsh@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Thu, Jan 26, 2023 at 3:04 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Thu, Jan 26, 2023 at 2:52 PM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Thu, Jan 26, 2023 at 12:06 PM Vipin Sharma <vipinsh@google.com> wrote:
> > >
> > > On Wed, Jan 25, 2023 at 10:23 AM Ben Gardon <bgardon@google.com> wrote:
> > >
> > > > +static void run_vcpus_get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
> > > > +{
> > > > +       int i;
> > > > +
> > > > +       iteration++;
> > > > +       for (i = 0; i < VCPUS; i++) {
> > > > +               while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> > > > +                      iteration)
> > > > +                       ;
> > > > +       }
> > > > +
> > > > +       get_page_stats(vm, stats, stage);
> > >
> > > get_page_stats() is already called in run_test() explicitly for other
> > > stats. I think it's better to split this function and make the flow
> > > like:
> > >
> > > run_vcpus_till_iteration(iteration++);
> > > get_page_stats(vm, &stats_populated, "populating memory");
> > >
> > > This makes it easy to follow run_test_till_iteration() and easy to see
> > > where stats are collected. run_test_till_iteration() can also be a
> > > library function used by other tests like dirty_log_perf_test
> >
> > Yeah, either way works. We can do it all in the run_tests function as
> > I originally had or we can have the run vcpus and get stats in a
> > helper as David suggested or we can separate run_vcpus and get_stats
> > helpers as you're suggesting. I don't think it makes much of a
> > difference.
> > If you feel strongly I can send out another iteration of this test.
> >
>
> I should have read David's comment and responded in that version.
> No strong feelings. It is up to you.

No worries, it probably would have been easier to track down if I had
links in the cover letter. :)

>
> > >
> > >
> > > > +       dirty_log_manual_caps = 0;
> > > > +       for_each_guest_mode(run_test, NULL);
> > > > +
> > > > +       dirty_log_manual_caps =
> > > > +               kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > > > +
> > > > +       if (dirty_log_manual_caps) {
> > > > +               dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > > > +                                         KVM_DIRTY_LOG_INITIALLY_SET);
> > > > +               for_each_guest_mode(run_test, NULL);
> > > > +       }
> > >
> > > Should there be a message to show  that this capability is not tested
> > > as it is not available?
> > > Or, there can be a command line option to explicitly provide intent of
> > > testing combined,  split modes, or both? Then test can error out
> > > accordingly.
> >
> > Sure, that would work too. If I send another version of this series I
> > can add a skip message, but I don't want to re-add an option to
> > specify whether to run with MANUAL_PROTECT, because that's what I had
> > originally and then David suggested I remove it and just always run
> > both.
>
> Sounds good.
>
> Reviewed-By: Vipin Sharma <vipinsh@google.com>

Thanks!
