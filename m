Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14B114F9A5
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgBASxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:53:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBASxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:53:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580583190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ynlbcXZn/fV5UG3J/76c5au0G0a+9DOQ/IKDe2dfkAo=;
        b=OHhLIgWCmEPGu6RNE6oza+HbFNIWI9JeqXX6MEOQi88Lh89ci7VWxU+xj/iSwnWBWaueD3
        ZpVY9fL07AeOLXUgR4/qwW22xOJnmIVcy9YddpuzFLnJj+I9F2U5lxLDtEzOcg7MI0zjwp
        kxys8q3ADpPFAbWw2iNWNazBPt095l8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-Rr3ImzIBPuSaMD7uug9DYQ-1; Sat, 01 Feb 2020 13:53:08 -0500
X-MC-Unique: Rr3ImzIBPuSaMD7uug9DYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 371D8107ACC7;
        Sat,  1 Feb 2020 18:53:07 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-27.ams2.redhat.com [10.36.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C6968642B;
        Sat,  1 Feb 2020 18:53:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 2/7] s390x: smp: Fix ecall and emcall
 report strings
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200201152851.82867-1-frankja@linux.ibm.com>
 <20200201152851.82867-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <15009dae-26eb-e6f6-25c6-c1dc9f0ee170@redhat.com>
Date:   Sat, 1 Feb 2020 19:53:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200201152851.82867-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2020 16.28, Janosch Frank wrote:
> Instead of "smp: ecall: ecall" we now get "smp: ecall: received".
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index e37eb56..93a9594 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -125,7 +125,7 @@ static void ecall(void)
>  	load_psw_mask(mask);
>  	set_flag(1);
>  	while (lc->ext_int_code != 0x1202) { mb(); }
> -	report(1, "ecall");
> +	report(1, "received");
>  	set_flag(1);
>  }
>  
> @@ -160,7 +160,7 @@ static void emcall(void)
>  	load_psw_mask(mask);
>  	set_flag(1);
>  	while (lc->ext_int_code != 0x1201) { mb(); }
> -	report(1, "ecall");
> +	report(1, "received");
>  	set_flag(1);
>  }

Reviewed-by: Thomas Huth <thuth@redhat.com>

