Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D8107C48
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 02:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfKWBlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 20:41:00 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33574 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfKWBk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 20:40:59 -0500
Received: by mail-pj1-f67.google.com with SMTP id o14so3849517pjr.0
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 17:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=plyjHlpPqvFNNK7wswM4fgLsIBmPXW6QytuDlO5XyNc=;
        b=Eauai1+p2hxa31oWM46CrXIblVVL4+ReBGWQHu2HcX8UNQSmGDvQA16/mJ/unLaXPP
         Q0ooNMDp4UsbhIUPNFxk2q1bQD7VlI67egV4n5WYPNLWglet61zTeOAHXlhN0xsy40FM
         DXWnit2eH/zVm+h3yXqEVvtfB6GUuipXeY1El2AOcZDY8JFcDhVuNa1yUOi2DjVoxOT/
         YiSIjkRlEufk5N53GDwwIc2diFP84VByv8N3N+hJHoe0qNIL8Bg2n45RBPnndKTdx/hH
         UtDB/2vShEJZBL7Sko4+F1mK+KzH8WGDXOsgCe7uoaEFM/lXe0zROhrTWnzyTz0lUlLP
         kk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=plyjHlpPqvFNNK7wswM4fgLsIBmPXW6QytuDlO5XyNc=;
        b=LDi8cbGvZo20VoEuHHC5bihC2om8MuHC3tOZMQCtMoZJMWBjPpybNGAFkUAVYeNsAA
         L7os41CSr+hmGqJO15pcaojEkn8Suh7mg4htkLq7pRL/+moE9rV0/c42W4NNarKLK5IJ
         kX8Z4cOJjp8F9ag0Q2lf2qMEH7iKOjb0kNKUHTSK+k5F1fRE4bKpR+MzQQwuPAkbZuLQ
         OGFtM/LVB/H1U8qwONLLAmdlL0XrIpRyQbSHEM2ELWJQ3dOv7n1PRJXJpK9xdJgkEGaT
         4n9Eeapbs6VILvNth5lk0CvZosOTm0ub4PbvDgrVWjq0jG5k8yBv2rr4xuloYejBWAAM
         ocyw==
X-Gm-Message-State: APjAAAXohZJ4X1gWqQJIxmBlJrSXjZLrGGFQvjiZN/eo9sTe40rjjwAD
        I8KW7d0lhSQN+0bPwcWT9uU=
X-Google-Smtp-Source: APXvYqyP9DxHyWmi6GklaB1cYsJK+gp8Gva59x90VmiEUDiE2KYXMudCPdPC8OVfoJKLMWr7LwhRyg==
X-Received: by 2002:a17:90a:ca04:: with SMTP id x4mr22989412pjt.103.1574473258642;
        Fri, 22 Nov 2019 17:40:58 -0800 (PST)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id m15sm8745762pfh.19.2019.11.22.17.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 17:40:57 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH kvm-unit-tests 2/4] x86: vmx_tests: extend HOST_EFER tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1569428066-27894-3-git-send-email-pbonzini@redhat.com>
Date:   Fri, 22 Nov 2019 17:40:56 -0800
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1EE752DF-F00B-4504-8E9B-56BC31127FA4@gmail.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
 <1569428066-27894-3-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Sep 25, 2019, at 9:14 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> Extend the tests to cover the host address size bit.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> x86/vmx_tests.c | 126 =
+++++++++++++++++++++++++++++++++-----------------------
> 1 file changed, 74 insertions(+), 52 deletions(-)

I get the following results with this test on Skylake bare-metal:

PASS: HOST_EFER EFER_LMA bit turned off, controls off: vmlaunch succeeds
PASS: HOST_EFER EFER_LMA bit turned on, controls off: vmlaunch succeeds
PASS: HOST_EFER EFER_LMA bit turned off, controls on: vmlaunch fails
PASS: HOST_EFER EFER_LMA bit turned off, controls on: VMX inst error is =
8 (actual 8)
PASS: HOST_EFER EFER_LMA bit turned on, controls on: vmlaunch succeeds
PASS: HOST_EFER EFER_LME bit turned off, controls off: vmlaunch succeeds
PASS: HOST_EFER EFER_LME bit turned on, controls off: vmlaunch succeeds
PASS: HOST_EFER EFER_LME bit turned off, controls on: vmlaunch fails
PASS: HOST_EFER EFER_LME bit turned off, controls on: VMX inst error is =
8 (actual 8)
PASS: HOST_EFER EFER_LME bit turned on, controls on: vmlaunch succeeds
PASS: HOST_EFER EFER_LMA bit turned off, controls off: vmlaunch fails
FAIL: HOST_EFER EFER_LMA bit turned off, controls off: VMX inst error is =
8 (actual 7)
PASS: HOST_EFER EFER_LMA bit turned on, controls off: vmlaunch fails
FAIL: HOST_EFER EFER_LMA bit turned on, controls off: VMX inst error is =
8 (actual 7)
PASS: HOST_EFER EFER_LMA bit turned off, controls on: vmlaunch fails
PASS: HOST_EFER EFER_LMA bit turned off, controls on: VMX inst error is =
8 (actual 8)
PASS: HOST_EFER EFER_LMA bit turned on, controls on: vmlaunch succeeds
PASS: HOST_EFER EFER_LME bit turned off, controls off: vmlaunch fails
FAIL: HOST_EFER EFER_LME bit turned off, controls off: VMX inst error is =
8 (actual 7)
PASS: HOST_EFER EFER_LME bit turned on, controls off: vmlaunch fails
FAIL: HOST_EFER EFER_LME bit turned on, controls off: VMX inst error is =
8 (actual 7)
PASS: HOST_EFER EFER_LME bit turned off, controls on: vmlaunch fails
PASS: HOST_EFER EFER_LME bit turned off, controls on: VMX inst error is =
8 (actual 8)
PASS: HOST_EFER EFER_LME bit turned on, controls on: vmlaunch succeeds

Apparently, turning the controls off, causes some =E2=80=9CVM entry with =
invalid
control field=E2=80=9D (7) instead of =E2=80=9CVM-entry with invalid =
host-state field=E2=80=9D.

According to the SDM, checks of control fields and host field are not =
ordered.
But I do not know what exactly causes the failure.

