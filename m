Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC14FD2E40
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfJJQB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 12:01:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbfJJQB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 12:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570723286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=yO8YpbAofQXr79B+Tt+fMBxx6HgPcVYbWHTjWLQdt6E=;
        b=O1V47DreWKvd4gyxeOMyuskB9BJhHPVmC2nNQHbo0uq9HRckNVg00f3gTuNsIFttm9hZkP
        w3rB1e9BQ1Mf6USzZqRJCuzy1BUTy+wa8kEVR9e6IVIANdzL8ipKbgakiIL3RD9adwWf4p
        y7w+p3tCIUpEnnFbhvkBKK7lAgaIURI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-p8GMErj7O5qpZDwvnLzzSQ-1; Thu, 10 Oct 2019 12:01:24 -0400
Received: by mail-wr1-f71.google.com with SMTP id t11so2950007wro.10
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 09:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yO8YpbAofQXr79B+Tt+fMBxx6HgPcVYbWHTjWLQdt6E=;
        b=jBK8utQI1JJy4zEcl1UsaWJWFTcjRxUP98+IRW59/yqGfjkAqeMFMy60Xz7bI7fMD/
         w83QAz3LMvcZQj5L33DpYsJ/pq9xTon+fpPuufk+BrVCADdZG9CNZtHc1Qat9nAd7hbV
         /+KIPkW4YcG0gW6gYqA6kaaz9+WEqOSXhVTr8lygHdsSA2A/4uZb5m8/F8DdDmjNFFkr
         2ewhdQpYbhBuE0ObcU+CZ4sJD2wTWIhM9Yq2ZOEsEjuYo1BxgpgXTK+N0gbWwB8QZHta
         zKR7gM4aorqEiQWqfNzkLJJwUHICfx+F+uw7xnv3yWMvMPUXrdD9sbh+/iAhnac9ycxG
         xxVA==
X-Gm-Message-State: APjAAAW2cYN/TQrjhTynY9pRubbuRsKot4XNf7A+b5yFizirAK6vWJCV
        6xoAgw9kKvvAK+6H7okWdRVOOu7FZ3qJZDkpBxdlCpVSfsJt6aMw9wt/NxoBqQdIo0vHPsmb8uu
        qHEqfHrn3MBIF
X-Received: by 2002:a05:6000:1cb:: with SMTP id t11mr8879735wrx.144.1570723282412;
        Thu, 10 Oct 2019 09:01:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzQ9rWpYxkYsUmvbwZHb06NPK2zY28T3PDxG5o6Kh8mSK8OlvpfdjVGD1orEVBHR9PyJ1LNPQ==
X-Received: by 2002:a05:6000:1cb:: with SMTP id t11mr8879595wrx.144.1570723281176;
        Thu, 10 Oct 2019 09:01:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id g4sm7825988wrw.9.2019.10.10.09.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 09:01:20 -0700 (PDT)
Subject: Re: [Patch 6/6] kvm: tests: Add test to verify MSR_IA32_XSS
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-6-aaronlewis@google.com>
 <f3bcebe3-d82d-7578-0dd9-95391fe522e0@redhat.com>
 <CALMp9eSqy2k2xJo+j2eFf5LNTGctywSt9bFq33iX4nR1gErFcQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <79b9c6f5-9a9d-2ea1-ee84-19d2f5b83089@redhat.com>
Date:   Thu, 10 Oct 2019 18:01:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSqy2k2xJo+j2eFf5LNTGctywSt9bFq33iX4nR1gErFcQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: p8GMErj7O5qpZDwvnLzzSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/19 01:44, Jim Mattson wrote:
>>> +uint32_t kvm_get_cpuid_max_basic(void)
>>> +{
>>> +     return kvm_get_supported_cpuid_entry(0)->eax;
>>> +}
>>> +
>>> +uint32_t kvm_get_cpuid_max_extended(void)
>> I would leave the existing function aside, and call this one
>> kvm_get_cpuid_max_amd() since CPUID leaves at 0x80000000 are allocated
>> by AMD.
> The existing function *is* the one that gives the largest
> AMD-allocated leaf.

Sorry about that---my fault for snipping the patch and assuming some
"git diff" craziness.

> Note that Intel documents CPUID.80000000:EAX as
> "Maximum Input Value for Extended Function CPUID Information," and AMD
> documents this as "Largest extended function."

Objection taken back, then!

Paolo

