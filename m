Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF01E5EC4
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbgE1Lzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:55:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59944 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388547AbgE1Lzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 07:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590666948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMrXL5UTOuAfzZCPWxCDdnj8ZN3SNqipk1q2lcevpUM=;
        b=fzE8EdJGON1UeeaJ4FgOFOqb79FtYwoqrn91MdR67ysf9DFmH3mXXT4u6/hZBHPexDuWQy
        i+eTQAOdW/ahUq7jT6LeFD6Q1CddRG7yzrZPM6KcZ9O/bQvT/2yFsNLfHzdyt2KyDzXUyq
        0d1vMR0u7UPuIZ8RRwmevPR6LorS9FM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-c_NmNQS6Nruq5X_kQ-1Rlw-1; Thu, 28 May 2020 07:55:46 -0400
X-MC-Unique: c_NmNQS6Nruq5X_kQ-1Rlw-1
Received: by mail-wm1-f72.google.com with SMTP id g194so896526wmg.0
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kMrXL5UTOuAfzZCPWxCDdnj8ZN3SNqipk1q2lcevpUM=;
        b=SnS430ViiUfgPg/Tn7Ei/KbMF6YuDNsU7ZFJGHC+6TEOJD9z3IO54/43HuSLUAkIgO
         teSjWegf4Rd4UTpMw/jsZi3vvdZqP3c64eErGAMOw3WXja+slmAUdI5q8owG6Ek/kRcH
         AhPFeEojiOB1RJwZiWJj9BGSuWhp7jn/xaQg4J5ULvReiaS7OawUOFJ6TrLRSN8Jx8i7
         J63RqqDSeinMhySrqKTLHcwIOzcw0/QD13FdfUf9GO7p8xlKmVBgk05kW3E10EVbNE7I
         q4EzO/dXwcc5JQu/22m3e3pKmLetqvqdtiHFkZKkrFw1XSjyA6qNMjx2PxmoAAjAZIAI
         AuJA==
X-Gm-Message-State: AOAM533FXSLz/APj4sPwTUNUehDK4W2yZw3pgbLL6lvTHa9k342qYb4B
        32reWxPECOIl7pJaHxJNMKFYjk6uUyymb76IMrQ6TdWbDryXsKnXwckG91OUpEw1CPOIvaFMLPJ
        e/hUp2494Oc8H
X-Received: by 2002:a1c:4d11:: with SMTP id o17mr2983437wmh.37.1590666945765;
        Thu, 28 May 2020 04:55:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRaCegJZCXeJg+DyF1D0t/2pQf4m0FYJJ1fMY2jcdAySIKDs/WMA30cgVqg6evvPOvJlfuvA==
X-Received: by 2002:a1c:4d11:: with SMTP id o17mr2983415wmh.37.1590666945527;
        Thu, 28 May 2020 04:55:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id n23sm3423436wmc.21.2020.05.28.04.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:55:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Ignore KVM 5-level paging support for
 VM_MODE_PXXV48_4K
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>,
        Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>,
        Peter Xu <peterx@redhat.com>
References: <20200528021530.28091-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ed65de29-a07a-f424-937e-38576e740de7@redhat.com>
Date:   Thu, 28 May 2020 13:55:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528021530.28091-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 04:15, Sean Christopherson wrote:
> Explicitly set the VA width to 48 bits for the x86_64-only PXXV48_4K VM
> mode instead of asserting the guest VA width is 48 bits.  The fact that
> KVM supports 5-level paging is irrelevant unless the selftests opt-in to
> 5-level paging by setting CR4.LA57 for the guest.  The overzealous
> assert prevents running the selftests on a kernel with 5-level paging
> enabled.
> 
> Incorporate LA57 into the assert instead of removing the assert entirely
> as a sanity check of KVM's CPUID output.
> 
> Fixes: 567a9f1e9deb ("KVM: selftests: Introduce VM_MODE_PXXV48_4K")
> Reported-by: Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>
> Cc: Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index c9cede5c7d0de..74776ee228f2d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -195,11 +195,18 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	case VM_MODE_PXXV48_4K:
>  #ifdef __x86_64__
>  		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> -		TEST_ASSERT(vm->va_bits == 48, "Linear address width "
> -			    "(%d bits) not supported", vm->va_bits);
> +		/*
> +		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
> +		 * it doesn't take effect unless a CR4.LA57 is set, which it
> +		 * isn't for this VM_MODE.
> +		 */
> +		TEST_ASSERT(vm->va_bits == 48 || vm->va_bits == 57,
> +			    "Linear address width (%d bits) not supported",
> +			    vm->va_bits);
>  		pr_debug("Guest physical address width detected: %d\n",
>  			 vm->pa_bits);
>  		vm->pgtable_levels = 4;
> +		vm->va_bits = 48;
>  #else
>  		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
>  #endif
> 

Queued, thnaks.

Paolo

