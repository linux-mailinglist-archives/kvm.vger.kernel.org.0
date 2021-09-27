Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7268A4193C7
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 14:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhI0MC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbhI0MCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 08:02:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F921C061575;
        Mon, 27 Sep 2021 05:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ZGz56D9PDMH0Z9KBoJRxNY2ws2
        uVWo1Tb+nHx18sJhRIukJIc3iQcK9Wq7R/S3CySv3a02INLlb1huajuVkEF24S64o6ZY278l4ONa2
        HQrv0yZMzld8QDfhONwlXZgTm5TTqQ7Fik+veQ0TlPxViY0XWEmgtr2iXv0o/Co54MwG41vxpgUZN
        A+2vYVjVnm+GZ9qtMcDthxkSJ1QJSqyimFyAk+MP8fAexcfwmxpvOU1zoUZ8l37UHiD0Dj/28XlkT
        /p/s/usXaUf8qKamgnSKObW0qorVTPGgiQDpObevLviNeBs+6tZEuxpC8IuVh8AbwztReRuXb4wMt
        E5c10lNQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUpIF-009idw-Rh; Mon, 27 Sep 2021 11:59:48 +0000
Date:   Mon, 27 Sep 2021 12:59:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     hch@infradead.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <YVGyJ7jkixtgPVSY@infradead.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901131434.31158-1-mgurtovoy@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
