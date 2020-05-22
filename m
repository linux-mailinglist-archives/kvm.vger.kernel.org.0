Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A831DE0AA
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgEVHL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVHL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23632072C;
        Fri, 22 May 2020 07:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590131487;
        bh=RK0sDSR+/5X7EHAHMKlK+l1aCrRrHSUPw39hiJQ067c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/dLCgIDjw9BFbgWVW+8EJNf783rEnWRBPkvWRwWKY8qQPq4GAvaGXPZxynng9EXd
         CtJgC54G304K3qGYtmvZAhhPV4B87Nd+v2G6VB7GpzU9RP9s9Se/RJU6VWKZxRYZNL
         mgQu/fPX+glM8Qhai5jkXE399sqeQxZ5K0bfQc6s=
Date:   Fri, 22 May 2020 09:11:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
Message-ID: <20200522071123.GI771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-17-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-17-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:44AM +0300, Andra Paraschiv wrote:
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

No changelog?

> ---
>  samples/nitro_enclaves/.gitignore             |   2 +
>  samples/nitro_enclaves/Makefile               |  28 +
>  .../include/linux/nitro_enclaves.h            |  23 +
>  .../include/uapi/linux/nitro_enclaves.h       |  77 +++

Why are you not using the uapi files from the kernel itself?  How are
you going to keep these in sync?

thanks,

greg k-h
