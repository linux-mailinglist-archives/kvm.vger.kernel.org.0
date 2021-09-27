Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C05B419D2C
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 19:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhI0RpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 13:45:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237632AbhI0RpU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 13:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632764621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56cp6DuOx03UDlPp5wTq9ZqnaoI7a1YZthbcSmDRL7g=;
        b=ehbkhVMGRdSU8TFLYsQ4qvHJh0blnTK9kftwVUsPGX4uMpSC0GtDv3InSBYXHgrWGAxRMk
        WAN2/jCpyaqbVdVptN+I3p9nRYAw4a+Z6jtpU502cw3kSKo12YxarTBlu0aN2OkE8fcDCH
        spYRpNRqMUQV19prhQNwiaknadhGylo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-E6DRafA1NSi_bsI6ER90Nw-1; Mon, 27 Sep 2021 13:43:40 -0400
X-MC-Unique: E6DRafA1NSi_bsI6ER90Nw-1
Received: by mail-wm1-f69.google.com with SMTP id r66-20020a1c4445000000b0030cf0c97157so555524wma.1
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 10:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=56cp6DuOx03UDlPp5wTq9ZqnaoI7a1YZthbcSmDRL7g=;
        b=HGMhBkAy+kI+slLVMAPrBM22fHnIbZrhWzaYMK7/2HdWMB+RdrZUe4XfzchHh3VMtG
         N/3yhZmHHH2f7OGSyB69n3hPR+pFwdynPo2vXfwy3gqCqQ+uK0Ga10uaPKLFiEE1yk/l
         dTovMInHRhMYuD4n8SWsbyWOJZdXo7FHPQEPdnvCd9p6d97IC85FpfzCQeWqfoEsIxBz
         v1U5k5RDClBTTNv8Xg++ZEGIWRynhLgZWExl2jYzIM99DWwmHm2mcnVPDAXzrLIXzCRQ
         BakOfxjTJUJvsJ+R28PB7t6fsFGQpmlNXF10zF8lavYH+xLF+wIOBWtxiiPuWloU0PbU
         Fxmg==
X-Gm-Message-State: AOAM530xekbLdksvWVM01kM4IgYZaoi1Wnkjda1eH5bqxG2pSC29Cb+x
        U7SRQcgDFBxOT66PKpg/JLRot+gnVIKGBLreePTBL9qCahmECuVl8Cf8ngTXlzEhg4va/plfhbr
        XDnPuNk0c+2q0
X-Received: by 2002:a1c:7515:: with SMTP id o21mr352390wmc.76.1632764619121;
        Mon, 27 Sep 2021 10:43:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdt4YCm5ni07STcm76GfQh9gIfBSpYs/TXpV0Iqj2OntD1J2Cw0IgeSRk1XOznWZQUpTpUZw==
X-Received: by 2002:a1c:7515:: with SMTP id o21mr352376wmc.76.1632764618974;
        Mon, 27 Sep 2021 10:43:38 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id a25sm158782wmj.34.2021.09.27.10.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 10:43:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 6/9] lib: s390x: Print PGM code as hex
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <dc7ea29a-62d9-b8d8-e3df-e71393f83beb@redhat.com>
Date:   Mon, 27 Sep 2021 19:43:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922071811.1913-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2021 09.18, Janosch Frank wrote:
> We have them defined as hex constants in lib/s390x/asm/arch_def.h so
> why not print them as hex values?
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/interrupt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 126d4c0a..27d3b767 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -169,7 +169,7 @@ static void print_pgm_info(struct stack_frame_int *stack)
>   		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
>   
>   	printf("\n");
> -	printf("Unexpected program interrupt %s: %d on cpu %d at %#lx, ilen %d\n",
> +	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
>   	       in_sie ? "in SIE" : "",
>   	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
>   	print_int_regs(stack);
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

