Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC23DE89E
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhHCIoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234407AbhHCIoZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627980253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ude2VhAI1aJYRLmEO5A/TvgrA5eRYeor1F1Z0AtsJ+0=;
        b=H1dqQiiwI6PAF5gfrZmI6osMcy92Ee7CF9nt5uhZlpZUhdXycaWCN17EMiv++D5PGYAalM
        mBoYpmqEZ0mlmkIDcZljurxmN5V+j9efgQC5UkOftQwZ1OaILpvwnUh6tKu71lrOhG5IGC
        SIc7lzfGxPO6HsPibWYQ5Fjp/Ozv2yk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-W8V_66WZPme-7Fjkdsw21Q-1; Tue, 03 Aug 2021 04:44:12 -0400
X-MC-Unique: W8V_66WZPme-7Fjkdsw21Q-1
Received: by mail-ed1-f72.google.com with SMTP id l3-20020aa7c3030000b02903bccf1897f9so6523383edq.19
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 01:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ude2VhAI1aJYRLmEO5A/TvgrA5eRYeor1F1Z0AtsJ+0=;
        b=ZqFSLBvusFj2fSl8i5CAhoeA8YYEp9lvlEyz5+SCGeOuoIdeu4RqBOnKFTP6thuR3A
         EvNJ5o/OM4XVd5B1TXlQkw84ZPtkDM5Nqw4glEzPfPlW5wLGcVHN/hz2bxr4sOm/v7Ky
         F6aqEGL02hrqBqvtIew1Ldlm1zT1ZmTsyQ8OKWebyNNPi0q1NDVGS2VpeHvM6wXHwIOz
         G8wLSua3ZUy32tgvywUKmkkxeOd156X7hWo6cdOFH8ymK3yHl66v5pevm9RSbETSI13G
         8I/j8IBz0IJfoe3U04KKst54e140kdIA04M/wj1b7QzIyhVOWd/VBaCjhr7YxLdQ/jhO
         xGKA==
X-Gm-Message-State: AOAM5320ZQHz/YVA1RODFt7Jzk32QVPQioIq8PhRI8NmGWRGN2gvHBRm
        ThC57pdvsDZqyQvSQ/6KfTRXWCFYA+uf58v8uNuxqAlKKCHkXhzeKb/oQCQGGeuKsxM8A8nfpSo
        zEQ3mpC7OeN4x
X-Received: by 2002:aa7:cd73:: with SMTP id ca19mr24044319edb.113.1627980251208;
        Tue, 03 Aug 2021 01:44:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlf1jsmQxy+O6kVZUgDFwEQIG4VGqfrJNqrpK/EwRblY6o0O4fRrTBkORbdk6JJS3XrJbeXQ==
X-Received: by 2002:aa7:cd73:: with SMTP id ca19mr24044300edb.113.1627980251043;
        Tue, 03 Aug 2021 01:44:11 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id c22sm7814861eds.1.2021.08.03.01.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:44:10 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-7-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 06/12] KVM: x86: don't disable APICv memslot when
 inhibited
Message-ID: <f221e94c-fb64-a859-de3c-30f883eac657@redhat.com>
Date:   Tue, 3 Aug 2021 10:44:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-7-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewing this patch and the next one together.

On 02/08/21 20:33, Maxim Levitsky wrote:
> +static int avic_alloc_access_page(struct kvm *kvm)
>  {
>  	void __user *ret;
>  	int r = 0;
>  
>  	mutex_lock(&kvm->slots_lock);
> +
> +	if (kvm->arch.apic_access_memslot_enabled)
>  		goto out;

This variable is overloaded between "is access enabled" and "is the 
memslot allocated".  I think you should check 
kvm->arch.apicv_inhibit_reasons instead in kvm_faultin_pfn.


> +	if (!activate)
> +		kvm_zap_gfn_range(kvm, gpa_to_gfn(APIC_DEFAULT_PHYS_BASE),
> +				  gpa_to_gfn(APIC_DEFAULT_PHYS_BASE + PAGE_SIZE));
> +

Off by one, the last argument of kvm_zap_gfn_range is inclusive:
Also, checking "activate" is a bit ugly when we have "new" available as 
well.  Yes, they are the same if !!old != !!new, but we care about the 
global state, not the single bit.

Putting everything together, this could become something like

         trace_kvm_apicv_update_request(activate, bit);
         if (!!old != !!new) {
		/*
		 * Kick all CPUs out of guest mode.  When
		 * kvm_vcpu_update_apicv succeeds in taking
		 * apicv_update_lock, it will see the
		 * new apicv_inhibit_reasons that we set below.
		 */
	        kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);

	        if (new) {
	                unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
	                kvm_zap_gfn_range(kvm, gfn, gfn);
	        }
	}
         kvm->arch.apicv_inhibit_reasons = new;
         mutex_unlock(&kvm->arch.apicv_update_lock);

Paolo

