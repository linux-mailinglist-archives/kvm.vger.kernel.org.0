Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E651E7993
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgE2Jkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:40:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725795AbgE2Jku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590745248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=UPtCI1ILff4fIxcDolPO4f3yzUVTY12YYe6DiQxSHEY=;
        b=XmagvbBroPa81UC57xK2LfaJdljEh2cIAYd7NHno4yZSgfUihkfacHeBaI7gVjNzlwwt22
        Ibwys5y1aOApmBM1DsEUH3AXdRtZ6SIRW9Ndt2AyzuaxD9yu4D3TBgtja0AvaVfYbLLDVT
        XYNwvYe3Bxs2DA+KMWEbfogWWWX5nqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-i7iNl6pvPny_NHh-SN5RyQ-1; Fri, 29 May 2020 05:40:45 -0400
X-MC-Unique: i7iNl6pvPny_NHh-SN5RyQ-1
Received: by mail-wr1-f71.google.com with SMTP id j16so798397wre.22
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UPtCI1ILff4fIxcDolPO4f3yzUVTY12YYe6DiQxSHEY=;
        b=IiKhkTgomYTmqFXsEI7I3ZSeGmW+KwADfiVY17TbS+rD2P+//Zy4VMR4hK9c0N8leY
         9tOyAgEt913oUlMEjRTU1claVGGju3ilpSkVkB+kHKGZfsBKqba75ek5FIKYoeZmvl7e
         MxEQMErlgxRj/szFcxTnCshmpv62zqUnShfEa+PQOaZN/A1VB2KsLg0Dz3A9HQXzwieo
         iIorgB9+UDAu+tjYaxb0Me8Ih1UotAiTcfOUEsuQ4ez3J0Bc0zFmRFOO07OiL2MteX08
         mtvjOmMx79fLwNWORFdHzROIv+oOfzWg+bgEwr7adpe+Ji/xAvqqqGucwunOZA41LiN1
         GiUA==
X-Gm-Message-State: AOAM530jDfuqgagFR9apACeDoCsDFJpT9MZLkPuzu8CsSWKY13mqV6x8
        HId/DmXjoUFquGr5+esLWLni5yMB4QoRx/t0iNzTTQuS8xiMMnQ8qYPqjvzeY3IsOUVDiRKxpb+
        1ENk0j+BF1ncF
X-Received: by 2002:a7b:c764:: with SMTP id x4mr1596746wmk.94.1590745244141;
        Fri, 29 May 2020 02:40:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLftavAO6RwLptM12fhh21OFc2vujYUyeYMuOsOsbu1L9MnawKG1jHOXUziAu3mFuPCB5H2Q==
X-Received: by 2002:a7b:c764:: with SMTP id x4mr1596729wmk.94.1590745243909;
        Fri, 29 May 2020 02:40:43 -0700 (PDT)
Received: from [192.168.1.34] (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id q128sm9560245wma.38.2020.05.29.02.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:40:43 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] scripts: More Python fixes
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org, Cleber Rosa <crosa@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>
References: <20200512103238.7078-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <dfbf5d8b-c02f-2ac9-80cd-c1190728eb74@redhat.com>
Date:   Fri, 29 May 2020 11:40:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/20 12:32 PM, Philippe Mathieu-Daudé wrote:
> Trivial Python3 fixes, again...
> 
> Since v3:
> - Fixed missing scripts/qemugdb/timers.py (kwolf)
> - Cover more scripts
> - Check for __main__ in few scripts
> 
> Since v2:
> - Remove patch updating MAINTAINERS
> 
> Since v1:
> - Added Alex Bennée A-b tags
> - Addressed John Snow review comments
>   - Use /usr/bin/env
>   - Do not modify os.path (dropped last patch)
> 
> Philippe Mathieu-Daudé (6):
>   scripts/qemugdb: Remove shebang header
>   scripts/qemu-gdb: Use Python 3 interpreter
>   scripts/qmp: Use Python 3 interpreter
>   scripts/kvm/vmxcap: Use Python 3 interpreter and add pseudo-main()
>   scripts/modules/module_block: Use Python 3 interpreter & add
>     pseudo-main
>   tests/migration/guestperf: Use Python 3 interpreter
> 
>  scripts/kvm/vmxcap                 |  7 ++++---
>  scripts/modules/module_block.py    | 31 +++++++++++++++---------------
>  scripts/qemu-gdb.py                |  4 ++--
>  scripts/qemugdb/__init__.py        |  3 +--
>  scripts/qemugdb/aio.py             |  3 +--
>  scripts/qemugdb/coroutine.py       |  3 +--
>  scripts/qemugdb/mtree.py           |  4 +---
>  scripts/qemugdb/tcg.py             |  1 -
>  scripts/qemugdb/timers.py          |  1 -
>  scripts/qmp/qom-get                |  2 +-
>  scripts/qmp/qom-list               |  2 +-
>  scripts/qmp/qom-set                |  2 +-
>  scripts/qmp/qom-tree               |  2 +-
>  tests/migration/guestperf-batch.py |  2 +-
>  tests/migration/guestperf-plot.py  |  2 +-
>  tests/migration/guestperf.py       |  2 +-
>  16 files changed, 33 insertions(+), 38 deletions(-)

Thanks, applied to my python-next tree:
https://gitlab.com/philmd/qemu/commits/python-next

