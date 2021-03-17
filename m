Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECC933EB02
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 09:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhCQIFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 04:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhCQIEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 04:04:43 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EC3C06175F;
        Wed, 17 Mar 2021 01:04:32 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so955349otn.10;
        Wed, 17 Mar 2021 01:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6d4hql6beHlJvtGdXFqP32SA7zCDyKRSTthLnZwVdw=;
        b=BjkOPx3gzuXisgtXasdvVao9c+d8xN2Pni7eCpDXO9OaznRZOoefKM+lc+9aGh9uGE
         2k4gyDTIiSgPaWbdj9D/EpgURv8377i5cHHjdLqWGwxJQoybpT7HQyYDC9iIfokvIKyk
         HHrh/lgeV4AgsTuQ0Eh49e/sCthkceaO9HyOiWgpSEWonGnR/hDXdblE3vQcTsoJ4VGD
         t60XJ2ULfkI8/mdHARKhIJ5SnjKjPaBKPsTmEpwzM7X/tj4Nrj6/otkOlZ0vDVyFmBtX
         V3REF5P/HElAkZTrzBdT8eKPiAqGzP1VmWkwgoMxGQCJzszm7gZSpa6F3OImfTcXzuW7
         1l1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6d4hql6beHlJvtGdXFqP32SA7zCDyKRSTthLnZwVdw=;
        b=Azc+MaoUohu3WkqIAB52oetKenIJemHxJ4qxPT0ZvCar7Ftk557E+d8Z29TFYQ+tKo
         BAjCxuJ3G/caReF5iPgdzSfPcby3uCkZepQwBCqnxKNuw2xpc9R8ZFKOFOD/T2iRKn23
         2U1DtIjdHdl2fQIr/I6HeJLF1YzKUdKgp2IlkOzI6vc+JuYs2zb4281DzxFqXbnqgmxu
         9MQ318yzoVgcCjMs2Q263qqce+TU2VcNmvf4mXx2pQzhB7kgXsazleOHQuGPQIQzLZll
         BGiH9GzQp09wujQpvTp4i3oxFpwYb1Ekjd4hE0NN04NxIJU1+YNMvUiYkhc/MzQ/NseS
         wm1g==
X-Gm-Message-State: AOAM5307sm7U1lgAuCZR6P8aXNA/iGO60tHsMddRbmg+jYOzlhllNFGe
        WOQQB87MgSzrs0XUZfgnbHQR6dAU3BeZ3R8vv0o=
X-Google-Smtp-Source: ABdhPJy3n/4zKDqhiXVmtvJII3U5OXj6gaaXPuZhLyohpd4m1n1A4B4yW5TKpMggH/7tLgc669TtltOiprfCIE1JB64=
X-Received: by 2002:a9d:470b:: with SMTP id a11mr2291931otf.254.1615968271723;
 Wed, 17 Mar 2021 01:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com> <YFG2Z1q9MJGr8Zek@dhcp22.suse.cz>
In-Reply-To: <YFG2Z1q9MJGr8Zek@dhcp22.suse.cz>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 17 Mar 2021 16:04:20 +0800
Message-ID: <CANRm+Cxi4qupXkYyZpPbvHcLkuWGxin4+w7EC+z0+Aidi5+B5A@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm: memcg awareness
To:     Michal Hocko <mhocko@suse.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Mar 2021 at 15:57, Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 17-03-21 13:46:24, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > KVM allocations in the arm kvm code which are tied to the life
> > of the VM process should be charged to the VM process's cgroup.
>
> How much memory are we talking about?
>
> > This will help the memcg controler to do the right decisions.
>
> This is a bit vague. What is the right decision? AFAICS none of that
> memory is considered during oom victim selection. The only thing memcg
> controler can help with is to contain and account this additional
> memory. This might help to better isolate multiple workloads on the same
> system. Maybe this is what you wanted to say? Or maybe this is a way to
> prevent untrusted users from consuming a lot of memory?

It is explained in this patchset for x86 kvm which is upstream, I
think I don't need to copy and paste. :)

    Wanpeng
