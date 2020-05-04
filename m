Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0A1C3FF7
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgEDQdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:33:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23980 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgEDQdt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hEpx8ijsNtOVF5thD83WQ9QtmFhV5BTDZrsTGbIGCpY=;
        b=QBYz8iGk9KniTrI0OChqrgb4p08cELOKyy8Iqj29zQ4PkqC/xg7zjAT6vxql4UxcVwk8VD
        mCYds8K2pW09wYRucM5mgDTdYR6ose/Bzs0QdFnMGoBfU+EumPXlxD2O/ztgZIEtN/5102
        tEb5SUFWuoUG4gPGidXZHxrZTNUt/SM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-xsktki65NT2_6bd62r9Mgg-1; Mon, 04 May 2020 12:33:46 -0400
X-MC-Unique: xsktki65NT2_6bd62r9Mgg-1
Received: by mail-wr1-f72.google.com with SMTP id q13so2201573wrn.14
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hEpx8ijsNtOVF5thD83WQ9QtmFhV5BTDZrsTGbIGCpY=;
        b=U4Ap6gfH3QG4fxbsmLEPPpJxnDw46mCmeaewN7uKE0uj1eu57U1B14FGk1/+yVo28p
         P+VnbuHkXituV9O7PSlfr5mhl25IKG86Nb8dqHvb6Jwamld+mNc3WTRUDDQZoptd34R+
         enAjGrqHOoOK0zF3sqyp6gteCbrMz58dtaYa8mQnW/gb/uY0AWz6YrfTXnNyLUWJdiXA
         ev6Afg/eZSgSsYTU9L8Z6CJw2kY/k/L7oPRLvqzr1t3o6fjnBreaYEnMfKXIFj5OaPS5
         UzVlf2ns8Btx+RyBXpjtc+WT+MhClWF9e79fEl5ycGISHqoynjfG6M7Un8a68qkWIGaU
         jllQ==
X-Gm-Message-State: AGi0PuYbGTupPzR2NlWpvoq19OYGrR5DDr9PvUlXpfS7B4Jmyif71a1m
        qC2jV8ol2TsXxWwr3xC+IGQNJMDiiLGYrQUnh9KnSkvBFr3J1c/CG5uhrvj72btJF+7NazktDWC
        Hd64a+sc1NQGt
X-Received: by 2002:adf:bb4e:: with SMTP id x14mr114213wrg.63.1588610025008;
        Mon, 04 May 2020 09:33:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLp5LlkN9O7rjWacff63es870g2BhlZ3YY8RkJhwBJnJLHFQa7k5VbWZXNuRl6jWlpqc+eC/A==
X-Received: by 2002:adf:bb4e:: with SMTP id x14mr114198wrg.63.1588610024831;
        Mon, 04 May 2020 09:33:44 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id h16sm21663437wrw.36.2020.05.04.09.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:33:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: ioapic: Run physical destination mode
 test iff cpu_count() > 1
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>
References: <20200423195050.26310-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ca7f71b1-82aa-53aa-fe81-2f61e3407a82@redhat.com>
Date:   Mon, 4 May 2020 18:33:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423195050.26310-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 21:50, Sean Christopherson wrote:
> Make test_ioapic_physical_destination_mode() depending on having at
> least two CPUs as it sets ->dest_id to '1', i.e. expects CPU0 and CPU1
> to exist.  This analysis is backed up by the fact that the test was
> originally gated by cpu_count() > 1.
> 
> Fixes: dcf27dc5b5499 ("x86: Fix the logical destination mode test")
> Cc: Nitesh Narayan Lal <nitesh@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/ioapic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 3106531..f315e4b 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -504,7 +504,8 @@ int main(void)
>  	test_ioapic_level_tmr(true);
>  	test_ioapic_edge_tmr(true);
>  
> -	test_ioapic_physical_destination_mode();
> +	if (cpu_count() > 1)
> +		test_ioapic_physical_destination_mode();
>  	if (cpu_count() > 3)
>  		test_ioapic_logical_destination_mode();
>  
> 

Queued, thanks.

Paolo

