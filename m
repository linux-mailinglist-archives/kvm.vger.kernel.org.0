Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DFFCFD25
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 17:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfJHPGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 11:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbfJHPGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 11:06:05 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4F197BDAC
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 15:06:04 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id n3so1527013wmf.3
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 08:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YDDOICmpIJztksi4vhnm7nHeqvXthG8WEL5li566+RI=;
        b=ObmY8BY+OsBJcbKu66ENQ/jfEAXo23U3d1v5TGaTy9qSzYhf+Y8qo5zRlz3OvTao6l
         W6zcBYFwOmZTKtRdp3bqpJmTjLSubithMzYlfqRy4ktLHfe4cNj34XUqNomATaVF6feu
         od3glV1VVe7thBKo1l13HxJ64g2kLLVVNj1hRYsZ4nZ0M+6LovghT+9cGnAr3SRH1hJW
         wiqfpmH4dMksL5z9tF9TKHppuA7gc6bwd2f7iN2eQfwT11KhppKpoKhTHLMUtrGBS6R/
         ySrW7Xq97zxlx02KhA/3UT51whZadk3x6MjXTn2Xf/2WLCp/2e5a5g5tEUULjVn7n2PU
         f0PQ==
X-Gm-Message-State: APjAAAVtdbIz12+NCM415cycvuEyP20B79TRXx+ol2fQaHOaaE3cHRu6
        aV6ZI5K0tiHhl2hbeIVfiCusI4oirhR3Q35Qr1rOHpdZidX41Pa9vGYBXOpLxu7JVRVpg7BoaAm
        bDd4Mvjxane+8
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr3999361wmd.172.1570547163408;
        Tue, 08 Oct 2019 08:06:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEXVA82UV5YInxhIH8aGUh0Es0frd1O6zHSdtiKPlqgvTaKH0A+maFlZvwXhvGOJyLRxLi4g==
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr3999342wmd.172.1570547163143;
        Tue, 08 Oct 2019 08:06:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y186sm6168893wmb.41.2019.10.08.08.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:06:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Subject: Re: KVM-unit-tests on AMD
In-Reply-To: <CA+res+QTrLv7Hr9RcGZDua6JAdaC3tfZXRM4e9+_kbsU72OfdA@mail.gmail.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com> <875zkz1lbh.fsf@vitty.brq.redhat.com> <CA+res+QTrLv7Hr9RcGZDua6JAdaC3tfZXRM4e9+_kbsU72OfdA@mail.gmail.com>
Date:   Tue, 08 Oct 2019 17:06:01 +0200
Message-ID: <87wodfz38m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jack Wang <jack.wang.usish@gmail.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> 于2019年10月8日周二 下午2:20写道：
>>
>> Nadav Amit <nadav.amit@gmail.com> writes:
>>
>> > Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>> >
>>
>> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
>> but the whole SVM would appreciate some love ...
>>
>> > Clearly, I ask since they do not pass on AMD on bare-metal.
>>
>> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
>> failures:
>>
>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>
>> (Why can't we just check
>> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>>
>> FAIL svm (15 tests, 1 unexpected failures)
>>
>> There is a patch for that:
>>
>> https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.com/T/#t
>>
>
>> Are you seeing different failures?
>>
>> --
>> Vitaly
> On my test machine AMD Opteron(tm) Processor 6386 SE, bare metal:
> I got similar result:
> vmware_backdoors (11 tests, 8 unexpected failures)
> svm (13 tests, 1 unexpected failures), it failed on
> FAIL: tsc_adjust
>     Latency VMRUN : max: 181451 min: 13150 avg: 13288
>     Latency VMEXIT: max: 270048 min: 13455 avg: 13623

Right you are,

the failing test is also 'tsc_adjust' for me, npt_rsvd_pfwalk (which
Cathy fixed) is not being executed because we do '-cpu qemu64' for it.

With the following:

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b4865ac..5ecb9bb 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -198,7 +198,7 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-extra_params = -cpu qemu64,+svm
+extra_params = -cpu host,+svm
 arch = x86_64
 
 [taskswitch]

everything passes, including tsc_adjust:

PASS: tsc_adjust
    Latency VMRUN : max: 43240 min: 3720 avg: 3830
    Latency VMEXIT: max: 36300 min: 3540 avg: 3648

-- 
Vitaly
