Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1F33BE4D
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhCOOpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:45:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37478 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbhCOOou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 10:44:50 -0400
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@canonical.com>)
        id 1lLoSe-00061a-Bi
        for kvm@vger.kernel.org; Mon, 15 Mar 2021 14:44:48 +0000
Received: by mail-ed1-f71.google.com with SMTP id i6so16158956edq.12
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 07:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/rOw6JMsy5TmcuNfXsdMbz1wU7+IrDSNfY1nK4kmqAI=;
        b=qa1gQrh3GYOUqP/Q2MQ7eblUVsyTVTZ/VyXHpJiZSmtwVEDPb3n821gBBgcePn2GzA
         BowzN43cR8mr59hvrH4VrUAwccIaZ4GQJXxXUlf1X6RvmbgPLK4GFOkN2ZJ2vTDELHFN
         +B0Qmmw9LnGtXkwQZE/97r+O361Z7Rzpw77xClqPTDOPnGw56/E8p4JF7p1rjp1IUp21
         cOgSUVLO0TdcIZNoufNvUZK2WMZ5/Rez94ijyVtDC2e6PnOQPHkL01nuY0nTjwViunFf
         iLxgK6Ceh1iMTuDCdCKomb1EYZAWeaIDp672WQsibtc3SJs8+k+ZQCP+ZdJRXEDVwwFj
         6oVQ==
X-Gm-Message-State: AOAM53229LOIh7rxcFpTrEatjyMtHp2YYtPClRvfhJarhOFdMWzbGC01
        sHg9o73FdW1Ay8fCVpDYidXGPm0u4S6woTOjKHQen6pZ8z8TS23pt97GwHEGQfmJSbjsKucCvEn
        3qDhRsjIq5+czedeGWu+9j4aFzlc0Qg==
X-Received: by 2002:a17:906:e16:: with SMTP id l22mr23860026eji.173.1615819487933;
        Mon, 15 Mar 2021 07:44:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX850jlad2N9FOS0qZRXIsOYQvuD87/PkQkWtiWY3kY5mGjEJZj64Syjg1iARAIS5QEMLnoA==
X-Received: by 2002:a17:906:e16:: with SMTP id l22mr23860009eji.173.1615819487785;
        Mon, 15 Mar 2021 07:44:47 -0700 (PDT)
Received: from gmail.com (ip5f5af0a0.dynamic.kabel-deutschland.de. [95.90.240.160])
        by smtp.gmail.com with ESMTPSA id e4sm7443229ejz.4.2021.03.15.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:44:47 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:44:44 +0100
From:   Christian Brauner <christian.brauner@canonical.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?utf-8?B?UGVudHRpbMOk?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
Message-ID: <20210315144444.bgtllddee7s55lfx@gmail.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-2-xieyongji@bytedance.com>
 <20210315090822.GA4166677@infradead.org>
 <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 05:46:43PM +0800, Yongji Xie wrote:
> On Mon, Mar 15, 2021 at 5:08 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> > > Export __receive_fd() so that some modules can use
> > > it to pass file descriptor between processes.
> >
> > I really don't think any non-core code should do that, especilly not
> > modular mere driver code.
> 
> Do you see any issue? Now I think we're able to do that with the help
> of get_unused_fd_flags() and fd_install() in modules. But we may miss
> some security stuff in this way. So I try to export __receive_fd() and
> use it instead.

The __receive_fd() helper was added for core-kernel code only and we
mainly did it for the seccomp notifier (and scm rights). The "__" prefix
was intended to convey that message.
And I agree with Christoph that we should probably keep it that way
since __receive_fd() allows a few operations that no driver should
probably do.
I can see it being kinda ok to export a variant that really only
receives and installs an fd, i.e. if we were to export what's currently
available as an inline helper:

static inline int receive_fd(struct file *file, unsigned int o_flags)

but definitely none of the fd replacement stuff; that shold be
off-limits. The seccomp notifier is the only codepath that should even
think about fd replacement since it's about managing the syscalls of
another task. Drivers swapping out fds doesn't sound like a good idea to
me.

Christian
