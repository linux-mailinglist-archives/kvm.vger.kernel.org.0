Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED99929393A
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 12:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393236AbgJTKe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 06:34:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392120AbgJTKez (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 06:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603190094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q96jnE0zL/+3eV1zXo6SJcOjLpLSsjofFz0lkEdY9WI=;
        b=FB4VCxjtYg1R5u5Tv4d70uQoOBt7MV9NxFcIDgMp9Nvy5DPb2MYwywZfhk6H4Hu+GW8BaJ
        IYTTHDvWssL68LJlm9xJBevVmeMKrYvinUXmGsa/7u7PDFFNzYlFh23EA28IZNOlW0zT9d
        1lypS5nEdmzmK2ZKnEGPlsxPbVaWzR0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-L9RClF-1OTK5OuiYTeaNKQ-1; Tue, 20 Oct 2020 06:34:50 -0400
X-MC-Unique: L9RClF-1OTK5OuiYTeaNKQ-1
Received: by mail-wm1-f70.google.com with SMTP id o15so306351wmh.1
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 03:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q96jnE0zL/+3eV1zXo6SJcOjLpLSsjofFz0lkEdY9WI=;
        b=gLdyCuW/56pA2OCFq610+l7d04W8rhW4AIbTexzlxuPdJHaVNzn+QywPsDo6nbLmgm
         faPcwVxYYJ3CyDO0BcNABWNT3GFrGLybkssNBrK6gTV7yB91NiOL3EU2BiCJrpg5XQ8j
         ZCSwinV8nRpYweE77RriX1eWPLjvwcMgbjr4hFTisDvZlAZGtipvmFhkSs1e4wtF/Xmn
         8mCnBs+4Us+/FbBvDW5gAgKWkKziBAn17ypO6R9VOQb6hYEmBymUSV6sLA5ObLOhQw2t
         3pokwRvbPAitJv/Jtx3tulnbcCJPRQ2KKf9Dvzck9eqOJpah56DdJNTEpy138dvl9tfO
         alhQ==
X-Gm-Message-State: AOAM532CQaFgI3PtYy5QQ+V3f8MnBn3J5cP0+lXAWrT4L0O+5ktH27Av
        5ZTF/aWxh0GaRjbK1hfppXIrXmb5nZnJDtLYA7CUsu4hasTxmmjLLKIy31rsxyg9PQKDi0Bgoam
        B+bA5wMrSjFLg
X-Received: by 2002:a1c:87:: with SMTP id 129mr2170668wma.103.1603190089058;
        Tue, 20 Oct 2020 03:34:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK0vtophc5uwVNCm9j+6rJW4gkhbpN0w4IRqerxSf208yGjd3VCwoUYBlm7xrrgEKKeeDtfQ==
X-Received: by 2002:a1c:87:: with SMTP id 129mr2170619wma.103.1603190088421;
        Tue, 20 Oct 2020 03:34:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x81sm2016034wmb.11.2020.10.20.03.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 03:34:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
To:     Alexander Graf <graf@amazon.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
 <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
 <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
 <bce2aee1-bfac-0640-066b-068fa5f12cf8@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6edd5e08-92c2-40ff-57be-37b92d1ca2bc@redhat.com>
Date:   Tue, 20 Oct 2020 12:34:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <bce2aee1-bfac-0640-066b-068fa5f12cf8@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/20 11:48, Alexander Graf wrote:
> 
>     count: 1,
>     default_allow: false,
>     ranges: [
>         {
>             flags: KVM_MSR_FILTER_READ,
>             nmsrs: 1,
>             base: MSR_EFER,
>             bitmap: { 1 },
>         },
>     ],
> }
> 
> That filter would set all x2apic registers to "deny", but would not be
> caught by the code above. Conversely, a range that explicitly allows
> x2apic ranges with default_allow=0 would be rejected by this patch.

Yes, but the idea is that x2apic registers are always allowed, even
overriding default_allow, and therefore it makes no sense to have them
in a range.  The patch is only making things fail early for userspace,
the policy is defined by Sean's patch.

Paolo

