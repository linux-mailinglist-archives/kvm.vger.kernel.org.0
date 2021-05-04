Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381D9372AAA
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 15:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhEDNKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 09:10:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhEDNKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 09:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620133746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+a3Gqq/AQH86AQgX5MsIHGOIG8nweku9Ika1zopWOs=;
        b=Zkt+yWzbHJqqo474875sFuCcBLDKnBjDSB7kEd6blfzTuiXGCtz2NKA996bbQP80YJcGx0
        kPkDQyTixwwqOGdD/peEe2KUBzBIOrUYSWG/OFwRAKN8se5bzNWylb26XJTO2S02A8pbcv
        t8H+MSlkG1WUSTpd6fNaUj7ViVZtT00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-sAMffVlyOI2oanb_IGH7cQ-1; Tue, 04 May 2021 09:09:03 -0400
X-MC-Unique: sAMffVlyOI2oanb_IGH7cQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4102964157;
        Tue,  4 May 2021 13:09:01 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37B075D72F;
        Tue,  4 May 2021 13:08:53 +0000 (UTC)
Date:   Tue, 4 May 2021 15:08:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        qemu-devel@nongnu.org, Daniel Vetter <daniel@ffwll.ch>,
        kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kurz <groug@kaod.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-api@vger.kernel.org,
        qemu-ppc@nongnu.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504150851.54e278f8.cohuck@redhat.com>
In-Reply-To: <20210504130039.GA7711@lst.de>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210504142236.76994047@bahia.lan>
        <YJFFG1tSP0dUCxcX@kroah.com>
        <20210504130039.GA7711@lst.de>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 May 2021 15:00:39 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, May 04, 2021 at 02:59:07PM +0200, Greg Kroah-Hartman wrote:
> > > Hi Christoph,
> > > 
> > > FYI, these uapi changes break build of QEMU.  
> > 
> > What uapi changes?
> > 
> > What exactly breaks?
> > 
> > Why does QEMU require kernel driver stuff?  
> 
> Looks like it pull in the uapi struct definitions unconditionally
> instead of having a local copy.  We could fix that by just putting
> them back, but to me this seems like a rather broken configuration
> in qemu when it pulls in headers from the running/installed kernel
> without any feature checks before using them.
> 

It is not pulling them from the installed kernel, but from a
development version to get new definitions. Removing things in the
kernel requires workarounds in QEMU until it can remove those things as
well. It is not a dumb update...

