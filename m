Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DCE2D0FC5
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgLGLyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgLGLyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 06:54:08 -0500
X-Greylist: delayed 351 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Dec 2020 03:53:28 PST
Received: from forward102o.mail.yandex.net (forward102o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863A1C0613D0;
        Mon,  7 Dec 2020 03:53:28 -0800 (PST)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id DBFBD66803FA;
        Mon,  7 Dec 2020 14:47:34 +0300 (MSK)
Received: from mxback10q.mail.yandex.net (mxback10q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:b6ef:cb3])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id D9EC3CF4000C;
        Mon,  7 Dec 2020 14:47:34 +0300 (MSK)
Received: from vla4-a16f3368381d.qloud-c.yandex.net (vla4-a16f3368381d.qloud-c.yandex.net [2a02:6b8:c17:d85:0:640:a16f:3368])
        by mxback10q.mail.yandex.net (mxback/Yandex) with ESMTP id rMjVz1xLQZ-lYfi5xEr;
        Mon, 07 Dec 2020 14:47:34 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1607341654;
        bh=YgNAleQJwLklwhkvJqaq9XtbQrqkOFbqphiRizVq1Ps=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=YPnZzdiKaVCKpbjViIx/orxY7OWVDryUmlcL1AOCBrU2C4FpVnMDW2kwfW21UPRuU
         5PrOYaQDrK2cTQ2jXYW5ULBiEjeNw3BbiECeYiL0wbz46N6ES4qwzHcvlp1FC8nxZ0
         IQSpKuBKZoH5DSWOk6DYzcJl2gunz+qV1V+b4n1c=
Authentication-Results: mxback10q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla4-a16f3368381d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 0PfyyTmv7T-lXmWUtxA;
        Mon, 07 Dec 2020 14:47:33 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_CPUID doesn't check supported bits (was Re: [PATCH 0/6]
 KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <c0c473c1-93af-2a52-bb35-c32f9e96faea@yandex.ru>
Date:   Mon, 7 Dec 2020 14:47:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <c206865e-b2da-b996-3d48-2c71d7783fbc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.12.2020 14:29, Paolo Bonzini пишет:
> On 07/12/20 12:24, stsp wrote:
>> It tries to enable VME among other things.
>> qemu appears to disable VME by default,
>> unless you do "-cpu host". So we have a situation where
>> the host (which is qemu) doesn't have VME,
>> and guest (dosemu) is trying to enable it.
>> Now obviously KVM_SET_CPUID doesn't check anyting
>> at all and returns success. That later turns
>> into an invalid guest state.
>>
>>
>> Question: should KVM_SET_CPUID check for
>> supported bits, end return error if not everything
>> is supported?
>
> No, it is intentional.  Most bits of CPUID are not ever checked by 
> KVM, so userspace is supposed to set values that makes sense
By "that makes sense" you probably
meant to say "bits_that_makes_sense masked
with the ones returned by KVM_GET_SUPPORTED_CPUID"?

So am I right that KVM_SET_CPUID only "lowers"
the supported bits? In which case I don't need to
call it at all, but instead just call KVM_GET_SUPPORTED_CPUID
and see if the needed bits are supported, and
exit otherwise, right?
