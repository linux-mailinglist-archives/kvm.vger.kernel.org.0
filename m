Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94624299300
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786636AbgJZQyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:54:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1786625AbgJZQyQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 12:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603731255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLEKZXx53bC/AXofQXHwBHnCSy+NkKOX2yE9+4TERTk=;
        b=XEpcAbje/9DlFiVKVZFg+yoz6FBDUbCxM8x/m+SSfvAKVdMPpFrxeTJSVvKkFIV+XFXWjw
        0PoP1GR+mpa/6IrawOvtiObpiCLB65i7l8snMDRjnB2ou/3hjKOT7O+nNFGQtoNk1sGYHr
        89d7Mgze88agg8HR2QBbfz1g6fshT6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-6gZAGOtrPBiQoHan6C7dTA-1; Mon, 26 Oct 2020 12:54:11 -0400
X-MC-Unique: 6gZAGOtrPBiQoHan6C7dTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF78B1009E27;
        Mon, 26 Oct 2020 16:54:09 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E01445D9E4;
        Mon, 26 Oct 2020 16:53:54 +0000 (UTC)
Date:   Mon, 26 Oct 2020 10:53:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, thuth@redhat.com,
        pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, philmd@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 00/13] s390x/pci: s390-pci updates for kernel 5.10-rc1
Message-ID: <20201026105354.703fc480@w520.home>
In-Reply-To: <20201026174124.1a662fa3.cohuck@redhat.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
        <20201026171947.0f302dcc.cohuck@redhat.com>
        <20201026174124.1a662fa3.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Oct 2020 17:41:24 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, 26 Oct 2020 17:19:47 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Mon, 26 Oct 2020 11:34:28 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> > > Combined set of patches that exploit vfio/s390-pci features available in
> > > kernel 5.10-rc1.  This patch set is a combination of 
> > > 
> > > [PATCH v4 0/5] s390x/pci: Accomodate vfio DMA limiting
> > > 
> > > and
> > > 
> > > [PATCH v3 00/10] Retrieve zPCI hardware information from VFIO
> > > 
> > > with duplicate patches removed and a single header sync.  All patches have
> > > prior maintainer reviews except for:
> > > 
> > > - Patch 1 (update-linux-headers change to add new file)     
> > 
> > That one has ;)
> >   
> > > - Patch 2 (header sync against 5.10-rc1)    
> > 
> > I'm still unsure about the rdma/(q)atomic stuff -- had we reached any
> > conclusion there?
> >   
> > > - Patch 13 - contains a functional (debug) change; I switched from using
> > >   DPRINTFs to using trace events per Connie's request.  
> 
> Looks good.
> 
> I think that should go through the vfio tree, in case there are
> collisions with the migration stuff?
> 
> (The s390x queue is currently empty.)

Patches appear to apply cleanly on top of the migration series, but I
can take it if preferred.  Thanks,

Alex

