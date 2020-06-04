Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35D1EE9E0
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgFDR4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 13:56:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730008AbgFDR4o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 13:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591293403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YRb6tBftcN4ywgPXESWRYJJkk+CvsoyUYJ93rzfhMU4=;
        b=Q7Qrz+BzDjgcfupD6vFknmrH1T/0Cn9EPtkcUSuVzNSDy4AfyoQrdjtWVDkoyt7mdY7YFj
        6VV0yR06FhvRuUjbHu59rcrWcVFXHwV2MP7ST4eFeYmm44f4TI1AAJ6HBCW/JyMvB9TIG8
        hTNWiXbC0xk7i4cG7UGJT1mfm7Ujm/0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-E5RWKCpbOoqX4tzr56DGQg-1; Thu, 04 Jun 2020 13:56:41 -0400
X-MC-Unique: E5RWKCpbOoqX4tzr56DGQg-1
Received: by mail-wr1-f71.google.com with SMTP id w4so2729462wrl.13
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 10:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YRb6tBftcN4ywgPXESWRYJJkk+CvsoyUYJ93rzfhMU4=;
        b=QqZ8RpkPUy3ekFkt8tYP5MwF/INPyj5gRtiDjUkRCuss45+2Ia6BpoWZOdY+A4ILf2
         y07brBF4fO7IcH55eaehs0tTe14ElI+VP+n/TFOwuS/wsYkUwQK9VnbpxnxKZARmIo8r
         78MHZgQngxdULmrQaktTkahPqq7eojfB9y54Ugs5s7U8MEhSKEn45j1LaOfnJJuKA5Jo
         epjsiGmu+TXAvQW2Rxz3W93uyfZ0TRRQL6It0YOpcdEoQTtzwqFixsh0fW9W8NVA380x
         16aXnaOiP/CQEtt9XLjBHYWVOOD2V+JzcB1R6LSrCQUZVVm8v8cqqizOz451Ze3Ao//v
         dYgw==
X-Gm-Message-State: AOAM533e9LjTJ275o56VwVQKYY2SUH5dfdZk3PA3dkLG5Z8/VCm3VBuu
        ncV5YRUjsjs7rP8tO660AfUWZvZianpU4ILpAEV1LnzgTfmvrh222dv4uoVdEcS/gsJkbIvcGg9
        YCVAoMahbtXYq
X-Received: by 2002:a5d:548c:: with SMTP id h12mr5492278wrv.120.1591293400613;
        Thu, 04 Jun 2020 10:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlNwMQCPzZScok4aBC3SMcPaIZjURMRw+b5itxwYHzx4gbOSCjJlzT3dBoJesPlCEZMtDUEg==
X-Received: by 2002:a5d:548c:: with SMTP id h12mr5492252wrv.120.1591293400383;
        Thu, 04 Jun 2020 10:56:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id q13sm8582433wrn.84.2020.06.04.10.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 10:56:39 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: x86: Interrupt-based mechanism for async_pf
 'page present' notifications
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <3be1df67-2e39-c7b7-b666-66cd4fe61406@redhat.com>
 <20200604174534.GB99235@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <673d2612-53d2-4f86-1b88-dd9d8d974307@redhat.com>
Date:   Thu, 4 Jun 2020 19:56:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200604174534.GB99235@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 19:45, Vivek Goyal wrote:
>> I'll do another round of review and queue patches 1-7; 8-9 will be
>> queued later and separately due to the conflicts with the interrupt
>> entry rework, but it's my job and you don't need to do anything else.
> Hi Paolo,
> 
> I seee 1-7 got merged for 5.8. When you say patch 8-9 will be queue later,
> you mean later in 5.8 or it will held till 5.9 merge window opens.

I hope to get them in 5.8.  They have some pretty nasty conflicts that
are too much for Linus to resolve.  So my plan is to put 8-9 in a topic
branch and do the merge myself.  Whether this works out depends on the
timing of the tip pull request.

Paolo

