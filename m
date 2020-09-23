Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D04F275E9D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIWR1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgIWR1n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600882062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ma/IyYqWd34oHOgskwlzrFRY7gOhK4MLYjQUwqMt/1Q=;
        b=Hy8kF9xKgr5O380fljKUBjUFR0MEs6wCsvhz8xZ+Cfo3BPs2kZYRtUQ/N806alXhGaDwDq
        YkqSqaoXNWwwTCx85SFEwnlmNzGK24fxodr65/KfObxRBgdxhqwjkOIewMxuAFGRU92Ixz
        RK5f8IPI49Ck+KNA+tzv7+c7zbC9ETI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-E40L9dInPcaFviAbxwVvHg-1; Wed, 23 Sep 2020 13:27:40 -0400
X-MC-Unique: E40L9dInPcaFviAbxwVvHg-1
Received: by mail-wr1-f70.google.com with SMTP id g6so120410wrv.3
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ma/IyYqWd34oHOgskwlzrFRY7gOhK4MLYjQUwqMt/1Q=;
        b=L2kxeEt00os2uoOzeM5I5PH8jSJ/vpSkwtoHijC22alFdFEB3c+DPJrvSETf7qZoju
         z5VTZSNomCsPm+Dsllr4uGfIB2uCxAuVU8SC6vz4y5R5aeJopGbVcbFMYSyJ3Zgb3G7j
         vxxYnj6t2ErRWs/f5KBJUkcvPimTIQZ5TV5pD5FqCAP0yVDsUtpOcmP9Bh9ejoGK+xdd
         5cRJbc5/l22xFNVmp246ADdGdJKrmRBw4+MMuQr28kxvrx9BJtQHP3nqhNPkbAQNeHVJ
         jHau6dbD1aT0pdQENyQ9Fx8MrHTiN/bXub9gazUVOrGy1W9yP/FCScKRSZydaRAgxM4m
         VfWA==
X-Gm-Message-State: AOAM5326Ag4YYIlPTKOCYa1EHUILSK0gZ4xzDPSe3dCyoBVvZBzX4gS9
        D8i8P6Q4sSviDVdtS90WVhPRN7J1dC6N8xHvix6NaCJvbxMqqlMa8Js1G6SUnkx+/5LIvxcSS4E
        1er/dZK84Ws4S
X-Received: by 2002:adf:f58b:: with SMTP id f11mr757848wro.250.1600882059641;
        Wed, 23 Sep 2020 10:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsdKtajaFmi/b3j9rqMRBSAB1kFNumm9ZLFFSjFBEHO1MxeWAxTEGwTkb33g3um/6zhxK81w==
X-Received: by 2002:adf:f58b:: with SMTP id f11mr757833wro.250.1600882059442;
        Wed, 23 Sep 2020 10:27:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id t124sm539908wmg.31.2020.09.23.10.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:27:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cfir Cohen <cfir@google.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20200807012303.3769170-1-cfir@google.com>
 <20200919045505.GC21189@sjchrist-ice>
 <5ac77c46-88b4-df45-4f02-72adfb096262@redhat.com>
 <20200923170444.GA20076@linux.intel.com>
 <548b7b73-7a13-8267-414e-2b9e1569c7f7@redhat.com>
 <20200923172646.GB32044@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0ccf42d8-2803-c1db-73f0-884d1ea27282@redhat.com>
Date:   Wed, 23 Sep 2020 19:27:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923172646.GB32044@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 19:26, Sean Christopherson wrote:
> 	/*
> 	 * Flush before LAUNCH_UPDATE encrypts pages in place, in case the cache
> 	 * contains the data that was written unencrypted.
>  	 */
>  	sev_clflush_pages(inpages, npages);
> 
> there's nothing in the comment or code that even suggests sev_clflush_pages() is
> conditional, i.e. no reason for the reader to peek at the implemenation.
> 
> What about:
> 
> 	/*
> 	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
> 	 * place, the cache may contain data that was written unencrypted.
> 	 */

Sounds good.

Paolo

