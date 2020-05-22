Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5791F1DE0A1
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgEVHJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbgEVHJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6E42072C;
        Fri, 22 May 2020 07:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590131359;
        bh=siqAKAhPdHB34ed/jqAQ/rPGKnZobfHSokZRD7WLHJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LDlpaqFUUO1Afmq5GmOSkpssdME79UKsrQCMEfIXF0LeLKRfQeXm5OLtdk+ry5R2z
         7PaMw7sctYkUsC0CqMv1NVGbMbRaQeOK1qGAOvRtdMzNNIZQ/XRwv48q4tuJWkWJ0C
         8MCiAZ4NlYwzJsxUPXxGaktlVkSUkgpqeN97cWnI=
Date:   Fri, 22 May 2020 09:09:17 +0200
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
Subject: Re: [PATCH v2 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
Message-ID: <20200522070917.GF771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-15-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-15-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:42AM +0300, Andra Paraschiv wrote:
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

changelog is needed.
