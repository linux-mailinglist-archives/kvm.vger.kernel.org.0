Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8918F14A79
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfEFM72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 08:59:28 -0400
Received: from verein.lst.de ([213.95.11.211]:52212 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfEFM71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 08:59:27 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 36EC567358; Mon,  6 May 2019 14:59:09 +0200 (CEST)
Date:   Mon, 6 May 2019 14:59:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Max Gurtovoy <maxg@mellanox.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@infradead.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        John Ferlan <jferlan@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amnon Ilan <ailan@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 06/10] nvme/core: add mdev interfaces
Message-ID: <20190506125909.GB5288@lst.de>
References: <20190502114801.23116-1-mlevitsk@redhat.com> <20190502114801.23116-7-mlevitsk@redhat.com> <20190503122902.GA5081@infradead.org> <d1c0c7ae-1a7d-06e5-d8bb-765a7fd5e41d@mellanox.com> <20190504064938.GA30814@lst.de> <1cc7efd1852f298b01f09955f2c4bf3b20cead13.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cc7efd1852f298b01f09955f2c4bf3b20cead13.camel@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 06, 2019 at 11:31:27AM +0300, Maxim Levitsky wrote:
> Why are you saying that? I actualy prefer to use a sepearate queue per software
> nvme controller, tat because of lower overhead (about half than going through
> the block layer) and it better at QoS as the separate queue (or even few queues
> if needed) will give the guest a mostly guaranteed slice of the bandwidth of the
> device.

The downside is that your create tons of crap code in the core nvme driver
for your specific use case that no one cares about.  Which is why it is
completely unacceptable.  If you want things to go fast make the block
layer go fast, don't add your very special bypass.
