Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC4121BF6B
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 23:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGJV4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 17:56:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726251AbgGJV4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594418200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zKgwKl+Y90bLEHmxv4Y9FIZIDImzOuHsMsOIgl1sMAo=;
        b=b/9d8z7o6XZJlOTUs+wo13oxARZT03sAwTqJ7OF/DyvONYc5qZJpmyoPiseB7SbQaG2iIZ
        +arKd+YQiWMui5qzsMHlDXhQYMmlW0/VetNyCy9eDEj799HdU8CDeVcmedWNucXAq2GSSR
        VTVzM4u2gCIvS1IBOpvfUx+zHtRqoZw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-ISFRgT4lOLqUSCZkphpwdQ-1; Fri, 10 Jul 2020 17:56:36 -0400
X-MC-Unique: ISFRgT4lOLqUSCZkphpwdQ-1
Received: by mail-wr1-f70.google.com with SMTP id g14so7365893wrp.8
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 14:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKgwKl+Y90bLEHmxv4Y9FIZIDImzOuHsMsOIgl1sMAo=;
        b=KPJe8FbVDQHJ50MD4rubrgH71j3iq/hg+60LU/fparK5IPAVVHjdNYX6pzxL+Oi0ba
         96/x037+XSFWIBUu3U3HAQ40oIbftAHeyR7Fn7LI4U61vUzrnoIqOechp3yJYAL7eL4J
         LtG8oJQOdbLybstP/fYnfDwCA3pIzi6extvJCCU231ulX+plWfklyRevyqcrK0qTlUJo
         vZ5C8zwdyqmfk5WRwEhhw3LrfT/L1ZMn4kH72tNfu13yMNM+Z3Ew7fD9BNoL4fq8CHgU
         akoYMENOkTaLgMY7oKG4lcoOltaNEQc5ZsBc2q1RXDxwPqTjblfboCTuvfRJBFgTF5Z7
         5IJw==
X-Gm-Message-State: AOAM533Y+FQqsA9GDpZL3jWAH9WJNkyV7uPWemcPdxLvXmxB2xwdaMkk
        u0SgwuX9XPMJVjOdEjoNbjPiLI/8SJxkwmN4CEzQB3a9OfSJcJXksoc6cZ/pCmtRd0uvQIt9huO
        JlAVFxYAxOlOf
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr7540063wml.128.1594418195409;
        Fri, 10 Jul 2020 14:56:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7j66IrBhBjLaBnymoh8O/l8zuLVdSzlKTl3+WywsT+6oxDb2+b88Y7Bj29Wyy8bWjvMKFdQ==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr7540044wml.128.1594418195193;
        Fri, 10 Jul 2020 14:56:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id a15sm13361386wrh.54.2020.07.10.14.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 14:56:34 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/4] x86: svm: clear CR4.DE on DR intercept
 test
To:     Nadav Amit <namit@vmware.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200710183320.27266-1-namit@vmware.com>
 <20200710183320.27266-2-namit@vmware.com>
 <8b7970c9-0b9e-6108-dfeb-4d871ab425b0@redhat.com>
 <E9674128-8401-49BA-B721-EE93C597BA8B@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89c8ac34-3bc8-1018-6a71-40b83a12e764@redhat.com>
Date:   Fri, 10 Jul 2020 23:56:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E9674128-8401-49BA-B721-EE93C597BA8B@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 23:21, Nadav Amit wrote:
>> On Jul 10, 2020, at 1:45 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 10/07/20 20:33, Nadav Amit wrote:
>>> DR4/DR5 can only be written when CR4.DE is clear, and otherwise trigger
>>> a #GP exception. The BIOS might not clear CR4.DE so update the tests not
>>> to make this assumption.
>>>
>>>
>>
>> I think we should just start with a clean slate and clear CR4 in cstart*.S:
> 
> Your change seems fine. If you can push it (with the rest of the recent svm
> changes), I would prefer to run it, before I need to return my AMD machine.
> 

Done now.

Paolo

