Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA21A47FB
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgDJPuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:50:15 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34525 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgDJPuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 11:50:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id i186so2574755qke.1
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 08:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ngAyglUW6GXylRlLf8NoeOB2cXhi0dD+XxTxvWca+JA=;
        b=K2kWQODXWLuYx5R27QDJ/1YBbK+LdcmowXrNptveX2l/RRJTGBA5u7KLRWjt17zNXL
         /QjyFOThqQfqtasPrjkGjpOg71A6aJ9TVgjPOuyIbe4YxmEYBDyCkAbgsWMFHYy/PFG6
         kHsPRqtqm76RasWplqB7SvdyTmfaOrplCG73DT+tBEvWJvM0okK2oKDC7hbOzw+RGwz1
         7Ob46NxTz3aro3/g6NTAzBXLMNMS0FSpQ8U7ipa+jo2EJC9ntFdPF0Tt3wqS1HDYF5F5
         WA21Oza8jeY/pL4MaqgX6NI44qhss4GPx4+Xv0oUhqj8UTCW7mR8GKbqAWMwJwFhhKe7
         tisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ngAyglUW6GXylRlLf8NoeOB2cXhi0dD+XxTxvWca+JA=;
        b=prEOfFxIRfwfLRIbB/QAs2yfXxqFXGEcxUNvQT5nsHqkDM2eOmd9JQNTP0q8QGWzJM
         FSBbmoP70TRwGkL29K3O+GQItWPbMNsro5ZNL+6cStb7S1SQFvAjLGsRBc3C/BS4EctR
         d5wHS53TPyUfdxol5rj4eMii090PGRMQNKO+aW49p8uHBsrY05kp/UhlUr2Stw28uaI0
         1KFqDdtzoIYDiIJM5+bICOsokCn/A5Cz2e6x2ByKNNjWcu6RQLdsevmiAPzhEXrQeNKJ
         tUvakvmktCeVFG/Fkgr7PTCe6EM2ywv0bMQ/lpRp6tYvh4HtjuHHr+uDzOTG1fgOx1wl
         O99Q==
X-Gm-Message-State: AGi0PuZg2TdIFS1uHjCPmBmTVHKguqMf9SL3hnuWbnH0FnMLbRqWuw7f
        WW5SPoLg0yCNGw9UVYqCSEV+7g==
X-Google-Smtp-Source: APiQypLFOkY2MclQ2lu0q6f6QboQgyR0N7WDHwSzvVZfEn5RgSTVV9jckZIxYvSmg1o+CRpa/sHTMw==
X-Received: by 2002:a37:9c4f:: with SMTP id f76mr4535161qke.294.1586533812612;
        Fri, 10 Apr 2020 08:50:12 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 206sm1897059qkn.36.2020.04.10.08.50.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 08:50:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: KCSAN + KVM = host reset
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
Date:   Fri, 10 Apr 2020 11:50:10 -0400
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B798749E-F2F0-4A14-AFE3-F386AB632AEB@lca.pw>
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
 <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
 <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
To:     Marco Elver <elver@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 10, 2020, at 7:35 AM, Marco Elver <elver@google.com> wrote:
>=20
> On Fri, 10 Apr 2020 at 13:25, Qian Cai <cai@lca.pw> wrote:
>>=20
>>=20
>>=20
>>> On Apr 10, 2020, at 5:47 AM, Marco Elver <elver@google.com> wrote:
>>>=20
>>> That would contradict what you said about it working if KCSAN is
>>> "off". What kernel are you attempting to use in the VM?
>=20
> Ah, sorry this was a typo,
>  s/working if KCSAN/not working if KCSAN/
>=20
>> Well, I said set KCSAN debugfs to =E2=80=9Coff=E2=80=9D did not help, =
i.e., it will reset the host running kvm.sh. It is the vanilla ubuntu =
18.04 kernel in VM.
>>=20
>> github.com/cailca/linux-mm/blob/master/kvm.sh
>=20
> So, if you say that CONFIG_KCSAN_INTERRUPT_WATCHER=3Dn works, that
> contradicts it not working when KCSAN is "off". Because if KCSAN is
> off, it never sets up any watchpoints, and whether or not
> KCSAN_INTERRUPT_WATCHER is selected or not shouldn't matter. Does that
> make more sense?
>=20
> But from what you say, it's not the type of kernel run in VM. I just
> thought there may be some strange interaction if you also run a KCSAN
> kernel inside the VM.
>=20
> Since I have no way to help debug right now, if you say that
> "KCSAN_SANITIZE_svm.o :=3D n" works, I'd suggest that you just send a
> patch for that. If you think that's not adequate, it may be possible
> to try and find the offending function(s) in that file and add
> __no_kcsan to the  function(s) that cause problems.

This works,

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct kvm_vcpu =
*vcpu)
=20
 bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
=20
-static void svm_vcpu_run(struct kvm_vcpu *vcpu)
+static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm =3D to_svm(vcpu);

Does anyone has any idea why svm_vcpu_run() would be a problem for =
KCSAN_INTERRUPT_WATCHER=3Dy?

I can only see there are a bunch of assembly code in __svm_vcpu_run() =
that might be related?=
