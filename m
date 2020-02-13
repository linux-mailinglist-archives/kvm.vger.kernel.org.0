Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6ED15C888
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 17:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBMQmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 11:42:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727754AbgBMQmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 11:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581612173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUAVztf0mnqwOsxLxzEADFCDw8cl8eEfkVuidQniXqk=;
        b=V7pa+RzF1762u59TJ10FkkXnw1qQtjKwIdTlTgt3KVoTl0aOUd8dTkqZ7NG9yyv/UZFvPu
        TwKI1TYU0QJyo5RrFTeDFuLTcgSSmdh98JhxgVYxtayhQAHMaQa8HMQGhHX4oBnjbWhNaX
        kjPj3MoN3lOZYZHTi1aD1QfAXYpu2Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-2-Ux7KseMyS3itl3VlAXBg-1; Thu, 13 Feb 2020 11:42:47 -0500
X-MC-Unique: 2-Ux7KseMyS3itl3VlAXBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1DA08017CC;
        Thu, 13 Feb 2020 16:42:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C98E5C100;
        Thu, 13 Feb 2020 16:42:42 +0000 (UTC)
Date:   Thu, 13 Feb 2020 17:42:39 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com
Subject: Re: [PATCH kvm-unit-tests] s390x: unittests: Use smp parameter
Message-ID: <20200213164239.4xfxqtnexdp3ihbk@kamzik.brq.redhat.com>
References: <20200213143855.2965-1-drjones@redhat.com>
 <33d2e4cd-d43f-d93c-2958-8603e8f899e8@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33d2e4cd-d43f-d93c-2958-8603e8f899e8@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 04:08:30PM +0100, Janosch Frank wrote:
> On 2/13/20 3:38 PM, Andrew Jones wrote:
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
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
> 
> That should've been part of the VMM patchset?

I sent it separately because it's not really related. I did find it
while doing the VMM patchset though.

> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks,
drew

> 
> >  [sclp-1g]
> >  file = sclp.elf
> > 
> 
> 



