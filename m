Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B32A213E56
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 19:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgGCRLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 13:11:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726148AbgGCRLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 13:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593796277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hu2aMRfs7eEdtp92yAIspNuj4yLg1D8Hmm/uskf12is=;
        b=g2YlqUGB7Qt0BXrEHkFf0gaDnH+y+eiMb1KsluTaH8kQ+MIfK0Zs90fy6qbe3rGCW4pzjM
        OVMck2qvs7JD85MD/ThkZ0pOtmOxTVnEBgIP815F3WoE+S/vvd1RuDImQtnm4SXsuwpcMk
        akgOc0eUkG7TXBePzCbEm+eovrvIcFo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-LoqoZ1GsO62h_7WMIUJ7wQ-1; Fri, 03 Jul 2020 13:11:14 -0400
X-MC-Unique: LoqoZ1GsO62h_7WMIUJ7wQ-1
Received: by mail-wr1-f69.google.com with SMTP id j16so26985414wrw.3
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 10:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hu2aMRfs7eEdtp92yAIspNuj4yLg1D8Hmm/uskf12is=;
        b=GPO+OmlekTf4uoV89n6bC9U9eWfC0AdgfunJShI8t1NYMa5iZY8d3o3lT4s9Ei2844
         TaJ9Ylp/RaL3lo7YCRo4XxBjzJGbiEouNMpIHw7H3ervzelyZaEtpf7QuOFYzPAo26lp
         Z4nlk17drLZ08v2o2AhrBgCuTcJH+1q0begH+3elVq84cPH1w4aHcX/VTlJqsLHEMQL4
         MHmjcX5uL6OCziEAkpw6sOI2u5vU41WitSujkZ6fF81EpMA8+eoPZd+5ACVcQ9AqTbpM
         hpwoZ9u1XqiY+uwgUVnnRL8biURqkGxcLcd2p9knW7mbbv1Hw5u+p4sT3vbT7SkALDsc
         Dflw==
X-Gm-Message-State: AOAM533QoGJYFL+LsA8/ccE8zYCq4rPV7QWwDBunxO2Tt/UfDpqoIFvW
        fc3KdDYxOWmlJqMv7YkCOSL7UFk2JaKA105haFeG7iBi2qs5qxyhH2p3cs98D1D4roW8erD/Gzx
        IZKVe3khedW6M
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr37058926wrw.355.1593796273016;
        Fri, 03 Jul 2020 10:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYamxxVttebwJlXepculyEyfWKMmoY9sYuEBpVBWycKnntKBR/tqGhUsfHTS8TB4UKdFJypw==
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr37058915wrw.355.1593796272811;
        Fri, 03 Jul 2020 10:11:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id b10sm13454915wmj.30.2020.07.03.10.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:11:12 -0700 (PDT)
Subject: Re: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
 <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2276167-0bda-0b31-85c0-63a3a0b789bd@redhat.com>
Date:   Fri, 3 Jul 2020 19:11:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 00:33, Krish Sadhukhan wrote:
> Ping.
> 
> On 5/14/20 10:36 PM, Krish Sadhukhan wrote:
>> v2 -> v3:
>>     In patch# 1, the mask for guest CR4 reserved bits is now cached in
>>     'struct kvm_vcpu_arch', instead of in a global variable.
>>
>>
>> [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in
>> [PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not
>> set on
>> [PATCH 3/3 v3] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not
>> set on vmrun
>>
>>   arch/x86/include/asm/kvm_host.h |  2 ++
>>   arch/x86/kvm/cpuid.c            |  2 ++
>>   arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
>>   arch/x86/kvm/svm/svm.h          |  5 ++++-
>>   arch/x86/kvm/x86.c              | 27 ++++-----------------------
>>   arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
>>   6 files changed, 53 insertions(+), 26 deletions(-)
>>
>> Krish Sadhukhan (2):
>>        KVM: x86: Create mask for guest CR4 reserved bits in
>> kvm_update_cpuid()
>>        nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun
>> of nested gu
>>
>>   x86/svm.h       |   6 ++++
>>   x86/svm_tests.c | 105
>> +++++++++++++++++++++++++++++++++++++++++++++++++-------
>>   2 files changed, 99 insertions(+), 12 deletions(-)
>>
>> Krish Sadhukhan (1):
>>        nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of
>> nested g
>>
> 

Sorry, this one was not queued because there were comments (also I think
it doesn't apply anymore).

Paolo

