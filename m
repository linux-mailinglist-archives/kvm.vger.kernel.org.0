Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB543342F7
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 17:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCJQWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 11:22:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229790AbhCJQW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 11:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615393345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVPdOUNaxxpVJfSx6BSqcYWZ03ZhUTF6iZsIeSCKXsM=;
        b=QhORrZ+Qn8Te6byu54xWwqVUBhlJOkubA4GMODJHv0+ip8ouxeFcIVoRYGiy6eWfvzpEzl
        Z+jOu2oIyYQXPQHSAcoLdmULgdfSBSbu1UOVcc/Pxkg9XquoHalFzHAHSpY2F79I7iXlmm
        z86emLmgnnfgah1rFzCjYyQJLqh/aXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-dImOJa_CPEOS7Q_wm5hXdQ-1; Wed, 10 Mar 2021 11:22:21 -0500
X-MC-Unique: dImOJa_CPEOS7Q_wm5hXdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67579108BD07;
        Wed, 10 Mar 2021 16:22:20 +0000 (UTC)
Received: from gondolin (ovpn-113-99.ams2.redhat.com [10.36.113.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4D3460C05;
        Wed, 10 Mar 2021 16:22:11 +0000 (UTC)
Date:   Wed, 10 Mar 2021 17:22:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 0/2] Get rid of legacy_s390_alloc() and
 phys_mem_set_alloc()
Message-ID: <20210310172208.02f8b988.cohuck@redhat.com>
In-Reply-To: <20210303130916.22553-1-david@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Thanks, applied.

