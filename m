Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750FA15745B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBJMQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:16:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32852 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727121AbgBJMQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 07:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581337004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LfXcULfNyHDOw1vBEG5lNh0/okf6kSE3hFQB1OXob30=;
        b=ahGOtDN75OCTDNY7To9+jXyXUl/VSv++YMyfZoOtrQzD6GFOXFkBFiBno6PGSGcpttUX70
        EMB5vzNOW0uqC8ts+UyHUAOreiP7TEoQcYWypfq10O98HReXYNl/VaTqvPpOoSWD9SBXpA
        CBOrLsK4Cze+UaYXRFYdWLLSFdhybso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-sZWbJoGrP3GruwHdKX6vhA-1; Mon, 10 Feb 2020 07:16:39 -0500
X-MC-Unique: sZWbJoGrP3GruwHdKX6vhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EE04800D48;
        Mon, 10 Feb 2020 12:16:37 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CDEF5C1D4;
        Mon, 10 Feb 2020 12:16:29 +0000 (UTC)
Date:   Mon, 10 Feb 2020 13:16:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 07/35] KVM: s390: add new variants of UV CALL
Message-ID: <20200210131626.39c88be8.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-8-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-8-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:30 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This add 2 new variants of the UV CALL.

"This adds two new helper functions for doing UV CALLs."

?

> 
> The first variant handles UV CALLs that might have longer busy
> conditions or just need longer when doing partial completion. We should
> schedule when necessary.
> 
> The second variant handles UV CALLs that only need the handle but have
> no payload (e.g. destroying a VM). We can provide a simple wrapper for
> those.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 59 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

