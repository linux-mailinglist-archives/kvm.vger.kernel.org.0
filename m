Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F51E1B85
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgEZGo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgEZGo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:44:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32768207D8;
        Tue, 26 May 2020 06:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590475497;
        bh=ee0xUeLx8woNb4NNohFSdm4jIhZLVDjEwLtDO83PJpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0rEE8+xpu6rI+f7GTJ/mWWnWgFhiw3xwynyZtW9wK2ABbmiotKI75cycXIgrka+0s
         8/MvOufClfzsNNG3eV84/W0QGiMkcX/D+Nph4NY+qDreVlGRdOLNEL82cdeveGAxma
         8B5/Wu9u5qbOL0NJXbbkADeEVM5RR7fPJpXkiZMo=
Date:   Tue, 26 May 2020 08:44:55 +0200
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
Subject: Re: [PATCH v3 02/18] nitro_enclaves: Define the PCI device interface
Message-ID: <20200526064455.GA2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-3-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:13:18AM +0300, Andra Paraschiv wrote:
> +struct enclave_get_slot_req {
> +	/* Context ID (CID) for the enclave vsock device. */
> +	u64 enclave_cid;
> +} __attribute__ ((__packed__));

Can you really "pack" a single member structure?

Anyway, we have better ways to specify this instead of the "raw"
__attribute__ option.  But first see if you really need any of these, at
first glance, I do not think you do at all, and they can all be removed.

thanks,

greg k-h
