Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F701E1B93
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgEZGwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgEZGwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:52:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F335720776;
        Tue, 26 May 2020 06:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590475970;
        bh=578soxxNM+PnpJUnfjZmqXmt3ZxJDXb6cTa7vdFmkcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g7coDl//s2uasgScprZvqTGdHz9UH43heVbj6kHs/iGNFEDGnZZgINJ+E7JBBjU5G
         bQdpkdiR0e3rb41nkUV+c7SWzdj37hX9b+HVhxj81n4zDUi4a+lCFZwo134OGw28h6
         dqGVB0xzHP4NVcbL/rC+KyxYUAg9XWJNAnuKIA5o=
Date:   Tue, 26 May 2020 08:52:48 +0200
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
Subject: Re: [PATCH v3 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
Message-ID: <20200526065248.GE2580530@kroah.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-17-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525221334.62966-17-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:13:32AM +0300, Andra Paraschiv wrote:
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>

Again, I can't take patches without any changelog text, and you
shouldn't be writing them, as they are just lazy :)

thanks,

greg k-h
