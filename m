Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9586D1A3BF0
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgDIVaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:30:01 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:45759 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgDIVaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:30:01 -0400
Received: by mail-pg1-f170.google.com with SMTP id w11so66004pga.12
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 14:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2haAfgLKYBB+Ck2GeXIDF02e3G20o5okdEJ4GVkyKHY=;
        b=tlTPjD5qX1MtNLUbFTxtsi76wOwwBHkm6mxp4SXIuDhluz+iSqnUtFTOx6AzLoXsQo
         Zgj+ehZUI2jX9tH8O/JCxL2ihIsf4moF15t6fRw8P5Ym4pTdc146gWvpNO9nY16SQWn8
         7yUSA52DM1+fEKL3SgUdcz2KZnx4ioc+THh/3lJw63BpVDqacYiIN0wrelbj4voix8vu
         j/+BvvW3H9y8/oX1rGFK6y56BGFUK4D/f6CpeFukUj6m1UxRcPJoksN6cnSHSegwqmhU
         bcYeBg1xzLfO3LlGy2INslidV9R96grhRuj1Mfqmmpd5ML2y6Yekp6pRFR00T/4jQMu/
         8dAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2haAfgLKYBB+Ck2GeXIDF02e3G20o5okdEJ4GVkyKHY=;
        b=gC1v/9PqbExBseFEb5HIQ9u4a4xY7mWn4JxG82RHRcPGqceH+wggqlMXCVq9JgQ2lX
         5WuiuXAohu2Ov0ed5hYdZ8yrHqJ4D2llWRgpJ/Q89QI7OsHPFKoaRTEervBqA0MtnMte
         m94FLjgO1pk3pM/roH1flpr+iddCENFyn1sr4OPwfPG3pHrow5O47rRjRBoku4q7Xebh
         lfasO4AjlCOg2wmFCLaEwIOamCVrwYis1rpXLD4yuJ4UEMiTvnHRs5cZuY6kzbavj0DS
         dEPQB/+hhgeOzt9Z1rqbzFweHfyk2ZNE91145m9XHgoBah7Cz+hP+08+0hTSY+x/AezN
         7ybQ==
X-Gm-Message-State: AGi0Pub1PLgotM2tlHpTSAEpwrEERRPnhwAkLg775wRxPLOPTZfM0ema
        Rody0BfF0EAZjL4ZThn82LKiUTvk/Pm4U2f/A7WlmFGITms=
X-Google-Smtp-Source: APiQypJnWgQFTPi8xfW1m4+qOKK0mlo6V+P1r1kcFFpIZEOaf7lUiz0lOQSrJbDk84F/UXmMTZCTwebVzQC9m/zitJE=
X-Received: by 2002:a63:ae04:: with SMTP id q4mr1333418pgf.373.1586467799380;
 Thu, 09 Apr 2020 14:29:59 -0700 (PDT)
MIME-Version: 1.0
From:   Javier Romero <xavinux@gmail.com>
Date:   Thu, 9 Apr 2020 18:29:47 -0300
Message-ID: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
Subject: Contribution to KVM.
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

 My name is Javier, live in Argentina and work as a cloud engineer.

Have been working with Linux servers for the ast 10 years in an
Internet Service Provider and I'm interested in contributing to KVM
maybe with testing as a start point.

If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at disposal.

Thanks for your kind attention.

Best Regards,



Javier Romero
