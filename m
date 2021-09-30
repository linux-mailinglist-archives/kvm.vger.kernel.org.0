Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBC41D55E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349089AbhI3I1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348107AbhI3I1K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 04:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632990327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZDlrtySWZ8aKYElfHM2QvkjVRqwG+Yrljzwwq0Gl48=;
        b=iwn1wDd6DugpCLFen0QeHSDkhmo38eEFP3atbfzEPOUzGIYOpxx2f8eX4Hj6yjUP9bu6qV
        Bs8wESJabcgVOZHc3lObe6x7v26yF0AtF96oSbse0KAXCsP6AEvYch9/q1dy4oWKSlIIn8
        cc5ucGpMcExi0xVG2M8GzyvAAxW7rHE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-DVKWTvlmMsCAFI30xL1tYA-1; Thu, 30 Sep 2021 04:25:26 -0400
X-MC-Unique: DVKWTvlmMsCAFI30xL1tYA-1
Received: by mail-ed1-f69.google.com with SMTP id e21-20020a50a695000000b003daa0f84db2so5385844edc.23
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 01:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qZDlrtySWZ8aKYElfHM2QvkjVRqwG+Yrljzwwq0Gl48=;
        b=6N6blq/Goa0hxdo8Iln60X9LLKq9scVAkM2IJGU+kApKVScnI312TOfK59CAPzkMAq
         awNAclQEbK4lMOQA3Cn9hJ878Hhal4qlVtvig83oTXg4QnZZj4lMfpT/PLowd+/qLXI0
         d7b7M86DmDqxn0becjiYZyAM0txhE4pIsPY4WbKaKFuVdNneNUJiH4DE7I6/mOPenbzN
         YE53BH8C43ObxOGdaf8bESc89kIfGiQByMnspk0ySi9ABSSYn5wh8rLnTDlsBv8Z7Y0k
         5NKHsGrPGIF0W7sjHVm00bQuLV4N3HrkUcqmcKXqkrvGz4m5HRyGjh/oA+OFXxvLZrNe
         mb1A==
X-Gm-Message-State: AOAM533i8iUOuAjUTV1LyXDwRO0WX81oq/sAX8JsprQa51w+kZIKqLcf
        uLoQEhRjFqfVO4leZx1JOhFH/q9KNacgX3DfCnohCPzZW/rJwm0G/ViDLDTVypKDGe+jf9hytCv
        oR6HG4dbrIz8/
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr5306281eju.10.1632990325030;
        Thu, 30 Sep 2021 01:25:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6dmrAQnGVYDpSFITeZQ5J78A0Qbz6DDf8Zt8iSZNnThEDyhAzvKmWq+5AFnH0Qaik7Pezug==
X-Received: by 2002:a17:906:4f82:: with SMTP id o2mr5306267eju.10.1632990324849;
        Thu, 30 Sep 2021 01:25:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id k7sm1052460eds.96.2021.09.30.01.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 01:25:24 -0700 (PDT)
Message-ID: <75632fa9-e813-266c-7b72-cf9d8142cebf@redhat.com>
Date:   Thu, 30 Sep 2021 10:25:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 2/2] KVM: x86: Manually retrieve CPUID.0x1 when getting
 FMS for RESET/INIT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
References: <20210929222426.1855730-1-seanjc@google.com>
 <20210929222426.1855730-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210929222426.1855730-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 00:24, Sean Christopherson wrote:
>  	 * RESET since KVM emulates RESET before exposing the vCPU to userspace,
>  	 * i.e. it'simpossible for kvm_cpuid() to find a valid entry on RESET.
> +	 * But, go through the motions in case that's ever remedied.  Note, the
> +	 * index for CPUID.0x1 is not significant, arbitrarily specify '0'.

Just one nit, this comment change is not really needed because almost 
all callers are using '0' for the same reason.

But, perhaps adding kvm_find_cpuid_entry_index and removing the last 
parameter from kvm_find_cpuid_entry would be a good idea.

Also, the kvm_cpuid() reference needs to be changed, which I did upon 
commit.

Paolo


>   	 */
> -	eax = 1;
> -	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
> -		eax = 0x600;
> -	kvm_rdx_write(vcpu, eax);
> +	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
> +	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);

