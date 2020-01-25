Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624CC14923E
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 01:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbgAYAGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 19:06:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44644 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387419AbgAYAGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 19:06:44 -0500
Received: by mail-pf1-f193.google.com with SMTP id 62so1862180pfu.11
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 16:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nhglXtwmeZl3KuhK/rxAwnOBAeX9EG+lzc/qU82Ybtg=;
        b=Y65AZ8uCoollRGoV/zWI2qyPzx42ehugu9t1ispHF5tK0AXAZH3ItGTIeX8NRHui8z
         vEixWO6P7dAFEm9haStQWFcUnInXvzcwmognmx45zvFoo4XSS0XfFWizthJE8LK/9Bkt
         TGO+zVuYR6DXOtr/NK3ZKKNEjseMg+bAMRlq7NwwhOuZx55qbwNy7OLlSINYVnoeh1Dw
         FWbBeD8cGCzvzw3wUxQmgIftxwOta0BFLGON99CDSeOMaK18vBjm20Jb+OAjr43EwGwp
         pt2mwLsZcnYAmIm+ZthTA4foVRGb+gS8AXtfrkMZukA0R9uczAxW3uYj33nqO1uEiodc
         gxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nhglXtwmeZl3KuhK/rxAwnOBAeX9EG+lzc/qU82Ybtg=;
        b=CfU0Ir/VUzAqVEeGOYYFKZ6Hd71PK34N81ZjCNw6TVF7UG3lLsyBcCxCa9kbTBVrs3
         z3xlqss+EeAERRysamwOSRjfN9M7cvPbVWQwqaryEh0UbgjnZDlCiz02qEVU6n+auJNS
         on6v3fzs0Q/z8WBooTCmk/V3SdzMguV3y81In9iAUyL7pBEDZw0Dp9m/lLnDr6IAHTOU
         FHVvF7lqpIBfoUczpupCctsmwD1AM4q7ZUge9bOUzF7P2UaxQ4DPptGBU8CMW0AbWZgz
         V8Yi0fG6K1i9MbN9p6dN12LMz9WBpGPRBA+5iWE/yJHgoP5nHcqLopdKZCYe3nuh4v8+
         MFtw==
X-Gm-Message-State: APjAAAVsvYiIr1Gbx5L80FFRC9DLtuJy1YD2eSmUNYz8vTmt4kEWaidn
        FWesr6o5S5H1gn0zqZ+Q5lo=
X-Google-Smtp-Source: APXvYqxU9G7QPJB0zBTtTwPcN4rtPomC0/eYEfIgQSVpneCA78nQvzo8r+zxa5f1sA5o+A2HdRf88A==
X-Received: by 2002:a65:488f:: with SMTP id n15mr7368725pgs.61.1579910803970;
        Fri, 24 Jan 2020 16:06:43 -0800 (PST)
Received: from [10.2.129.203] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 6sm7763643pgh.0.2020.01.24.16.06.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jan 2020 16:06:43 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200124233835.GT2109@linux.intel.com>
Date:   Fri, 24 Jan 2020 16:06:40 -0800
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
 <20200124233835.GT2109@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jan 24, 2020, at 3:38 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Jan 24, 2020 at 03:13:44PM -0800, Nadav Amit wrote:
>>> On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> =
wrote:
>>>=20
>>> Verify that the difference between a guest RDTSC instruction and the
>>> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
>>> MSR-store list is less than 750 cycles, 99.9% of the time.
>>>=20
>>> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest =
observable L2 TSC=E2=80=9D)
>>>=20
>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>=20
>> Running this test on bare-metal I get:
>>=20
>>  Test suite: rdtsc_vmexit_diff_test
>>  FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
>>=20
>> Any idea why? Should I just play with the 750 cycles magic number?
>=20
> Argh, this reminds me that I have a patch for this test to improve the
> error message to makes things easier to debug.  Give me a few minutes =
to
> get it sent out, might help a bit.

Thanks for the quick response. With this patch I get on my bare-metal =
Skylake:

FAIL: RDTSC to VM-exit delta too high in 100 of 49757 iterations, last =3D=
 1152
FAIL: Guest didn't run to completion.

I=E2=80=99ll try to raise the delta and see what happens.

Sorry for my laziness - it is just that like ~30% of the tests that are
added fail on bare-metal :(

