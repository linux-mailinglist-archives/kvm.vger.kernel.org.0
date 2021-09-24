Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7334416DD6
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244799AbhIXIfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:35:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244794AbhIXIfN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 04:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632472419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaDeyk3yfVnmfFx2TBmoad42W0snbs51oGVq1h9yRTU=;
        b=YCWDiTIx8xg66lEIBQ4A5n0I2kGJP+j1bPYWWxc/oT5sAFiM1MshKYRGu9tSW43N/bKumL
        icJqcBdb5XLx2GJzQZylr4FeAhX401zumANBZR387WAb0NIDwA0jVQDqcLesOVLxNzEUWV
        Mn5gRcRx1Te0cjDuvu2BV/jzpd5sIag=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-jyD1I0cbORCbCwuGHqDXBw-1; Fri, 24 Sep 2021 04:33:35 -0400
X-MC-Unique: jyD1I0cbORCbCwuGHqDXBw-1
Received: by mail-wr1-f72.google.com with SMTP id u10-20020adfae4a000000b0016022cb0d2bso7387607wrd.19
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 01:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BaDeyk3yfVnmfFx2TBmoad42W0snbs51oGVq1h9yRTU=;
        b=46d+UefiQdtMOSmuY02xFyeZyFEA6akc4G0ugnNW/h1AYnd8sblFFQo0BFtfkreEpt
         c0p0uyEL776qK6F/UKydzViQ58B5J4yYyOWjeROYYVXHW6DCQlRQkvMkrtM04x0IeK9l
         Inq2RBfzl3K2GStK1/SCdDdvUI2Bm4mKHrSrrMOnraU+d5HGSM5Iz2ZfAHnHt9hxZCNG
         NQxeWuwdKEb66xyXEZTF4bcjTIfoRZGNIoYTFWdQBJMVtll+zKhCuR0m3gfeR/b0Nw4a
         weiT3WURs3rUJWDlTY2IOERfMGYFM/Go40SxiUYeZ/uPAJvC7f67UBy5zHGwiTHm+SEJ
         3BPQ==
X-Gm-Message-State: AOAM530fZXPYrMlNxDyRHLs8vljkq6NSc/lxP+SvtOAI32JCjsAc6dvg
        qJRiCLI3SSBpGi28qg5BZYcqSyqV4hpRWukSgsfRjGuisgLdWpz7IWpeddrT+pgwinF9+S4+xVu
        cTQDm2rR3IN52
X-Received: by 2002:adf:f486:: with SMTP id l6mr9626322wro.375.1632472414849;
        Fri, 24 Sep 2021 01:33:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvNlxwL7n8/leRHbTwVBQPcw7YS+W5qZ+GrVNPWUJy8T6FkA1TUSMB0NR1i+PXEuQiczgy/w==
X-Received: by 2002:adf:f486:: with SMTP id l6mr9626299wro.375.1632472414638;
        Fri, 24 Sep 2021 01:33:34 -0700 (PDT)
Received: from thuth.remote.csb (tmo-097-75.customers.d1-online.com. [80.187.97.75])
        by smtp.gmail.com with ESMTPSA id o13sm8629230wri.53.2021.09.24.01.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 01:33:34 -0700 (PDT)
Subject: Re: [PATCH] scripts: Add get_maintainer.pl
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Daniele Ahmed <ahmeddan@amazon.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923101655.4250-1-graf@amazon.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <42815df9-4bb4-dae8-53c5-1d4afab8d5e4@redhat.com>
Date:   Fri, 24 Sep 2021 10:33:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923101655.4250-1-graf@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2021 12.16, Alexander Graf wrote:
> While we adopted the MAINTAINERS file in kvm-unit-tests, the tool to
> determine who to CC on patch submissions is still missing.
> 
> Copy Linux's version over and adjust it to work with and call out the
> kvm-unit-tests tree.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>   scripts/get_maintainer.pl | 2586 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 2586 insertions(+)
>   create mode 100755 scripts/get_maintainer.pl

I'm basically fine with this (maybe we need some modifications as Vitaly 
suggested?), but please add at least the Linux kernel commit ID (or tag) to 
the commit description where you've copied the script from. Otherwise it 
will get ugly if we later try to decide whether we need to backport some 
patches from the kernel...

  Thomas

