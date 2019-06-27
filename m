Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB33357CF5
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 09:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfF0HPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 03:15:32 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:38478 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfF0HPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 03:15:32 -0400
Received: by mail-lf1-f53.google.com with SMTP id b11so827499lfa.5
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 00:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MoCioRtjfr92xRy8ifd6iLuVSMBFG72GsMszTDcLRjQ=;
        b=J6RwYKvFnh4WTeVauSiBEUHITQ1iGL/oAcqMh3B5jh/Vdf4ypIDZQPX++SU2bL8QKf
         e/lJoGOrtrFP3ZL/o03hRa4wWc/2uwN3V4obwsx7kanaFKVfV38+Xi2B+OtBpX97nM5O
         YMtmH4UJTV6A03ed2h745l5TPg43mmLaYC8zAlF2pIi6UitaE+hC9gyqZGqtC9gufsYw
         SGH5bCN/DONtdcDcwXs4oCYnOWBg1sYQOc4rwhL+OnAmJ9yUgxFPnSkqGzPyNhXrgiAy
         V+uBj+VaD8pKUKMLom0a82Pl7GghFNc0AGO7ikq+B1cCEJ0BDZVLPRJJmU0rqvP7Y5aH
         J0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MoCioRtjfr92xRy8ifd6iLuVSMBFG72GsMszTDcLRjQ=;
        b=TaS6r79gL25L2iIdPRx0eBQDFvQXmnq9n3pjDG4aMcnS30PR8t0pZBn4VT6q0tzR1c
         LxbAvJ45g4F5t2HOVhh4vafKWsLpgLkXpyxvZwN+f2F4X1E6IfVkqmPKpUI3ZCiqQTS/
         UpnbtFD7m0li1vMcfvX2Z08vGZOFViwYRmBIji+8T5CQVmgmztevx11KFCkrTDY22jfu
         iQJPke8k30nEoW4paANA+HkyksqflVF8STEAEPK2lvpZnjobFxjZRX0k/VribFTMHr2o
         +VqOytop1D8bP0jkt31zinznWtsHDtv/HBz4F6lkwVk+9Ct76q21gQ+lRxUTvJLytOiC
         0nvg==
X-Gm-Message-State: APjAAAWNTm2goPy4UYYvokeQt9Tojl89E6cp7e89C8YIJKZNG1CzTE9r
        87soAqzachtltYEJw8iZPe9LOjk/tw3qzhp9tBiUeKZRmZA=
X-Google-Smtp-Source: APXvYqxjC5gx6iYYr+9dmnowqsBqEqUCKA9f/AiJjGvyCuIe4fkCX6YLBwq7noHRsYAzHQh4Nscf8nskYXe4S8lzxlU=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr1200357lft.132.1561619729527;
 Thu, 27 Jun 2019 00:15:29 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 27 Jun 2019 12:45:18 +0530
Message-ID: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
Subject: Pre-required Kconfigs for kvm unit tests
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com, drjones@redhat.com,
        andre.przywara@arm.com, cdall@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We (kernel validation team) at Linaro running KVM unit tests [1] on arm64
and x86_64 architectures. Please share the Kernel configs fragments required
for better testing coverage.
Thank you.

[1] https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git

Best regards
Naresh Kamboju
