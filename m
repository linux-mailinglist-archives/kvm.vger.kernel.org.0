Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1302107E02
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfKWKWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:22:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbfKWKWU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Nov 2019 05:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574504538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TtLTEtBWf4y9L2z3NCrE6T7Sn8p33MruSXRSTugIgt8=;
        b=ihOEIAqalepbEMoVZB1uOg4gyKrBAJUyQQS9yZOI7jH4PTz5OtmdQehqv5eEvPDWcoj9vQ
        RIyaYDyX2BT1FiZ3UVQoS8U5nmPt5C5y4UVoV69YqfUB1c9fMeOYWJW/mdqO7T+kdnzjIh
        w7ntj//fn1Iz7en94RDcivyIVKZX5t0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-fe5huQzDOaWmvLgWCZ13AA-1; Sat, 23 Nov 2019 05:22:17 -0500
Received: by mail-wr1-f69.google.com with SMTP id c6so5232529wrm.18
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9bDBmXdZA69WLyzAiMBLBK7Z2+jpZZgwiaZErKcUFII=;
        b=j3Lq62nRKgnFZmk1LOHzmjRgN1qV/bYaxJ3DEmkhjHPaHP5Z5GTg28eck2FrQ/vFpa
         yXdBZMFqkON91VNEZp9b7XkiOjRbScOLCQ9IMxNq92UZw4MJH4ko0xwLSQR58oY83bIV
         09f6DvCDReaNv5n+WYxDVJ0GtY3BRuVLMPjiTe+u1u0RVKx+he+qBWJRDhcjgPBig9hr
         RA56fig8G3zTAqPwGz1QR9tF7DOF70owW3wF0PFTLd3qUL7JTHMDjMtUcLFHBct7Mebw
         BOoBAuSAbBm3Qk5IU05osgFnx6EKNWe/I9IiPR5rP2IMY+Y0KJi2gSUN2jbJgVj598Wd
         AKpQ==
X-Gm-Message-State: APjAAAVh7x1UUWcDMWj0HSKUT0T24AjMNr7QYzVGFY08fHJAqu8cbEUt
        aaDmMe7SxdGmuWL6G+rAv/97bV7X1Boui5NFEICtRsYHEdq0VDKalmOhZk+9mBql84RfDfSTtJH
        /4zn6Qzp3XZnM
X-Received: by 2002:a7b:cd86:: with SMTP id y6mr20232536wmj.163.1574504535925;
        Sat, 23 Nov 2019 02:22:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzd/+DDyjpLmCGeMts5WYWRDcxayFxn/ldBPMt2CdqZtkrDZqA4SYqLQxpXy5TdvofK8VcFqQ==
X-Received: by 2002:a7b:cd86:: with SMTP id y6mr20232512wmj.163.1574504535630;
        Sat, 23 Nov 2019 02:22:15 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id v14sm1614955wrm.28.2019.11.23.02.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:22:15 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 2/4] x86: vmx_tests: extend HOST_EFER tests
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
 <1569428066-27894-3-git-send-email-pbonzini@redhat.com>
 <1EE752DF-F00B-4504-8E9B-56BC31127FA4@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ddf7ba88-baf3-8727-586d-66dfa6ed7455@redhat.com>
Date:   Sat, 23 Nov 2019 11:22:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1EE752DF-F00B-4504-8E9B-56BC31127FA4@gmail.com>
Content-Language: en-US
X-MC-Unique: fe5huQzDOaWmvLgWCZ13AA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/11/19 02:40, Nadav Amit wrote:
>=20
>=20
>> On Sep 25, 2019, at 9:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Extend the tests to cover the host address size bit.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> x86/vmx_tests.c | 126 +++++++++++++++++++++++++++++++++-----------------=
------
>> 1 file changed, 74 insertions(+), 52 deletions(-)
>=20
> I get the following results with this test on Skylake bare-metal:
>=20
> PASS: HOST_EFER EFER_LMA bit turned off, controls off: vmlaunch succeeds
> PASS: HOST_EFER EFER_LMA bit turned on, controls off: vmlaunch succeeds
> PASS: HOST_EFER EFER_LMA bit turned off, controls on: vmlaunch fails
> PASS: HOST_EFER EFER_LMA bit turned off, controls on: VMX inst error is 8=
 (actual 8)
> PASS: HOST_EFER EFER_LMA bit turned on, controls on: vmlaunch succeeds
> PASS: HOST_EFER EFER_LME bit turned off, controls off: vmlaunch succeeds
> PASS: HOST_EFER EFER_LME bit turned on, controls off: vmlaunch succeeds
> PASS: HOST_EFER EFER_LME bit turned off, controls on: vmlaunch fails
> PASS: HOST_EFER EFER_LME bit turned off, controls on: VMX inst error is 8=
 (actual 8)
> PASS: HOST_EFER EFER_LME bit turned on, controls on: vmlaunch succeeds
> PASS: HOST_EFER EFER_LMA bit turned off, controls off: vmlaunch fails
> FAIL: HOST_EFER EFER_LMA bit turned off, controls off: VMX inst error is =
8 (actual 7)
> PASS: HOST_EFER EFER_LMA bit turned on, controls off: vmlaunch fails
> FAIL: HOST_EFER EFER_LMA bit turned on, controls off: VMX inst error is 8=
 (actual 7)
> PASS: HOST_EFER EFER_LMA bit turned off, controls on: vmlaunch fails
> PASS: HOST_EFER EFER_LMA bit turned off, controls on: VMX inst error is 8=
 (actual 8)
> PASS: HOST_EFER EFER_LMA bit turned on, controls on: vmlaunch succeeds
> PASS: HOST_EFER EFER_LME bit turned off, controls off: vmlaunch fails
> FAIL: HOST_EFER EFER_LME bit turned off, controls off: VMX inst error is =
8 (actual 7)
> PASS: HOST_EFER EFER_LME bit turned on, controls off: vmlaunch fails
> FAIL: HOST_EFER EFER_LME bit turned on, controls off: VMX inst error is 8=
 (actual 7)
> PASS: HOST_EFER EFER_LME bit turned off, controls on: vmlaunch fails
> PASS: HOST_EFER EFER_LME bit turned off, controls on: VMX inst error is 8=
 (actual 8)
> PASS: HOST_EFER EFER_LME bit turned on, controls on: vmlaunch succeeds
>=20
> Apparently, turning the controls off, causes some =E2=80=9CVM entry with =
invalid
> control field=E2=80=9D (7) instead of =E2=80=9CVM-entry with invalid host=
-state field=E2=80=9D.
>=20
> According to the SDM, checks of control fields and host field are not ord=
ered.
> But I do not know what exactly causes the failure.

The failure happens when checking the VM-exit host address size bit
against EFER.LMA.  26.2.2 puts that check under "Checks on Host Control
Registers and MSRs", so technically it would be wrong to return error 7
instead of 8.  However we can relax the test, it's not a big deal.

Paolo

