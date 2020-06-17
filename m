Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7971FD348
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 19:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgFQRRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 13:17:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56014 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726511AbgFQRRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 13:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592414269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syoG//epP3bFi8zAl2b0mjdOvXOrZ7ZffbKVm7T0ZmA=;
        b=Obwy1UBvMOHyI4x37DeQuMG1SSATmGC5eEjUsQfCykBEbBJvUZYtxsqVSeqWpu2WzeNm+E
        Jhu3ys6RqcvLSwAwNk5E7jcYfa6Hu7quhAFgcPBSn8WjrUx9/KzIAMYEBGnqi04tgQbNl0
        1JxhH9wNByhbjMxXcN+76VoqVRCOCc4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-mI3dt4dONP-4rl-qJoKo2Q-1; Wed, 17 Jun 2020 13:17:47 -0400
X-MC-Unique: mI3dt4dONP-4rl-qJoKo2Q-1
Received: by mail-wm1-f71.google.com with SMTP id c4so1507797wmd.0
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 10:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=syoG//epP3bFi8zAl2b0mjdOvXOrZ7ZffbKVm7T0ZmA=;
        b=Aws5mDtq29NltSJEYVni0Y+cQXla7f3gmPN6dWRsHumyk2wGkHVJGw0rxPGz3uu2Iv
         4qz/bcKAOrY3RSIuMtwr8d/XYQl6+IhrB9rRru6SS0E8aHb737ElGMbm9tOgL1xLWs2r
         82gkPbyd101Oh8tufBR9H4d9mAxobTvXeUqpNDe+buAe9bfeBJQp1fUMZ/e4Q2u+Kz7t
         Qn/XA9fQm7kPJ1LunEm4Iu39bD1uwoOtPORNmyGIKS99bYbu+dWAWTx9gvWYnT36X7/0
         OSOyj04mIRsoGdNhNUwfd8KtqKNbY4SCufXrVv6iOLYHDlI0kIGfB8/ao+fw19knLSAN
         i13Q==
X-Gm-Message-State: AOAM531bKjKZF8MgA9t37NiFWeZ97Qcocwd6Nu0LE0rqQb0MJsJDsKhn
        43x8y7UiJ8lZzJ6LrQQ8XmnmZGgqKYCyJDj09JSER3f7hdhz/ttvSJzLk7t9w9Nez7EPs8oA7+F
        5gqQkHUSfcdjB
X-Received: by 2002:a1c:e40a:: with SMTP id b10mr9258256wmh.41.1592414266541;
        Wed, 17 Jun 2020 10:17:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLVxP68bp+s83lap0HNMsWZSZhomS98RZJPhW0GgtvOxsW+p3Qva87d7QFsCgkfzvuBpUIIw==
X-Received: by 2002:a1c:e40a:: with SMTP id b10mr9258238wmh.41.1592414266343;
        Wed, 17 Jun 2020 10:17:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:48a4:82f8:2ffd:ec67? ([2001:b07:6468:f312:48a4:82f8:2ffd:ec67])
        by smtp.gmail.com with ESMTPSA id 23sm464714wmg.10.2020.06.17.10.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 10:17:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated
 MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200616161427.375651-1-vkuznets@redhat.com>
 <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com>
 <87366vhscx.fsf@vitty.brq.redhat.com>
 <CALMp9eQ1qe4w5FojzgsUHKpD=zXqen_D6bBg4-vfHa03BdomGA@mail.gmail.com>
 <87wo45hqhy.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <36ebc576-52c0-4164-1c83-e31146806b6b@redhat.com>
Date:   Wed, 17 Jun 2020 19:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87wo45hqhy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 13:38, Vitaly Kuznetsov wrote:
> 
> For KVM_GET_MSR_INDEX_LIST, the promise is "guest msrs that are
> supported" and I'm not exactly sure what this means. Personally, I see
> no point in returning MSRs which can't be read with KVM_GET_MSRS (as
> this also means the guest can't read them) and KVM selftests seem to
> rely on that (vcpu_save_state()) but this is not a documented feature.

Yes, this is intended.  KVM_GET_MSR_INDEX_LIST is not the full list of
supported MSRs or KVM_GET_MSRS (especially PMU MSRs are missing) but it
certainly should be a sufficient condition for KVM_GET_MSRS support.

In this case your patch is sort-of correct because AMD machines won't
have X86_FEATURE_PDCM.  However, even in that case there are two things
we can do that are better:

1) force-set X86_FEATURE_PDCM in vmx_set_cpu_caps instead of having it
in kvm_set_cpu_caps.  The latter is incorrect because if AMD for
whatever reason added it we'd lack the support.  This would be basically
a refined version of your patch.

2) emulate the MSR on AMD too (returning zero) if somebody for whatever
reason enables PDCM in there too: this would include returning it in
KVM_GET_FEATURE_MSR_INDEX_LIST, and using kvm_get_msr_feature to set a
default value in kvm_pmu_refresh.  The feature bit then would be
force-set in kvm_set_cpu_caps.  This would be nicer since we have the
value in vcpu->arch already instead of struct vcpu_vmx.

Thanks,

Paolo

