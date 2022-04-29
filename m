Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846B7514FE9
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376319AbiD2PzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiD2PzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:55:23 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA66166FBC
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:52:02 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v4so10990080ljd.10
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OizdqLk0k8QMs1TRuRMo3qpTsCyU7LjlsmMSoOiqvXk=;
        b=C1CdlLOyBVKSuvcDCJi04jQ9cDv2DCq/9LzcvSW8ZdFn/u87peE8WaMOl5ddFxt8L8
         HR8M9qpK8qocmYfPBoSQxDehTKHrHphs0hfrpt+TbJNOjpQoVe0E11WJ8KNdgzoJVT0K
         yTW0xhTf+0dCsuVhiT8qG6JSYSpkq2kOKXz4w4BSwdO1lyE28aWwplB0VWgL9xYACGzv
         a6nee4mMztAiur45wq+SKxeQbkMs97tO2FI4v0G+A8wtUAu0gkPwQbdvL21+7LED+e04
         AxyHDaboZM39wLBeG+27qKJ0WLUtkoNAg3Dlv1JgnC0hJxeOE1/o8L+XkV15JTmMK9pL
         IcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OizdqLk0k8QMs1TRuRMo3qpTsCyU7LjlsmMSoOiqvXk=;
        b=CD+r+fUPEBAuThIgI7LzSDfHno+biF3anKF4U+Zx4O0jhfOy/GYWGwVMZ0Rk1DMYGT
         Rq7FGo2tT0H1kJohb1T8c9y4MD4r4t7U26UZaQNFzFfP0COf5HFDW+AKVvVVs9zqkKfl
         C+QatO/yG6UuGpkrkTFDNd2mLrgZxJf5ilW9NH6SZ0+yBYRcMVSpasUqTiR+pxfpmOUR
         Pt1kjEWLx893PMgjYcvNJ3A5UmF0rd2Eu98PWPq30YhOevQYOvVWe5QU4CyECTkoEZLC
         EMA0+JaRld/ozrZ6uB6wjaa1N+lDrI0n2EMdBcv9QxjXEnDLk1a/5nbO7hk3icYWKmKv
         h3AA==
X-Gm-Message-State: AOAM5321crLLqZNvZxfCB1haR0GRqVPUhZAmobRbSV+L6PxEdKj8/Swd
        TRz1LwAUmW6VKLq7llA6wRrodT+kIz7mRMcos6v5Npn6sO9odQ==
X-Google-Smtp-Source: ABdhPJx29wqDAwEp8Y2yRPTpOUG8lGhwBqmjZeupJHNgtGob5BjndU0KZ8b0HGRPE8G9/v0AgulGcOfaxhvwTtfUnrM=
X-Received: by 2002:a2e:a5cb:0:b0:24f:233b:d90e with SMTP id
 n11-20020a2ea5cb000000b0024f233bd90emr11835285ljp.83.1651247520931; Fri, 29
 Apr 2022 08:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com> <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com>
In-Reply-To: <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 29 Apr 2022 09:51:49 -0600
Message-ID: <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
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

On Fri, Apr 29, 2022 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/29/22 17:35, Peter Gonda wrote:
> > On Thu, Apr 28, 2022 at 5:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 4/28/22 23:28, Peter Gonda wrote:
> >>>
> >>> So when actually trying this out I noticed that we are releasing the
> >>> current vcpu iterator but really we haven't actually taken that lock
> >>> yet. So we'd need to maintain a prev_* pointer and release that one.
> >>
> >> Not entirely true because all vcpu->mutex.dep_maps will be for the same
> >> lock.  The dep_map is essentially a fancy string, in this case
> >> "&vcpu->mutex".
> >>
> >> See the definition of mutex_init:
> >>
> >> #define mutex_init(mutex)                                              \
> >> do {                                                                   \
> >>           static struct lock_class_key __key;                            \
> >>                                                                          \
> >>           __mutex_init((mutex), #mutex, &__key);                         \
> >> } while (0)
> >>
> >> and the dep_map field is initialized with
> >>
> >>           lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
> >>
> >> (i.e. all vcpu->mutexes share the same name and key because they have a
> >> single mutex_init-ialization site).  Lockdep is as crude in theory as it
> >> is effective in practice!
> >>
> >>>
> >>>            bool acquired = false;
> >>>            kvm_for_each_vcpu(...) {
> >>>                    if (!acquired) {
> >>>                       if (mutex_lock_killable_nested(&vcpu->mutex, role)
> >>>                           goto out_unlock;
> >>>                       acquired = true;
> >>>                    } else {
> >>>                       if (mutex_lock_killable(&vcpu->mutex, role)
> >>>                           goto out_unlock;
> >>
> >> This will cause a lockdep splat because it uses subclass 0.  All the
> >> *_nested functions is allow you to specify a subclass other than zero.
> >
> > OK got it. I now have this to lock:
> >
> >           kvm_for_each_vcpu (i, vcpu, kvm) {
> >                    if (prev_vcpu != NULL) {
> >                            mutex_release(&prev_vcpu->mutex.dep_map, _THIS_IP_);
> >                            prev_vcpu = NULL;
> >                    }
> >
> >                    if (mutex_lock_killable_nested(&vcpu->mutex, role))
> >                            goto out_unlock;
> >                    prev_vcpu = vcpu;
> >            }
> >
> > But I've noticed the unlocking is in the wrong order since we are
> > using kvm_for_each_vcpu() I think we need a kvm_for_each_vcpu_rev() or
> > something. Which maybe a bit for work:
> > https://elixir.bootlin.com/linux/latest/source/lib/xarray.c#L1119.
>
> No, you don't need any of this.  You can rely on there being only one
> depmap, otherwise you wouldn't need the mock releases and acquires at
> all.  Also the unlocking order does not matter for deadlocks, only the
> locking order does.  You're overdoing it. :)

Hmm I'm slightly confused here then. If I take your original suggestion of:

        bool acquired = false;
        kvm_for_each_vcpu(...) {
                if (acquired)
                        mutex_release(&vcpu->mutex.dep_map,
_THIS_IP_);  <-- Warning here
                if (mutex_lock_killable_nested(&vcpu->mutex, role)
                        goto out_unlock;
                acquired = true;

"""
[ 2810.088982] =====================================
[ 2810.093687] WARNING: bad unlock balance detected!
[ 2810.098388] 5.17.0-dbg-DEV #5 Tainted: G           O
[ 2810.103788] -------------------------------------
[ 2810.108490] sev_migrate_tes/107600 is trying to release lock
(&vcpu->mutex) at:
[ 2810.115798] [<ffffffffb7cd3592>] sev_lock_vcpus_for_migration+0xe2/0x1e0
[ 2810.122497] but there are no more locks to release!
[ 2810.127376]
               other info that might help us debug this:
[ 2810.133911] 3 locks held by sev_migrate_tes/107600:
[ 2810.138791]  #0: ffffa6cbf31ca3b8 (&kvm->lock){+.+.}-{3:3}, at:
sev_vm_move_enc_context_from+0x96/0x690
[ 2810.148178]  #1: ffffa6cbf28523b8 (&kvm->lock/1){+.+.}-{3:3}, at:
sev_vm_move_enc_context_from+0xae/0x690
[ 2810.157738]  #2: ffff9220683b01f8 (&vcpu->mutex){+.+.}-{3:3}, at:
sev_lock_vcpus_for_migration+0x89/0x1e0
"""

This makes sense to me given we are actually trying to release lock we
haven't locked yet. So thats why I thought we'd need to work with a
prev_vcpu pointer. So the behavior I've observed is slightly different
than I'd expect from your statement "(i.e. all vcpu->mutexes share the
same name and key because they have a
single mutex_init-ialization site)."

Ack about the unlocking order, that makes things easier.

>
> Paolo
>
