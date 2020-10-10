Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900F28A19A
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgJJVvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730658AbgJJTwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 15:52:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBB0C0613D6
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 02:09:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so9295716pgb.10
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 02:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SD4l5Kz+FA+HdcZ6jOV6LIyRE33PoP95TodtQTRXGa4=;
        b=jjR2oLRCDm/87IowldAxD+GXKXpTVgsl8OkJuSKLlLqhcWL7jL2uTBXQkfmigidXkY
         Qmmq4p1tF6SSxuAs6/fRz9PLpsWDOjj++5/S0xcfrtImH5SiE+7WPZMzSLY6Yt1/HATv
         Vw+brqSupNLJceFtCxLGqFu9nFLg8sdvnseMJMbfBGwbjJRIdt3t/M5QwmA2l+LHcEmZ
         M1d9FWerRDc+Yrmkc+BdGTcW5fdE8bWRiU2mibdXOHSTax84ebwpHSDBQMPEDUEBgOLu
         lxCYAFzV/DWaISlsoFSpobqJtoa/2d9vnV6BQ1nRz6z2ch5EFMaCC4kAr+zNfCdPlGA8
         7eaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SD4l5Kz+FA+HdcZ6jOV6LIyRE33PoP95TodtQTRXGa4=;
        b=TAjSBaeoIdGsQtuxc2Z5PO3d7dbg+BGeC5awEEhYW12/+XT05k6MdxlEfXx4dZPGPP
         sCXJcfp0r4U/WtJXI6DzfSO37/hTAypIn1UGLOzYdoU75FnHF17+yYmfLKtEPr87e+Vv
         ND4p/egrop1weKJp3o9PcIQZY25g5/IVjtOPzPs/KPSqa2eqkKO32CTA+AcZugsgcb+e
         clVz9rwhs9ImmpR8pbbRJ6IGjLO5tpjA9Alb8xS7Zifao8yMXdMBKnUA9aGTa/v7vQXM
         koHkRCo4thcXlC9xeJ5fp3RogoCsu1fgE7Wo1SW93jeBg4tNKZEmR6m6UVIuEhJnZkgv
         T1Qw==
X-Gm-Message-State: AOAM532zQMeVOU7Rxwz0/8KyOzHS8Aru4mz4el/yBZXbB4uGFWfqcaeD
        L+AeRCQd6JtYXlJgVF5iWSg=
X-Google-Smtp-Source: ABdhPJyVHdbFU2yW0WRGt/th1PTbmur2TB4wSu3UN2/ugbOqCAQJ4kmJHcr+Mf+LgPy+uRzc7LfTHg==
X-Received: by 2002:a63:5015:: with SMTP id e21mr6720777pgb.61.1602320980266;
        Sat, 10 Oct 2020 02:09:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:25eb:9460:8682:b3b5? ([2601:647:4700:9b2:25eb:9460:8682:b3b5])
        by smtp.gmail.com with ESMTPSA id ge19sm14872512pjb.55.2020.10.10.02.09.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 02:09:39 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
Date:   Sat, 10 Oct 2020 02:09:38 -0700
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3705293E-84DE-41ED-9DD1-D837855C079B@gmail.com>
References: <20200925073624.245578-1-yadong.qi@intel.com>
 <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
To:     "Qi, Yadong" <yadong.qi@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 4, 2020, at 12:19 AM, Qi, Yadong <yadong.qi@intel.com> wrote:
>=20
>> -----Original Message-----
>> From: Qi, Yadong <yadong.qi@intel.com>
>> Sent: Friday, September 25, 2020 3:36 PM
>> To: kvm@vger.kernel.org
>> Cc: pbonzini@redhat.com; Qi, Yadong <yadong.qi@intel.com>
>> Subject: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal =
processing
>>=20
>> From: Yadong Qi <yadong.qi@intel.com>
>>=20
>> The test verifies the following functionality:
>> A SIPI signal received when CPU is in VMX non-root mode:
>>    if ACTIVITY_STATE =3D=3D WAIT_SIPI
>>        VMExit with (reason =3D=3D 4)
>>    else
>>        SIPI signal is ignored
>>=20
>> The test cases depends on IA32_VMX_MISC:bit(8), if this bit is 1 then =
the test
>> cases would be executed, otherwise the test cases would be skiped.
>>=20
>> Signed-off-by: Yadong Qi <yadong.qi@intel.com>

[ snip ]

>=20
> Hi, Paolo
>=20
> Any comments of this patch?
> It is test case for https://patchwork.kernel.org/patch/11791499/

On my bare-metal machine, I get a #GP on the WRMSR that writes the EOI
inside ipi() :

Test suite: vmx_sipi_signal_test
Unhandled exception 13 #GP at ip 0000000000417eba
error_code=3D0000      rflags=3D00010002      cs=3D00000008
rax=3D0000000000000000 rcx=3D000000000000080b rdx=3D0000000000000000 =
rbx=3D0000000000000000
rbp=3D000000000053a238 rsi=3D0000000000000000 rdi=3D000000000000000b
 r8=3D000000000000000a  r9=3D00000000000003f8 r10=3D000000000000000d =
r11=3D0000000000000000
r12=3D000000000040c7a5 r13=3D0000000000000000 r14=3D0000000000000000 =
r15=3D0000000000000000
cr0=3D0000000080000011 cr2=3D0000000000000000 cr3=3D000000000041f000 =
cr4=3D0000000000000020
cr8=3D0000000000000000
	STACK: @417eba 417f36 417481 417383

I did not dig much deeper. Could it be that there is some confusion =
between
xapic/x2apic ?

