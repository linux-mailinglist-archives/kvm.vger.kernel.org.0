Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0EF27AD43
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgI1LxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgI1LxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 07:53:09 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E96C061755;
        Mon, 28 Sep 2020 04:53:09 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 26so977901ois.5;
        Mon, 28 Sep 2020 04:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQxf8eR0dURUFnxSfO8awhZP1MTj2t0jw3MmlFzeHs0=;
        b=GMtSjZZfxG9MbEdffePlO1h7sC8ZgA63nZOWgJl6O48iDiGXuLeFSRWMwtxi8ApR5d
         WO6QHpzwYEQSnol1QWCM3fhLtodSPBObnSi4NDrpDMe/DlxKbN/cxOp6H5x+B06ytI2D
         ZABv1vTdi2CWD6G3MMfXTr3IiEVXXt84u/gtI6VqlnMe2o6aoHbl7XzHxU9iRK53asTK
         K4Y3AxkrNychFccLD+p9Rp5/UQc23Jku0q/1HOBxumpU+GZhV0sFFMNnYTCmjZtSEzGL
         adr1lYYEIT/L8/F76Sg8WB8Yy9ZdkPDAsJ7FfgnxD3Rjd5Hb3YvUuyndx/F7R+2Ycnjm
         PVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQxf8eR0dURUFnxSfO8awhZP1MTj2t0jw3MmlFzeHs0=;
        b=nGYPNMKt3aVvGWMGSxDPEepyzRcZ1WTNB18ulVPAvlvbtl1O/F0a6pepRRz0Msb4lm
         l4x3MlhWzkoVmMfAR4cRJ61Xz7CcR4CaBhYKSHreyKpI0no9W917AqxVasFpPrBrKutv
         LnxCuVSwldwb0sRdSUhFsayFco9KrTCEguIWcJ6icBSc822T6aQgBiXcvvV0M+sDRdF4
         hhIEZga+eG7lSlgjraxAEc1BKJuFLSzAzUrIEGLVviWvvJEtngTy4714pviAFy0UOnl5
         4+IEH3f0G83p48nxJONFvhbe04YFe7JOe5c4hVJ5iUFbsedeFhY+IOZ/Jxi/obF7bF6x
         nqXg==
X-Gm-Message-State: AOAM531dFTLtgCXmvIrJXrzLcGpLnDROWtCWsNvHANs8doAvfNZi24AH
        io2p2YHHIxCNet+iNcruGZGDxzmf3RUucWyH+Lw=
X-Google-Smtp-Source: ABdhPJxlSoQmFcr9h6f4O8+MFkJPm4gQcBxjML8NNr9yV3njDHhlIjZIlTgJiAkWjrev48D1bqggdKZvPN7/31UXFe8=
X-Received: by 2002:a05:6808:98f:: with SMTP id a15mr665150oic.58.1601293988496;
 Mon, 28 Sep 2020 04:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598868203.git.yulei.kernel@gmail.com> <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
 <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
 <CANgfPd8uvkYyHLJh60vSKp1ZDi9T0ZWM9SeXEUm-1da+DqxTEQ@mail.gmail.com>
 <CACZOiM1JTX3w567dzThM-nPUrUksPnxks4goafoALDq1z_iNsw@mail.gmail.com>
 <CANgfPd-ZRW676grgOmm2E2+_RtFaiJfspnKseHMKgsHGfepmig@mail.gmail.com> <2592097d-3190-1862-b438-9e1b16616b82@redhat.com>
In-Reply-To: <2592097d-3190-1862-b438-9e1b16616b82@redhat.com>
From:   yulei zhang <yulei.kernel@gmail.com>
Date:   Mon, 28 Sep 2020 19:52:57 +0800
Message-ID: <CACZOiM3LdZKyDEPswa1tcKW3-joJMk0jHU3fDn-v9K8hOo1vvQ@mail.gmail.com>
Subject: Re: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, Wanpeng Li <kernellwp@gmail.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 26, 2020 at 4:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 19:30, Ben Gardon wrote:
> > Oh, thank you for explaining that. I didn't realize the goal here was
> > to improve LM performance. I was under the impression that this was to
> > give VMs a better experience on startup for fast scaling or something.
> > In your testing with live migration how has this affected the
> > distribution of time between the phases of live migration? Just for
> > terminology (since I'm not sure how standard it is across the
> > industry) I think of a live migration as consisting of 3 stages:
> > precopy, blackout, and postcopy. In precopy we're tracking the VM's
> > working set via dirty logging and sending the contents of its memory
> > to the target host. In blackout we pause the vCPUs on the source, copy
> > minimal data to the target, and resume the vCPUs on the target. In
> > postcopy we may still have some pages that have not been copied to the
> > target and so request those in response to vCPU page faults via user
> > fault fd or some other mechanism.
> >
> > Does EPT pre-population preclude the use of a postcopy phase?
>
> I think so.
>
> As a quick recap, turn postcopy migration handles two kinds of
> pages---they can be copied to the destination either in background
> (stuff that was dirty when userspace decided to transition to the
> blackout phase) or on-demand (relayed from KVM to userspace via
> get_user_pages and userfaultfd).  Normally only on-demand pages would be
> served through userfaultfd, while with prepopulation every missing page
> would be faulted in from the kernel through userfaultfd.  In practice
> this would just extend the blackout phase.
>
> Paolo
>

Yep, you are right, based on current implementation it doesn't support the
postcopy. Thanks for the suggestion, we will try to fill the gap with proper
EPT population during the post-copy.

> > I would
> > expect that to make the blackout phase really long. Has that not been
> > a problem for you?
> >
> > I love the idea of partial EPT pre-population during precopy if you
> > could still handle postcopy and just pre-populate as memory came in.
> >
>
