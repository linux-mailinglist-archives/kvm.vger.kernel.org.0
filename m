Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20253309BDA
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhAaL6s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 31 Jan 2021 06:58:48 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:40865 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhAaL55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:57:57 -0500
Received: by mail-oi1-f179.google.com with SMTP id k142so1086689oib.7
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:57:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVkInRJxpduhbRvqa9xcBthpuPzf7AjKpZhjK7Cpckg=;
        b=QE4trR5xaSfbTWwgkwEhLofJ88NlyWLNFu15JiEj+b11V2aQuntFWL4HitAiLx2OEb
         W7f5ha9uVW9qwzk+clIE7rcn/OCC82bk0I1jts5HmXb2id84cUQE/XYn7LuH+3v6Zuni
         ikLURlYPFKhtdetguZ1ZwthV9CoijpreZLWq0UTtOi367wHvmgW/5xLmaLle0RW3osxb
         ci/rOQC4LsufpZbNbG2+gGGD+IjivP9hH1xWvmZpWwD2uXb75nrc0gofmwdimubzx4TR
         5eacczskM2tVWLngIMB+HU07aOssH4+Geq0+EchbpflOq3nzAxq5Je6iA/hGKJOVjEGH
         fdQg==
X-Gm-Message-State: AOAM532Za1XHYuPrRoLYlPSXPKHvS0jrJn7E3IN6hOt890h90LRntGhI
        pXFwZYpguEXR2aMaWgZVj8ev+Kwl4H1mvYBR4cM=
X-Google-Smtp-Source: ABdhPJzTsVYWTiFYHJJoplW61B8aLyILK891rvibXykh/sCNgQ3gvSZtbxkhWSacPEQCBANMrvfh/48uBylcMZS22go=
X-Received: by 2002:aca:f1d4:: with SMTP id p203mr7974934oih.46.1612094235899;
 Sun, 31 Jan 2021 03:57:15 -0800 (PST)
MIME-Version: 1.0
References: <20210131115022.242570-1-f4bug@amsat.org> <20210131115022.242570-12-f4bug@amsat.org>
In-Reply-To: <20210131115022.242570-12-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Sun, 31 Jan 2021 12:57:04 +0100
Message-ID: <CAAdtpL4kPsFE3PuxkdE-Pmc+AqYiXFOEhdBTpvyBckZ1BJMHtQ@mail.gmail.com>
Subject: Re: [PATCH v6 11/11] .travis.yml: Add a KVM-only Aarch64 job
To:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Block layer core" <qemu-block@nongnu.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm <kvm@vger.kernel.org>, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 31, 2021 at 12:51 PM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>
> From: Philippe Mathieu-Daudé <philmd@redhat.com>
>
> Add a job to build QEMU on Aarch64 with TCG disabled, so
> this configuration won't bitrot over time.
>
> We explicitly modify default-configs/aarch64-softmmu.mak to
> only select the 'virt' and 'SBSA-REF' machines.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> Job ran for 7 min 30 sec
> https://travis-ci.org/github/philmd/qemu/jobs/731428859

BTW I added this patch for completeness but I couldn't test it again
as I don't have anymore Travis-CI credit. I however tested it on a similar
Ubuntu Aarch64 host.
