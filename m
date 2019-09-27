Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599C4C0927
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfI0QGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13303 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0QGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:06:39 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2530D796E9
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:06:39 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id h6so1306871wrh.6
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UrmeD7O6xfWH7o64iQhC/WYyQTUgCZxajSTDdhgE6O0=;
        b=gjum970ZEFp9+qYPtacv/QGGsC2JwNSHQXpsFz63LnIM+V131AZMp8BVOg4lrCAJCj
         C3x/Ld1RRI339QoDn8krDSSeMgVWqtH2L0tVw+1UFZN/MCQ5PReWHxd89JlsKViAZBe6
         MqagcS4kjqPsLA8xzf/jUUrrYvIUkd7Poi/ajHIiaEg2VUp4XY/SwEGgi6B//4g1rwhk
         EkScsjMdFiLo2MttPsvQgHjedudeTxefA8CGYL8vfJp5EoU2EK/PsG67eADbswGmRQDg
         td9ARApP4RbKj4XbhoO19z0NllmDO8VbZWAlEZ5yfQo5d1dcFdKhF/u1lWe04RCEHZen
         5mqg==
X-Gm-Message-State: APjAAAW8rPBn7/gFSDL05ruqf/+hDEMYDX9zqKfWbRehv3TF0JDSDcDt
        pmAx0bjmEvf4Dn47QVqOidv8P+WXPC8cuuNWptGEbFNCjcsz7dKK3Nelv4yWUmd+PJ9ghwBjfFQ
        ZYFjqtldgmYOJ
X-Received: by 2002:a1c:544e:: with SMTP id p14mr7447580wmi.72.1569600397543;
        Fri, 27 Sep 2019 09:06:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwd6FIMentYmXbwuv5OVNUsI1ZCCXASJYxLoGRloTB6SP9mbKT9ueJjjMcjrnZ2pM6GodB/Vg==
X-Received: by 2002:a1c:544e:: with SMTP id p14mr7447551wmi.72.1569600397287;
        Fri, 27 Sep 2019 09:06:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id u68sm12425842wmu.12.2019.09.27.09.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:06:36 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com>
 <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com>
 <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
Date:   Fri, 27 Sep 2019 18:06:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 17:58, Xiaoyao Li wrote:
> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> they are free from different guest configuration since they're initialized when
> kvm module is loaded.
> 
> Even though some MSRs are not exposed to guest by clear their related cpuid
> bits, they are still saved/restored by QEMU in the same fashion.
> 
> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?

We can add a per-VM version too, yes.

Paolo
