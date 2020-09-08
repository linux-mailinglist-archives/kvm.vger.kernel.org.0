Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42CF260B10
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 08:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgIHGjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 02:39:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25740 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgIHGjw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 02:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599547191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsoJDQwHbzc2FzKEG0oCLi6Fz8Nuu83Q3N2T5Y49xnI=;
        b=cd6Bvypm/lgac278swJD1bRnFeiX9vLA03Cvg2j7VQ0ZfecLTEhnI8ALPqSWz5LpjTBEMo
        MJV6ts5BVO6yuZ4dQ7OQIWRwtkRHyA5IFqqISn9SCh12l+XGblpsaIhGr09bkSVL+jtbVK
        7ifY5JcLWhWriZpaukkgivkfBztPENo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-x0lSHKwiNkWjOzRbOYRvKg-1; Tue, 08 Sep 2020 02:39:46 -0400
X-MC-Unique: x0lSHKwiNkWjOzRbOYRvKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5988800688;
        Tue,  8 Sep 2020 06:39:44 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 493B927BCD;
        Tue,  8 Sep 2020 06:39:40 +0000 (UTC)
Date:   Tue, 8 Sep 2020 08:39:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, hca@linux.ibm.com
Subject: Re: [PATCH v2 2/2] s390x: Add 3f program exception handler
Message-ID: <20200908083937.5eae4a4b.cohuck@redhat.com>
In-Reply-To: <20200907124700.10374-3-frankja@linux.ibm.com>
References: <20200907124700.10374-1-frankja@linux.ibm.com>
        <20200907124700.10374-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Sep 2020 08:47:00 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Program exception 3f (secure storage violation) can only be detected
> when the CPU is running in SIE with a format 4 state description,
> e.g. running a protected guest. Because of this and because user
> space partly controls the guest memory mapping and can trigger this
> exception, we want to send a SIGSEGV to the process running the guest
> and not panic the kernel.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> CC: <stable@vger.kernel.org> # 5.7+
> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kernel/pgm_check.S |  2 +-
>  arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

