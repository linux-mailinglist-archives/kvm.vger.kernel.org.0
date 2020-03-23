Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0934818F386
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 12:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgCWLON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 07:14:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgCWLON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 07:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C87xnsNVhELeyQ/6uqphym88jFGzMbtyl2CNN0gORIA=; b=o5lKo3i0kb1illdXOiPPAzVhWL
        yFCU7ddszwkAVtvo1szMwDsQTaq9ThbZ7r8ecoVY8a10Lt6jrbKOOYXKdmX4UyqS5P+eR8V6x1DGB
        wxYkGuUq5trGA1mXs9LXWNI7eCOK3pGxLb2mZpufbvUyQt1mS7TKdpKKye/mkBFwiWiXr8yugQYMu
        gtLUk0B3c7HpqcLLgInwa32ayAp63bqTtYYzIfT1mMWYqF+Fg42iEqwiVCZmXuZrMvz0pFp56L0Mr
        E0l1gkqu4ZG2x65NyocAktwz/9caCKoEGKV7uX4O6bBNsrxIfdnwpbvte6QGiUUa6TyjKvMHMe38v
        +uBkQY2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGL1w-0001Zv-HQ; Mon, 23 Mar 2020 11:14:04 +0000
Date:   Mon, 23 Mar 2020 04:14:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yonghyun Hwang <yonghyun@google.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
Message-ID: <20200323111404.GA4554@infradead.org>
References: <20200320175910.180266-1-yonghyun@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320175910.180266-1-yonghyun@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 10:59:10AM -0700, Yonghyun Hwang wrote:
> To enable a mediated device, a device driver registers its device to VFIO
> MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> the sysfs attribute, "create", to create the mediated device. This
> additional step happens after boot-up gets complete. If the driver knows
> how many mediated devices need to be created during probing time, the
> additional step becomes cumbersome. This commit implements a new function
> to allow the driver to create a mediated device in kernel.

Please send this along with your proposed user so that we can understand
the use.  Without that new exports have no chance of going in anyway.
