Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F151CB53E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEHQ4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 12:56:37 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:58036 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEHQ4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 12:56:37 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 0F68E2E0E43;
        Fri,  8 May 2020 19:56:34 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id TLSYbsq6XL-uXWWRMSI;
        Fri, 08 May 2020 19:56:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588956994; bh=JPwhDlNygUCNya+u1OVmS0FqYzzk+3lVFpXzWTtC53w=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=eXvLIrPpB4iTv5aWogftFjlyE1MwRAAyuFcvCBzQkOHWwIXwwyke+z2C/XstcyHgk
         z2EQZ6SNmd3OacAEquRWGtzcuicnaxIk9QPmYw0cYY12UZ3oE/JcllTHbxMfCu2KQf
         8Tk3WPlMHDDkcG2duyBJSw1yIl11KAByEfQplXEQ=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:517::1:a])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Dm1QRpJe3P-uWWKLl5J;
        Fri, 08 May 2020 19:56:32 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Fri, 8 May 2020 19:56:31 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200508165631.GA9576@rvkaganb>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
 <20200505200010.GB400685@rvkaganb>
 <20200506044929.GD2862@jondnuc>
 <20200506084615.GA32841@rvkaganb>
 <20200507030037.GE2862@jondnuc>
 <20200508142954.GH2862@jondnuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508142954.GH2862@jondnuc>
Received: from fastsrv.yandex-team.ru (iva8-96b94b6ea53b.qloud-c.yandex.net
 [2a02:6b8:c0c:2f26:0:640:96b9:4b6e]) by mxbackcorp1o.mail.yandex.net with
 LMTP id aBVHqGFBXH-OtHdu90kJuQ1 for <rvkagan@mail.yandex-team.ru>; Fri, 08
 May 2020 19:55:26 +0300
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 05:29:54PM +0300, Jon Doron wrote:
> Hi, just wanted to update you I did some stupid mistake when I did the UEFI
> setup test (that's why I could not boot my Win10).
> 
> I suggest we will abandon this patch, and try to keep going on the QEMU
> VMBus patchset.
> 
> And perhaps submit a very basic patch to SeaBIOS and EDK2 which just enable
> SCONTROL.
> 
> Does that sound like a good plan to you?

Absolutely.

Thanks,
Roman.
