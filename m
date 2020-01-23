Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F49146E25
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 17:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAWQQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 11:16:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728911AbgAWQQ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 11:16:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579796186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sIIr88lSbFA0BlG1nNmj6Enx5IlWKEvDOlX33MYcGs=;
        b=R5FFQmMenvEz/n1k9wHm4/kfrkq7efeJafRNC8rdaCTcYmxAbCagvaexo0Oc780GDeCi7S
        jPPWwEeLgQbVHL6Hl6W3X2IYuRgq9tGSJycfnYY9zsaMVOcqm0QaBqUmrw/N+R0ibdAz8I
        4YHe2BO+nSI22+T90E+9rm1tnjuC0Mg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-umG6Mi5YP_eHMYwCR7-wiA-1; Thu, 23 Jan 2020 11:16:23 -0500
X-MC-Unique: umG6Mi5YP_eHMYwCR7-wiA-1
Received: by mail-wm1-f72.google.com with SMTP id 7so864807wmf.9
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 08:16:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5sIIr88lSbFA0BlG1nNmj6Enx5IlWKEvDOlX33MYcGs=;
        b=aFmxVHXrqgfW3rKxbkt/oeUS1dMHJ0DWmfsF2KNZ3P38uRZHn1zbDHust0OU9R2o1f
         UFY++0E3Q3Wl3EQqtc8nvoFCJzZO8rIzeYQXi/ACXVmPLsqe8ltfw5gsLxDDwKWNvwfm
         sQmWfycJFU8zwE/qO+jjGaP0tSoL+IB/ydMTKCuAGylx9WuRKk1i1ezqvwz1TV+Sxsqd
         28D/nRW9aD1Ko8zFcTQ9Wt4Gad1HsuqOYTbC8Et553ijJQ90DE0CuAbtmdeQrH68ofxX
         PXtnhCcFRYFLjZsVxN9EXSexlYMy7dpVln4KGBywQw8HYHjRhYvaIoFTm2CIzCywLAIZ
         dYRw==
X-Gm-Message-State: APjAAAU7qWNFX5OJIWzAD+U+gFkrYK06aBSfR6wFg5Ydoebz3IQ42eta
        +N1PcOirrD+KJo6KTGhQkARsdJViEF/3UF6NWX5QTvRu0OhM7i3GxQTnuM2hO/LwAMyR2SCnswA
        wbzQJYNDnQ3qV
X-Received: by 2002:a1c:1b42:: with SMTP id b63mr2167994wmb.16.1579796182460;
        Thu, 23 Jan 2020 08:16:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxSF26kJs+JPMSG10GEDEcJjNLaTdakZx0Dm0y+GVghiwYl96TqI7gbcuuqv9s25ojTDMfPCg==
X-Received: by 2002:a1c:1b42:: with SMTP id b63mr2167981wmb.16.1579796182282;
        Thu, 23 Jan 2020 08:16:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id a9sm3117714wmm.15.2020.01.23.08.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 08:16:21 -0800 (PST)
Subject: Re: [RESEND] Atomic switch of MSR_IA32_UMWAIT_CONTROL
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Tao Xu <tao3.xu@intel.com>, Jingqi Liu <jingqi.liu@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200123154526.GC13178@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0146cafa-9713-59a7-00b7-87add0ab0738@redhat.com>
Date:   Thu, 23 Jan 2020 17:16:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200123154526.GC13178@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 16:45, Sean Christopherson wrote:
> cc'ing KVM and LKML this time...
> 
> Why does KVM use the atomic load/store lists to load MSR_IA32_UMWAIT_CONTROL
> on VM-Enter/VM-Exit?  Unless the host kernel is doing UWMAIT, which it
> really shouldn't and AFAICT doesn't, isn't it better to use the shared MSR
> mechanism to load the host value only when returning to userspace, and
> reload the guest value on demand?
> 

To clarify, laziness also on part of the reviewer, aka me.

Paolo

