Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B72AF75B8
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKKNyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:54:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbfKKNyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Kdxnyo+p6t0JdZhsLc2EdVrHnYFkAr4aia07OARRAyk=;
        b=ZZs1HUK2Mn8lDBCAE8iSdkLx1yAUG/FibdjEP6QCxLB8OcUWKhWqeQwE3JvOuAdGR3Q/xL
        inbuCTYlLXcuxRVMiCKgTwzS8glOVeWo7TX7YKOfO89Khn7JhERCs/XYvjo3vf4/trYFmt
        HZX50Fjo5fYdMWsLj2H6LVJI0aElk48=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-Wrq4e7CsN92LVxn_Nkz79A-1; Mon, 11 Nov 2019 08:54:47 -0500
Received: by mail-wm1-f69.google.com with SMTP id h191so8181189wme.5
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BxHVyZ+cnRCYzkQSXGK/lCaiu55fYily773XUj4dT5s=;
        b=Vv3PKoihBmZ33n7fJTbaMfEF1yM+fhap/40wNb1yC37epv9ZYbALPXoq86gMFpykZQ
         xgKq7EL3UHX94Dteef+5gY2i0CPGuj5HWmfFRDMejeBtwPG2juVb9h76+7FPnK4aDKAk
         SZUnJtqHx+GV3Av5oFsrYV2+D36jz3KCdeBUtScGwh0VssI0f04OrWmJIEUj1fzkPXS1
         xn3Q7RLkmtKcUBxWE6121Ev3RA3tFXsSQ466iu16gjG/M1CjPcBRRQo95pGvcjpS4LL0
         Xv9gHQunNvbD7k+WejFpomNVtXnolpk9pia24p9RIFHjayWNj6u1vWX9UVyRIvZrMyDB
         5Ung==
X-Gm-Message-State: APjAAAW25eUrd/tuZ+dzaYIxCLdpAnpzgMnrtepfq3ELLd+uNI2lTlRl
        O1MhwZFfsMyQ004Uc1YcXCQt2aeabJXNKsDtQ8RGrkUJ08JSxpmdn/VajqnFQgvpEQyHMb0KOSA
        uR5Vz7CmJUCwI
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr9404568wmc.37.1573480486541;
        Mon, 11 Nov 2019 05:54:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqxPKbfaui1XILL/LXgyrl/T67qcN/cQ/bVUBjzaNiprDnW/V8fSSn81rsVJlkmK1d+EG5JIBg==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr9404546wmc.37.1573480486289;
        Mon, 11 Nov 2019 05:54:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id 200sm27687037wme.32.2019.11.11.05.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:54:45 -0800 (PST)
Subject: Re: [PATCH 4/5] cpuidle-haltpoll: add a check to ensure grow start
 value is nonzero
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-5-git-send-email-zhenzhong.duan@oracle.com>
 <20191101211908.GA20672@amt.cnet>
 <7245089f-788e-03d6-9833-6ce4d313f4ce@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <57679389-6e4a-b7ad-559f-3128a608c28a@redhat.com>
Date:   Mon, 11 Nov 2019 14:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7245089f-788e-03d6-9833-6ce4d313f4ce@oracle.com>
Content-Language: en-US
X-MC-Unique: Wrq4e7CsN92LVxn_Nkz79A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 03:56, Zhenzhong Duan wrote:
>=20
> On 2019/11/2 5:19, Marcelo Tosatti wrote:
>> On Sat, Oct 26, 2019 at 11:23:58AM +0800, Zhenzhong Duan wrote:
>>> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
>>> guest_halt_poll_shrink). If guest_halt_poll_grow_start is zero,
>>> dev->poll_limit_ns will never be larger than zero.
>>>
>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>> ---
>>> =A0 drivers/cpuidle/governors/haltpoll.c | 15 ++++++++++++---
>>> =A0 1 file changed, 12 insertions(+), 3 deletions(-)
>> I would rather disallow setting grow_start to zero rather
>> than silently setting it to one on the back of the user.
>=20
> Ok, will do.

Similar to patch 2, I think disabling halt polling is a good behavior if
grow_start =3D 0.

Paolo

