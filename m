Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78BF413194
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 12:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhIUKbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 06:31:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232137AbhIUKbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 06:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632220176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ttx288q8wLdtdWWF2QymL+a9cWj2Gh8ncjXNg61K68k=;
        b=MWekuYy8lM8RaboU4gnxfJcF3Cwo7UwqJeDHMk29rz5/iHe7ijA57EcUftkIBnOihYVH6B
        nFqokedeULybk1oW3Cm8YVGFJmxge6bQ9YWaFctJvUTuuqGfTWHpoRP7NT/McGXC9rMdVH
        0pjt5uN0HYsB0ML+csDHY4ZHbyFeh9o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-2JEnGmyKPDCmZKF1XpNh8g-1; Tue, 21 Sep 2021 06:29:05 -0400
X-MC-Unique: 2JEnGmyKPDCmZKF1XpNh8g-1
Received: by mail-ed1-f70.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so18530730edv.17
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 03:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ttx288q8wLdtdWWF2QymL+a9cWj2Gh8ncjXNg61K68k=;
        b=7zEESGmPWPCV0yGv6nYfFmwQMO8LVBMX2JwgtDW/mhu0jOQs0Orvspc2WZyn/ygu9b
         GIuiAqDkpI+pIRklwULHXh805g+4Tr+SwzyBtrXlouRTr+jj8D34+4/Qc7DrLXBormHJ
         oY8/rtfdeZTIfoca50mO8bKHhBgzBdrNRh3ku7h2eaqx8a5DtMRYxBFapAewrr7Fayqg
         AJGRXJageAYV8WjdV7CbJ6+sxaTL38S4BIlaUPqLTOqIQ9NujtWTs5m3TYUJ3j26zGtv
         xTp9JwgHeq5LjHYkMRqGAVCMq4CEbT7feUUUENjTWmyKKwPNQgoDMwz28TExoE6+gY8J
         WAmg==
X-Gm-Message-State: AOAM532UG/+w7W6k+2od1NazfZ2ZStaNIEGZQMrj1qAlm7SSw8xfDyNw
        OO88li+0IrOusDVRG8MIroIWkGguYwBmHLJAHYraN0vNQ1CFkzuAKLr/Usyq3Ey8NeiFVgBJXsv
        f5GW9y24JKg2X
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr35269261ede.220.1632220143989;
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgLRBigh5K8LJJ+14RCQJFiDpnbVVX0GBmEXBh2FC2cpkj99qZcgWH+kGe4mNA5vY3sW0rrw==
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr35269235ede.220.1632220143834;
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm7182873ejd.57.2021.09.21.03.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL
 ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210920125401.2389105-1-pbonzini@redhat.com>
 <20210920125401.2389105-3-pbonzini@redhat.com>
 <20210921101702.8672a0f1e356289e21864a76@intel.com>
 <4db02f44-fec0-b78e-b9ae-0aa41ac7819f@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c69d1eca-0175-0bbd-8902-1f7f380a1159@redhat.com>
Date:   Tue, 21 Sep 2021 12:29:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4db02f44-fec0-b78e-b9ae-0aa41ac7819f@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 01:09, Dave Hansen wrote:
>> Maybe also worth to mention userspace should guarantee there's no vcpu running
>> inside guest enclave when resetting guest's virtual EPC.
> Why, specifically?
> 
> Is it because EREMOVE will also fail if there is a CPU running in the
> enclave?

Yes, and SGX_ENCLAVE_ACT would cause a WARN.  Good catch, Kai, I'll fix it.

Paolo

