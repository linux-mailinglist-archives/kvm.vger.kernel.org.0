Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1CF3E19E7
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbhHEREV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbhHEREU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 13:04:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FD9C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 10:04:05 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id oz16so10711035ejc.7
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BvHm6jFFGAa+HyzevSS5ZKKmSsAvnJ39qhbHYBP9kr4=;
        b=oPuBgySPKDXh+TPTJJ85wWNKCwZy4yb+jZcI5xdBHOhfooW+gDNTry5Eho0frDj9pD
         ym2b9SUzP89OBwaGRU5P98MdX09qbKwGs1Gl5aRlDOIupQx1k/8gzDzdnxEZc3O+vqaH
         56PUyLpWhdmqR6abs6gNKjcC907U7/2Gr7uNp75YzQHlxQ/s+j1RUKMpK29SATAe5xND
         BiDRqqqrmxpx/djnV0ufqXrT5KJozY+SLKzyvAwicYKguZNpmH5kdnNR9QPeFaA60/qG
         RT3rNvgWTzBjjd6c827XCzhhSkiBBie6U/RqKXtR9eaQDCROblOWTaLpjxsGMPNyPJiG
         LM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BvHm6jFFGAa+HyzevSS5ZKKmSsAvnJ39qhbHYBP9kr4=;
        b=VJz+b4HfxCnMpJrke/3nIyuzHi1Slz702doLR/tlOu/znGS7AvqoLeqMCgzdSwQCMz
         an+P9GjjP6JlxB1OXPSrQ1Rg1R7nCAimXQjmJj9BB3VqKRkE+b992W1b4iaA3+DsT7Oc
         8yRM3vXwLXsE8SomGhNAaqFLpqnLzukrP9lqSQAOY+UaXUkOgGLur0vQmCv8/a1opGZa
         poz3xMbw13evQRHSDYLyk0+HNT3YJTTlvme2hUXKPXBKLZY0meLMhi4iwHc7ixBsOccA
         rN9lkyISSg3c0WlBfEp1wr9f+P8y/VmgDsUdVuZFmEr3MZE9GQJtufNc53YC1ylXZD4r
         JMkQ==
X-Gm-Message-State: AOAM533p1XZLcGV+Rb3qlTGsD+ttx4HcYWA/yCQWlBx1Aogqc9Lisx3x
        97pr5ZFMJvgZ+JflIoyy5/0Fw3j8zD3uIEG9PL3IOVkrAE5oyw==
X-Google-Smtp-Source: ABdhPJydbtRJkCp9pU269D8/geqElc+KkMZa6UMGNiCys1/0IkIJG9oOoeYLB70riMlTNa6l42iJaZ5wVV4tYO/e5vg=
X-Received: by 2002:a17:906:e13:: with SMTP id l19mr5870622eji.63.1628183043346;
 Thu, 05 Aug 2021 10:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7Ssm8BEKjpt7PxwX7aPuCwtBjRoVx8dR3YCB6y=fQsHOOhgg@mail.gmail.com>
In-Reply-To: <CAD7Ssm8BEKjpt7PxwX7aPuCwtBjRoVx8dR3YCB6y=fQsHOOhgg@mail.gmail.com>
From:   Kaushal Shriyan <kaushalshriyan@gmail.com>
Date:   Thu, 5 Aug 2021 22:33:51 +0530
Message-ID: <CAD7Ssm9Jmg_yVHD7=ssAW+2vXEaoCBjKcw6dn6kN5gDKg3KxGg@mail.gmail.com>
Subject: Re: unable to connect to the guest VM instance running Ubuntu 18.04
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 4, 2021 at 10:31 PM Kaushal Shriyan
<kaushalshriyan@gmail.com> wrote:
>
> Hi,
>
> #cat /etc/redhat-release
> CentOS Linux release 7.8.2003 (Core)
> #virt-install --version
> 1.5.0
> #virt-install -n snipeitassetmanagementubuntu --ram 8096 --vcpus 2
> --virt-type kvm --os-type linux --os-variant ubuntu18.04 --graphics
> none --location
> 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/'
> --extra-args "console=tty0 console=ttyS0,115200n8" --disk
> path=/linuxkvmguestosdisk/snipeitassetmanagementubuntu.img,size=30
>
> I am unable to connect to the guest VM instance. Any clue and i look
> forward to hearing from you. Thanks in advance.
>
> Best Regards,
>
> Kaushal

Hi,

$virsh console snipeitassetmanagemeubuntu
Connected to domain snipeitassetmanagementubuntu
Escape character is ^]

The screen is frozen. To connect it to the VM guest instance, I need
to configure the static private IP for this VM instance.

Please suggest. Thanks in advance.

Best Regards,

Kaushal
