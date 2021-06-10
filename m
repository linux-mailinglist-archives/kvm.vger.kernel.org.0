Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7775F3A2B9B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFJMcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:32:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhFJMc3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623328233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVoiHxqAd6aQAtB+HJlB46eioLbZAvstwtt/eGYsy6Y=;
        b=XBVAr81BHml3o0ljtKrVafHpjMpqXgmyLV8UzRJZtJ3BOGMqJNrZJlTwIhI3giEZ9V7bZy
        b6kbhcakFCZrwaKFWaTfh7bK/BcFaUi179WVCPsn5P8xl2/QpTazgiLC08vQcWLGJyprMS
        yfSEVHEcJuYDCSkbGbvBHYS2Zfm/JOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-at8l7rlRNbOhD-p7nALrgA-1; Thu, 10 Jun 2021 08:30:32 -0400
X-MC-Unique: at8l7rlRNbOhD-p7nALrgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C1E41015C8F;
        Thu, 10 Jun 2021 12:30:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1798A60FC2;
        Thu, 10 Jun 2021 12:30:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/8] x86: non-KVM improvements
Date:   Thu, 10 Jun 2021 08:30:29 -0400
Message-Id: <162332821539.174323.14090781989794920220.b4-ty@redhat.com>
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 18:29:37 +0000, Nadav Amit wrote:
> This set includes various fixes and improvements, mostly for non-KVM
> environments.
> 
> The purpose of the patches are: easier to parse test results, skipping
> tests that are unsupported and few fixes to tests.
> 
> Nadav Amit (8):
>   lib/x86: report result through serial console when no test device
>   x86/tsx-ctrl: report skipping tests correctly
>   x86/smptest: handle non-consecutive APIC IDs
>   x86/hypercall: enable the test on non-KVM environment
>   x86/hyperv: skip hyperv-clock test if unsupported by host
>   x86/syscall: skip TF-test if running neither on KVM nor AMD
>   x86/pmu: Skip the tests on PMU version 1
>   x86/vmx: skip error-code delivery tests for #CP
> 
> [...]

Applied, thanks!

[1/8] lib/x86: report result through serial console when no test device
      commit: 5747945371b47c51cb16187a26111d06f58f06b2
[2/8] x86/tsx-ctrl: report skipping tests correctly
      commit: c8312cbd25df6bf350a9654b6c0364b213ba406c
[3/8] x86/smptest: handle non-consecutive APIC IDs
      commit: 90ab30c22dbb18b6d9804421ef3f160cfef031b8
[4/8] x86/hypercall: enable the test on non-KVM environment
      commit: 22abdd3999b7c17ba976d31706852b92fb45cd5a
[5/8] x86/hyperv: skip hyperv-clock test if unsupported by host
      commit: 5067df40755d6f3a3363c99a1054b6de21a556e1
[6/8] x86/syscall: skip TF-test if running neither on KVM nor AMD
      commit: c1e64e2fe08cecc9dcac5b2f72488c74c5134d34
[7/8] x86/pmu: Skip the tests on PMU version 1
      commit: 70972e212ee4af14b603131fc27c67a0cf29d458
[8/8] x86/vmx: skip error-code delivery tests for #CP
      commit: c986dbe8670535e4f88871b1e8b8480bdc256ded

Best regards,
-- 
Paolo Bonzini <pbonzini@redhat.com>

