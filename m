Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B8639FD6A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFHRVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhFHRVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 13:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623172755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q37WuaMm0t5GY7ci6kK43xp6wy9rrv5jWDUeFr8BX58=;
        b=HZaph1iayMfxXgaC6SnfW28TZmvO6JdJBtF3Y+PetZo01qwPZ03l92v8P0tcO3mM/zGMRq
        iXuHg8Ve51c4NvHaSdPdpnQADVDZJcAMnBQBcTeE92WnVUFLHLdH/AIcNW9uSMlnThcQid
        clYWM5rur7Kr9zaiQEFLYywYVUi5PIY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-jRt9_811Op2RzelJGe3HLg-1; Tue, 08 Jun 2021 13:19:14 -0400
X-MC-Unique: jRt9_811Op2RzelJGe3HLg-1
Received: by mail-wm1-f70.google.com with SMTP id n127-20020a1c27850000b02901717a27c785so1424325wmn.9
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q37WuaMm0t5GY7ci6kK43xp6wy9rrv5jWDUeFr8BX58=;
        b=fDKjUUdvSEhcyo0TfPbS8unNWrQ1cL5zVMVR/rpg04KtMgXFSgYg309Psb7XIZFPG9
         zcjGOO7m1xADoAINkDbVrY7zopiqCXtdC4Rje7Ve/Qc89pH2dVTMcgA3Fijm7kFyST2d
         deaLcAkFqajwSwE2KAgIVV+AobARYqjOqg2IgDQSwkjZLTaWUM/WWDHOQcc7XdvyB8pF
         b0wMzuxhCnClb1EaTbhcfm7A2BRu/CZR2zBmP0so/hQsd0T8eh1LoLkCMO2Ac4juNSM2
         9rcY6072FO+habMB5OzhTAv0gnac8YwNKBNpX7CIjSBZ5TqBNri1hIc39wGDaiIqfnIT
         K47A==
X-Gm-Message-State: AOAM531gXo7tzsD9oWd3XhdiSEVn23HojaGESERJmyWpXz40UQ4O0iYy
        ra0zXg+6ygg30ZofBWyea5Q7dAYm6Zr67dkx+vANRlmLXwufPa2w4VIAMOkQEEPB67VqTNbVKXb
        MlgzgOa9lfZsa
X-Received: by 2002:a5d:4984:: with SMTP id r4mr23378626wrq.152.1623172753133;
        Tue, 08 Jun 2021 10:19:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmj4FqLI7Hl07c/hm40gQk0oiqQ2Kqht7RwmxNMtqkm+JIoKEXMqQlJVoko7IZo8dAbaAwCQ==
X-Received: by 2002:a5d:4984:: with SMTP id r4mr23378608wrq.152.1623172752912;
        Tue, 08 Jun 2021 10:19:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q3sm21120231wrz.71.2021.06.08.10.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 10:19:12 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: selftests: introduce P47V64 for s390x
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     bgardon@google.com, dmatlack@google.com, drjones@redhat.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, peterx@redhat.com,
        venkateshs@chromium.org
References: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
 <20210608123954.10991-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a32486ec-f34d-3cdb-2dd4-19e28e7f3948@redhat.com>
Date:   Tue, 8 Jun 2021 19:19:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608123954.10991-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/21 14:39, Christian Borntraeger wrote:
> s390x can have up to 47bits of physical guest and 64bits of virtual
> address  bits. Add a new address mode to avoid errors of testcases
> going beyond 47bits.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> v1->v2:
> - remove wrong comment
> - use 5 levels of page tables
>   tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
>   tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..b602552b1ed0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -43,6 +43,7 @@ enum vm_guest_mode {
>   	VM_MODE_P40V48_4K,
>   	VM_MODE_P40V48_64K,
>   	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> +	VM_MODE_P47V64_4K,
>   	NUM_VM_MODES,
>   };
>   
> @@ -60,7 +61,7 @@ enum vm_guest_mode {
>   
>   #elif defined(__s390x__)
>   
> -#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
> +#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
>   #define MIN_PAGE_SHIFT			12U
>   #define ptes_per_page(page_size)	((page_size) / 16)
>   
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 28e528c19d28..b126fab6c4e1 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -175,6 +175,7 @@ const char *vm_guest_mode_string(uint32_t i)
>   		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
>   		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
>   		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
> +		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
>   	};
>   	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
>   		       "Missing new mode strings?");
> @@ -192,6 +193,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>   	{ 40, 48,  0x1000, 12 },
>   	{ 40, 48, 0x10000, 16 },
>   	{  0,  0,  0x1000, 12 },
> +	{ 47, 64,  0x1000, 12 },
>   };
>   _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>   	       "Missing new mode params?");
> @@ -277,6 +279,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>   		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
>   #endif
>   		break;
> +	case VM_MODE_P47V64_4K:
> +		vm->pgtable_levels = 5;
> +		break;
>   	default:
>   		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
>   	}
> 

Queued, thanks.

Paolo

