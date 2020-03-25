Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD965192E2A
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 17:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCYQ01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 12:26:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60643 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgCYQ00 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 12:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585153585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jq8Dmg84++T9Uwu65Jmp6+JlUIFUs5ji5T/tuboCktU=;
        b=b+VQXyBHSIXV/lgMLX/RUDpG3r8nQfURXT2j/ZHbg78Ke9qaeL1r/Oz7hWLtjJB0Mx6Nd7
        7Zdd4uqcqLBDghqZXnpHYamJWeL8oDxFpZrtoHq/kpKu490BvXrb+q4RM0/5VC+AXAgXtQ
        ejnqGO8HqTrbs1BZhqXPnHeMuu951L0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-Oo9nBzwlOWGpcZKHMS2Fzw-1; Wed, 25 Mar 2020 12:26:23 -0400
X-MC-Unique: Oo9nBzwlOWGpcZKHMS2Fzw-1
Received: by mail-wr1-f70.google.com with SMTP id d1so1376028wru.15
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 09:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jq8Dmg84++T9Uwu65Jmp6+JlUIFUs5ji5T/tuboCktU=;
        b=FjMHY/zhvs6KwttM/y2bhxH2V6dDb2Q272yf35sPJD8sayomRnybubP1fM1tS86iRI
         cqjXVhhUAgQhsKQKV8kQJUL5SHIsqt4sLpXojTflFdpQKsenf78/Jei5o2QSU6Of4Nv4
         8C9F4XjsSu6YSfbKvsCBAqPL8WfblchSj9VcohA8a+FzMkvblJ/dh/Jl1vW3aQO6Lxh2
         G9XU2Zd7GOGVHQRCR7z3XU/YDDxjnPDMuPLuKOuEfnl9OxWpvrQDjxZb/n4sJ5HwzQdr
         VVA5akSnUB9tseeamH13hWEfHb8jkUb3WZCB2UW84fISRekuwe9DtCWqlVGJWSI3Y6jF
         L7Eg==
X-Gm-Message-State: ANhLgQ23s+LXfout79pyPywLjm0ghIym9qi6ehDLfEPbaCeNrRhp3cLr
        47NhSszyyNLAzrpgRbwdIKqkwVR9CY6ufcdCuxyWbY2S4TVPaQ24xWSJSLZgIzqsoTwG2X1k5QA
        lFZyJTCj/EDXG
X-Received: by 2002:adf:f7cb:: with SMTP id a11mr4174640wrq.79.1585153582609;
        Wed, 25 Mar 2020 09:26:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vszjkz/iylm2IOX6v20+yKn/X1ndP6vMESmczBIbaUPTcqyrif74MHSe2V+EevIro+vcwpMPw==
X-Received: by 2002:adf:f7cb:: with SMTP id a11mr4174617wrq.79.1585153582400;
        Wed, 25 Mar 2020 09:26:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id h18sm2550204wmm.34.2020.03.25.09.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:26:21 -0700 (PDT)
Subject: Re: linux-next: Tree for Mar 25 (arch/x86/kvm/)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200325195350.7300fee9@canb.auug.org.au>
 <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
 <d9af8094-96c3-3b7f-835c-4e48d157e582@redhat.com>
 <064720eb-2147-1b92-7a62-f89d6380f40a@infradead.org>
 <85430f7e-93e0-3652-0705-9cf6e948a9d8@redhat.com>
 <20200325161405.GG14294@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b71119b-4594-2535-24ba-2c59430e4f30@redhat.com>
Date:   Wed, 25 Mar 2020 17:26:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325161405.GG14294@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/20 17:14, Sean Christopherson wrote:
>> Doh, right.  I think the only solution for that one is to degrade it to
>> WARN_ON(1).
> I reproduced the error, give me a bit to play with the code to see if the
> BUILD_BUG can be preserved.  I'm curious as to why kvm_cpu_cap_mask() is
> special, and why it only fails with this config.
> 

I could not reproduce it, but I would not be surprised if there are
other configurations where the compiler cannot constant-propagate from
the reverse_cpuid struct into __cpuid_entry_get_reg.

Paolo

