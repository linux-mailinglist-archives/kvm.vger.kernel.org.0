Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD22305C0D
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhA0MvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:51:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237986AbhA0MtD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611751650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aOdVU2S1wjLYeAxjDzo6QAJ2zlJ7GdzXTsTuzIEKa+g=;
        b=c7Ct+IyYgPHfzBDOTFQ5lG5aQ9SJBuQBxiklknT0GvQW+DH11iv5PT0dOFVDVW+LzGezes
        Hhmfs/l515pepRMNHQuKgq38oyHBDL6ZxaUyua6UDwxfalX9/RGcgtj+cAVrEC+nWDTLfJ
        2Ep7sGZdO1Gdt7D4Vy4zShd3uCCMKaA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-sOX56RHNMfCkuAlGTMCwlw-1; Wed, 27 Jan 2021 07:47:28 -0500
X-MC-Unique: sOX56RHNMfCkuAlGTMCwlw-1
Received: by mail-wm1-f71.google.com with SMTP id z188so2543207wme.1
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 04:47:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aOdVU2S1wjLYeAxjDzo6QAJ2zlJ7GdzXTsTuzIEKa+g=;
        b=BkIwvtgEEGAfIahusEMcJWFouQVM55SHLTL36PTp+NHVhiX83HA1qD937ffFmXC3YH
         azIYaU73XTm2WkeF46nWZ/pXL4ryr5ny23qmt8eQXxz9od6waF7xW7Z5aM8bOMR5UhhE
         7icmVZP5RrqTbgUD7N9hMRGZXxpcwCeRzrCcN9EUNOAFjfae2ZusBjL9akLVbB8gB6Gq
         rUK8TaQ+z4L2peN2uHEpr05ygfibnC/k58Qoer2O3ws84bjfGgyfsvI7QanTeNe03tqf
         3c7tiZxj+BBn+pl3Ey6yX7G2xUpGSxCYH+9bNbveSwtrPhaZGzAlaZlhH+PsTL/1QuIT
         ue9w==
X-Gm-Message-State: AOAM530TCI2NJXLr3mf7tTlF/mipmTJgpUmwVCPoU8MRI14L7iU8x1kF
        QP5yHKXYPTqIJ0wCZiLfzNB3ZT6XWnW5TyAS8dFkweCvcIOkstK3vlHdHQXGtgQYqtBjOlGX02V
        A7TV0zI4Q9RL6
X-Received: by 2002:adf:f849:: with SMTP id d9mr11193420wrq.349.1611751647655;
        Wed, 27 Jan 2021 04:47:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6jR2V5MwJgGPqAttIKU4Cs/88SOEleQU/qrmSqPY0rvKN4j1E3jKNjiRR/h96bE2ml2/b8Q==
X-Received: by 2002:adf:f849:: with SMTP id d9mr11193406wrq.349.1611751647520;
        Wed, 27 Jan 2021 04:47:27 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id z184sm2618398wmg.7.2021.01.27.04.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 04:47:21 -0800 (PST)
Date:   Wed, 27 Jan 2021 07:47:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>
Cc:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Subject: Re: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
Message-ID: <20210127074549-mutt-send-email-mst@kernel.org>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <20210112074658-mutt-send-email-mst@kernel.org>
 <9952EF0C-CD1D-4EDB-BAB8-21F72C0BF90D@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9952EF0C-CD1D-4EDB-BAB8-21F72C0BF90D@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 10:28:16AM +0000, Catangiu, Adrian Costin wrote:
> On 12/01/2021, 14:49, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
>     On Tue, Jan 12, 2021 at 02:15:58PM +0200, Adrian Catangiu wrote:
>     > The first patch in the set implements a device driver which exposes a
>     > read-only device /dev/sysgenid to userspace, which contains a
>     > monotonically increasing u32 generation counter. Libraries and
>     > applications are expected to open() the device, and then call read()
>     > which blocks until the SysGenId changes. Following an update, read()
>     > calls no longer block until the application acknowledges the new
>     > SysGenId by write()ing it back to the device. Non-blocking read() calls
>     > return EAGAIN when there is no new SysGenId available. Alternatively,
>     > libraries can mmap() the device to get a single shared page which
>     > contains the latest SysGenId at offset 0.
> 
>     Looking at some specifications, the gen ID might actually be located
>     at an arbitrary address. How about instead of hard-coding the offset,
>     we expose it e.g. in sysfs?
> 
> The functionality is split between SysGenID which exposes an internal u32
> counter to userspace, and an (optional) VmGenID backend which drives
> SysGenID generation changes based on hw vmgenid updates.
> 
> The hw UUID you're referring to (vmgenid) is not mmap-ed to userspace or
> otherwise exposed to userspace. It is only used internally by the vmgenid
> driver to find out about VM generation changes and drive the more generic
> SysGenID.
> 
> The SysGenID u32 monotonic increasing counter is the one that is mmaped to
> userspace, but it is a software counter. I don't see any value in using a dynamic
> offset in the mmaped page. Offset 0 is fast and easy and most importantly it is
> static so no need to dynamically calculate or find it at runtime.

Well you are burning a whole page on it, using an offset the page
can be shared with other functionality.

> Thanks,
> Adrian.
> 
> 
> 
> 
> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

