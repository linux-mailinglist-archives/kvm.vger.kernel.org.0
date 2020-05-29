Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23F61E871F
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgE2TCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 15:02:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26696 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725865AbgE2TCp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 15:02:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590778963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJMaCzfWpvw3lORFlgEXivBUbl9HW4vSaSwT9Obtnms=;
        b=HUKbNQNKgQq/QUNeXtiNfCJHPChtKIKwm4ctJZe2UBmti5HAHCjg7OZnucgp0kFamDrU8K
        or9o0LZQgvMta9uqAxAkKv0Y81WFgQWGafPQU1xs5bHiDna4zt36Y48glg/DyQnUGcm1wT
        ReKbHgTEq/e09th34M00cxnsaSDsR1k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-1D-kP5_DMGm1t-v8yGQE-w-1; Fri, 29 May 2020 15:02:42 -0400
X-MC-Unique: 1D-kP5_DMGm1t-v8yGQE-w-1
Received: by mail-wm1-f70.google.com with SMTP id q7so1134343wmj.9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 12:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wJMaCzfWpvw3lORFlgEXivBUbl9HW4vSaSwT9Obtnms=;
        b=PLJhEzT+apAKVI7kZloh3hIIhPLvHNZZ9omH4JfaRctoMFLEwz5aMHArliepaG8x/R
         vgJ4ThmT54pozME5jAs0FwJy5VIITuegjxh/5fCSv5lUorV6/qIX5YLQ/x09c+VgSI17
         ezkIk1MYSza13U9y2mT3wz/IZ5UYyR0KyGtAMxvY5hBgJuu2tvS/S3fT2Q5ZTNOl56Ac
         Lnt0Jwwfwe4RkSVPLaTIDhEAs4lfsqGN5YZNTuKwG6XmYIljou07ayLrnKH1bJXr6a7m
         9NSC6kAlBmf/QJ/gSoObiQiqw89uXVV25owi0vluIeJsJCZXjI+am4zbDN6DtwIDfQi4
         uy5A==
X-Gm-Message-State: AOAM533wk4dCp/YBQVcqDrfZ/KfugVPUE9Kj2b7IFwYqQnknmLU1nsbF
        tiLFOpLG7aYvdh6TpeKMWV2ySfK7rnYHSwx6Su3JgNACMDtzVOwFz+xRIiDXsQOOZIU2cZt9EPl
        qxpqigog32kBP
X-Received: by 2002:a1c:2d14:: with SMTP id t20mr10121035wmt.28.1590778960678;
        Fri, 29 May 2020 12:02:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBYHA7k+z98Qk2WF3wdHLqhx+6XZ6IgNBwtrzlyMkD9FmEfDC9CoCtymAamfD32bH24wEoUQ==
X-Received: by 2002:a1c:2d14:: with SMTP id t20mr10121011wmt.28.1590778960374;
        Fri, 29 May 2020 12:02:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id l17sm452722wmi.3.2020.05.29.12.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 12:02:39 -0700 (PDT)
Subject: Re: [PATCH 10/30] KVM: nSVM: extract preparation of VMCB for nested
 run
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-11-pbonzini@redhat.com>
 <bf123ad6-3313-351c-a7b8-e55cefb53f63@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f866ffb-625c-e577-bed2-c489aa42782c@redhat.com>
Date:   Fri, 29 May 2020 21:02:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bf123ad6-3313-351c-a7b8-e55cefb53f63@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 20:27, Krish Sadhukhan wrote:
>>
>> +static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct
>> vmcb *nested_vmcb)
> 
> 
> Not a big deal, but I feel that it helps a lot in readability if we keep
> the names symmetric. This one could be named prepare_nested_vmcb_save to
> match load_nested_vmcb_control that you created in the previous patch.
> Or load_nested_vmcb_control could be renamed to nested_load_vmcb_control
> to match the name here.

This is actually intended: while load_nested_vmcb_control loads the
members of nested_vmcb->control into svm->nested, the two functions in
this patch prepare the svm->vmcb.  A couple patches later,
nested_prepare_vmcb_control will not use nested_vmcb anymore.

I could use nested_load_nested_vmcb_control, but that is just too ugly!
 Instead, the best thing to do would be to use the vmcb01/vmcb02/vmcb12
names as in nVMX, in which case the functions would become
nested_load_vmcb12_control and nested_prepare_vmcb02_{save,control}.
However this is a bit hard to do right now because the svm->vmcb acts as
both vmcb01 and vmcb02 depending on what is running.

Thanks,

Paolo

