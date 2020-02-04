Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2053D151F35
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 18:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBDRUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 12:20:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727414AbgBDRUT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 12:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580836818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hw6+Wu4uyD789kyPxb+U85AivhJLuap+29+WsIGmLOk=;
        b=Pl7OCcb35IRKXDzVPb1JO86MzWgRkN5keNqlz4+w4RBcreT1wqNKIG2rFTdIR/vZ77uigP
        oCd1TgT7kuLbpvcKe9tWbAoDBIA6HN5xz46Zhb1lfoGWusYmChCGr1bQAuaNsgonaUxF8L
        ZJISz5MhCWFvoNS28jiLxvyZ6Dzzv/0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-axvsEwpANvGpaNg11OZSzg-1; Tue, 04 Feb 2020 12:20:12 -0500
X-MC-Unique: axvsEwpANvGpaNg11OZSzg-1
Received: by mail-wm1-f72.google.com with SMTP id b202so1755723wmb.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 09:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hw6+Wu4uyD789kyPxb+U85AivhJLuap+29+WsIGmLOk=;
        b=ubcr8ok3T7nb2f3B1DZc+bBS05yRq57y/cgpkKOzprzSqjqjV7KYToHJ2xu1FSTl5T
         osAN137Boa67Z6gbxAeXdCK9efPDDop87vSxQmoAZR/N6Zq5te2YKbj7YgLaFfV0QdT3
         VixCZQnK85YI5LucbRaVOPC+G4koLYEhfTS1Zvr8AlWEgxvqPN6vhFfKFWxmYrlxSIVQ
         +lckRwbjmlZyyVBT6LBWNF6+epvtwGLeamE1QsfGvm50SiFMM9kNT84Cxnv4G5Io91Ni
         Vj0oF7Py0DBgkoDU/vg/3vQ9j73Cr+Eq/DCmajLfvNuPADpAthQObKse/75xEuUCxvGL
         t4ug==
X-Gm-Message-State: APjAAAXHbDO4HxwFX+5roLJfVHDYpwQzv7qPVocC77plyX7+T/X2Vxa7
        ebjhpor80Lvfojw+M42kXzla0uaK9MqxYaItr9y1Cs0HoHx0iVdn8X99FBquwZ9j1R9uYq7o6lK
        o0g3V+HWJWHiK
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr28206wmk.131.1580836810502;
        Tue, 04 Feb 2020 09:20:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqxbro2tqGgYpNhs3142offvNXpPRxeBmpIjZwerMVMvgRuzLuB19WVpuA2rEayfC7paM+nNVQ==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr28168wmk.131.1580836810223;
        Tue, 04 Feb 2020 09:20:10 -0800 (PST)
Received: from [192.168.1.35] (162.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.162])
        by smtp.gmail.com with ESMTPSA id h13sm19865065wrw.54.2020.02.04.09.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 09:20:09 -0800 (PST)
Subject: Re: [PATCH v2 00/12] python: Explicit usage of Python 3
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org
References: <20200130163232.10446-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <36f9ee1f-03e1-beb5-6f2f-80b17a30ef79@redhat.com>
Date:   Tue, 4 Feb 2020 18:20:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130163232.10446-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/20 5:32 PM, Philippe Mathieu-Daudé wrote:
> Hello,
> 
> These are mechanical sed patches used to convert the
> code base to Python 3, as suggested on this thread:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html
> 
> Since v1:
> - new checkpatch.pl patch
> - addressed Kevin and Vladimir review comments
> - added R-b/A-b tags
> 
> Regards,
> 
> Phil.
> 
> Philippe Mathieu-Daudé (12):
>    scripts/checkpatch.pl: Only allow Python 3 interpreter
>    tests/qemu-iotests/check: Allow use of python3 interpreter
>    tests/qemu-iotests: Explicit usage of Python 3 (scripts with __main__)
>    tests: Explicit usage of Python 3
>    scripts: Explicit usage of Python 3 (scripts with __main__)
>    scripts/minikconf: Explicit usage of Python 3
>    tests/acceptance: Remove shebang header
>    scripts/tracetool: Remove shebang header
>    tests/vm: Remove shebang header
>    tests/qemu-iotests: Explicit usage of Python3 (scripts without
>      __main__)
>    scripts: Explicit usage of Python 3 (scripts without __main__)
>    tests/qemu-iotests/check: Only check for Python 3 interpreter

Series applied to my python-next tree:
https://gitlab.com/philmd/qemu/commits/python-next

