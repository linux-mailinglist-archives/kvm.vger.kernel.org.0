Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7BA273144
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgIURz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 13:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIURz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 13:55:26 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D30C061755
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 10:55:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i26so18954637ejb.12
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bCrE34MnbVdDowmPT6kMQGf/vb7ALGieKX82jIu37ZE=;
        b=U8hh+LRDUImDxn440ZLufEt7EyVObg0TINZQMA3BDQN1SZV/RXz8oRr/+H8hr04Moz
         j2pol5qC5Qr71y5mtMsIL/kjbkUauvSMJN1RdoveqbAaebahLSBAtl0ospcAk5439Rt+
         aBJ5cZ10MeDs4kDk3KifjbW/9iUGQdsa8WPGNr/OA4sN1xQ6vLim1UUMyEvavts83GbO
         E9MmSpVeCu6GWPnZC9d/PJMOmH9bb2L/Ubmh8YolLHdIe327jUQ5hcVGGKAaK8mNprgE
         /Ut7iUmtmju6ICT0vuhaHm/VI0NcxVwfYE0LSdagzZx+NgqlHgDtq8gDK0CjWN9qXVgw
         q7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bCrE34MnbVdDowmPT6kMQGf/vb7ALGieKX82jIu37ZE=;
        b=D+A+nSJjfhJXbSsnzDrgBm0MPNs14+l6KCDUs1wYY1vUhn7WG5AGVqlCq7lpCWlE9s
         3mSNrAyE7/bBTKAqQutkJXgRVe9haDZ2E2Mx8QFcQxLeLVuJlb91wfAZAp/opgNqI/1X
         12KJwYltSmHYSRku7UCkLdNMs3o/5Z0n1tHUQjM3mOybcfzanIEFfLd0m+aHgFhe7/tQ
         7ta1Pxh/8F6Lkxfjkn6sjznkI8YSJ3T+VSqCnlr0jXW+7sRdPxwXsPEFec1hkVTOEwuC
         ehWwk4kkwcOLcXF/Kpea0Ba1vzkYEBhC5/tDshZZuoHZIMugVoB5wVFpZZ+cur7coZb9
         Kfng==
X-Gm-Message-State: AOAM531VamBPGT98+Ts6o0VSceUMW2cUfQw12xIN1KDTMLyF4flQaMWq
        Q5Ni6JG+ORgKtwX9fiT/o+IDlBM3BaKWv25HYLMBhA==
X-Google-Smtp-Source: ABdhPJwwjJQ5uCRGyddt+SCfScS2eR9k3t+oeWDdMWf1OnG6OG/W4ekZAx6y8i3tqkzr69o7ZQTNC5UVDBpRW00rc7k=
X-Received: by 2002:a17:906:24d6:: with SMTP id f22mr627848ejb.85.1600710923790;
 Mon, 21 Sep 2020 10:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200918202750.10358-1-ehabkost@redhat.com>
In-Reply-To: <20200918202750.10358-1-ehabkost@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 21 Sep 2020 18:55:11 +0100
Message-ID: <CAFEAcA_AJcHaUjXdRH4jc5hkEq63d5ngap9vpp-yx4JsTDiQiA@mail.gmail.com>
Subject: Re: [PULL 0/4] x86 queue, 2020-09-18
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Sep 2020 at 21:28, Eduardo Habkost <ehabkost@redhat.com> wrote:
>
> The following changes since commit 053a4177817db307ec854356e95b5b350800a2=
16:
>
>   Merge remote-tracking branch 'remotes/philmd-gitlab/tags/fw_cfg-2020091=
8' into staging (2020-09-18 16:34:26 +0100)
>
> are available in the Git repository at:
>
>   git://github.com/ehabkost/qemu.git tags/x86-next-pull-request
>
> for you to fetch changes up to 31ada106d891f56f54d4234ce58c552bc2e734af:
>
>   i386: Simplify CPUID_8000_001E for AMD (2020-09-18 13:50:31 -0400)
>
> ----------------------------------------------------------------
> x86 queue, 2020-09-18
>
> Cleanups:
> * Correct the meaning of '0xffffffff' value for hv-spinlocks (Vitaly Kuzn=
etsov)
> * vmport: Drop superfluous parenthesis (Philippe Mathieu-Daud=C3=A9)
>
> Fixes:
> * Use generic APIC ID encoding code for EPYC (Babu Moger)
>
> ----------------------------------------------------------------


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/5.2
for any user-visible changes.

-- PMM
