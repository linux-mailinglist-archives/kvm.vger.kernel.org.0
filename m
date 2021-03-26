Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89E34AD2D
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCZRNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhCZRN3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYX3Pr+wY1U0fuqj3VKN1uau5ruRe+oCNWNth4NlHBE=;
        b=UoNes85ei6For+SoxPoNwPgdqmh2luxrBpbK0eIhqBuiijmDghwaKJGZyfVet5s0dAooIu
        /WLVgCGzgEKLOi8ByvoFc94NWA2NieRxlJA+hPryPZVAjvDrLc4OYv+8lwXUIsY/ybv15G
        ZB5XTKEKO3NQfOX4R86wqdI2fz/Vmz4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-wV3N8XFzOhSxUF9-XqEBtQ-1; Fri, 26 Mar 2021 13:13:26 -0400
X-MC-Unique: wV3N8XFzOhSxUF9-XqEBtQ-1
Received: by mail-ej1-f71.google.com with SMTP id rl7so4344030ejb.16
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uYX3Pr+wY1U0fuqj3VKN1uau5ruRe+oCNWNth4NlHBE=;
        b=kdzQOiFsXGa8ek8nzWJHahxdpbyBkCXAjlSnyNbSuSi2CxKIUv4XV696Pl4MNMAXq2
         r4fEd6H7dNopYIv1K4laCFAUwXrsdP1T8ABucSRxl2JVmtHIT01YGdabJDFyD31WxFcu
         Nkz1sqZX5swK4dJtpN6do5R0YxqoJm51Cn3IgBjcMYTt45Sn6wRa0UOGUK9iyR1UrCdh
         KaW/QVanBaiPm4I9E39t1GIuvF5rJVv29BcxImRX8NQur6S4gHNAOUWx1S8fThVPAFXu
         rki2vUVB8FbEI+Ztvl3N9MQRvoVnFf7/Pz2VPTm4SJwA+uPffOt5oEO4AsFsR68kdHsL
         /TOQ==
X-Gm-Message-State: AOAM530qxk/PZdoAFj5CQr07Q0a6dQl3M4kRs3vhLvpTtq4DGKgO/kTo
        dUxeKeKCYXXZv/9JGUG06mc28Tt6Rlp+L64Vub5TPY14wdzwSHxQ/paTPJT79odeQc3KNSmFE9C
        lNiv1x2I6nCbi
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr16033510ejb.170.1616778805442;
        Fri, 26 Mar 2021 10:13:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvHb1xJA6IsY9jNQ4z7xuRprpd/9Dmex3UEJxmIg/KfdFHV+3q3yw2+p68OcaDNorC5iwIDA==
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr16033490ejb.170.1616778805245;
        Fri, 26 Mar 2021 10:13:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gn19sm3918920ejc.4.2021.03.26.10.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:13:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: clean up the unused argument
To:     lihaiwei.kernel@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
References: <20210313051032.4171-1-lihaiwei.kernel@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc2f81a4-5e71-bdab-5e70-836c813ea91f@redhat.com>
Date:   Fri, 26 Mar 2021 18:13:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210313051032.4171-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/21 06:10, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> kvm_msr_ignored_check function never uses vcpu argument. Clean up the
> function and invokers.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)

Queued, thanks.

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 012d5df..27e9ee8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -271,8 +271,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>    * When called, it means the previous get/set msr reached an invalid msr.
>    * Return true if we want to ignore/silent this failed msr access.
>    */
> -static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> -				  u64 data, bool write)
> +static bool kvm_msr_ignored_check(u32 msr, u64 data, bool write)
>   {
>   	const char *op = write ? "wrmsr" : "rdmsr";
>   
> @@ -1447,7 +1446,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   	if (r == KVM_MSR_RET_INVALID) {
>   		/* Unconditionally clear the output for simplicity */
>   		*data = 0;
> -		if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +		if (kvm_msr_ignored_check(index, 0, false))
>   			r = 0;
>   	}
>   
> @@ -1613,7 +1612,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
>   	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
>   
>   	if (ret == KVM_MSR_RET_INVALID)
> -		if (kvm_msr_ignored_check(vcpu, index, data, true))
> +		if (kvm_msr_ignored_check(index, data, true))
>   			ret = 0;
>   
>   	return ret;
> @@ -1651,7 +1650,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>   	if (ret == KVM_MSR_RET_INVALID) {
>   		/* Unconditionally clear *data for simplicity */
>   		*data = 0;
> -		if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +		if (kvm_msr_ignored_check(index, 0, false))
>   			ret = 0;
>   	}
>   
> 

