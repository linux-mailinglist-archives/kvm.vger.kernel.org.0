Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2A049CED4
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbiAZPqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:46:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243029AbiAZPqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643211961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=85xNqoR4ThIkZTm0ksRjdnAn/hdDPYPlrpJkOEBO+Gw=;
        b=JTGWsYQpM5dbPo8z68CO+kDCdhUNr3ZE0QphQQSfnErwJFOKlPgzDh0pdWmnvvfwlp21Ya
        vTfwPX+JOFNryHGSlAlRXYfXmBdJdVXiMKdromNdwvnnLNNTMKzCCe/eU+HMwuGWQMJeRZ
        Hd95iOO723ip1ZmhnB8xRgrPXh5zwS4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-7RqXBpHdMQqRiYWQ-QPqNA-1; Wed, 26 Jan 2022 10:46:00 -0500
X-MC-Unique: 7RqXBpHdMQqRiYWQ-QPqNA-1
Received: by mail-ej1-f69.google.com with SMTP id v2-20020a1709062f0200b006a5f725efc1so5070398eji.23
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 07:45:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=85xNqoR4ThIkZTm0ksRjdnAn/hdDPYPlrpJkOEBO+Gw=;
        b=AQBsN7rJky/DFy1LR6RhlDpFTSUKQcwA8eakZkVQmuNiW+snaB87Iejt5iP+KflTwt
         3lSA7eAon3ZtANlazun4YsKcejj7lhN1hj8rCAXuM6shJOTLkFt77/yG4A6OZ3K/4bJr
         W+99qcvwpti8MFVBZzMAlnmgp/oR3TnVdx/JJyamZEvPQ31baNnTZjrJ8t07l88f5/5b
         DjOoiejaxmYlY2s18ZVDndW7rHY2tubb5HaAEJn5JPYRQEDWZxzPtnJHn1QaF3pB92C2
         4k7rvc+ZdJeOzZav2wh5XO7DNPoBTi7Z2DiymPbBdfLBe+rZRUQ8X+FGe0aGF30UXrQY
         /FdQ==
X-Gm-Message-State: AOAM530gmpeyRIUwh3uyzJgvOZoL0Kmz0F+8y/IDU0wlCSU/zQwQp/7r
        UsGhXC0QaUchYdL9oOE8MMRsDczErEGk4tvuJnLjp9fRswsC5oqIUKMk5IOMNoey6CHRO/MLyxw
        wHWAHBSpxiS/j
X-Received: by 2002:a17:907:608b:: with SMTP id ht11mr19968287ejc.644.1643211957984;
        Wed, 26 Jan 2022 07:45:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpEDNBOKy7dIjLhVKX4NyD/FEvAkY4wpp1H4YHhCLVbMYQN/BtgG/EAr7zu3rkoVxfQk9vLQ==
X-Received: by 2002:a17:907:608b:: with SMTP id ht11mr19968273ejc.644.1643211957786;
        Wed, 26 Jan 2022 07:45:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l5sm7667966ejn.59.2022.01.26.07.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 07:45:57 -0800 (PST)
Message-ID: <e570f7d2-03fc-1498-bd91-6fd7aabae766@redhat.com>
Date:   Wed, 26 Jan 2022 16:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: selftests: Don't skip L2's VMCALL in SMM test for
 SVM guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20220125221725.2101126-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125221725.2101126-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 23:17, Sean Christopherson wrote:
> Don't skip the vmcall() in l2_guest_code() prior to re-entering L2, doing
> so will result in L2 running to completion, popping '0' off the stack for
> RET, jumping to address '0', and ultimately dying with a triple fault
> shutdown.
> 
> It's not at all obvious why the test re-enters L2 and re-executes VMCALL,
> but presumably it serves a purpose.  The VMX path doesn't skip vmcall(),
> and the test can't possibly have passed on SVM, so just do what VMX does.
> 
> Fixes: d951b2210c1a ("KVM: selftests: smm_test: Test SMM enter from L2")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/x86_64/smm_test.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 2da8eb8e2d96..a626d40fdb48 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -105,7 +105,6 @@ static void guest_code(void *arg)
>   
>   		if (cpu_has_svm()) {
>   			run_guest(svm->vmcb, svm->vmcb_gpa);
> -			svm->vmcb->save.rip += 3;
>   			run_guest(svm->vmcb, svm->vmcb_gpa);
>   		} else {
>   			vmlaunch();
> 
> base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4

Queued, thanks.

Paolo

