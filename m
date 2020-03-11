Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF318223D
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 20:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbgCKT1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 15:27:43 -0400
Received: from elvis.franken.de ([193.175.24.41]:34841 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbgCKT1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 15:27:43 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jC713-0008JO-01; Wed, 11 Mar 2020 20:27:41 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 46A54C1038; Wed, 11 Mar 2020 20:20:17 +0100 (CET)
Date:   Wed, 11 Mar 2020 20:20:17 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH -next 015/491] KERNEL VIRTUAL MACHINE FOR MIPS
 (KVM/mips): Use fallthrough;
Message-ID: <20200311192017.GB3588@alpha.franken.de>
References: <cover.1583896344.git.joe@perches.com>
 <5a1ee76be0f502af626f50313456730d75fe424b.1583896348.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a1ee76be0f502af626f50313456730d75fe424b.1583896348.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 09:51:29PM -0700, Joe Perches wrote:
> Convert the various uses of fallthrough comments to fallthrough;
> 
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/mips/kvm/emulate.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
