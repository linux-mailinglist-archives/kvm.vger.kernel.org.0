Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB66E1B88D1
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDYTQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 15:16:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726216AbgDYTQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 15:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587842180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajW83cPmwSdOeR1VWQQEGhPP3tbajGWXOutPh+OWcCo=;
        b=i+kFM2j3jroUZG966cGab2G+Af9Lbb1eRiGwqdV423AqZr6u7dbXC5HuZW+Vvdq7dre9wv
        l3Z3ptdnmcotu5j3skPfbXc+sK0Q+3Fm0XWrflzTPnwRU5xuWDe6e/Zzivcy3iqYARem1e
        ZEY/OpmyhWWuqiRavFSu2lc/NwzTYls=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-zuPcIaM3OUyCSZoTr_BCDw-1; Sat, 25 Apr 2020 15:16:18 -0400
X-MC-Unique: zuPcIaM3OUyCSZoTr_BCDw-1
Received: by mail-wr1-f70.google.com with SMTP id j22so7237489wrb.4
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 12:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajW83cPmwSdOeR1VWQQEGhPP3tbajGWXOutPh+OWcCo=;
        b=HgiQZsFhzO73ACRg0AnZ+srYBLMztyNyauvofwMxvTam0PHGMASm9dgbDPHsAo8kH5
         Dy/9KGixy9BpJe06IG72ME5aXZfvWbCCoqQvZGj8zVZiI7ieRAWraK2JWMMInsghznlp
         w/8lCIUcR2VI4rCyjq1mYp2PRkZpIvscIN84jEfz9TIUETN3z7jSkRuhwUdcPR3KZTxy
         DwhavuL3/outyKC66EtcRUCR1PQcpS9oNhw11Gc/6ymMtR3DW/JJpIdx/ax0YVYZYlnX
         x6E6Hbzf5Am5A6QaMe/1P5ELJOsBDZng95wW2hpoWq5RvxihfhhVvfmRnPxAtA33HN5c
         dIEQ==
X-Gm-Message-State: AGi0PuYSFY1be1VaW++nN99aDc4x/RE4AG1aq3ClBCloOFG2+CUV/auv
        u5GoGI1I74WztGrI1G6PSNbgoOMKHswFRtBZSvIioUQX03s8gLxnPmYucTm2i7BZlFnNK+FNwmz
        rRzM5h1WqM71q
X-Received: by 2002:a5d:5001:: with SMTP id e1mr18996371wrt.27.1587842177345;
        Sat, 25 Apr 2020 12:16:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypIslrnrTCUpVt5mn/A0rA0ebcrzDNEHzKVQ09XyEpYeCTU1+Fo5jDEho79nKUV/iuLclvvUMA==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr18996358wrt.27.1587842177133;
        Sat, 25 Apr 2020 12:16:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id p6sm13751690wrt.3.2020.04.25.12.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 12:16:16 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <85cb5946-2109-28a0-578d-bed31d1b8298@redhat.com>
 <08C6D1FB-A4F7-49FA-AC46-5323C104840A@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8223a7e2-5d4a-b427-c44f-d76450f16748@redhat.com>
Date:   Sat, 25 Apr 2020 21:16:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <08C6D1FB-A4F7-49FA-AC46-5323C104840A@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/04/20 18:54, Nadav Amit wrote:
>> I wonder if KVM_DEBUGREG_RELOAD is needed at all.  It should be easy to
>> write selftests for it, using the testcase in commit message
>> 172b2386ed16 and the information in commit ae561edeb421.
> I must be missing something, since I did not follow this thread and other
> KVM changes very closely.
> 
> Yet, for the record, I added KVM_DEBUGREG_RELOAD due to real experienced
> issues that I had while running Intel’s fuzzing tests on KVM: IIRC, the DRs
> were not reloaded after an INIT event that clears them.

Indeed, but the code has changed since then and I'm not sure it is still
needed.

> Personally, I would prefer that a test for that, if added, would be added
> to KVM-unit-tests, based on Liran’s INIT test. This would allow to confirm
> bare-metal behaves as the VM.

Yes, that would be good as well of course.

Paolo

