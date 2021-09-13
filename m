Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963A2409419
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbhIMO15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:27:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245538AbhIMO0A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631543083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/m3AGrRM+x9xiDO65EqO8A6qIIRr/vuUKsxmz2wgEqc=;
        b=gWmiHZTDtJXfgyGMlDjXv055GajxYZJdqNAM+0zuc+QDJ/Ke8Dwxd950E+RYOf9N6RWe4z
        mIna2qIfX09kT0zGGISXsOkx2iGt8m51dVlWwmr0nu4jam7OA1X8D8jVGpsZ7JIJQxNNL3
        Z29ePat6hCgsm3z3hgPoYWSjQR/D9qU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-twD99Sj9PjaYPKO-wYswzw-1; Mon, 13 Sep 2021 10:24:42 -0400
X-MC-Unique: twD99Sj9PjaYPKO-wYswzw-1
Received: by mail-ej1-f70.google.com with SMTP id g18-20020a17090670d200b005f0df5ce29bso1011852ejk.1
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 07:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/m3AGrRM+x9xiDO65EqO8A6qIIRr/vuUKsxmz2wgEqc=;
        b=jJgnfik1SaJp1Rup7LWMmw0b6PxoMPcuQTBIR4q4aHoyGiUBWnLv7lgvs4n5+PTvDP
         RHh8xkxN4WD6lmTfykb3LGqaOVUPEdtYkrUzq71awjOsxNQHahfU2whSg7exe5elKjtZ
         7QG3IRpCvnMOhQUgFLYcEiUHibrbVkGjiy5AKFn39gumPZTNLqsECkY98WDuXv8FnTD9
         kIdogRT7m+G3mXL8+uzfL2vypEK6VfPirRab+lTPjNMO+YGmVl3cTQ81sytLq0XB6Xiz
         DSy1yJ2Nhfsnm+zx4/B3wSrieVOIyMItOal2ZlmNFpI2HJJBIJypOYf4Lzr6ZAIlF6BA
         c4NA==
X-Gm-Message-State: AOAM532VJPBMpLf1fXG62XkwNspckgEJ5csDBNs556VzxCpIc8+ABN++
        4PwoIoYrHvVtdnswfwsd9+iFvGK2xqJapEya4H9YDMkWbLVVieorgK2MeAJEfTCnBVsS1x70M3H
        mDdPdC438FBtE
X-Received: by 2002:a17:906:95d7:: with SMTP id n23mr12423367ejy.479.1631543081230;
        Mon, 13 Sep 2021 07:24:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3KI1g0FBsQQOkmYOFK11KFkgXtKpHivUh6eKIdur7U1Ajbs2LHAT6yejIQU4zPOFhZHWcRQ==
X-Received: by 2002:a17:906:95d7:: with SMTP id n23mr12423347ejy.479.1631543081050;
        Mon, 13 Sep 2021 07:24:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t19sm3549377ejb.115.2021.09.13.07.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 07:24:40 -0700 (PDT)
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-2-pbonzini@redhat.com>
 <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
Date:   Mon, 13 Sep 2021 16:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/21 16:05, Dave Hansen wrote:
> On 9/13/21 6:11 AM, Paolo Bonzini wrote:
>> Windows expects all pages to be in uninitialized state on startup.
>> In order to implement this, we will need a ioctl that performs
>> EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
>> other possibilities, such as closing and reopening the device,
>> are racy.
> 
> Hi Paolo,
> 
> How does this end up happening in the first place?
> 
> All enclave pages should start out on 'sgx_dirty_page_list' and
> ksgxd sanitizes them with EREMOVE before making them available.  That
> should cover EREMOVE after reboots while SGX pages are initialized,
> including kexec().

By "Windows startup" I mean even after guest reboot.  Because another 
process could sneak in and steal your EPC pages between a close() and an 
open(), I'd like to have a way to EREMOVE the pages while keeping them 
assigned to the specific vEPC instance, i.e. *without* going through 
sgx_vepc_free_page().

Thanks,

Paolo

> sgx_vepc_free_page() should do the same for pages that a guest not not
> clean up properly.
> 
> sgx_encl_free_epc_page() does an EREMOVE after a normal enclave has used
> a page.
> 
> Those are the only three cases that I can think of.  So, it sounds like
> one of those is buggy, or there's another unexpected path out there.
> Ultimately, I think it would be really handy if we could do this EREMOVE
> implicitly and without any new ABI.
> 

