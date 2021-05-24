Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805F538E69F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhEXMcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhEXMci (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ycZL+mokHGEEWTTJX0ncvhwWG4fH6WZfM6N/AXHg5Y=;
        b=gcHfIvoZlBYHlok524RFdXI4T8IX9Z8OcRG5d2JYNpU0ERDgE1GZGdRvH2Fda+zu7xnQq3
        E6kvXTw+QO6xDZruAFDbM4y69SCpoBlmhsKGA4kBoCJpAFcJAg3f3T8sHzmGG9tGXvAzcQ
        wLXec9fZhfxw6vEumrHRt22CdAZkSfY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-6sIVE7AZOmeZxc5Vr3wnyQ-1; Mon, 24 May 2021 08:31:06 -0400
X-MC-Unique: 6sIVE7AZOmeZxc5Vr3wnyQ-1
Received: by mail-ed1-f72.google.com with SMTP id d4-20020aa7ce040000b029038d1d0524d0so14729549edv.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ycZL+mokHGEEWTTJX0ncvhwWG4fH6WZfM6N/AXHg5Y=;
        b=tj2f8lbWcGCh4MMo7ez7+pGuNPgLdDUz5aTJu1osii1nHAifIdQREB2My3YbvOtGQa
         6VSXpAzv1FCJ4DrBrSoAc1muFWFi3W+WLXZzCoIbbBr88gcDFSOYPHYzKAiyzUVBqQxb
         87X88FbAo0AXgTEJMFUr8djZ2yjKc9el6CQ3OnnFHhRSayt6FJF38xgpfl8PaASfsMkV
         h9haTAwlcWQ2yxPIF67q9swMnI43yvpCitefVhvnKMyNm7lX2vYl6hVvq+5+cwiszTwM
         e2Q8myWO2eIb5D/5e3TGfyZSqPIB8nqnkFje7NZHqaV/KAPzREGE5gpNwpdVp9BPlGIR
         LTvQ==
X-Gm-Message-State: AOAM532keaTTk1sEw8gxvpLTKWtn+8H1Q/E4Gt555ooO/UCVYwfCE72T
        ik/JW7ujjV6ONukHK6oqKXhRoXDwzYmoqIQzZzI0sY0H54GR0hE6vEAuJA/oD+bj3RbXoiTBwLp
        cAxtRBEQjTjXp
X-Received: by 2002:a17:906:c30b:: with SMTP id s11mr22987668ejz.486.1621859464999;
        Mon, 24 May 2021 05:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCTDa/j1CWhPxK5vjgATBL56ndHacreQ2tzpRoKbKFLYsW0n8dKRt7me2TpgJWGkPHu0lOeQ==
X-Received: by 2002:a17:906:c30b:: with SMTP id s11mr22987652ejz.486.1621859464840;
        Mon, 24 May 2021 05:31:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p15sm4370181edr.50.2021.05.24.05.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:31:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Ignore CPUID.0DH.1H in get_cpuid_test
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210519211345.3944063-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08787663-92ef-2e6d-5c65-2baff1b25f27@redhat.com>
Date:   Mon, 24 May 2021 14:31:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519211345.3944063-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 23:13, David Matlack wrote:
> Similar to CPUID.0DH.0H this entry depends on the vCPU's XCR0 register
> and IA32_XSS MSR. Since this test does not control for either before
> assigning the vCPU's CPUID, these entries will not necessarily match
> the supported CPUID exposed by KVM.
> 
> This fixes get_cpuid_test on Cascade Lake CPUs.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   tools/testing/selftests/kvm/x86_64/get_cpuid_test.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> index 9b78e8889638..8c77537af5a1 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> @@ -19,7 +19,12 @@ struct {
>   	u32 function;
>   	u32 index;
>   } mangled_cpuids[] = {
> +	/*
> +	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
> +	 * which are not controlled for by this test.
> +	 */
>   	{.function = 0xd, .index = 0},
> +	{.function = 0xd, .index = 1},
>   };
>   
>   static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
> 

Queued, thanks.

Paolo

