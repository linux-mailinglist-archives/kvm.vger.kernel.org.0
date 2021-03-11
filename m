Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0233717F
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 12:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhCKLhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 06:37:39 -0500
Received: from verein.lst.de ([213.95.11.211]:40565 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhCKLhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 06:37:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0C4B268B05; Thu, 11 Mar 2021 12:37:07 +0100 (CET)
Date:   Thu, 11 Mar 2021 12:37:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, aik@ozlabs.ru
Subject: Re: [PATCH 9/9] vfio/pci: export igd support into vendor vfio_pci
 driver
Message-ID: <20210311113706.GC17183@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com> <20210309083357.65467-10-mgurtovoy@nvidia.com> <20210310081508.GB4364@lst.de> <20210310123127.GT2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310123127.GT2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:31:27AM -0400, Jason Gunthorpe wrote:
> Yes, that needs more refactoring. I'm viewing this series as a
> "statement of intent" and once we commit to doing this we can go
> through the bigger effort to split up vfio_pci_core and tidy its API.
> 
> Obviously this is a big project, given the past comments I don't want
> to send more effort here until we see a community consensus emerge
> that this is what we want to do. If we build a sub-driver instead the
> work is all in the trash bin.

So my viewpoint here is that this work doesn't seem very useful for
the existing subdrivers given how much compat pain there is.  It
defintively is the right way to go for a new driver.
