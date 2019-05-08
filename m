Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31367182BD
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfEHXiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 19:38:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43780 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfEHXiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 19:38:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id n8so146375plp.10
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 16:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0hxH/Y1I/+AiCLRqngDiJ8pCwAEeJTQ30Vg4ucT9SsQ=;
        b=sQLL6mRV3sLvKyzaindicKc+pYFJ87wEL0um8WFax/ghc4Yzuf5Hs/ngxClnw2eIP1
         HP0OSOt1w27vtLdHimRMg64iWNd8avhUPaETzcouesPS27ol76D8BQpRSiZ9X+uXgcYj
         4BheEwoqeqZLmKXIbDUMsRGPAYanc8XehPp7JSl1bXKAMEcWkSSOQDuppvEOcmPaSBAV
         Uit+oh9CxSkUj9UO1JNd7QpPcwrU3EC9y6OsZ4Ys1F02hubxX21hpSxZcPWdkZ24+5aP
         ypnook9Dtqh3EpY49IXNTy+UFizfYyp2JYSMx9fCk744VnJSsOQW2t/739kUfB6yAnp8
         xBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0hxH/Y1I/+AiCLRqngDiJ8pCwAEeJTQ30Vg4ucT9SsQ=;
        b=qE01WxVxrMhHQy9BrjY1IQw6hbuV67CJa7DgrTfWI/PmiTjv819IDF4XDv+Vx1ypDd
         CG8OzLW1sEf53uXbiX71NbTCb4tb7CLZ0b5Rwj+nTkJ5Ku/a7MbmdaKk3R9CF4ze1FBA
         BIgsMc4z3ERauoSXkwWhqiURKSOWGCEqKeQdMYJrbp0POvXm2hu64b3XEIjj7oThCa88
         4sApNLHATnJlTIVXDFk9vtYnl32Nj5pEsOGMZ7iBOCrtgWfvNKn8A/skhWcmCxMZqjRS
         CAnSKSgp6UG5LogyZNGDCAzndqCPXN7MA58vgmMqLUsQD5fs92XD/simUL8al7KbpDSj
         l22A==
X-Gm-Message-State: APjAAAV+Q5uJTnZlh6j5bRqXR1Tvv8xuJOwGd81kNbsdWSwxsie7WG85
        ol3DMsqVECM4jVL07oSzm5g=
X-Google-Smtp-Source: APXvYqxEA5PTjB+oHkMm/I/Be5/FWSU9dz2dSfBLH9keWFY7Fc78T858krsOxM9QbuPRGHHgjR7c1g==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr755359plb.4.1557358692383;
        Wed, 08 May 2019 16:38:12 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id w38sm327544pgk.90.2019.05.08.16.38.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 16:38:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after
 NMI/INTR-window tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTE8vsrSC0K7KVArT_KFA_NGBZ5t6eW_Gh8cdJ_88JM+Q@mail.gmail.com>
Date:   Wed, 8 May 2019 16:38:10 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E388EB3A-CB2C-436D-94D2-1157B3328EAD@gmail.com>
References: <20190508102715.685-1-namit@vmware.com>
 <20190508102715.685-3-namit@vmware.com>
 <CALMp9eTE8vsrSC0K7KVArT_KFA_NGBZ5t6eW_Gh8cdJ_88JM+Q@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 8, 2019, at 4:21 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> From: Nadav Amit <nadav.amit@gmail.com>
> Date: Wed, May 8, 2019 at 10:47 AM
> To: Paolo Bonzini
> Cc: <kvm@vger.kernel.org>, Nadav Amit, Jim Mattson, Sean =
Christopherson
>=20
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
>> events wake the logical processor if it just entered the HLT state
>> because of a VM entry." A similar statement is told about NMI-window
>> exiting.
>>=20
>> However, running tests which are similar to verify_nmi_window_exit() =
and
>> verify_intr_window_exit() on bare-metal suggests that real CPUs do =
not
>> wake up. Until someone figures what the correct behavior is, just =
reset
>> the activity state to "active" after each test to prevent the whole
>> test-suite from getting stuck.
>>=20
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
>=20
> I think I have been assuming that "wake the logical processor" means
> "causes the logical processor to enter the 'active' activity state."
> Maybe that's not what "wake" means?

I really don=E2=80=99t know. Reading the specifications, I thought that =
the test is
valid. I don=E2=80=99t manage to read it any differently than you did.

