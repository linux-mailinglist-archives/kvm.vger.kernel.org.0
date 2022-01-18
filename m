Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A28492C95
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347431AbiARRl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:41:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347491AbiARRlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642527671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qaFQ9J8H+xfsuplR1tz9ydY/Cr1eCcJo4bl6CngBsMQ=;
        b=FQhpn7E30IqWh04udCkGTWfdobQzaNBGVCQt0VH3mdQ747RHSdpUwzZEWCV48EEP8+Gpep
        3YfoYR1xwbEllz/OWNvOlgovYCMjYMU8UcuH/B3ThYZ685JXOCvXyPtFsopATywfei99aY
        Dky8sdI+Mh199s/twom0HXbswrynJDo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-bgIFVPxyMfqnVqmWw1rH8g-1; Tue, 18 Jan 2022 12:41:08 -0500
X-MC-Unique: bgIFVPxyMfqnVqmWw1rH8g-1
Received: by mail-ed1-f70.google.com with SMTP id el8-20020a056402360800b00403bbdcef64so1783431edb.14
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qaFQ9J8H+xfsuplR1tz9ydY/Cr1eCcJo4bl6CngBsMQ=;
        b=rZk0QzeSdi5TLpg2PPsKRxng2qRz1ClOcE0I4Bcp2TDsKV6Iq8mD2S8YTwpN/Ko9DK
         Xwk8aQhXeBtqOak7/5RgNFgxz5FVnB1PoQI4qrX6k+jJJ423LkYyPKzSm3U+qg+O4fvx
         VYQ0mUGWE37pPPIQrFo+cUwNMikuDIBtouEaSE71qrsmHe1U5j0QXcl2lk3ewjQ9m5Uy
         2GTW45EcDSlFyPSuYzUZNtLfkLIVJvcwUIdvx4la3Tag+PF4QNSXcrE1FshIeVCEay1T
         kY4dPz+m9OV86OQBQ87PJqa2NU4EyXtIVufdURXA6Z2jdQOJFhAN+cUKtKll+bbI/LbU
         D7+w==
X-Gm-Message-State: AOAM531rmqC9cBueMpRsVbQcXB1Se8TGOyY8o8RA+1isXLiBXVZJPVPz
        4x8kTPkg+waLqfSbrbYDD8iYYdVbWCA7pd8vCfFGDZsA7O5pF2t0rpkwaK+ddeNgwCZIIs6xWUD
        crYwEeRoEOPTO
X-Received: by 2002:aa7:cc83:: with SMTP id p3mr26396702edt.382.1642527666394;
        Tue, 18 Jan 2022 09:41:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/mHK7fdubfAZWWTzDybNb47Jilr4Dp6hn9sRYT20gcFMjuhC9L/MtBRojtfvN6AvjD2IFEA==
X-Received: by 2002:aa7:cc83:: with SMTP id p3mr26396685edt.382.1642527666205;
        Tue, 18 Jan 2022 09:41:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s8sm140105edh.65.2022.01.18.09.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 09:41:05 -0800 (PST)
Message-ID: <8f957326-30e0-ac68-7440-b0787871d96e@redhat.com>
Date:   Tue, 18 Jan 2022 18:41:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/4] KVM: x86/mmu: Fix write-protection bug in the TDP
 MMU
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>
References: <20220113233020.3986005-1-dmatlack@google.com>
 <aadbee28-054b-ddac-6b99-f7ee63e19d7c@redhat.com>
 <CALzav=cs7wz3K4jaqF30BHzfwA1qF2M13SQkap81uG8cpW9xzg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=cs7wz3K4jaqF30BHzfwA1qF2M13SQkap81uG8cpW9xzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 18:38, David Matlack wrote:
> Thanks Paolo.
> 
> Patches 1 and 4 had some wordsmithing suggestions from Sean that I
> think would be worth taking. I'm fine if you want to fold his
> suggestions directly into the queued patches or I can resend.
> 
> The feedback on Patch 3 would require a follow-up series to address,
> which I can handle separately.
> 

Ok, I will fold it myself.

Paolo

