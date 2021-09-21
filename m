Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D204138B8
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhIURkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:40:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230444AbhIURkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632245921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4x8fIa6lEehlH6YSx+A89ipydpaaLldQpHkxWi3LP8=;
        b=GjLBhGAJCW4ocMqdX4hD/gFv3G+qm1PbTdkjrhWR4G98O1/haoMM7GWh7+hiBA1HQDAul/
        2MfyiuFHNRybKt6KHF2wzA6kIR2Z7j+Ag89WFtNiSBnQBwt3JKfi3iAukoqfGXcCfF9riG
        i8bmSIy9jm6HocnkXGvm+4Ar3ebRYGo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-EbFOn9G3OtST5m85zeCw4g-1; Tue, 21 Sep 2021 13:38:40 -0400
X-MC-Unique: EbFOn9G3OtST5m85zeCw4g-1
Received: by mail-ed1-f72.google.com with SMTP id o18-20020a056402439200b003d2b11eb0a9so19760506edc.23
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g4x8fIa6lEehlH6YSx+A89ipydpaaLldQpHkxWi3LP8=;
        b=pWLg+2o5/e4LG/hOLJHOxAKdv2q0MOND7B3wGPnuvnqJGQVVTxHbryWCTGKPKxX2fx
         QYWZRb7OYkbUB6X6lnFH2O9TrhjgRVTupWAOQM1IfgtNC5fNCl+yODaJJvEXn6pga1Kc
         uKzO33sso8FjbBiBoNZqwAF48JaTzU9waXcJXDL4zZjBOKQnvqGcLeaACZwH4tiuXjIC
         uhAxfVNBEhqfH1jg7n2O6wZb0nZvSaMwnrsQPbv71kRIRtmaJRFdgzmR+Hx0UtK/GyWt
         AHhXaP0ZGa2urgt8lzByMEeHFcW9xn/ZXtictSX3cwlFRgwdskORNUVA7WzN58ZWC5RZ
         kZBg==
X-Gm-Message-State: AOAM532rT/fJoe7Q0G2h5+lz8U0gO6PYjrRNUPpinl+HO4pYuT1mBkcu
        SxEZzgl9C/WsRDrwyKY+SeKAUgjf9yMimwb32mXxdHaFB5YIUmuy0uaxh+11BEcBdKrN8xnnVPP
        /Am04OqKP/YE6
X-Received: by 2002:a17:906:e094:: with SMTP id gh20mr37662772ejb.252.1632245919432;
        Tue, 21 Sep 2021 10:38:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG0dI4y8cwBsr6Qzl02Dh4NFyuqTM5EkeEabM8u43/L8oDrq8XZ/KwKPq32rZu6mumygWVgQ==
X-Received: by 2002:a17:906:e094:: with SMTP id gh20mr37662749ejb.252.1632245919237;
        Tue, 21 Sep 2021 10:38:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h13sm8884541edr.4.2021.09.21.10.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:38:38 -0700 (PDT)
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in
 demand_paging_test
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-2-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
Date:   Tue, 21 Sep 2021 19:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921010120.1256762-2-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 03:01, Oliver Upton wrote:
> Building demand_paging_test.c with clang throws the following warning:
> 
>>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>                    if (!pollfd[0].revents & POLLIN)
> 
> Silence the warning by placing the bitwise operation within parentheses.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e79c1b64977f..10edae425ab3 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
>   			return NULL;
>   		}
>   
> -		if (!pollfd[0].revents & POLLIN)
> +		if (!(pollfd[0].revents & POLLIN))
>   			continue;
>   
>   		r = read(uffd, &msg, sizeof(msg));
> 

Queued (with small adjustments to the commit message and Cc: stable), 
thanks.

Paolo

