Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FDF87381
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405885AbfHIHxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:53:21 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39402 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405811AbfHIHxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:53:21 -0400
Received: by mail-lj1-f194.google.com with SMTP id v18so91185350ljh.6
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqqiFOTILayCWP92aAvbU7rZYbJzYJq2hFWqssnZfow=;
        b=nY8IF2S8A3L3Vuay9KDIsTtuFYPZeeklDr8dKII6lyiCdYnIje0PkqQD6KT7a8QWHU
         4FUv3TSucrFG98xqdbHX/fz/oYdj+KcmhxIwu8wKAtss6gbGo71dbqGgeWzg90cnNTLd
         daAxPNFCgGaViq4pcXkR0d3YXrO3QvcYqJLrUvOmGL94qGQ59Qp7Xv4ryXeG5I2fMJ+M
         RYNGCai1CaOieNia2IDUnrL3GIqtVgZc/GqiIUa3v0hJ0AeNWaNOq2pWS/Vu4XzMDeyG
         iuvJ/pFULgifhSM/dP60F1hCYQ+lhZ8YerE+lgkMmWp/Rib29Nj7JqNyN1P8uIoH04Es
         rtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqqiFOTILayCWP92aAvbU7rZYbJzYJq2hFWqssnZfow=;
        b=Tlaqrw25Qcu9I/CJieruJCUu5Cgg5SkdELF4eSABd+9e6oVdWTolYFmRq60/mjmSQa
         52nbdp0y7Fm5ebRQ6h4omE+vV57Ix7c7bQqANcdRA1HoV0K3jxirh2qZk1qny3ErVt4O
         9LCiM6QhnPWHMDce4sLo8plzEdiIkl1h4j8a8kR8ChhAV/YVo8VTKKMxEfTlru6h2VUh
         Kjuen2LCAH3iLgfZDD+s+wuuC7NoOcRsMgKV08Q8eyrlcdqTP961+WE4scz2cVLd+Snn
         4OfNU9oTsNFPGlwdwB/DpH49fCfX0N1XFrmqqJwFepky2Zxbv+emdXO2mIZETodjv9SY
         fyEQ==
X-Gm-Message-State: APjAAAW+nIuXde4aTxmJGc0ofpLUiZZvo1X7gTAx9X3ScIrviJVrG+IN
        lcd4PsnXDh46Y86L0PEIeI2JkwQjDcCv8+xRwWDhug==
X-Google-Smtp-Source: APXvYqxFQuHM3xYJAfyF6kQS8ItALDrQIiaCIj4v6PZYeYPQwqRCeQNlySydBHuBNvEurL5a+9vQM3W8O0NVFX8Igw4=
X-Received: by 2002:a2e:87d0:: with SMTP id v16mr10709810ljj.24.1565337199321;
 Fri, 09 Aug 2019 00:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190809072415.29305-1-naresh.kamboju@linaro.org> <0a0e0563-aba7-e59c-1fbd-547126d404ed@redhat.com>
In-Reply-To: <0a0e0563-aba7-e59c-1fbd-547126d404ed@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 9 Aug 2019 13:23:08 +0530
Message-ID: <CA+G9fYt4QPjHtyoZUfe_tv+uT6yybHehymuDWBFHL-QH3K-PxA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] selftests: kvm: Adding config fragments
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        sean.j.christopherson@intel.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        Dan Rue <dan.rue@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Aug 2019 at 13:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/08/19 09:24, Naresh Kamboju wrote:
> > selftests kvm all test cases need pre-required kernel config for the
> > tests to get pass.
> >
> > CONFIG_KVM=y
> >
> > The KVM tests are skipped without these configs:
> >
> >         dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> >         if (dev_fd < 0)
> >                 exit(KSFT_SKIP);
> >
> > Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > ---
> >  tools/testing/selftests/kvm/config | 1 +
> >  1 file changed, 1 insertion(+)
> >  create mode 100644 tools/testing/selftests/kvm/config
> >
> > diff --git a/tools/testing/selftests/kvm/config b/tools/testing/selftests/kvm/config
> > new file mode 100644
> > index 000000000000..14f90d8d6801
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/config
> > @@ -0,0 +1 @@
> > +CONFIG_KVM=y
> >
>
> I think this is more complicated without a real benefit, so I'll merge v2.

With the recent changes to 'kselftest-merge' nested configs also get merged.
Please refer this below commit for more details.
---
commit 6d3db46c8e331908775b0135dc7d2e5920bf6d90
Author: Dan Rue <dan.rue@linaro.org>
Date:   Mon May 20 10:16:14 2019 -0500

    kbuild: teach kselftest-merge to find nested config files

    Current implementation of kselftest-merge only finds config files that
    are one level deep using `$(srctree)/tools/testing/selftests/*/config`.

    Often, config files are added in nested directories, and do not get
    picked up by kselftest-merge.

    Use `find` to catch all config files under
    `$(srctree)/tools/testing/selftests` instead.

    Signed-off-by: Dan Rue <dan.rue@linaro.org>
    Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

- Naresh
