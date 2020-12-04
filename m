Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BAF2CED00
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 12:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgLDLYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 06:24:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728701AbgLDLYU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 06:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607080973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2xYmq1WDTNwe1WMK0sFOwKcOwQdm9xnUmb1ObuGviYU=;
        b=dLMhL3eaFcT5uTMDquQyfdPFjoGzlTFDN204ttVa9nShLlLyDMVoTDIeo+jGvoRZkWWre/
        lfck76MySkGHd+qAkXIin5oVlmzATy+z3UVMdLw/bB3tdV61X+QFSLX0bVxKcIGSGYyTL8
        eALZ8hCC2CsGOjhW3EMdHiSq0Hy07B8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-fdO3WeWBO0STH5b9hEro5A-1; Fri, 04 Dec 2020 06:22:52 -0500
X-MC-Unique: fdO3WeWBO0STH5b9hEro5A-1
Received: by mail-ed1-f72.google.com with SMTP id dc6so2215475edb.14
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 03:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2xYmq1WDTNwe1WMK0sFOwKcOwQdm9xnUmb1ObuGviYU=;
        b=LC6VXkQF4HYvmmsi5Rtqj9Jr6oykGyCFxHoX47/sygrHj6DV4/gB3b7DAvdKZryNm/
         TEHC8HvMXEl9Rh+urYbAMX3gjOnqi5aXbfdIsXiWsAUXUKg2aG814CWaBPTH7dJoS+xF
         PAfbpgi44qN52H51WP8nhgoY+uv+8NSAIKHmpiq6fPrtodEOnyVaVlwvMU0bkFBc3hD6
         sBIjb+6Rv73OwMfmxk1DucBeetb1EDcgl1ZmoHCvvnNNTCjTq206xhJZIAfP93fwLXcO
         pfMCF5cMbEmH066Ce+phwZj4cmxTpd31rnqhUqJqC2ZI7wmKNh8WiU7wgyn5/tuaHEyx
         5l9g==
X-Gm-Message-State: AOAM532+21+J12ot9o7TolQxHgkCHllVBfhR+zMcARjWAhixO+w2UB63
        k5jsXtAqjAE6dMHvTLVZezjjJtoIydSrBWxCp4EM15mmeID2P7xNwM3eS+ctHnrRrCi9ADU5eZR
        X3kYtfNlWb0Ml
X-Received: by 2002:a17:906:6683:: with SMTP id z3mr6827630ejo.27.1607080970817;
        Fri, 04 Dec 2020 03:22:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw343SknxiSSuY0NNWzbJs4msxXhsprD6WBOFGcibn/gINRccGkPWRXPfY4u3yR4ha4Ysx8pw==
X-Received: by 2002:a17:906:6683:: with SMTP id z3mr6827610ejo.27.1607080970670;
        Fri, 04 Dec 2020 03:22:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u1sm3256230edf.65.2020.12.04.03.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 03:22:49 -0800 (PST)
Subject: Re: [PATCH v8 18/18] KVM: SVM: Enable SEV live migration feature
 implicitly on Incoming VM(s).
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a3e57c5-8a8c-30dc-4414-cd46b201eed3@redhat.com>
Date:   Fri, 4 Dec 2020 12:22:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 23:22, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> For source VM, live migration feature is enabled explicitly
> when the guest is booting, for the incoming VM(s) it is implied.
> This is required for handling A->B->C->... VM migrations case.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6f69c3a47583..ba7c0ebfa1f3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1592,6 +1592,13 @@ int svm_set_page_enc_bitmap(struct kvm *kvm,
>   	if (ret)
>   		goto unlock;
>   
> +	/*
> +	 * For source VM, live migration feature is enabled
> +	 * explicitly when the guest is booting, for the
> +	 * incoming VM(s) it is implied.
> +	 */
> +	sev_update_migration_flags(kvm, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +
>   	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
>   		    (gfn_end - gfn_start));
>   
> 

I would prefer that userspace does this using KVM_SET_MSR instead.

Paolo

