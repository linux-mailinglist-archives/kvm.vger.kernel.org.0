Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB42C0FD6
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 17:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgKWQJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 11:09:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732063AbgKWQJL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 11:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606147750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vudEG5bLsot0T0VPkaODIJMcaiPIyeTC0NncFZ09Eyo=;
        b=IP7Z3Di1EfIhF6XRWByVcFRKmGDEv8wMbsG02V8L6znmi77wMp84QVuSplitdf2+VWUoAd
        /m6AfBWjlEKAKukNfmXObZTDWWb+mKUDzTXGUOzZrEIJEhgvZBTFFKC33Oz3juixdrnMOc
        wpgOjpQQTrVEQk0udGSqV5PhZbsDDXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-JqoY7vdGNFOHnuyf7fplsg-1; Mon, 23 Nov 2020 11:09:05 -0500
X-MC-Unique: JqoY7vdGNFOHnuyf7fplsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84A4A800050;
        Mon, 23 Nov 2020 16:09:04 +0000 (UTC)
Received: from gondolin (ovpn-113-104.ams2.redhat.com [10.36.113.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A2AE60864;
        Mon, 23 Nov 2020 16:08:59 +0000 (UTC)
Date:   Mon, 23 Nov 2020 17:08:57 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH 1/2] KVM: s390: Add memcg accounting to KVM allocations
Message-ID: <20201123170857.1218d5e7.cohuck@redhat.com>
In-Reply-To: <20201117151023.424575-2-borntraeger@de.ibm.com>
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
        <20201117151023.424575-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 16:10:22 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Almost all kvm allocations in the s390x KVM code can be attributed to
> process that triggers the allocation (in other words, no global

s/process/the process/

> allocation for other guests). This will help the memcg controller to do

s/do/make/

> the right decisions.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/kvm/guestdbg.c  |  8 ++++----
>  arch/s390/kvm/intercept.c |  2 +-
>  arch/s390/kvm/interrupt.c | 10 +++++-----
>  arch/s390/kvm/kvm-s390.c  | 20 ++++++++++----------
>  arch/s390/kvm/priv.c      |  4 ++--
>  arch/s390/kvm/pv.c        |  6 +++---
>  arch/s390/kvm/vsie.c      |  4 ++--
>  7 files changed, 27 insertions(+), 27 deletions(-)

Didn't do a deep review, but looks reasonable.

Acked-by: Cornelia Huck <cohuck@redhat.com>

