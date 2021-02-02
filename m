Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5763E30C8EE
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhBBSE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:04:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238158AbhBBSCY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 13:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612288856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Xo/ste6mcKDasiY2TP0mhB7WxKM/bwzUGagnvWcl28=;
        b=SkPNDDVVJcCdC8jqCcL2Fh8Y/QRIJjgrRFNo2Gxbctw8hFP+ox7+gXU9VIsMJNdGMcFTVI
        p1DEAlhBBUwhmovkN+kAn28bCjDpmysrFCU8vOHYj24mBKfT0244d8kPjYgRJnk5Yiqz42
        OZBg3JNti7SHQR7SUy3GTQvnw/X/S5U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-bmF1xmGiOiqsROgA6dsmzA-1; Tue, 02 Feb 2021 13:00:52 -0500
X-MC-Unique: bmF1xmGiOiqsROgA6dsmzA-1
Received: by mail-ed1-f69.google.com with SMTP id o8so10031246edh.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:00:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Xo/ste6mcKDasiY2TP0mhB7WxKM/bwzUGagnvWcl28=;
        b=ExeY/chN8h6v1/V7C3or6bWDfl2WmgqsNfYQ6VGvNuJTycuGCDY3Y357I7H1kuw3z1
         g+xKqNfEqLwfGubecdmO+ZlsUFPeTUczU+vT7ejOoklwAmHnG/wRQgjhbr9RVeitdhpw
         y7csdTudh+Cana0jW6vvcLwspkzY1PgUaP9lEMhazuSJ4Qpoq6VGieg6f7Z1LSNcYP17
         r9I+wXH7hz8JRxlF/7uURRrO4M3JRJ1l4PUl4SaBZ8eoBQog3m008HflKNtngJ0TNnfV
         C5+ER+C8aSN1LdUhtIqT070ZJ2wCLtvIOlcAq2c8gQehumnqlZiYXbwMKYi8pfYZ0fxr
         Rxmw==
X-Gm-Message-State: AOAM530bc0FUsanRDZKkp6cUUxw/eDeV58SUTyBH/31KKzSngo+9OuqT
        eDSLYYpC75y7SiH8Pzf5aMpTPdIa53bPR7POS14Xe0i2a86EEZj/oh55wTWOaMt27/XZQbxZbJM
        IiMPiD5fsORVj
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr108410edd.271.1612288851466;
        Tue, 02 Feb 2021 10:00:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6E/THy8dCvBqoufmpSDqbBDoV6tnoQXAMUyy8ufzV4ooUyX80TCNxOcS4oMEXqF5ZNHS54g==
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr108393edd.271.1612288851291;
        Tue, 02 Feb 2021 10:00:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm9792589ejb.65.2021.02.02.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 10:00:49 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/27] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
 <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
 <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32df1e72-b53d-bdf7-9018-a5eee4550dc4@redhat.com>
Date:   Tue, 2 Feb 2021 19:00:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 02:25, Kai Huang wrote:
> On Tue, 26 Jan 2021 08:04:35 -0800 Dave Hansen wrote:
>> On 1/26/21 1:30 AM, Kai Huang wrote:
>>> From: Jarkko Sakkinen <jarkko@kernel.org>
>>>
>>> Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
>>> sgx_reset_epc_page(), which is a static helper function for
>>> sgx_encl_release().  It's the only function existing, which deals with
>>> initialized pages.
>>
>> Yikes.  I have no idea what that is saying.  Here's a rewrite:
>>
>> EREMOVE takes a pages and removes any association between that page and
>> an enclave.  It must be run on a page before it can be added into
>> another enclave.  Currently, EREMOVE is run as part of pages being freed
>> into the SGX page allocator.  It is not expected to fail.
>>
>> KVM does not track how guest pages are used, which means that SGX
>> virtualization use of EREMOVE might fail.
>>
>> Break out the EREMOVE call from the SGX page allocator.  This will allow
>> the SGX virtualization code to use the allocator directly.  (SGX/KVM
>> will also introduce a more permissive EREMOVE helper).
> 
> Thanks.
> 
> Hi Jarkko,
> 
> Do you want me to update your patch directly, or do you want to take the
> change, and send me the patch again?

I think you should treat all these 27 patches as yours now (including 
removing them, reordering them, adjusting commit message etc.).


>> OK, so if you're going to say "the caller must put the page in
>> uninitialized state", let's also add a comment to the place that *DO*
>> that, like the shiny new sgx_reset_epc_page().
> 
> Hi Dave,
> 
> Sorry I am a little bit confused here. Do you mean we should add a comment in
> sgx_reset_epc_page() to say, for instance: sgx_free_epc_page() requires the EPC
> page already been EREMOVE'd?

I also don't understand Dave's comment.  I would say

It's the caller's responsibility to make sure that the page is in 
uninitialized state with EREMOVE (sgx_reset_epc_page), EWB etc. before 
calling this function.

Paolo

