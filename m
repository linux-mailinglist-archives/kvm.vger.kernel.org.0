Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C34C2C0899
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 14:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgKWM4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 07:56:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387921AbgKWMzp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 07:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606136142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIgMARHh65d7vastz6z3wvlKkBr9dL8K0WJkVXjIrks=;
        b=BFFTK0PiKzqo+tSOUkaOzX2v505nuB7BWCvxlx5br3bzTgQhu9aSZ3k1RyMdA86FaRE1D5
        BKZAWLdYRbejanumV8Qlz6Wt+HfXOxcJhQ1uSqlu5g9jNJlBFLRs+dg2KTAuhgZ/sIZRK6
        WlYEEGCEvrz3LuMXqZvBXxR8dpE3Ri8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-loqBrmAXOiiQZFlkCvaSBA-1; Mon, 23 Nov 2020 07:55:38 -0500
X-MC-Unique: loqBrmAXOiiQZFlkCvaSBA-1
Received: by mail-wm1-f70.google.com with SMTP id k128so7399610wme.7
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 04:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FIgMARHh65d7vastz6z3wvlKkBr9dL8K0WJkVXjIrks=;
        b=JDOnXWjiRRnRslc/yULllIdCoMtXi9zsWQKmcLkWo0uoDgV8Js5I0Ai6y6K9HL9gLQ
         sIbm1YeOVXzKOaXFWwCx1ujGbVvrUxYFjMlHXEbDEAAWCAFcuH6WV3wMloZcl06In//d
         RNMQ8Ske2u+/w7T0PABHEH0AyeytMXieO5p04iGvyJVoJYjahjo8p9fVN9dgpbcsZyYQ
         zNdOmD0xpD1BzV+VHSIVTfLxd9jTEwPHKO7kcSq+TdiwUJDRMiytgEnMzs1fqbB6oDp9
         GD1fCgMkmgm2pJOwp8d6CXTxkupLYpjkglE8FcVZCkDQ4Mg5JSYoRUCsQpiA3gCvbK/h
         4taw==
X-Gm-Message-State: AOAM533HDcKYppv5nu3BaLCM9Jt/Z3Sa2iNa1mCMtHDxVtE7kRO/eXUy
        shFdEexJ5tMJleqdPwnG8Q8ysAFTsXU5OQ9SxtY2jJtoTzwIbod8kgnsbB1sB175J0t0RCRRdHc
        dPYHHVHkzRSon
X-Received: by 2002:a1c:bac1:: with SMTP id k184mr22709769wmf.76.1606136137178;
        Mon, 23 Nov 2020 04:55:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwD3soA/YD1GS6KsWtMF7U7PIn4x93ioUOOj813SwZ/DStZr8boOM5xZW7n1byt0bBxPp2B9Q==
X-Received: by 2002:a1c:bac1:: with SMTP id k184mr22709749wmf.76.1606136136977;
        Mon, 23 Nov 2020 04:55:36 -0800 (PST)
Received: from [192.168.1.36] (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id e1sm16184060wmd.16.2020.11.23.04.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 04:55:36 -0800 (PST)
Subject: Re: [PULL 00/33] Block patches
To:     Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Keith Busch <kbusch@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
 <CAFEAcA_fer-r6tJLRgQwQ+X1bAe0ODSA5UNWxZbSCtS1VHDO9A@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <753aef6b-128d-e1af-b959-e83481749120@redhat.com>
Date:   Mon, 23 Nov 2020 13:55:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_fer-r6tJLRgQwQ+X1bAe0ODSA5UNWxZbSCtS1VHDO9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/20 9:59 PM, Peter Maydell wrote:
> On Wed, 4 Nov 2020 at 15:18, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>
>> The following changes since commit 8507c9d5c9a62de2a0e281b640f995e26eac46af:
>>
>>   Merge remote-tracking branch 'remotes/kevin/tags/for-upstream' into staging (2020-11-03 15:59:44 +0000)
>>
>> are available in the Git repository at:
>>
>>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
>>
>> for you to fetch changes up to fc107d86840b3364e922c26cf7631b7fd38ce523:
>>
>>   util/vfio-helpers: Assert offset is aligned to page size (2020-11-03 19:06:23 +0000)
>>
>> ----------------------------------------------------------------
>> Pull request for 5.2
>>
>> NVMe fixes to solve IOMMU issues on non-x86 and error message/tracing
>> improvements. Elena Afanasova's ioeventfd fixes are also included.

There is a problem with this pull request, the fix hasn't
been merged...

> Applied, thanks.
> 
> Please update the changelog at https://wiki.qemu.org/ChangeLog/5.2
> for any user-visible changes.
> 
> -- PMM
> 

