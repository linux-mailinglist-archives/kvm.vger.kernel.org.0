Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B130C299
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 15:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhBBO4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 09:56:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhBBOzL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 09:55:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612277623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63iUIFUeXpHPrYf2eKlD+tbc5HBRhOL3GBF5o8JxTlk=;
        b=YAIHievJV8EColRfuahcyQYU28SojQcAt383QVb4zkTI8ldVlpAsGSCW/4CwcRyQuBa1Ig
        WLSeOOWDt+KSD3KdDDt2oI1Ms8A5Lo7cXYWBqawCNRNs8U4jst7xwB9dnw63nWbdXyW5Ja
        aEIi2EFQDa5/NMr2dSbY80/KgL0yvEk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-VENP4xeaMg-27EYHAKipFw-1; Tue, 02 Feb 2021 09:53:42 -0500
X-MC-Unique: VENP4xeaMg-27EYHAKipFw-1
Received: by mail-ed1-f71.google.com with SMTP id v19so9696087edx.22
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 06:53:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=63iUIFUeXpHPrYf2eKlD+tbc5HBRhOL3GBF5o8JxTlk=;
        b=jLm3si9G3ejyv88jlRRcaNL0l00FlhmLq7HL08SUlhI0Gg4F2S614lihVCX4/xfsVT
         ZW7Tp19XVFDV+s9dQWgRNnrb3tX4a5mNJm96iuiedK03IBfQHJKadzt/XaFnz2Q3ZzVX
         5yg0/17kHgN3uEtHCU9Xdb6h6tqsZQqmPtyLTV7Ht34l4FSNtFhJqwfo+eVZ20rUQnAC
         ZVCUEUGW35YFw3zExbBZ+sKr5tjxdmoKdNslNArqw4gXLBtrhIdC19XD/3tEUx0qKx1f
         s2LKyaOPqXKXjTPcfxKSCCEnKAXIjsPIs0T9Pbz6dqQBg5g2DJThaGAdQDMzbeXgNFyL
         pvuQ==
X-Gm-Message-State: AOAM5318O78iYGQvR/1qWjyYr/Fk9axmUCTU1An5T0nzIX3TOARqYJ6m
        Jmp4r70JM8XHjD2iyIZvS4Q96TZzoBmPWehF7GAd+Qgn+Z5R7tdnku/0j3XEOUtmnlggSZ8/lhz
        pjXPpby1K03us
X-Received: by 2002:aa7:da98:: with SMTP id q24mr24166761eds.370.1612277620975;
        Tue, 02 Feb 2021 06:53:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxS9mIrFl6AZTBNvZUMHlM02ABoapOleP6I0hNt3ggSqA97e6S5oPNkoPpxyqUQzT6OIB0y9w==
X-Received: by 2002:aa7:da98:: with SMTP id q24mr24166742eds.370.1612277620810;
        Tue, 02 Feb 2021 06:53:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x17sm9996283edd.76.2021.02.02.06.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 06:53:39 -0800 (PST)
Subject: Re: [PATCH v14 11/11] selftests: kvm/x86: add test for pmu msr
 MSR_IA32_PERF_CAPABILITIES
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <20210201060152.370069-1-like.xu@linux.intel.com>
 <20210201060152.370069-5-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f77954f5-02ad-8a40-d7d3-31614628b007@redhat.com>
Date:   Tue, 2 Feb 2021 15:53:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201060152.370069-5-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 07:01, Like Xu wrote:
> 
> +uint64_t rdmsr_on_cpu(uint32_t reg)
> +{
> +	uint64_t data;
> +	int fd;
> +	char msr_file[64];
> +
> +	sprintf(msr_file, "/dev/cpu/%d/msr", 0);
> +	fd = open(msr_file, O_RDONLY);
> +	if (fd < 0)
> +		exit(KSFT_SKIP);
> +
> +	if (pread(fd, &data, sizeof(data), reg) != sizeof(data))
> +		exit(KSFT_SKIP);
> +
> +	close(fd);
> +	return data;
> +}

In order to allow running as non-root, it's better to use the 
KVM_GET_MSRS ioctl on the /dev/kvm file descriptor.

The tests pass, but please take a look at the kvm/queue branch to see if 
everything is ok.

Paolo

