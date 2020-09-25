Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048D82792F5
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIYVHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:07:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbgIYVHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:07:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601068031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtDwwcJi59z1D/HKuiCOR5O73IrRrE1wXfUfD2k4jj0=;
        b=U7hudy6nCXL+eu9PtSYa5aQ7mZgiUos8Vtw1dSbPUAFP9BhyOMk/QkvUXlLvJeN6Tf0KTT
        SRPs4r/jhZbCZ9VeeZTM0sjIy2CtjwXVf4hUSvDtRHogl0eQk3mvXCfB2B2XimIYqG+BGj
        I7R/4uEWVJT2hATZXyo4kTmFgaCWwaU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-fnQ5Aw51OuKmHH0u_VblNw-1; Fri, 25 Sep 2020 17:07:07 -0400
X-MC-Unique: fnQ5Aw51OuKmHH0u_VblNw-1
Received: by mail-wr1-f69.google.com with SMTP id v12so1561669wrm.9
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WtDwwcJi59z1D/HKuiCOR5O73IrRrE1wXfUfD2k4jj0=;
        b=k+qK1uq6UVjjA6vgcSfIYOAq0xzuvhUVPNkX8+hHGXiA/7DXuRdmTtBrWPZ8cpT2Hs
         RiQ4s/GscRaugM7dcMYIrb+e3/zkG8XpmZybmQrfbxZTApUsTUqeAHtH1RZ7JwiW9aE2
         uzMXfLMXaiDtM+w7w6PMO7Angh1dA5O1xSwClqLMksYheQ9C7ONs+Ygy+G8FVbWw1Xl5
         WqDlPKT9a97+YNhixrmBSoc9JbmxS2ly+oigNoNBh1M9v2JFMbMnvBfEos7aehXMcx4b
         BV8P1Sl/cWyt1TKN8y5o6DIecy3M1FyKCSN3jBCKepTLJLl1jmco0nIVMR47dyBct8Sp
         TuKQ==
X-Gm-Message-State: AOAM533ms5zhoRXd6eoRZondd5OaSiA4J2csW4a4BgZDH060p1llDNVw
        lN2G8MVVeGFlrLicd98N94b+0HpJSy/ZoiktgwL793IQ5F9qohe0XxYkuaDhbJWtwFS/DoPT8cz
        jXaL9P7m27raX
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr457972wme.49.1601068026737;
        Fri, 25 Sep 2020 14:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzepkHEOYf7m00OenFDw5LRaOwFSj9BZafaij8HANdVNw/0nzhGSsNqlZMboX6tC0BbrvI+uQ==
X-Received: by 2002:a05:600c:2183:: with SMTP id e3mr457953wme.49.1601068026456;
        Fri, 25 Sep 2020 14:07:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id b188sm239515wmb.2.2020.09.25.14.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:07:05 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: VMX: Super early file refactor for TDX
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200923183112.3030-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcf93010-7c6b-a1a5-250c-f6017ea8f881@redhat.com>
Date:   Fri, 25 Sep 2020 23:07:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923183112.3030-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 20:31, Sean Christopherson wrote:
> Rename vmx/ops.h to vmx/vmx_ops.h, and move VMX's posted interrupt support
> to dedicated files in preparation for future Trust Domain Extensions (TDX)
> enabling.
> 
> These changes are somewhat premature, as full TDX enabling is months away,
> but the posted interrupts change is (IMO) valuable irrespective of TDX.
> 
> The value of the vmx_ops.h rename without TDX is debatable.  I have no
> problem deferring the change to the actual TDX series if there are
> objections.  I'm submitting the patch now as getting the rename upstream
> will save us minor merge conflict pain if there are changes to vmx/ops.h
> between now and whenever the TDX enabling series comes along.
> 
> https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
> 
> Sean Christopherson (1):
>   KVM: VMX: Rename ops.h to vmx_ops.h
> 
> Xiaoyao Li (1):
>   KVM: VMX: Extract posted interrupt support to separate files
> 
>  arch/x86/kvm/Makefile                 |   3 +-
>  arch/x86/kvm/vmx/posted_intr.c        | 332 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/posted_intr.h        |  99 ++++++++
>  arch/x86/kvm/vmx/vmx.c                | 321 +------------------------
>  arch/x86/kvm/vmx/vmx.h                |  92 +------
>  arch/x86/kvm/vmx/{ops.h => vmx_ops.h} |   0
>  6 files changed, 440 insertions(+), 407 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/posted_intr.c
>  create mode 100644 arch/x86/kvm/vmx/posted_intr.h
>  rename arch/x86/kvm/vmx/{ops.h => vmx_ops.h} (100%)
> 

Queued, thanks.

Paolo

