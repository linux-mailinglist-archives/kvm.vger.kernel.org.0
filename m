Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1599515182E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 10:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgBDJtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 04:49:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726479AbgBDJtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 04:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580809788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QMMZyzmGnRuRqMTcQDYBBSptxEtc2oQ8xAtmgxtCpo=;
        b=DVMoPUS0HiZHipkhrMqWtEK6NixVlqH+1qWmnh1Eyf1ujINTV9IiQSBr2ih7pq+Wlz9pn4
        1LVVsdwmc6iq7SOxbKKixpe1y20UH6VmXt4Ih3wGueyH04xmceN7WAa5gxhSxOj036106J
        9Yn3hZscga+TBQm0yFk73xMvhhVav60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-FMNY4un9Pbyvt7Fo5RKrwA-1; Tue, 04 Feb 2020 04:49:43 -0500
X-MC-Unique: FMNY4un9Pbyvt7Fo5RKrwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED79E10CE780;
        Tue,  4 Feb 2020 09:49:41 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C718F196AE;
        Tue,  4 Feb 2020 09:49:37 +0000 (UTC)
Date:   Tue, 4 Feb 2020 10:49:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 02/37] s390/protvirt: introduce host side setup
Message-ID: <20200204104935.0c40b169.cohuck@redhat.com>
In-Reply-To: <37a54aaf-a297-1caf-478a-523acd6af6b1@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-3-borntraeger@de.ibm.com>
        <20200203181238.7c7ea03b.cohuck@redhat.com>
        <0310f99f-6d1e-b1bb-9313-be2a92c601ba@de.ibm.com>
        <20200204102820.51081649.cohuck@redhat.com>
        <37a54aaf-a297-1caf-478a-523acd6af6b1@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 10:38:55 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 04.02.20 10:28, Cornelia Huck wrote:
> > On Mon, 3 Feb 2020 23:03:42 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 03.02.20 18:12, Cornelia Huck wrote:  
> >>> On Mon,  3 Feb 2020 08:19:22 -0500
> >>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>>     
> >>>> From: Vasily Gorbik <gor@linux.ibm.com>
> >>>>
> >>>> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> >>>> protected virtual machines hosting support code.    
> >>>
> >>> Hm... I seem to remember that you wanted to drop this config option and
> >>> always build the code, in order to reduce complexity. Have you
> >>> reconsidered this?    
> >>
> >> I am still in favour of removing this, but I did not get an "yes, lets do
> >> it" answer. Since removing is easier than re-adding its still in.  
> > 
> > ok  
> 
> Any preference from you?

Not at the moment, I still need to look at the following patches.

> 
> [...]
> > 
> > I think I was confused about different things last time...
> > 
> > But that is probably a sign that this wants a comment :)  
> 
> Will add
> 
> to kernel/uv.c
> /* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
> 
> to boot/uv.c
> /* will be used in arch/s390/kernel/uv.c */

Thanks!

> 
> 
> [...]
> > Fair enough; it's just that it's not very clear from the messages in
> > the log what happened. Maybe
> > 
> > "prot_virt: Running as protected virtualization guest."
> > "prot_virt: The ultravisor call facility is not available."
> > 
> > That at least links back to the kernel parameter.  
> 
> I will defer this until the end, in the hope to have a final name by then.
> 
ok

