Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9FF6E28B3
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDNQtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjDNQtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:49:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E652240F8
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:49:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b67a25fc1so198761b3a.1
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681490970; x=1684082970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=40C1L22YEHEevxTzzqVpMykNpm1pkiWPGGfKGEe0Zpc=;
        b=QV6+HrWpPJa3oucDSnQ99kteOsEbzuPvhBN7E1aJX6VVfSSqxcvb5/5EHWaazsErn7
         k728J3eeV8zfbJrT22k9+85QAb2gnZ/vyj8upnq5Dj2PBBcwmRR21VecywuIAS6Aodus
         zsWsXqjwgNdXUnxzHd3vVkP4yDCtdp/ADatKf3QbKT7AKOVZIJXfpBo9WPcEVv+MROEk
         LVnB1Ds4wITg1U/qMumdE7jBJKItHeQBX9FkYGpX3m3S42NgSzlUGboiHEjPmTwGEuXz
         F7kYyY50qRtbmee6BJqmo89QX8f+CCx+hwA/Eok/i1voYGxvxoZJCzfpprMZGCdEYlK5
         MSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681490970; x=1684082970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40C1L22YEHEevxTzzqVpMykNpm1pkiWPGGfKGEe0Zpc=;
        b=Z+rTMIQgtcLMaN+AlEwCa1SJk9zKB2vJ7HZZl41EWzE4APayUEhlB+XpVAmBkWOnlr
         ki/GZScC2vxOQj0aLoCv34aUoGerYYvrJevN+fB3R6cvLEvWPQwZpdrjiOBS8GrEQ/Nw
         LINsB6d6ljxIjliAh21nExdZg9qCVMKxM5waWXp83yZasG8QyHVTHeNLZJXb9UzbJhZl
         qwkfBqr0X0IUEYLeYIxYmj4P7aJUFy3AJ5rpWwoMip12dfiDQke1oeYV2PAhUZlAVv5d
         8WwQlgI5X5CsnJKbf0EnTt0JVBNx72QWHfM2Gbb0eGGnG5Itl8JQqoqBIlojUvJQr2VU
         AYbA==
X-Gm-Message-State: AAQBX9exbGkTGdUIh8ZoSspVgok5rVOjy1+MHFKnAnBb6RAUvEO0QRdb
        kPYMa7KBneAkxqclZGYAV+ESfNWxGYc=
X-Google-Smtp-Source: AKy350bwiTR8+BCNZM+umf+qw+u2MpXzSq+b/YEAANNEZzj0igF5DhYIRZ6OYWXyIJdeFjEYvWoA7WFzIok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:21c8:b0:63b:2102:4a64 with SMTP id
 t8-20020a056a0021c800b0063b21024a64mr3371970pfj.3.1681490970381; Fri, 14 Apr
 2023 09:49:30 -0700 (PDT)
Date:   Fri, 14 Apr 2023 09:49:28 -0700
In-Reply-To: <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net> <ZB7oKD6CHa6f2IEO@kroah.com>
 <ZC4tocf+PeuUEe4+@google.com> <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
Message-ID: <ZDmEGM+CgYpvDLh6@google.com>
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Greg KH <greg@kroah.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Jeremi

On Fri, Apr 14, 2023, Mathias Krause wrote:
> On 06.04.23 15:22, Mathias Krause wrote:
> > On 06.04.23 04:25, Sean Christopherson wrote:
> >> These are quite risky to backport.  E.g. we botched patch 6[*], and my initial
> >> fix also had a subtle bug.  There have also been quite a few KVM MMU changes since
> >> 5.4, so it's possible that an edge case may exist in 5.4 that doesn't exist in
> >> mainline.
> > 
> > I totally agree. Getting the changes to work with older kernels needs
> > more work. The MMU role handling was refactored in 5.14 and down to 5.4
> > it differs even more, so backports to earlier kernels definitely needs
> > more care.
> > 
> > My plan would be to limit backporting of the whole series to kernels
> > down to 5.15 (maybe 5.10 if it turns out to be doable) and for kernels
> > before that only without patch 6. That would leave out the problematic
> > change but still give us the benefits of dropping the needless mmu
> > unloads for only toggling CR0.WP in the VM. This already helps us a lot!
> 
> To back up the "helps us a lot" with some numbers, here are the results
> I got from running the 'ssdd 10 50000' micro-benchmark on the backports
> I did, running on a grsecurity L1 VM (host is a vanilla kernel, as
> stated below; runtime in seconds, lower is better):
> 
>                           legacy     TDP    shadow
>     Linux v5.4.240          -        8.87s   56.8s
>     + patches               -        5.84s   55.4s

I believe "legacy" and "TDP" are flip-flopped, the TDP MMU does't exist in v5.4.

>     Linux v5.10.177       10.37s    88.7s    69.7s
>     + patches              4.88s     4.92s   70.1s
> 
>     Linux v5.15.106        9.94s    66.1s    64.9s
>     + patches              4.81s     4.79s   64.6s
> 
>     Linux v6.1.23          7.65s    8.23s    68.7s
>     + patches              3.36s    3.36s    69.1s
> 
>     Linux v6.2.10          7.61s    7.98s    68.6s
>     + patches              3.37s    3.41s    70.2s
> 
> I guess we can grossly ignore the shadow MMU numbers, beside noting them
> to regress from v5.4 to v5.10 (something to investigate?). The backports
> don't help (much) for shadow MMU setups and the flux in the measurements
> is likely related to the slab allocations involved.
> 
> Another unrelated data point is that TDP MMU is really broken for our
> use case on v5.10 and v5.15 -- it's even slower that shadow paging!
> 
> OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
> for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
> on v5.10.

Anyone that's enabling the TDP MMU on v5.10 is on their own, we didn't enable the
TDP MMU by default until v5.14 for very good reasons.

> I backported the whole series down to v5.10 but left out the CR0.WP
> guest owning patch+fix for v5.4 as the code base is too different to get
> all the nuances right, as Sean already hinted. However, even this
> limited backport provides a big performance fix for our use case!

As a compromise of sorts, I propose that we disable the TDP MMU by default on v5.15,
and backport these fixes to v6.1.  v5.15 and earlier won't get "ludicrous speed", but
I think that's perfectly acceptable since KVM has had the suboptimal behavior
literally since EPT/NPT support was first added.

I'm comfortable backporting to v6.1 as that is recent enough, and there weren't
substantial MMU changes between v6.1 and v6.3 in this area.  I.e. I have a decent
level of confidence that we aren't overlooking some subtle dependency.

For v5.15, I am less confident in the safety of a backport, and more importantly,
I think we should disable the TDP MMU by default to mitigate the underlying flaw
that makes the 18x speedup possible.  That flaw is that KVM can end up freeing and
rebuilding TDP MMU roots every time CR0.WP is toggled or a vCPU transitions to/from
SMM.

We mitigated the CR0.WP case between v5.15 and v6.1[1], which is why v6.1 doesn't
exhibit the same pain as v5.10, but Jeremi discovered that the SMM case badly affects
KVM-on-HyperV[2], e.g. when lauching KVM guests using WSL.  I posted a fix[3] to
finally resolve the underlying bug, but as Jeremi discovered[4], backporting the fix
to v5.15 is going to be gnarly, to say the least.  It'll be far worse than backporting
these CR0.WP patches, and maybe even infeasible without a large scale rework (no thanks).

Anyone that will realize meaningful benefits from the TDP MMU is all but guaranteed
to be rolling their own kernels, i.e. can do the backports themselves if they want
to use a v5.15 based kernel.  The big selling point of the TDP MMU is that it scales
better to hundreds of vCPUs, particularly when live migrating such VMs.  I highly
doubt that anyone running a stock kernel is running 100+ vCPU VMs, let alone trying
to live migrate them.

[1] https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
[2] https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
[3] https://lore.kernel.org/all/20230413231251.1481410-1-seanjc@google.com
[4] https://lore.kernel.org/all/7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com
