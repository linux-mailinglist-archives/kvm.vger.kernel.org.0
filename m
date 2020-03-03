Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9CE177AEA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgCCPrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:47:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39059 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729789AbgCCPrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583250472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bG7spyj/jPjRcn2UnTtv+KAPrRp318NfiqYCxbBVCsY=;
        b=MoDpKX0eX+Nf6KbZqXn/b1+PjCrE7OtD0HCrFswmaYTdRFnUBlksSDknp/XllRaaxTTsp5
        ckZ1C85yJ1mv9slVqLq35FidgriX6Tgayn1OIU6tAKT/7uuxeUlQkmXC3W8tADEYf+onEO
        Ir6IAJwit9JbAUO6pkBIRy2BksZ/8Sc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-aW3ntaGjOc-c67KdNgP-ww-1; Tue, 03 Mar 2020 10:47:50 -0500
X-MC-Unique: aW3ntaGjOc-c67KdNgP-ww-1
Received: by mail-wm1-f69.google.com with SMTP id j130so1253005wmj.9
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bG7spyj/jPjRcn2UnTtv+KAPrRp318NfiqYCxbBVCsY=;
        b=YVARY97lAmuIErv1WrSjDBp4WSqdfQcjvh7dZB4YtXaSa2Cr8rOn6J+GWQR1uKpSZc
         Bsz3XQkBdSakMuEUVDbIHGgQSeZY/wo6wHJoJQxY3CW6S3GNlb8uFk+tMjlxjaj9tLEB
         FK49aCbRHNENmtgQlxhXJU7SptVWg6iF5ZjPvr3NX0xy3OdUdAfpc5AVE6inzlyTyok3
         UGOeIbGoQeSOnCGF2j2JSS4ut5kKFWJZChL6B0pKAuWNc+kodf4pRRIfq3X/VdbHrHOG
         1xRRCzEA3JV959EnUDlkX96pX3SO6f/APcxyxtSkW9FKptWa852Dtcq8VWQYme4hYXDI
         5xqA==
X-Gm-Message-State: ANhLgQ3HqV+VeT+rUeYIEfMwdhQomLU/SIOKbseXdQPMeCK9PDBgUbFq
        wp300T9iA2gss1rndvMV1prKO8NDMfp+ayypPfApIFJ3lEBWdtz2up2eSGer3gpD1sgcRj5IaFE
        uVdOdd+3kimbP
X-Received: by 2002:adf:f84a:: with SMTP id d10mr6193505wrq.208.1583250469314;
        Tue, 03 Mar 2020 07:47:49 -0800 (PST)
X-Google-Smtp-Source: ADFU+vurPs03BOzNDPspE899csrvDYsx6LhbVx0i31qdR5zsRxPUfjTQbsqbQsY3PprBfki9zN9/ww==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr6193486wrq.208.1583250469102;
        Tue, 03 Mar 2020 07:47:49 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id y139sm4796973wmd.24.2020.03.03.07.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:47:48 -0800 (PST)
Subject: Re: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for EPT
 in VMX code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-37-sean.j.christopherson@intel.com>
 <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
 <20200303153550.GC1439@linux.intel.com>
 <c789abc9-9687-82ae-d133-bd3a6d838ca5@redhat.com>
 <20200303154453.GF1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21298366-2604-186d-1385-c2a04c74bad7@redhat.com>
Date:   Tue, 3 Mar 2020 16:47:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303154453.GF1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 16:44, Sean Christopherson wrote:
>>> Oof, that took me a long time to process.  You're saying that KVM can
>>> allow the guest to use GBPAGES when shadow paging is enabled because KVM
>>> can effectively emulate GBPAGES.  And IIUC, you're also saying that
>>> cpuid.GBPAGES should never be influenced by EPT restrictions.
>>>
>>> That all makes sense.
>> Yes, exactly.
> I'll tack that on to the front of the series.  Should it be tagged Fixes?
> Feels like a fix, but is also more than a bit scary.

If you don't mind, I prefer to do the changes myself and also fix the
conflicts, in order to get my feet wet in the new cpu_caps world.  I'll
push it to a temporary branch for you to take a look, possibly tomorrow.

Paolo

