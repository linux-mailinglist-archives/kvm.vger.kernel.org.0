Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE8376FB0
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGZRXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 13:23:05 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:39307 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfGZRXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 13:23:05 -0400
Received: by mail-io1-f50.google.com with SMTP id f4so106369850ioh.6
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 10:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=lgKH17VlfO22ZhiUfZF9CCv2dqmR90O0SvY7KEkhTWg=;
        b=Gln98UtavXjK4leHQutUhWbDfkY03xDi9SJLUR6aYkKPBeHE89a1HDaXNUOccXRUcl
         ZhSxSdJBtKZ6dLhSwoqZ3ecORYPYS4dBaR4buexppzGdXF6QdPVcq2YRieVtFjn/eqnU
         iEOyimVULCA4l/8o5qFtoBo6gDbuxV7935L45xMb6vyzINXHezEDqA1qstwhoWG2hLqU
         VxxxkVFpeb2qm10GEgNhCBG5nyakKuCZ8G6E9Bei0Dm62b+6EZeiLOxrRvqLdwsjBt6M
         IdNmHJLryVOzD/z7hBT7AIQT04OJbGY2PJSRxe9L4GTs/sssGKp9wfzlFXaYYKE74Ho3
         n2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lgKH17VlfO22ZhiUfZF9CCv2dqmR90O0SvY7KEkhTWg=;
        b=A/gUM1z8zjlER4LG3jrdcjxpOh+mYXK0DuDUnuO2bmklwyoF8r0WSPQOKGz0fDH95v
         sAljMOH4mAS0v/Kb5fFUYNTUKNQDdr52rwzv/ecVO9PYWjTKIBMfZLUlezmPSE83UMoB
         8NRdmWmk4hPrXUgEts2uFeEpLt3pjVPtdwoEigijAzD09ZFPc6MCJHU/DpnGUAZEn+mY
         WQKNcTpGF8Dl/cD3eS7dw5jLnR9YmkJiueW4zxKPrUzK+uSPEC2tYdCQEOmhNiVvaSmk
         L6ZlweJLaSkd4CVaJHtZ7zlWUwPD9ZSAW0rJTcRGnQ31aTfulB1FDRM3S/ai7Hs20ksG
         UU0Q==
X-Gm-Message-State: APjAAAV+HHawENJvnTAyVqge9PBUli97oZ3AUHC1Y5eK6V8AIdupEFyd
        jkTpGhL7KyA1z1IEdC/5tVMMPs7CgCyiXV1BUcrCkygsJXRiCA==
X-Google-Smtp-Source: APXvYqzDcL1nd7UnRTgkj/GDw2zab47wN+Mg1Fv+qPRrnxGMl1e6o6uYbEQ34ct5L4sIa+b9bFbsNJ/WvTez2V69b/M=
X-Received: by 2002:a6b:6310:: with SMTP id p16mr89477631iog.118.1564161783915;
 Fri, 26 Jul 2019 10:23:03 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 26 Jul 2019 10:22:53 -0700
Message-ID: <CALMp9eSYQGy4ZEXtO92zr-NG5cvDdA4qK+PzqbzwFP3TU-=hGg@mail.gmail.com>
Subject: Intercepting MOV to/from CR3 when using EPT
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using EPT, why does kvm intercept MOV to/from CR3 when paging is
disabled in the guest? It doesn't seem necessary to me, but perhaps I
am missing something.

I'm referring to this code in ept_update_paging_mode_cr0():

exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
CPU_BASED_CR3_STORE_EXITING);

Thanks!
