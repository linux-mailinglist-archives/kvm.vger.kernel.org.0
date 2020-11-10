Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F12AE0C8
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgKJUhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:37:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgKJUhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 15:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605040659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86E1PiwpTATAQtderrQWGZYhJziSfrLmfv7s2P36MyY=;
        b=EatpexV/NwS2/g4QcIp62FdQTYoYh+2mXkQrBnPDlRGJkGM4tG3RhJJ/UMfHWYcKI8k6rs
        uzwqRzATJ7CigCcIK1YuqzQUptg1NKQ4DKkSH+ib4nyedePQ8iFmZjIkl4vv0tikCrSo63
        z016iJnGvQZ9l2qygKMNoGVTLer8KVY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-usJEOh08N8S0qFc7IOy46A-1; Tue, 10 Nov 2020 15:37:38 -0500
X-MC-Unique: usJEOh08N8S0qFc7IOy46A-1
Received: by mail-wr1-f72.google.com with SMTP id w17so5372971wrp.11
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 12:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=86E1PiwpTATAQtderrQWGZYhJziSfrLmfv7s2P36MyY=;
        b=aOXBX5VdUBRmNSvvOgWJV0XVQgSj7UwbsbKcDvdqtC7/2VE8nbpPdkA3f6RnATbknX
         H1shyLhv4Ded/cjNGy8lkGi6lTcmnTvKjPQl/saPvg0koE6Vj3VNMIk2l/LEgPr3QpAG
         xXOue6ouq29wiulx55BXpIaktoEcffsn89DVgWmwvEZQeIy81LnAYpCCELOJsLEPQKk3
         1g0E3TZoZRQ5tKMPX7NZuX3xlmEsgCdUYDqx6mzSwVEOZurOlHecfPmjHIRICKrbsBHB
         xlPItZmkhk6kkNTMAAx7dE/rDVHS/wJG5g/3qx9m8d3AhHfy/uhrMzoz4QmxsPsAW+kD
         0hCQ==
X-Gm-Message-State: AOAM530BAHXvpdJvbYtLImdDAPsKSiv8TUhPwHvifjTlFIGmdOSkBNB+
        6uEtyfdZcxgusPozPPwoQW0IvZ7Rlz6uWUggZZ0mpzBq/A3+3NvnigrMM5n2nMCnRyWgOp+oCRq
        8Br/KOLrAjq5tFph5+jiEayJnTFUxgPSd8YPcgHo6FzYgDCLJjgGRs5OjTLBhMDxQ
X-Received: by 2002:a5d:6744:: with SMTP id l4mr24886223wrw.378.1605040656898;
        Tue, 10 Nov 2020 12:37:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1TcLE86QgwB8CSzyVPHmo0gyCUPTPLnWMfxW3NiNpbb9kz55y3L1GCvdcftAsFMgZJiLBMg==
X-Received: by 2002:a5d:6744:: with SMTP id l4mr24886197wrw.378.1605040656635;
        Tue, 10 Nov 2020 12:37:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g131sm4181864wma.35.2020.11.10.12.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 12:37:35 -0800 (PST)
To:     "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc:     Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
 <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
 <20201110155013.GE9857@nazgul.tnic>
 <1b587b45-a5a8-2147-ae53-06d1b284ea11@redhat.com>
 <cacd1cd272e94213a0c82c9871086cf5@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <7bd98718-f800-02ef-037a-4dfc5a7d1a54@redhat.com>
Date:   Tue, 10 Nov 2020 21:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cacd1cd272e94213a0c82c9871086cf5@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/20 18:52, Luck, Tony wrote:
> Look at what it is trying to do ... change the behavior of the platform w.r.t. logging
> of memory errors.  How does that make any sense for a guest ...

Logging of memory errors certainly makes sense for a guest, KVM already 
does MCE forwarding as you probably know.

The exact set of information that MSR_ERROR_CONTROL[1] adds may not make 
much sense in the case of KVM, but it may make sense for other 
hypervisors that do nothing but partition the host.  (Difficult for me 
to say since the relevant part of the SDM might as well be written in 
Klingon :)).

In any case, checking HYPERVISOR is not enough because having it clear 
is a valid configuration.  So you would still have to switch to 
{rd,wr}msrl_safe, and then checking HYPERVISOR is pointless.

Paolo

> that doesn't even
> know what memory is present on the platform. Or have guarantees that what it sees
> as memory address 0x12345678 maps to the same set of cells in a DRAM from one
> second to the next?

