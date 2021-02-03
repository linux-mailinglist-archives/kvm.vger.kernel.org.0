Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB5730D70B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhBCKIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:08:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233215AbhBCKIs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 05:08:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612346842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RRNWNZSEjYUISWzV/hzDQuuQn4Ann7n4iPTKBGa+3mE=;
        b=i14Mw43vVugSlpNJEWo3TOtgRLaYSm6P8mL0hgnS6F1mcZLMpWRlH0Ya0+5Qu9lPuH3ANz
        RgyfZLIaMJGCeTfkN7o3gGAIhsS85asOSGkeX6kEEAKktHGO2Hch0pQkhqeKUAnCqTdurD
        AEWcF79iI4IAeB+steQf1LH10PgtKa4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-vSdjnu0nPBCMCMoCoXFmWA-1; Wed, 03 Feb 2021 05:07:20 -0500
X-MC-Unique: vSdjnu0nPBCMCMoCoXFmWA-1
Received: by mail-ed1-f69.google.com with SMTP id i13so5140041edq.19
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 02:07:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RRNWNZSEjYUISWzV/hzDQuuQn4Ann7n4iPTKBGa+3mE=;
        b=aQWgVoERvqjdrYSMK/n0SZdHlAuJhQxD/OmFoeulLvsN4uF+7YCM31qryVTvLkYGAw
         vr3x1UUUyZmEa6g6ZMNnDu1T2mo9+SUeE+IRFNOpIgg48cXwYFI7hTfdO2Sm7HeGOBoN
         hJaDcwu13zEp8kPAFjPafDAq1TSreRhcLk8blB48xdkeQKwb/pvXx1lBQAH91OGcKsxD
         Pyh3iuGf9ffWQQSp8Qaa/VE7cfA312zSOgig7qQzPcG3+xFEq118NKQc3WWIx/zxvj7f
         zt9MI7kVDTQnG8OTT/ynWNFeAY2Ak2+s9MoW9fzZUCgyqTPn6XSKqZGXvJWJUasaIpCz
         rpuA==
X-Gm-Message-State: AOAM532L2eOuMU4+TW5gsrEQ/4ptSlT8GtQYotkEbaNouG/fx8m5rn4/
        yF5v56k8VwIon9ZW71ubZt+CfBc/EQZftmU5pA0nbOmB1K0skL82tSWa6zE8ez9CoI6zKo5yNAs
        bJasMK/FePAKc
X-Received: by 2002:a05:6402:1118:: with SMTP id u24mr2157675edv.386.1612346839147;
        Wed, 03 Feb 2021 02:07:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNBYEODxX2CDv6VeeoBShNHoVFAtymdsHrukNbtazorn38PHHEcvCDODPGT2aOTgYsyvAhjg==
X-Received: by 2002:a05:6402:1118:: with SMTP id u24mr2157652edv.386.1612346838998;
        Wed, 03 Feb 2021 02:07:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h25sm781475ejy.7.2021.02.03.02.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 02:07:18 -0800 (PST)
Subject: Re: [PATCH v2 28/28] KVM: selftests: Disable dirty logging with vCPUs
 running
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-29-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1edd4e34-5463-9802-bf07-7f4840f3d103@redhat.com>
Date:   Wed, 3 Feb 2021 11:07:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-29-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> Disabling dirty logging is much more intestesting from a testing
> perspective if the vCPUs are still running. This also excercises the
> code-path in which collapsible SPTEs must be faulted back in at a higher
> level after disabling dirty logging.
> 
> To: linux-kselftest@vger.kernel.org
> CC: Peter Xu <peterx@redhat.com>
> CC: Andrew Jones <drjones@redhat.com>
> CC: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 604ccefd6e76..d44a5b8ef232 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -205,11 +205,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		}
>   	}
>   
> -	/* Tell the vcpu thread to quit */
> -	host_quit = true;
> -	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> -		pthread_join(vcpu_threads[vcpu_id], NULL);
> -
>   	/* Disable dirty logging */
>   	clock_gettime(CLOCK_MONOTONIC, &start);
>   	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX, 0);
> @@ -217,6 +212,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>   		ts_diff.tv_sec, ts_diff.tv_nsec);
>   
> +	/* Tell the vcpu thread to quit */
> +	host_quit = true;
> +	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> +		pthread_join(vcpu_threads[vcpu_id], NULL);
> +
>   	avg = timespec_div(get_dirty_log_total, p->iterations);
>   	pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
>   		p->iterations, get_dirty_log_total.tv_sec,
> 

Queued the two selftests patches, because why not.

Paolo

