Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D156028AE43
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgJLGhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 02:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgJLGhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 02:37:09 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0DBC0613CE
        for <kvm@vger.kernel.org>; Sun, 11 Oct 2020 23:37:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so13321466pgk.4
        for <kvm@vger.kernel.org>; Sun, 11 Oct 2020 23:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9B6a9v7XisHVHThRLn1o3EcE9Nmx+xBw62Ng4IigrMs=;
        b=IhlKRkp26IsCwFoACwxQbmv2ONp0mRDqdI7FXQd5H1Kz7xK8UIu0ibfEU8DdbRoaO9
         sAe1SACQhEgol3REmzfNnpVaduKyYtNnQholdR6PpfxX4mqijuOZSG6Smy/rwhCA2M6m
         34JcUae1YxvajtS8NdJf5YjhNZkiEK3oB/mtEigrGlZHVwKGf5DGxBR/E1R3iZ6joMpG
         b8D6YtFpxefM+UPJwCIaTKpeo1DS4TQkjo+9XRApe6c198lMhQllLnQwqhT1pUoj9JrF
         FJw0eNHlk38hxcgk04J49OdgKk5g648/iNPX1OPIcmYhJNIonFHNVMlEJvAAN6A0ne8T
         c00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9B6a9v7XisHVHThRLn1o3EcE9Nmx+xBw62Ng4IigrMs=;
        b=S9MepcHqfjVlIG8lLyqe+hdz1NFyH6zWvU82v44lKN+PJIZlWSaon09edsgN18eel0
         Drklscp7n3PJV/iw6aO2xpKCTpziZQdoUVVfOZuKgN5StZZ6ejAczHqCEGHYAjx3BVhf
         VD0S5v6CvlMo17yWk4AnrwS3/yy5QGR9OKJGQmNhzf220vIM4JRX8rlfmJqxhWwZuHaz
         G2nzBMtFdl3ErN2wD2wbk4tilNAcFDKVQBBue7LJQEFDnkSqyjl8tXPKuBeyUD+Cxh4Y
         R2aFJOi1jt2ekbWWUtaSDznwRxF6U+FprdnRYL1Eu9L9Y0RJEkAlgB+Mq7WL5XOEfpIZ
         vEpA==
X-Gm-Message-State: AOAM532IOY9BqxVXBjRBPQeAmEsOLG3qCCxSJsZKt3yrOffQGY7NAzZC
        HfxgnDUg9WvlhyOnQRWjf8boUeLcLJJ3Lg==
X-Google-Smtp-Source: ABdhPJyYult8UVxKv56RzdxaA/8s1kTDBUupdA3tIfV4Ij7p/5okcqdi9++2hLnNkRXHPiGgK2LT8Q==
X-Received: by 2002:a17:90a:a81:: with SMTP id 1mr19225774pjw.174.1602484628907;
        Sun, 11 Oct 2020 23:37:08 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:90d8:71cc:be49:14c1? ([2601:647:4700:9b2:90d8:71cc:be49:14c1])
        by smtp.gmail.com with ESMTPSA id s66sm18143373pfb.25.2020.10.11.23.37.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 23:37:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for SIPI signal
 processing
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <MWHPR11MB196876354169E0DB6046BA5BE3070@MWHPR11MB1968.namprd11.prod.outlook.com>
Date:   Sun, 11 Oct 2020 23:37:06 -0700
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7D2E7AB8-A063-4B91-9FB9-558B9D2BAA4F@gmail.com>
References: <20200925073624.245578-1-yadong.qi@intel.com>
 <MWHPR11MB1968C521D356F1D1FA17EE6EE30F0@MWHPR11MB1968.namprd11.prod.outlook.com>
 <3705293E-84DE-41ED-9DD1-D837855C079B@gmail.com>
 <MWHPR11MB196876354169E0DB6046BA5BE3070@MWHPR11MB1968.namprd11.prod.outlook.com>
To:     "Qi, Yadong" <yadong.qi@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 11, 2020, at 6:19 PM, Qi, Yadong <yadong.qi@intel.com> wrote:
>=20
>> On my bare-metal machine, I get a #GP on the WRMSR that writes the =
EOI inside
>> ipi() :
>>=20
>> Test suite: vmx_sipi_signal_test
>> Unhandled exception 13 #GP at ip 0000000000417eba
>> error_code=3D0000      rflags=3D00010002      cs=3D00000008
>> rax=3D0000000000000000 rcx=3D000000000000080b rdx=3D0000000000000000
>> rbx=3D0000000000000000
>> rbp=3D000000000053a238 rsi=3D0000000000000000 rdi=3D000000000000000b
>> r8=3D000000000000000a  r9=3D00000000000003f8 r10=3D000000000000000d
>> r11=3D0000000000000000
>> r12=3D000000000040c7a5 r13=3D0000000000000000 r14=3D0000000000000000
>> r15=3D0000000000000000
>> cr0=3D0000000080000011 cr2=3D0000000000000000 cr3=3D000000000041f000
>> cr4=3D0000000000000020
>> cr8=3D0000000000000000
>> 	STACK: @417eba 417f36 417481 417383
>>=20
>> I did not dig much deeper. Could it be that there is some confusion =
between
>> xapic/x2apic ?
>=20
> Thanks, Nadav.
> I cannot reproduce the #GP issue on my bare metal machine.
> And I am a little bit confused, there is no EOI MSR write in this test =
suite,
> how the #GP comes out...
> Could you provide more info for me to reproduce the issue?

We might have different definitions for =E2=80=9Cbare-metal=E2=80=9D :)

I meant that I ran it directly on the machine without KVM. See [1]. You
do need some access serial console through the iDRAC/ilo/etc..

Anyhow, I figured out that you forgot to setup CR3 on the AP.

Doing something like:

+       on_cpu(1, update_cr3, (void *)read_cr3());
=20
        /* start AP */
        on_cpu_async(1, sipi_test_ap_thread, NULL);


Solves the problem. You may want to do it in a slightly cleaner way, or
extract update_cr3() to one of the libs to avoid further code =
duplication.

Regards,
Nadav


[1] https://patchwork.kernel.org/patch/11053903/

