Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CB32D474
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbhCDNq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235304AbhCDNqi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614865512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBMjPB64qBZBTU4tzpqO9GPtoxtPscgOLp3NFDBAY0c=;
        b=OgTxkXHCsmIYa239u4kXf+VNHZwInxqrVQrUPAvHf/I4Coks/Z02NyMxVgNM6OJOFbwZgS
        jQvx588jj0+A9mEViQbidwoJ+UOYXAiUNJERWSeK/Xq/4cYRL5OYyAFl9eoUA+5a+198Pr
        h22bu1WcvyTNHZzaaJcsLvhyOBirX6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Zjhl0zr6MJOaSXhNAP85tw-1; Thu, 04 Mar 2021 08:45:11 -0500
X-MC-Unique: Zjhl0zr6MJOaSXhNAP85tw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4518C1B18BCA;
        Thu,  4 Mar 2021 13:44:55 +0000 (UTC)
Received: from gondolin (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CE1319D7C;
        Thu,  4 Mar 2021 13:44:12 +0000 (UTC)
Date:   Thu, 4 Mar 2021 14:44:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 0/2] Get rid of legacy_s390_alloc() and
 phys_mem_set_alloc()
Message-ID: <20210304144409.78d5db49.cohuck@redhat.com>
In-Reply-To: <20210303130916.22553-1-david@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  3 Mar 2021 14:09:14 +0100
David Hildenbrand <david@redhat.com> wrote:

> Let's finally get rid of the alternative allocation function. Outcome of
> a discussion in:
>     https://lkml.kernel.org/r/20210303123517.04729c1e.cohuck@redhat.com
> 
> David Hildenbrand (2):
>   s390x/kvm: Get rid of legacy_s390_alloc()
>   exec: Get rid of phys_mem_set_alloc()
> 
>  include/sysemu/kvm.h |  4 ----
>  softmmu/physmem.c    | 36 +++---------------------------------
>  target/s390x/kvm.c   | 43 +++++--------------------------------------
>  3 files changed, 8 insertions(+), 75 deletions(-)
> 

Ok, who is going to queue this?

I'd be happy to take this through the s390x tree, if I get an ack from
Paolo :)

