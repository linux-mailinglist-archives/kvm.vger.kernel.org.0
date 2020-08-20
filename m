Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADE524B78B
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 12:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgHTK4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:56:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730753AbgHTK4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 06:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597921000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyUbWiVt+/pd6NCJLIhu4YVJj7CJ58kl1EyN+2zcEbc=;
        b=UWAnRGtXTK3s66cnQZSThr8J8neiyuiL+INDKpacViA8/6lHekSE+595gdGTKy7IFf3btS
        lcyu9map2/U88NeLkUHtAU7faoL60XW0y8Vp3QgWRBlWkasZeCzMm3tdMEgYddH/SnbV7Z
        tiJK7sIhfDkJ2HevnF02EpL8lKOs7DU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-w535wRriOBWx3edtHs8ZBA-1; Thu, 20 Aug 2020 06:56:38 -0400
X-MC-Unique: w535wRriOBWx3edtHs8ZBA-1
Received: by mail-wm1-f70.google.com with SMTP id z1so642045wmf.9
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 03:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YyUbWiVt+/pd6NCJLIhu4YVJj7CJ58kl1EyN+2zcEbc=;
        b=UbUx999NA9KLRJddpzvZvWpX6JlzOlhS9QIMAkcBOU/m5WiQo79WKUI8FS91/Eo8AU
         1FqPa/hXzZh6l2mhj8uTlN9xWMgWAvnS0Qepz5EHMgHLCy0jriB4VyoYRwapFerRm4wZ
         put4DmEmhK+iF91nEV+EevAIIYL38zyDVrSLEgLCvC9U7POU6F4MdQuJyJIneZZlZ9pp
         iYBcXhuAxsVV2rdhCSVyI4XxdD1+u/HkhEX+aFZttqqNwxk/wgcet4jq9k04bBfpAj96
         tVKShsT8WTchFptviPrEBCbxRB44/Qh3uasKAdfaYFVYfhlXbgHhvtmUaxhzRfAzicI9
         vjbA==
X-Gm-Message-State: AOAM532bJFe+HGP+GEz1YQkfwSA6kDk1EsNqKo+Q8Np7joS6gizzhm0i
        8a8cD62SqeTaHFvPkGLNs6Bm+6TqA4Y1EgQOcc9x++h81Im2r3odeWDcohfPYl/gc/j8RKwpLnz
        UV1zcOpLVFELv
X-Received: by 2002:a1c:7f17:: with SMTP id a23mr2873502wmd.28.1597920997679;
        Thu, 20 Aug 2020 03:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz4y78/vex3lvu61KJP6j3mDCaLwnKwb2xiZYks8rpAtkPmpBciNL88mgoiDLwRjYGmwwlnw==
X-Received: by 2002:a1c:7f17:: with SMTP id a23mr2873484wmd.28.1597920997427;
        Thu, 20 Aug 2020 03:56:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id t14sm3842691wrg.38.2020.08.20.03.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:56:36 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few
 places
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-3-mlevitsk@redhat.com>
 <f6bf9494-f337-2e53-6e6c-e0b8a847ec8d@redhat.com>
 <608fe03082dc5e4db142afe3c0eb5f7c165f342b.camel@redhat.com>
 <2e8185af-08fc-18c3-c1ca-fa1f7d4665dd@redhat.com>
 <2b8faaead6f7744dc10b4701bd1583a2b494d4f4.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3effc656-20e8-40c9-d0e3-5c700d9b5572@redhat.com>
Date:   Thu, 20 Aug 2020 12:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2b8faaead6f7744dc10b4701bd1583a2b494d4f4.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 12:23, Maxim Levitsky wrote:
> I fully agree that adding local variable is a good idea anyway.
> 
> I was just noting that svm->nested.vmcb is already about the nested
> (e.g vmcb12) thus I was thinking that naming this field vmcb12 would be
> redundant and not accepted this way.

We want to have both svm->nested.vmcb12 and svm->nested.vmcb02 in there,
and hsave is also a VMCB of sort (somewhat like a vmcb01 that is only
used while running a nested guest).  So it is clearer to write _which_
vmcb it is, and it also helps by making terminology consistent between
VMX and SVM.

Paolo

