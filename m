Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675FAC2A31
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfI3XCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:02:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37695 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3XCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:02:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so6469253pfo.4
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PUeAdddicHf+X6gaxhZyUx6ITWPAPmZpRqJJvt9jw0w=;
        b=idUGstjutNREl9OEJTnZUiNmWyYO1bgqsI/ju/KFyDIKbOxlmmbqTaGooiAo2Y0lc9
         2SFILS+VIyPSMEQQMmpVqmN/ar03Aumgd+ag8RWCf0E17OTnHJxjiLFnww19MgKrfKW0
         YkX+6p8LHVDxUJfKK/nAP4Qaxw/u2jEHzM5SdV06CxBIM05cLfqNLGUu9eACXH7umKuF
         nut/vSndyNID8E9t5ay78CmxcMRKuMsNjwbkte/HuCiRKxyb20G+i8gtsEkRfMdXZmL7
         YlYdkCnh6yWDFMuflSJmW9Q6gq79dsPQjHB/UhuFCfJEyuPuZZJ9dO9+QluuL5IDuurI
         1sKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PUeAdddicHf+X6gaxhZyUx6ITWPAPmZpRqJJvt9jw0w=;
        b=Im1TajkYXnvqT8thLAWF+SoFjN2dr3xjiz3EzDd4darMXsKWw2zL5onQVVI3AgsXKG
         ROA3WyDv81cs4dLTJefehphw8z5E8GSSzwXBpkOp5/tzfGPmL7qp0RyeQb20M+ab0/Rg
         /6SpcSckcPhN5wo5RLhbEBA0Mcwxx0IlJ1mp+qRtC6f9A3TnJ9LK3Exp3U3JRzflwuzv
         DGVGZxBSFBImfJU0DRqJETb5LUO3gDY3uIT9i/dpcgCBcdBr9+4tknWWrixyRmxTIT5W
         z3UB9wZMBqFUa1F7ICWq+zpVb3yLSm6VBnWndgnE+bqOC5Inz93KD9kLH5AIS6OKdo9/
         KQsg==
X-Gm-Message-State: APjAAAUkPKMIHriis2bK014yBvpw3XBAW/C1SGEFDpmY8Hgy9m+TR26j
        wCgaqP5rF0k7s5NDs/aqj0E=
X-Google-Smtp-Source: APXvYqyYnAQ8+aoBDvID/Pd2uZyInoPmSJ0ZupD96eJXCqnbRbeA2SjvSyH6LR9tmHr9tmSj7lohoA==
X-Received: by 2002:aa7:998f:: with SMTP id k15mr25074498pfh.203.1569884559458;
        Mon, 30 Sep 2019 16:02:39 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y8sm21104238pgr.28.2019.09.30.16.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 16:02:38 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190919125211.18152-1-liran.alon@oracle.com>
Date:   Mon, 30 Sep 2019 16:02:36 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Sep 19, 2019, at 5:52 AM, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> Hi,
>=20
> This patch series aims to add a vmx test to verify the functionality
> introduced by KVM commit:
> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>=20
> The test verifies the following functionality:
> 1) An INIT signal received when CPU is in VMX operation
>  is latched until it exits VMX operation.
> 2) If there is an INIT signal pending when CPU is in
>  VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
> 3) Exit from VMX non-root mode on VMExit do not clear
>  pending INIT signal in LAPIC.
> 4) When CPU exits VMX operation, pending INIT signal in
>  LAPIC is processed.
>=20
> In order to write such a complex test, the vmx tests framework was
> enhanced to support using VMX in non BSP CPUs. This enhancement is
> implemented in patches 1-7. The test itself is implemented at patch 8.
> This enhancement to the vmx tests framework is a bit hackish, but
> I believe it's OK because this functionality is rarely required by
> other VMX tests.
>=20
> Regards,
> -Liran

Hi Liran,

I ran this test on bare-metal and it fails:

 Test suite: vmx_init_signal_test
 PASS: INIT signal blocked when CPU in VMX operation
 PASS: INIT signal during VMX non-root mode result in exit-reason =
VMX_INIT (3)
 FAIL: INIT signal processed after exit VMX operation
 SUMMARY: 8 tests, 1 unexpected failures

I don=E2=80=99t have time to debug this issue, but let me know if you =
want some
print-outs.

Nadav

