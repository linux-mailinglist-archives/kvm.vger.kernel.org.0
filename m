Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AE4397402
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 15:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhFANXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 09:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233758AbhFANXn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 09:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622553721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ThmhXV5C1Mdx87JvqBPyBVcdeP2i7QEeRJhDPg8Jb0Y=;
        b=UJR7GtPI22bYDieQRkOQP5b0jdBIHRfEETEjU13DSu/xMYUEs3VpmCk5gIDvLx+/5ie24E
        ioIaXtfrPOe0bBncJZbCT/dRvSFmmQ/HnR7Jp/bmJ83oUxjtfNTRxitBhuW1PiP0CwxQXW
        T4m4fG7Cty/tI9RLrV6yMI0GWZH+2xE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-BcLfYdDjOVSfYufOFlYFJw-1; Tue, 01 Jun 2021 09:22:00 -0400
X-MC-Unique: BcLfYdDjOVSfYufOFlYFJw-1
Received: by mail-ed1-f69.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so7849240edt.23
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 06:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ThmhXV5C1Mdx87JvqBPyBVcdeP2i7QEeRJhDPg8Jb0Y=;
        b=qNdWc6XeDBsTduTCt5jvNu6qOhwHPruNrJprU28qfO+FzZIDZdy2mTd7YS45voBACM
         z8lB1jVPsiA3DiHYvN4iXHMQ+YWAqybh2XkpCLudEiD36//u0TMMGkyWzxhdxGsZAEVU
         VkAbhZ08mp4YrCzWwyJV/frG9Dwp+O5xIiAKcDkgOi3fgC8YNIBxDBCWoG7iRyd9nQW2
         8QCQXVOeNBqhf0NKyS2rqWx0ejsXvjDLc1vMqXoKohvQZSmae7i79QhUB+aYBKQDUp1X
         kqGtEiYJ7DBjnQLq3fr3rrssELEbJbl/yqkeC/aEALSQuxaUI44KU6AA53kEmzjgIU+Z
         Sw/g==
X-Gm-Message-State: AOAM530lI4IOTwNJCUNcJ8uX95U4rQ0Bo9awizgunBug2d8cTOzfos6D
        ayExQJhvWa5KpiilgeXTZmynYmVdRJbeYkypVXJIN8a+X1zP/5A9DtbuAjSD1l6OUK4GLL4Ijml
        JaaFfiTiJyZ8z
X-Received: by 2002:a50:fd13:: with SMTP id i19mr7558988eds.280.1622553719256;
        Tue, 01 Jun 2021 06:21:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwib9IzYrXbEw79+Z8nE2OguJl12IzGR+VIrSFD6C5CbyzCFWlk9D3q1IvxJWKKa0r/vLCqGw==
X-Received: by 2002:a50:fd13:: with SMTP id i19mr7558970eds.280.1622553719129;
        Tue, 01 Jun 2021 06:21:59 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id nc26sm1596965ejc.106.2021.06.01.06.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 06:21:58 -0700 (PDT)
Date:   Tue, 1 Jun 2021 15:21:56 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Message-ID: <20210601132156.qtgcfkvlr7i7rf2d@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210525172628.2088-5-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 06:26:28PM +0100, Alex Bennée wrote:
> When running the test in TCG we are basically running on bare metal so
> don't rely on having a particular kernel errata applied.
> 
> You might wonder why we handle this with a totally new test name
> instead of adjusting the append to take an extra parameter? Well the
> run_migration shell script uses eval "$@" which unwraps the -append
> leading to any second parameter being split and leaving QEMU very
> confused and the test hanging. This seemed simpler than re-writing all
> the test running logic in something sane ;-)

Yes, bash is a pain for this. I may try to get migration with more than
one parameter to work at some point though. But, for generally determining
if a unit test is running with tcg or with kvm, we have the QEMU_ACCEL
environment variable. So you could just do getenv("QEMU_ACCEL") in the
unit test. However, I wouldn't use it for this case, since the purpose is
just to force errata to be ignored. We have the "ERRATA_FORCE" environment
variable for that already. You can set it yourself, e.g.

 $ ERRATA_FORCE=y tests/its-migration

or, if you plan to run all tests, then with

 $ ./run_tests.sh -a

but that also runs nodefault tests. Maybe we should teach run_tests.sh
to always set ERRATA_FORCE=y when running with TCG?

Thanks,
drew

