Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED31579BA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 14:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgBJNRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 08:17:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44153 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728858AbgBJNRj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 08:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581340659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLHGSnX6dzgJDJgWHU7xx4GxTnH/PXyr8Br35B16HDA=;
        b=IkDYAnn6gpOVdQ/voy4nfs+kpS9OW2NPek1ShuVc5+2tWu5iQP0OBCCKpCKOV8Mxb2lqRX
        OuLeKyEFOqwYany8Q8I6XD8rjD1BykKACuhorhI6AEOtNChVLz+Uz4y3EA/y6UUad2uo1L
        cx/ydA2vpUgO0jpSpYHt5keXNvYXvjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-d-8Kc5zoOQaeV0rRy1IyVg-1; Mon, 10 Feb 2020 08:17:35 -0500
X-MC-Unique: d-8Kc5zoOQaeV0rRy1IyVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC5AE13F7;
        Mon, 10 Feb 2020 13:17:33 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89E395C21B;
        Mon, 10 Feb 2020 13:17:28 +0000 (UTC)
Date:   Mon, 10 Feb 2020 14:17:25 +0100
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
Subject: Re: [PATCH 34/35] KVM: s390: protvirt: Add UV cpu reset calls
Message-ID: <20200210141725.27979f51.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-35-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-35-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:57 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> For protected VMs, the VCPU resets are done by the Ultravisor, as KVM
> has no access to the VCPU registers.
> 
> As the Ultravisor will only accept a call for the reset that is
> needed, we need to fence the UV calls when chaining resets.

Last time, I suggested replacing this with

"Note that the ultravisor will only accept a call for the exact reset
that has been requested."

I still suggest that :)

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

