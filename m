Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97032CF9A1
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbfJHMTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 08:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbfJHMTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 08:19:34 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B619587633
        for <kvm@vger.kernel.org>; Tue,  8 Oct 2019 12:19:33 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id w2so9102475wrn.4
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 05:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Tgcww5rIiP7eqtGDNnoKDykhjXm7lkYPIyBimMQpM5Y=;
        b=JwUnxcL5dfQdGLIOAPwXjJcBj25uv7Auzh5zBIvaWo9xz9TUXkXGyxNmsfPcg0/4QS
         dzggFevhNrm0ZMcQO8j1O3hm4hKrmsz9vcRiAKo3V5UrSL+h5zGv5HlHhsftcqJfvEQe
         AsCI2H0TCxVGvw3TUgrqkQPukIPAf6DkjcRtnyr1t1gRz096vml033QVpq3Rd9hiSbWA
         yaIhE8J2kRIQ0jX3cVj5Mu8yWuaFwWDDBTHev9n4b7fKQpVqrdGSlv+PpCy9Hr178F1I
         VOWDBoyBmVA5uT4iHvpG7DkVqPG20TrQhEnd1a7DDA6JoB7MGdv/ttzCKGPkYbBdpNQE
         mEnw==
X-Gm-Message-State: APjAAAWSJ1WDQ/mrMA/KyGp4QDnQXr4BINW2i9UZmlNXPklIc7bvHWNX
        j38HXhnLrwqPyfZgaJyg1rpCo+b+WhoeSkn0ZyVmMwhpAmwLAAL7GiUz1QF/A/P1iGHtvK5s1Ar
        FpCOCpAeV0pVb
X-Received: by 2002:a1c:7f84:: with SMTP id a126mr3833830wmd.42.1570537172479;
        Tue, 08 Oct 2019 05:19:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzfYK1kF7k0Rob1/Nn6WWI2pop7NyT2Z0jyf2l6UlwLZESXs3eCX8fN08qZN5JAzlZUXfeWfw==
X-Received: by 2002:a1c:7f84:: with SMTP id a126mr3833819wmd.42.1570537172256;
        Tue, 08 Oct 2019 05:19:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r13sm31333320wrn.0.2019.10.08.05.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 05:19:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Subject: Re: KVM-unit-tests on AMD
In-Reply-To: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
Date:   Tue, 08 Oct 2019 14:19:30 +0200
Message-ID: <875zkz1lbh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nadav Amit <nadav.amit@gmail.com> writes:

> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>

It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
but the whole SVM would appreciate some love ...

> Clearly, I ask since they do not pass on AMD on bare-metal.

On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
failures:

FAIL vmware_backdoors (11 tests, 8 unexpected failures)

(Why can't we just check
/sys/module/kvm/parameters/enable_vmware_backdoor btw???)

FAIL svm (15 tests, 1 unexpected failures)

There is a patch for that:

https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.com/T/#t

Inside a VM on this host I see the following:

FAIL apic-split (timeout; duration=90s)
FAIL apic (timeout; duration=30)

(I manually inreased the timeout but it didn't help - this is worrisome,
most likely this is a hang)

FAIL vmware_backdoors (11 tests, 8 unexpected failures)

- same as on bare metal

FAIL port80 (timeout; duration=90s)

- hang again?

FAIL svm (timeout; duration=90s)

- most likely a hang but this is 3-level nesting so oh well..

FAIL kvmclock_test 

- bad but maybe something is wrong with TSC on the host? Need to
  investigate ...

FAIL hyperv_clock 

- this is expected as it doesn't work when the clocksource is not TSC
  (e.g. kvm-clock)

Are you seeing different failures?

-- 
Vitaly
