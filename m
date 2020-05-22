Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECBD1DE089
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgEVHAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgEVHAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:00:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C8A20679;
        Fri, 22 May 2020 07:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590130817;
        bh=YpTtK9CaE3YRm1COpzX0/s0OubyAybGfUzkJTbrDxIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0w/U1NEO+otxIK0/xRXAtj2AGte2WaiK9giFysWpnFpVKGFoAFMM6KCDhDUKTTeNk
         leZyQacITJGbIH+ZzuMitRI/1Q1k2OUfYRI6ExTigCFDvt9P5hI/3GomqTHnZv6Gug
         takeb4oPGQj8CoPIIpALOGAxJMqYNGYag3F6eBk8=
Date:   Fri, 22 May 2020 09:00:15 +0200
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
Subject: Re: [PATCH v2 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200522070015.GA771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-2-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:29AM +0300, Andra Paraschiv wrote:
> --- /dev/null
> +++ b/include/uapi/linux/nitro_enclaves.h
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */

Note, if you have the SPDX line, you can get rid of all of the
boilerplate "GPL text" as well.  We have been doing that for lots of
kernel files, no need to add more to increase our workload.

thanks,

greg k-h
