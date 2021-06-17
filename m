Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDB63ABF3B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhFQXRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhFQXRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:17:18 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAECC061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:15:09 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r7so5957667edv.12
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XTNgvtHJoY4wVIhPcHx8miXZZsGDL4D6mRMoZQTewfM=;
        b=jlndgXimsTzkbh55rmw2/5ASfe0+XiRhSreLXXpWaHOkN8P1HRI/mfvup0BkOjmDKP
         mC2OxQvivVSPRY/KcQfeHfQRLPUGlcO+0+YqfWvy/Igm1S5PtMuYV/lvxGGsvqi2qqLK
         u/vq8qELe7snicxT/qesZWDh4oLS7pp5Y3ZYMJGRAlTY8MszQEkx6h5Eu/4nad8Cpo/G
         o2ziGecNDSKNB3ZRsrdnLumUft3FYGxGxlulHB3hSjMHSEfYbV+FIPO46GwMLLs/5nME
         nbULzW6s/o65tB9k+HpYI8ZGqljazLylq7pkn3eyMNOZ2Ysk+X+07Y+Vk9EqeZRMM+by
         LyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XTNgvtHJoY4wVIhPcHx8miXZZsGDL4D6mRMoZQTewfM=;
        b=rD6xweSZBO40fi5qvBDa6yS7zQsetl0EZCpVu1juRGtx0EpIhTbDUGYIxtBz3Swt18
         38CF3VsPqdyM/Yu8wxhaAdaJYwtn0VhGzsNGc5vQ3ybczTEvdhtcG2SV442w+0kTAhUT
         Mz9lldLbza77Udjf5g9OaBlN5yoxhf4Bx8HoiaPiVeIf5o1I6CvaaJaE8XjVAeOAJnRi
         mdR+5J7T5LC38OF240jbsRhtw2MpI8L4gA3ChVgL0teCKhzYBYjaWuWrVdQFE0CMVbWS
         1N3jYFYUB4pIRFFoYoz6fEjUY2ihrXiXYKQcjLCy/FL0hHyL1P7Ywq8mnpkpJ3V2gfw0
         5lUw==
X-Gm-Message-State: AOAM532zmgFypzQSSV6RofqhJVYzRLwn9FBH1G5S9dpEut3vOT/2mgUY
        +VANWsU/pxTiRkNP3ktynIaLsNtE4S37kVOcpfJFA88WXb0=
X-Google-Smtp-Source: ABdhPJyX05d2WymE+koI3ziY7UkMt5MJuoQsj1Vm98Oe/UmHGlpa8MubdKQu6nRRV1xcz7iwM10GWOxQuld/4w6nBxo=
X-Received: by 2002:a50:b2c5:: with SMTP id p63mr999148edd.5.1623971706948;
 Thu, 17 Jun 2021 16:15:06 -0700 (PDT)
MIME-Version: 1.0
From:   Kallol Biswas <kallolkernel@gmail.com>
Date:   Thu, 17 Jun 2021 16:14:55 -0700
Message-ID: <CANcxk1g0K6TFLwiOzTCAuxzeMYTZ4e90+FLtLL_sS9D1QEnH8g@mail.gmail.com>
Subject: vmcs_config.size is 1024 but field offsets are larger
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
    I am trying to understand the vmcs manipulation code.

It seems that we allocate 4096 bytes for vmcs, but the field offsets
are much larger.

crash> p vmcs_config.size
$15 = 1024

vmx.h:
HOST_RIP                        = 0x00006c16
GUEST_RFLAGS                    = 0x00006820

vmx.c:
flags = vmcs_readl(GUEST_RFLAGS);

I must have a gap in understanding. Maybe I should read the intel
manual carefully.

Any response?

Thank you,
