Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3157C6EAFF2
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjDURAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbjDUQ7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:59:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D98C172
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:59:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f833bda191so1250136f8f.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 09:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682096323; x=1684688323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8Rxt8dTLEovw3lEAnM7MgL3OWO4znXGRJ3kPeyNNpw=;
        b=c2yeDPrvbiceHrf8w+PQc1Uwqt2wh6D7nCKhERo+oeLqgUJTVxF3Q+xtEqAMODaI72
         2ARnoyoOcN9RWgG5ztthzt2xleV+WThmkuilL6DjSPc1uFF2r4Lb+kAmjDN7bCy8bMJt
         XTxSS1LAHGwub5nILUVdDv+w+lfYmZHJNnNxbHndvSim6AJRVPA+AWBITxJULAa5KBIZ
         Sv8hwfIOInAiN/zCUQlNChk8/7e3U8SA8y6pkDjFd3KJ5FfAXAeOcuZJILRGnf/6ZH57
         q08zX2T7ZHW+cQPUWaTM9d7brBJsbmMt/RSSde6wnqI3D7FXH9G2dB8OT0AyDuISv+7F
         YO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096323; x=1684688323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8Rxt8dTLEovw3lEAnM7MgL3OWO4znXGRJ3kPeyNNpw=;
        b=hUz4xcfdr5K3VMmNy64qL3aKu0vbmTHXejCtzt3Qvf3HIEDxece0ZhzFPbK50gZPhD
         wGnVrO/RDce6/Tk3XlLYIMPGAJtz6JhxT6K16QMXgp1ZD3o4dz9+wz6aTTvXpsYIEuml
         dkkXTrWr5+VGfAcxi/QBOQNXrFSJyE3ML+Wq0iOJnLqCWIAN9WIBXMQEWOZdZ1spLd6d
         ps4xeO1sQ75CtSivIaimU+fJE9Zhd7h3tkox85OU6H3FzwYRTtB4iS7VVq9NfUcS+nwO
         Ht706yNVKPayJGp0MbiScu7Yhi8DAcf0PekbDSfttES3FebSs/nL3awQcfZtNnj2roWk
         qSFQ==
X-Gm-Message-State: AAQBX9c82ONd75U83byOQsV/lKmcHEk7BrfWu6horQmW4hnh+xdGht5c
        vAVO8hel7IzsCdelTRhrbkkP33BpI3VWyBloEqiluQ==
X-Google-Smtp-Source: AKy350afBzvM3bUoCKK6F0lcGkrooiM3JAYrImnU/G6GTNeb4vcAlPGHsM/xbA7Ai0f52THZ20jeXhiZqD2U/OjaC5A=
X-Received: by 2002:adf:cd85:0:b0:2f4:55c3:8452 with SMTP id
 q5-20020adfcd85000000b002f455c38452mr5064489wrj.22.1682096322772; Fri, 21 Apr
 2023 09:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
In-Reply-To: <ZEGuogfbtxPNUq7t@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 21 Apr 2023 09:58:06 -0700
Message-ID: <CAF7b7mrP-ZekkvmXyWbeZOyMjsHQmCKvBEPSogBsw1eAUCs_1A@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Peter Xu <peterx@redhat.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 2:29=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Yes I don't understand why vanilla uffd is so different, neither am I sur=
e
> what does the graph mean, though. :)
>
> Is the first drop caused by starting migration/precopy?
>
> Is the 2nd (huge) drop (mostly to zero) caused by frequently accessing ne=
w
> pages during postcopy?

Right on both counts. By the way, for anyone who notices that the
userfaultfd (red/yellow) lines never recover to the initial level of
performance, whereas the blue line does: that's a separate issue,
please ignore :)

> Is the workload busy writes single thread, or NCPU threads?

One thread per vCPU.

> Is what you mentioned on the 25%-75% comparison can be shown on the graph=
?
> Or maybe that's part of the period where all three are very close to 0?

Yes, unfortunately the absolute size of the improvement is still
pretty small (we go from ~50 writes/s to ~150), so all looks like zero
with this scale.

> > The second is the redis memtier benchmark [1], a more realistic
> > workflow where we migrate a VM running the redis server. With scalable
> > userfaultfd, the client VM observes significantly higher transaction
> > rates during uffd-based postcopy (see "Memtier.png"). I can pull the
> > exact numbers if needed, but just from eyeballing the graph you can
> > see that the improvement is something like 5-10x (at least) for
> > several seconds. There's still a noticeable gap with KVM demand paging
> > based-postcopy, but the improvement is definitely significant.
> >
> > [1] https://github.com/RedisLabs/memtier_benchmark
>
> Does the "5-10x" difference rely in the "15s valley" you pointed out in t=
he
> graph?

Not quite sure what you mean: I meant to point out that the ~15s
valley is where we observe improvements due to scalable userfaultfd.
For most of that valley, the speedup of scalable uffd is 5-10x (or
something, I admit to eyeballing those numbers :)

> Is it reproduceable that the blue line always has a totally different
> "valley" comparing to yellow/red?

Yes, but the offset of that valley is just precopy taking longer for
some reason on that configuration. Honestly it's probably just better
to ignore the blue line, since that's a google-specific stack.

> Personally I still really want to know what happens if we just split the
> vma and see how it goes with a standard workloads, but maybe I'm asking t=
oo
> much so don't yet worry.  The solution here proposed still makes sense to
> me and I agree if this can be done well it can resolve the bottleneck ove=
r
> 1-userfaultfd.
>
> But after I read some of the patches I'm not sure whether it's possible i=
t
> can be implemented in a complete way.  You mentioned here and there on th=
at
> things can be missing probably due to random places accessing guest pages
> all over kvm.  Relying sololy on -EFAULT so far doesn't look very reliabl=
e
> to me, but it could be because I didn't yet really understand how it work=
s.
>
> Is above a concern to the current solution?

Based on your comment in [1], I think your impression of this series
is that it tries to (a) catch all of the cases where userfaultfd would
be triggered and (b) bypass userfaultfd by surfacing the page faults
via vCPU exit. That's only happening in two places (the
KVM_ABSENT_MAPPING_FAULT changes) corresponding to the EPT violation
handler on x86 and the arm64 equivalent. Bypassing the queuing of
faults onto a uffd in those two cases, and instead delivering those
faults via vCPU exit, is what provides the performance gains I'm
demonstrating.

However, all of the other changes (KVM_MEMORY_FAULT_INFO, the bulk of
this series) are totally unrelated to if/how faults are queued onto
userfaultfd. Page faults from copy_to_user/copy_from_user, etc will
continue to be delivered via uffd (if one is registered, obviously),
and changing that is *not* a goal. All that KVM_MEMORY_FAULT_INFO does
is deliver some extra information to userspace in cases where KVM_RUN
currently just returns -EFAULT.

Hopefully this, and my response to [1], clears things up. If not, let
me know and I'll be glad to discuss further.

[1] https://lore.kernel.org/kvm/ZEGuogfbtxPNUq7t@x1n/T/#m76f940846ecc94ea85=
efa80ffbe42366c2352636

> Have any of you tried to investigate the other approach to scale
> userfaultfd?

As Axel mentioned we considered sharding VMAs but didn't pursue it for
a few different reasons.

> It seems userfaultfd does one thing great which is to have the trapping a=
t
> an unified place (when the page fault happens), hence it doesn't need to
> worry on random codes splat over KVM module read/write a guest page.  The
> question is whether it'll be easy to do so.

See a couple of notes above.

> Split vma definitely is still a way to scale userfaultfd, but probably no=
t
> in a good enough way because it's scaling in memory axis, not cores.  If
> tens of cores accessing a small region that falls into the same VMA, then
> it stops working.
>
> However maybe it can be scaled in other form?  So far my understanding is
> "read" upon uffd for messages is still not a problem - the read can be do=
ne
> in chunk, and each message will be converted into a request to be send
> later.
>
> If the real problem relies in a bunch of threads queuing, is it possible
> that we can provide just more queues for the events?  The readers will ju=
st
> need to go over all the queues.
>
> Way to decide "which thread uses which queue" can be another problem, wha=
t
> comes ups quickly to me is a "hash(tid) % n_queues" but maybe it can be
> better.  Each vcpu thread will have different tids, then they can hopeful=
ly
> scale on the queues.
>
> There's at least one issue that I know with such an idea, that after we
> have >1 uffd queues it means the message order will be uncertain.  It may
> matter for some uffd users (e.g. cooperative userfaultfd, see
> UFFD_FEATURE_FORK|REMOVE|etc.)  because I believe order of messages matte=
r
> for them (mostly CRIU).  But I think that's not a blocker either because =
we
> can forbid those features with multi queues.
>
> That's a wild idea that I'm just thinking about, which I have totally no
> idea whether it'll work or not.  It's more or less of a generic question =
on
> "whether there's chance to scale on uffd side just in case it might be a
> cleaner approach", when above concern is a real concern.

You bring up a good point, which is that this series only deals with
uffd's performance in the context of KVM. I had another idea in this
vein, which was to allow dedicating queues to certain threads: I even
threw together a prototype, though there was some bug in it which
stopped me from ever getting a real signal :(

I think there's still potential to make uffd itself faster but, as you
point out, that might get messy from an API perspective (I know my
prototype did :) and is going to require more investigation and
prototyping. The advantage of this approach is that it's simple, makes
a lot of conceptual sense IMO (in that the previously-stalled vCPU
threads can now participate in the work of demand fetching), and
solves a very important (probably *the* most important) bottleneck
when it comes to KVM + uffd-based postcopy.
