Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AABF267B75
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 18:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgILQwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 12:52:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725838AbgILQw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 12:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599929545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1i+tRnD/Pinc/Vxe3A21hdWo97zYy4i/YlaOs9ixmA=;
        b=B+FB99/HC/L7kRiGTvQM967pIFQ2B/cAAaeIq6T8IJw1sZ7E085He2yRkrWNlGhBP3h2u3
        hmECOxEoghXqxdNO+1lMIVe/GUMK/yNuG+IE2SKZDc/Z2i7NDQX3InQ5W762ScljDKm6fr
        1Mqcc9zqxVNaViIGKQLwjYvJB9Z+xN4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-gl1gxUqAPHWEl62RwHYnFQ-1; Sat, 12 Sep 2020 12:52:23 -0400
X-MC-Unique: gl1gxUqAPHWEl62RwHYnFQ-1
Received: by mail-wm1-f69.google.com with SMTP id m25so1848080wmi.0
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 09:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1i+tRnD/Pinc/Vxe3A21hdWo97zYy4i/YlaOs9ixmA=;
        b=ME18Hl2LGOAaBLC8HN45cgvTKu4cDCF04I4Oy07ISJDpmbx0qJMnrEnUDXjYQjjQTc
         HLUVrQOXjGa2LXnJqPmrU/Ha9q0d9z9QusPX1zLnlPnJpIJKld08Wjojs6JP0EwMq2Cp
         VC9f2/IRBm8jMr7agkNHHYJDw1NemKNaxkqw23Xypd1NjToADv+g6HIE8jvbXzldJY4G
         uts5WslBX8L6n/rdr071gXzpQTUbjwtoRpMWfXNqg6fTPb7rRrWzWYYDhawyJsOHHNWo
         1+BPt1JXFMUtf314JXtM/aFygj1x4TSQOobf9fdg8Tl7GNGM/+rWEPPjVxhvkTLfKVJj
         hzKA==
X-Gm-Message-State: AOAM530YHHufNbAVZcCy7KzhC641AUgblIX4aqQGGPkWbIq0UP3rsSz6
        bpinuYCxKxEteUrIByOyMqNVW+181Jt80tHGGdSHQM5kQMbpeQyEGgrZqcLXhxKFnT1yvbAI0lm
        FB6ziLjuifFoh
X-Received: by 2002:a1c:2543:: with SMTP id l64mr7147047wml.96.1599929542005;
        Sat, 12 Sep 2020 09:52:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0dg+YHQj+TRcLDt2n8FPsN7Qa+ebcOURMGqwY+M6Mj9h+GWE/XZW5TAev48TdVLTD9KHx6w==
X-Received: by 2002:a1c:2543:: with SMTP id l64mr7147038wml.96.1599929541809;
        Sat, 12 Sep 2020 09:52:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9fd9:16f2:2095:52d7? ([2001:b07:6468:f312:9fd9:16f2:2095:52d7])
        by smtp.gmail.com with ESMTPSA id y5sm10962968wmg.21.2020.09.12.09.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 09:52:21 -0700 (PDT)
Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
To:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
Date:   Sat, 12 Sep 2020 18:52:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 21:28, Babu Moger wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1a5f3908b388..11892e86cb39 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1003,11 +1003,11 @@ static void init_vmcb(struct vcpu_svm *svm)
>  
>  	set_dr_intercepts(svm);
>  
> -	set_exception_intercept(svm, PF_VECTOR);
> -	set_exception_intercept(svm, UD_VECTOR);
> -	set_exception_intercept(svm, MC_VECTOR);
> -	set_exception_intercept(svm, AC_VECTOR);
> -	set_exception_intercept(svm, DB_VECTOR);
> +	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
> +	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
> +	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
> +	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
> +	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);

I think these should take a vector instead, and add 64 in the functions.

Paolo

