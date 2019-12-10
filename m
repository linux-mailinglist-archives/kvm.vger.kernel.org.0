Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED177118262
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 09:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfLJIj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 03:39:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbfLJIj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 03:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575967167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjTTvpt6PobdsvvlIPtldg7usxW7jcyhRVwzKlCfqFM=;
        b=NKzG5H3+PPtAvJqN2hgv5Gjw7reNjhvtDnU7qzNC+Q+OwGarENBXt/pd2pVtXYCpRU3ZXo
        /3y4ObjtUdsXsG8IhMxF7hiz3vkAY9BTOx9+x1rmjWHOK7rVH7SoIwFgLy9ylnHZ6XtcJg
        XTIVikH2aEysLNy7PUeQnvUhFrSFHSc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-pP2HBSdMOpaFQP90V5sBQA-1; Tue, 10 Dec 2019 03:39:24 -0500
Received: by mail-wr1-f71.google.com with SMTP id b13so8639805wrx.22
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 00:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GjTTvpt6PobdsvvlIPtldg7usxW7jcyhRVwzKlCfqFM=;
        b=FwtWEyJJ9+auFNU0iqbrUcGCdoHG3PWHBzYRhMRF8xVRvvOSyJpwlTG9RLm/wFUMNf
         vDkz39MYA3hahfY1Rbb7F+PUg6KHWbTQghzLrVRAbp+NddMVxqJBvihFQMXwjXpR96gk
         Jc05hA7eotDNzomaVXSVMOZDlHRn5yavyn6zVOSfCoIKNTG/Sz8eL+Ogug02XRasaZTU
         S68yCymFtDlQibuOsUbAy4RWA6eVvr+YR4BNQ4jywz9i3l+jUfnTyZqiM6p6N+13ufFd
         Z74Kz3BHnyi2j2zmyTNnbKQquda6rpuUg253g+68yUQXqbjRgIcDv2gUQD1FdtGaPdYM
         zo5Q==
X-Gm-Message-State: APjAAAVVntGBasFMunk1XCre2ZQ0nS9wupkF8ze5ANzvZaabf/xltM+3
        MR6nMj+bu0dn/9gOyePoK9ICvGc4wm7B0iUr7g8dMuKChasC4yzlNgR+/LbEhNQpubnb4pmhcSC
        3HBLDOwvA1yDf
X-Received: by 2002:adf:cd03:: with SMTP id w3mr1707603wrm.191.1575967163444;
        Tue, 10 Dec 2019 00:39:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqzU1FBt3vbHWbnkN03vACZhNOppfQeC0toEpmCVEttiJubR5galA/9amse/PQ6hN2pPzkBTjA==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr1707583wrm.191.1575967163132;
        Tue, 10 Dec 2019 00:39:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id i11sm2433522wrs.10.2019.12.10.00.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 00:39:22 -0800 (PST)
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS
 field
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
References: <20191204214027.85958-1-jmattson@google.com>
 <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
 <f20972b7-ea45-6177-afa6-f980c9bd6d0f@redhat.com>
 <CALMp9eRag2YFfK-2y-e12NdP+EE068nC+Sv_=BVtBdPXV-FE7Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1ff0d0a-a7b1-970c-3755-559f89a90713@redhat.com>
Date:   Tue, 10 Dec 2019 09:39:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRag2YFfK-2y-e12NdP+EE068nC+Sv_=BVtBdPXV-FE7Q@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: pP2HBSdMOpaFQP90V5sBQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 00:34, Jim Mattson wrote:
> On Mon, Dec 9, 2019 at 8:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 05/12/19 22:30, Jim Mattson wrote:
>>>> I'll put one together, along with a test that shows the current
>>>> priority inversion between read-only and unsupported VMCS fields.
>>> I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
>>> going to add the test to tools/testing/selftests/kvm instead.
>>>
>>
>> With the next version of QEMU it will be "-cpu
>> host,-vmx-vmwrite-vmexit-fields".
> 
> Or, presumably, -cpu Westmere?

Yes, more precisely -cpu Westmere,+vmx because nested is still not the
default for named CPU models.

Paolo

