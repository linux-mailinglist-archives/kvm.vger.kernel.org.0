Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A202FD5F1
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 17:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbhATQoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 11:44:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391219AbhATQlA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 11:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611160759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQZfi4/Ce6D+3G99X+rNeEgrjpz/uKCb6ET5YSMJWLw=;
        b=IyDq4yvFsn7Vu0ecNzL8tdTCZ4BlQawsdZfIe7OPNNjjFEVffU6Unna3muqPz0+d8KSpZO
        APr0TKVPul7dgQ2HKD4/i9Sw45PmJysgAhab6QrJpL0Iajn3Y0pTT7+UiBwZwR7YOMR+4q
        nx350NFpOEWfpN38U0sBbDmHLkdFGpg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-wnjL74PrN8ar0Mm72euXTw-1; Wed, 20 Jan 2021 11:39:17 -0500
X-MC-Unique: wnjL74PrN8ar0Mm72euXTw-1
Received: by mail-ed1-f71.google.com with SMTP id o19so4668950edq.9
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 08:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQZfi4/Ce6D+3G99X+rNeEgrjpz/uKCb6ET5YSMJWLw=;
        b=PRKwHX5OHg2qYcKoLjhG/d+r+fSfPKML1D93wORJoKaspC6VqUawtDNJdQUO5mkB69
         ywwjQ+lSw58shGYRkD1osCVSHIWr+ld3h5E0AE4PUnKWTRuh5gvcQCYzV28eZICBfmg/
         pEw+p9QcbPRDTIOVCu1ygdBUDEyKmLtlWcOkXpYmpGQHtgURXVvGn03QoWlHEm2+yN4s
         uLkpr4A3hWzRCDM8x7BhjAQYPyCiygb2gRDN4oOCqIkLy4AgPZsy4uj4eRWCpxvh/vKG
         Q4KsXwA1lPe2wG73IcqCSHZbADNfCyQinKhu6d6eVCQTJZ6Lef1mmwIsebv03VzTTDvA
         CjrA==
X-Gm-Message-State: AOAM532Ii7HyxDQ83U3VcQxfBf4VDMH12CYorNd97cPXfNpopgOqCRrp
        BBMv5CLlqBkFS91nw8LxwrQGgnTKvPWPGMx1MUfERAYvazYQ8eJdhQ+nwL1EOsM/KcNk0f5QLy0
        ksc+jJbKe64HM
X-Received: by 2002:a17:906:4151:: with SMTP id l17mr6963885ejk.54.1611160755920;
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykBNkBj13lbMYLDJqbA4i/REeVCtiqYGD3w8w8hrVK4Ws+SkWQUFGojSHBZDpgHglL9Woc1Q==
X-Received: by 2002:a17:906:4151:: with SMTP id l17mr6963862ejk.54.1611160755782;
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g2sm1105143ejk.108.2021.01.20.08.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
 <YAhb1mYB3ajc2/n9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cd130cc-cda5-97d5-7c25-99fe813de824@redhat.com>
Date:   Wed, 20 Jan 2021 17:39:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAhb1mYB3ajc2/n9@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/21 17:35, Sean Christopherson wrote:
> On Wed, Jan 20, 2021, Kai Huang wrote:
>> I'd like to take this chance to ask: when this series is ready to be merged, what is
>> the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
>> changes, and it obviously has KVM changes too. So instance, who should be the one to
>> take this series? And which tree and branch should I rebase to in next version?
> The path of least resistance is likely to get acks for the x86 and sgx changes,
> and let Paolo take it through the KVM tree.  The KVM changes are much more
> likely to have non-trivial conflicts, e.g. making exit_reason a union touches a
> ton of code; getting and carrying acked-by for those will be tough sledding.
> 

Yes, the best way is to get a topic branch from Thomas or Borislav.

Paolo

