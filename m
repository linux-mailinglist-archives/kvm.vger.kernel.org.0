Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B282D13E7
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLGOmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:42:23 -0500
Received: from forward101o.mail.yandex.net ([37.140.190.181]:47839 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgLGOmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 09:42:23 -0500
Received: from mxback28o.mail.yandex.net (mxback28o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::79])
        by forward101o.mail.yandex.net (Yandex) with ESMTP id F1E6B3C00876;
        Mon,  7 Dec 2020 17:41:38 +0300 (MSK)
Received: from iva5-057a0d1fbbd8.qloud-c.yandex.net (iva5-057a0d1fbbd8.qloud-c.yandex.net [2a02:6b8:c0c:7f1c:0:640:57a:d1f])
        by mxback28o.mail.yandex.net (mxback/Yandex) with ESMTP id oamv1XwPu4-fcWWfQid;
        Mon, 07 Dec 2020 17:41:38 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1607352098;
        bh=14tUsqybUpCpcHIHOV3QLP0iWuq+HJ50yDceRMbfNI8=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=BO/gcz0D/DfBZeX8UOYKeghLawyt4u9WmDhYsCZzq2c0NihbTNySUP44owk/Vxquj
         BMW4UUJrg2e1F/gdmkrM+RaLN+WVr21YUzeRtLsjmxLgEs5S8xcAk91uDjYakShNvA
         rjiPXoY8gOR9ZWFjgtJYAhO2wjbnjwm0OLOc4iA8=
Authentication-Results: mxback28o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva5-057a0d1fbbd8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id awEwUpSmah-fbmmVX2Y;
        Mon, 07 Dec 2020 17:41:37 +0300
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
 <f505b1f3-4117-ba0f-ef3a-e6ff5293205f@yandex.ru>
 <CABgObfYN7Okdt+YfHtsd3M_00iuWf=UyKPmbQhhYBhoiMtdXuw@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <ae433269-61ee-9bb8-0e06-a266b10c7f31@yandex.ru>
Date:   Mon, 7 Dec 2020 17:41:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CABgObfYN7Okdt+YfHtsd3M_00iuWf=UyKPmbQhhYBhoiMtdXuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.12.2020 17:34, Paolo Bonzini пишет:
>
>     > It is too late to change that aspect of the API, unfortunately. We
>     > don't know how various userspaces would behave.
>     Which means some sensible behaviour
>     already exists if I don't call KVM_SET_CPUID2.
>     So what is it, #UD on CPUID?
>
>
> I would have to check but I think you always get zeroes; not entirely 
> sensible.
In that case I would argue that you can't
break anything by changing that to something
sensible. :)
But anyway, since my problem is solved,
this is just a potential improvement for the
future, or the case for documenting.
