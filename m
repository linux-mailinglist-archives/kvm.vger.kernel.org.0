Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7819291007
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 08:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437009AbgJQGMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 02:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436918AbgJQGMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 02:12:19 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A560C061755
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 23:12:19 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v12so2363978ply.12
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 23:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IBwDRknN7DUE22GjRcZ+zTg/FbCmUOPdhNoxxvl0ET0=;
        b=fiMq9Fn0pzgVMNP/VjjbyZjJkWY+PH0UQXP5Q3PE/fnS+YXFsevSym6BMJ4ICI7Unt
         7BC4Y7AzfD0Cfe2As07tI8yqhADJvUJ1ymHaxmk4wcQnB4O496eTU5YicOg+WbDjgnup
         YeUy9no8gHdN90rkfjK+Ui4i3idcPmFEBe9ea5ekSvSRRz47aLqmxpy3q12fyFFiezoI
         zsTTFPpPSCbiRw8WOyansR6QeG2XduyfDcxHpZBwSzdqZ2xip4KMwm2ZyBn+jsrAwaNp
         HqfM03MR8Dlo8R63QyWJtIvoUecb4wO9OvZx/HLXjGhPVgkQaG5XCfq2HetgBxIfekmr
         laDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IBwDRknN7DUE22GjRcZ+zTg/FbCmUOPdhNoxxvl0ET0=;
        b=NEANRxjBggJ5fhfeBwui6yxv+NBSNPUZcb0IndeufnRrwdAfylcCf+p++FvnexZlOW
         fwPDEZ9VC74lkgLx80Mav+tscbXYmUzknBcmyqN3A0rNIQ0DQCQGUtJnK21ayEU/B9zf
         1nsszj+DcgpwevMmAlQuMv0iFyyExotS7oHyBQkcIZjGGxCboNNME8HzC2hELF4m8O0M
         N2On1tV9WxLA0+/TrrZMjPCirDI+8NJPz1+BvVhMOuLRStT8cpQDDXWnZJSVbrEx+QaW
         XC/kPSQnYEnykqWbSU+RgCrMA0TcXD79IHn9qI/Q3gEhM/qy9JnM8N6KilfRsgg/0j+p
         7DeA==
X-Gm-Message-State: AOAM530aLulu6TNW3TV8mU6x5XEYjl4uryruH0OOSEmxsjTCjUJ21KhT
        hu4jWdhsHMpt7zYESpf9CyU=
X-Google-Smtp-Source: ABdhPJyJZbIjpjsHorvTpei7+3UjewvDib+UP0SYjsIz15GvXw7HKkI0mJeGTvI/gFyP785MBNSCUw==
X-Received: by 2002:a17:902:a588:b029:d3:7f4a:28a2 with SMTP id az8-20020a170902a588b02900d37f4a28a2mr7586496plb.26.1602915138581;
        Fri, 16 Oct 2020 23:12:18 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:a16c:70da:997e:1c1b? ([2601:647:4700:9b2:a16c:70da:997e:1c1b])
        by smtp.gmail.com with ESMTPSA id d129sm4743442pfc.161.2020.10.16.23.12.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2020 23:12:17 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 2/2] nSVM: Test reserved values for 'Type' and invalid
 vectors in EVENTINJ
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201017000234.42326-3-krish.sadhukhan@oracle.com>
Date:   Fri, 16 Oct 2020 23:12:16 -0700
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3C14E481-3298-41CD-A04F-4AC46F9E2C1A@gmail.com>
References: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
 <20201017000234.42326-3-krish.sadhukhan@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 16, 2020, at 5:02 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
> According to sections "Canonicalization and Consistency Checks" and =
"Event
> Injection" in APM vol 2
>=20
>    VMRUN exits with VMEXIT_INVALID error code if either:
>      - Reserved values of TYPE have been specified, or
>      - TYPE =3D 3 (exception) has been specified with a vector that =
does not
> 	correspond to an exception (this includes vector 2, which is an =
NMI,
> 	not an exception).
>=20
> Existing tests already cover part of the second rule. This patch =
covers the
> the first rule and the missing pieces of the second rule.
>=20
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
> x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 40 insertions(+)
>=20
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index f78c9e4..e6554e4 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2132,6 +2132,45 @@ static void test_dr(void)
> 	vmcb->save.dr7 =3D dr_saved;
> }
>=20
> +static void test_event_inject(void)
> +{
> +	u32 i;
> +	u32 event_inj_saved =3D vmcb->control.event_inj;
> +
> +	handle_exception(DE_VECTOR, my_isr);
> +
> +	report (svm_vmrun() =3D=3D SVM_EXIT_VMMCALL && count_exc =3D=3D =
0, "Test "
> +	    "No EVENTINJ");
> +
> +	/*
> +	 * Reserved values for 'Type' in EVENTINJ causes VMEXIT_INVALID.
> +	 */
> +	for (i =3D 1; i < 8; i++) {
> +		if (i !=3D 1 && i < 5)
> +			continue;
> +		vmcb->control.event_inj =3D DE_VECTOR |
> +		    i << SVM_EVTINJ_TYPE_SHIFT | SVM_EVTINJ_VALID;
> +		report(svm_vmrun() =3D=3D SVM_EXIT_ERR && count_exc =3D=3D=
 0,
> +		    "Test invalid TYPE (%x) in EVENTINJ", i);
> +	}
> +
> +	/*
> +	 * Invalid vector number for event type 'exception' in EVENTINJ
> +	 * causes VMEXIT_INVALID.
> +	 */
> +	i =3D 32;
> +	while (i < 256) {
> +		vmcb->control.event_inj =3D i | SVM_EVTINJ_TYPE_EXEPT |
> +		    SVM_EVTINJ_VALID;
> +		report(svm_vmrun() =3D=3D SVM_EXIT_ERR && count_exc =3D=3D=
 0,
> +		    "Test invalid vector (%u) in EVENTINJ for event type =
"
> +		    "\'exception\'", i);
> +		i +=3D 4;
> +	}

I know that kvm-unit-tests has nothing to do with style, but can=E2=80=99t=
 this loop
be turned into a for-loop for readability?

And why "i +=3D 4" ?

