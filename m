Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0CF151DD0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgBDQHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:07:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727290AbgBDQG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 11:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580832418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uO2tNLNQjvNTQibFbidqKHre5h6Xo6FO5reYTPg4ja0=;
        b=fgIf3gC7vLpRttK/dGAOJ7e+SBw9bbocdsCFBcwtnnmcNXjTbzbqTAKI7yGLHjyzMf/1Db
        4BeRem5g7M4RE/CoCR1JFTMVbt7wMV1ZLEUpT4jWcPT/9Nc0rav73r4OFXJXjFXNb7i+IP
        vePngrPBqqxhYvdCxQXaHP/ONqPoAH8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-vxameGIMNBaRYeRaCF3lgA-1; Tue, 04 Feb 2020 11:06:42 -0500
X-MC-Unique: vxameGIMNBaRYeRaCF3lgA-1
Received: by mail-wr1-f71.google.com with SMTP id t3so10444676wrm.23
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:06:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uO2tNLNQjvNTQibFbidqKHre5h6Xo6FO5reYTPg4ja0=;
        b=t4VMyG5sCADR+vUfaHjEZDnW3Z3w3y2E6I+XNrnTKF1k2I7p6o5F6HjjWxFU+IvFyd
         yX/s4TslBDd4CUKbezQxEYgFszY4OuAEyH1U7cPsc4/to/rMZWAPDSrrgpN6mwiVEPDh
         Gm9k/90UZzTREpkE0UPhpff6GdDR1HT3t/3CdhtMgy6StcCbPQYoeeJ30FFAyJb5ArXx
         Rod344qokEeV1A3ri9WTzEfbU2dcjd54IMPMxWvjEahTRJ5tDdnnA4L3QlOfuNLUB1Mr
         Fcp5Ra5WkRDotn9fmxBUFEA2klwrGKOOn3ijiifhQ//N2aU2evNbeGX/UVPgKcLeqqcP
         IbxA==
X-Gm-Message-State: APjAAAVgnQX0ftSY8VHHFGZnYkdLkserf8vs2th+w5mJuVscz75ZXWAJ
        ct4D2nD2xYFKH0J5tjnYEhC15/NoylE0PNdTGnUZ6r6DVX2rN+7cZYGpBfElcbPZVO5wZlLsDKX
        9Jwigtzn+xkax
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr12124638wru.391.1580832400680;
        Tue, 04 Feb 2020 08:06:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqwsqxSqJ5f4FP8ZEGpsr6vbdyW/x58Gmx4gi3aOH8PTYDIlX3/+a6xhr+yAIln1S5k24i73Mg==
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr12124615wru.391.1580832400442;
        Tue, 04 Feb 2020 08:06:40 -0800 (PST)
Received: from [192.168.178.40] ([151.20.243.54])
        by smtp.gmail.com with ESMTPSA id x7sm30660688wrq.41.2020.02.04.08.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 08:06:38 -0800 (PST)
Subject: Re: [PATCH v2 00/12] python: Explicit usage of Python 3
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
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
        Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org
References: <20200130163232.10446-1-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20cac786-0985-2b20-fe97-a99d9f1d2401@redhat.com>
Date:   Tue, 4 Feb 2020 17:06:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200130163232.10446-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/20 17:32, Philippe Mathieu-Daudé wrote:
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

Queued, thanks.

Paolo

