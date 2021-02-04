Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255DF30F0FE
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 11:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhBDKgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 05:36:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235541AbhBDKfv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 05:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612434864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qWsTxPld0hEiuoxPO/c9bHf318nkKx5uc/Fo065i5o=;
        b=eX0XstRma04SuH5MXhG4C+1CcxQ2nEBABjslqRKUAMkXfRJkEKteZ2PHIdlLDqFxn+Tt3o
        FdtBCP8veTSamJ6CDTpfAJI2MRclMiVnt8wf9s3PiXlFojQtM2AjYqIBpmCHp3dym83g6F
        rIiYy3/uGhCv7WtNL59Mp0Qsy3I5cas=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-92DsSShtM1eMRG1MOemq1g-1; Thu, 04 Feb 2021 05:34:20 -0500
X-MC-Unique: 92DsSShtM1eMRG1MOemq1g-1
Received: by mail-ed1-f72.google.com with SMTP id t9so2576070edd.3
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 02:34:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0qWsTxPld0hEiuoxPO/c9bHf318nkKx5uc/Fo065i5o=;
        b=E5VHihT6/8axuLDv5HSJ/aU1a+T4Ds4gKyq7fvK17yt0U/xJTZ5CdeIudX2/5umbX7
         wzylBuLJxbDa1CjhggEmuL9RYc8nPKieRO3UX0G1/+d+xWFMoocy+6/X3hL3CUdLORYd
         mlQiADglTYDNjBBV6bRCUWOXA2N/ppksGRuDjU7T+9Rq9Cv8aiiGUwWpmMxqKqpNgMT1
         N8FooKtJJDKlqFkUR0qRSYyM2ss4EksSb4LGTlRvORdaIQuoIjB8rxFhvGv3g7ePqHfE
         aLHmLeKAM/cimydHKcsTp0zvs1X4lws1VQdq9Z/w1HJxSrFGNs8dmRQ+Y50Ous5tPKW6
         4EOg==
X-Gm-Message-State: AOAM531u1fJhcEqLLvl93PeJTXe3B6J0G3tzMyZ0H7TE/K/peKAS9g/p
        aymBKn9nZb4MBu6u5PmJGB5wqGs7Cl7vk3M/t1tH1u/VSaqiSfOZISccRja9TEcSMafIKeGu6Wx
        n67HEF2petCmP
X-Received: by 2002:a17:906:607:: with SMTP id s7mr7339844ejb.301.1612434859654;
        Thu, 04 Feb 2021 02:34:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyc26Db+8nKxp1WBsWO53i+fnEOMalBbhvFAN6L3W4Yk/kUZ3BoXarC4Jw3AV0aCs9W+kOHmQ==
X-Received: by 2002:a17:906:607:: with SMTP id s7mr7339829ejb.301.1612434859465;
        Thu, 04 Feb 2021 02:34:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r3sm2232360edi.49.2021.02.04.02.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 02:34:18 -0800 (PST)
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
To:     Sean Christopherson <seanjc@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
References: <20210204000117.3303214-1-seanjc@google.com>
 <20210204000117.3303214-8-seanjc@google.com>
 <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
 <YBtZs4Z2ROeHyf3m@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
Date:   Thu, 4 Feb 2021 11:34:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBtZs4Z2ROeHyf3m@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 03:19, Sean Christopherson wrote:
> Ah, took me a few minutes, but I see what you're saying.  LAM will introduce
> bits that are repurposed for CR3, but not generic GPAs.  And, the behavior is
> based on CPU support, so it'd make sense to have a mask cached in vcpu->arch
> as opposed to constantly generating it on the fly.
> 
> Definitely agree that having a separate cr3_lm_rsvd_bits or whatever is the
> right way to go when LAM comes along.  Not sure it's worth keeping a duplicate
> field in the meantime, though it would avoid a small amount of thrash.

We don't even know if the cr3_lm_rsvd_bits would be a field in 
vcpu->arch, or rather computed on the fly.  So renaming the field in 
vcpu->arch seems like the simplest thing to do now.

Paolo

