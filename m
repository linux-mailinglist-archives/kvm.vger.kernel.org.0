Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2C3B2371
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 00:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhFWWPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 18:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhFWWPS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 18:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624486379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RI3bpzwl+9lRSuSFRNo0yswkG4pYNG6+9xza8sRUOac=;
        b=AS8ujqJ19bS7qdSzWIVgAfUPDOy4dT4k/w6ph6AtWzBfhR1TZcVPbcxF1rjgFR9xRF9nqx
        W3IkG7gl9y2BKCewpbztnoNamJ2SuduyG/7FB1CZ81b0qJBizYPw3sdV7XHR2szSMYRwpY
        +RouoHStoGnSeGU39Qo2LhOpU1UKMNQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-CVNi0whvPo-Il1bM2LjGPA-1; Wed, 23 Jun 2021 18:12:58 -0400
X-MC-Unique: CVNi0whvPo-Il1bM2LjGPA-1
Received: by mail-ed1-f72.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so2141108edt.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 15:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RI3bpzwl+9lRSuSFRNo0yswkG4pYNG6+9xza8sRUOac=;
        b=SxODfgP5eI6ayJ/igbGBIpJlIWdo+Pps+2wPsS2Ak2UGLBeEUvAjcrAtqdq4ncEx49
         HLnSIVbHqzowJWz2XiilcZIb9K8wb/gYyC0DhlP4citVcnEgwt7UnIYv7VnLYsBJQ6DB
         1eWUFi9t9iExHqz8WpSGCZnL8yHoHEaJGH9+62sD9V9LtMdAkcqK/AGI5wVfhXNEjIml
         igjwodiOBoFx5oBr/rZJQb3IsGpY7DjTK8ezmGIdyhIDfn1zOoR+Qovz0H4IRQNBXhGH
         5hLqwEmnRqjPLWvCROEXEPU8LU1dBlKE01BJeCYKHONy+TiahWd/u17hn6JQKP5xUHCb
         gOGQ==
X-Gm-Message-State: AOAM531SO4q/FdEjl6Hp5EQOWFyZObfnZaBUW5mERXptqKOt5kJUrG0r
        o2gMQS7+dye3SKrGzra4zeI/JsxcJlUA94H21bf5opOrt9+kMk/mfRN+Hp2Hz7vGYHeEu2UJx2q
        JIooAWdJAYKxj
X-Received: by 2002:a17:906:6ad3:: with SMTP id q19mr2089773ejs.11.1624486377002;
        Wed, 23 Jun 2021 15:12:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz23lnkyS8pgkuHkgkoqeGalGDDxaV/9NdMfAgAvm/CcnpOfH14xYP5wOBkIhPjaaBrvcPTPA==
X-Received: by 2002:a17:906:6ad3:: with SMTP id q19mr2089763ejs.11.1624486376856;
        Wed, 23 Jun 2021 15:12:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y16sm373010ejk.101.2021.06.23.15.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 15:12:56 -0700 (PDT)
Subject: Re: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
 <YNOiar3ySxs0Z3N3@google.com>
 <d9004cf0-d7ac-dc7d-06ad-6669fe11a21b@redhat.com>
 <YNOwz4ln0MsI+/Ts@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80a120a4-305d-33e7-6f97-eb2f154f4cef@redhat.com>
Date:   Thu, 24 Jun 2021 00:12:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNOwz4ln0MsI+/Ts@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 00:08, Sean Christopherson wrote:
>> We can just mark them static inline, which is a good idea anyway and enough
> But they already are static inline:-(

Yep, I noticed later. :/  Probably the clang difference below?

>> to shut up the compiler (clang might behave different in this respect for .h
>> and .c files, but again it's just a warning and not a bisection breakage).
> 
> I was worried about the CONFIG_KVM_WERROR=y case.

CONFIG_KVM_WERROR can always be disabled.  "Unused" warnings do 
sometimes happen in the middle of large series.

Paolo

