Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3870E242831
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 12:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHLKZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 06:25:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25211 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726453AbgHLKZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 06:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597227947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o7xZf6bRAQ1fAn5OtHzaQRhzaOM4m+C5MJxnLgV/A0w=;
        b=M7fjpYUr3yQGphKPvkT7YdheDLTF++Jce/ljt5I1reGFgZ8Es9fvBqj76z53tLXbgZMmfl
        vsYOEXQ1P4trLS6gg5ICPab870FadsW0lz75KHbEqTJE34VmNkHmN2uWChHOnjpvAxJLQX
        1S76AfEsMMpfh7UcWkIpZcJNiCEX6uI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-DXMd2W0ZPVyTdV0YvDX8QQ-1; Wed, 12 Aug 2020 06:25:45 -0400
X-MC-Unique: DXMd2W0ZPVyTdV0YvDX8QQ-1
Received: by mail-wr1-f72.google.com with SMTP id z12so730705wrl.16
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 03:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o7xZf6bRAQ1fAn5OtHzaQRhzaOM4m+C5MJxnLgV/A0w=;
        b=jSQOUb8erwgn1HplDmhGyaCZ4h9cGZV058NUEvTDG4GcjOEtbH82TzhktEvb96Yljd
         kT9DE6HwlCjc2hV4M1BiS3TTrcyY1Din1EnZt3Z44PRDKe2VNW946AtB5Y0EGbDsDqwo
         omrCjzjABt3poLQeHBj4+9aVsxU9mt4v/Yfym8tdthPgT5WuXsQWjJhfvN+Byrv/tvLz
         I5vewjybDsaN/mZh5T8WYep3bvSWtfh7Za8iJfWTyob9F2HPyS4IT9tBk7IF1kIPFlKG
         c+0CvnIrrJnuqf9bBsO+idZc4++N6EfNAeIG/mejG/LapDu1INkiWxxqEQzEnbLMfbzf
         fCQQ==
X-Gm-Message-State: AOAM533vAskqB0DXuIcvASXbmNFUNgAAEQv7RyeBY+kQmDsQ3micY/QR
        DwMs+U6j28ZXKiH0uhUJqRFkY4kiUxFXDpLZUnxg/6GHadlssoRwcMK9EYTxX4tSafegixW4XLJ
        +VhYDJsU+7SxP
X-Received: by 2002:adf:c64d:: with SMTP id u13mr3988974wrg.114.1597227944529;
        Wed, 12 Aug 2020 03:25:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVDh+Aq9bZWdTR8hkH8hhARMdwQlEpkxgYel5SlF6fjQlpnIdFxMi09Uh4ydaLsX5ip7iBcA==
X-Received: by 2002:adf:c64d:: with SMTP id u13mr3988958wrg.114.1597227944318;
        Wed, 12 Aug 2020 03:25:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:744e:cb44:4103:26d3? ([2001:b07:6468:f312:744e:cb44:4103:26d3])
        by smtp.gmail.com with ESMTPSA id d21sm3171340wmd.41.2020.08.12.03.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 03:25:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
To:     Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200812050722.25824-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
Date:   Wed, 12 Aug 2020 12:25:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200812050722.25824-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/20 07:07, Like Xu wrote:
> To emulate PMC counter for guest, KVM would create an
> event on the host with 'exclude_guest=0, exclude_hv=0'
> which simply makes no sense and is utterly broken.
> 
> To keep perf semantics consistent, any event created by
> pmc_reprogram_counter() should both set exclude_hv and
> exclude_host in the KVM context.
> 
> Message-ID: <20200811084548.GW3982@worktop.programming.kicks-ass.net>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/pmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 67741d2a0308..6a30763a10d7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -108,6 +108,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		.exclude_host = 1,
>  		.exclude_user = exclude_user,
>  		.exclude_kernel = exclude_kernel,
> +		.exclude_hv = 1,
>  		.config = config,
>  	};
>  
> 

x86 does not have a hypervisor privilege level, so it never uses
exclude_hv; exclude_host already excludes all root mode activity for
both ring0 and ring3.

Paolo

