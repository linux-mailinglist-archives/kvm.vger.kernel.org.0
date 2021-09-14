Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3C440AB89
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 12:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhINKU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 06:20:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229969AbhINKUx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 06:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631614775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRAlggCC+PYlUePAB0cF2Y6j/OP0F7mIhm9zbgJqV5g=;
        b=Bt0kNv/q4NZMamPIMD/8Fe4X3wcGWv1zk85EnYXvhHCi4PiuDtdlc4AOu7YiiQ/2ApMaLX
        /JaxtflW5d69M0kuqRuh3110nNoFyzCAJjp5OiUfIhY0qcMfz4dov0PcJGwWw6vL8lZxX7
        Pdhn+KNyKrquRMUTt6Am5o2gE7Tg394=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Frjee4D3MdGQyBbR8vik6A-1; Tue, 14 Sep 2021 06:19:34 -0400
X-MC-Unique: Frjee4D3MdGQyBbR8vik6A-1
Received: by mail-ed1-f71.google.com with SMTP id b8-20020a056402350800b003c5e3d4e2a7so6528644edd.2
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 03:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRAlggCC+PYlUePAB0cF2Y6j/OP0F7mIhm9zbgJqV5g=;
        b=B6xcGoSvvr3x63kWxFYTmYVjgUJfYK2IUJ8TvYiKWyHNcmx8l8tVVmrQg6vEkw8QgU
         K7uI9GlJ1NojuPgAlZVwAkcCRK3oUyNhF9dymRAS71h6Od4JPx0R7rblQdsSR8ML6X3p
         fRqIwMk79+RHEQAFXdhVA9Zj5W7esudM+j6YZ827Y/uM5KXqZtKMqodZ8ImSrVNZSuro
         hdLrS/uyIEXvI46QgQySaDMReHaDtTofr+wZ8unO2PgMCNmgA0d1MxqcGXW8tUoqI5qv
         S3TyIfoKP+G+YVvx0vhLwHNuuRr2IEMzyacxafslkfS44kRtFybfRkQk4b+qms1xG9/i
         mh1A==
X-Gm-Message-State: AOAM531DbNtkW7A0Cb9eBjSCMx909a+NNHlY2ouM+EXKAOicvWuIuyys
        XCkTNI5q2X/7lx6oJ7pyhX8/aom+A8WgEyUfsx43BQRpGTUtkrY2yp78xAxNzPPk9jaK8U0plFE
        xpZfEZznbRuEs
X-Received: by 2002:a17:907:76e7:: with SMTP id kg7mr16778431ejc.344.1631614773414;
        Tue, 14 Sep 2021 03:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbCELqwjjt8QQVuD+3BuPAl2MJy/czcHXmaprwjH6qzNCYuRmte+5SasZsQL6iipLwMo7OSg==
X-Received: by 2002:a17:907:76e7:: with SMTP id kg7mr16778412ejc.344.1631614773211;
        Tue, 14 Sep 2021 03:19:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dg18sm2398050edb.44.2021.09.14.03.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 03:19:32 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210914071030.GA28797@yangzhon-Virtual>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
Date:   Tue, 14 Sep 2021 12:19:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914071030.GA28797@yangzhon-Virtual>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 09:10, Yang Zhong wrote:
> On Mon, Sep 13, 2021 at 09:11:51AM -0400, Paolo Bonzini wrote:
>> Based on discussions from the previous week(end), this series implements
>> a ioctl that performs EREMOVE on all pages mapped by a /dev/sgx_vepc
>> file descriptor.  Other possibilities, such as closing and reopening
>> the device, are racy.
>>
>> The patches are untested, but I am posting them because they are simple
>> and so that Yang Zhong can try using them in QEMU.
>>
> 
>    Paolo, i re-implemented one reset patch in the Qemu side to call this ioctl(),
>    and did some tests on Windows and Linux guest, the Windows/Linux guest reboot
>    work well.
> 
>    So, it is time for me to send this reset patch to Qemu community? or wait for
>    this kernel patchset merged? thanks!

Let's wait for this patch to be accepted first.  I'll wait a little more 
for Jarkko and Dave to comment on this, and include your "Tested-by".

I will also add cond_resched() on the final submission.

Paolo

