Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836CF177A8E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgCCPgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:36:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27049 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729661AbgCCPgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583249761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ujsLLzVuYTRYMxSwdOvoebiKOIVvxP1nddRp1hnsi8w=;
        b=AG67bF89heOsL1VOxmx+RKzO58Y4PQc2BFbieZ4+s2hESivstalqS8H+dozQl9cpmSi3lE
        uoGywm0ZLdWRDd4EleEUzZxVtmPtj2lppjKzMuzac1m5j6rfY1V02a2W0bnN8m9JyZb7cP
        vk3tkJrBhpItIGdyl5Pbtg5pg8SLBc8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-4N0iXehiPGK2--fx-OpviA-1; Tue, 03 Mar 2020 10:36:00 -0500
X-MC-Unique: 4N0iXehiPGK2--fx-OpviA-1
Received: by mail-wr1-f72.google.com with SMTP id m13so1391968wrw.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:35:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ujsLLzVuYTRYMxSwdOvoebiKOIVvxP1nddRp1hnsi8w=;
        b=KMNjwRMpk+nlfMW8kzyBQNJVYPTltgGUNDCY+aepGCaxK6rvlj+TKrLcy6bFAxE9Me
         YmWeD0FpGvPqnfbZ7eRRzQxvlYd5fM3SfMTh6rcD9oOfl0MiNwe5hpDfTNMRAu4UlMD3
         1dO5AItRNaEj7zbNpKMxecWXHPf/tVtLKhKxlQtWf0lk6aR6uiH/F0BLm4AQwwDJ8yZn
         jrQuqP/2ZKrlNsU9FRFM7Cc8aFbUUo6R/qIlEq61IbdQlH57SqF72CA1OuCVRw1cGScO
         UJ6aRukDKb1X3S7sPt3T3uXV+rbRVL6B9tMS0GG7UzkAIII75qC9Z60wPhAPYOxl1a0L
         Mmrg==
X-Gm-Message-State: ANhLgQ28IwrA064J0tHxsaGhToI9lLFPz5JEhofPrS8Zafo+jTGA9GVG
        VebU6ocoOUoIkalfaORQtR2kctVFTozCL4rm24YUtPz3I38pnBEiUH38Nw+bGUgGIF1VsebJafQ
        DfNH81Q/qnVv0
X-Received: by 2002:adf:fa0f:: with SMTP id m15mr6386525wrr.392.1583249758943;
        Tue, 03 Mar 2020 07:35:58 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtXOdsBuRFJDRHIa5TRjfWnThT4qNW6T0BPy5J15OWGLpEe3lKOi93Q21PvbTbxna5Yu0DsqQ==
X-Received: by 2002:adf:fa0f:: with SMTP id m15mr6386514wrr.392.1583249758741;
        Tue, 03 Mar 2020 07:35:58 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id f3sm3777601wrs.26.2020.03.03.07.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:35:58 -0800 (PST)
Subject: Re: [PATCH v2 66/66] KVM: x86: Move nSVM CPUID 0x8000000A handing
 into common x86 code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-67-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d2b5256-5c00-54d2-8f73-c78d54b23552@redhat.com>
Date:   Tue, 3 Mar 2020 16:35:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302235709.27467-67-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 00:57, Sean Christopherson wrote:
> +	case 0x8000000A:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +		entry->eax = 1; /* SVM revision 1 */
> +		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> +				   ASID emulation to nested SVM */
> +		entry->ecx = 0; /* Reserved */
> +		/* Note, 0x8000000A.EDX is managed via kvm_cpu_caps. */;

... meaning this should do

                cpuid_entry_override(entry, CPUID_8000_000A_EDX);

shouldn't it?

Paolo

> +		break;

