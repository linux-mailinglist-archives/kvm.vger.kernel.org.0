Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095D425DB5A
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgIDOVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730677AbgIDOVl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 10:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599229299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDKt2YWBHOXCJpRpr6ZFofyXOG86ba3y49iBnjylyO0=;
        b=VaXrLcJ2JC39gO69lZoEC1oeOgWF4u6TWtSIZypFeqkbVqjJdf5vD7yud9Hxu3Wiwm4ttg
        9ZxJUcI+qEn68zfrT8wUJUa15eDVgT6xeOpJiUTzzyzr3LfIB546ld4KdTOOqeqJeNw0PW
        iJFwj2ptg5lY7NPfEkrPucMN2IAr6nM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-IkxAtkzwPh6TvT2bz16D6Q-1; Fri, 04 Sep 2020 10:21:37 -0400
X-MC-Unique: IkxAtkzwPh6TvT2bz16D6Q-1
Received: by mail-ed1-f71.google.com with SMTP id y15so2773007ede.14
        for <kvm@vger.kernel.org>; Fri, 04 Sep 2020 07:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qDKt2YWBHOXCJpRpr6ZFofyXOG86ba3y49iBnjylyO0=;
        b=p9Xd9z4rSyH5IV/wdZErkrxZ9NXhsPoGAIepm3dGRzAdNRJmM8Q4GMz6oZx6BCDAXU
         wVRgduvZ4Afgnz2VuDaC3yn+fStNHRhKtj6yhpmAuDvyXYKOGuPQNG78io8YrC/axG/m
         9WhWbhI6yFaApkdOQgle1QwZdIRILpmYwDn4Gc/2HRDXvpDE1Oco/N6/P9tKsnUW9vHi
         1BDce6TduF8DfctNVPp1LdFj4cmBts03l0wqI8HqVDATkd4M6GrwMUo1ka61fIh7/Z/2
         ZHAsUNdbfAV0+j1r8CBzSpH8Y3+JvPqES/ofjxSa2cbIjHpqmvvbdppgSLzW/8Eryq7W
         eKng==
X-Gm-Message-State: AOAM532/81voBYunIFEv0B60Q2xQ3dYD65XHhgpi6oeg+VNds9JjrPX6
        VJ+JDZrY9fxZdFzri1Iv71h9HwPL1IrCIs/cQ8kIi3KKPmHYVUqeVluzEIZyHZx3V9FgZ49/BH0
        kEgCHvetf04qG
X-Received: by 2002:aa7:d353:: with SMTP id m19mr8516757edr.275.1599229296306;
        Fri, 04 Sep 2020 07:21:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzinSGCnHsqdaMAd/9wdONP3ipYBrcPxGrp5p4bF0P9QQGqsmDhpSKvuBW4vLpOli4PIz09Sg==
X-Received: by 2002:aa7:d353:: with SMTP id m19mr8516724edr.275.1599229296001;
        Fri, 04 Sep 2020 07:21:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6276:52ed:96d5:c094? ([2001:b07:6468:f312:6276:52ed:96d5:c094])
        by smtp.gmail.com with ESMTPSA id u4sm6161523edt.11.2020.09.04.07.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 07:21:35 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Test build on CentOS 7
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200731091548.8302-1-thuth@redhat.com>
 <5ed391a5-ad9f-c143-8286-71ec22497a83@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9fcdb394-1be9-a015-82c9-58862fb4131a@redhat.com>
Date:   Fri, 4 Sep 2020 16:21:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <5ed391a5-ad9f-c143-8286-71ec22497a83@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/20 16:00, Thomas Huth wrote:
> On 31/07/2020 11.15, Thomas Huth wrote:
>> We should also test our build with older versions of Bash and Gcc (at
>> least the versions which we still want to support). CentOS 7 should be
>> a reasonable base for such tests.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  .gitlab-ci.yml | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>> index d042cde..1ec9797 100644
>> --- a/.gitlab-ci.yml
>> +++ b/.gitlab-ci.yml
>> @@ -99,3 +99,20 @@ build-clang:
>>       eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
>>       | tee results.txt
>>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
>> +
>> +build-centos7:
>> + image: centos:7
>> + before_script:
>> + - yum update -y
>> + - yum install -y make python qemu-kvm gcc
>> + script:
>> + - mkdir build
>> + - cd build
>> + - ../configure --arch=x86_64 --disable-pretty-print-stacks
>> + - make -j2
>> + - ACCEL=tcg ./run_tests.sh
>> +     msr vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
>> +     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed port80
>> +     setjmp sieve tsc rmap_chain umip
>> +     | tee results.txt
>> + - grep -q PASS results.txt && ! grep -q FAIL results.txt
>>
> 
> Ping!
> 
> Paolo, Drew, any comments on this one?

Applied, thanks.

Paolo

