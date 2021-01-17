Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECD2F9416
	for <lists+kvm@lfdr.de>; Sun, 17 Jan 2021 18:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbhAQRFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbhAQRFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 12:05:06 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EDC061573
        for <kvm@vger.kernel.org>; Sun, 17 Jan 2021 09:04:26 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id c124so11517477wma.5
        for <kvm@vger.kernel.org>; Sun, 17 Jan 2021 09:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=binghamton.edu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=K+XBdQTHsa5ZK7WHd+6/CSc+AwXcWY/dqE+orC2AWJ8=;
        b=VuxoyToo8nvQxNAK3ZtAZl5QdxAgeCw+j52DGAtyVB4UadioSB0zMAs66D1466gFlS
         t1OGZTbO9gorBSpxybC81RosFyyc1FWAZUhrbg0QRf/AB2hZ5sQy+ANMeVz5tRT/gFVO
         oHeyGa5N+PnR7uB+11DwA8eYVqCOagaOEJgWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=K+XBdQTHsa5ZK7WHd+6/CSc+AwXcWY/dqE+orC2AWJ8=;
        b=NkBh9pj0N5SiYglhfqsQrdjsyZz6Gm/fNZMCSVIZU2bqDhGFPe2en5HeKB5//bsWfP
         16q9SRWNAbSnxNr/F0EtgtiehzxPxBHacNwfmik4jHe3IVwdj4Xqleb+oIjOVZ5EbkEg
         0aKQe8bFd5PAGHyvwyY6T1rwI58OuSlkQbkAUOB3b8Z66SaWi5YL7LEn/ktuGXJwZF2H
         /2tWu70X/AWYkqVtGr+POjt77HyhK5EhnsTpmoK8DVZh1UCBiXEcy2rFczc4zWBEj0Kc
         iHvWlrQZQJmz4My/qnqV/8Kx/g0JmMFjwBP+KinMYQt2cBg0uZClB8KvId0sR/a1pFYY
         PXLA==
X-Gm-Message-State: AOAM530sqRWHdgz9BWwQbLh+WNbMhr/030w2IDYgCpLGa+pMRxt9RhmS
        lB/otoGcUqR4AI/EzmhS5sMCTdcZwQvJXmC83Y7D5rkVHw+bj1U9
X-Google-Smtp-Source: ABdhPJzXQWWEb8wW9ha9q5CSUpqvzeZVkXowSJ2CkWvOG7t/2bLWk+PGtVsmg7UMIyekbKR7rhqzQkqKvOGrA5yBxPU=
X-Received: by 2002:a7b:c04c:: with SMTP id u12mr17874369wmc.185.1610903064750;
 Sun, 17 Jan 2021 09:04:24 -0800 (PST)
MIME-Version: 1.0
From:   Roja Eswaran <reswara1@binghamton.edu>
Date:   Sun, 17 Jan 2021 12:04:14 -0500
Message-ID: <CAGTfD8bQ+F94yva3_W0yfMGP5bhajQf8WcrcsWrpcD4DLOGAEQ@mail.gmail.com>
Subject: VT-d Posted Interrupts
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I am looking forward to buying intel embedded SoC that supports VT-d
posted interrupts. There are a lot of intel processors used for
embedded systems that support VT-d.

Q1) Does VT-d support guarantees VT-d posted interrupts mechanism?

Q2) If not, what are the intel embedded processors that support VT-d
posted interrupt mechanism?

Thank you so much for your help in advance!

--
Thanks,
Roja
