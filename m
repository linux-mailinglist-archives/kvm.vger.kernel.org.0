Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA229B008B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfIKPvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:51:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbfIKPvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:51:11 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 222384E92A
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:51:11 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m6so1417616wmf.2
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MYNEXJF4GkgPzBLfLPqtcFS1AbXG16xNG5ruRxPdF1M=;
        b=JvVdMHr41ldx0LB84wFalMK1lH65eEC6SGS7p+AyOn4tJOj3RoG/XEZNzB/2+rxePK
         POGsj31AyO9kNYiO/e4e0xv0VF4TULc5whfvCI5ktCX5SXkRSDZkq+bEcXLlsVokHEir
         3IR4/wOSUOnwzqkXNEYaY7gkY0KKr8CD4V4bsvFTf5I/sx2oGBiNOzh1aEenmT3xgbuK
         FIhhahYjeU45/+FTJm3RLA9cynXabI4Mbcxz11ORikoWP6C1yOm+NlsbhiL8BhLpZbmK
         JUP2aW1UkXCQzD6KLur4wxroTFjRjuLx/ExWpHxmHASH7IIr+8THEfhDgxDmoQOf6KaY
         znaA==
X-Gm-Message-State: APjAAAXbZmpsnXCIhK3oBFYZLOPnXzGskxiHZUxKYvRRgnLqwP9hP16U
        6fwUBGjFocf/IspFlBp7rzSlrn7kFl1Ep9AfZKNhlnEzfHoOQWsHWlYwTSdEvnU825a2yzIKeTT
        8u4gqtm5y22C7
X-Received: by 2002:a7b:c761:: with SMTP id x1mr4475054wmk.100.1568217069595;
        Wed, 11 Sep 2019 08:51:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwrcjV0TF/QpLhw2Hb2TkuwW5WlkfcWes3bPsKS74TJB47gt2uRH2r+YUum/UKrt2ooDWkz7w==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr4475030wmk.100.1568217069325;
        Wed, 11 Sep 2019 08:51:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id r65sm4352320wmr.9.2019.09.11.08.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:51:08 -0700 (PDT)
Subject: Re: [PATCH 0/3] fix emulation error on Windows bootup
To:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b35c8b24-7531-5a5d-1518-eaf9567359ae@redhat.com>
Date:   Wed, 11 Sep 2019 17:51:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/19 15:07, Jan Dakinevich wrote:
> This series intended to fix (again) a bug that was a subject of the 
> following change:
> 
>   6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
> 
> Suddenly, that fix had a couple mistakes. First, ctxt->have_exception was 
> not set if fault happened during instruction decoding. Second, returning 
> value of inject_emulated_instruction was used to make the decision to 
> reenter guest, but this could happen iff on nested page fault, that is not 
> the scope where this bug could occur.
> 
> However, I have still deep doubts about 3rd commit in the series. Could
> you please, make me an advise if it is the correct handling of guest page 
> fault?
> 
> Jan Dakinevich (3):
>   KVM: x86: fix wrong return code
>   KVM: x86: set ctxt->have_exception in x86_decode_insn()
>   KVM: x86: always stop emulation on page fault
> 
>  arch/x86/kvm/emulate.c | 4 +++-
>  arch/x86/kvm/x86.c     | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 

Queued, thanks.  I added the WARN_ON_ONCE that Sean suggested.

Paolo
