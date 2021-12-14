Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F774741D4
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 12:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhLNLuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 06:50:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231665AbhLNLuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 06:50:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639482651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+h2CjDECkE7naOqREV8EYRWbl6MLE1bq6FCssGIuZg=;
        b=LT4jmVKMnelV1cMaqq8nFS4AeqLgCMAHcMZI0pCcpsrQnWq5vJY1dz35x+54yVWhJF+X3m
        14jxSy6r5pEPQoi9SSiaB9POqdVIv7gMgImDuNedSeeaLXyqayGFcgyv2WoAyRyfqTu4xI
        C97EWAsOLipQyPKxMKZ1xvatKm4AUGw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193--hYfsPepOnSPnWjr1TIdeg-1; Tue, 14 Dec 2021 06:50:50 -0500
X-MC-Unique: -hYfsPepOnSPnWjr1TIdeg-1
Received: by mail-ed1-f69.google.com with SMTP id w4-20020aa7cb44000000b003e7c0f7cfffso16815100edt.2
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 03:50:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A+h2CjDECkE7naOqREV8EYRWbl6MLE1bq6FCssGIuZg=;
        b=LmKe+Szr9kn7EHQrUgNJZXmMBl3u9KudTtXtHwte7BppwCAWS8lq/58eFYDHnpVPfb
         gQfsqM6qzp+3mYeBWaDCq3/ts4uC9O1otwUMvorZLLGAiFp+DJjehWVYJaBFwBgMbWEH
         csA+J3hRxu3krSdl0+aGmMZ1PZyjHH1KBxqriFc9wk9P6d4m1mPBxkjW4jMctOTWNy+U
         eEqNt7/B3adUSM2+GMnuhQmL3xPbmTPdVMILb3R1KH6XWRj0Ypgh3dwpRXDlUnNg0ul+
         2YRadGFCD89RH/scZACPYGWXHSm/cLqpnHWkMjo6Hw5E68w+1No/dajaACwOqLiClGra
         EbpQ==
X-Gm-Message-State: AOAM530QA1aNeN78DVug8rTtDJ1KFh5Re1gKVDJgd9LQuhHO1nqcVcAp
        lOiCxfxidjMnE9570alHwEM1CPEiMtXCd3QHGs9J2CG2quaIQF4lFRklGtK9hHeHBK5agTKWh7j
        qWXXeUhdT18lX
X-Received: by 2002:a05:6402:1d48:: with SMTP id dz8mr7262778edb.100.1639482648918;
        Tue, 14 Dec 2021 03:50:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZwIm/I/NvC/GwFaVhvRl7q3rFDG7lL9ZjxXc1WAqWSefkTSYHH9dQu7NOGOLLyFjNvzKAwg==
X-Received: by 2002:a05:6402:1d48:: with SMTP id dz8mr7262761edb.100.1639482648779;
        Tue, 14 Dec 2021 03:50:48 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id k21sm7507968edo.87.2021.12.14.03.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:50:48 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:50:46 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Message-ID: <20211214115046.kpiboz7uzgymdoci@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021 at 11:53:43AM +0000, Alex Bennée wrote:
> Hi,
> 
> Not a great deal has changed from the last posting although I have
> dropped the additional unittests.cfg in favour of setting "nodefault"
> for the tests. Otherwise the clean-ups are mainly textual (removing
> printfs, random newlines and cleaning up comments). As usual the
> details are in the commits bellow the ---.
> 
> I've also tweaked .git/config so get_maintainer.pl should ensure
> direct delivery of the patches ;-)
> 
> Alex Bennée (9):
>   docs: mention checkpatch in the README
>   arm/flat.lds: don't drop debug during link

>   arm/run: use separate --accel form

I queued these three to arm/queue[1].

>   Makefile: add GNU global tags support

Haven't queued this yet since I think we need .gitignore changes.

>   lib: add isaac prng library from CCAN
>   arm/tlbflush-code: TLB flush during code execution
>   arm/locking-tests: add comprehensive locking test
>   arm/barrier-litmus-tests: add simple mp and sal litmus tests
>   arm/tcg-test: some basic TCG exercising tests

These I've queued to arm/mttcg[2] with a slight change of dropping the
'mttcg' group name from any tests that can also run under kvm and
renaming mttcg to to tcg for the tests that require tcg.

I haven't pushed everything to arm/queue yet since I'm not yet sure
I like all the nodefault tests showing up in the logs, even though that
was my suggestion... I need to play with it some more.

Thanks,
drew

[1] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
[2] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/mttcg

