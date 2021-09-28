Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6220941B2F6
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhI1PcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 11:32:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241629AbhI1PcL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 11:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632843031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nfUMXC+UekTv9Q+thQkucTYO8+JG8hE9EwxakRMNd0=;
        b=Psi50dYZ3clqCQ2EIaZZAa6fsif4E2oz+azvVq2Q/5plXIsXMoLVZ6cs+/J8yKZAEKtj0I
        m6C9+xRTxXSQSq37uKWhUpmROd+HMJYf1BwsFq5SfefIIH/J1LvRmw7qAv+hqWX2phcZF6
        cwcrEp/MS5Fe2ym2ra+DDO1/Z/AyTPU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-DijLFa4IP3mbFOo8IUVpIA-1; Tue, 28 Sep 2021 11:30:30 -0400
X-MC-Unique: DijLFa4IP3mbFOo8IUVpIA-1
Received: by mail-ed1-f69.google.com with SMTP id h6-20020a50c386000000b003da01adc065so22212869edf.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8nfUMXC+UekTv9Q+thQkucTYO8+JG8hE9EwxakRMNd0=;
        b=RhqQpM4MwfXLPzO3P+Aqp0iJ/4+lkO+TRNxGWrye2ZM1hXDXfvfqOFh2yRD5CdKB5S
         Al11ZQ16YWp07hOkqHJVyVF5L+YVrO2IxbQ7XL5uX7xt/30gr8OvU44PfabOMzeTwZVn
         3l5qfxwIeCYz6sTEd6NaNNxt9Sp5APAappWXM68gIBZCrh7/XYrP/bILR4LaT28O57wb
         nc/EK747gvCuQ50jwyk0VjyNw/1bamxR4K8l973yieKfM4zGwPR06zpsMrurOpcRwQI8
         G09Qi4dR/QIPo1CfJfRMoPYdeMOR0pdQXiT3mfKVgERLc/eQNRP4K/WXxwKwVxJanb3z
         u3Hw==
X-Gm-Message-State: AOAM532qE4f63C1XuX0e1/YthYyyfP+cqgVgU3DNfwsVeLvrJMrhRLSD
        9Avrslfi65f+Kdjh0K0ZymlvYPSp+EleCYl9SgLGJQzE4s4pnxvMWwbPnSXByjBpeu8kGnBE3ly
        3rA2gStQ1P3hj
X-Received: by 2002:a50:d90b:: with SMTP id t11mr8138902edj.215.1632843028989;
        Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwx0Zed07mMfNcMPJp44ILJOmNEJ8xvPdh0FNEGA01duLwFDm+toq4CLSk2QmPp61IoqnU0Q==
X-Received: by 2002:a50:d90b:: with SMTP id t11mr8138886edj.215.1632843028825;
        Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d22sm10729845ejk.5.2021.09.28.08.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
Message-ID: <5fedbea6-4485-5de7-1a46-3646390931c2@redhat.com>
Date:   Tue, 28 Sep 2021 17:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923220033.4172362-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210923220033.4172362-1-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 00:00, Oliver Upton wrote:
> While x86 does not require any additional setup to use the ucall
> infrastructure, arm64 needs to set up the MMIO address used to signal a
> ucall to userspace. rseq_test does not initialize the MMIO address,
> resulting in the test spinning indefinitely.
> 
> Fix the issue by calling ucall_init() during setup.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 060538bd405a..c5e0dd664a7b 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
>   	 * CPU affinity.
>   	 */
>   	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	ucall_init(vm, NULL);
>   
>   	pthread_create(&migration_thread, NULL, migration_worker, 0);
>   
> 

Queued, thanks.

Paolo

