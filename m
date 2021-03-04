Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3903F32D30A
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhCDMaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 07:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240685AbhCDM3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 07:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614860904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtAZyTPHai0C5szIeWiO0SDjbjKRItWma6gRleyofco=;
        b=VhqXOyhAw5V+W1byuBjeBelxjkS35fNvMuUbASRCLt/uevgp0gwhb1AGQGXQljPCv0HEpk
        GVpAPVaoAvkzaECRtmiyVm70ld+Q6kwxkP98ER9DdcePsn1dubN2X6agcQjloo7Hac6a7a
        gp7x3e8v41rNSbLrefx9MX6af3w9Sik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-dq38zMl-Nc-4RSXuo2S1rA-1; Thu, 04 Mar 2021 07:28:22 -0500
X-MC-Unique: dq38zMl-Nc-4RSXuo2S1rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 885C1E5768;
        Thu,  4 Mar 2021 12:28:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D387D18A69;
        Thu,  4 Mar 2021 12:28:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Remove SAVE/RESTORE_STACK
 and lowcore fpc and fprs save areas
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-8-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7154a604-9b00-88f1-7fea-d52aad19edcb@redhat.com>
Date:   Thu, 4 Mar 2021 13:28:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222085756.14396-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2021 09.57, Janosch Frank wrote:
> There are no more users. At the same time remove sw_int_fpc and
> sw_int_frps plus their asm offsets macros since they are also unused
> now.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c  |  2 --
>   lib/s390x/asm/arch_def.h |  4 +---
>   s390x/macros.S           | 29 -----------------------------
>   3 files changed, 1 insertion(+), 34 deletions(-)
> 
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 2658b59a..fbea3278 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -54,8 +54,6 @@ int main(void)
>   	OFFSET(GEN_LC_MCCK_NEW_PSW, lowcore, mcck_new_psw);
>   	OFFSET(GEN_LC_IO_NEW_PSW, lowcore, io_new_psw);
>   	OFFSET(GEN_LC_SW_INT_GRS, lowcore, sw_int_grs);
> -	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
> -	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>   	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>   	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>   	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index b8e9fe40..13e19b8a 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -103,9 +103,7 @@ struct lowcore {
>   	struct psw	io_new_psw;			/* 0x01f0 */
>   	/* sw definition: save area for registers in interrupt handlers */
>   	uint64_t	sw_int_grs[16];			/* 0x0200 */
> -	uint64_t	sw_int_fprs[16];		/* 0x0280 */
> -	uint32_t	sw_int_fpc;			/* 0x0300 */
> -	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
> +	uint8_t		pad_0x0304[0x0308 - 0x0280];	/* 0x0280 */

Please rename to pad_0x280 now.

With that fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

