Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54230465300
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 17:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbhLAQo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 11:44:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238010AbhLAQo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 11:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638376866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SnH7pitgX4lHmYlmAxxzezWYSXvVY830GNF3XqnXOcQ=;
        b=CGzh5whjJ7q3ePFVaPG5/oFoFm6Jj4DE9fkrgTSYONeE1w3jU0HJDlRYAmy5lLZIU/Swhk
        IlncOtRsXUl2n+0l20B9HatMlAzxD2i2p7hy+ex8E5wwDhyoe+eWFUmy+jhd1Ph2FlvL/n
        fh232Wrgkcj7Pawjf+joGyx5NzLyQ/o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-qtpooW_7MvWGxCx1wMXPng-1; Wed, 01 Dec 2021 11:41:05 -0500
X-MC-Unique: qtpooW_7MvWGxCx1wMXPng-1
Received: by mail-ed1-f69.google.com with SMTP id b15-20020aa7c6cf000000b003e7cf0f73daso20777653eds.22
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 08:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SnH7pitgX4lHmYlmAxxzezWYSXvVY830GNF3XqnXOcQ=;
        b=cKiTwXGF5X9HXe1O6yL1k69TZY5q/eO387aoB8fuhBJLFMYnFzi1pZydT2ltKH2ANB
         T4M/RkxeFFhslxI/C/MSdT2KcZcCBHa+o91GS+TLowprEDUp9bgleCboAMG5WGDVATE5
         ElSV7sIklW8ZpwD//0azik3oBerXjypu89DJf1BDuwq8t60pf+xVu/YH972Om/0YSu+9
         wmIpNwJXplrWuKpU2aF0PzAlsMAE6wIb41PyFFn6Ta1eIPQ47lLGcD3YictakWHprQ8d
         SEk6sG+TM/r1vc8QiC8Ng0ZypWzJxBzLAS0/ufo+7PLbqZtKim3P9Z68t/0qnKoFyydg
         nt9A==
X-Gm-Message-State: AOAM5339E4DEr2tO4cKGG05de7I1vCugfMAcELBVPJnn4MxqQ4xk+Wp2
        6LWzy8kAp7ubMw8gEg74GIoHIG+2uAmY0RQ5QV96Buh3n0WAat3p/WFw7JVD0ZFDrlVYHGUYlf9
        AUiLx5qo/roxj
X-Received: by 2002:a17:907:7e96:: with SMTP id qb22mr8301414ejc.469.1638376864202;
        Wed, 01 Dec 2021 08:41:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7NgTpX038FPeTelSCzUfb+R+QmNIuw2Yq+6qAI1XJAIRnYJhRSKw++EkKdFdXuTjVs3aJVA==
X-Received: by 2002:a17:907:7e96:: with SMTP id qb22mr8301380ejc.469.1638376863918;
        Wed, 01 Dec 2021 08:41:03 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id s4sm174995ejn.25.2021.12.01.08.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:41:02 -0800 (PST)
Date:   Wed, 1 Dec 2021 17:41:00 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Message-ID: <20211201164100.57ima4v5ppqojmu7@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator>
 <87o860xpkr.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o860xpkr.fsf@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021 at 04:20:02PM +0000, Alex Bennée wrote:
> 
> Andrew Jones <drjones@redhat.com> writes:
> 
> > On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Bennée wrote:
> >> The upcoming MTTCG tests don't need to be run for normal KVM unit
> >> tests so lets add the facility to have a custom set of tests.
> >
> > I think an environment variable override would be better than this command
> > line override, because then we could also get mkstandalone to work with
> > the new unittests.cfg files. Or, it may be better to just add them to
> > the main unittests.cfg with lines like these
> >
> > groups = nodefault mttcg
> > accel = tcg
> >
> > That'll "dirty" the logs with SKIP ... (test marked as manual run only)
> > for each one, but at least we won't easily forget about running them from
> > time to time.
> 
> So what is the meaning of accel here? Is it:
> 
>   - this test only runs on accel FOO
> 
> or
> 
>   - this test defaults to running on accel FOO
> 
> because while the tests are for TCG I want to run them on KVM (so I can
> validate the test on real HW). If I have accel=tcg then:
> 
>   env ACCEL=kvm QEMU=$HOME/lsrc/qemu.git/builds/all/qemu-system-aarch64 ./run_tests.sh -g mttcg
>   SKIP tlbflush-code::all_other (tcg only, but ACCEL=kvm)
>   SKIP tlbflush-code::page_other (tcg only, but ACCEL=kvm)
>   SKIP tlbflush-code::all_self (tcg only, but ACCEL=kvm)
>   ...
> 
> so I can either drop the accel line and rely on nodefault to ensure it
> doesn't run normally or make the env ACCEL processing less anal about
> preventing me running TCG tests under KVM. What do you think?

Just drop the 'accel = tcg' line. I only suggested it because I didn't
know you also wanted to run the MTTCG "specific" tests under KVM. Now,
that I do, I wonder why we wouldn't run them all the time, i.e. no
nodefault group? Do the tests not exercise enough hypervisor code to
be worth the energy used to run them?

Thanks,
drew

