Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3323393314
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 18:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhE0QCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 12:02:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234874AbhE0QC3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 12:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622131256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K1rwglUCDYFJDhYemb58TKXBmWarWvKgb3mpajWGZeU=;
        b=fEgewxjIvdtyvJ1uPS1C9JVz2rC73F2sxDT5hRXG80rr2kR7hIB+aINKDP0uAkMkYeUj+n
        0npYqFqw9PAQHNkU3Wf4IWl8zksCTMXHafaQN270OvLHd41ghcCE4U1IxzqjOmvyPHMFBs
        Ju2IIXVJLRM2L9Sft9UFiSikQM7Vlpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-dy58I4OTPjKUKPDin4IYiw-1; Thu, 27 May 2021 12:00:45 -0400
X-MC-Unique: dy58I4OTPjKUKPDin4IYiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B29DC106BB43;
        Thu, 27 May 2021 16:00:41 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-46.ams2.redhat.com [10.36.113.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84E5310016F8;
        Thu, 27 May 2021 16:00:40 +0000 (UTC)
Date:   Thu, 27 May 2021 18:00:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: b4 usage
Message-ID: <20210527180009.3311781a.cohuck@redhat.com>
In-Reply-To: <your-ad-here.call-01622129150-ext-7521@work.hours>
References: <20210520113450.267893-1-cohuck@redhat.com>
        <your-ad-here.call-01622068380-ext-9894@work.hours>
        <20210527083313.0f5b9553.cohuck@redhat.com>
        <your-ad-here.call-01622129150-ext-7521@work.hours>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 May 2021 17:25:50 +0200
Vasily Gorbik <gor@linux.ibm.com> wrote:

> > > BTW, linux-s390@vger.kernel.org is now archived on lore and we started  
> > 
> > Oh, nice.
> >   
> > > using b4 (https://git.kernel.org/pub/scm/utils/b4/b4.git) to pick up
> > > changes. Besides all other features, it can convert Message-Id: to Link:  
> > 
> > I've been using b4 to pick patches (Linux and especially QEMU) for
> > quite some time now, but never felt the need to convert Message-Id: to
> > Link:. If you prefer the Link: format, I can certainly start using that
> > for kernel patches.  
> 
> It's up to you, whatever you prefer. Just wanted to point out that this is
> possible now. I personally just follow what seems to be a more common practice.
> 
> $ git log --grep=Link:.*lore --oneline linux/master | wc -l
> 53522
> $ git log --grep=Message-Id: --oneline linux/master | wc -l
> 1666

For QEMU, it's the other way around :)

But I'll try to use Link: for kernel patches, unless I forget.

