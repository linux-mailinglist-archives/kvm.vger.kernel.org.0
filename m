Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C832827D9
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 03:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgJDBgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 21:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgJDBgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 21:36:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52978C0613D0;
        Sat,  3 Oct 2020 18:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NDQcs2sypgUb2kaljw/PLF9eyPJJqCCMKlV+6nk3qyA=; b=iVM81vLVhXohJ7qOoV+tDGUf5Y
        SKtcp4UP39tB0Axj/fhnx76xM9UduT8h8NuuwmPPI2fW3v/mtptxbfO2tzewdHuO6lPpYW+Aj+hH7
        ZH3++M4csNhhE5vPVviIUIkZY0/6PBnBvRx4AWYA0sinPAsWQDg9JvEp4gOFMrYXc0cSi33bRdc1l
        T7NPCMiJaVpAuXiuuZFV2CF/pFefDvXY9sqmtI4qrV+ieA/rZlivPwk3qDmNUNhvQIXvZk4GRmNbt
        VWblMIFSOQYERk6gOsg/lvRl3UCfj9tFR7whYVt5c62bFdmNc8L+Mv1u92CHPYlIqyQFgVn9Bx+ST
        SBST4P7w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOsws-00012u-Sq; Sun, 04 Oct 2020 01:36:27 +0000
Date:   Sun, 4 Oct 2020 02:36:26 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Joe Perches <joe@perches.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, rcu@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Where is the declaration of buffer used in kernel_param_ops .get
 functions?
Message-ID: <20201004013626.GE20115@casper.infradead.org>
References: <cover.1601770305.git.joe@perches.com>
 <250919192de237dadf36218ee6b4dabf1bd4cbde.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <250919192de237dadf36218ee6b4dabf1bd4cbde.camel@perches.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 03, 2020 at 06:19:18PM -0700, Joe Perches wrote:
> These patches came up because I was looking for
> the location of the declaration of the buffer used
> in kernel/params.c struct kernel_param_ops .get
> functions.
> 
> I didn't find it.
> 
> I want to see if it's appropriate to convert the
> sprintf family of functions used in these .get
> functions to sysfs_emit.
> 
> Patches submitted here:
> https://lore.kernel.org/lkml/5d606519698ce4c8f1203a2b35797d8254c6050a.1600285923.git.joe@perches.com/T/
> 
> Anyone know if it's appropriate to change the
> sprintf-like uses in these functions to sysfs_emit
> and/or sysfs_emit_at?

There's a lot of preprocessor magic to wade through.

I'm pretty sure this comes through include/linux/moduleparam.h
and kernel/module.c.
