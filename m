Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B0D6F4A1
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 20:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGUS01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 14:26:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36422 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfGUS00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 14:26:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so16254700pfl.3
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PHDIIvGX8533QpOCTfiRKfsRytK8ntOLSE4rPnK0DcE=;
        b=gTnUIHabBFHS9xrqgPlxB9AhrNMSrqldXIMyFiC0HOxe+VtKN99aVPaCrZ0g098tkg
         CItVA3Gb9sq3PMrIV836EkQ0Z/Qj474xD2mljxobhWonSA4n9GR3gTIDrkdiAjJKFOcP
         DELqFbFhaYByE6k/TbnTyxzsm0EPca0D5sVCj8tolHcOAPQ4rFvdROstHG3dGMgkpgXS
         B07b8kMhZ9TtN+gm1CGSnpdowu0/IJdd3beZ8/OpZXONjs8bIyn38l5iHUx9hhYwaL28
         LZVEhDpTtaHAMDb+pZLopPhCx6W9IB+dIb03eJxJnkmIQP01hNFpUr587/OPHd9BtMMi
         ye6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PHDIIvGX8533QpOCTfiRKfsRytK8ntOLSE4rPnK0DcE=;
        b=sLO3KuetJu8LSK9qWvxH2wycx6Vo+MQv2m+s/rRogXNG5nsjfmTujjiocKE7SHmGLn
         tDvbyxyxOYB0+1YEebS9XAhufGTSVX+14fomh6coHMIlh3jaxlJMMis9H4zLUQsZu0qL
         a5tVjqCrjX1Xf810VByh/jAlvCsau/EpATufYycAKXwSv8zRmZvR2ZyA4O/EZBmqEblc
         OO0RCDmpPcsgVFgbj1QDZFNephrRqc5Cif7fTNiYywU/A+Dfrjzqv/cMbUB7lMioVLUW
         FzJrNFx0+IBD4eA8A+5lwCD4H/a8CdjxvU9QAGaEqW0CIs/I6rPCrsnQOdO1fXdzebzb
         iCjQ==
X-Gm-Message-State: APjAAAXsHhsyWT2l3H6AsNXgkZ8gI6WSM8VdzAr+etb61ShEjPbGxLa2
        I86dt1qClrME+TNOyZ40KEo=
X-Google-Smtp-Source: APXvYqyRu7VzzQXPKyYd0VylkwVtJelcAOkBsW0sMnuvmttJ2raM2pesVKxIV317LJMcAUlglIki+g==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr72786268pjs.101.1563733585981;
        Sun, 21 Jul 2019 11:26:25 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v13sm45227252pfe.105.2019.07.21.11.26.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 11:26:25 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2 v2]kvm-unit-test: nVMX: Test Host Segment Registers
 and Descriptor Tables on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190703235437.13429-3-krish.sadhukhan@oracle.com>
Date:   Sun, 21 Jul 2019 11:26:24 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <826A8AB0-D0A3-4C77-96C9-9C6670CF6C9C@gmail.com>
References: <20190703235437.13429-1-krish.sadhukhan@oracle.com>
 <20190703235437.13429-3-krish.sadhukhan@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 3, 2019, at 4:54 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
> According to section "Checks on Host Segment and Descriptor-Table
> Registers" in Intel SDM vol 3C, the following checks are performed on
> vmentry of nested guests:
>=20
>    - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, =
the
>      RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>    - The selector fields for CS and TR cannot be 0000H.
>    - The selector field for SS cannot be 0000H if the "host =
address-space
>      size" VM-exit control is 0.
>    - On processors that support Intel 64 architecture, the =
base-address
>      fields for FS, GS, GDTR, IDTR, and TR must contain canonical
>      addresses.

As I noted on v1, this patch causes the test to fail on bare-metal:

 FAIL: HOST_SEL_SS 0: VMX inst error is 8 (actual 7)

I don=E2=80=99t know what the root-cause is, but I don't think that =
tests that
fail on bare-metal (excluding because of CPU errata) should be included.

