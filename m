Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67C41E9BF0
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 05:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgFADEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 23:04:41 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53982 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgFADEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 23:04:41 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 05134KVO003273
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 22:04:24 -0500
Message-ID: <a37b0156c076d3875f906e970071cb230e526df1.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.de>
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
Date:   Mon, 01 Jun 2020 13:04:19 +1000
In-Reply-To: <20200528131259.GA3345766@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-8-andraprs@amazon.com>
         <20200526065133.GD2580530@kroah.com>
         <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
         <20200526123300.GA2798@kroah.com>
         <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
         <20200526131708.GA9296@kroah.com>
         <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
         <20200526222402.GC179549@kroah.com>
         <b4f17cbd-7471-fe61-6e7e-1399bd96e24e@amazon.de>
         <20200528131259.GA3345766@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-05-28 at 15:12 +0200, Greg KH wrote:
> So at runtime, after all is booted and up and going, you just ripped
> cores out from under someone's feet?  :)
> 
> And the code really handles writing to that value while the module is
> already loaded and up and running?  At a quick glance, it didn't seem
> like it would handle that very well as it only is checked at ne_init()
> time.
> 
> Or am I missing something?
> 
> Anyway, yes, if you can dynamically do this at runtime, that's great,
> but it feels ackward to me to rely on one configuration thing as a
> module parameter, and everything else through the ioctl interface.
> Unification would seem to be a good thing, right?

I personally still prefer a sysfs file :) I really don't like module
parameters as a way to do such things.

Cheers,
Ben.


