Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66391E9D7B
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 07:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFAFsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 01:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgFAFsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 01:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3779B20734;
        Mon,  1 Jun 2020 05:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590990498;
        bh=zbjGSKYrzzSB+sq/pQ8w3/Me0mvCvWVALBgOqEgSoOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9+w3ogjHkAQbFyjqveufeMn6/PLEfDYCbfs68A4yz6Ds9G6eisfcf1VR9CB8V4nN
         KN2apX9IiRFl4RiuwGz5BswT0oHCeWex/7DrjU7QiA5UM8i0lKYG2LlwOTs2ta+k91
         x9MsR+eqf72WHY5yFZBzxJxLbkReLzLmUCm/vV0c=
Date:   Mon, 1 Jun 2020 07:48:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
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
Message-ID: <20200601054816.GB1444369@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <d1be2b61febf69af6d63f653ee02903fb2663eb2.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1be2b61febf69af6d63f653ee02903fb2663eb2.camel@kernel.crashing.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 01, 2020 at 12:47:12PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2020-05-26 at 08:51 +0200, Greg KH wrote:
> > 
> > And get them to sign off on it too, showing they agree with the design
> > decisions here :)
> 
> Isn't it generally frowned upon to publish a patch with internal sign-
> off's on it already ?

Not at all.

> Or do you mean for us to publicly sign off once we have reviewed ?

Either is fine, as long as you do the public one "quickly" and don't
rely on others to do the review first :)

thanks,

greg k-h
