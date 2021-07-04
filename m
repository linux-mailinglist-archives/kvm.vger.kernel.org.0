Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE603BABE1
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 09:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhGDHsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 03:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhGDHsW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Jul 2021 03:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625384746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1Gb4Gbd7xkRwBneJi/dyKuYm8JJapDVv+41hhK6Pwk=;
        b=XNPY/ptiCF6HYEr10y00+65jv0TdL2C/Lqa9fMWqcPsdJRC+Pat0nlPwYzT52uptbrLJh0
        W5dBhRnlTBhgSFOMzD2cIpQM+TDbuU0U7jaPNV50Ovn82nljrPCQZwfkOmDkEMCqHQF0oX
        FmaGU2hpHiIqDuekNDrUqlkxIgrXowI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-ecrMKIJlMueCujkT-jxDRw-1; Sun, 04 Jul 2021 03:45:43 -0400
X-MC-Unique: ecrMKIJlMueCujkT-jxDRw-1
Received: by mail-wm1-f72.google.com with SMTP id 13-20020a1c010d0000b02901eca51685daso8189944wmb.3
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 00:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t1Gb4Gbd7xkRwBneJi/dyKuYm8JJapDVv+41hhK6Pwk=;
        b=DxbIG+/tOtbVsud1EOc5SKYY6VE+KbmgJBfNMv8YJFrIyW9MPpg+OAoU8D9SQL1yPu
         RFxZXACXbs0xrhFwL0XLyfC5mDENhY7NJHuSSuC1fWWRpaf5cLKnMUyrPoNf5npHuyVY
         I7op17vriFtRPvtlQqH68WfWG9r6XGA/gS1TOWeL/83annoF4BUUjEdlpaSK2j9h7tL+
         7Fcyrq3TUsfVoa6GEHTgS8Vw5O0cXHWndo+kHId8D+jCwqW05YhO4O/til+axO5Fx9r5
         z9UPLJe4mLSWofJ0+vwaqonJCSSfX3ar/+1CXgJKuX3ziRNk3lF6QUgfOG/TF4XG4PC6
         Q4yg==
X-Gm-Message-State: AOAM530JaJxxaVMjRpGWDdmEDs0oix6n1sAOEC4UrpktdDyQGX5C98a3
        1xZQGP0ep+SqwCSposi+xes+c5QoPJpjk2NUBtXk57MQOAibVmLfeVpFcu5dA+Evl+EMbpYAQsX
        Y1BQrNl0On+35
X-Received: by 2002:a7b:c107:: with SMTP id w7mr8602357wmi.107.1625384742681;
        Sun, 04 Jul 2021 00:45:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzj0Ugoz9yao1AAb5cz9Y0Weyu+UXNHEv6oa7LHhCk4CeHzMXz0V2Ud/jjCzEE7aniZbjFEJA==
X-Received: by 2002:a7b:c107:: with SMTP id w7mr8602350wmi.107.1625384742535;
        Sun, 04 Jul 2021 00:45:42 -0700 (PDT)
Received: from thuth.remote.csb (p5791d89b.dip0.t-ipconnect.de. [87.145.216.155])
        by smtp.gmail.com with ESMTPSA id r3sm6068485wrz.89.2021.07.04.00.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 00:45:42 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: sie: Fix sie.h integer types
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2cbcce3b-1311-536d-4eec-66f08e3d379b@redhat.com>
Date:   Sun, 4 Jul 2021 09:45:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629133322.19193-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/2021 15.33, Janosch Frank wrote:
> Let's only use the uint*_t types.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sie.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index b4bb78c..6ba858a 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -173,9 +173,9 @@ struct kvm_s390_sie_block {
>   } __attribute__((packed));
>   
>   struct vm_save_regs {
> -	u64 grs[16];
> -	u64 fprs[16];
> -	u32 fpc;
> +	uint64_t grs[16];
> +	uint64_t fprs[16];
> +	uint32_t fpc;
>   };
>   
>   /* We might be able to nestle all of this into the stack frame. But
> @@ -191,7 +191,7 @@ struct vm {
>   	struct kvm_s390_sie_block *sblk;
>   	struct vm_save_area save_area;
>   	/* Ptr to first guest page */
> -	u8 *guest_mem;
> +	uint8_t *guest_mem;
>   };

Yes, that's more consistent in this file.

Reviewed-by: Thomas Huth <thuth@redhat.com>

