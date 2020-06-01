Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704091E9BD4
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFACvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 22:51:41 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53906 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFACvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 22:51:41 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 0512pHeQ003129
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 21:51:21 -0500
Message-ID: <f256a37a89db56fcad229a1cfea11b8636b13829.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Date:   Mon, 01 Jun 2020 12:51:16 +1000
In-Reply-To: <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-8-andraprs@amazon.com>
         <20200526065133.GD2580530@kroah.com>
         <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
         <20200526123300.GA2798@kroah.com>
         <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 14:44 +0200, Alexander Graf wrote:
> So I really don't think an ioctl would be a great user experience. Same 
> for a sysfs file - although that's probably slightly better than the ioctl.

What would be wrong with a sysfs file ?

Another way to approach that makes sense from a kernel perspective is
to have the user first offline the CPUs, then "donate" them to the
driver via a sysfs file.

> Other options I can think of:
> 
>    * sysctl (for modules?)

Why would that be any good ? If anything sysctl's are even more awkward
in my book :)

>    * module parameter (as implemented here)
>    * proc file (deprecated FWIW)

Yeah no.

> The key is the tenant split: Admin sets the pool up, user consumes. This 
> setup should happen (early) on boot, so that system services can spawn 
> enclaves.

Right and you can have some init script or udev rule that sets that up
from a sys admin produced config file at boot upon detection of the
enclave PCI device for example.

> > module parameters are a major pain, you know this :)
> 
> I think in this case it's the least painful option ;). But I'm really 
> happy to hear about an actually good alternative to it. Right now, I 
> just can't think of any.

Cheers,
Ben.


