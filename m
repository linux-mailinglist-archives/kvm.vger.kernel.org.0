Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6954C318684
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 09:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBKIvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 03:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBKIuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 03:50:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5885AC06178A;
        Thu, 11 Feb 2021 00:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0+1wsL2U/UOf5qLOqr+WtO+GFHaK5njXOQm3ltdvYqE=; b=V1fNhX0SAT9Kjh0cdeZG8wqXkX
        1dr6lym8yWshTHk5h/HgHIzmTu5KgT97LKBSxNERfoWWCRth1koQdUzZmIFkrlFwnmm3L/XuLStAF
        1XBpOd5po9jwefEPsBCogZbQckL3Iz8f90uKszVdsFNItfvXdoiABsjbSgSRndyBpI52Bl1plAtL8
        hEZvpGoe3DFi2Ypg83jw46CtCoiAF6jEGwVhfE+ZQk4In0S1BS5mwq6QHv34NDhx+MMyf3FEYFBfp
        dY4AX3pX4bcRnSNbe3RTJgdcR+zZNICik+T96AmP9al3B9SJOpQrHIE1u6i3qTHMByhimrcbhwlQJ
        sbs+uUSQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lA7aM-009zKa-9y; Thu, 11 Feb 2021 08:44:26 +0000
Date:   Thu, 11 Feb 2021 08:44:26 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211084426.GB2378134@infradead.org>
References: <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
 <20210202185017.GZ4247@nvidia.com>
 <20210202123723.6cc018b8@omen.home.shazbot.org>
 <20210202204432.GC4247@nvidia.com>
 <5e9ee84e-d950-c8d9-ac70-df042f7d8b47@nvidia.com>
 <20210202143013.06366e9d@omen.home.shazbot.org>
 <20210202230604.GD4247@nvidia.com>
 <20210202165923.53f76901@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202165923.53f76901@omen.home.shazbot.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 04:59:23PM -0700, Alex Williamson wrote:
> vfio-pci-igd support knows very little about the device, we're
> effectively just exposing a firmware table and some of the host bridge
> config space (read-only).  So the idea that the host kernel needs to
> have updated i915 support in order to expose the device to userspace
> with these extra regions is a bit silly.

On the other hand assuming the IGD scheme works for every device
with an Intel Vendor ID and a VGA classcode that hangs off an Intel
host bridge seems highly dangerous.  Is this actually going to work
for the new discreete Intel graphics?  For the old i740?  And if not
what is the failure scenario?
