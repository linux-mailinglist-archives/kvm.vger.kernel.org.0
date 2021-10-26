Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E365043B6E9
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbhJZQT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237389AbhJZQT2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635265023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrGP2hx/5gqG8KTbScu3FM5mqdfWvd8zWiCw/D9kcnY=;
        b=Pd5YrAYpkwa/tw+562IPdlNBXS64oZMRqcgA8HzFFAHU957yht3MQfPJCQxQ22H0YTEi/o
        kArq+BJzWwWoj32Tf5fqHC+8pnaynFubg5YSXOr70HxuaQfbqJoU+Yn9usCgM1mBJjX3Kn
        TeCODiQ4/IQDjg95GdGNjEta+oWacic=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-XzDVchtXPNi22oLTubIDgg-1; Tue, 26 Oct 2021 12:17:02 -0400
X-MC-Unique: XzDVchtXPNi22oLTubIDgg-1
Received: by mail-ed1-f70.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so13538511edi.12
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HrGP2hx/5gqG8KTbScu3FM5mqdfWvd8zWiCw/D9kcnY=;
        b=ofKmTZBMeTt57S+hbWx0DZWU9xZ1gstO4Rhh3VI4uP7I6FRS0TEKXb5jrOFTA4SKaa
         wZysHzp1T1s30Y9MoS4wrTpnVqaX9QHmNK6YjWItJlme6MBHiluzeYBuHqvu2sssJvMN
         00UJNfa0crENvJiVw6JDntkYanBYr9pUTSmSKmiws2s0oJp3afRAV32CNQyZvm1JKWgP
         k2SfcPClCg/ZX0HtzsnIeQySQat16EIUs2vpjaNvnKWaGWDOou82dBqVWXyyNrSq43nf
         wp5jIlWqkctRwNaPVppuxJkp3vJfjbzoAAHPmMnlR/mQlr1XjG/HuM0Uu0uXcy1hWAg3
         VcCw==
X-Gm-Message-State: AOAM530CKtMPdEAR2pJ2ato2VhBU08Ka9PcFFtc2MOiOOABOTikY624j
        4lSVniAClGsxlua9CzfbHV/XOpAqiJz5AArbG4k13Np6ILOXZ7Tu4SLNmmGuS2PQEdjtaZzF9FW
        OQDMuZtUB1Vt+
X-Received: by 2002:a17:906:ca18:: with SMTP id jt24mr31355806ejb.325.1635265020751;
        Tue, 26 Oct 2021 09:17:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCAgaJ1nXM1ocpSePMgU4hrCoy1y+RLuGZFU21qMLu8XFQGQoffuE7NXc4djJHfV0Ccx8NlQ==
X-Received: by 2002:a17:906:ca18:: with SMTP id jt24mr31355787ejb.325.1635265020563;
        Tue, 26 Oct 2021 09:17:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x6sm468027eds.83.2021.10.26.09.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:17:00 -0700 (PDT)
Message-ID: <dabdf154-eba2-f453-1597-fa84d464a106@redhat.com>
Date:   Tue, 26 Oct 2021 18:16:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 4/5] KVM: SEV-ES: Set guest_state_protected
 after VMSA update
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211025203828.1404503-1-sashal@kernel.org>
 <20211025203828.1404503-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211025203828.1404503-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 22:38, Sasha Levin wrote:
> From: Peter Gonda <pgonda@google.com>
> 
> [ Upstream commit baa1e5ca172ce7bf9554070139482dd7ea919528 ]
> 
> The refactoring in commit bb18a6777465 ("KVM: SEV: Acquire
> vcpu mutex when updating VMSA") left behind the assignment to
> svm->vcpu.arch.guest_state_protected; add it back.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> [Delta between v2 and v3 of Peter's patch, which had already been
>   committed; the commit message is my own. - Paolo]
> Fixes: bb18a6777465 ("KVM: SEV: Acquire vcpu mutex when updating VMSA")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/sev.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cb166bde449b..50dabccd664e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -619,7 +619,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>   	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
>   	vmsa.address = __sme_pa(svm->vmsa);
>   	vmsa.len = PAGE_SIZE;
> -	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +	if (ret)
> +	  return ret;
> +
> +	vcpu->arch.guest_state_protected = true;
> +	return 0;
>   }
>   
>   static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

I missed that bb18a677746543e7f5eeb478129c92cedb0f9658 was Cc'd to 
stable.  Good bot. :)

Paolo

