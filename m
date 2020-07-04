Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617632144A0
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 11:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgGDJJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 05:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGDJJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 05:09:54 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2948AC061794
        for <kvm@vger.kernel.org>; Sat,  4 Jul 2020 02:09:54 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f18so36432571wml.3
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 02:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zmPyzSZ4jwwesHsKEURbETDCROe4ArINyrDqXDoheMY=;
        b=pBWtb6MnTVeWS/fQMF0cw3ZGqKtUNdGZgv+qJ9orBvpP/kMBd2jQbeauRED2P/H6z2
         qDyT0d4BqyPADJaYP6OD414h5GpHBKCLdZ12knPaclzG1oGGyd/grJsWYR4pR3irz/ei
         mQRuSlTz3xDMbkFpkzkMYA9PBrfaxKo3cZYDH0PaBsJ9nfulONMa5mkpYl8WPYOVCMSm
         NJ1VD1Jn4qVPhH8sRzZycqt3YnFLlLXsxVYlwBMuZDQ4M/eUGlP+tmtmFsMjW9PJIEK7
         BTa2larGOI+GhSWdib7+HJ72flGwZIqwkIhHPbHHQRJwAx+4oC4pNYLi4WNOPFxJVaGu
         Yigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zmPyzSZ4jwwesHsKEURbETDCROe4ArINyrDqXDoheMY=;
        b=GV+sQcIuldc/SAEtWySEpDWROZr3c9Gmior8dAkZ7gast06m11rHgxfbn2p8blVGPr
         MGzMOW8V2jl2ften1ncYZ5y4kKze33aJ5dinGimm1Z6Bh7jbtJONAWnAhzrSD3agjv7k
         WkgMHBiQXvSTqyojlMkx6DcvpvCPWaYzQIOLo6Y50Wg9Us8etapxwECMJn51QX4YhM0w
         i8Lm8uR6F59hSIygcoa69lH75l1/mN+8R1StdELTKR0rOG9UFC/GclF7PLGR7dBfCgy7
         77xAZEHRIgbd/Pyb5w5t18Xj3Du+IxWBAjvgJNtzAlo0Xi9Q3MV5hhCtAo6X/3x0RaTC
         M1RQ==
X-Gm-Message-State: AOAM53025F0AoPa+xGbGJsDV+HAzc/lWOEk8sYwFcGTHF6jatCbUUDUS
        7XEvDXpEIBAUzKT8BeNUjL2kwJGDGQVOpBejOh2/uA==
X-Google-Smtp-Source: ABdhPJzOvMqSd4xpuJgiCdh+/xyK5ViKRuWcbTg2Kcp6WpcoTUz1rP/uXLPIT3z/w0Hyu+iMBXBFqYj09LgJmRwfvU0=
X-Received: by 2002:a7b:c84d:: with SMTP id c13mr40205192wml.170.1593853791689;
 Sat, 04 Jul 2020 02:09:51 -0700 (PDT)
MIME-Version: 1.0
From:   Jidong Xiao <jidong.xiao@gmail.com>
Date:   Sat, 4 Jul 2020 03:09:41 -0600
Message-ID: <CAG4AFWZ3zd1LEZa6RHbUYyMsT8vGzOJSmw9G0CK-pnpRLv6Hfw@mail.gmail.com>
Subject: KVM upcall questions
To:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo and all,

Do KVM support upcalls, which enable the hypervisor to make requests
to the guest? Or if I want to add one more upcall by myself, which
part of the KVM code should I examine? I know Xen has implemented
upcalls, but I can't find any documents about upcalls in KVM.

Thank you!

-Jidong
