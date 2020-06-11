Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF671F5F5D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 03:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgFKBBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 21:01:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32431 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726982AbgFKBBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 21:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591837289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOoC7RZ5ToDqNeWTQf3aC7r+Da9v45zFK3rD3f6b8x4=;
        b=VIhQYaa7GSmv5RznyS/S1q/NmPO8/QdxxxbyybehJvu7JeImSbxBajHcY5TDIhUmhCy/tC
        3Cza6DqaqZQC5U/G5mjzKAPkagQd/UKruRgM7xMoFsicGkN2R4D200lmU0f7Xi11w8Z90j
        L3dchNjh/SU4bAqIa6n7MUuQCHfwcs0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-ZL3c7Pr9Mdq0vnpLFqHKqw-1; Wed, 10 Jun 2020 21:01:26 -0400
X-MC-Unique: ZL3c7Pr9Mdq0vnpLFqHKqw-1
Received: by mail-wr1-f69.google.com with SMTP id o1so1815786wrm.17
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 18:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qOoC7RZ5ToDqNeWTQf3aC7r+Da9v45zFK3rD3f6b8x4=;
        b=SQB+u4sEzrK5s5b+eQRZIlNas7A57LLWT5Uxa71d5Qk05OlpEzEm5fiGdiwETzoSPD
         eXobdEgOd3GIevzKrYkLAkwgJMvcGN7uqZHmGd7cJtcPLFJKs3Fd+98E1LkJvCEAeQwF
         MIwOMVCkbYZwbK0tHoCZTZlLueeRh3Y1OUaIiRTccgnKNhOmcl0fnDnGj1KteRV2Coxq
         BHKwl0YkEYzL4YvV2bTFJ7TcKEEFaQqWHPm/SptSiTUrInlR4+7SWM/boLLPLaMm8NQm
         p8baN2zzSwvh+hEuLGJ/0POH55gpUle0O68dhuUp/P90DkB8N5LUaOs2DZRAPzzBRPbq
         pSlw==
X-Gm-Message-State: AOAM533SWDpYpymT81NQrwcXFSg38g0d4Y0XVuHfMkESCrRmqqHbJYsg
        8RqGi2hWmnnHjzVUW8UP6NBLZXLQDqAYYYecTPzofiMGTTB6a3Y6H//NZh5ZuHN6V6NK2LLihiy
        HMtkbxbgSZfY9
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr6609276wrw.225.1591837284795;
        Wed, 10 Jun 2020 18:01:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmpCKb33oT61/L2DBN7Q3n+XsWKue6qZSzcaJIPB+na46qNm4n2FtvyAgaYgBeP8nlL4U3ag==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr6609256wrw.225.1591837284584;
        Wed, 10 Jun 2020 18:01:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id p9sm1622565wma.48.2020.06.10.18.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:01:24 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.8-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
References: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
 <87d0e310-8714-0104-90ef-d4f82920f502@redhat.com>
 <20200611004807.GA2414929@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2dc7c7fc-6cba-e42a-3be4-cf16229c65bc@redhat.com>
Date:   Thu, 11 Jun 2020 03:01:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200611004807.GA2414929@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/20 02:48, Paul Mackerras wrote:
> On Thu, Jun 04, 2020 at 08:58:06PM +0200, Paolo Bonzini wrote:
>> On 02/06/20 01:53, Paul Mackerras wrote:
>>> Hi Paolo,
>>>
>>> Please do a pull from my kvm-ppc-next-5.8-1 tag to get a PPC KVM
>>> update for 5.8.  It's a relatively small update this time.  Michael
>>> Ellerman also has some commits in his tree that touch
>>> arch/powerpc/kvm, but I have not merged them here because there are no
>>> merge conflicts, and so they can go to Linus via Michael's tree.
> ...
>>
>> Pulled, thanks.
>>
>> Paolo
> 
> Thanks.
> 
> Are you planning to send Linus another pull request for this merge
> window, with this stuff in it?

Yes, of course.  I have just pushed it to kvm/next and I'll send it
tomorrow.

Paolo

