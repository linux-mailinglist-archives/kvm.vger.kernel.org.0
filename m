Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC602F34AE
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392152AbhALPwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:52:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391892AbhALPwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 10:52:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOl/r4Dmy7eKEJNRr0aJClYLx2l8We3fAEMBkfb7rQc=;
        b=YzVA1wWcyF0CN6liX/L/IfNAKSpXAON1dG6D6NS5GEuvUbQhFEUsLwMI2GdVlxfixyET2/
        hIOBuTjLI6uF3DGABBkycX6vQAMz0VwRVO5Dly38DTz0wwL8Kiz0hxNT3M3kUu2uM8eha6
        bxO9GUQK06a9BrLE200cidy3tJtXeUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-UzZ7WKaFNGeEIgNKlgEbPQ-1; Tue, 12 Jan 2021 10:51:13 -0500
X-MC-Unique: UzZ7WKaFNGeEIgNKlgEbPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AE35809DC9;
        Tue, 12 Jan 2021 15:51:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-184.ams2.redhat.com [10.36.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 171275B4A1;
        Tue, 12 Jan 2021 15:51:06 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-10-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <72a9f9e7-5a3d-0cd3-6bfb-1b4bb3350ae3@redhat.com>
Date:   Tue, 12 Jan 2021 16:51:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112132054.49756-10-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/2021 14.20, Janosch Frank wrote:
> Let's make it clear that there is something at the end of the
> struct. The exact offset is reported by the cpu_offset member.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sclp.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index dccbaa8..395895f 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -134,7 +134,10 @@ typedef struct ReadInfo {
>   	uint8_t reserved7[134 - 128];
>   	uint8_t byte_134_diag318 : 1;
>   	uint8_t : 7;
> -	struct CPUEntry entries[0];
> +	/*
> +	 * The cpu entries follow, they start at the offset specified
> +	 * in offset_cpu.
> +	 */
>   } __attribute__((packed)) ReadInfo;
>   
>   typedef struct ReadCpuInfo {
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

