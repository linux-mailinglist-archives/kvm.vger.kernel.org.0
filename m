Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385CB12780E
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 10:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfLTJZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 04:25:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56130 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727269AbfLTJZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 04:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576833918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LsxcLVbBun1f96xBFFfgPOlzuKGlq4r29EdM+SsmX7k=;
        b=XCSvcuHZl4fYpSg3+lJGo7wB9zu/5eGQ/Sk161B0dNiEKY/TWOPMT4PKIswsjbfsgWmozX
        30WcZ2NxviW42XxYvpMCXrNS4PQvI3F//kMadPHcURTdX5+TGwZjCutY6tAVNbdh0tM9XC
        VNIv2l6v3eIrXbxeJYOQ8yICFjiWQr0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-MV1GUbcFPF2micIZKGBcEw-1; Fri, 20 Dec 2019 04:25:17 -0500
X-MC-Unique: MV1GUbcFPF2micIZKGBcEw-1
Received: by mail-wr1-f70.google.com with SMTP id d8so3541787wrq.12
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 01:25:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LsxcLVbBun1f96xBFFfgPOlzuKGlq4r29EdM+SsmX7k=;
        b=sYN+cC2Ufh555lfoslo1B8yvLOfxwBnZrwT/QDojDwuIMeF9gQ1dvsD4qwTTMejM05
         SBaIvV0hv17qJlFyyxGow13RMRgT5+iaOU98cxy5LzkbK0rn0o3qKIWzvdA9bKTqe4xR
         QhUu8yl8UEYXmKT38dhDT6unYwu0eKjYMCns9r78ZjmCjoOURdCL3wwRg2wmnWjTScix
         bPAUgBdboAz3tdhOxXSreKemhNLsVwjeVuRoknLbU8un+m03IWX6zOTwZqv9OFkED1Hj
         5LpDtNq7jlRHf1rKyJZur7w6f2hZvWZCtXdG7lcdipE5ayiOIch6HBVhZ/H9UASO0eLt
         kZ5Q==
X-Gm-Message-State: APjAAAVP4DyTunflxMxIfR/5vnL7SOrAmLCXWySqadt3L9pzgPLL3w/V
        6NRYCJv8DaTL9WIXDLg2i6WlqWVUFqlKnbB6j0JcYHNxcQvLk03adw2g3ZZR/22WQLWBB0kAFlC
        npX9pff3UcE+r
X-Received: by 2002:a05:600c:246:: with SMTP id 6mr15371256wmj.122.1576833916357;
        Fri, 20 Dec 2019 01:25:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqzw8wZPLS7TkKIeuMQ4kT47hh6TgBs/pAj1q7SP7litoY6M7b4efDd9KnpDPbJZMMJOaN3lqQ==
X-Received: by 2002:a05:600c:246:: with SMTP id 6mr15371232wmj.122.1576833916119;
        Fri, 20 Dec 2019 01:25:16 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m7sm9097969wrr.40.2019.12.20.01.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 01:25:15 -0800 (PST)
Subject: Re: [PATCH v2] kvm/svm: PKU not currently supported
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, vkuznets@redhat.com
References: <20191219201759.21860-1-john.allen@amd.com>
 <20191219203214.GC6439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a77e3b9-049e-e622-9332-9bebb829bc3d@redhat.com>
Date:   Fri, 20 Dec 2019 10:25:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191219203214.GC6439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/12/19 21:32, Sean Christopherson wrote:
> On Thu, Dec 19, 2019 at 02:17:59PM -0600, John Allen wrote:
>> Current SVM implementation does not have support for handling PKU. Guests
>> running on a host with future AMD cpus that support the feature will read
>> garbage from the PKRU register and will hit segmentation faults on boot as
>> memory is getting marked as protected that should not be. Ensure that cpuid
>> from SVM does not advertise the feature.
>>
>> Signed-off-by: John Allen <john.allen@amd.com>
>> ---
>> v2:
>>   -Introduce kvm_x86_ops->pku_supported()
> 
> I like the v1 approach better, it's less code to unwind when SVM gains
> support for virtualizaing PKU.
> 
> The existing cases of kvm_x86_ops->*_supported() in __do_cpuid_func() are
> necessary to handle cases where it may not be possible to expose a feature
> even though it's supported in hardware, host and KVM, e.g. VMX's separate
> MSR-based features and PT's software control to hide it from guest.  In
> this case, hiding PKU is purely due to lack of support in KVM.  The SVM
> series to enable PKU can then delete a single line of SVM code instead of
> having to go back in and do surgery on x86 and VMX.
> 

I sort of liked the V1 approach better, in that I liked using
set_supported_cpuid but I didn't like *removing* features from it.

I think all *_supported() should be removed, and the code moved from
__do_cpuid_func() to set_supported_cpuid.

For now, however, this one is consistent with other features so I am
applying it.

Paolo

