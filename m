Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF42A7853
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 08:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKEHxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 02:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKEHxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 02:53:06 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD5C0613CF
        for <kvm@vger.kernel.org>; Wed,  4 Nov 2020 23:53:05 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id x13so784863pfa.9
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 23:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bJoT66/UqNLguyHFdjjr65GAanM6qVPduIrdt2mBxA4=;
        b=RYn4fYuRR0mTPAynqhOwzpej/9Pq95W0xHS/17Ax4R7CkM1YEVzyg9QxuvQ6rYT8bw
         m14C045xaD+lYSADxQYUh+ViBJ1GaiDgmqtbyDl6RlDqDSjtTFFY8CgH2wQb8M3Vf5Kf
         KVwf+zTFfgy/xd+Gg25GGlO2zQDho7F258ZMDTtAwaOgPB0rGr3gZeOIH6QaA1MlIzwW
         waEV7kpeK0LNOq8lVkP4vEAuVFqdiiscS6aYBy3mfD8MQAbSICa6SxOldlfGiqvydgX3
         hz/f7srdPgqu86Kgo7oRvmbV1slw9+ab6lrbKb48Qc7ymQFPSA+c/l4+QlmwQtlPxBtn
         iK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bJoT66/UqNLguyHFdjjr65GAanM6qVPduIrdt2mBxA4=;
        b=OLjsIBZiRhXzr8SPiV0RQUiW1HvTyp/DNJHZvG1p4Pr8HKwXGtBjD+1mvKH8xxlWxU
         gbe+Es4BMl4tGY5D77gNFZmJTHPEO1xnWn/kmBYe/TyZ1s64daVcRI3ULfiIaJIeoO3a
         Dz9ayUHihCdwPDxnMpP+9z9HAn0x5x69nmViUKhpjYcJrDGkEUeqg4j7UJBNWGvkfa7c
         siXDr49KgM8LAFfGRmktogllKCs33JzKX8YB+Ly49hS35qQ+yR+eDmF67zCF+M5GBBFx
         tAr75dQ1i1U8AHWb6KXskqQnjU5WclNPXdyYw32u9kUQWVWgBC/8rYMPxPu/srR35PgS
         tt1Q==
X-Gm-Message-State: AOAM5320H0nIV9lXo5+Mc+vf0WpHj03cbwf01pIVnnfINbooOUcak6DD
        Nw53Hmj0lkxQfotnIT8hCAM=
X-Google-Smtp-Source: ABdhPJxWtdRkHWm3uPzC9d/s1tQzovCzs+7s/F90y4ZOK7EGK/w0LFnuUlQ0ZXe0GYzkpEEmUQZSUw==
X-Received: by 2002:a17:90a:80c9:: with SMTP id k9mr1174546pjw.79.1604562784735;
        Wed, 04 Nov 2020 23:53:04 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:bda5:9796:e204:84e? ([2601:647:4700:9b2:bda5:9796:e204:84e])
        by smtp.gmail.com with ESMTPSA id k15sm1299208pgh.62.2020.11.04.23.53.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 23:53:03 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: check that clflushopt of an MMIO
 address succeeds
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201103160855.261881-1-david.edmondson@oracle.com>
Date:   Wed, 4 Nov 2020 23:53:01 -0800
Cc:     KVM <kvm@vger.kernel.org>, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D92A2CAA-584C-48FE-A071-682DB287432A@gmail.com>
References: <20201103160855.261881-1-david.edmondson@oracle.com>
To:     David Edmondson <david.edmondson@oracle.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Nov 3, 2020, at 8:08 AM, David Edmondson =
<david.edmondson@oracle.com> wrote:
>=20
> Verify that the clflushopt instruction succeeds when applied to an
> MMIO address at both cpl0 and cpl3.
>=20
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>=20

[snip]

> +	ret =3D pci_find_dev(PCI_VENDOR_ID_REDHAT, =
PCI_DEVICE_ID_REDHAT_TEST);
> +	if (ret !=3D PCIDEVADDR_INVALID) {
> +		pci_dev_init(&pcidev, ret);

Just wondering, and perhaps this question is more general: does this =
test
really need the Red-Hat test device?

I know it is an emulated device, but can=E2=80=99t we use some other =
MMIO address
(e.g., PIT) that is also available on bare-metal?

