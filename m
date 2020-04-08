Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08691A2781
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgDHQua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:50:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727187AbgDHQu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 12:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586364628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GEFzxGugHwTrvuv37BPHzwDk2hATRin4OSCD/6R76Ww=;
        b=JsgDXVDKj2/Mdw41JqGJqS/B7N8MBCkASjBFIFoup+yBQKZrCmPcwr45sPRe1krsJ40mIX
        qRhueoyq7jMjQugJiL+9AFBZRv2YZ7wK3rFoO+GLYwOkUF+alCa3FDnlQWXsBNoOfmSIxV
        0Q85FoNl3kQAnzGd2l+FE/8FGdRgssY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-g7c2pDvrMDSlxfzL8YJEfA-1; Wed, 08 Apr 2020 12:50:26 -0400
X-MC-Unique: g7c2pDvrMDSlxfzL8YJEfA-1
Received: by mail-wr1-f72.google.com with SMTP id q9so4584553wrw.22
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 09:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GEFzxGugHwTrvuv37BPHzwDk2hATRin4OSCD/6R76Ww=;
        b=QecsFSR4ev7xLRZ76XH1ZUELOLPLPogqFytzpZGvXC6k95FWZT6VvegvbthYwpAN5w
         Ltq/j3pvs0NIh+rWuFQxiGoc/T1lCuLiAG0UIF7JBvs+PfS9O5J/d5dQ0JPws99qwTZh
         xKfcWi2UKVrdacCJYrzv+4WvV6JoCNNY8HpF1+5GQdWYOFkD9CP26lzsYaMoywEMbatk
         4z8BC4fLhGeCyS+I4O43LHvJial3pYUnaVZeGe3RbcBaNeKk220dXh1o8SF8chXT69H6
         M5q9wNJ6guYcIqAjmt6VrspvJsaXOtadly/s174PmRv5oiqlTh3UQuLOmdA8rjqhffTq
         RzBA==
X-Gm-Message-State: AGi0PuZ5brfMDmXSvesSzOTCOdqIi439iNACOUtTfQsdqq9YKgRi0WTd
        /LVeL5irhoSRkppB+9gfpZqQidnUNJl+31mIfakWNy+qLyIk1lkUN1eVLhiVbb/EJLU++f+UI9u
        Lh7sT6YY1rw7s
X-Received: by 2002:a5d:4649:: with SMTP id j9mr10108920wrs.71.1586364625095;
        Wed, 08 Apr 2020 09:50:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypIfCXLt0kF7cyjpECu6nvaYx1McBhi3w+mzdWBDI5wsboGKzNwv/AeI5PDPDHt+4X21+78plA==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr10108883wrs.71.1586364624737;
        Wed, 08 Apr 2020 09:50:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e? ([2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e])
        by smtp.gmail.com with ESMTPSA id b82sm193680wmh.1.2020.04.08.09.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:50:24 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
Date:   Wed, 8 Apr 2020 18:50:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200408153413.GA11322@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/20 17:34, Sean Christopherson wrote:
> On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
>> Page-not-present async page faults are almost a perfect match for the
>> hardware use of #VE (and it might even be possible to let the processor
>> deliver the exceptions).
> 
> My "async" page fault knowledge is limited, but if the desired behavior is
> to reflect a fault into the guest for select EPT Violations, then yes,
> enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
> KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
> MMU page, otherwise not-present faults on zero-initialized EPTEs will get
> reflected.
> 
> Attached a patch that does the prep work in the MMU.  The VMX usage would be:
> 
> 	kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
> 
> when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
> initialize EPTEs.  32-bit could also be supported by doing memcpy() from
> a static page.

The complication is that (at least according to the current ABI) we
would not want #VE to kick if the guest currently has IF=0 (and possibly
CPL=0).  But the ABI is not set in stone, and anyway the #VE protocol is
a decent one and worth using as a base for whatever PV protocol we design.

Paolo

