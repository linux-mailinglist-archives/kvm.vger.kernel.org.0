Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FF21CA78D
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 11:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgEHJvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 05:51:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726908AbgEHJvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 05:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588931463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBP012LisVeq02MvD+mTCJEz8/IbuMae8oTpvqKDdT0=;
        b=DjzvJY0v9ftwkcTE+68k8/P6W4kLe7hOfhIl24EwvsawSldmvBASWUTprBklzhVR+wKZs5
        ozr9cpNitA5CfGN6keP8CFjqg/kgmPp9aQz0HwUSnEDWeYWXZl3R6+db/EYcB5ZQkzytja
        ZqDOtbr/1987eUSbrYrwiMJHOqMwVvU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-DQeQpLs6MG6N5iEywvqZMQ-1; Fri, 08 May 2020 05:50:59 -0400
X-MC-Unique: DQeQpLs6MG6N5iEywvqZMQ-1
Received: by mail-wm1-f69.google.com with SMTP id j5so4920789wmi.4
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 02:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yBP012LisVeq02MvD+mTCJEz8/IbuMae8oTpvqKDdT0=;
        b=srcKA1rmFBOkIejSak+65tcwSMZtKLOwahW/RGAV+Ilyrd+8WoAPdN5T1RGkEb0M3I
         k1wLIY79pywAic0fL1Q4YVMzwyVwZq/Uofjz5gB2RviI3RLXG8Q7KmMMeao2bAWt/zk2
         6qQUEzVrH7WjGvPPMxN3z5+ZEAY5fH63KuTA1X2Lyq/K2ZeEcJsCtlLFkmKBZOjTw8Rq
         5lb6vxb9UEgiMeCMPJLxufMWHGTti6qJRhYzz844FYCGAJSlrmnI/hLqotcMqfSpIrUu
         jOGv59txV5SSy+5KjSPsL3vJlsKs23BBbZIiqMlF6Imb8wbeIPykko+igyjH4epoAD4p
         CT5Q==
X-Gm-Message-State: AGi0PubNCFibIcEuRV+Z0kYMyicmWKIU2OFfAJb810OTLxZarMSFWebd
        3mcVO9knbmb/5OWuWTYyxYo77CFBrBormgKOn/YX0GtuyBWGn9mU3IAWhDdFKf7QrkRKLv5N40M
        1ryl71Qar7H71
X-Received: by 2002:a05:6000:1244:: with SMTP id j4mr2010702wrx.189.1588931458111;
        Fri, 08 May 2020 02:50:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypIWXmDNhLC5gO9SMkwG5Lh6nz7g8uF7L7LsK3nzgsXIOvFcFCFkDeit0JOLiJZCVVFzWCUN/A==
X-Received: by 2002:a05:6000:1244:: with SMTP id j4mr2010670wrx.189.1588931457883;
        Fri, 08 May 2020 02:50:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:20ea:bae4:47a7:31db? ([2001:b07:6468:f312:20ea:bae4:47a7:31db])
        by smtp.gmail.com with ESMTPSA id z1sm12491316wmf.15.2020.05.08.02.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 02:50:57 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: x86/pmu: Support full width counting
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508083218.120559-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com>
Date:   Fri, 8 May 2020 11:50:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508083218.120559-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I would just do small changes to the validity checks for MSRs.

On 08/05/20 10:32, Like Xu wrote:
>  		return 0;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		*data = vcpu->arch.perf_capabilities;
> +		return 0;

This should be:

		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
			return 1;

>  	default:
> -		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> +			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>  			u64 val = pmc_read_counter(pmc);
>  			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
>  			return 0;
> @@ -258,9 +277,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 0;
>  		}
>  		break;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		if (msr_info->host_initiated &&
> +			!(data & ~vmx_get_perf_capabilities())) {

Likewise:

		if (!msr->info->host_initiated)
			return 1;
		if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
		    ? data & ~vmx_get_perf_capabilities()
		    : data)
			return 1;

Otherwise looks good, I'm going to queue this.

Paolo

