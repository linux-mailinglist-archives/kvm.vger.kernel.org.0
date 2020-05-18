Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85A1D77CA
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgERLvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 07:51:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37547 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbgERLvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 07:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589802675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7n8PqWCHeJpc4TOjEire+J+qqMuJFazIRRj2XcxpTw=;
        b=XVK6UNYdU4VywjmAFzz4rSomFZo8w69sYLirdlHx1eh00yqZdbohfw1W0EJ98pGELrKuON
        TqPwRXBuBNaOe6PH2k++ArrdnXzSkn32fPLAIta4YPLBJaoHLoKHIvcDY7r8/VzXdL2s5M
        MB88Df8pucHBWL2smivtNcJ7Ik42sUk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-vL2OonkLOzCOk8GufPPBkA-1; Mon, 18 May 2020 07:51:11 -0400
X-MC-Unique: vL2OonkLOzCOk8GufPPBkA-1
Received: by mail-wr1-f71.google.com with SMTP id n9so3659078wru.20
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 04:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K7n8PqWCHeJpc4TOjEire+J+qqMuJFazIRRj2XcxpTw=;
        b=psLF5Gv3TGvSxrnhTL8/hH9cNqh+L4SAWelrFLxAl/CKL8wqLAlEg1NBkOhmcPLTxM
         L7PL6ic0kIeD7AVf7j0aJKhkBbnrLVUNO3TSoxoyBahSvhUQ05cvS1VWCcOCKLgu36ri
         +TYqfmt9l/1lxIAP08H4AKyMAkSL5048EQjt56D0iEfjWRdOCGmqlCo0LUNZ8NZGqQUf
         hDEpKEpocL+l3kkZUFuTDaFE/Mvyq8nzKDlRpBTe3qqi3aROe93nQFx9KMSQ4efiD2V8
         61o9Y5M2EpJ3emaYGohUnAN5niXn4jbLrMiLC5rUkMR19IHXJRmeEdKgYy6JxGjCcb8p
         dUdQ==
X-Gm-Message-State: AOAM533uF6yLfPZylv9k97I4OdlMtncKGeiBQ0tRS50+PEEPhorDjWkH
        Kq7xub8IAH0m2Bus/P0KpiYoTW35wjbWzJUWF7SyrsovYx226nh1SdhsYtU1MT/oKTSfgeG9ucS
        y+YkKglQD5UNG
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13480481wmj.118.1589802670498;
        Mon, 18 May 2020 04:51:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz/MHpQNa5OfqyAyUmSWspHe0TEjiHHxK4p4e3uIbEs+RNZalGxhgvtsm502hRAzN6gU/urQ==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13480458wmj.118.1589802670294;
        Mon, 18 May 2020 04:51:10 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id m65sm16590858wmm.17.2020.05.18.04.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 04:51:09 -0700 (PDT)
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Anastassios Nanos <ananos@nubificus.co.uk>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
 <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
 <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f077234c-ea74-faaf-422a-fd5d2c1c6923@redhat.com>
Date:   Mon, 18 May 2020 13:51:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 13:34, Maxim Levitsky wrote:
>> In high-performance configurations, most of the time virtio devices are
>> processed in another thread that polls on the virtio rings.  In this
>> setup, the rings are configured to not cause a vmexit at all; this has
>> much smaller latency than even a lightweight (kernel-only) vmexit,
>> basically corresponding to writing an L1 cache line back to L2.
>
> This can be used to run kernel drivers inside a very thin VM IMHO to break up the stigma,
> that kernel driver is always a bad thing to and should be by all means replaced by a userspace driver,
> something I see a lot lately, and what was the ground for rejection of my nvme-mdev proposal.

It's a tought design decision between speeding up a kernel driver with
something like eBPF or wanting to move everything to userspace.

Networking has moved more towards the first because there are many more
opportunities for NIC-based acceleration, while storage has moved
towards the latter with things such as io_uring.  That said, I don't see
why in-kernel NVMeoF drivers would be acceptable for anything but Fibre
Channel (and that's only because FC HBAs try hard to hide most of the
SAN layers).

Paolo

