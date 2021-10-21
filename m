Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22097436636
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhJUP30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:29:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231755AbhJUP3X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634830026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6MrzrO7xesFuLzBcBSeQQGfqugRLLAD0yJI9mSpS6E=;
        b=fZVvW3sg3dksO9jzoqeazc9mVvXetnix3I8mR8sVjFSy7gzoCIpxAiB64BMdYHvxJo/ORE
        t4v2uTNqNsxc+ZxNnlh7Ae0ph6IOUyUekzPMm5x9lg64SZbIXTIorjpHClqyntkx99cvnp
        Hyrqa1HprkCuqkwGvBmSVjW/kVtOjjU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-myycwZETNsexMuPsRzMWdg-1; Thu, 21 Oct 2021 11:27:05 -0400
X-MC-Unique: myycwZETNsexMuPsRzMWdg-1
Received: by mail-ed1-f72.google.com with SMTP id c25-20020a056402143900b003dc19782ea8so759368edx.3
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v6MrzrO7xesFuLzBcBSeQQGfqugRLLAD0yJI9mSpS6E=;
        b=G7xsBsl/2gVpVL6UhyVvaRXEC1CBSCiUi0O9r/9lVQUIBLpB8ds1V7E1xC1ePlwRXv
         ZiCw2FoGhBN2p1EIkLzymbwhG5A04jKoy5L4/MRkJ5oyf51V7vxzKCzERAytj/TSp28P
         hv2H4ZdhIe6NCk1SHqvGyJt6/k6+z14PhO9bSAcYEYUhY8wvFPIOamakmhRvLR2ZP7tC
         6kwHuQQcL6I1yJOwQI9l901wpGpyJrSBJqJykIdat+Pa7Wfj8IawEfksWu+Yo1t38C10
         eFYA4Y5s44R03agNM52Mc4lkYMsSyFOSswypwfjuvjpCcJPgye3MMUY/23kWWvXxjtHg
         DuMQ==
X-Gm-Message-State: AOAM530WAMSuaRT3eBJVHypfdX4U9Fy3fluDz8kKLtOrPyHK9wwL17y8
        tTbecaJG4peClxzrnSpIK9a1N2COMIYZEoW3Nt46adb/euvch2Uc2T8y4cOLbQvLuP0CW6t+cpD
        HogP0x1wvYYh7
X-Received: by 2002:a17:906:4fc8:: with SMTP id i8mr7830775ejw.342.1634830024449;
        Thu, 21 Oct 2021 08:27:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxDOrjICVVqTJ9+CDDGwf+1wA1UgMTXWu66IzWHwvhm5fM8zXDYn4XggFMnO9UcpVEQ2Hw1A==
X-Received: by 2002:a17:906:4fc8:: with SMTP id i8mr7830743ejw.342.1634830024244;
        Thu, 21 Oct 2021 08:27:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o21sm3003991edc.60.2021.10.21.08.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:27:03 -0700 (PDT)
Message-ID: <31db4c63-218a-5b26-f6ed-d30113f95e29@redhat.com>
Date:   Thu, 21 Oct 2021 17:26:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC 03/16] KVM: selftests: handle encryption bits in page tables
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>,
        linux-kselftest@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
References: <20211005234459.430873-1-michael.roth@amd.com>
 <20211005234459.430873-4-michael.roth@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211005234459.430873-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 01:44, Michael Roth wrote:
> SEV guests rely on an encyption bit which resides within the range that
> current code treats as address bits. Guest code will expect these bits
> to be set appropriately in their page tables, whereas helpers like
> addr_gpa2hva() will expect these bits to be masked away prior to
> translation. Add proper handling for these cases.

This is not what you're doing below in addr_gpa2hva, though---or did I 
misunderstand?

I may be wrong due to not actually having written the code, but I'd 
prefer if most of these APIs worked only if the C bit has already been 
stripped.  In general it's quite unlikely for host code to deal with C=1 
pages, so it's worth pointing out explicitly the cases where it does.

Paolo

> @@ -1460,9 +1480,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>    * address providing the memory to the vm physical address is returned.
>    * A TEST_ASSERT failure occurs if no region containing gpa exists.
>    */
> -void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
> +void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa_raw)
>   {
>   	struct userspace_mem_region *region;

