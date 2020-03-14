Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12ABA1859A1
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCODSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:18:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726549AbgCODSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Mar 2020 23:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584242293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1n2diAnKNcGukoSoK19lHzhyW5pkBLjvUTpDf87xZV0=;
        b=F458lGhoLQBZ4a4XyDtAPv1YTXJFudafDRjmubxvmSGjfSBArXsBE5mQBh54I50POvtSyM
        WIZQsxYYYq+2SHj+ZobZzUMnX3fh6UWXGbedzbbbevbd/Iwvh5C0g/22W8Imdyi5RrDftK
        QkCFBysZs5kiBVcXMQ9ESBmWmgQ/cpA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-uYFdx6WZMqOKq06vwZbHRA-1; Sat, 14 Mar 2020 07:14:51 -0400
X-MC-Unique: uYFdx6WZMqOKq06vwZbHRA-1
Received: by mail-wm1-f71.google.com with SMTP id r23so4111032wmn.3
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:14:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1n2diAnKNcGukoSoK19lHzhyW5pkBLjvUTpDf87xZV0=;
        b=BDe+HfJk9ZpSBN1ArAPL+RVF1GZyjTy3Fjc4AhSiQ59EQvoeuW9s8jFzIMMu9i3SsQ
         EjiTEITHjRNUNa4VVSdzULTqfhHVtO00kjYWmwKmNHUIBZMZ1VlrLjgtYDIuezwt7KI4
         Dqgpgp3p4/tS2a+iVYr4NhXjkrPoFkZhWmqOOvXssDb+eEOif7skJxAZsNCpSbiJBgbe
         L5+ljXtWVWqs2/3h1wARqPZHPoTlOKOJwOv++D6f6N0KMkcdA6RdUysj6QI25F4EAQjL
         DdXK5oZMEQoPshgPQaPco99At8R2PSLwJRhlrOeyM5/MTQpM/kIyjVJJDTTowu6gMC03
         EbWw==
X-Gm-Message-State: ANhLgQ2Io12JUqVgXthVvJioaEVdNedIea2AXGU/5X0UEUIUhj6iFiih
        vQ2TBP79XugZ5tlrp5So6L7057Ilvmi7Z2Xu2a/advB4cuk6dStaprxN0aZQ0GV7+lMVW39Kw83
        uyj+RUWqDRg7l
X-Received: by 2002:a5d:5702:: with SMTP id a2mr23067717wrv.17.1584184490064;
        Sat, 14 Mar 2020 04:14:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvGYfQStibYQrLoxdyoqvribe4AwCLNZFvlsNJmixXJp7cMnLyxj1EgeAYEH9jgYxGdwgWEaQ==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr23067702wrv.17.1584184489818;
        Sat, 14 Mar 2020 04:14:49 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id v15sm17933290wrm.32.2020.03.14.04.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:14:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Consolidate nested MTF checks to helper
 function
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
References: <20200224202744.221487-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c10065c-3013-9063-90a9-b87b86bc1926@redhat.com>
Date:   Sat, 14 Mar 2020 12:14:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224202744.221487-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 21:27, Oliver Upton wrote:
> commit 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing
> instruction emulation") introduced a helper to check the MTF
> VM-execution control in vmcs12. Change pre-existing check in
> nested_vmx_exit_reflected() to instead use the helper.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e920d7834d73..b9caad70ac7c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5627,7 +5627,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  	case EXIT_REASON_MWAIT_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
>  	case EXIT_REASON_MONITOR_TRAP_FLAG:
> -		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
> +		return nested_cpu_has_mtf(vmcs12);
>  	case EXIT_REASON_MONITOR_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
>  	case EXIT_REASON_PAUSE_INSTRUCTION:
> 

Queued, thanks.

Paolo

