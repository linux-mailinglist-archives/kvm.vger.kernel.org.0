Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4551B44DB36
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhKKRrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:47:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhKKRrT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 12:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636652668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sX6B0wyq8HXK/qZ80X8Qyra7US9S5w1/aYmWEs7Zq+o=;
        b=Jj+034szHR6fItQrKYRqoVCNJL/33yXLcJD2wzo6jr/Q62E/tv9hifC7yD5LDG+41LdaZ3
        wHIfOzwSApfc6UWUyfGmKCLipGHqR/xodd2Qq9n0nI/zq0xs5VOBQBdQGYcFZ304q+3YY1
        fC90iggha62yIi1IaFQ9krD//itvWeE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-dnevnGT0Nd6kbuZpE-6fsw-1; Thu, 11 Nov 2021 12:44:26 -0500
X-MC-Unique: dnevnGT0Nd6kbuZpE-6fsw-1
Received: by mail-ed1-f71.google.com with SMTP id m8-20020a056402510800b003e29de5badbso6011626edd.18
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sX6B0wyq8HXK/qZ80X8Qyra7US9S5w1/aYmWEs7Zq+o=;
        b=Gjz1D5rnFoK7S7GR73sy5nRK0YSJ2vRACbEdptv+pbzzHSgqkiJ71Ew+YvL9hlOoNH
         y/U6emYSvpccND5es9QBE/wS7DWtqNOxRUr6hLe8msnsFhKZSn1SpTito5xBD4Yqf9O7
         wMKwgll1cIY3besNzmSmP48vCia7BAaw1OUt80uMMjG0h+nsiy+bg8mnt7Ya0j4Ogm4L
         J4NAXJfg5hCJukzO9zvO98Ct3lHu+W+qvjU0wMSL9lNBJLkBkqB1uW6pZ31xR5X9/nCV
         eNmFMTJT67fnNcBPRCIhZVYkL62tWNnbkLQbSPbTMPQ+GMXQ0fZNcaf2nkRoljmZGb3e
         lRVA==
X-Gm-Message-State: AOAM530KbYirrOzfzg5av6fFh2IC9X4SAB8Cr5mvYRYPJxRttPOmyUFd
        IGaM5WhfwVMXs3QIs6PYq8+NdEWUNr9IDnt3NQUJ7uVpTj/GtLSPRam58b4L1/z0W3gN/q5pWW0
        dMFh8vAigOEKr
X-Received: by 2002:a17:907:97d4:: with SMTP id js20mr11645113ejc.416.1636652664863;
        Thu, 11 Nov 2021 09:44:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdkCpqIpkvubDcpdA5m395LNP8ARB3mV6RpcSqRqiKVzoQRjs09kHpMw3c9AwsjokND/kS/w==
X-Received: by 2002:a17:907:97d4:: with SMTP id js20mr11645080ejc.416.1636652664630;
        Thu, 11 Nov 2021 09:44:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id hr11sm1589279ejc.108.2021.11.11.09.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 09:44:24 -0800 (PST)
Message-ID: <4b2a99db-bd7e-fde8-695a-5d198da45f3e@redhat.com>
Date:   Thu, 11 Nov 2021 18:44:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR
 persistence bug
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20211015195530.301237-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/21 21:55, Jim Mattson wrote:
> In Linux commit afc8de0118be ("KVM: nVMX: Set LDTR to its
> architecturally defined value on nested VM-Exit"), Sean suggested that
> this bug was likely benign, but it turns out that--for us, at
> least--it can result in live migration failures. On restore, we call
> KVM_SET_SREGS before KVM_SET_NESTED_STATE, so when L2 is active at the
> time of save/restore, the target vmcs01 is temporarily populated with
> L2 values. Hence, the LDTR visible to L1 after the next emulated
> VM-exit is L2's, rather than its own.
> 
> This issue is significant enough that it warrants a regression
> test. Unfortunately, at the moment, the best we can do is check for
> the LDTR persistence bug. I'd like to be able to trigger a
> save/restore from within the L2 guest, but AFAICT, there's no way to
> do that under qemu. Does anyone want to implement a qemu ISA test
> device that triggers a save/restore when its configured I/O port is
> written to?
> 
> Jim Mattson (3):
>    x86: Fix operand size for lldt
>    x86: Make set_gdt_entry usable in 64-bit mode
>    x86: Add a regression test for L1 LDTR persistence bug
> 
> v1 -> v2:
>    Reworded report messages at Sean's suggestion.
>    
>   lib/x86/desc.c      | 41 +++++++++++++++++++++++++++++++----------
>   lib/x86/desc.h      |  3 ++-
>   lib/x86/processor.h |  2 +-
>   x86/cstart64.S      |  1 +
>   x86/vmx_tests.c     | 39 +++++++++++++++++++++++++++++++++++++++
>   5 files changed, 74 insertions(+), 12 deletions(-)
> 

Queued patches 1 and 3; the function of 2 is also done by my own GDT/IDT 
cleanup series, which is also present in Aaron's #PF tests.

Paolo

