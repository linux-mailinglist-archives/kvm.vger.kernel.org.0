Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DBB33EB07
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 09:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCQIFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 04:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCQIFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 04:05:03 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE47C06174A;
        Wed, 17 Mar 2021 01:05:03 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id w1-20020a4adec10000b02901bc77feac3eso351022oou.3;
        Wed, 17 Mar 2021 01:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5NGxaWCaBJWoG0b5sm40J/0n4KRIeeKYnwNe0wAf5w=;
        b=jKAcf2c0cIfKN1ASZn8CJwucx5JT5I0l8hVHnUYSDKeIqnpsCnqWvXmWIqE8PVV3Li
         NC28oTmZTqWZQR72SbvCA8n9HSD/bha3E3J3s6PhfZyYI66cno0L65eK0OUqY7CMfAqC
         6U1FfW7THkyudQk++ZWoWYw4ol4mquRT1z7wKPf+thRJsOnFJbMj50mvpi3+EtOItTOn
         90xCV5EZPLohhOBA4nJTHzY+AwiJQbo2HDAhNCo59JridDMzrU4LUtdkWO7fpK8GqkTy
         vWt4jXXQIT6JpXdk9m3Rv5OxtlwUDEk5jKIUiq4wFIOh+i3x547Qct4W1vAzQGszfAWb
         wQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5NGxaWCaBJWoG0b5sm40J/0n4KRIeeKYnwNe0wAf5w=;
        b=B7dRTIDSHjdMTk5DAw6RRtjK/PInvYuhH1IGniwcDP6siUmCDZxtBHb6/p4PUWFh7h
         VD4I06kgIjkzgubi7kcvE1JdusO2jpuJedfeTE1fEBcHIvh+q3G7R6e3lnhut3nUQJHa
         siqq5OrLR2w9LHFgOYYqif5HKA1yXS2sye1GSmFTi6SvfhBMuiwHuXU3QAgtaKZTecrC
         znoFCQwx2OS2ug8X3nLjK2Be+mGmE++kHdr7E9K23QzmnOXnxAMOUXiLpJTpK0CJUIvy
         64VaLix2Zi/23k7gJcxOn/V7YoJS0w7FtG1vWCvAV7H/qceGA9TAwBFzvq1FfwqNepkF
         YWcg==
X-Gm-Message-State: AOAM531rk1w1S6yE6ZbsuWTtPk5o8bQkU+fX9IrrVTMzKq2S8/dZDQ92
        szDzwu08AA5IH296Ialf4jJbH1zosmfgwPGQsJ5rRiImgpU=
X-Google-Smtp-Source: ABdhPJzhQlfli9hHPmtTaNTOLZGOiH0Lka2doKQtyNoyAVXCZ8OlNEc70wNMLO83OA5qjPKnvJgPO5ykFd4OLoQrzpg=
X-Received: by 2002:a4a:8ed2:: with SMTP id c18mr2375227ool.66.1615968302508;
 Wed, 17 Mar 2021 01:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
 <YFG2Z1q9MJGr8Zek@dhcp22.suse.cz> <CANRm+Cxi4qupXkYyZpPbvHcLkuWGxin4+w7EC+z0+Aidi5+B5A@mail.gmail.com>
In-Reply-To: <CANRm+Cxi4qupXkYyZpPbvHcLkuWGxin4+w7EC+z0+Aidi5+B5A@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 17 Mar 2021 16:04:51 +0800
Message-ID: <CANRm+CwLBAPwwZzHB8U2SDMHKer_NtOKfAk52=EHUpG-SqxJWg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm: memcg awareness
To:     Michal Hocko <mhocko@suse.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Mar 2021 at 16:04, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Wed, 17 Mar 2021 at 15:57, Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Wed 17-03-21 13:46:24, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > KVM allocations in the arm kvm code which are tied to the life
> > > of the VM process should be charged to the VM process's cgroup.
> >
> > How much memory are we talking about?
> >
> > > This will help the memcg controler to do the right decisions.
> >
> > This is a bit vague. What is the right decision? AFAICS none of that
> > memory is considered during oom victim selection. The only thing memcg
> > controler can help with is to contain and account this additional
> > memory. This might help to better isolate multiple workloads on the same
> > system. Maybe this is what you wanted to say? Or maybe this is a way to
> > prevent untrusted users from consuming a lot of memory?
>

https://patchwork.kernel.org/project/kvm/patch/20190211190252.198101-1-bgardon@google.com/

> It is explained in this patchset for x86 kvm which is upstream, I
> think I don't need to copy and paste. :)
>
>     Wanpeng
