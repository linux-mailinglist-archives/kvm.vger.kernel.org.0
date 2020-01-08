Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ECA1349A9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgAHRqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:46:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgAHRqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 12:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4VZx0As0ZHiXTxgHXESIjy6Uh0rww0LXaVy0vAdM7A=;
        b=bQ67OxV9BtfKHORNCBCaJh0gSV9TvZyOh+yWaY6o7tbp6TyT/pGhNgWFmz6JT7dOfad3SI
        65hvewrdqqM/wQqE4WtVbRHNsSpc4GlsJk0dIx1s/1U9XbTD9+0jt9o8UoYE6+Yj4HnNLd
        Ox21bzCGDns4AXnjtS9bCrluaXJVUUY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-WcINaXGUOp2EvCLYklgOSQ-1; Wed, 08 Jan 2020 12:46:03 -0500
X-MC-Unique: WcINaXGUOp2EvCLYklgOSQ-1
Received: by mail-wm1-f70.google.com with SMTP id w205so1108029wmb.5
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4VZx0As0ZHiXTxgHXESIjy6Uh0rww0LXaVy0vAdM7A=;
        b=BGnMiC5g6ryJb6T47M+3QJu2KP4J9ruWHc6Bis6SHAWhv6TXUr2RYodW0J2w2IAefa
         R1KNWq6Oz5U5ugA1wV+JEG5oMyJBN26g5nSk6LeSS3sdDNr9Dw+JFs2jaqEm4pq+XjA3
         23YzZLXXsvv7gCUiGWy0o9DatCboVHua8TYgSdl+DbMtfLayKhVFXiPcok0U/j7QGpWN
         ZUWHpKhk210HRAHRwO+UKvbB7FlqBF8xmTeZb+DlAU+Qrzv8kzWEhZ9CCBCVWpVC5dqW
         Pwy9d6MBcpDMWcu85rqi5+r/6ZHt9wtnzAL973Qg03IacXilsMNksdCqjtW18VdrpvU6
         Vq3A==
X-Gm-Message-State: APjAAAV8m63n2FA80kI1l/ZC4WSQ47pTw4X6/po/zurzkgImpMXkPmUn
        +0k48yPD+ZFSogGDg3F6UkGREKDRoc9aL9T0nOw96arL7ZwT151q8g60OsK0tT0KtmG+OcMwjwF
        Dfo+IUifx8/YS
X-Received: by 2002:adf:81c2:: with SMTP id 60mr5796483wra.8.1578505562630;
        Wed, 08 Jan 2020 09:46:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUDnQgu7gDBsXLItppqiWGQNzHgByvlYXbyrUB8070jJES4YdmovQ+cTSX6O4KilpgStcP2g==
X-Received: by 2002:adf:81c2:: with SMTP id 60mr5796460wra.8.1578505562427;
        Wed, 08 Jan 2020 09:46:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id p17sm5063893wrx.20.2020.01.08.09.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:46:01 -0800 (PST)
Subject: Re: [PATCH RESEND v2 02/17] KVM: X86: Change parameter for
 fast_page_fault tracepoint
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-3-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9eae2e6e-b767-0471-b913-ea6c3ad00ae8@redhat.com>
Date:   Wed, 8 Jan 2020 18:46:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-3-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> It would be clearer to dump the return value to know easily on whether
> did we go through the fast path for handling current page fault.
> Remove the old two last parameters because after all the old/new sptes
> were dumped in the same line.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/mmutrace.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> index 7ca8831c7d1a..09bdc5c91650 100644
> --- a/arch/x86/kvm/mmutrace.h
> +++ b/arch/x86/kvm/mmutrace.h
> @@ -244,9 +244,6 @@ TRACE_EVENT(
>  		  __entry->access)
>  );
>  
> -#define __spte_satisfied(__spte)				\
> -	(__entry->retry && is_writable_pte(__entry->__spte))
> -
>  TRACE_EVENT(
>  	fast_page_fault,
>  	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
> @@ -274,12 +271,10 @@ TRACE_EVENT(
>  	),
>  
>  	TP_printk("vcpu %d gva %lx error_code %s sptep %p old %#llx"
> -		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
> +		  " new %llx ret %d", __entry->vcpu_id,
>  		  __entry->gva, __print_flags(__entry->error_code, "|",
>  		  kvm_mmu_trace_pferr_flags), __entry->sptep,
> -		  __entry->old_spte, __entry->new_spte,
> -		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
> -	)
> +		  __entry->old_spte, __entry->new_spte, __entry->retry)
>  );
>  
>  TRACE_EVENT(
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

