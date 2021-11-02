Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529344347A
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKBRWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:22:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhKBRWl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 13:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635873606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9HOAen4JdZY2zeHb5PkTjQnBJDBjxaF4FOqrymR00jA=;
        b=RD86TO10PmKCDGteiqAaQ1jR2i83Oqg2sZmBlU2fZaxC8yZD8BSFH2F1srV/7/b9moIyxe
        qIWOlteOvnaFhilTWA6QpQC/Xqmiwre5iymGvEq2e80ylD9GfUUux5iG9qggqKnUyDo95T
        6Yl5r3j/tWsXtesrs190uFCGxWfqLGw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-NUvwOx7eOL6CgvaW_--a_g-1; Tue, 02 Nov 2021 13:20:05 -0400
X-MC-Unique: NUvwOx7eOL6CgvaW_--a_g-1
Received: by mail-wm1-f69.google.com with SMTP id k6-20020a7bc306000000b0030d92a6bdc7so1117044wmj.3
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9HOAen4JdZY2zeHb5PkTjQnBJDBjxaF4FOqrymR00jA=;
        b=w67Qajemvu/3aqrbzBzjzIDhItnGC9I1xfzXG1YZMczIqOHtjJ6Q/CjpFCTq1pHRfI
         vrAlo5avhvWZ+1sWDztUNoTDNCFZfOLCnC1Ap67mRPjVZA/qhFTFAczQrWgNbUgaGn/k
         ZSoYssG/mTYuQCRr3Dds5y9vcjSw+hsl3Q5h8QgvF9I5/oVEv1P0962rsIhRXyBGw1es
         tfnud7RDwQVRb0sbgDcvtUsI6vQELIlmK2l6p+AEiXknuyTva8uL8LQ/Op3ZSRltpily
         +Niw3VhPxZOuL6Nyozv8P1fk6sFWuS3c0ZXFvwCT42wr9e7EZgCxja55Gu+y325wO6lP
         ZwEg==
X-Gm-Message-State: AOAM531QFeKoVN8JJ6suWZoAA5sDk/H7sDImQp7Qg+yhzLp0kmiCOuDd
        lESJTdzP9CXs7KT/rwyrC5fW+rXyK70SXkxGgZRRVcXuOXWIorVDShnbgm+Z4CJrcksMl6SPgl9
        48ptHR3Ny95/9
X-Received: by 2002:adf:ba87:: with SMTP id p7mr48437374wrg.282.1635873603365;
        Tue, 02 Nov 2021 10:20:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySB5hqLUKqg+OTyL/5+lfoYsx3ZpFIfLbt02S5NOgPSfmcOQJRhH/ISPa18p63Lbu8lLMA7Q==
X-Received: by 2002:adf:ba87:: with SMTP id p7mr48437340wrg.282.1635873603121;
        Tue, 02 Nov 2021 10:20:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w1sm3062221wmc.19.2021.11.02.10.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 10:20:01 -0700 (PDT)
Message-ID: <a425b478-2a8b-83bc-1f65-3a27ce35811b@redhat.com>
Date:   Tue, 2 Nov 2021 18:19:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/riscv for 5.16 take #2
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        KVM General <kvm@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy0TUZAgb5Wyp4Lnv30A1sJ009ATr9VTq49ow_C9-YVeBg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy0TUZAgb5Wyp4Lnv30A1sJ009ATr9VTq49ow_C9-YVeBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/21 13:34, Anup Patel wrote:
>    git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-2

git:// doesn't work anymore for github, please change your configuration 
to https://, but---patches pulled, thanks!

Paolo

