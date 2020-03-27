Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E187B1954A1
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgC0J7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:59:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35158 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgC0J7p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 05:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585303184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bS2Q0AnXuP8bbAaX5yJ2znzWn6uZToAN6gpYIFaL5io=;
        b=Q734UtWJeHx+fsww+DbxQQPIjv7FD7COE/F3+GvNdsn8GPXs+XS6q1hH1unJJEUHJfhZsG
        XSPm6/JJWDXEU4NbvXpNHaJOcAsT9LLq7ArtT752E4z8v7pJzjmWaxyVwvlMy4ZIOdOhXJ
        cnV/hEB4IZH6i1z3m1yYtgV4wC3gtec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-PXAdTNCIOKKqqUBUFeLMDw-1; Fri, 27 Mar 2020 05:59:42 -0400
X-MC-Unique: PXAdTNCIOKKqqUBUFeLMDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AD3E800D5C;
        Fri, 27 Mar 2020 09:59:41 +0000 (UTC)
Received: from gondolin (ovpn-113-83.ams2.redhat.com [10.36.113.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CDC4A0A98;
        Fri, 27 Mar 2020 09:59:36 +0000 (UTC)
Date:   Fri, 27 Mar 2020 10:59:33 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] s390/gmap: return proper error code on ksm unsharing
Message-ID: <20200327105933.6edf41d9.cohuck@redhat.com>
In-Reply-To: <20200327092356.25171-1-borntraeger@de.ibm.com>
References: <20200327092356.25171-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Mar 2020 05:23:56 -0400
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> If a signal is pending we might return -ENOMEM instead of -EINTR.
> We should propagate the proper error during KSM unsharing.
> 
> Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
> Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/mm/gmap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

