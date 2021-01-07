Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29C52ECED9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbhAGLhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAGLhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8450D20732;
        Thu,  7 Jan 2021 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610019403;
        bh=kpNs9ZeYv2RT1PB41nJ+rDUgLeZYC/vtXw4Y8KJ/whg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rHxMtWFwpCG6H0Bw4N0BDAuJ69XPV1eIGaBvswzYjqSE5jOmxkoGnsa1357IL88TM
         SiGeOzHGmyorQOvh2300Ft5xtjRlSp9gSP508slH5I/VZJcBJshYIxXv1Or4ERrN4O
         4xSuknIoueeAoRN2dqSumvEdglw8gemFwXVLr4k4=
Date:   Thu, 7 Jan 2021 12:38:02 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5p2O5o23?= <jie6.li@samsung.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?6rmA6rK97IKw?= <ks0204.kim@samsung.com>,
        =?utf-8?B?5L2V5YW0?= <xing84.he@samsung.com>,
        =?utf-8?B?5ZCV6auY6aOe?= <gaofei.lv@samsung.com>
Subject: Re: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq
 equals to IRQ_NOTCONNECTED
Message-ID: <X/bymlYr6pZls93k@kroah.com>
References: <CGME20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca@epcms5p2>
 <20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca@epcms5p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca@epcms5p2>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 07:32:07PM +0800, 李捷 wrote:
> >From 0fbcd7e386898d829d3000d094358a91e626ee4a Mon Sep 17 00:00:00 2001
> From: Jie Li <jie6.li@samsung.com>
> Date: Mon, 7 Dec 2020 08:05:07 +0800
> Subject: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq equals to
>  IRQ_NOTCONNECTED

Why is this in the body of the email?

Please just use 'git send-email' or some other sane email client to send
patches out so that we can apply them correctly.

thanks,

greg k-h
