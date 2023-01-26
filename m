Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2631B67D95F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 00:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbjAZXEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 18:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjAZXEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 18:04:43 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D82A74489
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:04:22 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b1so3935484ybn.11
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xkDJ6MyKVc/yoPEgFwADBOJoFNEHdP+bpdBc8jczQVM=;
        b=fcGnVsvWf9nRIjaBJIrDn8rx44F5Ld868Cj4XkTTjIBGCXV2mq0XjOg3khBN/pHisU
         jjEgGVr8IEiuaMN+t0UYTS/BZj0N/I8SYcQt3xJTYsfmRXtDrCDErhh9BmtRicXrGrS8
         DWU4qMuL4hpzWf5wq4qwktCdwV7XDPQxGYp51qKD4maK4MYT3x/yraidt55GwoeQx9FS
         Tgxh7umPPyD8RcMT4rlMwCBNHLmgO41psuEg0VuKDhtITd0ORexflJX6Q7BJwPVyTMHt
         4xkZs3G+ml4z9RX59OvuVwkyoUJoPXpK6zfOSTfgxGCWBIvt8VUa0oGg0vXQmino72Gs
         /yvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xkDJ6MyKVc/yoPEgFwADBOJoFNEHdP+bpdBc8jczQVM=;
        b=lFIhdu8PHOATPE7WL+9GdieVLP++R7D6HAlwO4VHS/ugx3l0fdoRyui9DOuKq/KSwW
         ZXh3eyudvZ1tudCDsxSX0wRlPOaw0MnLXO04Mn/9tSRT+cuoraXnHnLF0GF5tVzglEk1
         MdSdqAWYH1q6WMfElSoys8FkgNG4HmXLrJTIIyEE/uNqFYpYRdLejiWmcTjue+jk59T6
         yTlIlIWraZHYNNO8yvzyf8joVe4ZGMEfu6bF0aX/eSYK7LWWW2WmP12nm+wNvfEt960J
         JX4CO84s+zMiymfbllS5VTzBrGvu788OsMOAx/Vkz0oCT0d/UrUUdT++NUp4QWGb2NFC
         il7Q==
X-Gm-Message-State: AFqh2kqjtt+i8qHb22swuIkICuMqxPrz4qEhTMS3BDngUSvOJ63FcA7N
        zrEc0u8z2BXo4hRdY8vAR7oakVFV22dUghUEviQtpA==
X-Google-Smtp-Source: AMrXdXs+4wbK0s4poI8ySoyQ9Rt9tQ4r5PbQykwi2MGaaHYxTVYoUn2B2aSHOIyXrm2WJG0uyq5dGoRhM/4XHPahPJA=
X-Received: by 2002:a25:6a0b:0:b0:7d1:5a92:eb5c with SMTP id
 f11-20020a256a0b000000b007d15a92eb5cmr4460775ybc.166.1674774260527; Thu, 26
 Jan 2023 15:04:20 -0800 (PST)
MIME-Version: 1.0
References: <20230125182311.2022303-1-bgardon@google.com> <20230125182311.2022303-3-bgardon@google.com>
 <CAHVum0ex4=X_iD_hKMQAkNVEcVzZSNUb_V0ApjPKxpCX+oFV6w@mail.gmail.com> <CANgfPd-7Yb05BYBW7TOg67qq=_vSXqrRQ_XF7WUfstQjXgyPww@mail.gmail.com>
In-Reply-To: <CANgfPd-7Yb05BYBW7TOg67qq=_vSXqrRQ_XF7WUfstQjXgyPww@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 26 Jan 2023 15:03:44 -0800
Message-ID: <CAHVum0eepF4wNp84eb2mY+Wyw0MGhyDuOu_81pvrYDbAWn2UXg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] selftests: KVM: Add dirty logging page splitting test
To:     Ben Gardon <bgardon@google.com>
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

On Thu, Jan 26, 2023 at 2:52 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Thu, Jan 26, 2023 at 12:06 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Wed, Jan 25, 2023 at 10:23 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > > +static void run_vcpus_get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
> > > +{
> > > +       int i;
> > > +
> > > +       iteration++;
> > > +       for (i = 0; i < VCPUS; i++) {
> > > +               while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> > > +                      iteration)
> > > +                       ;
> > > +       }
> > > +
> > > +       get_page_stats(vm, stats, stage);
> >
> > get_page_stats() is already called in run_test() explicitly for other
> > stats. I think it's better to split this function and make the flow
> > like:
> >
> > run_vcpus_till_iteration(iteration++);
> > get_page_stats(vm, &stats_populated, "populating memory");
> >
> > This makes it easy to follow run_test_till_iteration() and easy to see
> > where stats are collected. run_test_till_iteration() can also be a
> > library function used by other tests like dirty_log_perf_test
>
> Yeah, either way works. We can do it all in the run_tests function as
> I originally had or we can have the run vcpus and get stats in a
> helper as David suggested or we can separate run_vcpus and get_stats
> helpers as you're suggesting. I don't think it makes much of a
> difference.
> If you feel strongly I can send out another iteration of this test.
>

I should have read David's comment and responded in that version.
No strong feelings. It is up to you.

> >
> >
> > > +       dirty_log_manual_caps = 0;
> > > +       for_each_guest_mode(run_test, NULL);
> > > +
> > > +       dirty_log_manual_caps =
> > > +               kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > > +
> > > +       if (dirty_log_manual_caps) {
> > > +               dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > > +                                         KVM_DIRTY_LOG_INITIALLY_SET);
> > > +               for_each_guest_mode(run_test, NULL);
> > > +       }
> >
> > Should there be a message to show  that this capability is not tested
> > as it is not available?
> > Or, there can be a command line option to explicitly provide intent of
> > testing combined,  split modes, or both? Then test can error out
> > accordingly.
>
> Sure, that would work too. If I send another version of this series I
> can add a skip message, but I don't want to re-add an option to
> specify whether to run with MANUAL_PROTECT, because that's what I had
> originally and then David suggested I remove it and just always run
> both.

Sounds good.

Reviewed-By: Vipin Sharma <vipinsh@google.com>
