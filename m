Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895E95108B1
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiDZTLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354104AbiDZTKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 15:10:51 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A99377D0
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 12:07:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bu29so33666789lfb.0
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 12:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMUo75UTC5Zq38VD1DUMdcugqakIxwdJdBuqcLGg5cM=;
        b=B6l2FCoWUjMTIYAm5BMFDODEvyat9Os9xRTWwN1Y7lxxKOMc7fWsNmyA631uNgIzP5
         98LOTnMDdjHq1kUQ4BV9Eay7YwgnLnB6KhSzy4SWqKBFpOomK+qQFHsk71vKeqTvP4Ht
         yMSY2xAUu9haK6Xh9r7uOVsUASl28383s5DS5byk5LPeJW45hquSmvSFMmXJHil0JRhB
         WeK295aiBwnvCnZrLNwI9Nj/sa/sdvNRiXz/sAILmka6AZl8o8ujlvCpBymzX0YUTOWE
         KiWLkzTA47UMfsO1C1S+Mai5kNR8Ut28n5Q9bQi4BG/6/+d68wjhiP6mB7B0DYVPAjJ0
         NKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMUo75UTC5Zq38VD1DUMdcugqakIxwdJdBuqcLGg5cM=;
        b=D01o6xgcHz2hLQOaqrugDh8uekwhPNYLeybx32aTfzIKvTTsq1kFNXGEBnoeB2Hpz8
         mju/zVfgDCiXniKCxgFbZhAkrdEX8u6zYgJ93rLYbet6zmmlJegVykNuXcU0areVfGoA
         53iIthWbmpFgQJeF50KwyBt3I/HP6Fh1n/eEcmvqEe9jOALbMiY6bsVleobNejJbf3N7
         YrtcEVg3wsaPbC/AqtAYw9qaLQWhI3/GvUpiKPiBNytUA3r4MAaf4+pSBAPJmw3CxWBA
         e6OGtMcsL8PhSxKEpMOPFapYgLZdag7pAupPGpV8RMfwoX9uPERnUO+S0gM6xSV2MUhn
         YywA==
X-Gm-Message-State: AOAM533U1XwzH/QE3whbwoMjyW12uog+/ogAE+I+mh5i39DKqPzHYOOq
        uwomcJXxhjE+pGnBnYGw9qK3CvN9CGQo0umRlaxANw==
X-Google-Smtp-Source: ABdhPJydBoE/1X8tWwZ7TDirJEYimL8BCKNHbsayDufUP9gWpIaPHn2S15G3loeImJTnQ2dbUjvNGs97dN/VnOeZhBQ=
X-Received: by 2002:a05:6512:c01:b0:448:6aec:65c5 with SMTP id
 z1-20020a0565120c0100b004486aec65c5mr18091652lfu.193.1651000029309; Tue, 26
 Apr 2022 12:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com> <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
In-Reply-To: <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 26 Apr 2022 13:06:57 -0600
Message-ID: <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
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

On Thu, Apr 21, 2022 at 9:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/20/22 22:14, Peter Gonda wrote:
> >>>> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
> >>>> source and target vcpu->locks. Mark the nested subclasses to avoid false
> >>>> positives from lockdep.
> >> Nope. Good catch, I didn't realize there was a limit 8 subclasses:
> > Does anyone have thoughts on how we can resolve this vCPU locking with
> > the 8 subclass max?
>
> The documentation does not have anything.  Maybe you can call
> mutex_release manually (and mutex_acquire before unlocking).
>
> Paolo

Hmm this seems to be working thanks Paolo. To lock I have been using:

...
                  if (mutex_lock_killable_nested(
                              &vcpu->mutex, i * SEV_NR_MIGRATION_ROLES + role))
                          goto out_unlock;
                  mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
...

To unlock:
...
                  mutex_acquire(&vcpu->mutex.dep_map, 0, 0, _THIS_IP_);
                  mutex_unlock(&vcpu->mutex);
...

If I understand correctly we are fully disabling lockdep by doing
this. If this is the case should I just remove all the '_nested' usage
so switch to mutex_lock_killable() and remove the per vCPU subclass?
