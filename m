Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA99407AEF
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 01:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhIKXwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 19:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbhIKXwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Sep 2021 19:52:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CB8C061757
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 16:51:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c22so6855609edn.12
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 16:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leRkWwyCkV+yLUurqNTXB1nL9C8rNgcr6OELrhx3Jh8=;
        b=gL9zMnhkSMLvxK+1ORTO87nJ6ziEdxePIUddJb9MU/H/b15xiTMoLElusVn7wTRzxO
         HR9q+RVjGgJhMDSHwRkGwxZpWDIvbOLOTV54AJB9YvTfv70yaulz+Sjga4pY8KhfT7/G
         Po3KHsveH9GZZXTT8mQ0uJ3JV+KIXYNzetPi92eNXuhrIVruJhpQEyQEIUCuNJJQPQzs
         0AkFPYOgOfgkSfQlg0ZEvbaxqUoTvlgwvGtS55NpX/yVPVygP12toyz4lbG87EnH9pxE
         T3ZNd8cFflsjP5dbJ6qEqY4PMcDpEA/yGA9lKIY0vibJhsnbMt5f1mhX3GQxoU43j5gK
         GnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leRkWwyCkV+yLUurqNTXB1nL9C8rNgcr6OELrhx3Jh8=;
        b=boH1gVLg+wKh9swfRw0zk4IVmef0iYK4NgpZuMTuVlJdJxfavymWmxDmjmBnPvcdrw
         AiSycCicglkEtnL4eoPcFXKMfEqbbBobBg7p11tp39NJM/adUb87tJv7YeN8Wfp0vjda
         cgU+GAk+9glW+5zQ1kNpxRSezQphw5YvHU+jCnE/5k4QDrZWDyUqAJjVZPDOYFcJFGX+
         14MHYK3wVE3csQ+ckt/516n9kfH+mr3EcjlfBeu9TYBoajjSQtJXqbtTMVA68wTKQG+C
         Zwshwu0pjBOAfmPdxKTMKxKJ2ZCWI1ffBV8e4aoG7haQeK0GDr5N9Y8lYEb3llSqJQpb
         fbkA==
X-Gm-Message-State: AOAM530u2UDSrSdG0cRvdr9Ajc3/1K7EpWnGtk5vWI2szqciErUmNnra
        ZYvzr16DJ/AmChZ/GNBEWRLFR1UknoHLZf9G7li3
X-Google-Smtp-Source: ABdhPJzK/CRmdCFffCTwQY+B+wt6+tYYUxEXqrspDHfHmPcttKC/M87U7T1G1dYXYhzDLPuaD2Zd8iaLrA9S+FXso0k=
X-Received: by 2002:a05:6402:6cf:: with SMTP id n15mr5371170edy.85.1631404288117;
 Sat, 11 Sep 2021 16:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210909095608-mutt-send-email-mst@kernel.org> <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgcXzshPVvVgGDqa9Y9Sde6RsUvj9jvx0htBqPuaTGX4Q@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sun, 12 Sep 2021 07:51:17 +0800
Message-ID: <CACycT3ter3tB=hcTWFLboXdSsn-ZBVb8iHZCn4tv3NsnsS3TjQ@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vdpa,vhost: features, fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>, Wolfram Sang <wsa@kernel.org>,
        xianting.tian@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 12, 2021 at 5:56 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Sep 9, 2021 at 6:56 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > NB: when merging this with
> > b542e383d8c0 ("eventfd: Make signal recursion protection a task bit")
> > from Linus' tree, replace eventfd_signal_count with
> > eventfd_signal_allowed, and drop the export of eventfd_wake_count from
> > ("eventfd: Export eventfd_wake_count to modules").
>
> What? No. That can't be right.
>
> Do you mean "replace eventfd_signal_count with !eventfd_signal_allowed()"?
>
> Because if I read the logic correctly, the issue is that
> 'vduse_vq_kick()' will call eventfd_signal().
>
> Which it must not do it eventfd_signal_allowed() returns false.
>
> So if eventfd_signal_allowed() is _not_ set, the code needs to defer
> it to the workqueue.
>
> No?
>

Yes, that's my fault. I just check how the eventfd_signal_allowed()
works in fs/aio.c (also needs a fix) when I see the fix for the merge
conflicts. Sorry for that.

Thanks,
Yongji
