Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C521F1C0574
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 20:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD3S72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 14:59:28 -0400
Received: from chronos.abteam.si ([46.4.99.117]:58861 "EHLO chronos.abteam.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgD3S72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 14:59:28 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by chronos.abteam.si (Postfix) with ESMTP id 8FB7B5D0009E;
        Thu, 30 Apr 2020 20:59:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=bstnet.org; h=
        content-language:content-transfer-encoding:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:from:from:references:subject:subject; s=default; t=
        1588273166; x=1590087567; bh=UvqVH8KTpiW3ze+03I7jQomdNtH9aYZzxBy
        DU1xjgWk=; b=ek0J2O7DTBKU/RTJHQQhqswL+PW9xzCvyxVnajugrhD8e4YMDkJ
        dybM5eoOw8mIAJGmYDDVuFdFqN0kqgbPqy/38woBcCqj5oIfpR2/lx4LSKn8w4jz
        YKakS6NSkICLfuzG/cjXxjGgaSjD/QOeM/TEU7vLg0YvFrxm1Odv+oNI=
Received: from chronos.abteam.si ([127.0.0.1])
        by localhost (chronos.abteam.si [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F8pxT38ApKLo; Thu, 30 Apr 2020 20:59:26 +0200 (CEST)
Received: from bst-slack.bstnet.org (unknown [IPv6:2a00:ee2:4d00:602:d782:18ef:83c9:31f5])
        (Authenticated sender: boris@abteam.si)
        by chronos.abteam.si (Postfix) with ESMTPSA id CD7E25D0009C;
        Thu, 30 Apr 2020 20:59:24 +0200 (CEST)
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
 <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
 <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
 <2cc1df19-e954-7b69-6175-b674bf12b2c0@amd.com>
 <51d65e72-16de-3a31-1a62-5698775c026f@bstnet.org>
 <95363ee2-ebec-ea19-a40f-37c9cde88566@amd.com>
From:   "Boris V." <borisvk@bstnet.org>
Message-ID: <4b60ec39-6028-b48b-07a7-566bb8469af6@bstnet.org>
Date:   Thu, 30 Apr 2020 20:59:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <95363ee2-ebec-ea19-a40f-37c9cde88566@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 19:21, Suravee Suthikulpanit wrote:
> Boris,
>
> Could you please also give the
>
> [PATCH v2] kvm: ioapic: Introduce arch-specific check for lazy update 
> EOI mechanism
>
> in https://bugzilla.kernel.org/show_bug.cgi?id=207489 a try?
>
> Thanks,
> Suravee

Yes, this patch seems to work.
