Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B46C445D
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 01:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfJAXhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 19:37:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44661 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbfJAXhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 19:37:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id i14so10784238pgt.11
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 16:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6x+IVA0/EOtbh6VduVVtHR62h1xHhwzVGrLStBwdG7w=;
        b=uoOrBVwzl/YnIQkJv0Cr51DOx3hhUADpioNm/hsRXKkctS64X2vKTCJHf66f5KRaPe
         cdSX3FxIw4XguK1nNIJZilDapxseUNiJO+fnMZ3avlkIywqJd2uQJIuBfwjAqs/HqUIX
         +UeV82/8Gp73QwB6oPTV2Nmn2bIEnu3meXfPAfQnp2U7IZgWOV9+U/sz1xxxsL0ie1aU
         v2cpXAYmUFOXcjWl4o0V3dRbca9wi2YOAbYojTwIyTLnrwfc8DdfjrU1xlz8mB6c9Osu
         JTlnF20XkU2bjv+gYFRutj7CGAd1e7XwnXjZ4mufLlr3pPNlcpuIZwkhE6MDczC3l4ip
         MvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6x+IVA0/EOtbh6VduVVtHR62h1xHhwzVGrLStBwdG7w=;
        b=CMx3Hwakg8iWlsXr0HfQ3F4WqOd0S6mYavLhCLq8NvYUCxZKTdqUTxnFJUE7WezK1S
         a2JAkZQlJbasxb2ZHLQpX39SVKrIZDHLwGchQ10Dv3iqQE+Tonm1hp/MZ+UCOcNyvHsc
         zAAnxGP6IQP/POqxMtBXx6Fn9Nn9FyFIirn0ztTpO+WIF3gHexmvSk55zp9PgEzALuMl
         A8rs442ujEIzoGh0ykW9haAKJKImP3uuyO+9HGBmuqz3Z1Gn51ZDMGyVL2tP/OzugCac
         nvdaGguHujJw6PLFYBQQpUuts8oKdDCYQE77/evWMSm0uZ3pinJPs/9E+6ARnBxpW6E3
         MaJQ==
X-Gm-Message-State: APjAAAXkF4cLPcqdybm9l3B//7adSsGaFISsHURbnNUKYPYSCeEIhXFw
        tMz95GcqvnpIsvr7PVfZx6I=
X-Google-Smtp-Source: APXvYqxbnEnV0EfLcUAhpXsyH888vyjJsE3NmHNRCCUE/m1tnzKXANjW1JmVPaxXjSYqj+SQgIH7Wg==
X-Received: by 2002:a63:151f:: with SMTP id v31mr443299pgl.233.1569973065037;
        Tue, 01 Oct 2019 16:37:45 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id l72sm4181691pjb.7.2019.10.01.16.37.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 16:37:43 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20191001233408.GB6151@linux.intel.com>
Date:   Tue, 1 Oct 2019 16:37:41 -0700
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3DAFE71E-1A28-490D-BD3E-056C54766915@gmail.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
 <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
 <20191001184034.GC27090@linux.intel.com>
 <20191001233408.GB6151@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 1, 2019, at 4:34 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Oct 01, 2019 at 11:40:34AM -0700, Sean Christopherson wrote:
>> Anyways, I'll double check that the INIT should indeed be consumed as =
part
>> of the VM-Exit.
>=20
> Confirmed that the INIT is cleared prior to delivering VM-Exit.

Thanks for checking. I guess Liran will take it from here - I just =
wanted to
ensure kvm-unit-tests on bare-metal is not broken.

