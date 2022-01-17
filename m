Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E7D490371
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbiAQIJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:09:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42920 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiAQIJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:09:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92862CE0F72;
        Mon, 17 Jan 2022 08:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF8AC36AE7;
        Mon, 17 Jan 2022 08:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642406950;
        bh=+ker6gPqXQx23Br01jW9fxItorIHv0lFU3htpl/ApUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfnzylFJBmQV9Y73T0iNxTjqdDQABm/h3OndI613+xpDaE06QBLu8lMjkVgnwS1f8
         KLzZrnjL0zE/Xn6XTxourrPFYRiuKagDS2VhZmXjWcBrgEu1JIzcaHN2MWYghtuzix
         JkFK5kkiW16iBTgUOg93vgA/Y2w5r59Tr5RM0qUY=
Date:   Mon, 17 Jan 2022 09:09:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "James D. Turner" <linuxkernel.foss@dmarc-none.turner.link>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Message-ID: <YeUkIyAsrYHOuaKt@kroah.com>
References: <87ee57c8fu.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee57c8fu.fsf@turner.link>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 16, 2022 at 09:12:21PM -0500, James D. Turner wrote:
> So, the issue was introduced between v5.13 and v5.14-rc1. I'm willing to
> bisect the commit history to narrow it down further, if that would be
> helpful.

Bisection would be great as that is a very large range of commits there
from many months ago, so people might not remember what could have
caused this issue.

thanks,

greg k-h
