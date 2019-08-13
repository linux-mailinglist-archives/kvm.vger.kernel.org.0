Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E84F8AC4D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 02:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfHMAzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 20:55:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36797 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMAzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 20:55:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id k18so34095076otr.3;
        Mon, 12 Aug 2019 17:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tWuGMpfvpi8rnoPC1nxIMSH77huA/siJ3AWEzI3xTs4=;
        b=cdoqbO7X+MHlqsYbY8wcYKMu8ZiVU/PnEECnYlul350769xA+jJ/DHDldH73SJHM9x
         jCLEZaXj0eOs0lrUj/ZbAkmBErQaxUQK4lgaGUk0G8vW1Hm6UkVtac5jxe1WMHj74dDn
         sJuOrHlmsazBackDrzbtX8BaRJCxCqX7DxYWMpizL9scBtr3lJM9wDIkOX15UNTQZstN
         H8dTO/vlWkBYZlbVfI4x6A4UmaX1W8N3IJhwl1Y+AkRAb58zX+Y070wQY3OU61v7fixw
         tX+2QdSDxNJABKy99euf/v0NwPY0pItxvKVSa+rBMsZnBoY1V/Nmu7ol86/vv9BqD4h4
         Bscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tWuGMpfvpi8rnoPC1nxIMSH77huA/siJ3AWEzI3xTs4=;
        b=tqJo4HMbxz9RHyhHdKTSFGgggln4JoaOtdO6q3DbfkPuoC5XHS0vEh9oIaYUIEar1H
         RCNacQ7CaDbOPMXy4cdbPs7Rs6aqBiF5XWUmOb9eitoxF2vesMrbDmqaFYKreXaeOhsQ
         bbRjFPo8hj4dRa3QqNeWMaaogW3FdBzr9ZCe49qIgqM1bnlyjW/XwxrCH29x4cG5dLC2
         SqdRwqSS7UT/u0QAOQeurbZvAZbxrE8Kpo4/Ifoe+NB6NIkPAA9n8ITDa2P76TbLRLDO
         6IZgK/iNJEUhfN6f3XLrkMI3tOsfznD6WQG5RMWeDaMshPOqViyHk5q6SQNqGwg/bmBa
         BwcA==
X-Gm-Message-State: APjAAAX03r16gPkf/DeHbeXzrP1NNv08SwZFRoMt0DTIoA8lLm+c8xXD
        Ua/bb9fw+wHaEYCEHw5U8pVl8p9eYlhNHkH+0Hk=
X-Google-Smtp-Source: APXvYqxFUejRwv90klmWLQY0ZnGSa/zWt+ZB47N82vsS2BbcZs9ZZ7OVLxQ2jCM+HFwTwqP1mrDp6dwz7pFH0Le1m4w=
X-Received: by 2002:a9d:1b02:: with SMTP id l2mr28824055otl.45.1565657741864;
 Mon, 12 Aug 2019 17:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com> <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet>
In-Reply-To: <20190803202058.GA9316@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 13 Aug 2019 08:55:29 +0800
Message-ID: <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > >> From: Wanpeng Li <wanpengli@tencent.com>
> > >>
> > >> The downside of guest side polling is that polling is performed even
> > >> with other runnable tasks in the host. However, even if poll in kvm
> > >> can aware whether or not other runnable tasks in the same pCPU, it
> > >> can still incur extra overhead in over-subscribe scenario. Now we ca=
n
> > >> just enable guest polling when dedicated pCPUs are available.
> > >>
> > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Paolo, Marcelo, any comments?
> >
> > Yes, it's a good idea.
> >
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >
> > Paolo
>

Hi Marcelo,

Sorry for the late response.

> I think KVM_HINTS_REALTIME is being abused somewhat.
> It has no clear meaning and used in different locations
> for different purposes.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
KVM_HINTS_REALTIME 0                      guest checks this feature bit to

determine that vCPUs are never

preempted for an unlimited time

allowing optimizations
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Now it disables pv queued spinlock, pv tlb shootdown, pv sched yield
which are not expected present in vCPUs are never preempted for an
unlimited time scenario.

>
> For example, i think that using pv queued spinlocks and
> haltpoll is a desired scenario, which the patch below disallows.

So even if dedicated pCPU is available, pv queued spinlocks should
still be chose if something like vhost-kthreads are used instead of
DPDK/vhost-user. kvm adaptive halt-polling will compete with
vhost-kthreads, however, poll in guest unaware other runnable tasks in
the host which will defeat vhost-kthreads.

Regards,
Wanpeng Li
