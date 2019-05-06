Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE831466E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 10:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEFIed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 04:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfEFIec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 04:34:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23B3DC05B00E;
        Mon,  6 May 2019 08:34:32 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4E3119C4F;
        Mon,  6 May 2019 08:34:24 +0000 (UTC)
Message-ID: <8ed3a93804ca136690749edcb464a60d4149a4e8.camel@redhat.com>
Subject: Re: [PATCH v2 06/10] nvme/core: add mdev interfaces
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Max Gurtovoy <maxg@mellanox.com>
Cc:     Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-nvme@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
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
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Amnon Ilan <ailan@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Mon, 06 May 2019 11:34:26 +0300
In-Reply-To: <1cc7efd1852f298b01f09955f2c4bf3b20cead13.camel@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190502114801.23116-7-mlevitsk@redhat.com>
         <20190503122902.GA5081@infradead.org>
         <d1c0c7ae-1a7d-06e5-d8bb-765a7fd5e41d@mellanox.com>
         <20190504064938.GA30814@lst.de>
         <1cc7efd1852f298b01f09955f2c4bf3b20cead13.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 06 May 2019 08:34:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-05-06 at 11:31 +0300, Maxim Levitsky wrote:
> On Sat, 2019-05-04 at 08:49 +0200, Christoph Hellwig wrote:
> > On Fri, May 03, 2019 at 10:00:54PM +0300, Max Gurtovoy wrote:
> > > Don't see a big difference of taking NVMe queue and namespace/partition
> > > to 
> > > guest OS or to P2P since IO is issued by external entity and pooled
> > > outside 
> > > the pci driver.
> > 
> > We are not going to the queue aside either way..  That is where the
> > last patch in this series is already working to, and which would be
> > the sensible vhost model to start with.
> 
> Why are you saying that? I actualy prefer to use a sepearate queue per
> software
> nvme controller, tat because of lower overhead (about half than going through
> the block layer) and it better at QoS as the separate queue (or even few
> queues
> if needed) will give the guest a mostly guaranteed slice of the bandwidth of
> the
> device.

Sorry for typos - I need more coffee :-)

Best regards,
	Maxim Levitsky

