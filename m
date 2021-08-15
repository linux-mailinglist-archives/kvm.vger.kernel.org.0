Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAD23ECA0F
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 17:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhHOPtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 11:49:07 -0400
Received: from verein.lst.de ([213.95.11.211]:51966 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHOPtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 11:49:06 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 52DC467357; Sun, 15 Aug 2021 17:48:34 +0200 (CEST)
Date:   Sun, 15 Aug 2021 17:48:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210815154834.GA325@lst.de>
References: <20210811151500.2744-1-hch@lst.de> <20210811151500.2744-6-hch@lst.de> <20210811160341.573a5b82.alex.williamson@redhat.com> <20210812072617.GA28507@lst.de> <20210812095614.3299d7ab.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812095614.3299d7ab.alex.williamson@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is a version with the tain only on successful groip allocation:

http://git.infradead.org/users/hch/misc.git/commit/bdb5d2401ebd43ae6c069aeaa8a64e0c774dd104

I'm not going to spam the list with the whole series until a few more
reviews are in.
