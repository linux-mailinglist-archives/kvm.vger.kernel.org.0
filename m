Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784BA47566F
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbhLOKba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:31:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241669AbhLOKb3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 05:31:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639564289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hMK13kZT/iOHtebkYDknWOrcLsLxaWCYYET8CgcF778=;
        b=WZ1bRjztdTHJ2sWjkFfzZ1RAehiBeslT+NI74JyZCVsGHSo7nR9JIk3OMmdh4E3v6Rbejh
        KmKVr5y4Mpky4fPn+5Ww10Vp/J90fhyqfMWujiv5wEbqMhbWFmS9NvJurXXJSIFRT2kw3j
        qzuup0gcrCSR47ITnjAfnqCeKu4GmEg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-QkbsS-jgMFyWc173E5VRhA-1; Wed, 15 Dec 2021 05:31:28 -0500
X-MC-Unique: QkbsS-jgMFyWc173E5VRhA-1
Received: by mail-wm1-f72.google.com with SMTP id i15-20020a05600c354f00b0034566ac865bso581106wmq.6
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 02:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hMK13kZT/iOHtebkYDknWOrcLsLxaWCYYET8CgcF778=;
        b=4ogsAEnCGtSN6eHyfFShob05bw6m8Kkdf5BKgn0n4au4SRe9rnOW7NOGAf4ZgCkSJD
         WvrTxhoooqdDN+ym8rmDzIzklLyd0swtuWYNMnUMa52RXEf1nTqHXLdX9H/VJNaYKhJ5
         OfhKloRzY4Y63Dsl5UTvEh2Kg2rL8DsCAzXZg7V3pHdSxhS8jaA7uK/AVaRaFnS8mYyD
         Xfih0ipJRa/Ks2CsoehCPNucrLy5qS3oNnkau4EhsCSG3ZzlxgOyBdAf3Eg0h5QkqxL6
         I7mR+G5ubvog2Ja1Wkbav71LCQtssPtPgvCMITRz4Pjy4U7xlTSo5HefCmcYkeGrii6g
         wkXw==
X-Gm-Message-State: AOAM530OP50zbyxCXW7DH0NPHMK1I8akmmSoz6018qBRD7+U5GA+tDKJ
        hSjdhW308X0JmoQLojJlfjyqVKB80MfNvS8KnirEF2g2aGmUf2y7UBH32WC2YfmoUtaVh1Agwjb
        Ah7AMzZBE10A9
X-Received: by 2002:adf:dd46:: with SMTP id u6mr3731134wrm.280.1639564287194;
        Wed, 15 Dec 2021 02:31:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvGEoMe3XejFZnV/yWQaLuWTnlfrzvMYfV6X1zSHmFnqK86Up9eZ/nMmGBQcIY3qr7fCtl6Q==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr3731118wrm.280.1639564287050;
        Wed, 15 Dec 2021 02:31:27 -0800 (PST)
Received: from [192.168.1.36] (174.red-83-50-185.dynamicip.rima-tde.net. [83.50.185.174])
        by smtp.gmail.com with ESMTPSA id d1sm1556650wrz.92.2021.12.15.02.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:31:26 -0800 (PST)
Message-ID: <b30255cd-f34d-1d83-de1f-8eed9b04ad04@redhat.com>
Date:   Wed, 15 Dec 2021 11:31:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH-for-6.2? v2 0/3] misc: Spell QEMU all caps
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, John Snow <jsnow@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Michael Roth <michael.roth@amd.com>, qemu-block@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
References: <20211119091701.277973-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <20211119091701.277973-1-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping?

On 11/19/21 10:16, Philippe Mathieu-Daudé wrote:
> Replace Qemu -> QEMU.
> 
> Supersedes: <20211118143401.4101497-1-philmd@redhat.com>
> 
> Philippe Mathieu-Daudé (3):
>   docs: Spell QEMU all caps
>   misc: Spell QEMU all caps
>   qga: Spell QEMU all caps
> 
>  docs/devel/modules.rst                 |  2 +-
>  docs/devel/multi-thread-tcg.rst        |  2 +-
>  docs/devel/style.rst                   |  2 +-
>  docs/devel/ui.rst                      |  4 ++--
>  docs/interop/nbd.txt                   |  6 +++---
>  docs/interop/qcow2.txt                 |  8 ++++----
>  docs/multiseat.txt                     |  2 +-
>  docs/system/device-url-syntax.rst.inc  |  2 +-
>  docs/system/i386/sgx.rst               | 26 +++++++++++++-------------
>  docs/u2f.txt                           |  2 +-
>  qapi/block-core.json                   |  2 +-
>  python/qemu/machine/machine.py         |  2 +-
>  qga/installer/qemu-ga.wxs              |  6 +++---
>  scripts/checkpatch.pl                  |  2 +-
>  scripts/render_block_graph.py          |  2 +-
>  scripts/simplebench/bench-backup.py    |  4 ++--
>  scripts/simplebench/bench_block_job.py |  2 +-
>  target/hexagon/README                  |  2 +-
>  tests/guest-debug/run-test.py          |  4 ++--
>  tests/qemu-iotests/testenv.py          |  2 +-
>  20 files changed, 42 insertions(+), 42 deletions(-)
> 

