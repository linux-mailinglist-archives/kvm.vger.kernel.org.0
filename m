Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58ABAE338A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502364AbfJXNLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:11:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42024 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfJXNLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id c16so8119348plz.9
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xo0WkUjWDnE/H4X4N+cQZqf98SENyk0SBmAI3sBPGIg=;
        b=t/LA5FmdSWO2uLJcRujTTOOL5Hdq4SSWNNzt8gtbUWoxM6Wsx5tjOqE1izAXivO0Ia
         AgBOnEXQDAWeIqWePIuwWicCQbMmdWgCUgf1Kf2Lc1UZeDBLyXaf1AvQU3D2yMVaUuAv
         OBi7x+7VaZjtscab1aWVmwprqqv5CNubZTit1UUJ+JmvUHKvn1wFiTszs0JauF//be0+
         g/ppiwm/nlPZ141Zc5VJWQUcGu4YM/wzRRzGmeQsFB88P9FJ7Xn5fiZfSuPsLf0v8fEW
         BlW1Cm5bvXgD6AP/CydfVi4ccRS1AETvzKQs3ZofIEK0GOtFu0LtgzTPc0CMPg4H2g1U
         uxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xo0WkUjWDnE/H4X4N+cQZqf98SENyk0SBmAI3sBPGIg=;
        b=P0s5zm3akmna+4V/sWc3/TeVIE2XXsLlwwEjZ53YsxAUAsbZn/eri/5zvhLSB6tT0V
         bTqjuMRNfr1eP3MZE82fE2R36BvY4AtU716QlwI4NdTNNBiBFDWi4iWlw9ep5VJlMrTW
         1MOM1xwKvSxpofbQVQDooJe0/ijbaeSSsWoQzrDrCFWqfXByondUs4Bvrl3AJtZYRWdh
         JMPHQBPw+rszLdlPQ30FQK/h0mLq9D11AZq51BIF87gExLn1GV9ezVcwRrhq0tLr2CX4
         Bj5CVkFv1+XjDRYUd3k8d7UikfrrVTSzJQEKPfap9C4snmdkoOmzt5jqhwcIoQT+KhqK
         kRog==
X-Gm-Message-State: APjAAAUmy94dsIJjoTXsK12vqx/sLmR5QprO0O70sz/Dw7pHYokuUyYu
        NRJD6afhKdKjZImjSORqgPIeChMQrZ4U4uGRmEL4wQ==
X-Google-Smtp-Source: APXvYqyy5qlLBB9opQM1zjilQUiju2zRB6OI/DofEJGzghw2O2H+RqiQobefmx7Itav5M1rRYtcWroC7W5dIZdO1IdA=
X-Received: by 2002:a17:902:9696:: with SMTP id n22mr14759199plp.252.1571922666109;
 Thu, 24 Oct 2019 06:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <df26802a60c09d155291c2abbcb51e4530eb19d7.1571762488.git.andreyknvl@google.com>
 <201910240119.fyrtJQLH%lkp@intel.com>
In-Reply-To: <201910240119.fyrtJQLH%lkp@intel.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 24 Oct 2019 15:10:54 +0200
Message-ID: <CAAeHK+zeY2YLkf8+T2PQ6Q288XYphCnj6bP7EKdsfePAXrS4mw@mail.gmail.com>
Subject: Re: [PATCH 1/3] kcov: remote coverage support
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 7:20 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Andrey,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [cannot apply to v5.4-rc4 next-20191023]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Andrey-Konovalov/kcov-collect-coverage-from-usb-and-vhost/20191023-185245
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 3b7c59a1950c75f2c0152e5a9cd77675b09233d6
> config: arm-allmodconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    kernel/kcov.o: In function `kcov_remote_stop':
> >> kcov.c:(.text+0x1094): undefined reference to `__aeabi_uldivmod'
>    kcov.c:(.text+0x1144): undefined reference to `__aeabi_uldivmod'

OK, looks like arm32 can't divide 64 bit integers. Will fix in v3.

>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
