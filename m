Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8C1E9BE0
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 04:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgFAC7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 22:59:32 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53932 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgFAC7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 22:59:32 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 0512xBhh003181
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 21:59:15 -0500
Message-ID: <ea25810cbd43974b75934f9cfb6ca3f007339dce.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 02/18] nitro_enclaves: Define the PCI device interface
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>
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
Date:   Mon, 01 Jun 2020 12:59:10 +1000
In-Reply-To: <20200526222109.GB179549@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-3-andraprs@amazon.com>
         <20200526064455.GA2580530@kroah.com>
         <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
         <20200526222109.GB179549@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-27 at 00:21 +0200, Greg KH wrote:
> > There are a couple of data structures with more than one member and multiple
> > field sizes. And for the ones that are not, gathered as feedback from
> > previous rounds of review that should consider adding a "flags" field in
> > there for further extensibility.
> 
> Please do not do that in ioctls.  Just create new calls instead of
> trying to "extend" existing ones.  It's always much easier.
> 
> > I can modify to have "__packed" instead of the attribute callout.
> 
> Make sure you even need that, as I don't think you do for structures
> like the above one, right?

Hrm, my impression (granted I only just started to look at this code)
is that these are protocol messages with the PCI devices, not strictly
just ioctl arguments (though they do get conveyed via such ioctls).

Andra-Irina, did I get that right ? :-)

That said, I still think that by carefully ordering the fields and
using explicit padding, we can avoid the need of the packed attributed.

Cheers,
Ben.


