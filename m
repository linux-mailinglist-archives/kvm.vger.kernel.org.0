Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964143A5852
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhFMMqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 08:46:22 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:53007 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231733AbhFMMqV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 13 Jun 2021 08:46:21 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2021 08:46:21 EDT
Received: from myt5-95f184467838.qloud-c.yandex.net (myt5-95f184467838.qloud-c.yandex.net [IPv6:2a02:6b8:c12:5981:0:640:95f1:8446])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id BCAC04D41219
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 15:36:48 +0300 (MSK)
Received: from myt6-efff10c3476a.qloud-c.yandex.net (myt6-efff10c3476a.qloud-c.yandex.net [2a02:6b8:c12:13a3:0:640:efff:10c3])
        by myt5-95f184467838.qloud-c.yandex.net (mxback/Yandex) with ESMTP id KOGJbXhgh6-amI0bcQr;
        Sun, 13 Jun 2021 15:36:48 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1623587808;
        bh=40GLmJMHLXoOqUixsdtFsGY+AQQlYxAe2PcEAtt58NE=;
        h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
        b=gRk5CAZcJdLJa/V4sc1He6rS54tRnKCAKSvSN7xzNIikrO+7EUMQVv6yKWGyrHwsh
         eWxnbRdBT8iwQMQ++0OibgZ7hRkLZt4EKwcXbXGYTAIEMgSckktdM2QRhJCpOLzr+3
         WwGFMtxpJyn5/iDBhrRwXS7uW/IxQBa5C9UpQuu0=
Authentication-Results: myt5-95f184467838.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-efff10c3476a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id hCj3MKLKEI-am2GrMS1;
        Sun, 13 Jun 2021 15:36:48 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
From:   stsp <stsp2@yandex.ru>
To:     kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
Message-ID: <87035d8e-ad35-5cbb-a547-ee7c353221d4@yandex.ru>
Date:   Sun, 13 Jun 2021 15:36:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

13.06.2021 01:49, stsp пишет:
> I've found that the one needs to
> check KVM_CAP_SYNC_MMU to
> safely write to the guest memory,
> but it doesn't seem to be documented
> well.
In fact, I wonder if its description in
the kernel doc is even correct:
---

When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
the memory region are automatically reflected into the guest.
---

But, after looking into the patches
that introduce that capability, I've
got an impression that it is only needed
if you mmap() something else to the
guest-shared region.

