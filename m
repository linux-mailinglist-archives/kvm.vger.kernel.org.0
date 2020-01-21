Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF61436F8
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 07:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgAUGPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 01:15:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725789AbgAUGPr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 01:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579587346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=T9T91wthMRYLkB9hIkyjq+L7ysHwhnI+p2/kgg4Act0=;
        b=h6Ivolr6SGXU6NIb2JpWSSAr3nWBkeVVPwNuog7mXe8C6cBNRw8vnrCkFbQ4vBzWJDwgQw
        CmK4DBHwCgijKYwiWaRlf9zMoEBmpGX+i7300WkI3Nrc0tobCWnzlZLNUIC5PQFHswhLpw
        awthiZ4DOoG8RKY0tC06VT9NGzG17Ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-UKgwv6z1PeK-KKfn92A3ww-1; Tue, 21 Jan 2020 01:15:45 -0500
X-MC-Unique: UKgwv6z1PeK-KKfn92A3ww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3426518A6EC0;
        Tue, 21 Jan 2020 06:15:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47CC960E1C;
        Tue, 21 Jan 2020 06:15:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 3/6] s390x: lib: fix stfl wrapper asm
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-4-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <810e2bb3-42b9-2b23-6ea6-1023d496cc3b@redhat.com>
Date:   Tue, 21 Jan 2020 07:15:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200120184256.188698-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2020 19.42, Claudio Imbrenda wrote:
> the stfl wrapper in lib/s390x/asm/facility.h was lacking the "memory"
> clobber in the inline asm.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/facility.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index 5103dd4..e34dc2c 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -24,7 +24,7 @@ static inline bool test_facility(int nr)
>  
>  static inline void stfl(void)
>  {
> -	asm volatile("	stfl	0(0)\n");
> +	asm volatile("	stfl	0(0)\n" : : : "memory");
>  }
>  
>  static inline void stfle(uint8_t *fac, unsigned int len)
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

