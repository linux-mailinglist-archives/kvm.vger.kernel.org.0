Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5262712D87
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfECM3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:29:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfECM3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v4iIVCgbPpVINMcoD8zLnWlww4NXBXy4bT54BBiY754=; b=lS5qyt80Q7feOHrLTFeRIBJF8
        3nonvZ5GZbuvDBcmHzEbEAybp2SCkM4KzraDjAUUKpz8yfgzbnqTEH/cAmoPTMeIwAGbIAomz71IB
        3PXUmFbYyM/szp4FHMDwwyhoo0WJR48rL4a1y4ReS+JZRtoNCbwbjn3pHTOcCkg92FaNEcXXreuKQ
        /QKhFgDupKtezZ6g4lkx+zPbE+ERO5ruf9xG44/DomFfXfpvrKSbCVKlNb491et2FCl+LRtIrp69G
        zGxCdvFpNCLNYdaqlI5pddqw0itAIH4mqcNHzJYYySZWN9OEcgRmcss1yDMvWjO3MZIqRpnuA6q5C
        Jvgabpcqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMXJG-0003b5-O2; Fri, 03 May 2019 12:29:02 +0000
Date:   Fri, 3 May 2019 05:29:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-nvme@lists.infradead.org, Fam Zheng <fam@euphon.net>,
        Keith Busch <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>, kvm@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Ferlan <jferlan@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 06/10] nvme/core: add mdev interfaces
Message-ID: <20190503122902.GA5081@infradead.org>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
 <20190502114801.23116-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502114801.23116-7-mlevitsk@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 02:47:57PM +0300, Maxim Levitsky wrote:
> If the mdev device driver also sets the
> NVME_F_MDEV_DMA_SUPPORTED, the mdev core will
> dma map all the guest memory into the nvme device,
> so that nvme device driver can use dma addresses as passed
> from the mdev core driver

We really need a proper block layer interface for that so that
uring or the nvme target can use pre-mapping as well.
