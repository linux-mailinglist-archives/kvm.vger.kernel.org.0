Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A0C366F53
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244063AbhDUPjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 11:39:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236008AbhDUPja (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 11:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619019536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LH4Md5GFyHsRu3EpNnm63FYFT/U0BE+N7qiFVDQcVqg=;
        b=PHVdTJA8TgMIaCndgNQopRVmggvMOST1hQ+Y88FZDKlY/kfQnV0AQy1qXrdVcsIl6kbZx2
        z9tRuvT6j0xcVVIM9tyPxk3MzmF1o+H0Ywrg00SgjJ8IyqJ+RXowqzlFlr5XxakO5189L8
        uyODOzF0OgqmflD68t53u1Foed/xvuE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-Wv5KMFWkNH28vjDCb_9RQQ-1; Wed, 21 Apr 2021 11:38:49 -0400
X-MC-Unique: Wv5KMFWkNH28vjDCb_9RQQ-1
Received: by mail-ed1-f70.google.com with SMTP id r14-20020a50d68e0000b0290385504d6e4eso5329171edi.7
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 08:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LH4Md5GFyHsRu3EpNnm63FYFT/U0BE+N7qiFVDQcVqg=;
        b=SIU5VF/w2gwN7WB/bFqAOoaMjlKnvEmYCLZnCGCrc62tq3yUlYSb133am3UnqOsxJg
         hE0HT506t2WNUd5KpU0EYe/NAKSBT8hfnZWUs6g7nkxirELweNGckwv3nDqYivJMgiMS
         9JsCdujc9IJKFTpVR42MUupxEGgQgrwokR4AIqUT2jjNDFpHpi6P+9ftgnJUTt6hRbXX
         moGMVoXEKLQkwMsaTxe4e8ZAM1u+u76ivbxNUZiUi7flu14RKjrCoWlSiX9pqHrm/XsJ
         8mZvG+50LHZbXUBRzNhpfVuGxh2bQo5fIFA6t+6ihWwtQD5umjVyxpk0NyMlByv7mZIo
         8oDQ==
X-Gm-Message-State: AOAM531mPGic/pZcM29C+q/9h2JBi91htz+h2U+0XGYMYYaeXI+Ql+nh
        FkBrs7mAfWL3IzZcq6G6wsOqK47a+JLFnamsf5JPT5+sW50z8RFQDi/wyIIq1c60v3jQIpDZtrw
        /a1Az2PZDQ23Q
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr39696649edq.219.1619019527997;
        Wed, 21 Apr 2021 08:38:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxduVqz2/JzoEQO/Yw48tCFx89EkksxKpd/jLae3kGSka+DVi9FP0CJS9tMLShEsMc3QFbXow==
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr39696624edq.219.1619019527751;
        Wed, 21 Apr 2021 08:38:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u13sm2758321ejj.16.2021.04.21.08.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 08:38:47 -0700 (PDT)
To:     Borislav Petkov <bp@alien8.de>, Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
 <20210421144402.GB5004@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <2d3170ae-470a-089d-bdec-a43f8190cce7@redhat.com>
Date:   Wed, 21 Apr 2021 17:38:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210421144402.GB5004@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/21 16:44, Borislav Petkov wrote:
> On Thu, Apr 15, 2021 at 04:01:16PM +0000, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The guest support for detecting and enabling SEV Live migration
>> feature uses the following logic :
>>
>>   - kvm_init_plaform() invokes check_kvm_sev_migration() which
>>     checks if its booted under the EFI
>>
>>     - If not EFI,
>>
>>       i) check for the KVM_FEATURE_CPUID
> 
> Where do you do that?
> 
> $ git grep KVM_FEATURE_CPUID
> $
> 
> Do you mean
> 
> 	kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)
> 
> per chance?

Yep.  Or KVM_CPUID_FEATURES perhaps.

> 
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 78bb0fae3982..94ef16d263a7 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/kprobes.h>
>>   #include <linux/nmi.h>
>>   #include <linux/swait.h>
>> +#include <linux/efi.h>
>>   #include <asm/timer.h>
>>   #include <asm/cpu.h>
>>   #include <asm/traps.h>
>> @@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>>   	early_set_memory_decrypted((unsigned long) ptr, size);
>>   }
>>   
>> +static int __init setup_kvm_sev_migration(void)
> 
> kvm_init_sev_migration() or so.
> 
> ...
> 
>> @@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
>>   
>>   bool sev_enabled __section(".data");
>>   
>> +bool sev_live_migration_enabled __section(".data");
> 
> Pls add a function called something like:
> 
> bool sev_feature_enabled(enum sev_feature)
> 
> and gets SEV_FEATURE_LIVE_MIGRATION and then use it instead of adding
> yet another boolean which contains whether some aspect of SEV has been
> enabled or not.
> 
> Then add a
> 
> static enum sev_feature sev_features;
> 
> in mem_encrypt.c and that function above will query that sev_features
> enum for set flags.

Even better: let's stop callings things SEV/SEV_ES.  Long term we want 
anyway to use things like mem_encrypt_enabled (SEV), 
guest_instruction_trap_enabled (SEV/ES), etc.

For this one we don't need a bool at all, we can simply check whether 
the pvop points to paravirt_nop.  Also keep everything but the BSS 
handling in arch/x86/kernel/kvm.c.  Only the BSS handling should be in 
arch/x86/mm/mem_encrypt.c.  This way all KVM paravirt hypercalls and 
MSRs are in kvm.c.

That is:

void kvm_init_platform(void)
{
	if (sev_active() &&
	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
		pv_ops.mmu.notify_page_enc_status_changed =
			kvm_sev_hc_page_enc_status;
		/* this takes care of bss_decrypted */
		early_set_page_enc_status();
		if (!efi_enabled(EFI_BOOT))
			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
			       KVM_SEV_LIVE_MIGRATION_ENABLED);
	}
	/* existing kvm_init_platform code goes here */
}

// the pvop is changed to take the pfn, so that the vaddr loop
// is not KVM specific
static inline void notify_page_enc_status_changed(unsigned long pfn,
				int npages, bool enc)
{
	PVOP_VCALL3(mmu.page_encryption_changed, pfn, npages, enc);
}

static void notify_addr_enc_status_changed(unsigned long addr,
					   int numpages, bool enc)
{
#ifdef CONFIG_PARAVIRT
	if (pv_ops.mmu.notify_page_enc_status_changed == paravirt_nop)
		return;

	/* the body of set_memory_enc_dec_hypercall goes here */
	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
		...
		notify_page_enc_status_changed(pfn, psize >> PAGE_SHIFT,
					       enc);
		vaddr_next = (vaddr & pmask) + psize;
	}
#endif
}

static int __set_memory_enc_dec(unsigned long addr,
				int numpages, bool enc)
{
	...
  	cpa_flush(&cpa, 0);
	notify_addr_enc_status_changed(addr, numpages, enc);
  	return ret;
}


> +static int __init setup_kvm_sev_migration(void)

Please rename this to include efi in the function name.

> 
> +		 */
> +		if (!efi_enabled(EFI_BOOT))
> +			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> +			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> +		} else {
> +			pr_info("KVM enable live migration feature unsupported\n");
> +		}
> +}

I think this pr_info is incorrect, because it can still be enabled in 
the late_initcall.  Just remove it as in the sketch above.

Paolo

