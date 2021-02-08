Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D161C3143B9
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 00:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBHX1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 18:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhBHX1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 18:27:07 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5AFC061788
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 15:26:27 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id h8so6091733qkk.6
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 15:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tPs7Rxd3+a1J4EcPtbp92Vc8SIRVzBfN6f0oIsK/9dE=;
        b=NGjt6irEWGzDe4R0vuCTGyrQtyj+Lqew2oddL9qXYYkTZi3hhtyG5TI8KRmoHku4Z6
         I/rDjvOu8LBsGkR/eDbnCjg+qzHLR5uL/lXzqVJBJWF7lTbDTTQnj31VWRcSSU38XJkF
         ZUXv2uerrPTteSPfpP/x7KBNkFNj34yXvDcbiUUJYe0CUwRKgxgPkWOYY+ixLlzPM+pG
         o08Os9fzu3jVp0yHonS5lYnDKycpicZDlNKLfkRCkp4Yc49CG/S+p/hSK0+Jdic42+BD
         FurImZvpISN/hhX+vEsJWpBVYY+XEF9zHrkBXlAuQkqpqhZvPqw2LoE8i2sMKsC9yd1i
         i34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tPs7Rxd3+a1J4EcPtbp92Vc8SIRVzBfN6f0oIsK/9dE=;
        b=kdtMlJFObkS4QttEziNH6VvHjbOjjVDeice+rme2jZOubroZNwIYkwVrSsm5pcfjTQ
         OaWaqm/LLVdL2NYmB0G8fKoFuXhFSeCqop0DF7GWz1+0HpHQZFR9AzS3xAprUkdCRS+5
         6wIxTpuh2OkH725mpbUpYWqM5zd1iNs/l47fwTqaj2R3mVsTkdTbHR/Gjx4LNfpMs+rz
         4AgF2AORV3fG3f3luIz4EzjCgMfzWWIZMkiTrgxBHRocasvLgwee7slILWyshyR4B8kJ
         Si3breUSr3LspkOS+R0z+L+rhrT0BaFfvb1z0pxnELk2boThLDCZEdKVfQraC4ZgpXQ0
         GTew==
X-Gm-Message-State: AOAM533oWTemfIhDK3g4TbtuMim6R1Tm5xqzF7GVCibAtsO+KEvHAlWm
        CoGIC5FWZySJpMZw4qkq2bZIag==
X-Google-Smtp-Source: ABdhPJwSgIbUiF0xJm2keLZ0APQp0Ru6baflVBIy955ENsWj4a1eAmS+5rWyR/uRtttw/vmjx7myMQ==
X-Received: by 2002:a05:620a:5fa:: with SMTP id z26mr19500613qkg.108.1612826786830;
        Mon, 08 Feb 2021 15:26:26 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id q55sm2537411qtq.57.2021.02.08.15.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 15:26:26 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l9FvF-0057WX-GA; Mon, 08 Feb 2021 19:26:25 -0400
Date:   Mon, 8 Feb 2021 19:26:25 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     dan.j.williams@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210208232625.GA4718@ziepe.ca>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1>
 <20210208185133.GW4718@ziepe.ca>
 <20210208220259.GA71523@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208220259.GA71523@xz-x1>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 05:02:59PM -0500, Peter Xu wrote:
> On Mon, Feb 08, 2021 at 02:51:33PM -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 05, 2021 at 01:14:11PM -0500, Peter Xu wrote:
> > 
> > > But I do have a question on why dax as the only user needs to pass in the
> > > notifier to follow_pte() for initialization.
> > 
> > Not sure either, why does DAX opencode something very much like
> > page_mkclean() with dax_entry_mkclean()?
> > 
> > Also it looks like DAX uses the wrong notifier, it calls
> > MMU_NOTIFY_CLEAR but page_mkclean_one() uses
> > MMU_NOTIFY_PROTECTION_PAGE for the same PTE modification sequence??
> > 
> > page_mkclean() has some technique to make the notifier have the right
> > size without becoming entangled in the PTL locks..
> 
> Right.  I guess it's because dax doesn't have "struct page*" on the
> back, so it

It doesn't? I thought DAX cases did?

Jason
