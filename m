Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E563E305C79
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313790AbhAZWqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730581AbhAZSYn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 13:24:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611685397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mTz7Xoz/xvXYECYSVr5bsWFWwC4zp+4NtN2NN+NvbGo=;
        b=ZWFW8MMLx3OVDdnmV16otIcGQqgpy1RrC5Tt1VnW8uBI+FJwMSX+ZnZsZ8bcoeVkBN/TbD
        6WLa14A2GNVIVZmD5s32MmmysSwtXgKKmyjE/FeZ+VH5xMCcTr0N162AaMerz0SOjKR6vz
        gDdfYnI3jnI2odGZZJvRj3jIvNnpFWc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-k6iah8YAOsqS9e6gFb3HLg-1; Tue, 26 Jan 2021 13:23:15 -0500
X-MC-Unique: k6iah8YAOsqS9e6gFb3HLg-1
Received: by mail-ej1-f70.google.com with SMTP id q11so5278719ejd.0
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:23:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mTz7Xoz/xvXYECYSVr5bsWFWwC4zp+4NtN2NN+NvbGo=;
        b=qEVsOtcRoLojn7pO09e1dnsqVB5B0hrO3/yvmhV5RsbDTL9YPOZYwtbJe0s/ja2UE4
         PhpaHDhlJri6LtFi/WgJvk3vA21hXSvGCKmDeC/4TOBg88X+xzmGhNuixVo1KZayrRJt
         ElZo5ccMjalBMt3iJZqs+kfiVj/6w6DUQxac6D71agWHaDPLIjMr1it+0q5cvGqPIybF
         Xe4vT5sPhoHO3hKEURXKs6YMf8EeHDRyHn+Aipo/4v+EmXPF8zrpnrb2nX2rZYxOnLby
         Y3mA2uWVD4HUTFNkykwCaqaFu7oM6jeDjS/yv6JF9oWcMEEMnYLj/CEYwsVYS2bq3ChE
         nKDQ==
X-Gm-Message-State: AOAM532hl9QJx/qIfyJUZV2osrf42bpexwqz3fl1IKkRAdHxWtW7OUaB
        LMQddySFONm2agTQnyF2+GcyTwcB1OIaER5ApaR/woM2O3B18lnkR8Cs51kfQuPhgseZy/6wN2G
        lOuUH21yoNHw6
X-Received: by 2002:a05:6402:304e:: with SMTP id bu14mr5340156edb.60.1611685394064;
        Tue, 26 Jan 2021 10:23:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr51I20o6O5R03Qzlo4pmpOKwtbS3ynzLph+LxnPczeJmRRvNM0dj1mdVqb/N74vT5qUFbNQ==
X-Received: by 2002:a05:6402:304e:: with SMTP id bu14mr5340145edb.60.1611685393882;
        Tue, 26 Jan 2021 10:23:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y2sm1522942ejd.27.2021.01.26.10.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:23:13 -0800 (PST)
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-6-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 5/7] KVM: MMU: Add support for PKS emulation
Message-ID: <0689bda9-e91a-2b06-3dd6-f78572879296@redhat.com>
Date:   Tue, 26 Jan 2021 19:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200807084841.7112-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/20 10:48, Chenyi Qiang wrote:
> 
>  		if (pte_access & PT_USER_MASK)
>  			pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +		else if (!kvm_get_msr(vcpu, MSR_IA32_PKRS, &pkrs))
> +			pkr_bits = (pkrs >> (pte_pkey * 2)) & 3;

You should be able to always use vcpu->arch.pkrs here.  So

pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : vcpu->arch.pkrs;
pkr_bits = (pkr >> pte_pkey * 2) & 3;

Paolo

