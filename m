Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23046D948
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 18:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhLHRNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 12:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbhLHRNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 12:13:11 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BEEC061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 09:09:39 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id q74so7433280ybq.11
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUOCCwERsiAdkftIilxYjt7sMB07w0Aw7ZE6U72nToY=;
        b=ydwJqeSrwGb5kN9CFJL2J40jM6FNTAbaqRAmuH4a+1dG69EjKIjsUxoRr/3INzl/mh
         bvHj1l4mHw/40ly3ZpIw9jRw48NosBJgbQcDYLoPIpAvBDKxh+GGYw7bKRNcToISOnbc
         9L4p/wsWuEJvl0wk8qh/67ffFX8ZMXbpZkpPyoF8JROl0i0lMi2gM051+5bbcf/4uDIH
         TRi+Y9OYi3jeDYxZjiYAk4rZQ/aav9IwpwQIYyTL6NmTilQzlmXDm8hl4cJzo/OxpeEw
         iG1OnZwJR4Uc5+r0mkSw7hBO5zou99d/az2nm6gqwoIEdpgihoV4rWRJJyxtfxN3zQN6
         Vy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUOCCwERsiAdkftIilxYjt7sMB07w0Aw7ZE6U72nToY=;
        b=mi6Vr7WIqQ3r1+6B5iSlE9aJzyWqU9QpGrKDJvmWUR3odxPj55OSA96eeWAS7tQaDu
         XhAH+RX78iGCnHG7AymcPmQ6H6yMfiriPKRFvcvKIUBUxxrywT5YO9JXzzJsOJvc7+v3
         gkAPxcSkX537afIfzqfoGun4+Gg9AazzyLWryKr5SbdU+RHNMhSX5YzLosz7bLbByH0i
         Z9QZUY9UWo3OT+sM6+tLQCfZBpAogfwCda/JaI3+wpfilIpvwUGMGYnMTF90qLiRqhR1
         QyyX5bWCxXMypbo5WGKkvAuXrdeER7jVlZ7g+Cxtbgpn2MD1rgKZVsBUdSKbWzP2qjNy
         bP+w==
X-Gm-Message-State: AOAM5300K7T6S7/gBo7T0m2S2oOZV/5k+pQmsaTztPnU/BaFrO/g4dxy
        HLhsUwxqrmoy37tOtnsMIBqkZu3KcVJ1AqRMsiJVyQ==
X-Google-Smtp-Source: ABdhPJx1JNbWtK7HoaHftGxEdC8QXoFVlqqI4oL/Q7n9xsAzch2AQKRq4GthFfjo9C+wc8clvH9ZTMt9Tc0L2yGdiIU=
X-Received: by 2002:a25:287:: with SMTP id 129mr63010099ybc.524.1638983378187;
 Wed, 08 Dec 2021 09:09:38 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtSx_OFkN1csWGQ2-pP1jLgziwr0oXoMMb4q8Y=UYPGqAg@mail.gmail.com>
 <Ya/fb2Lc6OoHw7CP@google.com>
In-Reply-To: <Ya/fb2Lc6OoHw7CP@google.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 8 Dec 2021 12:09:22 -0500
Message-ID: <CAJCQCtTzQAWdMOp_JKMw-UTocBg=qBhm2ZCU_ykiY5Epe9Bn_Q@mail.gmail.com>
Subject: Re: dozens of qemu/kvm VMs getting into stuck states since kernel ~5.13
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chris Murphy <lists@colorremedies.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 5:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 07, 2021, Chris Murphy wrote:
> > cc: qemu-devel
> >
> > Hi,
> >
> > I'm trying to help progress a very troublesome and so far elusive bug
> > we're seeing in Fedora infrastructure. When running dozens of qemu-kvm
> > VMs simultaneously, eventually they become unresponsive, as well as
> > new processes as we try to extract information from the host about
> > what's gone wrong.
>
> Have you tried bisecting?  IIUC, the issues showed up between v5.11 and v5.12.12,
> bisecting should be relatively straightforward.

We haven't tried bisecting. Due to limited access since it's a
production machine, and limited resources for those who have that
access, I think the chance of bisecting is low, but I've asked. We
could do something of a faux-bisect by running already built kernels
in Fedora infrastructure. We could start by running x.y.0 kernels to
see when it first appeared, then once hitting the problem, start
testing rc1, rc2, ... in that series. We also have approximately daily
git builds in between those rc's. That might be enough to deduce a
culprit, but I'm not sure. At the least this would get us a ~1-3 day
window within two rc's for bisecting.

>
> > Systems (Fedora openQA worker hosts) on kernel 5.12.12+ wind up in a
> > state where forking does not work correctly, breaking most things
> > https://bugzilla.redhat.com/show_bug.cgi?id=2009585
> >
> > In subsequent testing, we used newer kernels with lockdep and other
> > debug stuff enabled, and managed to capture a hung task with a bunch
> > of locks listed, including kvm and qemu processes. But I can't parse
> > it.
> >
> > 5.15-rc7
> > https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840941
> > 5.15+
> > https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840939
> >
> > If anyone can take a glance at those kernel messages, and/or give
> > hints how we can extract more information for debugging, it'd be
> > appreciated. Maybe all of that is normal and the actual problem isn't
> > in any of these traces.
>
> All the instances of
>
>   (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x77/0x720 [kvm]
>
> are uninteresting and expected, that's just each vCPU task taking its associated
> vcpu->mutex, likely for KVM_RUN.
>
> At a glance, the XFS stuff looks far more interesting/suspect.

Thanks for the reply.

-- 
Chris Murphy
