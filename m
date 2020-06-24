Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D258206CBE
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 08:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbgFXGmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 02:42:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388360AbgFXGme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 02:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592980953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h21zdseg/Gl0CmLWJOIbeM5J3qeW6mS2nm8/Bjpw/Eo=;
        b=V9QzDbsdL1Q0DzsO3saQHaqslXj/f9jA6Xgg83YMFmBLV46nQ8juv6Ete58eQ6tueObCqd
        nZ0v4XOK2nMmgSi3/mf/z5Z7BX6lLrN2GepxUt8u60vyMIwCGbx4Q1/0EeEVxBpgKt7xzI
        HfWgR4uZhhWPqKpnc8EyC6zamZmHaX8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-xkLXiRdZNOGLDe7ELUrxdg-1; Wed, 24 Jun 2020 02:42:31 -0400
X-MC-Unique: xkLXiRdZNOGLDe7ELUrxdg-1
Received: by mail-wm1-f70.google.com with SMTP id p24so1870864wma.4
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 23:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h21zdseg/Gl0CmLWJOIbeM5J3qeW6mS2nm8/Bjpw/Eo=;
        b=sYfgCXEH5hrBS66RY52ln3UDYduGJwZLWhTtAD4t4494z+R2ElTqrjGSNQOrW1oKlh
         tZyIVRPX7A6bDsqDsWb2BCGpa6AcQIVf2rgI/SQ50iAyBrjBGDKw2xfWGLSHoHjwxJk6
         ecBPiAHZyhwSijmdsTtAK9jNr7GJJMZ+ook769mtWhwoBKNxX1/44qaALfTnfrSQ1kd5
         U9SApgs8V6iJbaeJPDOzQA61+A6AArYhCKxYYw7VwpxQCHFSQbBAvoX7uniu5TtJGKOu
         iMsSvgE0fmi/hLsXpg+ZmitFlLz4yGCyhJ1g9HDBFVUH5dp0R8xRDfZNv868hAymoHZT
         fpsg==
X-Gm-Message-State: AOAM533qlPKGjGUyrqtqJy2IZ1V1cEn6aJg0PtLep5L/6v8De6JF35HK
        Y3nJ5B3E679z+zAkFx0Yfcz/SkvlFf7IsgX+yuyEJ1O8vEvItTsco6QDEjymmJ8ocG/3kjeH935
        ZZR5mCzagsNA+
X-Received: by 2002:a1c:24c6:: with SMTP id k189mr29426251wmk.9.1592980949921;
        Tue, 23 Jun 2020 23:42:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0ydt79pdzvcMi27pXwEmXv2a+GTwhmNRCLeaCDjsLbRRtCbzAuFKWfRh4hNhGvy5/ZrA1WA==
X-Received: by 2002:a1c:24c6:: with SMTP id k189mr29426234wmk.9.1592980949673;
        Tue, 23 Jun 2020 23:42:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v11sm7925900wmb.3.2020.06.23.23.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 23:42:29 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200623084132.36213-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <960c46c5-1b39-36b8-5401-26cd22dafc21@redhat.com>
Date:   Wed, 24 Jun 2020 08:42:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200623084132.36213-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 10:41, Nadav Amit wrote:
> Currently, the BSP's segment selectors are not initialized in 32-bit
> (cstart.S). As a result the tests implicitly rely on the segment
> selector values that are set by the BIOS. If this assumption is not
> kept, the task-switch test fails.
> 
> Fix it by initializing them.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/cstart.S | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index fa62e09..5ad70b5 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -94,6 +94,15 @@ MSR_GS_BASE = 0xc0000101
>  	wrmsr
>  .endm
>  
> +.macro setup_segments
> +	mov $0x10, %ax
> +	mov %ax, %ds
> +	mov %ax, %es
> +	mov %ax, %fs
> +	mov %ax, %gs
> +	mov %ax, %ss
> +.endm
> +
>  .globl start
>  start:
>          mov $stacktop, %esp
> @@ -109,6 +118,7 @@ start:
>  
>  prepare_32:
>          lgdtl gdt32_descr
> +	setup_segments
>  
>  	mov %cr4, %eax
>  	bts $4, %eax  // pse
> @@ -133,12 +143,7 @@ save_id:
>  	retl
>  
>  ap_start32:
> -	mov $0x10, %ax
> -	mov %ax, %ds
> -	mov %ax, %es
> -	mov %ax, %fs
> -	mov %ax, %gs
> -	mov %ax, %ss
> +	setup_segments
>  	mov $-4096, %esp
>  	lock/xaddl %esp, smp_stacktop
>  	setup_percpu_area
> 

Applied, thanks.

Paolo

