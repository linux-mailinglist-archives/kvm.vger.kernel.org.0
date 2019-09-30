Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E68CC2AF7
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbfI3Xe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:34:28 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:54673 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfI3Xe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:34:28 -0400
Received: by mail-wm1-f44.google.com with SMTP id p7so1199514wmp.4
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9C7f+VIjZWYqRhztT/KRGFegfYDW/6gkvAaGneypRNM=;
        b=UngWFSrP3f4sSDTVTL6dFlubJ5/yczxe9Xm0Bn6AaL1qOgcaND/5EL7niIU1uTcEOF
         i3bzKTOXGoatiBzORDUpct2nNeafubkWbx++AANLC3WtaPF+zO0cTLcn+k8/0y7D45Ll
         rcOtc7naUeUe8YUyXIBd/jaPHuIGZvFdoIzqihc6+yCC1/kFwGO+7Xk5UVN5qDOXNJro
         /NylEMwQAoAzH59sBEoWM50akv/cpe2wnuqCYZaICV6M+veKO1yQSS7Kw/wrGz9XFHyQ
         ULPr49PJ6iHaVqOo4G2V6xdw1XGsbrO/BKeqPxxHmBD4bijAYQo3/ExGXkvIqnWCjzvq
         gycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9C7f+VIjZWYqRhztT/KRGFegfYDW/6gkvAaGneypRNM=;
        b=BfUruK1fQ8dXvG2jAdHa8BKoLaniwnYhnPoH2EYJbch3nF8iW1MIcyyZ9gK2hBF4E+
         2RxqY1nsr3XcxRGQXTK3p86UJabpQgn47uFP9gySSOO0EW9IZvH2vh+pBk9CItTY7I0r
         nUa2EFQErYAMNR1Mpue+ig+gZmwDN+ATDizAm9PiUW4JuYuS1CbBc27GM37zHCYXwGYZ
         4kcHDmxgD62MthnUmHo5ZRbQm0zpLZe3G9T1MporWVdFBmoug3Jd/HColpLgG+nSOR0E
         ZV4nbbFiLW+U5nDLiowGvxjYOUpSJnGJQC9zTOochWBpbBWQB05oaUjR8MSJp240cw78
         k5Rg==
X-Gm-Message-State: APjAAAX4V189SMro50CPHFUvfC1S+J7X+f2N4+T1UF/P/EdbDU8zXRiJ
        Zcgz83f0c8qo1fJulUzxn10nno83wlT76O86ivouAw==
X-Google-Smtp-Source: APXvYqzAUyEP61sLXMKEYdIp0rsAcOApvBAIh3s1tnXfKHBt9nkPlToYGzvqBu5/OVOZgLyazcGXYZ9I+sWg6RVE7jo=
X-Received: by 2002:a1c:f602:: with SMTP id w2mr1087528wmc.145.1569886465890;
 Mon, 30 Sep 2019 16:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190925011821.24523-1-marcorr@google.com> <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com> <20190926143201.GA4738@linux.intel.com>
 <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
In-Reply-To: <C94E79EE-EACF-40C1-AF7A-69E2A8EFAA35@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 30 Sep 2019 16:34:14 -0700
Message-ID: <CAA03e5FPBdHhVY5AyOd68UkriG=+poWf0PCcsUVBOHW7YPF3VA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch MSRs
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Thanks for caring, but it would be better to explicitly skip the test if it
> is not running on bare-metal. For instance, I missed this thread and needed
> to check why the test fails on bare-metal...
>
> Besides, it seems that v6 was used and not v7, so the error messages are
> strange:
>
>  Test suite: atomic_switch_overflow_msrs_test
>  FAIL: exit_reason, 18, is 2147483682.
>  FAIL: exit_qual, 0, is 513.
>  SUMMARY: 11 tests, 2 unexpected failures
>
> I also think that printing the exit-reason in hex format would be more
> readable.

Exit reasons are enumerated in decimal rather than hex in the SDM
(volume 3, appendix C).

To be clear, are you saying you "opted in" to the test on bare metal,
and got confused when it failed? Or, are you saying that our patch on
unittest.cfg to make the test not run by default didn't work?
