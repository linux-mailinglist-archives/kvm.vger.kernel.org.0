Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1476DC2ACD
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfI3XZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:25:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46996 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbfI3XZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:25:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so8217440pgm.13
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5ND9olyH6PryxDEfMSbX/dKIZa2dPmewv+flF1bNewM=;
        b=aJSIraOk1PvvPQgG7dJkgpnj9Eu0FxWC873npj/Tpo01rc+EisiWB9nETf5qYnePW0
         xUWIs4TvtzwsFrK4wINHaQAR0sxMn9Em0jXU8xKR+4JeGXfWPbTGiGFQvYSkkUhhdPeT
         DFz4WS24Ytk5TIVvn1yflAHoof9HC0rkmACXelCgA4ydUXmrIpgSK1GGjobScBgdRW7n
         lZHzj2chwJ4xMuUBeHpoZqXeYid+C6MZzYqGhn5ihxjaVG0W6eIVoVIRj+dAw9dPVDML
         DUsEkVkJSJysu+t/Cn+gR+ZJ3e3n5Zm7JM8iGpTfZCyAPhvMMga7SG62Y2nHAjrnUR97
         Vqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5ND9olyH6PryxDEfMSbX/dKIZa2dPmewv+flF1bNewM=;
        b=D6B2KwueNna+eSDm/jkOL77O8O5I33uN+4Lh+vmPuVpE25fM54g0UhmmX5TV0hu65V
         z8aqV6EruIx1qf8TOege+3ONLh53u0J2Ass2twKBueAGOXsX3CWOKlDIQCRUEL0BInaa
         wFhmtBHkNJqGhDqusQqZlVoCFWo4dTZ9hvdkx/+xx+CPmBsajSMLmW9VrtAFgnit38jr
         nb2BnbZriaOZJUhxbrvFepr6Ou1XZLLQb2j2bEgKIpJYlCCwl2fMRzn3XWEzVO9IUwRT
         ujdHSxAKCVzM7TAmPFPt7Q7BdH9Yms0Pg175qE71mlHEdJ0duSvdPyFkuTU6v1If7g+P
         d0YA==
X-Gm-Message-State: APjAAAUJxBJTjQqYHGjIOtRGn3mtZJVNHpEBHKaHlof86rZV3e0E1NoF
        amSDglH8usY3BLyKMjWCAuY=
X-Google-Smtp-Source: APXvYqzlX1yDFog1bauhSsX4tlJxNQyGvWwkTpAEZXLsCorLU3dLyzNhHrRff5LH0JwsUDB/8pCCqw==
X-Received: by 2002:a17:90a:a404:: with SMTP id y4mr1996884pjp.62.1569885930482;
        Mon, 30 Sep 2019 16:25:30 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id d14sm22792347pfh.36.2019.09.30.16.25.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 16:25:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190926143201.GA4738@linux.intel.com>
Date:   Mon, 30 Sep 2019 16:25:27 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        dinechin@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 26, 2019, at 7:32 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Thu, Sep 26, 2019 at 11:24:57AM +0200, Paolo Bonzini wrote:
>> On 25/09/19 03:18, Marc Orr wrote:
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index 694ee3d42f3a..05122cf91ea1 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -227,7 +227,7 @@ extra_params =3D -cpu qemu64,+umip
>>>=20
>>> [vmx]
>>> file =3D vmx.flat
>>> -extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test =
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
>>> +extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test =
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test =
-atomic_switch_overflow_msrs_test"
>>> arch =3D x86_64
>>> groups =3D vmx
>>=20
>> I just noticed this, why is the test disabled by default?
>=20
> The negative test triggers undefined behavior, e.g. on bare metal the
> test would fail because VM-Enter would succeed due to lack of an =
explicit
> check on the MSR count.
>=20
> Since the test relies on somehwat arbitrary KVM behavior, we made it =
opt-in.

Thanks for caring, but it would be better to explicitly skip the test if =
it
is not running on bare-metal. For instance, I missed this thread and =
needed
to check why the test fails on bare-metal...

Besides, it seems that v6 was used and not v7, so the error messages are
strange:

 Test suite: atomic_switch_overflow_msrs_test
 FAIL: exit_reason, 18, is 2147483682.
 FAIL: exit_qual, 0, is 513.
 SUMMARY: 11 tests, 2 unexpected failures

I also think that printing the exit-reason in hex format would be more
readable.

