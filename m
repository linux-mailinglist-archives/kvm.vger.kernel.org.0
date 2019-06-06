Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A28A37A2E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfFFQyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:54:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35310 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfFFQyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:54:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so3201751wrv.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5RrWyhnpIhFZ+ShB4/Pa5S7dEp3L8AOcCcNIxj1Z18s=;
        b=Gg2axAdCncRu8KCxYmevxrKrsGegejp/sRxe21rsaCYBLf/f1ievElK3vTVBS+xTG5
         2yEerfL/UEhdqK6vtn/m0MODc9QIdqKlNZowBn6MO+ThCPtrh8LH+yNFY1soYTAtec4q
         5R4UrUB0q0Si3daj1pojAbNvxnYO9drEYb8K6XoKDFCPwDP+4ZDKQbb8Kk60/TiQ/JSe
         6mvDzzufwxjTO21a7gcIDkKQQvumq0BiBnab1TBEMRTHlFOPvfTvBKPEssB+YF4JQDF6
         lUcHGK4Rh1JveaVBXaN+zT5B5bQdtoixLjp/H2NW6GvixiRCCDH1KN9NbyQuZqY4d0O1
         k3Fg==
X-Gm-Message-State: APjAAAUCJoq057a6+98+QzM/QRMNrTSppVSnj7gd1wqffNXTDV8dZxAs
        9IoPpQIkOMUvZpcWMv792kmsxCMIFdg=
X-Google-Smtp-Source: APXvYqz44j7t1KxUi82RCwmkMielR171bbXwBtxn0Y/tQfdt5AjkVyJ6a4F4dlICmd8v5aoucl5dcw==
X-Received: by 2002:adf:ead1:: with SMTP id o17mr18022228wrn.176.1559840070901;
        Thu, 06 Jun 2019 09:54:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id p16sm3294306wrg.49.2019.06.06.09.54.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:54:30 -0700 (PDT)
Subject: Re: [PATCH 00/15] KVM: nVMX: Optimize nested VM-Entry
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c22da863-8fb4-6baa-7821-f439e5cd0ccf@redhat.com>
Date:   Thu, 6 Jun 2019 18:54:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> The majority of patches in this series are loosely related optimizations
> to pick off low(ish) hanging fruit in nested VM-Entry, e.g. there are
> many VMREADs and VMWRITEs that can be optimized away without too much
> effort.
> 
> The major change (in terms of performance) is to not "put" the vCPU
> state when switching between vmcs01 and vmcs02, which can reudce the
> latency of a nested VM-Entry by upwards of 1000 cycles.
> 
> A few bug fixes are prepended as they touch code that happens to be
> modified by the various optimizations.

I've queued the patches locally, but it will be a few days before I can
give them adequate testing so I have not yet pushed them to kvm/queue.

Paolo
