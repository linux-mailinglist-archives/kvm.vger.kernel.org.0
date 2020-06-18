Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A31FE960
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 05:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFRDSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 23:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgFRDSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 23:18:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1453AC06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 20:18:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d6so2009837pjs.3
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 20:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1Nb0OKkrYI7UdUwYs4M/9iCS139uCuO87Yk1yKcZKtM=;
        b=dxmE6qRji4kPvuNtROXvm9eYHXzOZJvRUOt6F65MtnCl8R5EgI/5TTzvzskNvyD2Jk
         UiMqiRR3227QZLfSNc34aZ7iyWb15yQ2f2YBCsdfKArbvnT2NpayWJKLyebSubR+CV1j
         0VCXJ6TOrnnurUOxVUf1jmIuvm0DHZY/bKwWUnmahlVgAof3lGfwzsWvT1C3+7bPK8c8
         e7huquqCC9u46IpRv8llWpRa0mTWAfzekFrsXpyC8j8txHHc+O70VgI6S7ihhuQVdFLD
         Nrm9gE7YUImWS4wGL3w7XAuYjF2AHm9KwfoANJfx/Fur0KX+nNzj9PIytgDgkIivTKKE
         ndyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1Nb0OKkrYI7UdUwYs4M/9iCS139uCuO87Yk1yKcZKtM=;
        b=F+/to4pGVFdx49G2QkAe6x47p57C7RpvbbIldMfVQM017bs4N4S9M07VLHK1LgPrsK
         e6KGN1J2iVCVOKVcVVcax/wGWULGIO7mI8I+G48In2AX5IOddaE6JWTbfSqAi3yveHT8
         wvsNh1mAWOmwVtV25OLmAxiScQHrS/klH0xChhpKTxw+oLXGGwuoLUSBIZ8NCRl4YZmR
         OXXO84N7KeI8WZh8/0N9TMGEbrydwYVrBglpiU0ZfWmoOd1LH6f3UiB7a+zWxUAe46Gr
         FMrQPl9hz1sdA/id2Gll3D2vZIZ/zUgUf+lI1ZcJ7wgL4LOSKlrHpSjFCOg8aP3xykR6
         Sm7A==
X-Gm-Message-State: AOAM533Y86+5fdX/6hwV3YTtQCopDzPc3O8MmSx0yLzcsvV1bbD7lVfN
        ijebes8xCS4dGWjl6Gd6Mok=
X-Google-Smtp-Source: ABdhPJz4iVX0Bfn2/xKEDVp/mXf3F0o1/6hYnthCSZOlZbSvlfZvDuA9Kd5G7XPIPXPyeqiXXIqzyA==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr2090076plr.154.1592450322312;
        Wed, 17 Jun 2020 20:18:42 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:1c36:bfc:73ae:1f3? ([2601:647:4700:9b2:1c36:bfc:73ae:1f3])
        by smtp.gmail.com with ESMTPSA id o96sm815843pjo.13.2020.06.17.20.18.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 20:18:41 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
Date:   Wed, 17 Jun 2020 20:18:39 -0700
Cc:     corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
        sean.j.christopherson@intel.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
To:     John Andersen <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Jun 17, 2020, at 3:46 PM, John Andersen =
<john.s.andersen@intel.com> wrote:
>>=20
>> Paravirutalized control register pinning adds MSRs guests can use to
>> discover which bits in CR0/4 they may pin, and MSRs for activating
>> pinning for any of those bits.
>=20
> [ sni[
>=20
>> +static void vmx_cr_pin_test_guest(void)
>> +{
>> +	unsigned long i, cr0, cr4;
>> +
>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
>> +	/* nop */
>=20
> I do not quite get this comment. Why do you skip checking whether the
> feature is enabled? What happens if KVM/bare-metal/other-hypervisor =
that
> runs this test does not support this feature?

My bad, I was confused between the nested checks and the non-nested =
ones.

Nevertheless, can we avoid situations in which
rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
implemented? Is there some protocol for detection that this feature is
supported by the hypervisor, or do we need something like rdmsr_safe()?

