Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B63FD2D6
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 07:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbhIAFWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 01:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhIAFWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 01:22:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE9FC061575;
        Tue, 31 Aug 2021 22:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Sm8cG8stcqpgFKiVBKuUxhVdzU
        l9LuxUIXxe5uaSLQw2HR5QYlPcFDTQNZ9e3rdJX0kxY0H4iSXs+4I7z6Fxmkgj8BtbMnRLZlvW6T3
        1rCg8wrshgo4lVc9tWjurZ5z0M5+2AGVXAzq1fiSCaVlhWXxlV+yB9i1+IZkMcRU6cAYpuLuD1Z0V
        1KjzGTssbQgGjH+jJD5zHQ9kJCb3PzvYprU3JyFZy13Z8rBQjVjguetMDihYW8h6RYoB/gySrljQ3
        co2kdSCrb0i+/tZ8qT3gzcsHvhYRDdxJfGEcZkkzfnP8xvHJdcIH3Hdlr/n94ZfYQBsWC/4aHVXSF
        jikXeuBA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLIgG-001tZC-44; Wed, 01 Sep 2021 05:21:10 +0000
Date:   Wed, 1 Sep 2021 06:21:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v2 1/1] virtio-blk: add num_io_queues module parameter
Message-ID: <YS8NvPbGODs5ZVmB@infradead.org>
References: <20210831135035.6443-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831135035.6443-1-mgurtovoy@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
