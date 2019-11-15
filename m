Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D527FDB3F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKOKXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:23:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725829AbfKOKXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=LJZWUyJg1E7Ij2ZZHY26+UinwqVcbOZ6aWiHNuzktJI=;
        b=euV7T3JXvni5+NbuyaaaW1rZXGb72Sv72BCmBeqDYj7AoLGyAorvkkSZNn5iktJIfkpz7Y
        PbDuVzIE6cTH/n66Mwc9KPmJMOap9qt9Tqe7CNp8oJxPQHsL1ZcRix5XhTrZzOnfTsYQYl
        qw/bdvNfAVQIEB72nEK4wNnt44+y2Z8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-xghVkPOBMuK_lNpPjMRJaw-1; Fri, 15 Nov 2019 05:23:31 -0500
Received: by mail-wr1-f69.google.com with SMTP id h7so7444332wrb.2
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riFyzWaRE74yUZSs6ib0kQ72YifLNntorBklihK+wDI=;
        b=tiv3QnkBX02hAJzeFCQYWu91jMxK5D+II8zOpQ7P1jwNq/G9oGqcsFBvIiKq6jVxWB
         G5Txk4/+mNW0njSIXTliEG20dKDR/GsT07nxp/qqJJnO82NNtwwI2VMees18Bp9ZjHPM
         HAW8KIF/7fyLoXo1H1yfDygXf5NAp4bqIQbVVw9kOBLWr+wIEpfJHtlbBCBwaJ6rsAeh
         jNJeniiU8suZL2yHz04rtebQGaAQqMrb4aZkgIRLDZWf6aaMGJGOMdJqwvOs8QgTsIrb
         OvYhiOh4ou1oEqo0rGicqvxn7HgGMUC1OLWZoE4ldtyTmtu2YwwZy6Ct3ND5HMbWeXZM
         TI8Q==
X-Gm-Message-State: APjAAAVBb3MF3JBAp7uk+I32MeHQmh3ckQKCkjfTy7Lb+3P2rVCWSRSe
        L3ZTsqPbAb6u0Sn3PQZey8k6532G0XW6ZxiDIw2mApxkdMyGf7L3a04HO+4cl7EKffzTRgnxqXD
        4tysuElb1axA+
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr14252348wmj.84.1573813410121;
        Fri, 15 Nov 2019 02:23:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwMwx6a770dZjGE4P17esD4gi1/RVlddRrwe3oSfYO+0m0/Z9SDE1Hv1R2OTDXA3Mk8Dy+ZzA==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr14252323wmj.84.1573813409759;
        Fri, 15 Nov 2019 02:23:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id b196sm9744061wmd.24.2019.11.15.02.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:23:29 -0800 (PST)
Subject: Re: [PATCH v4 0/4] Add support for capturing the highest observable
 L2 TSC
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191108051439.185635-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <52b9e145-9cc6-a1b5-fee6-c3afe79e9480@redhat.com>
Date:   Fri, 15 Nov 2019 11:23:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108051439.185635-1-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: xghVkPOBMuK_lNpPjMRJaw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/11/19 06:14, Aaron Lewis wrote:
> The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
> vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
> TSC value that might have been observed by L2 prior to VM-exit. The
> current implementation does not capture a very tight bound on this
> value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
> vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
> MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
> during the emulation of an L2->L1 VM-exit, special-case the
> IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
> VM-exit MSR-store area to derive the value to be stored in the vmcs12
> VM-exit MSR-store area.
>=20
> v3 -> v4:
>  - Squash the final commit with the previous one used to prepare the MSR-=
store
>    area.  There is no need for this split after all.
>=20
> v2 -> v3:
>  - Rename NR_MSR_ENTRIES to NR_LOADSAVE_MSRS
>  - Pull setup code for preparing the MSR-store area out of the final comm=
it and
>    put it in it's own commit (4/5).
>  - Export vmx_find_msr_index() in the final commit instead of in commit 3=
/5 as
>    it isn't until the final commit that we actually use it.
>=20
> v1 -> v2:
>  - Rename function nested_vmx_get_msr_value() to
>    nested_vmx_get_vmexit_msr_value().
>  - Remove unneeded tag 'Change-Id' from commit messages.
>=20
> Aaron Lewis (4):
>   kvm: nested: Introduce read_and_check_msr_entry()
>   kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS
>   kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
>   KVM: nVMX: Add support for capturing highest observable L2 TSC
>=20
>  arch/x86/kvm/vmx/nested.c | 136 ++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/vmx/vmx.c    |  14 ++--
>  arch/x86/kvm/vmx/vmx.h    |   9 ++-
>  3 files changed, 131 insertions(+), 28 deletions(-)
>=20

Queued, but it would be good to have a testcase for this, either for
kvm-unit-tests or for tools/testing/selftests/kvm.

Paolo

