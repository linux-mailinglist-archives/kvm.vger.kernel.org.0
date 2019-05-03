Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2125A12D5D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfECMTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:19:00 -0400
Received: from verein.lst.de ([213.95.11.211]:37321 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECMTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:19:00 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id E4F0B68AFE; Fri,  3 May 2019 14:18:38 +0200 (CEST)
Date:   Fri, 3 May 2019 14:18:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
Message-ID: <20190503121838.GA21041@lst.de>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I simply don't get the point of this series.

MDEV is an interface for exposing parts of a device to a userspace
program / VM.  But that this series appears to do is to expose a
purely software defined nvme controller to userspace.  Which in
principle is a good idea, but we have a much better framework for that,
which is called vhost.
