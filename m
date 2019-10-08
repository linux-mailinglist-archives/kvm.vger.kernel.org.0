Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE76FCFE2F
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 17:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfJHPza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 11:55:30 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:34568 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHPza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 11:55:30 -0400
Received: by mail-lf1-f47.google.com with SMTP id r22so12392265lfm.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 08:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Maf3t6UVF8VcQ4btx4pWjvJXMS6FKWOQG5BwNMzfZE=;
        b=Gux0sGxllbbkaQlR8sB6pB4X9FtIKwy0fg6x97ziAJB0rskEeY9X/qsusLDq8FjX6G
         b5Ib8wJyMd6gSng6FwHNqyKeavV7d8DD3tUqcfLKOA1lBJGxaRvlTtDJFdUznfMjDDk5
         p1dV/+CbgH5RKiDr+8ItSE9HfwspmkHeXyX/tL8k2cjl43363x6Uc1PENO2D2q+mZAi9
         +zplPWZPz3m/N+H35PyBVtRwdvSO9YkrUNObyjaKTUejJw1EcbzEPmyQJbl3DVplI6kZ
         LgxK8/588kQNJPROkh0UyNzLbs4MlUHfmgKEFzyXjB4qk2kCalGlHmZ4XcPs0jxulbTn
         mk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Maf3t6UVF8VcQ4btx4pWjvJXMS6FKWOQG5BwNMzfZE=;
        b=BmfLbsaHIURsSiC0g2rY/N7gYP8Fbgtrn84SJs/K/HnnUrr4wQ/burhK3Po8G5HV8+
         4AY8hP6fAOlXAzf0mTVhTomvrmqASgGwhaNQ2IIMQPnqQZYnOBXDl774ErHgebxZyf+2
         40/y8w+v0o3tC4ipjLtfNlQ+S8ET/Smb2OEc8lEgfFZWRt5GjEqAKFg2QKAkoQ1cOsTw
         vEaOAD4vRAnEDGiHqaa7rOEM9tdYPf8cL7sXu7MjFZXfhxBQOsSzlh1KCUkAW6i26X9v
         ttsLsq267/nYfakw7Io50YuNSGCu+bFrN2otXkTyH0RCdF1cIe69C85YYFLKnjNRUTxM
         Um/w==
X-Gm-Message-State: APjAAAXF8BqUNWhhTFgf13/+AtEP4QqK0UsHrE5Nt+etx8dTQarcPVuE
        B3yYnx/9v+ubBt+lH7HH1edLDiXkxHCu2MYDm0U=
X-Google-Smtp-Source: APXvYqxcG7WgaOYquFtgMIywZJoHWyVuDaQID4SAxJsksq9DQ2mecBEZyqqhf9YaOLET0Iy60yewxhxo/UMxy7RqQhA=
X-Received: by 2002:ac2:5a19:: with SMTP id q25mr11594931lfn.178.1570550128314;
 Tue, 08 Oct 2019 08:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com> <CA+res+QTrLv7Hr9RcGZDua6JAdaC3tfZXRM4e9+_kbsU72OfdA@mail.gmail.com>
 <87wodfz38m.fsf@vitty.brq.redhat.com>
In-Reply-To: <87wodfz38m.fsf@vitty.brq.redhat.com>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 8 Oct 2019 17:55:17 +0200
Message-ID: <CA+res+TWmPjtHy55SM6MBL0kPRAyuSZV3ivR+wxiN8CwM9K0sA@mail.gmail.com>
Subject: Re: KVM-unit-tests on AMD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=888=
=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=885:06=E5=86=99=E9=81=93=EF=BC=
=9A
>
> Jack Wang <jack.wang.usish@gmail.com> writes:
>
> > Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=
=888=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:20=E5=86=99=E9=81=93=EF=
=BC=9A
> >>
> >> Nadav Amit <nadav.amit@gmail.com> writes:
> >>
> >> > Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
> >> >
> >>
> >> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
> >> but the whole SVM would appreciate some love ...
> >>
> >> > Clearly, I ask since they do not pass on AMD on bare-metal.
> >>
> >> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
> >> failures:
> >>
> >> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
> >>
> >> (Why can't we just check
> >> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
> >>
> >> FAIL svm (15 tests, 1 unexpected failures)
> >>
> >> There is a patch for that:
> >>
> >> https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redha=
t.com/T/#t
> >>
> >
> >> Are you seeing different failures?
> >>
> >> --
> >> Vitaly
> > On my test machine AMD Opteron(tm) Processor 6386 SE, bare metal:
> > I got similar result:
> > vmware_backdoors (11 tests, 8 unexpected failures)
> > svm (13 tests, 1 unexpected failures), it failed on
> > FAIL: tsc_adjust
> >     Latency VMRUN : max: 181451 min: 13150 avg: 13288
> >     Latency VMEXIT: max: 270048 min: 13455 avg: 13623
>
> Right you are,
>
> the failing test is also 'tsc_adjust' for me, npt_rsvd_pfwalk (which
> Cathy fixed) is not being executed because we do '-cpu qemu64' for it.
>
> With the following:
>
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index b4865ac..5ecb9bb 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -198,7 +198,7 @@ arch =3D x86_64
>  [svm]
>  file =3D svm.flat
>  smp =3D 2
> -extra_params =3D -cpu qemu64,+svm
> +extra_params =3D -cpu host,+svm
>  arch =3D x86_64
>
>  [taskswitch]
>
> everything passes, including tsc_adjust:
>
> PASS: tsc_adjust
>     Latency VMRUN : max: 43240 min: 3720 avg: 3830
>     Latency VMEXIT: max: 36300 min: 3540 avg: 3648
>
> --
> Vitaly
Yes with -cpu host, my tests also are all pass now.
PASS: tsc_adjust
    Latency VMRUN : max: 5266389 min: 14207 avg: 14444
    Latency VMEXIT: max: 138820 min: 13712 avg: 13932
