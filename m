Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1F21511B
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgGFCMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgGFCMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 22:12:14 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD88C061794
        for <kvm@vger.kernel.org>; Sun,  5 Jul 2020 19:12:13 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id v6so24070888iob.4
        for <kvm@vger.kernel.org>; Sun, 05 Jul 2020 19:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0EP/LXI4CzHqaVjw0NHIghaG9jR02WWVjhaOMm++lCU=;
        b=EfdTlpJDEp7js5MOh8VO7TUI+dY6/jZMUaxcsdd7QUjV8s3PY0JfjwtgcoVlDLKMHp
         abK25PpwU+sjZO5U1XDSzdiNNTEWnT+PnLogEOoQXxJJ8LrPoruYMyIpwIwbmUPPwB0p
         cKhNd3yj/1ns/o9pJ8FQSJ9fZjMert+saDlPO/wswPZx/p8Uy2ruNhkVifLLaNS5yAIf
         zWOSYxxvaBZcWxSOCHDyH+kyEAHJKGa61ujJPfn0j7QzCzmnPvS6QdGVUPTpSm7GbpS/
         /gbkaPYR33TwCd6UBHBJzx4nFxq2h9+6Z3bT8iIHucPFhICQ8MuidR+pTg8fWvyQYj3+
         +KMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0EP/LXI4CzHqaVjw0NHIghaG9jR02WWVjhaOMm++lCU=;
        b=lQ+EOgXJAygMF/Qo5hP76N4Hzj+LObJj7K6FcjKo82QQCzedhcCun4hNQjoy/fD0Tn
         1qx459BOgevQQWNMRJyFPJaaz92bWPpicIHuECS/OVuvGe1QnnAfH/UOGuxx20gIMk+Q
         QJqWXKiLGY7jF2xvsHD2hRYson2mK0nurfhnb8TkxIoeFJMfV9R7KzL/M6lb67kblQFl
         TNmuAU9oVO+zDEyTbIKfioAjCpbqV802pQX09dvtFbpDgx3J6cCKLyUw7EmxEc+wqtvJ
         kzqYVGG88pumP98Ic7YDgzt3Hii54m1EwUW1ogfO5xPsloqO3mFBHQiISeoe8QYxcm3M
         sYKA==
X-Gm-Message-State: AOAM533fcF8NRQs9/sX+I56QuTh0LP/OqApkQBtrdfB4NaQC0UVddDz7
        G4QTFTEjodSLaXaEDQY8xy6bcoeBq/I=
X-Google-Smtp-Source: ABdhPJyJhL+zLBGlQG1GM0tX4+f9mMRc8hN9N7+h2qepgrs8aDdKYcvAE/tRx1mnp7fdftEF6fkLcA==
X-Received: by 2002:a02:a008:: with SMTP id a8mr48500160jah.68.1594001533108;
        Sun, 05 Jul 2020 19:12:13 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:5:addf:db7c:e303? ([2601:647:4700:9b2:5:addf:db7c:e303])
        by smtp.gmail.com with ESMTPSA id c77sm10861557ill.13.2020.07.05.19.12.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jul 2020 19:12:12 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Question regarding nested_svm_inject_npf_exit()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com>
Date:   Sun, 5 Jul 2020 19:12:11 -0700
Cc:     kvm <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B43FBC4-D265-4005-8FBA-870BDC627231@gmail.com>
References: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
 <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 4, 2020, at 11:38 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 04/07/20 02:00, Nadav Amit wrote:
>> Hello Paolo,
>>=20
>> I encountered an issue while running some svm tests. Apparently, the =
tests
>> =E2=80=9Cnpt_rw_pfwalk=E2=80=9D and =E2=80=9Cnpt_rsv_pfwalk=E2=80=9D =
expect the present bit to be clear.
>>=20
>> KVM indeed clears this bit in nested_svm_inject_npf_exit():
>>=20
>>       /*
>>        * The present bit is always zero for page structure faults on =
real
>>        * hardware.
>>        */
>>       if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
>>               svm->vmcb->control.exit_info_1 &=3D ~1;
>>=20
>>=20
>> I could not find documentation of this behavior. Unfortunately, I do =
not
>> have a bare-metal AMD machine to test the behavior (and some enabling =
of
>> kvm-unit-tests/svm is required, e.g. this test does not run with more =
than
>> 4GB of memory).
>>=20
>> Are you sure that this is the way AMD machines behave?
>=20
> No, I'm not.  The code was added when NPF was changed to synthesize
> EXITINFO1, instead of simply propagating L0's EXITINFO1 into L1 (see
> commit 5e3525195196, "KVM: nSVM: propagate the NPF EXITINFO to the
> guest", 2014-09-03).  With six more years of understanding of KVM, the
> lack of a present bit might well have been a consequence of how the =
MMU
> works.

Thanks. I ran =E2=80=98git blame=E2=80=99 before asking you, and that is =
the reason I
assumed you would know best... ;-)

> One of these days I'd like to run the SVM tests under QEMU without =
KVM.
> It would probably find bugs in both.

Well, I think we can agree that bare-metal is a better reference than
another emulator for the matter. Even without running the tests on
bare-metal, it is easy to dump EXITINFO1 on the nested page-fault. I =
will
try to find a bare-metal machine.

Anyhow, I would appreciate if anyone from AMD would tell whether any =
result
should be considered architectural.

