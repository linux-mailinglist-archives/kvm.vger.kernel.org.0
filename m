Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75611E3243
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 00:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403986AbgEZWVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 18:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389613AbgEZWVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 18:21:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E6702088E;
        Tue, 26 May 2020 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590531671;
        bh=k6NIXNBHoIFJMYLYcaW8jcJWWohY5des9NYh3DMl9v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjbrWojNPIP9ULpJoH0B3tWwkklW2Z0wpLZJEcvPJfFqWKz/a65iA0chn3WfRjxkL
         HXkAegoMHuaX3JkVpmInezV/jdykRI9EI1YjKpbYb2LthaE0G2XDS/YqOsExkZGd1v
         UXhY+Guu4J1Ye/nzO2SmV9cd4+WpStIE1aqLZbi4=
Date:   Wed, 27 May 2020 00:21:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
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
Message-ID: <20200526222109.GB179549@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-3-andraprs@amazon.com>
 <20200526064455.GA2580530@kroah.com>
 <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 08:01:36PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 26/05/2020 09:44, Greg KH wrote:
> > On Tue, May 26, 2020 at 01:13:18AM +0300, Andra Paraschiv wrote:
> > > +struct enclave_get_slot_req {
> > > +	/* Context ID (CID) for the enclave vsock device. */
> > > +	u64 enclave_cid;
> > > +} __attribute__ ((__packed__));
> > Can you really "pack" a single member structure?
> > 
> > Anyway, we have better ways to specify this instead of the "raw"
> > __attribute__ option.  But first see if you really need any of these, at
> > first glance, I do not think you do at all, and they can all be removed.
> 
> There are a couple of data structures with more than one member and multiple
> field sizes. And for the ones that are not, gathered as feedback from
> previous rounds of review that should consider adding a "flags" field in
> there for further extensibility.

Please do not do that in ioctls.  Just create new calls instead of
trying to "extend" existing ones.  It's always much easier.

> I can modify to have "__packed" instead of the attribute callout.

Make sure you even need that, as I don't think you do for structures
like the above one, right?

thanks,

greg k-h
