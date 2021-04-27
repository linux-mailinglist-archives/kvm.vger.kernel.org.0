Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54E36C94D
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbhD0QYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50375 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237922AbhD0QWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3685A613E8;
        Tue, 27 Apr 2021 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619540042;
        bh=iJNKy1jyc1ewpilCIEXTE5LNRd9USHOEzh5sVXQBNr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4YWzbE16b+wOrx0Qj3/x9fWhJchKLjSqDiarZ5i15sQ+QxblkpVH0BM/5vjBFnhs
         qSGShTAsnBdpOl59Pp/+b26Kb47Z0QJfF32EokvL0j+h0BwIvrRFOW3tTQoWkY/VWT
         lhla5Tk9oq7njCe39geH8pQH/cXHgQEx+O0Mhf6E=
Date:   Tue, 27 Apr 2021 18:14:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     firas ashkar <firas.ashkar@savoirfairelinux.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: uio_pci_generic: add memory mappings
Message-ID: <YIg4SLWo3YEzO/U8@kroah.com>
References: <20210426190346.173919-1-firas.ashkar@savoirfairelinux.com>
 <YIetS88K/xLGHlXB@kroah.com>
 <878b461c295c084aa7152b56668b3e61aa78f744.camel@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878b461c295c084aa7152b56668b3e61aa78f744.camel@savoirfairelinux.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 10:06:39AM -0400, firas ashkar wrote:
> Hi,
> The reason for these extra changes is the result of running 
> fashkar@barbarian:~/Downloads/linux_mainline$ clang-format -style=file
> -i drivers/uio/uio_pci_generic.c

Please do not mix coding style changes with real fixes/additions.

And always review what a tool does, some of those changes were wrong.

thanks,

greg k-h
