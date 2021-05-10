Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5C377C19
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhEJGOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 02:14:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E39C061573;
        Sun,  9 May 2021 23:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P+kqNKNxvPn+WQsUe5wG5zKQfBTbs5EJcqRgrHP9ME0=; b=dNGYaNsIcZd9E+MQZ3SmcZ17xa
        Ehrbo+Xv2Hw2kBNS2yk5pUL2c0vHN7W3u36TfFocvfUIaO4kEqHccpqWrZ2YqHOhEcpWp6xzUyEpy
        9QPviiTgwn40yKHOZrQekbCAKuFR7Bon5h0LA7EhOS163tpMBmp5fD+h6pyJJ065i4GYGlwZC9miy
        5OgYbAUFaNU2QEzmcPfBNe8YZWyDcKd9fzN/HIFxPkbZPEI3EFQ5rBPG3diF+MVi47whLZDKlffTs
        DeN9IIXGRey3NGZa5852S337GbhGHC1XwxhpH1NP/XkgF/6BDOkeOY2g/uco2HR9l9d8zedKLpyYi
        M3QAWiJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lfz9q-005lOi-3j; Mon, 10 May 2021 06:12:47 +0000
Date:   Mon, 10 May 2021 07:12:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <YJjO3n6jWYDoYPAo@infradead.org>
References: <162041357421.21800.16214130780777455390.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162041357421.21800.16214130780777455390.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 12:53:17PM -0600, Alex Williamson wrote:
> +	/*
> +	 * The OpRegion size field is specified as size in KB, but there have been
> +	 * user reports where this field appears to report size in bytes.  If we
> +	 * read 8192, assume this is the case.
> +	 */

Please avoid pointlesly spilling the comment line over 80 chars.


> +	if (size == OPREGION_SIZE)

Shouldn't this be a range tests, i.e. >= ?
