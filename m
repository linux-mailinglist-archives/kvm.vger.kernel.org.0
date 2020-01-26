Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F68149D25
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2020 23:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgAZWGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 17:06:48 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:47048 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbgAZWGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 17:06:47 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so7880233ioi.13
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2020 14:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p7UVPfO0BwsFLiOapC03mrWBHVp4NOV2h6NEGD0saro=;
        b=PH0xW4wfijVH5bBnBkl05ScgtEv1xp1sJ+2j4bLZuIbsr/D5LwREPXA55QheKqovme
         AXPTc68CEv+uSxwCgvq0nD1pI4aGItwg/naCvxhAD2GRBAQUW6e6OBnZ+d8tIpU8cusc
         z5mXhcoLqGgByStzu9fWP8785tOJq4n0vvln41WPbQxkX4zGBuHXIusjAk7okEtpsXWk
         +6Xj9ONfmps9F4AtsEmkDRM+PANzIJgln0rCbsf3GdoXSUCveIoHDz5NLpgZlV6HW4eC
         AHwRXL4JLmhluIZBvGE18IpUt+pZOBVu96HVOVZ9UhozGBpeWrACMu0T1iG4lnvYP2UN
         CNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p7UVPfO0BwsFLiOapC03mrWBHVp4NOV2h6NEGD0saro=;
        b=UfDyjgQW7hrWvSrzqCtJbcMWy73Pam6o4N3cdAgxWsxvvCYANwU0CVgAi0tt61H0Jj
         UQjDzqzsUscq84xm+k2FiY5stScn5kQbgmF2KEkHvKCefYALcYwCKp2DWugxFhUFZrlU
         FkH+yYSzOu540XTFUYdEMtOOtr07QWpUuJCBT3nEIoy8ZgG1eNKYeOfeVcOpIq/MPjOv
         /F4aelBNLZAFCVEP6Cjm1P5dgxZ8ZISgG2Fg/UQ0RLt8x3ifAnwz9q6G0KLBPRoR7HJ8
         3WcoEBmEtMhfBZX7AwiJ34BmGaBQcyMdxjbXCRgiiE6g2rXTd9NNWhKJvHoJ+cxUsSCZ
         0e2Q==
X-Gm-Message-State: APjAAAWMn7yXijlQRsp7awxIMyRaBDFnMTm8QRc9bp67GehiMHYRb8+R
        pyPExTPRzpqTjXUljZiYnAIkjpj5q7UPNVHD5qwxxw==
X-Google-Smtp-Source: APXvYqw3m+zuhQr+V9NVoEFGLGbG6cUhx+uEAuSYliTDGqXN3Wdnyneg7Po+qZWgYDXUOIkP39HkZRGNxeYtGvguczQ=
X-Received: by 2002:a5e:924c:: with SMTP id z12mr10422056iop.296.1580076406439;
 Sun, 26 Jan 2020 14:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com> <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
In-Reply-To: <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sun, 26 Jan 2020 14:06:36 -0800
Message-ID: <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If I had to guess, you probably have SMM malware on your host. Remove
the malware, and the test should pass.

On Fri, Jan 24, 2020 at 4:06 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jan 24, 2020, at 3:38 PM, Sean Christopherson <sean.j.christopherson=
@intel.com> wrote:
> >
> > On Fri, Jan 24, 2020 at 03:13:44PM -0800, Nadav Amit wrote:
> >>> On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> wrot=
e:
> >>>
> >>> Verify that the difference between a guest RDTSC instruction and the
> >>> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> >>> MSR-store list is less than 750 cycles, 99.9% of the time.
> >>>
> >>> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observabl=
e L2 TSC=E2=80=9D)
> >>>
> >>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>
> >> Running this test on bare-metal I get:
> >>
> >>  Test suite: rdtsc_vmexit_diff_test
> >>  FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
> >>
> >> Any idea why? Should I just play with the 750 cycles magic number?
> >
> > Argh, this reminds me that I have a patch for this test to improve the
> > error message to makes things easier to debug.  Give me a few minutes t=
o
> > get it sent out, might help a bit.
>
> Thanks for the quick response. With this patch I get on my bare-metal Sky=
lake:
>
> FAIL: RDTSC to VM-exit delta too high in 100 of 49757 iterations, last =
=3D 1152
> FAIL: Guest didn't run to completion.
>
> I=E2=80=99ll try to raise the delta and see what happens.
>
> Sorry for my laziness - it is just that like ~30% of the tests that are
> added fail on bare-metal :(
>
