Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B758018A19A
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCRRcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:32:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59916 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbgCRRb6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584552716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bIEdAWs2IdQALzDuEkemxXWdr2rAA5T/LFwoILQOC80=;
        b=Bg0ZFkiWarRj0LI+ktYqCH68UBXBuBXiF7LCEAxs+SPMc5n2po3o/qpDs5QsVHfre37yTF
        ovLz6eG+w8Kpjxn0Erb0hoEDz9g8JdIqq6xBOJvhtRCsTmvxxu/GdjwMxpln2M2ahH5X4C
        msgeuglfEe6s9SpKB9q4D78nUqFJJSs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-74-IqWQYObiG4vGgoWz-3A-1; Wed, 18 Mar 2020 13:31:55 -0400
X-MC-Unique: 74-IqWQYObiG4vGgoWz-3A-1
Received: by mail-wr1-f70.google.com with SMTP id t10so6389089wrp.15
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bIEdAWs2IdQALzDuEkemxXWdr2rAA5T/LFwoILQOC80=;
        b=tmLVJMwCf8NXSTq4CCwcIZ7uDv1lbiiPxM55BHHfpjhUk59RE97VWo7lKIu6UcjLpS
         t4ajg+zvf+s0+BCrxn0IRy8WcVuLOaQ59EJISQKdgvIuocsLAprYU6tI13TfcQtZ02re
         hVQAIZmGMkUkSEmBDbyLrDMioIUBMBGoUdTthFjmTrwEEmz9XrbnJtO5C1A0xWH/iK37
         FNOpiiY5zqQm6rm/uRIwGMugiErDm+sQmGTjdAVmPoCJ496R+6IFuFrHTm6/xdUz2jWM
         HmUskYUhuTFuKGcOvTrBL9CjAdJLw7KkN/Bic4QT04Bx036unhfCkooDPA/xvjQuWqnB
         fH4Q==
X-Gm-Message-State: ANhLgQ35zHgLHCUj9RuOmCkmHX9wDR6ikcwrzfZXRaU4nzDi3R31o9Zb
        hnSKBG/VN8yj8tjs0fouWetFuy6NrxDv+ZYPsvERuZHKTLJa0Ab9i3HKeUnUJzmq8KT7iOtJt1V
        Jtniky04bTZSs
X-Received: by 2002:adf:a4d2:: with SMTP id h18mr6943180wrb.90.1584552713815;
        Wed, 18 Mar 2020 10:31:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvMOb5pOQOV0P/ATjTil/qiszSghckBJJr6fWehPfragC3y/9MOIQObyV9hSemvUTYNKmqFBA==
X-Received: by 2002:adf:a4d2:: with SMTP id h18mr6943159wrb.90.1584552713550;
        Wed, 18 Mar 2020 10:31:53 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id p8sm10385903wrw.19.2020.03.18.10.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 10:31:53 -0700 (PDT)
Subject: Re: [PATCH v4 0/2] KVM: VMX: cleanup VMXON region allocation
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200318171752.173073-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d992436-ada6-3674-9085-060f930a949e@redhat.com>
Date:   Wed, 18 Mar 2020 18:31:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318171752.173073-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/20 18:17, Vitaly Kuznetsov wrote:
> Minor cleanup with no functional change (intended):
> - Rename 'kvm_area' to 'vmxon_region'
> - Simplify setting revision_id for VMXON region when eVMCS is in use
> 
> Changes since v3:
> - Rebase to kvm/queue
> - Added Krish's Reviewed-by: tag to PATCH1
> - Re-name 'enum vmcs_type' members [Sean Christopherson]
> 
> Vitaly Kuznetsov (2):
>   KVM: VMX: rename 'kvm_area' to 'vmxon_region'
>   KVM: VMX: untangle VMXON revision_id setting when using eVMCS
> 
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c    | 44 ++++++++++++++++++---------------------
>  arch/x86/kvm/vmx/vmx.h    | 12 ++++++++---
>  3 files changed, 30 insertions(+), 28 deletions(-)
> 

Queued, thanks.

Paolo

