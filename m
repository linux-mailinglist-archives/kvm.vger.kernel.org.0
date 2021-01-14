Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F039A2F6CF5
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbhANVNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbhANVNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 16:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610658746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jZDB3whm7X5+2rZgMAol6m6nqt2zPNFs5ujNSvA7oLY=;
        b=ICayogUdOi/c6bJwTs3Zh6yJyVe+0oXVL+rK/SIAS1IQft7v7rA5Vobc028MvyaxiItgL5
        /xU3o54kZPmIV2GyjvNuq3ZTTHey/wQIL156guW9EwOs0ykDog/gYEfSnLYuinb3tRgDrg
        oZ6hMn4I4+pocFXNtHA9oxBpGeD7y4k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-KRM_pREGNvmO1Th-meKd4g-1; Thu, 14 Jan 2021 16:12:24 -0500
X-MC-Unique: KRM_pREGNvmO1Th-meKd4g-1
Received: by mail-ej1-f71.google.com with SMTP id m11so2718452ejr.20
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 13:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jZDB3whm7X5+2rZgMAol6m6nqt2zPNFs5ujNSvA7oLY=;
        b=CweklDJ/XHX+UeExT+6Vgm7g8TgTTP1umY8yJUz3Uw63VayUUinxVgI9Ay0iMxyO5t
         yUCRz9Mb8BWSZ3OLsoanmjJ8xfP0STpkdfPN9DualtI3SPpxWH3NtPD5cMTrlym+yZaR
         uD8SuFLxpTqTF9GwrrQrWQo2nZZ5PmXBz6DaCyZBoflh2XBizcpkbWI5vrmn5JIk2Ht+
         xK7wOD+A3PaKYX4nZcZAFpCDoXbh/+enJo4pPK8LK5OliyAgiVVMUTk60n2MeRWcKB9e
         Njz+Gds5aBSGjs09KPemo6l8+Az0LUNU/dcoXISN9+U/p0Iecs+d/BSDfk85rxBEg8lL
         nx0Q==
X-Gm-Message-State: AOAM532Tzi4sujyt6AGBsPjKpDbbjI83ASrbYsEdJmzRkfOWVX20f0iT
        heBrdqXM/Oh4OFpNyU3QGxa1krTknmgMsynCI/xH0vkt2P4ESxxDkoxFlLRJdQ5bYEfmy+Ch64j
        2C4/2LTEOec38
X-Received: by 2002:a17:906:60c3:: with SMTP id f3mr6482953ejk.65.1610658743448;
        Thu, 14 Jan 2021 13:12:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7N/HzHgYyV2eNtK6o+3fbrkHwtk9WDzIjpHehdzZyBOoeNFM0EB4XA/JJ6WzuvU/kCCCNrg==
X-Received: by 2002:a17:906:60c3:: with SMTP id f3mr6482943ejk.65.1610658743217;
        Thu, 14 Jan 2021 13:12:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c24sm25788edt.74.2021.01.14.13.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:12:22 -0800 (PST)
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2e5f090-b699-1f94-eb33-b7bb74f14364@redhat.com>
Date:   Thu, 14 Jan 2021 22:12:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YACl4jtDc1IGcxiQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/21 21:13, Sean Christopherson wrote:
> On Wed, Jan 13, 2021, Paolo Bonzini wrote:
>> On 12/01/21 23:28, Sean Christopherson wrote:
>>> What's the biggest hurdle for doing this completely within the unit test
>>> framework?  Is teaching the framework to migrate a unit test the biggest pain?
>>
>> Yes, pretty much.  The shell script framework would show its limits.
>>
>> That said, I've always treated run_tests.sh as a utility more than an
>> integral part of kvm-unit-tests.  There's nothing that prevents a more
>> capable framework from parsing unittests.cfg.
> 
> Heh, got anyone you can "volunteer" to create a new framework?  One-button
> migration testing would be very nice to have.  I suspect I'm not the only
> contributor that doesn't do migration testing as part of their standard workflow.

avocado-vt is the one I use for installation tests.  It can do a lot 
more, including migration, but it is a bit hard to set up.

avocado-qemu (python/qemu and tests/acceptance in the QEMU tree) is a 
lot simpler, but it does not have a lot of tests and in particular it is 
not integrated with kvm-unit-tests.

Maxim also wrote a script to automate his tests which has quite a few 
features, but I've never used it myself.

Paolo

