Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056FAC090F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0QBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0QBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:01:21 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E82F769066
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:01:20 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id w8so1305852wrm.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYUf3269swMCb356I8ten6acxDaLYy9zQ3oYoIzC4oc=;
        b=tg/Mj9mffOH44BLqGiLbD7amr1BuZWTsuixVNGIhDBhpWAs7bdXXXrB+7mqPMlFE8/
         GSG2i/dDHFQBEL5U2bPMksRPwuwX85IBKmE71kKXQibzuUfard+GvIQV7Heaet1cMO33
         z2+RxoNJfdWhA0rAtUvMEgqpi564xyFlmjNhf/zk3ZQVlDvaj6vACZvAZlRjCmufmtfc
         qwC4yOlbEuyYMXTmM+TCVSUWgly9oTcdebFyynQvvbercSPywAvptnjKJWa6KpY74gfY
         A0Lu9WiCRefhA8pYI2g5QAEI/H7n3J7O7T4jC3SsAvGI7rpa/hbDHxhtnXTAho6I+LUR
         J2Zg==
X-Gm-Message-State: APjAAAVjyZPeh1Cl2u/EcdYFqKFG3hPsvko6VaRgbF96q+NSCwsaUEce
        ixd7Do914fK/snnrHP0ibUGdFaxMNK9Z6Rfr1H+tufnxY7u6+th1haVUpdZduSoKNJjc1mYeLDJ
        GE9bI43USXkRX
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr937728wmf.80.1569600079574;
        Fri, 27 Sep 2019 09:01:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxE2IgzLWO4GNLc7NBrPVSYif8q+vO+5CAneWuBqXudRIz16uLNlUao7ZiwB9xjb13xe+59Rg==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr937695wmf.80.1569600079310;
        Fri, 27 Sep 2019 09:01:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c18sm4263587wrv.10.2019.09.27.09.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:01:18 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <CALMp9eTqWamhCb6cu7AvnVi0u0Y2c5HsG3iaktNANa-JfBODLw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <61949e86-b42d-f658-f10a-e220fe04ae4d@redhat.com>
Date:   Fri, 27 Sep 2019 18:01:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTqWamhCb6cu7AvnVi0u0Y2c5HsG3iaktNANa-JfBODLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 17:55, Jim Mattson wrote:
>> "KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
>> varies by kvm version and host processor, but does not change otherwise."
>>
>> So it seems that PMU MSRs just can't be there. Revert?
> 
> The API design is unfortunate, but I would argue that any MSR that a
> guest *might* support has to be in this list for live migration to
> work with the vPMU enabled.

In theory yes, in practice this breaks any userspace that (such as
state_test) blindly takes the list and passes it to KVM_GET_MSR.

> I don't know about qemu, but Google's
> userspace will only save/restore MSRs that are in this list

Almost, there are a few MSRs that it saves/restores always (TSC,
kvmclock, MTRR, PAT, sysenter CS/ESP/EIP, and on 64-bit machines
CSTAR/KERNELGSBASE/FMASK/LSTAR) and some where it compiles the list fom
KVM_GET_SUPPORTED_CPUID information (the PMU and processor tracing).

Of these, PMU and processor tracing seem to be the only one that vary
per VM.  So yeah, it needs to be reverted I suppose.

Paolo
