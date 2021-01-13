Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A972F48A5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 11:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbhAMK1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 05:27:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbhAMK1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 05:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610533551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azGscBBQYVKOXzgWJG/nFi12TMFAxWjm2VlEU7rwy3c=;
        b=GtaiWsi3ETujEHCVzsH1jq+WxNycmepObPTB/s1wO2Dr3gEIMrXPHClC4C94Gu12bO6FJZ
        KDZ0t3cSGaX66vncYAuOh972XKhuf4DsDE0wiuvRckKq826weOeII2qwxzKt9vzDt1DCiL
        fFANZ0QLgujvTHAK6C6b+PAvCl+Sp5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-eshJVyaLMRajVIDHBzUVFQ-1; Wed, 13 Jan 2021 05:25:49 -0500
X-MC-Unique: eshJVyaLMRajVIDHBzUVFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39672100C602;
        Wed, 13 Jan 2021 10:25:48 +0000 (UTC)
Received: from [10.36.114.135] (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6D371F0;
        Wed, 13 Jan 2021 10:25:46 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-10-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
Date:   Wed, 13 Jan 2021 11:25:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112132054.49756-10-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.01.21 14:20, Janosch Frank wrote:
> Let's make it clear that there is something at the end of the
> struct. The exact offset is reported by the cpu_offset member.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index dccbaa8..395895f 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -134,7 +134,10 @@ typedef struct ReadInfo {
>  	uint8_t reserved7[134 - 128];
>  	uint8_t byte_134_diag318 : 1;
>  	uint8_t : 7;
> -	struct CPUEntry entries[0];
> +	/*
> +	 * The cpu entries follow, they start at the offset specified
> +	 * in offset_cpu.
> +	 */

I mean, that's just best practice. At least when I spot "[0];" and the
end of a struct, I know what's happening.

No strong opinion about the comment, I wouldn't need it to understand it.

>  } __attribute__((packed)) ReadInfo;
>  
>  typedef struct ReadCpuInfo {
> 


-- 
Thanks,

David / dhildenb

