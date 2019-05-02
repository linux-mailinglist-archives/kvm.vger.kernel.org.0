Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981AC11B41
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 16:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfEBOUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 10:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfEBOUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 10:20:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B380530ADBC3;
        Thu,  2 May 2019 14:20:42 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA761827BC;
        Thu,  2 May 2019 14:20:32 +0000 (UTC)
Message-ID: <be56bf51cebb7f373c279adf3e9a46e6df5dfe76.camel@redhat.com>
Subject: Re: [PATCH v2 08/10] nvme/pci: implement the mdev external queue
 allocation interface
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Fam Zheng <fam@euphon.net>, Keith Busch <keith.busch@intel.com>,
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
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Date:   Thu, 02 May 2019 17:20:31 +0300
In-Reply-To: <20190502114801.23116-9-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
         <20190502114801.23116-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 02 May 2019 14:20:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-05-02 at 14:47 +0300, Maxim Levitsky wrote:
> Note that currently the number of hw queues reserved for mdev,
> has to be pre determined on module load.
> 
> (I used to allocate the queues dynamicaly on demand, but
> recent changes to allocate polled/read queues made
> this somewhat difficult, so I dropped this for now)
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/nvme/host/pci.c  | 375 ++++++++++++++++++++++++++++++++++++++-
>  drivers/nvme/mdev/host.c |  46 ++---
>  drivers/nvme/mdev/io.c   |  46 +++--
>  drivers/nvme/mdev/mmio.c |   3 -
>  4 files changed, 421 insertions(+), 49 deletions(-)

The changes in drivers/nvme/mdev aren't supposed to be here, this was some code
moving around to reduce the diff in the generic block layer support code,
it supposed to go to the main mdev commit.

Best regards,
	Maxim Levitsky

