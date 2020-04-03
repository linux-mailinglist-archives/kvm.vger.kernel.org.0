Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D29619D4B5
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 12:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgDCKMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 06:12:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727774AbgDCKMV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 06:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585908740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rhRDo/nNuXnp6F49mrirn5C3KQFx3IFFLknXJW1wcxU=;
        b=eaFPh3PYecRkUgTrAiByyPKXbDcne90sG8zEdNLbV/RD5HANWFxUCrNX7Y1hakGeH8NnY9
        3bVxET+vjZAEmW+FOscZCPdfhfTSreJtLhdUYBASw7eFtjfSNEEx+MZQSYqA1ME1ZlLgnZ
        6WKZQCJE/oqeZqmlEBjlZ2FJgRwnPbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-fBYUfL7VMta-Mk59WDXDxg-1; Fri, 03 Apr 2020 06:12:16 -0400
X-MC-Unique: fBYUfL7VMta-Mk59WDXDxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8D15107ACC4;
        Fri,  3 Apr 2020 10:12:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 680185DA75;
        Fri,  3 Apr 2020 10:12:11 +0000 (UTC)
Date:   Fri, 3 Apr 2020 12:12:08 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: Re: [PATCH kvm-unit-tests v2] s390x: unittests: Use smp parameter
Message-ID: <20200403101208.dvx7llsrvoqpq4vz@kamzik.brq.redhat.com>
References: <20200403094015.506838-1-drjones@redhat.com>
 <e66041e9-12bb-4b54-4532-b832726b216c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66041e9-12bb-4b54-4532-b832726b216c@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 11:58:02AM +0200, David Hildenbrand wrote:
> On 03.04.20 11:40, Andrew Jones wrote:
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> > 
> > v2: Really just a repost, but also picked up the tags.
> 
> (sorry, missed to pick this one up)
> 
> > 
> >  s390x/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 07013b2b8748..aa6d5d96e292 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -74,7 +74,7 @@ file = stsi.elf
> >  
> >  [smp]
> >  file = smp.elf
> > -extra_params =-smp 2
> > +smp = 2
> >  
> >  [sclp-1g]
> >  file = sclp.elf
> > 
> 
> Thanks, queued to
> 
> https://github.com/davidhildenbrand/kvm-unit-tests.git s390x-next
> 
> On the branch, we also do have
> 
> [stsi]
> file = stsi.elf
> extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -smp 1,maxcpus=8
> 
> Can that be expressed similarly?
> 

It would still work with QEMU if you changed it to

 extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003
 smp = 1,maxcpus=8

which is similar to what powerpc has with one of their tests

 smp = 2,threads=2

About the only problem I see with that is that we've documented the
'smp' unittests parameter as taking a '<num>', and if we want to get
other KVM userspaces working with kvm-unit-tests then we should try
to keep our unittests.cfg files VMM agnostic, and stick to its
documentation.

IOW, I'd probably leave 'stsi' as is.

Thanks,
drew

