Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C059D2314B0
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgG1VgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:36:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:29139 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729322AbgG1VgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595972161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hFN4b/j5jaO54ZEzhfUAuV3x8q451AKAzH67obVUqYg=;
        b=Crgl95u+x3r3N7wzEtTR3vJE5qHXYIhz7ETrYjZt4Y/sHqU7UZQDZq1eV7HAjyeSnDKzpq
        Zd57uqdHYMXhVBHNkmlDMujqpJRefZ5TNS1Xm8kPEdAK2n4V+zsewwxtHu0O60XUzSL7QY
        X9Hs22gEd8SWdRMzHNyO4Uo8M1SbzD4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-z_unr054P7KYIbBmz9HOGw-1; Tue, 28 Jul 2020 17:29:54 -0400
X-MC-Unique: z_unr054P7KYIbBmz9HOGw-1
Received: by mail-wm1-f69.google.com with SMTP id h205so317899wmf.0
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:29:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hFN4b/j5jaO54ZEzhfUAuV3x8q451AKAzH67obVUqYg=;
        b=I9CCj0pFlIqfyyN67MPzMyjqZ17y3liE7uDazRH8GJ5U9r9ZGQPLSvzp45CzR385Xe
         HTmIlBu02H7cFAEFHtOEsFfk1dav9frDB8/ReUToVBSeleRsZ0wgFhg5FaAY38l1dqXR
         IHzqilFvwLv3QPbzCchkb/fN51Mqje2jcsJD8ShPPQh4vDNhbj8LVndZHL1ri0AjgfSv
         71CUNbGgsVi6wYMSwKmpxQuLscqkaKd5QXGDzf0x46FN95b6CfifaI1Iv5UD3FOC+14A
         Aeg++ZTFIyKPjbc12Vacq4WXsyoidmt5ZI4cspt3v4Kz5rooSUKKdvD5R6JA37DxnkFr
         24WQ==
X-Gm-Message-State: AOAM531prCJgTPBV0vKcmFqgfMbkO4M1neAP5YqabjJEpN3U8RyNTjby
        6ItzSYFXjMmIMcHAykOsHR63oNHluRCaVGxfirqy7um0i3QIkhtgMoV/3S7iv+NlTIVCU+7WBfO
        d4zeWz7PTK9Ii
X-Received: by 2002:a1c:660a:: with SMTP id a10mr5333234wmc.115.1595971792867;
        Tue, 28 Jul 2020 14:29:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyv8RtkRgVb2UrBMPKjab2gkzX6HJ3ubcR3IAT+JjmgvuK2/IJZPY4tXrBYzqe1V8fNfHM1GA==
X-Received: by 2002:a1c:660a:: with SMTP id a10mr5333161wmc.115.1595971791156;
        Tue, 28 Jul 2020 14:29:51 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id t17sm192845wmj.34.2020.07.28.14.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:29:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] cstart64: do not assume CR4 should be zero
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
References: <20200715205235.13113-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f33c4d6b-016f-40f6-8d05-2816b2c766c6@redhat.com>
Date:   Tue, 28 Jul 2020 23:29:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715205235.13113-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/20 22:52, Sean Christopherson wrote:
> Explicitly zero cr4 in prepare_64() instead of "zeroing" it in the
> common enter_long_mode().  Clobbering cr4 in enter_long_mode() breaks
> switch_to_5level(), which sets cr4.LA57 before calling enter_long_mode()
> and obviously expects cr4 to be preserved.
> 
> Fixes: d86ef58 ("cstart: do not assume CR4 starts as zero")
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Two lines of code, two bugs.  I'm pretty sure Paolo should win some kind
> of award. :-D

Two lines of code, two bugs immediately before disappearing for two
weeks.  2^3 paper bags...

Paolo

>  x86/cstart64.S | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 3ae98d3..2d16688 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -175,8 +175,12 @@ prepare_64:
>  	lgdt gdt64_desc
>  	setup_segments
>  
> +	xor %eax, %eax
> +	mov %eax, %cr4
> +
>  enter_long_mode:
> -	mov $(1 << 5), %eax // pae
> +	mov %cr4, %eax
> +	bts $5, %eax  // pae
>  	mov %eax, %cr4
>  
>  	mov pt_root, %eax
> 

