Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8CC1E9BD7
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 04:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgFACxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 22:53:35 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53914 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFACxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 22:53:35 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 0512rEYW003141
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 21:53:18 -0500
Message-ID: <6bc1b1febd8b8b1ed8d86bc0951637ed521ca2d5.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 02/18] nitro_enclaves: Define the PCI device interface
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
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
Date:   Mon, 01 Jun 2020 12:53:13 +1000
In-Reply-To: <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-3-andraprs@amazon.com>
         <20200526064455.GA2580530@kroah.com>
         <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 20:01 +0300, Paraschiv, Andra-Irina wrote:
> 
> On 26/05/2020 09:44, Greg KH wrote:
> > On Tue, May 26, 2020 at 01:13:18AM +0300, Andra Paraschiv wrote:
> > > +struct enclave_get_slot_req {
> > > +	/* Context ID (CID) for the enclave vsock device. */
> > > +	u64 enclave_cid;
> > > +} __attribute__ ((__packed__));
> > 
> > Can you really "pack" a single member structure?
> > 
> > Anyway, we have better ways to specify this instead of the "raw"
> > __attribute__ option.  But first see if you really need any of
> > these, at
> > first glance, I do not think you do at all, and they can all be
> > removed.
> 
> There are a couple of data structures with more than one member and 
> multiple field sizes. And for the ones that are not, gathered as 
> feedback from previous rounds of review that should consider adding
> a 
> "flags" field in there for further extensibility.
> 
> I can modify to have "__packed" instead of the attribute callout.

I tend to prefer designing the protocol so that all the fields are
naturally aligned, which should avoid the need for the attribute. Is
it possible in this case ?

Cheers,
Ben.


