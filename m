Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E70626A83
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 17:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiKLQTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 11:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKLQTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 11:19:50 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F1C746
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 08:19:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368994f4bc0so69817397b3.14
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 08:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVgOl8R94xnVJVUhd0tLg4IuhiKfwsABI7lZpXnZ5Z4=;
        b=ViAUQ8GEYFiP4NiHdO2g7rPGt5Ijm+D+r/OTFYhZThKYiMFg26WDiMo8CJiHr81CcU
         ryjzRMgA6UQkdgwkfj6hQm3q0b7z6l1EnnbRIJOIzTcG6QlqMuMR/d19PHGAtn7A814R
         8MV9OXS9z2b99YJEwb1rW3OkFpto1r/Li4/WlW3PotvwsZY1B19kWERX1QUNIKVPWf9z
         Zh63lDV1fCx2Du13Uw79+esdiMm3n8oWYKcGlkr1JL+mL50IQupC27N7wR0kQ32D8p4p
         UEAa/O2ZlJmIOGst1oDvmezjTCwTx5D7IaRuIyb4j0E4QqAQws1gDlrY7YKfnSrvoEvD
         S37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVgOl8R94xnVJVUhd0tLg4IuhiKfwsABI7lZpXnZ5Z4=;
        b=qn9QbQmueG0ED4tbr7kCYJNYBEGpGZU2xfVxX9jhU1/vVuklPgMw1zI+j6y3X1LAU/
         Li66BDFofq6O9AFUrl6wTXOW3nF9uxyho5+m6kOiF0Kd3BKel0eOvMd7g8jFULcBqKJy
         M29DsMV3zpEbTRBlmK5BLKmZFwbyKyoLAMcO7TutpDJY7GfNXK9qKima/LEOOYPs+SZT
         v8740T1FYZ+yYYCM3XynZu/mEx39lb9nSV5K/P/E2DLBHHlMKkpwU0l/5NLKgecVxvzg
         9oeqltGjAW7P4vaFI0d70rulx+vzDGsWptskSnuRAANB2wKTQQUHesqgkLajyPtpr0Ol
         +d2g==
X-Gm-Message-State: ACrzQf1pTRFZ9Qmy/lubcUbdHfezAHMbEdAw/PYRIB1/o73P2Q2iWlOt
        IxbCuT0r/Jd3sx6L+MPWjgjxHQPcMTcR
X-Google-Smtp-Source: AMsMyM5GjyPavtYMW5Pjbj+Tmxr9IhTS96KOzXvXYoihtVKvCnMAK9/p3eTrluDYKKz6HsYN7RGlRdh3oJF5
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:ab8d:5d30:aa81:9b7b])
 (user=dvyukov job=sendgmr) by 2002:a25:4e42:0:b0:6cf:e71a:818f with SMTP id
 c63-20020a254e42000000b006cfe71a818fmr47335327ybb.113.1668269988383; Sat, 12
 Nov 2022 08:19:48 -0800 (PST)
Date:   Sat, 12 Nov 2022 17:19:42 +0100
In-Reply-To: <200906190927.34831.borntraeger@de.ibm.com>
Mime-Version: 1.0
References: <200906190927.34831.borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112161942.3197544-1-dvyukov@google.com>
Subject: Re: [PATCH/RFC] virtio_test: A module for testing virtio via userspace
From:   Dmitry Vyukov <dvyukov@google.com>
To:     borntraeger@de.ibm.com, mst@redhat.com, jasowang@redhat.com
Cc:     adrian.schneider@de.ibm.com, ehrhardt@de.ibm.com,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, tim.hofmann@de.ibm.com,
        virtualization@lists.linux-foundation.org,
        syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The original email is from 2009, so I assume you don't have it in
your inboxes already. Here is the original email:

https://lore.kernel.org/all/200906190927.34831.borntraeger@de.ibm.com/

> This patch introduces a prototype for a virtio_test module. This module can
> be bound to any virtio device via sysfs bind/unbind feature, e.g:
> $ echo virtio1 > /sys/bus/virtio/drivers/virtio_rng/unbind
> $ modprobe virtio_test
>
> On probe this module registers to all virtqueues and creates a character
> device for every virtio device. (/dev/viotest<number>).
> The character device offers ioctls to allow a userspace application to submit
> virtio operations like addbuf, kick and getbuf. It also offers ioctls to get
> information about the device and to query the amount of occurred callbacks (or
> wait synchronously on callbacks).

As far as I understand the test driver was never merged and I can't find
any similar testing drivers. I am looking for a test module that allows
to create a transient virtio device that can be used to activate a virtio
driver are communicate with it as if from the host.

Does such thing exist already?
Or how are virtio transports/drivers tested/fuzzed nowadays?

Thanks
