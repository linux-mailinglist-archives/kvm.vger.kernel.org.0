Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632BE1F14AC
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgFHIp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:45:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58398 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726535AbgFHIp1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591605926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=U8HwGManbmXHRBlZTbUdKJ6cKj9SanWPSjNpqlqEZpA=;
        b=V1fGooPVAZ6E8NhuLosS9K7VbNKeGLcsBrkMG9WFv+l1XluuvdYEmzdz0XqU8jlqioc683
        x5OMu8fG4mPUS9BM7aNyFfJhpWZBV1NKszQrS83mcPpC3e1qJ5wagXLmiVLsrAPzJ8PgH+
        y7yIl2JMdGyTIBuTZ4Kgu1SZTt0rodc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-FqEQzr9WPaOjxy1PylhJ1Q-1; Mon, 08 Jun 2020 04:45:22 -0400
X-MC-Unique: FqEQzr9WPaOjxy1PylhJ1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82AB9872FE0;
        Mon,  8 Jun 2020 08:45:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3399119C58;
        Mon,  8 Jun 2020 08:45:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 02/12] s390x: Move control register bit
 definitions and add AFP to them
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ac5e93fa-3b52-0f28-2c62-64c31b902c33@redhat.com>
Date:   Mon, 8 Jun 2020 10:45:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> While adding the definition for the AFP-Register control bit, move all
> existing definitions for CR0 out of the C zone to the assmbler zone to
> keep the definitions concerning CR0 together.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/asm/arch_def.h | 11 ++++++-----
>  s390x/cstart64.S         |  2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 5388114..12045ff 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -19,17 +19,18 @@
>  
>  #define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
>  
> +#define CR0_EXTM_SCLP			0x0000000000000200UL
> +#define CR0_EXTM_EXTC			0x0000000000002000UL
> +#define CR0_EXTM_EMGC			0x0000000000004000UL
> +#define CR0_EXTM_MASK			0x0000000000006200UL
> +#define CR0_AFP_REG_CRTL		0x0000000000040000UL
> +
>  #ifndef __ASSEMBLER__
>  struct psw {
>  	uint64_t	mask;
>  	uint64_t	addr;
>  };
>  
> -#define CR0_EXTM_SCLP			0x0000000000000200UL
> -#define CR0_EXTM_EXTC			0x0000000000002000UL
> -#define CR0_EXTM_EMGC			0x0000000000004000UL
> -#define CR0_EXTM_MASK			0x0000000000006200UL
> -
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
>  	uint32_t	ext_int_param;			/* 0x0080 */
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 6e85635..b50c42c 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -214,4 +214,4 @@ svc_int_psw:
>  	.quad	PSW_EXCEPTION_MASK, svc_int
>  initial_cr0:
>  	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
> -	.quad	0x0000000000040000
> +	.quad	CR0_AFP_REG_CRTL
> 

Acked-by: Thomas Huth <thuth@redhat.com>

