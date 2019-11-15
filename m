Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9267FDAEF
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfKOKQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:16:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36460 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfKOKQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:16:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id f10so7594560oto.3;
        Fri, 15 Nov 2019 02:16:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L31Kfs1iCtI5iVDCuelWcjeMJ55bO+AtIuo4wI7qu9U=;
        b=B3sScFr8xItN+PCAKQAeRtJPGIG/pfOvxOmeRw2G6qAdfPkZj8qMwOJpELvgThUmt4
         2aSkHajUnXFEAqLNao9XP/fVdop+7zeBwAJI8ZC9cPsEcG1XqO5j6ppGIP6XcK/L5RsS
         hxdYR6nGSdtTUw+9HzQZItpH682WZn78HDdnRAmIE6St8Z0PbfyT6gtJgpxTuOB6+MjD
         qT2gVoHP+BjEv/CSFGO5Yhwz9cGOVInHzLVuPXwLDaBqgu6HtJ9+Q7YtunJQwv/xAV79
         wrQOVqj2xGvt9mvF4DSs+Qxtg4qfULjfH6wfzs2msdd/pvbG5OZ6kODKCi/lN9hHxsIv
         rY6w==
X-Gm-Message-State: APjAAAX3Vh4Xq/5l8/47MG55cxH8ZTiueF0Btt4y/sjgAFwAF6X7A7/d
        F2GKQ+hKzVRqJpVUFSn78h6Id/NuNEVOsUwuMWc=
X-Google-Smtp-Source: APXvYqxZ/bAtMq18l9mpuCAsg44KJyrcgmnqVoIIx4Mk+o7r4aPh25WzgicKYS/aWkTqw5pQAng03Fta3Cmam/OYkEQ=
X-Received: by 2002:a9d:590f:: with SMTP id t15mr10089371oth.118.1573813017367;
 Fri, 15 Nov 2019 02:16:57 -0800 (PST)
MIME-Version: 1.0
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
 <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com> <2090510.mhlLnX9yIq@kreacher>
In-Reply-To: <2090510.mhlLnX9yIq@kreacher>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 15 Nov 2019 11:16:46 +0100
Message-ID: <CAJZ5v0i4b0hvGjSjSpBnZ-huJZGi3FmN1z5NVc_4V6CForaLfA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/4] cpuidle-haltpoll: ensure grow start value
 is nonzero
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 11:06 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> On Wednesday, November 6, 2019 12:54:59 PM CET Zhenzhong Duan wrote:
> > dev->poll_limit_ns could be zeroed in certain cases (e.g. by
> > guest_halt_poll_ns = 0). If guest_halt_poll_grow_start is zero,
> > dev->poll_limit_ns will never be bigger than zero.
>
> Given that haltpoll_enable_device() sets dev->poll_limit_ns = 0 to start with,
> I don't think that the statement above is correct.

Scratch this, I misread it.
