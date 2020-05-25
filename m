Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67831E10F2
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391024AbgEYOqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403985AbgEYOqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:46:53 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1B7C05BD43
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 07:46:53 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id er16so8141026qvb.0
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wNdLBHvbkTrwN+yv/sWMGmtXLBwALXBbwKYXu5aEHds=;
        b=jUsF++no9yX2fF8uzTtI9oj/C9thJExJqPCGhhaD4fJTlBwO/ZBSx4onZJ/fZfzXWj
         80T4kbcru+tTX41qGg3Pe6vW/3QOf01HzpY+r0+WYykWJt3Z2YFJhT9v0sAFpXepyWM9
         BW+gnEBpBtxROJG9e5ZQysyeI4Y9AIe/VJ5AAAB5MCyt5l+0XZn00gLNei0pcHcvqhsu
         pzHq6j6UGldrXe0kGezNIprVuagZjfuaS7Sct0nu8IFtPsunWaFDNMmbl76it5XvBLjn
         Q5SwCGijPD6wU+5MSunv9HIjZLzdHDF0Z5+hEGDMH5Fto54g+NmbmDBtkkgfrK7FFQm3
         LmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wNdLBHvbkTrwN+yv/sWMGmtXLBwALXBbwKYXu5aEHds=;
        b=LQp2YgT48v1+mZ4ikuGkk9HisDJsW3xSMjbEKnaKAZk2UY+Jfzs59WcblzNbl5Y7my
         gOvezH/C9QZd5DAVDFTBAse6l1RRUTr6POgKnuJJytdCKC4AuauLYq2hhj3YJY9dEaQ9
         npalIW3zylkvE5IWmE/hfiNm1A6o/5sHtrNMQ1cyCsLj8IKAUSpcBLL48xE6vhMCvKjx
         NA78k427YtLmIE6WKnGZJ44efLrbPu/3vre8W8x3BOCPUexw6Eq01m1chmv5kFrI6z1w
         yXuWZ50LSMT46nPIK+qokHYKK4jOczMKF8JETb5T7Wg71PRmVKrC5qIfzlTj4D+upcaf
         1iqA==
X-Gm-Message-State: AOAM531B4RlrZkuyhqiOcgj+/+50IZz9OhedQkZIDpJDDCYtdTeBB2PB
        SmFp9TEVzJAiQXbrH7O1qzg6GQ==
X-Google-Smtp-Source: ABdhPJzk9PXL5tuv6VnSy7N8GOFpoWO0KEErxD0sHMREjIJBWXzzD3MhgE/cnw3FD0VFZNqibPePCQ==
X-Received: by 2002:ad4:57a1:: with SMTP id g1mr15119941qvx.27.1590418012932;
        Mon, 25 May 2020 07:46:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id z3sm1070743qkl.111.2020.05.25.07.46.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 07:46:52 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdENP-0005qy-HO; Mon, 25 May 2020 11:46:51 -0300
Date:   Mon, 25 May 2020 11:46:51 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cai@lca.pw
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200525144651.GE744@ziepe.ca>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525142806.GC1058657@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 10:28:06AM -0400, Peter Xu wrote:
> On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> > On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> > 
> > > For what I understand now, IMHO we should still need all those handlings of
> > > FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> > > try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> > > not sure what would be the side effect of that if fault() blocked it.  E.g.,
> > > the caller could be in an atomic context.
> > 
> > AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
> > VM_FAULT_RETRY is returned, which this doesn't do?
> 
> Yes, that's why I think we should still properly return VM_FAULT_RETRY if
> needed..  because IMHO it is still possible that the caller calls with
> FAULT_FLAG_RETRY_NOWAIT.
> 
> My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:
> 
>   - We cannot release the mmap_sem, and,
>   - We cannot sleep

Sleeping looks fine, look at any FS implementation of fault, say,
xfs. The first thing it does is xfs_ilock() which does down_write().

I can't say when VM_FAULT_RETRY comes into play, but it is not so
simple as just sleeping..

Jason
