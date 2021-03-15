Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F3E33AF36
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 10:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCOJrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 05:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhCOJq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 05:46:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AD8C061574
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 02:46:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id si25so9322975ejb.1
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 02:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCH3VsMvUSEqRY0D77ObQA6OJaIvmvlJ89ZGUx/CcXM=;
        b=KBdJN57ZQ8VQz1uCDRBPHQrOXwItBmwEOFNPq9ozYMbd8bVSP9hZj0v9/leZLxc2v+
         bnEIog66c/xVxrJaQAQDSfaN+5ON+6/yYsZ8IdtMtK+aTlx4uX2mxihZsNBRUez/do4+
         1KvtRI7pNUOjnhjQuA0DVTja0OSZL+D2vVMQuDfYKe+dQbply48UC3cv2rlAidtOomQs
         k1BP33T2HNlfsNTa9+WA72vbFKmtOzfthLV8yRt2Y3aDsU1xaHrDx2k0biUGtA/628u1
         XwtKg+gHWjT467qCsHWkew3z6+raHVfH7JAGoUlxnPeVEVkdXSpctfKubCK/DjB1C3Uf
         K5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCH3VsMvUSEqRY0D77ObQA6OJaIvmvlJ89ZGUx/CcXM=;
        b=lQLTJHFT/6YTvlA9KBx7tvTx7tRjTnpLUZ7pBRroHrZYYkwD7sNmAZbprCYulmGCiC
         ArGqUn9fdaBXA5RNLbyoPkYWpg8YMn4XLy8hn/XJSc9UPR8WWTFcfWw+jES33N0pY6aU
         tCvhc1pXm4GFe4xC8Vt/q7QeLtZU0d0phDUvsAvHcR2Ce8nQw7FdToQvyfww10zEoZxB
         fSzZhuN9ofQsvserEikTfRoiFb3RRvQOFHYJziyNRbMppFkwmsxWyTj3XXea2/sVuT4k
         IWTiTyzI/ZZKVVtr/7IIAvQgjB+ZaWv/vpAMsRcGnGOQBMdI+2BV+UCHHfns0aaUvv6+
         F4Lw==
X-Gm-Message-State: AOAM530rk6UXtQPpEa+0H4E1/Nq1/hj7UxjG+k4niD2VTdmA29g1zDug
        EI2GBf/qYJHhT3JLqBBznRZpVzYEMLK20DDXdozN
X-Google-Smtp-Source: ABdhPJwfPpbGsW1NwziEvCm+pu9W0AYA2Ip5t3r5CSavHkGCI1g9/KIycGHrq/KBYUgnQfbZQ1cImKEpNMiBrV1NXz0=
X-Received: by 2002:a17:906:311a:: with SMTP id 26mr22439640ejx.395.1615801614537;
 Mon, 15 Mar 2021 02:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-2-xieyongji@bytedance.com>
 <20210315090822.GA4166677@infradead.org>
In-Reply-To: <20210315090822.GA4166677@infradead.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 15 Mar 2021 17:46:43 +0800
Message-ID: <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
Subject: Re: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 5:08 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> > Export __receive_fd() so that some modules can use
> > it to pass file descriptor between processes.
>
> I really don't think any non-core code should do that, especilly not
> modular mere driver code.

Do you see any issue? Now I think we're able to do that with the help
of get_unused_fd_flags() and fd_install() in modules. But we may miss
some security stuff in this way. So I try to export __receive_fd() and
use it instead.

Thanks,
Yongji
