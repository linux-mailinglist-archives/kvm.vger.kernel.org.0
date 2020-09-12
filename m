Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A01267B71
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgILQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 12:33:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbgILQc4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 12:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599928375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4ihSd1TvzPUuSizAvdliFkrAtlKKl27Hj03vXyNnuw=;
        b=An7QGiDnGu9iZ8AIFQ4CqOYzC1DRUTGZ3MrMRw1+VWRlKv2d0IqO5MZ04+h/9mqCHcl8Eh
        SBqtKmqQoRct238MzWH/xG0PN2RP/PSXNsKbu0vyEx/CS2eTAvCIfhJ5KpuiPXP2V/dbsr
        Y/thrqgQWgIAIPktCyq8SBJ5p80kR7s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-ysW9y23bNaqdVhvao1yAng-1; Sat, 12 Sep 2020 12:32:53 -0400
X-MC-Unique: ysW9y23bNaqdVhvao1yAng-1
Received: by mail-wr1-f69.google.com with SMTP id i10so4539425wrq.5
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 09:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E4ihSd1TvzPUuSizAvdliFkrAtlKKl27Hj03vXyNnuw=;
        b=DQhxz/F37Fis8uZ+NaHrr4Cun3zSaTRgG6StfsfPk5Lr5fFgT+3BHGslma3YsnP3cf
         qU0T1mDnaNqgQ6hxsW4aLFK5mOQJ+KXLAAAnfSeg59PJRqJFncgZKBrf2/Uy+BnwQBik
         QD2qmErfaDsYJOvvQtyjI9xiY7U4VHnAVtzgi/d7aRIxjI/7ELhkmUJB4phDiPX7afuJ
         ukWGIvkIPYwtbW73gysGpNDEGQOe1LtvHJAi2PxBqvjrkzeA/SQR48cq5Kz4Mlnf9oU+
         MD045nkTjwOeftfhb0IikGqk2uKjAwoH+PSuzgqjms3+44RPyXiV6DfZEwTwrSgcidry
         lTiw==
X-Gm-Message-State: AOAM533vZ4QUNPPl039YmVcx3rdzhe2OewR37oqrWBtRvoCsim7iyOVM
        oXi6eCDcSRg/MkuOByTOsSx6eU4HdQcWl2A3YMTJdy+akUUjXF+HBc9vfBjoX+IrDky/KnZmig9
        nCaBHX0kznaHR
X-Received: by 2002:a1c:9ad0:: with SMTP id c199mr3457019wme.54.1599928371914;
        Sat, 12 Sep 2020 09:32:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhdnLCjPsk8iumQ5OGtiUobfTtwGlOD/cjiQUiP0LJUrrrE0B4AfSFqWSuGoJ5ywAHfX2cVg==
X-Received: by 2002:a1c:9ad0:: with SMTP id c199mr3457005wme.54.1599928371733;
        Sat, 12 Sep 2020 09:32:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9fd9:16f2:2095:52d7? ([2001:b07:6468:f312:9fd9:16f2:2095:52d7])
        by smtp.gmail.com with ESMTPSA id o6sm11538464wrm.76.2020.09.12.09.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 09:32:51 -0700 (PDT)
Subject: Re: [PATCH 0/3] Few nSVM bugfixes
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200827162720.278690-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d428564f-9884-7927-f635-aa29c23895a6@redhat.com>
Date:   Sat, 12 Sep 2020 18:32:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827162720.278690-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/20 18:27, Maxim Levitsky wrote:
> This patch series contains few nested SVM fixes from
> testing I did this weekend.
> 
> Patch #1 fixes issue where we were setting the GIF (global interrupt flag)
> on first nested VMexit, after migration thus making the nested guest crash
> from unexpected interrupts.
> 
> Patch #2 is my observation that we never setup nesed msr bitmap on nested
> state load after migration.
> 
> Patch #3 was 'migrated' ;-) from my other patch series to make it smaller,
> which is about more strict checks when we about to return to a nested guest,
> from SMM.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (3):
>   SVM: nSVM: correctly restore GIF on vmexit from nesting after
>     migration
>   SVM: nSVM: setup nested msr permission bitmap on nested state load
>   KVM: nSVM: more strict SMM checks when returning to nested guest
> 
>  arch/x86/kvm/svm/nested.c |  7 ++++++-
>  arch/x86/kvm/svm/svm.c    | 29 ++++++++++++++++++-----------
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 

Queued, thanks.

Paolo

