Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB411F93C9
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgFOJpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:45:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgFOJpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 05:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592214332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=wPYHGoO4CqXANlsjYaA0wi7JY1jGlu8qGNaNIzAKLVU=;
        b=hS5lzMte1EEFGB1sYC/FkvsKKPm3TBq76Va0mUzHx7gpy5I/QNXLOAkFzT4/R2dKunIQvS
        0MEPaUhNR95YmvlSJlDx8VGmR82nNM3HikiK/jsmpHgQOafxMXRRL9iwPetaUV3Z4TqDTw
        6EsrS5cwhoQ2z+qlEYKueWj8WWcgBP0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-mSTDTBMGOz-8V6e4Qs6ugA-1; Mon, 15 Jun 2020 05:45:20 -0400
X-MC-Unique: mSTDTBMGOz-8V6e4Qs6ugA-1
Received: by mail-wm1-f69.google.com with SMTP id t145so6460385wmt.2
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wPYHGoO4CqXANlsjYaA0wi7JY1jGlu8qGNaNIzAKLVU=;
        b=i//fFjjaOZUPb1smrhYdfRVZZpAayO3Pinai63Z4EaWvEhAyO9ZOFxNSrTD9/5VtrP
         nbYgBbLvalQxs/mRuTdJi7wZ/TFW1y78ZSI7mwY+uXhyMysn0gGgfE3My+spvz0so3HW
         j3RCmvMgm4nFKhQnYwjSLtk5nyj/CZveyG+b3sgl6of01Se0GdY6X+GtUZgvpcSg48Mw
         8/mlFg8crFJXE2D2/hUTPMkGIKzfiSCDWVTcFwhLEFTuGZw+f7itAeXXy98KdT1A+Yva
         KCl6+DqpIf6AgDGmGja5E8OUW2ui9ElrcnTIMvaTeRrliCogkx0iH9uskIA9umCon/eA
         8sZg==
X-Gm-Message-State: AOAM531PPeDFMIhYvRa6imewdru+WbQjgMXK5DwxoEUtjuX8C1X2l2UZ
        D5xc3CjRs0bu+2fSIS5y09C9am52uEmXv2wn7IdtwrWGQeU4bdW4NXuOKbNvq3I1DScUKgeqTyR
        mSe1HRbrjr+HE
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr11781373wmk.28.1592214319244;
        Mon, 15 Jun 2020 02:45:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn+FystiLDSdZvtb92afzanp5cDdPGI+hwQhERDcbUh9bLPMJUYaRW7Lqv+qRdPdvvdEIfcA==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr11781362wmk.28.1592214319037;
        Mon, 15 Jun 2020 02:45:19 -0700 (PDT)
Received: from [192.168.1.40] (181.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.181])
        by smtp.gmail.com with ESMTPSA id j16sm28049543wre.21.2020.06.15.02.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 02:45:18 -0700 (PDT)
Subject: Re: KVM call for 2016-06-16
To:     quintela@redhat.com, kvm-devel <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org
References: <87wo48n047.fsf@secure.mitica>
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
Message-ID: <6324140e-8cc1-074d-8c02-ccce2f48a094@redhat.com>
Date:   Mon, 15 Jun 2020 11:45:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87wo48n047.fsf@secure.mitica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juan,

On 6/15/20 11:34 AM, Juan Quintela wrote:
> 
> Hi
> 
> Please, send any topic that you are interested in covering.
> There is already a topic from last call:

This topic was already discussed in the last call :)

> 
> Last minute suggestion after recent IRC chat with Alex Bennée and
> Thomas Huth:
> 
> "Move some of the build/CI infrastructure to GitLab."
> 
> Pro/Con?
> 
>  - GitLab does not offer s390x/ppc64el => keep Travis for these?
> 
> How to coordinate efforts?
> 
> What we want to improve? Priorities?
> 
> Who can do which task / is motivated.
> 
> What has bugged us recently:
> - Cross-build images (currently rebuilt all the time on Shippable)
> 
> Long term interests:
> 
> - Collect quality metrics
>   . build time
>   . test duration
>   . performances
>   . binary size
>   . runtime memory used
> 
> - Collect code coverage
> 
> Note, this is orthogonal to the "Gating CI" task Cleber is working on:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg688150.html
> 
> 
> 
> 
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
> 
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
> 
>  Call details:
> 
> By popular demand, a google calendar public entry with it
> 
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
> 
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
> 
> If you need phone number details,  contact me privately
> 
> Thanks, Juan.
> 
> 

