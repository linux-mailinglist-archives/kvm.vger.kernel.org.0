Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE381E9BCE
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 04:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFACrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 22:47:39 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53894 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFACrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 22:47:39 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 0512lEdN003103
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 21:47:17 -0500
Message-ID: <d1be2b61febf69af6d63f653ee02903fb2663eb2.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andra Paraschiv <andraprs@amazon.com>
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
Date:   Mon, 01 Jun 2020 12:47:12 +1000
In-Reply-To: <20200526065133.GD2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-8-andraprs@amazon.com>
         <20200526065133.GD2580530@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 08:51 +0200, Greg KH wrote:
> 
> And get them to sign off on it too, showing they agree with the design
> decisions here :)

Isn't it generally frowned upon to publish a patch with internal sign-
off's on it already ? Or do you mean for us to publicly sign off once
we have reviewed ?

Cheers,
Ben.


