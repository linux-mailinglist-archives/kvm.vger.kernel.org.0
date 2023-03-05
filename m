Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA85D6AB170
	for <lists+kvm@lfdr.de>; Sun,  5 Mar 2023 17:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCEQwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Mar 2023 11:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCEQwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Mar 2023 11:52:38 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58CDCDC3
        for <kvm@vger.kernel.org>; Sun,  5 Mar 2023 08:52:37 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x3so29229813edb.10
        for <kvm@vger.kernel.org>; Sun, 05 Mar 2023 08:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ge1WTr2yS2AL+JZ8zp/0KvvQMq7DOSFberU+bBdXxxk=;
        b=ifyDmzR8dM3mb+XNHNzy2CWoiDStOdXU2jPhA5qA5igt7YbTu3CZemwuTqif+sJXLN
         NRrEv7wOoUKusnvWdKEJARiksqA1gyS+4Re4egMCGcopcq9LzkI1dPSl0FUhCGOnJzar
         zaV88+yaKqeC9KDFqctAmDln72AWxTrimw/XMzqqDV1Wbz7dZLePbTelYv5f8tJHlwN2
         TlO3RLadJFAMhB3o8A974CAeDBXXgEWsl5mEl065GBaNzfqaQv1JGVEw7vv3HPTM9ZsS
         pCjqraErpodK0t8MXh44Mx2yZ/BJx43Zl9qA/gM0r6zQvfTtvsivwvfTPl9HPjuRBM9H
         y54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ge1WTr2yS2AL+JZ8zp/0KvvQMq7DOSFberU+bBdXxxk=;
        b=qZpByEVaeSkI+5o2NprHSpkjN7NsdZsdi6FVa+0xtB8+tSH4q/5o8a4x+flQ13uVeG
         FXUEbnD4UTikyFHxgyAzrs2xyFGRKS+/E+Hftq1o8YwOHrr/W/Z2VpocToaYKQygKDDC
         Bl2UTOTQatR6aCz8FirF7aBv7tHtvTSeGSDhcmeFrE3wu2Bz4MvKperk9WfSaW2CgFid
         6TXpanVsdlFBxbTWMviNrs6XItzLDnXcrsnt2n+h6iNaJtT6nf3qRBzLeAJrcOu0ZxdL
         AXsrBUdlCbSKsAaZV+0JFS3mPq4u9IyMzZ98oJvLrlYaxNN5sGHXfKS+19C5mGkwZFnq
         9e/Q==
X-Gm-Message-State: AO0yUKV3cXa1Ie4GLIP2WisRw/XC03SGuThFev1GdWHawVgHfvjTnZ7I
        jvJFg1KFZyzXx+ul3U0lYFhrHe2Ogu9EXwBpZAqWsDAMYutUIQ==
X-Google-Smtp-Source: AK7set+5mlqD1LyMacjPZxEd5bjsc8YmOfvUTUbqGytH8s/Rt9c3nwCBSPX49ByFTeqYvhLpaHXA5J/ruBBdKlXqpIo=
X-Received: by 2002:a17:906:310d:b0:87b:d50f:6981 with SMTP id
 13-20020a170906310d00b0087bd50f6981mr3354860ejx.14.1678035156122; Sun, 05 Mar
 2023 08:52:36 -0800 (PST)
MIME-Version: 1.0
From:   "David N." <taact135200@gmail.com>
Date:   Sun, 5 Mar 2023 11:52:25 -0500
Message-ID: <CACQapsBJxdH2SpwuSgD1rKhqymw9vAME+BdzLO82a=hV2V5=Lw@mail.gmail.com>
Subject: Bug: Intel Arc A-Series GPUs VFIO pass through no video out
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm not entirely sure if this is the right place for this. I'd
previously opened a report on the Intel GPU Community Issue Tracker
and they suggested I open a bug for the VM software I'm using.

The issue:

If you try to pass through an Intel Arc A770 LE (or any other Arc
A-series GPU) from a Linux host to a Windows guest, you do not get any
video out or detected monitors on the Arc card. But, the card is being
picked up by the drivers and will run whatever workload you throw at
it, there's just no picture on the monitor. The monitor detects
something on VM boot, but nothing other than a black screen is
visible.

There is a "fix" discovered by taoj17v on reddit: Unplug the display
cables from the GPU, boot the host and then the VM. Once the guest has
finished booting, connect the cables.

He also points out that it is likely a bug in the firmware.
