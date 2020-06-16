Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C074E1FBC0C
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgFPQpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:45:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47746 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729609AbgFPQpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 12:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592325939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ismgysJfJe2CLrWL0LmeWKazpTxHaimsQwhtZ2Vt0UQ=;
        b=RgMiILcIe4EGx+WqBbTbUoY6NL/JWFeeQ6DTQDDsyt7kj7KtEG/pIAc4F50CImoRgBR5gk
        ByXnFiPJwvyuN8ve+CJuWDrIAXUBc4iq22SksnRg6l1sEeqvl91tHqXO71I+cx4OkD68R8
        G8hQYDAl0dTeCLAn5b8xEIAzmQ3jAq8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-9ZufR66APE2rHCfJRBVwtg-1; Tue, 16 Jun 2020 12:45:37 -0400
X-MC-Unique: 9ZufR66APE2rHCfJRBVwtg-1
Received: by mail-ej1-f71.google.com with SMTP id bg25so4748307ejb.12
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 09:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ismgysJfJe2CLrWL0LmeWKazpTxHaimsQwhtZ2Vt0UQ=;
        b=uoEOAI4jzLSXhApyvjeK1jCGxl70U/nI/gPZjzwTaPXwBM2qA1ghOiwBGuDAuqdEv7
         9pWQXBCrScP0BTQBWynOGwnZ6Vcr0+MZHCBNVop9i1OZvhAI8/vAeH5ePwVu5raZl0/2
         0Mjh1Qq4RfRu6u9SsMxpFNZP3cb8joretKk9W3RTRQfmBycBYmeaITcklButE3VvZsGu
         35a9XzL4drllSvPmj5cidrERJiJRUGff4tnneWX0aiPIEQQ/StT3AKoqWwo5o/g7TTcC
         xRR5ExmMiZCHwZnjnFnZOA9tmBekcr1tnhYgHt6OhZmDyQEIo30T9dKV9tNhJdJHieFw
         sNxg==
X-Gm-Message-State: AOAM533j45f407n3ABTATDdi2+zZNJpRsOcoSPcfuQH+busjYmsyaVfp
        vYi5V7sPdXJ5r942VTd20BlBcscP3mXav0iJnzbvLILAgmEEzZFICpcxomV0fDGhFyguzC77EL3
        R83XOZpsCAeAL
X-Received: by 2002:a50:fd05:: with SMTP id i5mr3314282eds.79.1592325936098;
        Tue, 16 Jun 2020 09:45:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDneB8f/xDlNMJMpcox0nyWfsNpeZIDOB7EkaXqbs8xOHs3NkFJkjWLLuMBH+YlLczpJyl+w==
X-Received: by 2002:a50:fd05:: with SMTP id i5mr3314262eds.79.1592325935901;
        Tue, 16 Jun 2020 09:45:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ce25sm10365363edb.45.2020.06.16.09.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:45:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated MSRs
In-Reply-To: <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com>
References: <20200616161427.375651-1-vkuznets@redhat.com> <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com>
Date:   Tue, 16 Jun 2020 18:45:34 +0200
Message-ID: <87366vhscx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jun 16, 2020 at 9:14 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> state_test/smm_test selftests are failing on AMD with:
>> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
>>
>> MSR_IA32_PERF_CAPABILITIES is an emulated MSR indeed but only on Intel,
>> make svm_has_emulated_msr() skip it so it is not returned by
>> KVM_GET_MSR_INDEX_LIST.
>
> Do we need to support this MSR under SVM for cross-vendor migration?
> Or, have we given up on that?

To be honest I'm not sure about the status of cross-vendor migration in
general and PMU implications in particular, hope Paolo/Sean can shed
some light. In this particular case my shallow understanding is that
MSR_IA32_PERF_CAPABILITIES has only one known feature bit which unlocks
an MSR range with additional counters. If the feature bit is not set
this, I guess, can easily be migrated (basically, let's allow writing
'0' there on AMD and return '0' on read). But what if the feature was
enabled? We'll have to support the new MSR range and do something with
it after migration (run intel_pmu in fully emulated mode?).

Anyway, the immediate issue I'm trying to fix here is: whatever is
returned by KVM_GET_MSR_INDEX_LIST can be successfully queried with
KVM_GET_MSRS as some userspaces count on that.

-- 
Vitaly

