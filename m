Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6661EBD2A7
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 21:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410059AbfIXT3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 15:29:43 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37828 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409758AbfIXT3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 15:29:42 -0400
Received: by mail-io1-f68.google.com with SMTP id b19so7360077iob.4
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 12:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlxJHpznckyuwdTkHdoIvI3qOBLk0dtkYKkNDm0OIJ4=;
        b=kxbCn9IYyVKzA1767Xf/1mXVPBFiRqUfbN2b9Whs2SmJuOErkgtEV20F9+pbGhsl/z
         sngqbsiWTUVNh1rwllFjLIOoQqIC/lIT8oFlBjgZ5RvE44Zwct/agANNxrHLJTjrXiDQ
         E+eKyx308FPwO+9iWxdFvnb8ulIHvXoxu7cP8AJ0UJNeoFcAABNzX5cDSyf3oQcbmO94
         I9ss9wkOh7yWLIcej0S9Hxjk7FE9UAeLoZuun9rPLpzTHF0iXIoBCZkCrgM4G+MqC54n
         K/YGDTGly0fem6fvw2Z7V3nJGzLbrx14bwuTzck1l7edQYseGyLuweQ6XhxArXxQTTcS
         nwEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlxJHpznckyuwdTkHdoIvI3qOBLk0dtkYKkNDm0OIJ4=;
        b=TzGhGhOEznKo9Jiii0UUumd6ONkW2Wgkw3vZ4OjuVsO7cDQC6ryjzb+YdMbiIcEpOU
         ENzE9uEG4W5b6PfTREs3rQaySa68utvs048rMtLnXSvW6R6xq7upaQgTq8yiEJdfYHxY
         oZgUe67A5QyAXDmOvg+yEvuhtyAR44r6z4bsm21h3BXkdaKAP9J/Sxyd32wAxmjJCHp4
         71y3UkY0KQonPpnwcJTBMmVsXy6R+6bcLrBcWsnDa3JAASeZU1F4icFqGBh+0HddXKw7
         5l7k3mTrqBcgzPztG6dwiSB9zA2sCbeExMYFBKVvaY7L1UwLjDPzQSJt1lU9lIYVORNN
         llCA==
X-Gm-Message-State: APjAAAWT4WoPAGr0JSrEaNLMQel8hxwoes30O2gplyRNn7Ln3Vp26xsD
        7D4nL4rV01gqzgoY1yRx+vmqaAy1TUGAzAI7gUjPWZTGSl8=
X-Google-Smtp-Source: APXvYqwPBrv6kd14YEMBIDX64YYawTq+yBAOBEfw4PbQUePO3/twx/dldwsMmNvAcKUcS45lqxgIkX3zjdEm3MV4Eyg=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr5306033iom.296.1569353380758;
 Tue, 24 Sep 2019 12:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190919230225.37796-1-jmattson@google.com> <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
 <30499036-99CD-4008-A6CA-130DBC273062@gmail.com> <CALMp9eTT4mhVtkBCqW_YFDiYSoPCsir6u0j+rqOeoFZui+enzg@mail.gmail.com>
 <7ADCB7CB-605D-411A-A082-98B67B7982BE@gmail.com>
In-Reply-To: <7ADCB7CB-605D-411A-A082-98B67B7982BE@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Sep 2019 12:29:29 -0700
Message-ID: <CALMp9eTiM4+ZnnnXLP-TNrrjfn3DLAurkcY+2Jom5wWqzFe0Jw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 11:14 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Sep 24, 2019, at 11:09 AM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Tue, Sep 24, 2019 at 10:29 AM Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> On Sep 20, 2019, at 12:44 PM, Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
> >>> <krish.sadhukhan@oracle.com> wrote:
> >>>> On 9/19/19 4:02 PM, Jim Mattson wrote:
> >>>>> Ensure that support for RDPRU is not enumerated in the guest's CPUID
> >>>>> and that the RDPRU instruction raises #UD.
> >>>>
> >>>>
> >>>> The AMD spec says,
> >>>>
> >>>>        "When the CPL>0 with CR4.TSD=1, the RDPRUinstruction will
> >>>> generate a #UD fault."
> >>>>
> >>>> So we don't need to check the CR4.TSD value here ?
> >>>
> >>> KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.
> >>>
> >>> However, I should modify the test so it passes (or skips) on hardware. :-)
> >>
> >> Thanks for making this exception. Just wondering: have you or anyone else
> >> used this functionality - of running tests on bare-metal?
> >
> > I have not. However, if there is a simple way to add this testing to
> > our workflow, I would be happy to ask the team to do so before sending
> > submissions upstream.
>
> I guess I should build some script that uses idrac to automate this process.

I'm not familiar with idrac. What sort of functionality do you need
from the test infrastructure to automate this process?
