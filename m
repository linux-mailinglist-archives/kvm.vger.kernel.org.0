Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1361D5534
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOPyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:54:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbgEOPyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 11:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589558061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGF1RdECh7wTY0j1oOebqWNqb2M0++gn2OMVdOGWJas=;
        b=B87Dqiboy6O04DsAqdQJtuv0d9cEClyKd4J8Zve4tHYPuFmH2sbCdZrhCLgIJB7srwf5x6
        hI7kbH+pj9vstmVp5TImpaUbKNDomfJWHZmo+uipVuTm5QM0S3ffhrG3usfEzN/1Su1j+z
        xo6pkGUa42GpMU/EYi0LVhCXbjjHrO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-sfmsUV6GPmCSS2DzrcwDSg-1; Fri, 15 May 2020 11:54:19 -0400
X-MC-Unique: sfmsUV6GPmCSS2DzrcwDSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3E48189952E;
        Fri, 15 May 2020 15:54:18 +0000 (UTC)
Received: from w520.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83A785C1D6;
        Fri, 15 May 2020 15:54:15 +0000 (UTC)
Date:   Fri, 15 May 2020 09:54:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200515095415.3dd4d253@w520.home>
In-Reply-To: <20200515152251.GB499802@xz-x1>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
        <20200514212538.GB449815@xz-x1>
        <20200514161712.14b34984@w520.home>
        <20200514222415.GA24575@ziepe.ca>
        <20200514165517.3df5a9ef@w520.home>
        <20200515152251.GB499802@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 11:22:51 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Thu, May 14, 2020 at 04:55:17PM -0600, Alex Williamson wrote:
> > > I'm not if this makes sense, can't we arrange to directly trap the
> > > IOMMU failure and route it into qemu if that is what is desired?  
> > 
> > Can't guarantee it, some systems wire that directly into their
> > management processor so that they can "protect their users" regardless
> > of whether they want or need it.  Yay firmware first error handling,
> > *sigh*.  Thanks,  
> 
> Sorry to be slightly out of topic - Alex, does this mean the general approach
> of fault reporting from vfio to the userspace is not gonna work too?

AFAIK these platforms only generate a fatal fault on certain classes of
access which imply a potential for data loss, for example a DMA write to
an invalid PTE entry.  The actual IOMMU page faulting mechanism should
not be affected by this, or at least one would hope.  Thanks,

Alex

