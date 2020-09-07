Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A225F5E8
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 11:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgIGJBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 05:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgIGJBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 05:01:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB21E208C7;
        Mon,  7 Sep 2020 09:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599469271;
        bh=bsce752aD/wGIVZHsGm58lcD3XB9GuRtkX/NsHEv4WA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vcXTP2HWAvcq4F9UXWyh+wzVHxxvYMnpHwMIGw3jocfI7DwEUeJmi4/h/OXvImks1
         PgE47OJgn26ij5DOrWqrXFhBX7YukMUlxDCwOLdT15Q7oHm+PVRjU704bcwhTnrPvh
         GM8cJsnSCQoaznXq8Gc0xvGT2fiivJnqrY+ylysE=
Date:   Mon, 7 Sep 2020 11:01:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
Message-ID: <20200907090126.GD1101646@kroah.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-18-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904173718.64857-18-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 08:37:17PM +0300, Andra Paraschiv wrote:
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
> Changelog
> 
> v7 -> v8
> 
> * Add info about the primary / parent VM CID value.
> * Update reference link for huge pages.
> * Add reference link for the x86 boot protocol.
> * Add license mention and update doc title / chapter formatting.
> 
> v6 -> v7
> 
> * No changes.
> 
> v5 -> v6
> 
> * No changes.
> 
> v4 -> v5
> 
> * No changes.
> 
> v3 -> v4
> 
> * Update doc type from .txt to .rst.
> * Update documentation based on the changes from v4.
> 
> v2 -> v3
> 
> * No changes.
> 
> v1 -> v2
> 
> * New in v2.
> ---
>  Documentation/nitro_enclaves/ne_overview.rst | 95 ++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/nitro_enclaves/ne_overview.rst

A whole new subdir, for a single driver, and not tied into the kernel
documentation build process at all?  Not good :(

thanks,

greg k-h
