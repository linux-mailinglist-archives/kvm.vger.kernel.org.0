Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682F9182442
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgCKVxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:53:55 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50656 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbgCKVxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 17:53:54 -0400
Received: by mail-pj1-f66.google.com with SMTP id u10so1626374pjy.0
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 14:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bgj+vrWTEeOgbPTZYaBfAIMxs505axk/XYWCUaokL0Q=;
        b=aZcEM1PY6F0ZqLSUZ+Cgw3RZQQ7ble4udV1L5IGF3s7lgmB1SquyFhiYXqFKY54pVL
         8IAr4Q4R4P3CuaXLryj/r4FuAWgvib2Z6cHgNd0Kt+HdcpiHfkI4Is/F8MWuAReD8bpH
         jmF8IccSkoiNusFaOKamWsriZDt3PIxNByl/DLeLCfUJTfby6+nq8LZfXO64XMIAVQHY
         iLrNuAqP3SpYaAKobmkhI3JIfCto5H+71l9EwK/3QsuPJWZNhBG0md9LfvT3HYo0iDx5
         dcE3P8DTmE47XtRvHhDb4TvrQSiAr3x2Rh3jaogoCy4Agso/n678SFQjlddbg2CeVa7e
         ry4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bgj+vrWTEeOgbPTZYaBfAIMxs505axk/XYWCUaokL0Q=;
        b=DSBNSy2YrycUTQ77aA7VOkHgpr2GGUqfFoTp3oLopzp3asREVLxM2/K8Hq8CZMBq8W
         glDYLVFImR9Zj8k8qU5yEHPEoIx+3OTdpW1Q7+A2BZ9ikO46g0RfonV79yUQ2w4lqJTE
         24CD0fdKNMMpzBSqVkGN/Ct1TMPlpTubIFA2JLkn4vg0PdUfBCNE/PRA6r2OgtwHUMCf
         2mABW/dfORF8wWsfRJCLzB+uTp+RM30ib16uOPw3VTGjEPiS7w7DZ4uTGKwEJoC3gfO4
         S6LrBRcy6N4TqOF4eJvVBQ+w/OoumkPiaFLudytqNnLNbNzXtnrLJP8lu/+peIP7KzBr
         bKqw==
X-Gm-Message-State: ANhLgQ0lIlclmehgo7P1eBiIkXi5lJvHj/Oe+OGwwHaDDNQaFzOCxVqr
        vZMKFVRYObTxmLvWgaseUCA=
X-Google-Smtp-Source: ADFU+vuqwNQgIm7w2esOPmwghHSjqQNVGxII0Ju8nIUkqPcIGl6MRQo4xgFui+LwOQgM/OPB3CiWmA==
X-Received: by 2002:a17:90b:1991:: with SMTP id mv17mr786506pjb.148.1583963633334;
        Wed, 11 Mar 2020 14:53:53 -0700 (PDT)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y15sm1663865pfc.206.2020.03.11.14.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 14:53:52 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200311214657.GJ21852@linux.intel.com>
Date:   Wed, 11 Mar 2020 14:53:51 -0700
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, jmattson@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 11, 2020, at 2:46 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Mar 11, 2020 at 01:38:24PM -0700, Krish Sadhukhan wrote:
>> On 3/11/20 8:05 AM, Sean Christopherson wrote:
>>>> +static void test_guest_segment_sel_fields(void)
>>>> +{
>>>> +	u16 sel_saved;
>>>> +	u16 sel;
>>>> +
>>>> +	sel_saved =3D vmcs_read(GUEST_SEL_TR);
>>>> +	sel =3D sel_saved | 0x4;
>>>> +	TEST_SEGMENT_SEL(GUEST_SEL_TR, "GUEST_SEL_TR", sel, sel_saved);
>>>> +
>>>> +	sel_saved =3D vmcs_read(GUEST_SEL_LDTR);
>>>> +	sel =3D sel_saved | 0x4;
>>>> +	TEST_SEGMENT_SEL(GUEST_SEL_LDTR, "GUEST_SEL_LDTR", sel, =
sel_saved);
>>>> +
>>>> +	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
>>>> +	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
>>> Rather than react to the environment, these tests should configure =
every
>>> relevant aspect and ignore the ones it can't change.  E.g. the unit =
tests
>>> aren't going to randomly launch a vm86 guest.  Ditto for the =
unusuable bit,
>>> it's unlikely to be set for most segments and would be something to =
test
>>> explicitly.
>>=20
>>=20
>> Just wanted to clarify on the "unusable bit" part of your comment. Do =
you
>> mean each of the segment register checks from the SDM should have two =
tests,
>> one with the "unusable bit" set and the other with that bit not set,
>> irrespective of the checks being conditional on the setting of that =
bit ?
>=20
> Sort of.  In an ideal world, kvm-unit-tests would verify correctness =
of KVM
> for both unusable=3D1 and unusable=3D0.  But, the unusable=3D1 =
validation space is
> enormous, i.e. there are a bazillion combinations of random garbage =
that can
> be thrown into GUEST_*S_{SE,ARBYTE,BASE}.  So yeah, it could be as =
simple as
> running the same test as unusable=3D0, but expecting VM-Entry to =
succeed.
>=20
> That being said, I don't understand the motivation for these tests.  =
KVM
> doesn't have any dedicated logic for checking guest segments, i.e. =
these
> tests are validating hardware behavior, not KVM behavior.  The =
validation
> resources thrown at hardware dwarf what kvm-unit-tests can do, i.e. =
the
> odds of finding a silicon bug are tiny, and the odds of such a bug =
being
> exploitable aginst L0 are downright miniscule.

I see no reason for not including such tests. Liran said he uses
kvm-unit-test with WHPX, and I also use it in some non-KVM setups.

