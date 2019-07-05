Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E507605D6
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfGEMUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGEMU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:20:29 -0400
Received: from localhost (deibp9eh1--blueice1n7.emea.ibm.com [195.212.29.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706642147A;
        Fri,  5 Jul 2019 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562329229;
        bh=FvcAYMrwn+ocFjV0CkPScRrtGx5+x9Q9eo+5jIIZC54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5KD2kyqpd7Thrp5ooeCtvC5Zce8EDphZj3afgOlcx9TCyshFYKG6804h5b+7ZtCB
         hEkAH5lZ4bm3sAGwQXvBSofHM+DYq6LkDYb6SWK+RvCC5HAfSjGHNgFGzMN5PhhjnV
         /5BJgfRZduwmC3h6DR517XXGqMoSKGpYS+VewBCQ=
Date:   Fri, 5 Jul 2019 14:20:24 +0200
From:   Vasily Gorbik <gor@kernel.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/1] vfio-ccw fix for 5.3
Message-ID: <your-ad-here.call-01562329224-ext-7594@work.hours>
References: <20190705062132.20755-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190705062132.20755-1-cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 08:21:31AM +0200, Cornelia Huck wrote:
> The following changes since commit 05f31e3bf6b34fe6e4922868d132f6455f81d5bf:
> 
>   s390: ap: kvm: Enable PQAP/AQIC facility for the guest (2019-07-02 16:00:28 +0200)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190705
> 
> for you to fetch changes up to c382cbc6dbf513d73cf896ad43a3789ad42c2e2f:
> 
>   vfio-ccw: Fix the conversion of Format-0 CCWs to Format-1 (2019-07-05 07:58:53 +0200)
> 
> ----------------------------------------------------------------
> Fix a bug introduced in the refactoring.
> 
> ----------------------------------------------------------------
> 
> Eric Farman (1):
>   vfio-ccw: Fix the conversion of Format-0 CCWs to Format-1
> 
>  drivers/s390/cio/vfio_ccw_cp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> -- 
> 2.20.1
> 
Applied, thanks.
