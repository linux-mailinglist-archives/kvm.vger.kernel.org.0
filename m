Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14321E63BC
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 16:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391117AbgE1OXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 10:23:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56257 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391035AbgE1OWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 10:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590675771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJAE3W4i6ShVxeRfUH/bQwuRjs3nBOGoAWqm9myFCPw=;
        b=dz6NPnhJPKteYo/RPAU4/5RHF+imHDWXnb+fIqvVw0ARkw9kW9bkuk7DaUpPAX5eeX9B+T
        N2dRIOJnGQzL7H4+5Uob0hpsY8wlT55RqmmIQnz9FoBnqxqr4Ovvh3npRWuUKlRrtK37MM
        r2ELxk1Z46YoDpnLKfsK6RStTiUDDQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Akt7k8GuMKaJnQE7t8yySw-1; Thu, 28 May 2020 10:22:49 -0400
X-MC-Unique: Akt7k8GuMKaJnQE7t8yySw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A2F1005512;
        Thu, 28 May 2020 14:22:47 +0000 (UTC)
Received: from gondolin (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2132860C05;
        Thu, 28 May 2020 14:22:45 +0000 (UTC)
Date:   Thu, 28 May 2020 16:22:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 00/10] vfio-ccw patches for 5.8
Message-ID: <20200528162243.7ee3a352.cohuck@redhat.com>
In-Reply-To: <your-ad-here.call-01590669751-ext-3257@work.hours>
References: <20200525094115.222299-1-cohuck@redhat.com>
        <your-ad-here.call-01590669751-ext-3257@work.hours>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 May 2020 14:42:31 +0200
Vasily Gorbik <gor@linux.ibm.com> wrote:

> On Mon, May 25, 2020 at 11:41:05AM +0200, Cornelia Huck wrote:
> > The following changes since commit 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
> > 
> >   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200525  
> 
> Hello Conny,
> 
> s390/features is based on v5.7-rc2 rather than on v5.7-rc3 as your
> tags/vfio-ccw-20200525. Are there any pre-requisites in between for
> vfio-ccw changes? It does cleanly rebase onto v5.7-rc2.

There shouldn't be anything.

> 
> Could you please rebase onto v5.7-rc2 or s390/features if that's possible?

Ugh. Isn't there any way to avoid doing that?

