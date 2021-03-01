Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32770328DA4
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241179AbhCATO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 14:14:57 -0500
Received: from tr22g11a.aset.psu.edu ([128.118.146.136]:36698 "EHLO
        tr22n11a.aset.psu.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S241104AbhCATMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:38 -0500
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 14:12:37 EST
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        (authenticated bits=0)
        by tr22n11a.aset.psu.edu (8.15.2/8.15.2) with ESMTPSA id 121Imwcp031112
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 13:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=psu.edu;
        s=authsmtp_2020; t=1614624538;
        bh=0EV5Uzq4rBObwIoP2FCcdr8zhBHcFlQrLlX3bwO/NV8=;
        h=From:Date:Subject:To:Cc:From;
        b=bbMXepQOnrKkyP1ZqondJBabSjWvhO8QY8tIk6If+HyOkHK0FGrJ4q9ZM1q8hwQmr
         SKUxGOYgd79yKIONQNnM6rWq7/SGBBTWkaDHTDyqCujPUyv3CdoELrux6w19+bvF34
         wgK2KHrWcv1TWQsD5Bqr2RYnd2PF7Gy1POEir+ZOI+HaVX5u2VmMsWxmS2sdrHvGh7
         1Y5gX0cfbOyMJEUnJcJewQ9lp/iDw9OdDu8Z5bup6a9iJN8BbeF2A4Uf9OUNRP+C9l
         /G2a407s+yrdckBCAGRu8FpNKvSTBXgRV9IU2mmJRAVjUf6gPLLB6qTx2vkOSl2nDp
         zpCZtwB5Na7bg==
Received: by mail-oo1-f48.google.com with SMTP id i11so2690490ood.6
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 10:48:58 -0800 (PST)
X-Gm-Message-State: AOAM5307tGb0Nn8b3y8M4dfD1kCvgOybTsr1/kNRrriIbYWVH53GshDI
        wHeNOQxaWrHwQyYwc+mSl16Gc95IR/PQmJb/8yROKA==
X-Google-Smtp-Source: ABdhPJyRQuxfVF8616aZxoK8UojGWPlGb8YUV8+47PtPWdJq6fuoQpKzESfSGKYnXUrmoJ5+m9swZps7Wz2S7ny9lVU=
X-Received: by 2002:a4a:c592:: with SMTP id x18mr13553637oop.9.1614624537864;
 Mon, 01 Mar 2021 10:48:57 -0800 (PST)
MIME-Version: 1.0
From:   Aditya Basu <aditya.basu@psu.edu>
Date:   Mon, 1 Mar 2021 13:48:44 -0500
X-Gmail-Original-Message-ID: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
Message-ID: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
Subject: Processor to run Intel PT in a Guest VM
To:     kvm@vger.kernel.org
Cc:     "Jaeger, Trent Ray" <trj1@psu.edu>
Content-Type: text/plain; charset="UTF-8"
X-Milter: Strip-Plus
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
I am a PhD student at the Pennsylvania State University. For my
current project, I am trying to run Intel Processor Trace (PT) inside
a Guest VM. Specifically, I want to run KVM in the "Host-Guest mode"
as stated in the following bug:
https://bugzilla.kernel.org/show_bug.cgi?id=201565

However, I *cannot* find an Intel processor that supports this mode. I
have tried using Intel's i7-7700 and i7-9700k processors. Based on my
findings, the problem seems to be that bit 24 (PT_USE_GPA) of
MSR_IA32_VMX_PROCBASED_CTLS2 (high) is reported as 0 by the processor.
Hence, KVM seems to force pt_mode to 0 (or PT_MODE_HOST).

I would appreciate any pointers that someone might have regarding the
above. Specifically, I want to find an Intel processor that supports
running Intel PT in "Host-Guest mode".

Regards,

Aditya Basu
PhD Student in CSE
Pennsylvania State University
https://www.adityabasu.me/
