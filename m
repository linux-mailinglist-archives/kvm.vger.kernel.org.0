Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B453D3649F2
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbhDSSkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:40:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239080AbhDSSkV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 14:40:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618857591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5wZEixzzZ7BQyKgP2wJg1cDVNwqU3SACo/kL7cIrtY=;
        b=dYB4dLPNP0u2X5qnzAyhAiEjYpcAM1dhzkdpqdBi974MpjlKiOWrFR+uRYDvJsmFhYj24Y
        9orsiYKB6ye0QR2AwerPWigN9QONbnwr6F06DiL/PLYW/DS9XHJqHumlJ46o3TS0VzxGoh
        q1vC2UN4NePn0EdQQYdPRHJ9DNDhH5U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-zFH5ADFaOrirdjSvMnK0Vw-1; Mon, 19 Apr 2021 14:39:49 -0400
X-MC-Unique: zFH5ADFaOrirdjSvMnK0Vw-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso11669698edl.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I5wZEixzzZ7BQyKgP2wJg1cDVNwqU3SACo/kL7cIrtY=;
        b=D5EihNdGLselTl3Bm6ls4VNycHXpssD787K4oryhHJU68IoD9nxDAhy1+Su/xLDNin
         TAOoK9x+NH1IS7FvXsNVh1LSJtZOrJI7ugyMxaLWNQjol+FUpFk71P2qXBuXARVPl8Np
         dh1xpbdI4mJmbaRjzIOlDwg3u7/8TU5Wyfbi/wB2pgQfLTJDIR3AFtFkVd1IuS08CJG9
         z4ztoWDCQwHxt+03vMxgMvC//7HNDA5U8FxcZ8iMwC3EF3ECrX2fLXkCKVa08ciT4lfL
         KmNPbPDED6Dt/Zmd2E8q1VFgyWY871k/+Ltcs9LRairdBhfwyXJ+NhsvqkRMAKuvpRAd
         BjCw==
X-Gm-Message-State: AOAM530AY0bCCzg3Yv6h+KpUlFaLakLnFm66LQLWMFu/fp9HJQV3+OCQ
        p9I21rquUlm9269sbUSlrlzVe59M3HcJZg3809sYe+BfX9p2jQr1kMaM+nUELHT6pj7nwAbUsZm
        vRrYTZnNfB6kj
X-Received: by 2002:a17:907:3fa2:: with SMTP id hr34mr23789812ejc.476.1618857588669;
        Mon, 19 Apr 2021 11:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP1uTP85gYcMagyk148BltvMxLYcrpEhkZC2VRcUPss+lOjxdCSM4GV2A21uzznULK2NtGSA==
X-Received: by 2002:a17:907:3fa2:: with SMTP id hr34mr23789794ejc.476.1618857588451;
        Mon, 19 Apr 2021 11:39:48 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id bu8sm9970145edb.77.2021.04.19.11.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 11:39:47 -0700 (PDT)
Subject: Re: [kvm:queue 153/154] arch/x86/kvm/mmu/mmu.c:5443:39: error:
 'struct kvm_arch' has no member named 'tdp_mmu_roots'
To:     Ben Gardon <bgardon@google.com>, kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <202104172326.ZkdtgfKs-lkp@intel.com>
 <CANgfPd9WOLmQsDqQgtA5k4UHC+r6jPF4xFN5_gizg_fFa+LXjQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6f43303f-902d-2cc6-39ea-e6f583ef07c8@redhat.com>
Date:   Mon, 19 Apr 2021 20:39:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9WOLmQsDqQgtA5k4UHC+r6jPF4xFN5_gizg_fFa+LXjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 18:33, Ben Gardon wrote:
> I must have failed to propagate some #define CONFIG_x86_64 tags
> around.

It's nicer to extract the loop to a new function 
kvm_tdp_mmu_invalidate_roots.

> I can send out some patches to fix this and the other bug the
> test robot found.

No problem, I'm already testing some small fixes.

Paolo

