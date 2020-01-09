Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7A135B14
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbgAIOJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:09:39 -0500
Received: from mail-qv1-f48.google.com ([209.85.219.48]:43753 "EHLO
        mail-qv1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgAIOJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:09:38 -0500
Received: by mail-qv1-f48.google.com with SMTP id p2so2971873qvo.10
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8QV7o4T8Kss98lTXcXIWTfPETRl9+zSe6fXYbXvevAE=;
        b=sVl1xfc92GZB4kAfdA95fiar9VBggNsLhQkfEKj9Q9LzM+VDUW6jhJ7k5c2KpTr6ol
         hiYaVAOdZsSn3BszeMPd7ftyMSSGOQYfe9sSxIVJx9P6m0XfXdU2PZSmOwi4l+I8kYSl
         YcgqGbVRQqYMBBqwa6gVj+E594Gt9alpWR9fp1ao57eHWQt5UTid3zYD7O+dUwTVCgdQ
         LeP38UTL8FmbB48k87CBC9E6z6JrFK7jRVs/qocaIREjmH0GOVWb4aqutThiPSZwFzze
         M9CQmSe5QCIYJVFT8wJ/VUFNYvbMxy7MqICG+rq7UBaML9G3MXPmyzdq/VXZNzTfxhQ7
         G0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8QV7o4T8Kss98lTXcXIWTfPETRl9+zSe6fXYbXvevAE=;
        b=QWGJugJjMa3I3Xa+N/mv1J5cscKjAOB6Nvze+3Sjt9FLjDP+hKb6bXEpU0htiGIb1K
         I4DzddSPYF48D536y4/wdsUdjPwvQ6EfMFZb9KC8HAczAfrez1yMTmRfLRm0ONY1B0sg
         u79pQ/S/q+Bf4NXzxw6ye4kk5MKc4CURabDKMCMiCN98WDzliDbVgG6lBZF1qPuzvHfj
         K0jHj3D2THY206JQhYD/GlwgQazKaw1cHL+XuELanvPwV/TI+BQAwu/7PWaXOfC7R0O1
         pl8iDel6XEKNBtnGfmn/6WtfyJCDuAYK0HwDonanYBxVShis8T4b27MSPZfZ5TZ6uyx7
         aMrw==
X-Gm-Message-State: APjAAAVTasFPOjhYrWlCD+Yzuc5SJr5egiItnrTAQ5/TIvKjCUXhjyjg
        u2WOq/RmyPjI3lGhsLswOutHtFPFs/dnDQPh69g=
X-Google-Smtp-Source: APXvYqx0MbY7XXKZZAhD1Uu31ENSh4p0PVArt3wjQGqvodtCD64KSLHLzPYXWV2rCkeCFoEjvHE+TDS5W3E5kMcQ2PM=
X-Received: by 2002:a05:6214:982:: with SMTP id dt2mr8622222qvb.174.1578578977711;
 Thu, 09 Jan 2020 06:09:37 -0800 (PST)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 9 Jan 2020 14:09:23 +0000
Message-ID: <CAJSP0QWysOZdp88vqJSQ-7J8tPk6OdaSL2WDLetJ5+YXsNH-UA@mail.gmail.com>
Subject: Call for Google Summer of Code 2020 project ideas
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        rust-vmm@lists.opendev.org
Cc:     =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Valentine Sinitsyn <valentine.sinitsyn@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Alexander Graf <agraf@csgraf.de>,
        Alistair Francis <alistair23@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe@mathieu-daude.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Igor Mammedov <imammedo@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU, KVM, and rust-vmm community,
QEMU will apply for Google Summer of Code
(https://summerofcode.withgoogle.com/) again this year.  This internship
program offers full-time, paid, 12-week, remote work internships for
contributing to open source.  QEMU can act as an umbrella organization
for KVM kernel and rust-vmm projects too.

Please post project ideas on the QEMU wiki before February 1st:
https://wiki.qemu.org/Google_Summer_of_Code_2020

Good project ideas are suitable for 12 weeks of full-time work by a
competent programmer who is not yet familiar with the codebase.  In
addition, they are:
 * Well-defined - the scope is clear
 * Self-contained - there are few dependencies
 * Uncontroversial - they are acceptable to the community
 * Incremental - they produce deliverables along the way

Feel free to post ideas even if you are unable to mentor the project.
It doesn't hurt to share the idea!

I will review project ideas and keep you up-to-date on QEMU's
acceptance into GSoC.

For more background on QEMU internships, check out this video:
https://www.youtube.com/watch?v=xNVCX7YMUL8

Stefan
