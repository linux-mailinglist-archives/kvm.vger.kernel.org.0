Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AF62D13B4
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbgLGO3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:29:46 -0500
Received: from forward100o.mail.yandex.net ([37.140.190.180]:32907 "EHLO
        forward100o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbgLGO3q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 09:29:46 -0500
Received: from mxback14g.mail.yandex.net (mxback14g.mail.yandex.net [IPv6:2a02:6b8:c03:773:0:640:d1d3:51e5])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id B76EC4AC05BA;
        Mon,  7 Dec 2020 17:29:03 +0300 (MSK)
Received: from sas8-b61c542d7279.qloud-c.yandex.net (sas8-b61c542d7279.qloud-c.yandex.net [2a02:6b8:c1b:2912:0:640:b61c:542d])
        by mxback14g.mail.yandex.net (mxback/Yandex) with ESMTP id tTnFluAx8C-T3sCFrax;
        Mon, 07 Dec 2020 17:29:03 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1607351343;
        bh=oOiExwMNQHtfcgYSxIUj6xzsg445mQfA3dlJmKEAPrw=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=AUvGLVlmuQPBN+yuVOMrO5njrrY1kAqmHObZenOTg9HuPtHR5UeA0Xi2eRNBHsmX9
         lKaAGZNHIIhIksLa+XkxNwThjbu1N7lrfrWJJ/yHl0XrEzxLSjMTTNCYvvuj7bPqLR
         PxWWAHFQ6HPyZMGWKAH78d6ifgsYxS9wjUA/Jc5I=
Authentication-Results: mxback14g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas8-b61c542d7279.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ZIoNUqAXzC-T2nenAaI;
        Mon, 07 Dec 2020 17:29:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_CPUID doesn't check supported bits (was Re: [PATCH 0/6]
 KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup)
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
 <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
 <20201009153053.GA16234@linux.intel.com>
 <b38dff0b-7e6d-3f3e-9724-8e280938628a@yandex.ru>
 <c206865e-b2da-b996-3d48-2c71d7783fbc@redhat.com>
 <c0c473c1-93af-2a52-bb35-c32f9e96faea@yandex.ru>
 <CABgObfYS57_ez-t=eu9+3S2bhSXC_9DTj=64Sna2jnYEMYo2Ag@mail.gmail.com>
 <9201e8ac-68d2-2bb3-1ef3-efd698391955@yandex.ru>
 <CABgObfb_4r=k_qakd+48hPar8rzc-P50+dgdoYvQaL2H-po6+g@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <f505b1f3-4117-ba0f-ef3a-e6ff5293205f@yandex.ru>
Date:   Mon, 7 Dec 2020 17:29:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CABgObfb_4r=k_qakd+48hPar8rzc-P50+dgdoYvQaL2H-po6+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.12.2020 17:09, Paolo Bonzini пишет:
>
>
> Il lun 7 dic 2020, 15:04 stsp <stsp2@yandex.ru 
> <mailto:stsp2@yandex.ru>> ha scritto:
>
>     Perhaps it would be good if guest cpuid to
>     have a default values of KVM_GET_SUPPORTED_CPUID,
>     so that the user doesn't have to do the needless
>     calls to just copy host features to guest cpuid.
>
>
> It is too late to change that aspect of the API, unfortunately. We 
> don't know how various userspaces would behave.
Which means some sensible behaviour
already exists if I don't call KVM_SET_CPUID2.
So what is it, #UD on CPUID?
Would be good to have that documented.
