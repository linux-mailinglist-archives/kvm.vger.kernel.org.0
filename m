Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5D32A3013
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgKBQlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbgKBQlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31786C0617A6;
        Mon,  2 Nov 2020 08:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ytzVAE2XCkwajxNhr8bJkGONDthc4ed0WgNEJDU139o=; b=nE3J0Pfg3W6SPnONobv6XQp1hy
        owdsSlNiW+Y+bXs25cf+31F3D+mxsgHuDIuqdWfnAnRlHJ1s5R+ctP8rcgh+DxSSBBpSXd6axdU4J
        sRMEd3Y+YpSCakvhT0EkTeN6kVU5UD1aRFi6OCuHy5CgoyGRpl+5R238VwjWhH7cwoyPEK4yiZ1X6
        Cgs3zHL/wjscvr7GJ1R0kxcjsQaBy+BbvD8cAQG1QY+FZNbFHH3KZDCtM7wOsPa/epJ2/S6Z4tq1E
        eqqc5m7o1oaEZFRUN2OlMu229aZwM0UmKcHYyLco2iOqHMFfV7rvlyxhX+6qaKX5md8tUWMzty3Ex
        sDCyYxGQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZctf-0006jm-CW; Mon, 02 Nov 2020 16:41:31 +0000
Date:   Mon, 2 Nov 2020 16:41:31 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@infradead.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        J??r??me Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 08/15] mm: Add unsafe_follow_pfn
Message-ID: <20201102164131.GA25526@infradead.org>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-9-daniel.vetter@ffwll.ch>
 <20201102072931.GA16419@infradead.org>
 <CAKMK7uEe5FQuukYU7RhL90ttC9XyWw6wvdQrZ2JpP0jpbYTO6g@mail.gmail.com>
 <20201102130115.GC36674@ziepe.ca>
 <CAKMK7uHeL=w7GoBaY4XrbRcpJabR9UWnP+oQ9Fg51OzL7=KxiA@mail.gmail.com>
 <20201102155256.GG36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102155256.GG36674@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:52:56AM -0400, Jason Gunthorpe wrote:
> Need to hold the lock to check that and there are two ways to register
> notifiers these days, so it feels to expensive to me.
> 
> CH's 'export symbol only for kvm' really does seem the most robust way
> to handle this though.

I hope I can get that done for this merge window, but I'm not sure.

I still think we should at least have a new name for the old follow_pfn
that no one should use.  And it should sound more scary than
unsafe_follow_pfn :)
