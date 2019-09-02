Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD6FA5DB2
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfIBV66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 17:58:58 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38339 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfIBV66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 17:58:58 -0400
Received: by mail-ot1-f65.google.com with SMTP id r20so14774558ota.5;
        Mon, 02 Sep 2019 14:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7umLTaLdGe1hHSWworo6BV12SB2LrfownKt9R73/cvo=;
        b=SyHn+yVLKJ0Rr4hef7XgTaQP9IxgDuHAoWAQPB/LMgQshPKbtrNWXKqzt/BgNsCZJK
         Iygv9vz9Vb8PhB9UrB0UTMkXmdNOvhRyuOseb4mmsG96GvTWwlOD2dOb4PC2mVgzglIo
         Tciu9DENimUFXSeO0JfJ2MPJz4c7Jjx6ZEoofitc3G61W8nNpGNU6WC7LmPtj3qnqvx8
         FC49KmFJzRytkTteNsXUeoNP2IfcPSW8y3ASGmy3qTQlSJjOVliJOPpMViw99mly68od
         47/YN1h7jvmQmSPb7rb0CYjjhYZ/OYmhIF5wnC9MOmk7IzyD/9fq19n7G5VPSAu1AWjr
         SQFQ==
X-Gm-Message-State: APjAAAVXEUyMNss7INUHnEwI6XD43H/RZVzxH5k3NrzgFSgCl6yTHSCk
        JQwEQwQZ1e51l7AmpXr8/v3SfiG+SyEwxvjN5VY=
X-Google-Smtp-Source: APXvYqyNPqIRHrwfTvQ6h0ibZN99dew5nh6HMQWZhP6IuvP5guFJCZW0TfCqQW1DzWZCd/ZBGt9VNTHVj6Bx73jyi0c=
X-Received: by 2002:a9d:12d1:: with SMTP id g75mr24854511otg.189.1567461537014;
 Mon, 02 Sep 2019 14:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com> <d1d4ade5-04a5-4288-d994-3963bb80fb6b@linaro.org>
 <6c8816af-934a-5bf7-6fb9-f67c05e2c8aa@oracle.com> <901ab688-5548-cf96-1dcb-ce50e617e917@linaro.org>
 <722bd6f6-6eee-b24b-9704-c9aecc06302f@oracle.com> <2e2a35c8-7f03-d7c8-4701-3bc9d91c1255@linaro.org>
 <f8c63af5-2509-310d-7ba0-7687b20e3b44@oracle.com> <b759d5a9-f418-817e-eefa-2302d17cb6ea@linaro.org>
 <b164bd75-bc9a-0f07-e831-004a0bb5fe1b@oracle.com>
In-Reply-To: <b164bd75-bc9a-0f07-e831-004a0bb5fe1b@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 2 Sep 2019 23:58:46 +0200
Message-ID: <CAJZ5v0ixpAgdbSfLG=ZAKyF1K35XbeMBZE76+wqoqKBCLy_RLQ@mail.gmail.com>
Subject: Re: Default governor regardless of cpuidle driver
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 1:09 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 8/29/19 10:51 PM, Daniel Lezcano wrote:
> > On 29/08/2019 23:12, Joao Martins wrote:
> >
> > [ ... ]
> >
> >>>> Say you wanted to have a kvm specific config, you would still see the same
> >>>> problem if you happen to compile intel_idle together with haltpoll
> >>>> driver+governor.
> >>>
> >>> Can a guest work with an intel_idle driver?
> >>>
> >> Yes.
> >>
> >> If you use Qemu you would add '-overcommit cpu-pm=on' to try it out. ofc,
> >> assuming you're on a relatively recent Qemu (v3.0+) and a fairly recent kernel
> >> version as host (v4.17+).
> >
> > Ok, thanks for the clarification.
> >
> >>>> Creating two separate configs here, with and without haltpoll
> >>>> for VMs doesn't sound effective for distros.
> >>>
> >>> Agree
> >>>
> >>>> Perhaps decreasing the rating of
> >>>> haltpoll governor, but while a short term fix it wouldn't give much sensible
> >>>> defaults without the one-off runtime switch.
> >
> > The rating has little meaning because each governor fits a specific
> > situation (server, desktop, etc...) and it would probably make sense to
> > remove it and add a default governor in the config file like the cpufreq.
> >
> ICYM, I had attached a patch in the first message of this thread [0] right below
> the scissors mark. It's not based on config file, but it's the same thing you're
> saying (IIUC) but at runtime and thus allowing a driver to state a 'preferred'
> governor to switch to at idle registration -- let me know if you think that
> looks a sensible approach. Note that the intent of that patch follows the
> thinking of leaving all defaults as before haltpoll governor was introduced, but
> once user modloads/uses cpuidle-haltpoll this governor then gets switched on.
>
> [0] https://lore.kernel.org/kvm/c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com/
>
> I would think a config-based preference on a governor would be good *if* one
> could actually switch idle governors at runtime like you can with cpufreq -- in
> case userspace wants something else other than the default. Right now we can't
> do that unless you toggle 'cpuidle_sysfs_switch', or picking one at boot with
> 'cpuidle.governor='.

FWIW, I've been thinking about getting rid of the cpuidle_sysfs_switch
command line option and always allowing user space to switch cpuidle
governors at run time.  At least I see no reason why that would not
work ATM.
