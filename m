Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4E9287990
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgJHQAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 12:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbgJHQAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 12:00:20 -0400
Received: from forward106o.mail.yandex.net (forward106o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6452FC061755
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 09:00:20 -0700 (PDT)
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward106o.mail.yandex.net (Yandex) with ESMTP id 6803C5060543;
        Thu,  8 Oct 2020 19:00:15 +0300 (MSK)
Received: from mxback9q.mail.yandex.net (mxback9q.mail.yandex.net [IPv6:2a02:6b8:c0e:6b:0:640:b813:52e4])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 5AE157080004;
        Thu,  8 Oct 2020 19:00:15 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by mxback9q.mail.yandex.net (mxback/Yandex) with ESMTP id PuXLMA54Eh-0EHaTCfX;
        Thu, 08 Oct 2020 19:00:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1602172815;
        bh=DXPL2fNMjN/13Hhr6VQwGa84/Vd8iqJs7rwhwzEPIMA=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=Z1AU1M+Ap5nXDMJtQum3YPJEH5S+vvdNjxcLpSC7ghY5LPD0THOIXOlOKmxYTSUMi
         5EB8ifjXkXPJkRoaKsqxrccpy7N1hHrPzf+7FIb3HrsJfHTx4E+CMyT6+VmH6qyr4y
         76Y2tjKhN38XkYCBTjnPi82j42ztf24ddNwwMEvA=
Authentication-Results: mxback9q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 1DNHdJ5Tvj-0EnKvcvk;
        Thu, 08 Oct 2020 19:00:14 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
Date:   Thu, 8 Oct 2020 19:00:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.10.2020 04:44, Sean Christopherson пишет:
> Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.
Hi Sean & KVM devs.

I tested the patches, and wherever I
set VMXE in CR4, I now get
KVM: KVM_SET_SREGS: Invalid argument
Before the patch I was able (with many
problems, but still) to set VMXE sometimes.

So its a NAK so far, waiting for an update. :)
