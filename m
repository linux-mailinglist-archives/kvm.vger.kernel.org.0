Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A025541632D
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhIWQ1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230304AbhIWQ1T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWAQUvc9WZ1vqHaShxlPjUIFPCCCFA7GbKj7JUFPVOc=;
        b=Zho8tDgl3GjM1RdnsxUMj+NwcHpN9nvERmKuAfPfARvBr0YhgdsxiRZaNEpgZZ/eGhJf4v
        X8lof4kaUuV2Fk1B8rEQmXAaQZ3WS3hzZ1Nxie8JOzYKTlEKMJj2W+PrJ+zP6y9MLkT+Hq
        7+J9Kj5rtNbLvfEQuU2EZzj2IGPWGZ4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-N0oXLA17OlK8jkh_zcrWRQ-1; Thu, 23 Sep 2021 12:25:46 -0400
X-MC-Unique: N0oXLA17OlK8jkh_zcrWRQ-1
Received: by mail-ed1-f72.google.com with SMTP id l29-20020a50d6dd000000b003d80214566cso7232753edj.21
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wWAQUvc9WZ1vqHaShxlPjUIFPCCCFA7GbKj7JUFPVOc=;
        b=0Gw9gxrnKQFhwKtKRyYOOo0t89SFyyfyxIcdLGANAD380fdy3DSClPg/tyguHBP127
         ug4Zz+EWetzcQ9EuOKGKFlh4G2LYA5imdDIHIyrGHJqyUrkOiimUMoyXwdX22ZbTug6o
         0SqoUNaWtOB92LLwOUmpWzKvtLc2D8P9Yw4gF9FgYm9s8VukniKAm6hG5c8aaFM7XuQU
         9j2hZ385MPPxIkOT+PblN/dJAHvIp0OCFVlFSI95HTVHgEDSRH/H2ENg0ap4C7iVaYCj
         EaZSQP7z/BxjBYD7S+opDWRpAl5x4rEGgTBYA5ZVLwsjwPMafPWIcc2Xw7kQHGWbYgEW
         oHAA==
X-Gm-Message-State: AOAM5316Sn3lfAzwqRH3InrNb8MEP5iXNBuexAd0+ojagLjfBafmKNtA
        Tskk0Icm93NzIiPJfGJPBqMG9g7pmmfAfsluSI4fQummpQ+trghZ7tlO+Km/dRR/WhEMII+D0zi
        YGAVgiMYB65fk
X-Received: by 2002:a50:be8f:: with SMTP id b15mr6548777edk.200.1632414344680;
        Thu, 23 Sep 2021 09:25:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLPNCijm8vobMxCnfKUVsjGg5A9p8RGVLMgIZqTgCZT5T3yOUKBCQlwpq8PPv5EUorDNEyhw==
X-Received: by 2002:a50:be8f:: with SMTP id b15mr6548754edk.200.1632414344492;
        Thu, 23 Sep 2021 09:25:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t10sm3225755ejf.15.2021.09.23.09.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:25:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Fix kvm_vm_free() in cr4_cpuid_sync and
 vmx_tsc_adjust tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, Wei Huang <wei@redhat.com>
References: <20210826074928.240942-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <75a3bb1f-ff4a-0f3b-6ffd-8118fcb40c5a@redhat.com>
Date:   Thu, 23 Sep 2021 18:25:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210826074928.240942-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/21 09:49, Thomas Huth wrote:
> The kvm_vm_free() statement here is currently dead code, since the loop
> in front of it can only be left with the "goto done" that jumps right
> after the kvm_vm_free(). Fix it by swapping the locations of the "done"
> label and the kvm_vm_free().
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 3 +--
>   tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c | 2 +-
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> index f40fd097cb35..6f6fd189dda3 100644
> --- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> @@ -109,8 +109,7 @@ int main(int argc, char *argv[])
>   		}
>   	}
>   
> -	kvm_vm_free(vm);
> -
>   done:
> +	kvm_vm_free(vm);
>   	return 0;
>   }
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> index 7e33a350b053..e683d0ac3e45 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
> @@ -161,7 +161,7 @@ int main(int argc, char *argv[])
>   		}
>   	}
>   
> -	kvm_vm_free(vm);
>   done:
> +	kvm_vm_free(vm);
>   	return 0;
>   }
> 

Queued, thanks.

Paolo

