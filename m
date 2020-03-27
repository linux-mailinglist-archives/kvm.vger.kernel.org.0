Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA53194FD6
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 04:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0DzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 23:55:08 -0400
Received: from mail-vk1-f170.google.com ([209.85.221.170]:40846 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbgC0DzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 23:55:08 -0400
Received: by mail-vk1-f170.google.com with SMTP id k63so2334620vka.7
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 20:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OuEqGnF1mt535FVezKTG/eY0bIiexLnPOQeXaaLNdo0=;
        b=MsKMqP7NhOa9a0BH43TeJ5S1wvOYRRc8TtQ67N9b92K0YSDjGK1MWy0ANrN6NOLLIR
         LYp4zFGL/6uS5o6fcGDwqg9p9U/L/nUo7doHcKvEFcCT3wD74MEPE9Uzr0TyH0T3SrOJ
         7pvkWaRp3C0iNCTAKx9KFk2ulATQhR7K2xpPgn97b3sAR8T6htJlGT8WjwA9I2ZQMa2s
         ZUjtd34do1kJM0lrCs46ULFxLYZsGbmVbt/w15UVjtuE8Ckb8l+O5LYybKGcn3To/k4U
         yT3KuweI3ngqMi9vICGLoZVM85ZmOGG7zbD1Y75f0EcE4ymiSQOuCwKl0qqklCeyEOsi
         0JPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OuEqGnF1mt535FVezKTG/eY0bIiexLnPOQeXaaLNdo0=;
        b=Q5msFvwEmKAvtvlqt+BQH2npo88EJGImqz62gWfhrsYVt175bJvTiYK6jmrGDURpLU
         U3Bonyi4Ykqx2zwMW4YwrNuUY57zI8Gs03auCY/EYkNA4DYd3klR9gydAH2c8GqdW3dm
         KAUxJPuIQstDjAtpy7ikljwJ8xyapHsojqXLmBb3cBU05Zkza/AwM/m9ef8GlrCiVVVm
         sTP3p2XF0Uj+uvtx6TXeJIBLfXpfVwoHE/yirzPr8cbsLOET8ofzHCRffaPxuUH7pQrL
         WKAqsqPC/phzzCZQJNlKNvY9WrJtl4ZoXbRcm6lWMgdi9W9lr07RTm/b7gvOXoGOi20T
         u2qg==
X-Gm-Message-State: ANhLgQ09Zb96FIiXiWuvHOgjwTKmS772Nvx4YAlqZo0zeMEFSuOkLx/s
        HpS9ohd5ZaOQcQcxmckElGitAlwzAs+Wp6ZTRVG4Smpj
X-Google-Smtp-Source: ADFU+vtFxc3VyhdiYL1zOhl69Ulch58C4jwE1ENRhcxML3eNWJKF1W7XSdMbolcSIn3TorUB6P5tbkhhwE97SDK652w=
X-Received: by 2002:a1f:3210:: with SMTP id y16mr9524804vky.89.1585281307144;
 Thu, 26 Mar 2020 20:55:07 -0700 (PDT)
MIME-Version: 1.0
From:   xitler adole <zqyleo@gmail.com>
Date:   Fri, 27 Mar 2020 11:54:56 +0800
Message-ID: <CA+9FcC=PGZ76Tj5Sn1se-GkjpiQDUunKM0fzpdKRzvivTkiEqw@mail.gmail.com>
Subject: problems about EPT in kvm
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear developer:

I am facing confusing problems, there is no way for me to figure it
out, so I have to ask for help:

1.  I am using the <asm/kvm_host.h> <linux/kvm_host.h> for using kvm
in my module, but there are always some function undefined like
kvm_arch_mmu_notifier_invalidate_range. Are those functions not
visiable from outside?

2.   With the ept technology, If I use "alloc_page" inside the guest
virtual machine, and use "page_to_pfn" to get the pfn of the certain
page, Is the pfn I get the gfn or the pfn of the host machine?

3.  I want to modify the EPT table, so that I can make the gva point
to certain hpa just to share information between vm, Given the
condition that I can not modify the kvm code, Is that possible?

4. Do you have some technology about sharing memory between virtual
machine with some example code?

sorry for trouble, but I really find it hart to solve it only by myself.
