Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD11E1B91
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgEZGvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEZGvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19AF20776;
        Tue, 26 May 2020 06:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590475895;
        bh=/n7CVC7LLphe/L2oFfRjQ2cMPEhA/twuWYjp1dC1s8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2utEm7dm+rhAk2OV60E5ZEzJKodiyEjoIbGrwoD/KGX0ScEHNZf8QfZt9HgMLPxV8
         psD5EP4quntdJZJ+O+ePBo67X2y6EVmJ+2hLrynmqkEKf+H5JadVkbwsGfnrIkUmEv
         GwWaxK2um9maAE5L2QMcY0ChnbZbeA9IxjpPT4dY=
Date:   Tue, 26 May 2020 08:51:33 +0200
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
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
Message-ID: <20200526065133.GD2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-8-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:13:23AM +0300, Andra Paraschiv wrote:
> +#define NE "nitro_enclaves: "

Again, no need for this.

> +#define NE_DEV_NAME "nitro_enclaves"

KBUILD_MODNAME?

> +#define NE_IMAGE_LOAD_OFFSET (8 * 1024UL * 1024UL)
> +
> +static char *ne_cpus;
> +module_param(ne_cpus, charp, 0644);
> +MODULE_PARM_DESC(ne_cpus, "<cpu-list> - CPU pool used for Nitro Enclaves");

Again, please do not do this.

Can you get the other amazon.com developers on the cc: list to review
this before you send it out again?  I feel like I am doing basic review
of things that should be easily caught by them before you ask the
community to review your code.

And get them to sign off on it too, showing they agree with the design
decisions here :)

thanks,

greg k-h
