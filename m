Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A211718B06
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 15:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfEINyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 09:54:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:28319 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfEINyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 09:54:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 May 2019 06:54:48 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2019 06:54:49 -0700
Date:   Thu, 9 May 2019 07:49:17 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Fam Zheng <fam@euphon.net>,
        "Busch, Keith" <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, John Ferlan <jferlan@redhat.com>
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
Message-ID: <20190509134917.GC8365@localhost.localdomain>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
 <20190503121838.GA21041@lst.de>
 <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
 <20190509091255.GB15331@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509091255.GB15331@stefanha-x1.localdomain>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 02:12:55AM -0700, Stefan Hajnoczi wrote:
> On Mon, May 06, 2019 at 12:04:06PM +0300, Maxim Levitsky wrote:
> > On top of that, it is expected that newer hardware will support the PASID based
> > device subdivision, which will allow us to _directly_ pass through the
> > submission queues of the device and _force_ us to use the NVME protocol for the
> > frontend.
> 
> I don't understand the PASID argument.  The data path will be 100%
> passthrough and this driver won't be necessary.

We still need a non-passthrough component to handle slow path,
non-doorbell controller registers and admin queue. That doesn't
necessarily need to be a kernel driver, though.
