Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD08C34657E
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhCWQkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233127AbhCWQk0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 12:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616517626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BWe9jizGou9Z7iIZPltb/vzhcc5F+JZOIptQ1l0XQc=;
        b=G4mVXaLL6DJTn5AwsBRS4039QXkK3W0fO653D3fu3cIAjazoV7wdZ3cQtGsqaFJAJ7H4nQ
        6XCiLPPCci7CmOdYhoGftWLvYEtIM/UDRpmRisowHRxvvECebJO4cz7tRCU3ZsZj8sIDIw
        LuMKxWfdIVuJWKY4tSfT/kFOCHY2FM4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-gKR6BuxMOtCRJ1aEdNrRJQ-1; Tue, 23 Mar 2021 12:40:22 -0400
X-MC-Unique: gKR6BuxMOtCRJ1aEdNrRJQ-1
Received: by mail-wm1-f70.google.com with SMTP id w10so1325281wmk.1
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5BWe9jizGou9Z7iIZPltb/vzhcc5F+JZOIptQ1l0XQc=;
        b=Vmt/TIMu1lU223C/iGibh5y3HtPEUjZEthnv/gc698uOgYw58kB21mvmdNx2VfU/pF
         DtPdwW5xLo6eAhfKSRUhcJDXi4yBcv7PvYftDYlyEDgQYyLCrKHU+vz2MHNP/XUqfVaz
         eJCuU8Jo8iEB8nmAisB3C/s0iRXMT1AXgyc5HkvYlx+bOSKOOcWYtN7Fa4u7TCcYHuLo
         czG4tNf+xwAv35TG9cnaV4BZ0sMME7Z0aWyJfg60VgNsGakNSrD4N5zoX7M5xXe+7aCL
         nIwXVTbmqN4T5inI1j5NO6WnvUu3v4WDTZxN9mEFfTi81lDS9wvtR6BXQrXLX8SucSpz
         luSg==
X-Gm-Message-State: AOAM531rjnnLSvDVnSAeHZYYR705DnOm7e4Zr+P4wuvEowGBBV6QhTZT
        jsS61zGakqouxW5kGxtAQXltUPeTVhNyS0KDPE29IYuZZlt3Iojn4IcsYACNYRX3iruvQ6b/M+K
        T/yYz5wUj1a0z
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr4212912wmq.45.1616517621100;
        Tue, 23 Mar 2021 09:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgV8GAIHS3AZ2N+inHsbLx96rBH1y6Aiui1UHTThEyadz05ZOLO7nAbQtNg5qeojn2V0JkcA==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr4212895wmq.45.1616517620917;
        Tue, 23 Mar 2021 09:40:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k4sm30869920wrd.9.2021.03.23.09.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:40:20 -0700 (PDT)
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic> <YFjoZQwB7e3oQW8l@google.com>
 <a2e01d7b-255d-bf64-f258-f3b7f211fc2a@redhat.com>
 <20210323094336.ab622e64594a79d54f55e3d7@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <0918025f-736e-de4a-832e-b4b6d903eba2@redhat.com>
Date:   Tue, 23 Mar 2021 17:40:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323094336.ab622e64594a79d54f55e3d7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/21 21:43, Kai Huang wrote:
>> That was my recollection as well from previous threads but, to be fair
>> to Boris, the commit message is a lot more scary (and, which is what
>> triggers me, puts the blame on KVM).  It just says "KVM does not track
>> how guest pages are used, which means that SGX virtualization use of
>> EREMOVE might fail".
>
> I don't see the commit msg being scary.  EREMOVE might fail but virtual EPC code
> can handle that.  This is the reason to break out EREMOVE from original
> sgx_free_epc_page(), so virtual EPC code can have its own logic of handling
> EREMOVE failure.

I should explain what I mean by scary.

What you wrote above, "EREMOVE might fail but virtual EPC code can 
handle that" sounds fine.  But it doesn't say the failure mode, so it's 
hiding information.

What I would like to have, "EREMOVE might fail and will be leaked, but 
virtual EPC code will not crash and in any case there are much worse 
problems waiting to happen" is fine.  (It's even better with an 
explanation of the problems).

Your message however was in the middle: "EREMOVE might fail, virtual EPC 
code will not crash but the page will be leaked".  It gives the failure 
mode but not how the problem arises, and it is this combination that 
results in something scary-sounding.

Paolo

