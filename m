Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5689E34AD32
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCZROj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:14:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhCZROW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGdNAKTyvuE9HoUHdxIb+GgZN7iru3jfjd1dnZgCMbw=;
        b=TkL7zOZaoer7a5Z+dC85hi7CmqXtmpeBNvhaybXQhXKPdurvjWhdFe+y2gnlF11HiNYIdT
        yNb8ciMHTjl5QmEjPP9+EvmHTEOxRdm1QPlfxBtkzvbZPo2RP1DHu7l8JA+TjUpLkukRkW
        aQ+eWohj062Be/G9tju+FwK4AHbTSWs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-RL4VvQYUOoauo8DnevaRtw-1; Fri, 26 Mar 2021 13:14:17 -0400
X-MC-Unique: RL4VvQYUOoauo8DnevaRtw-1
Received: by mail-ed1-f71.google.com with SMTP id p6so4737218edq.21
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QGdNAKTyvuE9HoUHdxIb+GgZN7iru3jfjd1dnZgCMbw=;
        b=UefkpkgD5ZYCAtbpWXvZDT1IWjcVrCkZtnf7CgPCyAmJjFnIw42Dbp0Qn+MwltCuvw
         CVm6vvi2wzgZ4bXQ/xGADKBUNn9I/Ri5w88XpvGcOdXNtIbcOFKVqmjBUW1mIKlmDnlG
         sbVTFN+BusmbWjEi5mOlbMqaZlKHkUpcRK1GFlQJjhYtB9q9tsTL8IPOFyMojb1lq5ZZ
         ezc/o1LfMVKKEanAy/fLbxZIbyz2NVUV9+PbmiUdV9PXKFlrbSuxKGsc3HlZyZFZgoPz
         2zz2sImwvJRMVbsODctknrvm+2QuxGHbSyia5W1GXaARnO+r12PChgCY3Tpcc9u8mhJt
         MY1Q==
X-Gm-Message-State: AOAM533FQXuNy6+VZY4QyE1X1JmE/kSEKIcx2vtJUem0AA0/DrjGmOPe
        qu+tbvpEEgpFETBMaE13L3PHGODE7HWecVKXSk7rKrIDvgJg1z4x4XD622kh+3aNDbcbvqVDQiC
        WZoioXO6Yb3Qu
X-Received: by 2002:a17:906:b80c:: with SMTP id dv12mr16714940ejb.110.1616778856300;
        Fri, 26 Mar 2021 10:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaTiHmaXAM+TKtmD1MrN4M17ohbs85DP6TOlir6bKZN0oNLD+VTMlMenxI4R9ObpvaPki3YA==
X-Received: by 2002:a17:906:b80c:: with SMTP id dv12mr16714918ejb.110.1616778856155;
        Fri, 26 Mar 2021 10:14:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a26sm4716004edm.15.2021.03.26.10.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:14:15 -0700 (PDT)
Subject: Re: [PATCH 1/1] KVM: x86: remove unused declaration of
 kvm_write_tsc()
To:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
References: <20210326070334.12310-1-dongli.zhang@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <85eeb727-de5f-a42b-0e6a-dd23462a63da@redhat.com>
Date:   Fri, 26 Mar 2021 18:14:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326070334.12310-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/21 08:03, Dongli Zhang wrote:
> The kvm_write_tsc() was not used since commit 0c899c25d754 ("KVM: x86: do
> not attempt TSC synchronization on guest writes"). Remove its unused
> declaration.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   arch/x86/kvm/x86.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 39eb04887141..9035e34aa156 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -250,7 +250,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>   void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
>   void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>   
> -void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   u64 get_kvmclock_ns(struct kvm *kvm);
>   
>   int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
> 

Queued, thanks (with slight editing of the commit message as Vitaly 
mentioned).

Paolo

