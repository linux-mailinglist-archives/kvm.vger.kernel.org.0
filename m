Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8098B2690F7
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgINP7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgINP7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:59:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A130A208DB;
        Mon, 14 Sep 2020 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600099154;
        bh=KTqqnuYNHBDPGEnW6TQwSmoQqmLX+vuoeMtabOysLw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qffVypRPw5w3N09WTY0g3jodn/GkH1aVNKANSihDELNikvj7foT39OZPSp+9EUouT
         8XWn1XiDfjmjcv5YdQrOxDsaylaJUMClKFsDCrI9y1mpwf5xPgZc70+i160ouGOPwJ
         4zaO26gJrpERQr/rzyazMD+bXgvh8HptzWH5DTdE=
Date:   Mon, 14 Sep 2020 17:59:13 +0200
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
Subject: Re: [PATCH v9 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
Message-ID: <20200914155913.GB3525000@kroah.com>
References: <20200911141141.33296-1-andraprs@amazon.com>
 <20200911141141.33296-15-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911141141.33296-15-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 05:11:37PM +0300, Andra Paraschiv wrote:
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>

I can't take patches without any changelog text at all, sorry.

Same for a few other patches in this series :(

thanks,

greg k-h
