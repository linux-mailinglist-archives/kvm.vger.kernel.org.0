Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C138BEC2
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 18:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfHMQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 12:39:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfHMQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 12:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TQHnl4sxi4/VeRk7ZrA0i7J1S4zj4wT870VjzP1+G6U=; b=KEihp4hABTfJvQXf5YzARnhkO
        qROCR8tKjv8aP6VQsgA9eWXvdarCOx+IIkoV4IfSR1/rsBhk/Xu19oMQd6Y/YQhjaewjCdn7sRh3e
        pIv6bcMOSR5jbOKCn/vDHS60PEGk2ZF0sUarK8WRaqk41ebYL9tWCeJ2SJvI+ecWc+aRYcnqV+6wJ
        evXWID9CdpSgFkFoFY6+I9cBSFZx8YqYWCzaswZu+VClJkqLbYzUawKDLM7VohqRZcHjHeb7aQZgQ
        ybsELAEoDT8Yyc7HfDHzlB0yR0IT0KX9ajWOtj69pxblIDTig5XHO/BkbLAsSX0A4k4CXJVDHmwrF
        BAM8/WwNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxZpa-0007KM-A9; Tue, 13 Aug 2019 16:39:30 +0000
Date:   Tue, 13 Aug 2019 09:39:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, cjia@nvidia.com
Subject: Re: [PATCH v2 1/2] vfio-mdev/mtty: Simplify interrupt generation
Message-ID: <20190813163930.GB22640@infradead.org>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com>
 <20190808141255.45236-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808141255.45236-2-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 09:12:54AM -0500, Parav Pandit wrote:
> While generating interrupt, mdev_state is already available for which
> interrupt is generated.
> Instead of doing indirect way from state->device->uuid-> to searching
> state linearly in linked list on every interrupt generation,
> directly use the available state.
> 
> Hence, simplify the code to use mdev_state and remove unused helper
> function with that.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>

Looks good, the old code is rather backwards and a bad example to
copy:

Reviewed-by: Christoph Hellwig <hch@lst.de>
