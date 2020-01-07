Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9C132798
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgAGNaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 08:30:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727559AbgAGNaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 08:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578403802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dO5dyJRO92ZUMEZFdz0lng38rgp1kxe43yUbYPZQhs=;
        b=AvLHEKh8MssTAMSL3sWky7oXaSW/JS3KWALO0V5zFaGzQeb5ZYYA2/AoJKxUPYnJdh+N6f
        rINObQUWS882HSHWZ6pIB9qWD/NPLcvhofLlDt6cngAbE5BNfQqjzNXsCfxKN+vtbKcr1r
        LeeLmDuEaF1nY0yraB/WAWVLpANGNhA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-QpaEseGGN2Gya5WqYDN06Q-1; Tue, 07 Jan 2020 08:30:00 -0500
X-MC-Unique: QpaEseGGN2Gya5WqYDN06Q-1
Received: by mail-wm1-f70.google.com with SMTP id p2so4101275wma.3
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 05:30:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dO5dyJRO92ZUMEZFdz0lng38rgp1kxe43yUbYPZQhs=;
        b=W6RhAxw3ExsQs+4f//67uJZau7IFVUYdqurxvynvkrXyiB7FTnQx3GKnmslbj/DSUN
         b391fsdTyFLyk2nhXfpvmY2fWlyxaHBhqltxFPaM6EDHG6ffqPFtRhYGBOJH4e60ii6P
         IDGvLu0rUL1cs8Yiw1h9N/qioz7U/GJStX+kG76Je/tOYFBdU6F+TodPunhysDtj3tJI
         FOsLKgw9JNierO4J6jMj1N7iE9GSzvO1uA/z5GYch8a+jQDc0oQCOoufGEW2F9esqAs0
         zfFyZ4/8EJrKWrBkHBBocgLv938j69iDThGztoGbIq3vQ3kIfaOAG1l7NEOSykdxmDdh
         762w==
X-Gm-Message-State: APjAAAWw8Xi80CL9Ap8/4qICI8XRUWuGX+MOGW9yrq0KT5PNJT8sxdT3
        0bKJ4MEWsdCE0xO/it0xyvRPx8VmntrSLXuH/AlJHI/o5w2bvQR+9PipMEWHV0AQU8bmuMD9659
        MP0V0D4CQ3xC3
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr42191113wmg.34.1578403799574;
        Tue, 07 Jan 2020 05:29:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1/Ug72uyxI+8DqgZIs7Wjw/Gjie+smyhVbHZ3XaxWHLQKDAT+lPlftzLGzo7HhePck7odMQ==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr42191091wmg.34.1578403799367;
        Tue, 07 Jan 2020 05:29:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id o16sm28278808wmc.18.2020.01.07.05.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 05:29:58 -0800 (PST)
Subject: Re: [kvm-unit-tests] ./run_tests.sh error?
To:     Thomas Huth <thuth@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
 <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
 <8e25eae1-1a80-ddb7-9085-5ba0d8b515cc@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fddd07d0-cfa6-1acf-1758-c2b72b04800f@redhat.com>
Date:   Tue, 7 Jan 2020 14:29:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8e25eae1-1a80-ddb7-9085-5ba0d8b515cc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/20 14:22, Thomas Huth wrote:
> On 27/12/2019 13.46, Andrew Jones wrote:
>> On Wed, Dec 25, 2019 at 01:38:53PM +0800, Haiwei Li wrote:
>>> When i run ./run_tests.sh, i get output like this:
>>>
>>> SKIP apic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>>> such file or directory)
>>> SKIP ioapic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>>> such file or directory)
>>> SKIP apic (qemu: could not open kernel file '_NO_FILE_4Uhere_': No such file
>>> or directory)
>>> ......
> [...]
>> You need https://patchwork.kernel.org/patch/11284587/ for this issue.
>  Hi Paolo,
> 
> could you maybe apply my patch directly, to avoid that other people run
> into this issue, too?

Yes, I will apply the whole series.  I've finished more or less going
through QEMU patches.

Paolo

