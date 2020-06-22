Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF6F203EA3
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgFVSB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 14:01:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730246AbgFVSB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 14:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592848914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiPE/eywHM8Zlh7BqbyFgYnaqP2KFeRz5sUsSupRbV4=;
        b=c8zNtSqbhY4MYml6JtXvTOxm8M0HaB7sR452P8X+YPgIIZgR+190JfzaLL/CgZTHLCt5w4
        OlOK88dl/jq+tiWnGVfHLpZk5IiWszw89gU4AxaqgEi9qsfPTQLnrdXCTA3NpwUc1rWvl/
        bH8eGlUAQk9nd/NLiQB/euI+ZIvZiuU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-FsdnCrIOPESAp1aCfosdSw-1; Mon, 22 Jun 2020 14:01:48 -0400
X-MC-Unique: FsdnCrIOPESAp1aCfosdSw-1
Received: by mail-wr1-f71.google.com with SMTP id p9so11385354wrx.10
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 11:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EiPE/eywHM8Zlh7BqbyFgYnaqP2KFeRz5sUsSupRbV4=;
        b=oAOV8+xd/p2mxgyqSQ6/fi1CoZcXY7PlAibEdGRmfWo3wqO0p8UTvy/8JAgEv9Tti/
         kWWF8MM2pR2beWxBMIpvJWvhEUWCBZD5ZR8V+7nBA1NPhaVExlLRC1yJF5MG5IU/oA4j
         hzlMk8xSYfdG+/4n7A7X2dhG19eiv8lzo3tNNaLEjYBDIXYr+G4M3p6hMIl2K+v95dn+
         TK7gayf/SdrGaXQRKK/CBMNXKcnHYP1gQ9hYVgzAFrDT3kCuzvAM2AWHyf79sXSpYwpB
         WdKvFc5iLJbgk1kJPE7cNufLTS6dpK3rlXIkCRq1GP4GSr8eV32RzTBkW6nJcgyo8ALZ
         PQ+Q==
X-Gm-Message-State: AOAM533pBIcgbbJqAGnQFq0YVgFm51wHltuM8OtQOf1/smCitbdFoGSg
        uU7axsqAqqKRi4XRgwE0pr+JYDqFIzO+KtIO+zK8vf4zaPtTD/yzAc5+DHu+7yzCcDORPPX4rAe
        eMEJ3H1u3oyzA
X-Received: by 2002:adf:e80a:: with SMTP id o10mr20912750wrm.185.1592848907206;
        Mon, 22 Jun 2020 11:01:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywKtN0A+o5NJL2EDMhmcg7QtC83uSGVNvOTAksFhKv0w2PvIEBb39TCc2Fpd4C2r7Vr0waSA==
X-Received: by 2002:adf:e80a:: with SMTP id o10mr20912729wrm.185.1592848906985;
        Mon, 22 Jun 2020 11:01:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id c5sm380556wmb.24.2020.06.22.11.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 11:01:46 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
 <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
 <c89bda4a-2db9-6cb1-8b01-0a6e69694f43@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ed45f38-6a31-32ab-cec7-baade67a8c1b@redhat.com>
Date:   Mon, 22 Jun 2020 20:01:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <c89bda4a-2db9-6cb1-8b01-0a6e69694f43@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 19:57, Tom Lendacky wrote:
>>> In bare-metal, there's no guarantee a CPU will report all the faults in a
>>> single PF error code. And because of race conditions, software can never
>>> rely on that behavior. Whenever the OS thinks it has cured an error, it
>>> must always be able to handle another #PF for the same access when it
>>> retries because another processor could have modified the PTE in the
>>> meantime.
>> I agree, but I don't understand the relation to this patch.  Can you
>> explain?
>
> I guess I'm trying to understand why RSVD has to be reported to the guest
> on a #PF (vs an NPF) when there's no guarantee that it can receive that
> error code today even when guest MAXPHYADDR == host MAXPHYADDR. That would
> eliminate the need to trap #PF.

That's an interesting observation!  But do processors exist where either:

1) RSVD doesn't win over all other bits, assuming no race conditions

2) A/D bits can be clobbered in a page table entry that has reserved
bits set?

Running the x86/access.flat testcase from kvm-unit-tests on bare metal
suggests that all existing processors do neither of the above.

In particular, the second would be a showstopper on AMD.

Paolo

