Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6507723211
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbfETLQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:16:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731214AbfETLQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:16:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so14086749wrr.13
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxAda8y+Lw5w6X737KJdEPUh+wkc1U8IjaEMWE3lVAU=;
        b=LaivQ/Toh/DzU+8nbgsuQVtAgRaGU1xDsUgH4qDBF/u+rgD4n1txc1Jnc2fxb450jW
         qqRecvhOVTiZApNPtCaB/Ex+xboa1NsDIjzp4JmZ/mLbXuexyw+9I1k4I9LmuyUudhdV
         iAbici7AofSWkpb4WFhJND/lZ7bk4QJN4V9rZC2EX+tREnPkQuilPtngdKkRSCLP2Rp1
         8AHyKMiV199tMJs92ahF8GqXMTdJe68M+nrS9ykmtieK2I1nrVlt6s/g4qW7WJo/v2jb
         jbMIiiMzp4koSJEdxPFuNYD3mGH7X4gum8pN3Wi3ZKeAdUUmDRWbfKFBPmkHuKcJTDZ/
         f9ng==
X-Gm-Message-State: APjAAAVvjhAFA0WNMVbmn6JUr6BHw5uyG6k1KLpaVFJJMx+dYkllHTOh
        g/zD/dahQ0fldlIDfh0mRJ0XdQ==
X-Google-Smtp-Source: APXvYqxKv0sQ2iquFAoDIXnp3sduGK6TezmZvrJwiMji2N1+QfUnBhmOkknC6pCZTEflbhnzO3ZTiQ==
X-Received: by 2002:adf:dc04:: with SMTP id t4mr41535607wri.126.1558350985398;
        Mon, 20 May 2019 04:16:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id 91sm25337283wrs.43.2019.05.20.04.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:16:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Remove duplicated TEST_ASSERT in
 hyperv_cpuid.c
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190520105511.12471-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8402b29a-6be4-b123-eb14-80b3fa8d8080@redhat.com>
Date:   Mon, 20 May 2019 13:16:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520105511.12471-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 12:55, Thomas Huth wrote:
> The check for entry->index == 0 is done twice. One time should
> be sufficient.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Vitaly already noticed this in his review to the "Fix a condition
>  in test_hv_cpuid()" patch a couple of days ago, but so far I haven't
>  seen any patch yet on the list that fixes this ... if I missed it
>  instead, please simply ignore this patch.
> 
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 9a21e912097c..8bdf1e7da6cc 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -52,9 +52,6 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
>  		TEST_ASSERT(entry->index == 0,
>  			    ".index field should be zero");
>  
> -		TEST_ASSERT(entry->index == 0,
> -			    ".index field should be zero");
> -
>  		TEST_ASSERT(entry->flags == 0,
>  			    ".flags field should be zero");
>  
> 

Queued, thanks.

Paolo
