Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A731ACA3B
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbgDPPco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:32:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40123 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726543AbgDPNmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587044525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/1ZzkqlTi7SRUYHpseP8/ZANbIohPVFGcK3piqF1OY=;
        b=bR76VxiXZqep+ag2AGKWid9VYCtdzdY/XDXMovzY+6B/owFGIfpGKkpa5TXfSAUPRxh0bK
        d00GW0X1NTV9DMZCLrrx8tQRExa/M30+DQ8b5JmagGjdWBw1bp+dkyJPradT+uzYeoZLVj
        rOsfhwEmyRfJbQonAqeqSAIIeu4xMc0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-XBMvLm-0PuSzmg475HMGbw-1; Thu, 16 Apr 2020 09:42:04 -0400
X-MC-Unique: XBMvLm-0PuSzmg475HMGbw-1
Received: by mail-wr1-f71.google.com with SMTP id r11so1710501wrx.21
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/1ZzkqlTi7SRUYHpseP8/ZANbIohPVFGcK3piqF1OY=;
        b=nEd1elVGfmm0jCpg9nDp+yq4xfTgSxwmliQ0jKl0VDHPqNvLrxeu6oTmCr3A/QzSSw
         k6Wpz3f6zvS5hnPq/pZzVbQRYhFQBwauXO4IhTWKqCEW/P0nU5F6eRrX3fGfhUwB/3Tk
         byceZ8THLJ0/j20zj6Mmls2neYTSYgqbWX4y2u+7w+ltrFJf26yo9hkmP06UQ2WAnoZY
         yN79BOwiAr7Do+xUQXMMz8FGN07k7PgBApqjlZa9I3+psRI1DgnrcQRm71p8oa8lyVus
         QT1chbsakjDHYdmmLE/FwxfTrtFw7twgkmx8ZDK/0p+rMMOQmlMCI0F7Mo0KQLygbfFy
         LEFw==
X-Gm-Message-State: AGi0Puamb/MKPd5Gl3NQsRtcKo5+UUFXvCrPSge3UtdspeyXOUxWQYmt
        1cQSsuJEpxXlnO7kXKxnlsef2t2ZqjLhcJ/9tvs6AnfD27fKIECQUmmgTFHDFdV2eXsMBCYB9Yr
        Mtqj0LKNWQnsx
X-Received: by 2002:a1c:32c7:: with SMTP id y190mr5217957wmy.13.1587044522783;
        Thu, 16 Apr 2020 06:42:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzoEVKX7f3apWSf+0ABegyK+KCs7PTPeOkDlwys1PA0/OzOllgPpSCI941twQhqGT7eyIuCQ==
X-Received: by 2002:a1c:32c7:: with SMTP id y190mr5217940wmy.13.1587044522536;
        Thu, 16 Apr 2020 06:42:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id o16sm28082541wrs.44.2020.04.16.06.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:42:02 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: VMX: Add caching of EXIT_QUAL and INTR_INFO
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d449f6e3-ca28-2fac-e4ed-7dea2729d3b5@redhat.com>
Date:   Thu, 16 Apr 2020 15:42:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 22:34, Sean Christopherson wrote:
> Patches 4-5 are the focus of this series, adding caching of
> vmcs.EXIT_QUALIFICATION and proper caching of vmcs.INTR_INFO (instead of
> caching it with ad hoc rules about when it's available).  Patches 1-3
> are prep work to clean up the register caching to ensure correctness when
> switching between vmcs01 and vmcs02.
> 
> The idea for this came about when working on the "unionize exit_reason"
> series.  The nested VM-Exit logic looks at both fields multiple times,
> which is ok-ish when everything is crammed into one or two functions, but
> incurs multiple VMREADs when split up.  I really didn't want to solve that
> issue by piling on more cases where vmx->exit_intr_info would be valid, or
> by duplicating that fragile pattern for exit_qualification.
> 
> Paolo, this will conflict with the "unionize exit_reason" series, though
> the conflict resolution is all mechnical in nature.  Let me know if you
> want me to respin one on top of the other, send a single series, etc...

Queued, I think I fixed the conflicts right.  We'll see if anything
explodes when I test it. :)

Paolo

> 
> Sean Christopherson (5):
>   KVM: nVMX: Invoke ept_save_pdptrs() if and only if PAE paging is
>     enabled
>   KVM: nVMX: Reset register cache (available and dirty masks) on VMCS
>     switch
>   KVM: nVMX: Drop manual clearing of segment cache on nested VMCS switch
>   KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags
>   KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags
> 
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/vmx/nested.c       | 29 +++++++------
>  arch/x86/kvm/vmx/nested.h       |  4 +-
>  arch/x86/kvm/vmx/vmx.c          | 73 ++++++++++++++++-----------------
>  arch/x86/kvm/vmx/vmx.h          | 35 +++++++++++++++-
>  5 files changed, 86 insertions(+), 57 deletions(-)
> 

