Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5003102FC
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 03:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBECwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 21:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhBECwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 21:52:06 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8786C0613D6
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 18:51:25 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bl23so9283027ejb.5
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 18:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:sender:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=hqf55dXwvcYwwL4sAkoYuOM6RPu6wxeec88n5sMRYiY=;
        b=euTAcRophe84gDkP6+HHF/E8ix/I08jiZh9nnruE9PMdocNO+3WTsAT1cP+vdaqVWG
         Z7aB8VSbn/ExpiHm7xEgpfrJyvdY5jY8DSNa+8M4tvYRpbGxRLcXUnR26fp/NWEc08C3
         9Hd5StQ7y/lH4WxAHz+OwyAgxVOG5NqbaLXuUAc5yFiEnbiVHaU69JJlFgTEaFIlAfgG
         50kO2k7+NTPVf+kSl2+3lU2w3xKcfkjs1hLvZMl2pdGX90P0uTYEsnflJQeLzV3kSXGh
         iRYqygMBAyJ8pwLh2dGzN3vDy/QTRwUvdOJ5m7Y4MU7z7VXzCjPzYOraqCfsrameXWxO
         kfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:sender:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=hqf55dXwvcYwwL4sAkoYuOM6RPu6wxeec88n5sMRYiY=;
        b=S2ntuB4WjixdOM1RehY37i/wwVCtYeVG20j1X78ly03W04g9sKkO5/157fyLt9ZWvb
         1d71XL5myS37xqh9A8rkY2pwfRRDgnn8HFr+GIIoVJPI+ecyvWC8jBA9Hsk2iih0fil5
         F4/HE/TZDYVweGN91WWwbGGHCZ0QnsD15U7VC7APRkY3FxE3lAHF0MUnKEZU0gFoLKqj
         kQiBoMtnWRks67L9BRbJ2UjiskuyxkLXprU48BhFS6Y6snP4X9L06bD8Ek8v2nDwMCFz
         X0VB+cLOYhw3skJ4Lc8GvDBk7pmH37PIe4CkrzfymRuvZBpaqOputsMisAPz3wAXjgbK
         rYRA==
X-Gm-Message-State: AOAM531QZGCgkDX7WYSUDVUfLl7dc1TOIyQx9HMVdm5CNFtZgzmAJJDI
        rODz3cmJOVWt2iKsyeFcDKc=
X-Google-Smtp-Source: ABdhPJzfKy9qpqAoNY/LxS2YanNATw7NEE0zvf1F7kVmxRJkRHIKdFsT9ML+nife5U/do/Qzw4aJ/Q==
X-Received: by 2002:a17:906:c0cd:: with SMTP id bn13mr1936457ejb.368.1612493484672;
        Thu, 04 Feb 2021 18:51:24 -0800 (PST)
Received: from [192.168.1.6] ([154.124.28.35])
        by smtp.gmail.com with ESMTPSA id r23sm3251673ejd.56.2021.02.04.18.51.20
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 04 Feb 2021 18:51:23 -0800 (PST)
Message-ID: <601cb2ab.1c69fb81.9923d.f342@mx.google.com>
Sender: Skylar Anderson <barr.markimmbaye@gmail.com>
From:   calantha camara <sgt.andersonskylar0@gmail.com>
X-Google-Original-From: calantha camara
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: hi dear
To:     Recipients <calantha@vger.kernel.org>
Date:   Fri, 05 Feb 2021 02:51:13 +0000
Reply-To: calanthac20@gmail.com
X-Mailer: cdcaafe51be8cdb99a1c85906066cad3d0e60e273541515a58395093a7c4e1f0eefb01d7fc4e6278706e9fb8c4dad093c3263345202970888b6b4d817f9e998c032e7d59
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do you speak Eglish
