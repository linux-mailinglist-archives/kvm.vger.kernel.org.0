Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DFD1BF8D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 00:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfEMWnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 18:43:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41544 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfEMWnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 18:43:23 -0400
Received: by mail-pf1-f195.google.com with SMTP id l132so7963153pfc.8
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Iz17uylUOixOvYoCts1S5k/pag2CDfw8pil6TBcK9uE=;
        b=hfOUciK+DtqQ1B5UwZoPdzAmR3FUYG7xa6ZqtInshTOXa/7Lh1UWQwc7zi/Gl8rykh
         1iuyJIhEOc+eB3y5JwO4t8HRZvcrL0Wp3Ln0Gfs4SpIZywealFWWPZ5Jv9JPuQl2hmWf
         C1OhP2tk+QSkTA6/Mkaf/j7/JKrDjrK6egrjJlFQ0foAk+J01WC5nq6b2ezg91A5iRdn
         CLJOvrElyT/78S5UFNHlYbVqpWul46BF8Y9+MbFLq5va35gR7VlnQZE9tYyLSdq6J+P5
         DX6leFoRQNnrNBK+4TcekYL/zJl2iBIoGXZ6GAECDPeLR0fb1RKs3MQnpOWo5h7TJ202
         cobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Iz17uylUOixOvYoCts1S5k/pag2CDfw8pil6TBcK9uE=;
        b=XykGCA1UiJ1FlQA3xvyIgLiRkj3gOu5I7+a0l71joClcmeBortXcYnvnL/fI334ay1
         dCOoV/ckTKGREuJVSnohMFHlHKLdi8cDEP6RNNfWQKnItiZ/6cJ3cVlrMeKxwBr/uIb9
         NAzM7r8XPE6gL4+ALHFL6THOMwU2t/v5QS+CgLunmqVn6NJhmDJjjK2nrFB0fBIhMggn
         RpkHhQKkzzGunDOxn0Sk8tRqfb6HQHsAHIvmfwtXoJcy4grPlTQc51yRpTBE8Sa2hw7N
         OqL0kGjgEz2lW7W2nrZqXCT5AoQlkIRmzH7Yv0h1EqMIcsK6Rip9K0/RmLnzaW05bXwd
         bwSA==
X-Gm-Message-State: APjAAAWm/4C/O4cUvI4Ad1IHdrZc2yHFPOwxXNWprXRPCvxMPHSC2Aub
        CEVuSqRf1i+ABLE+6/R7kX6OuZXC
X-Google-Smtp-Source: APXvYqwMRvoYxDKf4fsXghb+IJBxNq3wK1BOJM/ZOvSDEmXRpBaDg8YCzhZP51p4FzP9Dq6KzTx1Cg==
X-Received: by 2002:a63:6988:: with SMTP id e130mr34928225pgc.150.1557787402895;
        Mon, 13 May 2019 15:43:22 -0700 (PDT)
Received: from [172.30.49.191] (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l1sm17494547pgp.9.2019.05.13.15.43.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 15:43:22 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Dynamically calculate and check
 max VMCS field encoding index
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190416013832.11697-1-sean.j.christopherson@intel.com>
Date:   Mon, 13 May 2019 15:43:18 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <04F148C8-5E44-4195-97E7-35A428E36983@gmail.com>
References: <20190416013832.11697-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 15, 2019, at 6:38 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Per Intel's SDM:
>=20
>  IA32_VMX_VMCS_ENUM indicates to software the highest index value used
>  in the encoding of any field supported by the processor:
>    - Bits 9:1 contain the highest index value used for any VMCS =
encoding.
>    - Bit 0 and bits 63:10 are reserved and are read as 0
>=20
> KVM correctly emulates this behavior, in no small part due to the VMX
> preemption timer being unconditionally emulated *and* having the =
highest
> index of any field supported in vmcs12.  Given that the maximum =
control
> field index is already above the VMX preemption timer (0x32 vs 0x2E),
> odds are good that the max index supported in vmcs12 will change in =
the
> not-too-distant future.
>=20
> Unfortunately, the only unit test coverage for IA32_VMX_VMCS_ENUM is =
in
> test_vmx_caps(), which simply checks that the max index is >=3D 0x2a, =
i.e.
> won't catch any future breakage of KVM's IA32_VMX_VMCS_ENUM emulation,
> especially if the max index depends on underlying hardware support.
>=20
> Instead of playing whack-a-mole with a hardcoded max index test,
> piggyback the exhaustive VMWRITE/VMREAD test and dynamically calculate
> the max index based on which fields can be VMREAD.  Leave the existing
> hardcoded check in place as it won't hurt anything and test_vmx_caps()
> is a better location for checking the reserved bits of the MSR.

[ Yes, I know this patch was already accepted. ]

This patch causes me problems.

I think that probing using the known VMCS fields gives you a minimum for =
the
maximum index. There might be VMCS fields that the test does not know =
about.
Otherwise it would require to update kvm-unit-tests for every fields =
that is
added to kvm.

One option is just to change the max index, as determined by the probing =
to
be required to smaller or equal to IA32_VMX_VMCS_ENUM.MAX_INDEX. A =
second
option is to run additional probing, using IA32_VMX_VMCS_ENUM.MAX_INDEX =
and
see if it is supported.

What do you say?=
