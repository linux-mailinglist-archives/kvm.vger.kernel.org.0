Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F0E2B22A0
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 18:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgKMRgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 12:36:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbgKMRgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 12:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605288977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAWOiKNPr7NdH0SfoGuNiXpNKXaZRwcJVJ3a0/q6UEM=;
        b=e5uhfzVoUMb/fohDY/ulqI3l1q+L4e/pKIuQquEbltKGeqbQUJsz5qNVloHnva5ou/zBd3
        L24bqSC6/jR+RZD8gRCOhg6o3yK6FWci692ZdsPAEObQ8F+0Gp0DvchL/9hR3XjyqQeyQO
        zOqCA2DmWtDNj+66P4GpyMpCyhmxGpw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-SWgHEAvcNpKnxp3GKnOf1w-1; Fri, 13 Nov 2020 12:36:15 -0500
X-MC-Unique: SWgHEAvcNpKnxp3GKnOf1w-1
Received: by mail-wm1-f69.google.com with SMTP id 3so4281439wms.9
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 09:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NAWOiKNPr7NdH0SfoGuNiXpNKXaZRwcJVJ3a0/q6UEM=;
        b=jahg2A6nSQntSTbvvw5t8bJfIikYwVLYbkqfvEbNqNZbaHocx60S8/9pa0B1Hp8LJd
         lnEl7MB84KS3MWbEZOqh3DpO/qkr4mqQ7t1sRV9GoyUsZ6Pe+FoqOQWHI74IGJsxmhvs
         7oKIPEkbZL75NHQTx2GJo9nr68H72xmnAYLK5pB6F7NtR/OWVaQEJ30NKiEqb10bxA2W
         huhjG9tUrYaqWpav2L+JOTXByojfFIGw6rOX0F59mmOvoHoT2xr+W3ewEyfeU4siWSfW
         k+GIKCtyxn26xcuZTILZA8ACoz0JEf88PwPf36UqLOKTrDdZvpphyvia2+u3VNRtfqBq
         C9fQ==
X-Gm-Message-State: AOAM533BkHfnrfvDkmBiKLx9NEJLumRhBe/7dns70M9q70udIJgT7HX0
        FBNAJAgXETtQVNGhTBJbDdEzcuDNwXLU2isolJ1oLidQX6pQLXb2NyZaN6MAWJc7trLG2C8ZbeQ
        9hh0fLgATDBMB
X-Received: by 2002:adf:fc01:: with SMTP id i1mr4829859wrr.250.1605288969425;
        Fri, 13 Nov 2020 09:36:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0vudkfKU4Xydr2EdpA/kzp9pTcHNEHyW7SYCAkCMGeUkCOR26XxFLcWnUl7631MBD2ZKN5A==
X-Received: by 2002:adf:fc01:: with SMTP id i1mr4829446wrr.250.1605288964464;
        Fri, 13 Nov 2020 09:36:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d63sm10940123wmd.12.2020.11.13.09.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 09:36:03 -0800 (PST)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-3-cavery@redhat.com>
 <20201013013349.GB10366@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Use a separate vmcb for the nested L2
 guest
Message-ID: <f3268301-6cbd-904e-949c-7ccc4a2e5d36@redhat.com>
Date:   Fri, 13 Nov 2020 18:36:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201013013349.GB10366@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/20 03:33, Sean Christopherson wrote:
>> +	svm->vmcb = svm->vmcb01;
>> +	svm->vmcb_pa = svm->vmcb01_pa;
> I very highly recommend adding a helper to switch VMCB.  Odds are very good
> there will be more than just these two lines of boilerplate code for changing
> the active VMCB.

Yes, probably we can make svm->vmcb01 and svm->vmcb02 something like 
VMX's struct loaded_vmcs:

struct kvm_vmcb {
	void *vmcb;
	unsigned long pa;
}

I don't expect a lot more to happen due to SVM having no need for 
caching, so for now I think it's okay.

I have other comments for which I'll reply to the patch itself.

Paolo

