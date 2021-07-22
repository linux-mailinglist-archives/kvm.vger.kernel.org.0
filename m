Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E633D21CD
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhGVJ3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 05:29:54 -0400
Received: from elvis.franken.de ([193.175.24.41]:45347 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhGVJ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 05:29:53 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1m6Ves-0007ey-02; Thu, 22 Jul 2021 12:10:26 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id D5AB7C11EE; Thu, 22 Jul 2021 12:09:29 +0200 (CEST)
Date:   Thu, 22 Jul 2021 12:09:29 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-mips@linux-mips.org,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH 1/2] mips: replace deprecated EXTRA_CFLAGS with ccflags-y
Message-ID: <20210722100929.GA7427@alpha.franken.de>
References: <20210331150658.38919-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331150658.38919-1-masahiroy@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021 at 12:06:56AM +0900, Masahiro Yamada wrote:
> As Documentation/kbuild/makefiles.rst says, EXTRA_CFLAGS is deprecated.
> Replace it with ccflags-y.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  arch/mips/kvm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
