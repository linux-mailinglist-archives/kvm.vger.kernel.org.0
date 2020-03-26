Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3DE193C0B
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgCZJiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:38:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgCZJiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 05:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eIxU9D2p34AyD0LcFkAamRDcJSbLLbHXVWCZNZkPA64=; b=htiLJTEoNalekvmhBxZGNPfUQf
        1NvDakxqrDuRl4RyY4QsQLL+5R/yN1EoFpAXTV4pr/5GkeqsGtqK+DO3zmJkGeRbpDvRN6hyTRNwl
        60SlF+6JxRwhiBJGeZKZwAQodGHrcmbI6AXqa0dT1yazkJ4YItI3n9adkzzOHz+FcVNWsxOMvcwi9
        ecQGHkmxmwRKUkFI3PhOGmIjLRc6OhSJ1wwGziK0AXownrW9SNSOLqvkuMC9i8ZMrorIyhbSaR8aG
        z3PaNAuHQ1J3BbQh7GKjJjzcHMaDUr2C1MVLnvZ2CG4wi+iLt3b0LmBAv/iG+DqDiEKTnwBlpJcyf
        zoKpKKBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHOxj-0005Mq-1H; Thu, 26 Mar 2020 09:38:07 +0000
Date:   Thu, 26 Mar 2020 02:38:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yonghyun Hwang <yonghyun@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
Message-ID: <20200326093807.GB12078@infradead.org>
References: <20200320175910.180266-1-yonghyun@google.com>
 <20200323111404.GA4554@infradead.org>
 <CAEauFbww3X2WZuOvMbnhOD2ONBjqR-JS2BrxWPO=HqzXVcKakw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEauFbww3X2WZuOvMbnhOD2ONBjqR-JS2BrxWPO=HqzXVcKakw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 02:33:11PM -0700, Yonghyun Hwang wrote:
> On Mon, Mar 23, 2020 at 4:14 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Fri, Mar 20, 2020 at 10:59:10AM -0700, Yonghyun Hwang wrote:
> > > To enable a mediated device, a device driver registers its device to VFIO
> > > MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> > > the sysfs attribute, "create", to create the mediated device. This
> > > additional step happens after boot-up gets complete. If the driver knows
> > > how many mediated devices need to be created during probing time, the
> > > additional step becomes cumbersome. This commit implements a new function
> > > to allow the driver to create a mediated device in kernel.
> >
> > Please send this along with your proposed user so that we can understand
> > the use.  Without that new exports have no chance of going in anyway.
> 
> My driver is still under development. Do you recommend me to implement
> an example code for the new exports and re-submit the commit?

Hell no.  The point is that we don't add new APIs unless we have
actual users (not example code!).  And as Alex mentioned the use case
is rather questionable anyway, so without a user that actually shows a
good use case which would remove those doubts it is a complete no-go.
