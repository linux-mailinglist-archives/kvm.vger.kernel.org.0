Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA725266474
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIKQib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIKPMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 11:12:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D876D20575;
        Fri, 11 Sep 2020 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599837128;
        bh=boBKEfpq+ALTe5FlCo88gBogFYwgRaTO/3chRAqYMZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+d9RmiaARzLVRWn9/QD0JaJRV71JJdXd1OpvSR4iePv2I/KwBepMDnoG1iCtzgwV
         Y0yJR8fr4UTATv1hzAFVYr/CeKK3IE4XkEctzkJyg9CGHGSr64G0lh8RSmSuZucdWX
         1yOskH/rR4AOn9JAfX2HlImIan/LDbXjsFyexiHM=
Date:   Fri, 11 Sep 2020 17:12:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
Message-ID: <20200911151213.GB3821769@kroah.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-18-andraprs@amazon.com>
 <20200907090126.GD1101646@kroah.com>
 <44a8a921-1fb4-87ab-b8f2-c168c615dbbd@amazon.com>
 <20200907140803.GA3719869@kroah.com>
 <b8a1e66c-7674-7354-599e-159efd260ba9@amazon.com>
 <310abd0d-60e7-a52c-fcae-cf98ac474e32@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <310abd0d-60e7-a52c-fcae-cf98ac474e32@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 05:56:10PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 07/09/2020 18:13, Paraschiv, Andra-Irina wrote:
> > 
> > 
> > On 07/09/2020 17:08, Greg KH wrote:
> > > On Mon, Sep 07, 2020 at 04:43:11PM +0300, Paraschiv, Andra-Irina wrote:
> > > > 
> > > > On 07/09/2020 12:01, Greg KH wrote:
> > > > > On Fri, Sep 04, 2020 at 08:37:17PM +0300, Andra Paraschiv wrote:
> > > > > > Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> > > > > > Reviewed-by: Alexander Graf <graf@amazon.com>
> > > > > > ---
> > > > > > Changelog
> > > > > > 
> > > > > > v7 -> v8
> > > > > > 
> > > > > > * Add info about the primary / parent VM CID value.
> > > > > > * Update reference link for huge pages.
> > > > > > * Add reference link for the x86 boot protocol.
> > > > > > * Add license mention and update doc title / chapter formatting.
> > > > > > 
> > > > > > v6 -> v7
> > > > > > 
> > > > > > * No changes.
> > > > > > 
> > > > > > v5 -> v6
> > > > > > 
> > > > > > * No changes.
> > > > > > 
> > > > > > v4 -> v5
> > > > > > 
> > > > > > * No changes.
> > > > > > 
> > > > > > v3 -> v4
> > > > > > 
> > > > > > * Update doc type from .txt to .rst.
> > > > > > * Update documentation based on the changes from v4.
> > > > > > 
> > > > > > v2 -> v3
> > > > > > 
> > > > > > * No changes.
> > > > > > 
> > > > > > v1 -> v2
> > > > > > 
> > > > > > * New in v2.
> > > > > > ---
> > > > > >    Documentation/nitro_enclaves/ne_overview.rst | 95
> > > > > > ++++++++++++++++++++
> > > > > >    1 file changed, 95 insertions(+)
> > > > > >    create mode 100644 Documentation/nitro_enclaves/ne_overview.rst
> > > > > A whole new subdir, for a single driver, and not tied into the kernel
> > > > > documentation build process at all?  Not good :(
> > > > > 
> > > > Would the "virt" directory be a better option for this doc file?
> > > Yes.
> > 
> > Alright, I'll update the doc file location, the index file and the
> > MAINTAINERS entry to reflect the new doc file location.
> > 
> 
> I sent out a new revision that includes the updates based on your feedback.
> Thanks for review.
> 
> To be aware of this beforehand, what would be the further necessary steps
> (e.g. linux-next branch, additional review and / or sanity checks) to
> consider for targeting the next merge window?

If all looks good, I can just suck it into my char-misc branch to get it
into 5.10-rc1.  I'll look at the series next week, thanks.

thanks,

greg k-h
