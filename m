Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EB81AAA88
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 16:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636749AbgDOOms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:42:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636613AbgDOOmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 10:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586961751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcswj4fMIzy1VSkpe0j3kCHXPaYoyRFwnxHUU0e019I=;
        b=X/VB/KtIlPs8RqKvLkqQYahNrzV16JhtmeJ1N037/IwNDMekMuzIvmYShQlgwGbBj1Yx+d
        j5AprWri9WbEf9UdvBoVRRtGrMwkqSf8RkadhSi/MqjeX7Nz0VBu9xU2DxGLOHJTXuyaPT
        YON+/iJQe1STB9nSPqNq6CXVbChqNho=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-jm1NhmyLOWmDv2yC-hLSfw-1; Wed, 15 Apr 2020 10:42:30 -0400
X-MC-Unique: jm1NhmyLOWmDv2yC-hLSfw-1
Received: by mail-wr1-f69.google.com with SMTP id f2so14951wrm.9
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jcswj4fMIzy1VSkpe0j3kCHXPaYoyRFwnxHUU0e019I=;
        b=nfsYfn4omdLmJsyB+SKsOWtcBFBlbjFZ1XQfkzCQFYbroMyBWvJXhxUFzJVw9wc3ev
         EfzLRIB4KOYTHd6sSqilnaB2YZGD5V2j5yXTIGrZ6ay6l6e7xPv+ldKD5LpGjoMFzyGL
         629DLMDXpmSsCArqH3fB02mI6IsvbR5loMbFB+a8OsRCsDkrOdhoD1v2qVxuD1y26CHd
         /hRXqnSCgpfHpM+aN/XPBbEEzyhNJLaJkmBfJKBFzBlZkuKtgjtRNFbD+kNMWcXdPN3A
         1yBX54Mrm8qe4O99cnjHVlBMtKPWIStZ9jGxhz00oDCRWVbNZPMtQUf0hgaBJJWf3Wnj
         C/Iw==
X-Gm-Message-State: AGi0Pub69sIoRM9dyVVOTXf0Uhwgsnejz8l7l/f79HcqomUOqW94bwqL
        GosMl2+GH/gen5tYkEcHGoRJuu0sC+ww7RlVatrSh/gfUasb+Bgki5CaWcX5NtRRXM1r7QpATpa
        zZiDAdrS+M0BT
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr23228101wrv.314.1586961748851;
        Wed, 15 Apr 2020 07:42:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypLhnFTufVnEV7mvMNC3KmCyW/b8aBHad2cdYj8UeBTDu5XbSSHNUq+WhQ9qWV0NLZkASnsJHg==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr23228081wrv.314.1586961748565;
        Wed, 15 Apr 2020 07:42:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id j11sm2090904wrr.62.2020.04.15.07.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:42:27 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: make steal_time static
To:     Jason Yan <yanaijie@huawei.com>, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hulk Robot <hulkci@huawei.com>
References: <20200415084939.6367-1-yanaijie@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1700173-29c1-2e7c-46bd-471876d96762@redhat.com>
Date:   Wed, 15 Apr 2020 16:42:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415084939.6367-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 10:49, Jason Yan wrote:
> Fix the following sparse warning:
> 
> arch/x86/kernel/kvm.c:58:1: warning: symbol '__pcpu_scope_steal_time'
> was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  arch/x86/kernel/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb72..f75010cde5d5 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -55,7 +55,7 @@ static int __init parse_no_stealacc(char *arg)
>  early_param("no-steal-acc", parse_no_stealacc);
>  
>  static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
> -DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
> +static DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>  static int has_steal_clock = 0;
>  
>  /*
> 

Queued, thanks.

Paolo

