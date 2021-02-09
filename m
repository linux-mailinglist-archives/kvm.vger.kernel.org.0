Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4083152BA
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhBIPZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 10:25:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232618AbhBIPWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 10:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612884088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bf68nln4Sgm+T5RoUMWcekZndb2iiDQ7eQPV26Yg8kY=;
        b=NEcutHbYr/Q3CnppaDr173D6AVJMwHW7Prlz+DPBg43SgOgOswWOnFcgSN6MIop9fvHctE
        KgVjHwIKsfMljosYC5VLkrbJ0QnlFQNmlt6N2VEZq1ogwyBRXGzk8lQXpK4UHkAmbpd26V
        XKItQTIg6hy1C+EyT0oJeGHyfARe/2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-NLBoHK1qN-G_nI9czj1NOA-1; Tue, 09 Feb 2021 10:21:26 -0500
X-MC-Unique: NLBoHK1qN-G_nI9czj1NOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18DDA80196C;
        Tue,  9 Feb 2021 15:21:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB9710016F6;
        Tue,  9 Feb 2021 15:21:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/4] libcflat: add SZ_1M and SZ_2G
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
 <20210209143835.1031617-2-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <bc698e30-883f-495f-c3c3-11cdffaf4152@redhat.com>
Date:   Tue, 9 Feb 2021 16:21:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209143835.1031617-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 15.38, Claudio Imbrenda wrote:
> Add SZ_1M and SZ_2G to libcflat.h
> 
> s390x needs those for large/huge pages
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/libcflat.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 460a1234..8dac0621 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -157,7 +157,9 @@ extern void setup_vm(void);
>   #define SZ_8K			(1 << 13)
>   #define SZ_16K			(1 << 14)
>   #define SZ_64K			(1 << 16)
> +#define SZ_1M			(1 << 20)
>   #define SZ_2M			(1 << 21)
>   #define SZ_1G			(1 << 30)
> +#define SZ_2G			(1ul << 31)
>   
>   #endif
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

