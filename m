Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9F21A4AC0
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgDJTly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 15:41:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32842 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgDJTly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 15:41:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so1395800pgo.0
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 12:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CgnU+ujBRV0gbvV/FEvyB7C6MQ/ZUVq1NHOVW73TsKw=;
        b=F+5Oqtal202Cfks9CO4zEB6xzOim31mB0c4paOikBeD9zHAIBjMRvuwBu6yg3XOnMa
         2DwEgrm3UNc7KuqUX7eQcMNQakhF1MArVGNQvD/LR+cqWB7pdBHHc+7+MmSp87lb0TPE
         XekaT72poEU3N7K/iOUS6mjNbwyltW0sNPMl7sy+9XWPd6lRGV/kTKdLzSTPMIMgkVGT
         3x42P03IOg/vT0KUY+qR17hg0jdkKLCipPHnAUKyQw5nfGQtxsRcjUj9CUpLfeM/7w61
         qPJaFbFkN1unRWebpkmVELt0ijaY2wqVvsAjaMQ83QmqdXX3opbws5VJgd9uF8rK8ooH
         fWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CgnU+ujBRV0gbvV/FEvyB7C6MQ/ZUVq1NHOVW73TsKw=;
        b=KqSdpTd07k4yW39GCVU649XfUUB756US6BKrwmge2RD7jLiffgrFw2V6tQYE4qdKmA
         icYjocHYGi8DyRwSB/4FfLDh1FqvHe4vKNDX2KEeB9Hkwir5iB3R9L84MA02ougvB6Jn
         zPruEEaQ2i1GWGHnOG5BDfkqKjkw8QPm5idPF86mVMDCRPJosWW3JebrLNOdGPzW9Ehd
         u5gzbZCYwx5nchqzkOjvrIuO7QrdeIPtA2sTxdzLG4ptcXEsdoT2ZnyKBVV678gL++xM
         DjzTT/+aFYCS9In50vnsHuxb25FCiOCiXtrtR5kiJXhShqDK9KyY9uVbvIexecwwmPEB
         3pFg==
X-Gm-Message-State: AGi0PuZQHKZFJIpPe2zWwLcXoM1JWbJBf7ewO2e+GVI5D4LtFOSm+O8F
        AhKFDL+CBed29lm1yQWB7cs=
X-Google-Smtp-Source: APiQypJOBRKFJSxkKIGN2xfjPWPl/+lBs+mMibX5Q01dX/ddCq3mD+f8Cts+eOjWSrg5zkfzAd289A==
X-Received: by 2002:a62:ee10:: with SMTP id e16mr6411313pfi.247.1586547713462;
        Fri, 10 Apr 2020 12:41:53 -0700 (PDT)
Received: from [10.0.1.60] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id s39sm2491073pjb.10.2020.04.10.12.41.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 12:41:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Contribution to KVM.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
Date:   Fri, 10 Apr 2020 12:41:51 -0700
Cc:     Javier Romero <xavinux@gmail.com>, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, like.xu@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <40B0C1D8-06B9-4E12-BB7B-E7E3AFF4409E@gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
 <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
 <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 10, 2020, at 3:20 AM, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
> On 10/04/2020 6:52, Nadav Amit wrote:
>> 2. Try to run the tests with more than 4GB of memory. The last time I =
tried
>>    (actually by running the test on bare metal), the INIT test that =
Liran
>>    wrote failed.
> Wasn't this test failure fixed with kvm-unit-test commit fc47ccc19612 =
("x86: vmx: Verify pending LAPIC INIT event consume when exit on =
VMX_INIT")?
> If not, can you provide the details of this new failure? As I thought =
this commit address the previous issue you have reported when running =
this test
> on bare-metal.

Your patch solved the problem of INIT and apparently you got the right
implementation in KVM.

There appears to be another issue, which I suspect is only a test issue,
when I run the tests on bare-metal with more than 4GB of memory. If I =
remove
Paolo=E2=80=99s patch the enabled support for more than 4GB of RAM, or =
if I run it
on a VM with 4GB of RAM it passes. I did not run the tests on KVM - to =
be
fair.

Here is the splat I got on a non-KVM hypervisor with 8GB or RAM:

Test suite: vmx_init_signal_test
Unhandled cpu exception 14 #PF at ip 0000000000419698
PF at 0x419698 addr 0x102066000
error_code=3D0000      rflags=3D00010046      cs=3D00000008
rax=3D0000000000000000 rcx=3D000000000000080b rdx=3D0000000000000001 =
rbx=3D0000000102066000
rbp=3D000000000053a7b8 rsi=3D0000000000000000 rdi=3D0000000102065000
 r8=3D000000000053a016  r9=3D00000000000003f8 r10=3D000000000000000d =
r11=3D0000000000000000
r12=3D0000000102065000 r13=3D0000000102065000 r14=3D0000000000000000 =
r15=3D0000000000000000
cr0=3D0000000080000011 cr2=3D0000000102066000 cr3=3D0000000000422000 =
cr4=3D0000000000000020
cr8=3D0000000000000000
	STACK: @419698 407539 419f81 419eb1

[ I ran it also on bare metal, and got IIRC got a similar splat, but did =
not
save it. ]

The splat shows the failure happened in alloc_page() which was called =
from
init_signal_test_thread() on the following line:

	freelist =3D *(void **)freelist;

( and IIRC freelist is nil )

I did not have time to analyze the problem or even run it on KVM.

