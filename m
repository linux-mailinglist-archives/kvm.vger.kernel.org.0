Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E981DC05C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgETUkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETUkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 16:40:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEFFC061A0E;
        Wed, 20 May 2020 13:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y/KWCW/p6UEY0CE3GxluJHgj+NYN+hDzrTZTbCbfJ9E=; b=Avl/i8C4AYLClzRSFSxL0oNff2
        XckOGyx31b3U6eEb2mQPp9GnLvH7RYKCyJgKvMttSoafE4cmW/2tnQmWlado1W+ZEawITGDu+SSeq
        Yak6ru0HJEDPKYadBn+h7IOMEm83fDqZFcrTyE5Om37fMFtEIQCjbDeMFyvYJ5lTG4AjF4Wf18tZT
        qLaFcJC507IH4Lqqqu74m3TElJ7gYqoijxASzWjS/hDEonDVRchiWEO0GHXBIByO6ayqp1DAVCc0r
        ZG+7f04CuLMxa4nPioRXMpHOiyOzs+Wnk9Bi6AUKc64sRbi/bmNiSEZUM8li3ZIYgc+cRIVCSVRsu
        NYhyHoTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbVW0-0003wE-Fg; Wed, 20 May 2020 20:40:36 +0000
Date:   Wed, 20 May 2020 13:40:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 22/24] uaccess: add memzero_user
Message-ID: <20200520204036.GA1335@infradead.org>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-23-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520172145.23284-23-pbonzini@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 01:21:43PM -0400, Paolo Bonzini wrote:
> +			unsafe_put_user(val, (unsigned long __user *) from, err_fault);

This adds a way too long line.  In many ways it would be much nicer if
you used an unsigned long __user * variable internally, a that would
remove all these crazy casts and actually make the code readable.
