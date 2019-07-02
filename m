Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C885D61D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 20:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGBS2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 14:28:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40423 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGBS2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 14:28:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so18972130wre.7
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 11:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ms7tBZBqvtkI96B9FL56hHtSG4WsKd/c7prQQsQyVk=;
        b=dG2yfufPD4Gje57iP6uyqN9Lw04lZiYpjhaZMmZ004RZqNyn8isWvX1dY017cEy1c0
         uq/lfxjBd5bG/YZmy+qx4xl7/rVQdvWToEDjyUwJ6iPqSpv0jJ0HHFnWpgEiU7U3LDMr
         jhFa0uIq2Ki5U+cjMwifDGaAWtLvel37g/X5fTMw7Y7Hr1G+3zDX6kSE5G0Rx+EXPoSo
         wM2Y1KooMGNnxap4nRPlSjzSDwGkD4L8OfOwVMqXY+xQS0wRmz26C49fjpDr6HdQuFDi
         F9OSM1Z1CCPjnnrQBvv25yE+ZGjAHkxbOrmXEKEHotDjy0s2vSiczfA97cXOmDIg3pi4
         a9FA==
X-Gm-Message-State: APjAAAXo8Zfc3TgC7HxCg+2LORmqmOhn+zKrGlaBzWPQBajZ+H5fhPWO
        mFr+OOu2cttfLZwAzCQoNn7FceYElW0=
X-Google-Smtp-Source: APXvYqxHomseeRkZviEHY9Www9PGKQ1yIEz9sNhzrfWP0iGxaONsBGYxjqauz0rZ/xx6FZKeZeLivQ==
X-Received: by 2002:adf:dd89:: with SMTP id x9mr19838057wrl.7.1562092132750;
        Tue, 02 Jul 2019 11:28:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id 72sm21293892wrk.22.2019.07.02.11.28.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 11:28:52 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
 <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
Date:   Tue, 2 Jul 2019 20:28:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/07/19 19:45, Nadav Amit wrote:
>>> I know you are not “serious”, but I’ll use this opportunity for a small
>>> clarification. You do need to provide the real number of CPUs as otherwise
>>> things will fail. I do not use cpuid, as my machine, for example has two
>>> sockets. Decoding the ACPI tables is the right way, but I was too lazy to
>>> implement it.
>> What about the mptables, too?
> If you mean to reuse mptable.c from [1] or [2] - I can give it a shot. I am
> not about to write my own parser.

Sure.

Paolo

> [1] https://github.com/kernelslacker/x86info/blob/master/mptable.c
> [2] https://people.freebsd.org/~fsmp/SMP/mptable/mptable.c

