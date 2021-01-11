Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048A52F1DA2
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 19:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390291AbhAKSKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 13:10:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390286AbhAKSKf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 13:10:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610388549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDmq4fV0YrNy0Sk1Sj2wa2wxIplOf4L7lrzO8gvGa44=;
        b=MYxKO8fbluidycX782LGtccVfvxHfqotGLBvFwBFDyCH6U71KAPPQyb3ujBKp5qV/2r3iT
        +G7qGfG3RvPWsVq8eeqXGVYVmudxNHbYV66D8Qxp5qbNJb87rb32iqurp4v6LnAatxyBdv
        hGa2kiEMGeD47VUh+7oGGbGjh4wAAtc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-u1d5o2UpPRqBIGO4J-_giA-1; Mon, 11 Jan 2021 13:09:07 -0500
X-MC-Unique: u1d5o2UpPRqBIGO4J-_giA-1
Received: by mail-ej1-f70.google.com with SMTP id q11so236136ejd.0
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDmq4fV0YrNy0Sk1Sj2wa2wxIplOf4L7lrzO8gvGa44=;
        b=PmDGjwdIgk6u4aIKOGSXS7inyKlXbE9nJ+9Ji5VJw16S44uySxMyu2TxfWO6kGCEMo
         VMm7ZsNveqy4DuxqBiRWOMK42pd3gso+z3HOU5YCUoZQlVhenVMQ1L27em4ixpIv4Xmj
         /ABhykXdsWIK6H981bfWvMj366hLLXLK+oOHBkObI1HasS9yX7+2qldXUJhpUXm7ql3W
         xQVxYCrPYc6MtdoWGVlobdtCm7TLodxC03y2CnbKTYVOoLUe8+ylwQm//CtR0dFkPxa/
         /QHpTwQOTsoCSmKzSFe+IIlJ8UDhlXSgvY+BVm+CGCm03r/ObYL5i1/piyh+5LjrtNFA
         RIXQ==
X-Gm-Message-State: AOAM532CqzDxMbA19gDzPN/p0Eelcd8ZaHfZacylivH0UY7ELVAoO7G5
        WvDbHDnIyYs7bjCm0v8L7mtg8/yydkDOHuSl8rmYrgRK0Qkc+k02TSKg8mBsTD+VUA4GGBvFIAR
        pgtxwpsONPPzR
X-Received: by 2002:a50:eb44:: with SMTP id z4mr425024edp.167.1610388546340;
        Mon, 11 Jan 2021 10:09:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsdYmcPCQW8JgADQ4kw4erWcJz0etvOGYoGwMhfC7ASHM+4OJl7UEC5wiPso1X/J1774zDpQ==
X-Received: by 2002:a50:eb44:: with SMTP id z4mr425011edp.167.1610388546158;
        Mon, 11 Jan 2021 10:09:06 -0800 (PST)
Received: from [192.168.1.36] (129.red-88-21-205.staticip.rima-tde.net. [88.21.205.129])
        by smtp.gmail.com with ESMTPSA id t12sm277730edy.49.2021.01.11.10.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:09:05 -0800 (PST)
Subject: Re: [for-6.0 v5 05/13] securable guest memory: Rework the
 "memory-encryption" property
To:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     thuth@redhat.com, cohuck@redhat.com, berrange@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        rth@twiddle.net
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-6-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <daf60f1f-354d-785e-4a15-6347fd655147@redhat.com>
Date:   Mon, 11 Jan 2021 19:09:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201204054415.579042-6-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 6:44 AM, David Gibson wrote:
> Currently the "memory-encryption" property is only looked at once we
> get to kvm_init().  Although protection of guest memory from the
> hypervisor isn't something that could really ever work with TCG, it's
> not conceptually tied to the KVM accelerator.
> 
> In addition, the way the string property is resolved to an object is
> almost identical to how a QOM link property is handled.
> 
> So, create a new "securable-guest-memory" link property which sets
> this QOM interface link directly in the machine.  For compatibility we
> keep the "memory-encryption" property, but now implemented in terms of
> the new property.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  accel/kvm/kvm-all.c | 22 ++++++----------------
>  hw/core/machine.c   | 43 +++++++++++++++++++++++++++++++++++++------
>  include/hw/boards.h |  2 +-
>  3 files changed, 44 insertions(+), 23 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

