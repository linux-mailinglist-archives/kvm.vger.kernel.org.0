Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8802DD0D68
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 13:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJILL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 07:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfJILL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 07:11:28 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19F1BC059B80
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 11:11:28 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id i10so939133wrb.20
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 04:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jGWgKZBUMvfPdzfHcqjjwuG5He2iv9Vy4sHR01HU1S8=;
        b=XryYWV5FPl0rV3NCteV3fZi5F6l36oognczzBPKVhrSQXicgimYRYtCJyFxr7lc9uN
         62oGxozdM/tEgs/XAhI3Niuz/Mtyy8KwJ5H3zjX+8TpVlRugrOwJnlwMo+7HHeah/TXa
         ANmSwp71hf8Sdo9UycwJZgPRg1niJHZ/VHyIpuGS+9AyHHlXpZ2YsiEwm52CQpKA1BMU
         4SJJdSahTEDmVHFzd00YuvDWB73ILpIw1Hxb8AAeEY/GJb74DN7xgj+N9H1ar4XOjdjR
         1Rm8DOyAFASj/RzUKgqE64i3bK/tNcuXjVJvGVh8eYd75W1696kzmB5VDze0hn+4EqDU
         nwYA==
X-Gm-Message-State: APjAAAXXKbiMy+SjhPYWGDTKZzOp+Owc2zUKxg4oFvnH4YGGGyLotCm3
        HbqG01hl4yq7eR5li/ZegnjNFAga75ywQwu493OYCdVQe0KvaYUaUou/rldbyqcsIksi82FVpIL
        BXANy5y4VDtU7
X-Received: by 2002:adf:a50b:: with SMTP id i11mr2567242wrb.308.1570619486788;
        Wed, 09 Oct 2019 04:11:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxJge5bT4Fndd0jKpf2bsQCbdfhi5IMzvx6cG1fbrcbsmBTC0oy38p5pvjjVOE2QUkWlM6YLg==
X-Received: by 2002:adf:a50b:: with SMTP id i11mr2567234wrb.308.1570619486543;
        Wed, 09 Oct 2019 04:11:26 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 36sm2872921wrp.30.2019.10.09.04.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 04:11:26 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20191008180808.14181-1-vkuznets@redhat.com>
 <20191008183634.GF14020@linux.intel.com>
 <b7d20806-4e88-91af-31c1-8cbb0a8a330b@redhat.com>
 <87d0f6yzd3.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5b1b95e5-4836-ab55-fe4d-e9cc78a7a95e@redhat.com>
Date:   Wed, 9 Oct 2019 13:11:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87d0f6yzd3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 12:42, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> There is no practical difference with Vitaly's patch.  The first
>> _vcpu_run has no pre-/post-conditions on the value of %rbx:
> 
> I think what Sean was suggesting is to prevent GCC from inserting
> anything (and thus clobbering RBX) between the call to guest_call() and
> the beginning of 'asm volatile' block by calling *inside* 'asm volatile'
> block instead.

Yes, but there is no way that clobbering RBX will break the test,
because RBX is not initialized until after the first _vcpu_run succeeds.

Paolo
