Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE9461405
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 12:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhK2LqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 06:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbhK2LoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 06:44:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27DBC08EB25
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 02:50:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id np3so12407669pjb.4
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 02:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=gStws1BsQA7ChV+ZSOVJ9jMVkmG66GOwFLh7gMjyE60=;
        b=eFKqu69J/Xgt/F4Of/guUi6aEe+helelYIpfX+KeICrG5Rzdt8j+JFGrckSGfKG7iE
         hiSL6y4lrUxN2EaYjWpezUfjBviv9HrdLyI90giBnknKV0ftt6PyVGxpcwdDm1nIqxRI
         uyXgfysMboWLQEqnOf+FHDm8pkBKAJFXAndwBkhJFMR9Zc4gvvL4A8h6LTe/4p1rb9sS
         R0Rnxn4c+ub0ZdNoBPpyIzlZFEpXJmVpNAQY5l5TIkydTk4hXvGjzFX5CHREJy03x6jF
         JpQaDL3q/YWUymDyinOcTVmYfXub5uyx6uLyszaTsuzY2fhqiSYfQFWjKrPJVeyhjYG8
         7PAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gStws1BsQA7ChV+ZSOVJ9jMVkmG66GOwFLh7gMjyE60=;
        b=sfC7O83W3fr+fxXwJkO7hPgNOeyJoy75H1JZou/m6bNNTJUyK1WeMQelULd5fk6v4l
         a8GluF3kdE2AMF5U8NiiNtot+4en/YfLjb4Sb7O9up1Y2Ytiemf6XOtBSKvTW9zoQubS
         uMwA7hxSsB//kp7KnVIgh71CIK7kiuY1DGYWAndJMy7BPEvsBiHegEXX3R55qxCumsxa
         U4GZFf3s5whbc1kQ51U77nsv2T6Oma+6UkUENU5evK2TZCIRKRW6v/kRgws9OeI+eyED
         VdquGzmh+D+8GO6TZMfX8IOefeIY9TdAaylQtfWiE/Qu9Hdjb/rCJN7QUXAL89jHps4S
         qd5Q==
X-Gm-Message-State: AOAM5312KhdmPqpkGpP5Jrruq0FDzNWlwgK5HhlIYtDg9wcjbyTnbmFD
        AehJ6B9QfweXgBmgbwaqogt/IIXSfxbNiCE7Qzz6sIYf0xOIIg==
X-Google-Smtp-Source: ABdhPJyLpiR54bj8wEc5kd9QSP7ECQOnGRiHdUENcm6EwCf3Iqcexd5Y0gvCXhvAnpEEHG4be4ZYB+UN0h3MfIaDqdE=
X-Received: by 2002:a17:902:c20d:b0:142:21e:b1e8 with SMTP id
 13-20020a170902c20d00b00142021eb1e8mr57188517pll.27.1638183028486; Mon, 29
 Nov 2021 02:50:28 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 29 Nov 2021 10:50:17 +0000
Message-ID: <CAJSP0QWB=-CaLHFz_0qxrQpkAKgXVoki=bHjpWcFSR-bunqXSw@mail.gmail.com>
Subject: FOSDEM 2022 call for participation
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU and KVM community,
The FOSDEM free and open source software conference takes place on 5 &
6 February, 2022. It is free to attend and will be a virtual
conference.

You can now propose talks about QEMU or KVM at
https://penta.fosdem.org/submission/FOSDEM22. The deadline is December
28th.

If you have something fun or interesting to share, please go ahead and
submit a talk! Don't worry if this is your first talk or you are not a
regular contributor. If you still have doubts, email me and I can help
you with your proposal.

You may be interested in the following devrooms:

Emulator Development:
https://lists.fosdem.org/pipermail/fosdem/2021q4/003293.html

Virtualization and IaaS:
https://fosdem.org/2022/schedule/track/virtualization_and_iaas/

Retrocomputing:
https://fosdem.org/2022/schedule/track/retrocomputing/

FOSDEM website:
https://fosdem.org/2022/

I hope to see you at FOSDEM!

Stefan
