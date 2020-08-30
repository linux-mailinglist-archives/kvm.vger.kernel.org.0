Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3D5256D29
	for <lists+kvm@lfdr.de>; Sun, 30 Aug 2020 11:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgH3JxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 05:53:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726479AbgH3Jwp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 30 Aug 2020 05:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598781164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shLz+NHIQw6ehBccBaS6HwdyHsjPr6eHCbl/kzv3/W0=;
        b=fY3qqkYvo5KXyBMbko/yb7je8LUgVWdBn3+5Nt7+98z6+kjN+zyaTr3W/DB+8Vneh+XONh
        6gvnzZiZr3iIAgW77PKIk4D2l98196Q8BJfgwvNKI4nXVspNhnJftq5WlmXbi/ntjwOTD2
        kSD9DuJk93ydPZvr3ikYc4kFL6tD11c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-hhvr8Fp4PdCToUXIRTIcAg-1; Sun, 30 Aug 2020 05:52:41 -0400
X-MC-Unique: hhvr8Fp4PdCToUXIRTIcAg-1
Received: by mail-wr1-f72.google.com with SMTP id l17so1873537wrw.11
        for <kvm@vger.kernel.org>; Sun, 30 Aug 2020 02:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=shLz+NHIQw6ehBccBaS6HwdyHsjPr6eHCbl/kzv3/W0=;
        b=TdmM8Dw1tIm68nXnWIcj3sCBpZQNeG4sP9XwcGJ9kXmCe2Aw+1I+3b94ckijMrAVI4
         nbe9eBCxfUS1yXXnyuuJlfWki/CzaNExQNH6VahVB139HfQ5oMF6clAK+e9Gw4wAagQB
         zUcDDT2k7WcWWD76+ledTrZ4DxNjcWmbc6SeUYMP7FUyT1Z2tMyvxlyTBO2picT13hAW
         N5+wRTH3krvKz/vXC+oTJ68amkPqwB1p/lRqqtlEYl2aEeIMm/+ewk6L39FAICtvJJ2c
         EFTYquVwjeebUpkWQ+VZEtRr2QIrgS1kSPX/OgVwVR4nO9XFSKKltjRrJkgB/i+GTnvV
         3mGQ==
X-Gm-Message-State: AOAM5307DJEKTDR1Pk1y0FByzdpoH3rvBHQqyYDelG7w7Ye+MAsnXhZT
        UFuFc30cAzK836l8tMrwDYUNZoFcJTnzSXxBdnK4eS04NYiiIB93+gQghYkGao5M6Relw/ULhMu
        r+538oBdfRVB7
X-Received: by 2002:a1c:e256:: with SMTP id z83mr1674898wmg.137.1598781160422;
        Sun, 30 Aug 2020 02:52:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu3YdiiJZJIOOb9YNtA+ULjbymzyuHXduF3D7yxpxJzNd5MhrgTQiao4swsuBo5MOq0oLLYw==
X-Received: by 2002:a1c:e256:: with SMTP id z83mr1674885wmg.137.1598781160243;
        Sun, 30 Aug 2020 02:52:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9d8:ed0a:2dde:9ff7? ([2001:b07:6468:f312:9d8:ed0a:2dde:9ff7])
        by smtp.gmail.com with ESMTPSA id q6sm6274965wmq.19.2020.08.30.02.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 02:52:39 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: fix the layout of struct
 kvm_vmx_nested_state_hdr
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Shier <pshier@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200713162206.1930767-1-vkuznets@redhat.com>
 <CALMp9eR+DYVH0UZvbNKUNArzPdf1mvAoxakzj++szaVCD0Fcpw@mail.gmail.com>
 <CALMp9eRGStwpYbeHbxo79zF9EyQ=35wwhNt03rjMHMDD9a5G0A@mail.gmail.com>
 <20200827204020.GE22351@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ba02f98-045d-a089-cb7e-8d0b613f76e7@redhat.com>
Date:   Sun, 30 Aug 2020 11:52:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200827204020.GE22351@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/20 22:40, Sean Christopherson wrote:
> Paolo pushed an alternative solution for 5.8, commit 5e105c88ab485 ("KVM:
> nVMX: check for invalid hdr.vmx.flags").  His argument was that there was
> no point in adding proper padding since we already broke the ABI, i.e.
> damage done.
> 
> So rather than pad the struct, which doesn't magically fix the ABI for old
> userspace, just check for unsupported flags.  That gives decent odds of
> failing the ioctl() for old userspace if it's passing garbage (through no
> fault of its own), prevents new userspace from setting unsupported flags,
> and allows KVM to grow the struct by conditioning consumption of new fields
> on an associated flag.

In general userspace (as a hygiene/future-proofing measure) should
generally zero the contents of structs before filling in some fields
only.  There was no guarantee that smm wouldn't grow new fields that
would have occupied the padding, for example.  The general solution we
use is flags fields and checking them.

(The original KVM_GET/SET_NESTED_STATE patches did add a generic flags
fields, but not a VMX-specific one field).

Paolo

