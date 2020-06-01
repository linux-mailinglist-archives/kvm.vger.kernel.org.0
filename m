Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7B1E9BE9
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 05:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFADD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 23:03:26 -0400
Received: from kernel.crashing.org ([76.164.61.194]:53958 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgFADDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 23:03:25 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 051330TT003234
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 31 May 2020 22:03:04 -0500
Message-ID: <a95de3ee4b722d418fd6cf662233cb024928804e.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Stefan Hajnoczi <stefanha@gmail.com>,
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
Date:   Mon, 01 Jun 2020 13:02:59 +1000
In-Reply-To: <20200527084959.GA29137@stefanha-x1.localdomain>
References: <20200525221334.62966-1-andraprs@amazon.com>
         <20200525221334.62966-2-andraprs@amazon.com>
         <20200527084959.GA29137@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-27 at 09:49 +0100, Stefan Hajnoczi wrote:
> 
> What about feature bits or a API version number field? If you add
> features to the NE driver, how will userspace detect them?
> 
> Even if you intend to always compile userspace against the exact kernel
> headers that the program will run on, it can still be useful to have an
> API version for informational purposes and to easily prevent user
> errors (running a new userspace binary on an old kernel where the API is
> different).
> 
> Finally, reserved struct fields may come in handy in the future. That
> way userspace and the kernel don't need to explicitly handle multiple
> struct sizes.

Beware, Greg might disagree :)

That said, yes, at least a way to query the API version would be
useful.

Cheers,
Ben.


