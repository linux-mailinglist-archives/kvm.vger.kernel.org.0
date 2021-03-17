Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1999733EA73
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 08:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCQHXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 03:23:35 -0400
Received: from casper.infradead.org ([90.155.50.34]:47140 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCQHW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 03:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VgWremH0I10zTIm6kNKr7I2+jlh/Pgq8sbo0UnUFG0E=; b=EfM8/Q3qa7owXrxD2xbByTMBCc
        UUhCwPxAvE3Qk7tC5abxDLcA9s5y2ZKUPGF5hWctwYKb4Nn2nX04O4+uaY+ZLbGh4YfR/oJTx/q4B
        /7i++JYLd03hMb5X7tbEoXnY/CeLk88Q1DAzIiCQ4wyiMEx0gFta3wGDp9wO/I01tnKk0eCkP5ds2
        1TRRkJ5dwk6DTrqIfCQlcBYjRdqkEZn+U1ADNC7qlhKZZUDT+ee5BIW6rr89U0o8640JvoEHVxuh1
        /P7Sg724uFmxdbapDmMOr71b0Nh9XTVcei7a4V/hvQsdGJGzYw8OCfw2U3qWhTJ6y+8d31Yo41GV5
        SmA58zaA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMQW0-001Ckh-8P; Wed, 17 Mar 2021 07:22:49 +0000
Date:   Wed, 17 Mar 2021 07:22:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Christoph Hellwig <hch@infradead.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        J??r??me Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/3] media/videobuf1|2: Mark follow_pfn usage as unsafe
Message-ID: <20210317072248.GA284559@infradead.org>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-3-daniel.vetter@ffwll.ch>
 <20210316154549.GA60450@infradead.org>
 <CAKMK7uF8Lv0P4TuoctjUiVHtRzAnXf9a50JaYgm0rV+v+7=LFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uF8Lv0P4TuoctjUiVHtRzAnXf9a50JaYgm0rV+v+7=LFw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 04:52:44PM +0100, Daniel Vetter wrote:
> My understanding is mostly, but with some objections. And I kinda
> don't want to let this die in a bikeshed and then not getting rid of
> follow_pfn as a result. There's enough people who acked this, and the
> full removal got some nack from Mauro iirc.

Hmm, ok I must have missed that.  I defintively prefer your series over
doing nothing, but killing the dead horse ASAP would be even better.
