Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39024D2038
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349670AbiCHS0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349684AbiCHS0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:26:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 496855A5B0
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646763902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZ+MOQYbd1Rp6Gp+T3LRIYK4uicgM63eg0ziCWnS/Qw=;
        b=ejh4gbr1QqL9b5MjWEVwS0j8Vy3SD/5ftER6MWQt2eJArdo9F4zgF43zfloDAt3fB+Ue9z
        orkOuDsb9BGXJ3df7J96Ry8VAD6HalST6Nn9dhDxbshkX8SM7RK8phem+oeYi/jxdbn0HX
        Wjk69MmVJZDlrEAqZkn75ZDmpQY+d2U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-PLciPFX6OKCDwvrnHhyPAQ-1; Tue, 08 Mar 2022 13:25:01 -0500
X-MC-Unique: PLciPFX6OKCDwvrnHhyPAQ-1
Received: by mail-ed1-f70.google.com with SMTP id o20-20020aa7dd54000000b00413bc19ad08so11103756edw.7
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:25:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KZ+MOQYbd1Rp6Gp+T3LRIYK4uicgM63eg0ziCWnS/Qw=;
        b=MsK/RhAuLLmxM6IxHcObhA1BJRceMHkHUQt/OJShzDZp0rnLjecdkZtDRYW1qYP6Au
         rc/zP+LSKKC1XNLebyut1eP3U8sYizP1OMN+XYoqQOCBL0sSKCNMZPzEaaIhTmJh+nNG
         1Ovuf/8c+PzWBUMDdt/XKFB4KfeasYqwd3q/PG49SPsEozdMKkADHJ5bMfqJXFYyWoWA
         aserrK/W4nj0eykY/BEy7NEE/Mg4n0aEgXN8KaWBr9moZnbTwkkKxM/JqYr5DBrj0yOW
         QYH6HQZlCTsxKVjzS0dGF/FP/Kupbfl4vRrXTVdpK7OFmvW6AIBu5XZ0dXH67NVrWkoP
         CPPA==
X-Gm-Message-State: AOAM532yjVEzF4WO9whXVlpV4+Xq8tHE02g12bKg1XTcFI+/Uq9PY1sZ
        QA76M/758wutHRSQoksJ+kzwPj3043CdmkHbl//54MrmippRiqWRJ2JKXRUsIBYfTdAEKWUzzj6
        xDr7rltjw7WT3
X-Received: by 2002:a17:907:72c3:b0:6ce:5256:1125 with SMTP id du3-20020a17090772c300b006ce52561125mr14895551ejc.697.1646763899847;
        Tue, 08 Mar 2022 10:24:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB9CUG4fE5I7TiF2MAdAzCHuxCgwLRBMpkZ1jZw+WDQfIRwTmu0Kmjod9AzZ734Y7mIgjMQQ==
X-Received: by 2002:a17:907:72c3:b0:6ce:5256:1125 with SMTP id du3-20020a17090772c300b006ce52561125mr14895544ejc.697.1646763899602;
        Tue, 08 Mar 2022 10:24:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm6194177ejt.108.2022.03.08.10.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 10:24:59 -0800 (PST)
Message-ID: <2e6c4c58-d4d2-69e2-f8ed-c93d9c13365b@redhat.com>
Date:   Tue, 8 Mar 2022 19:24:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 12/25] KVM: x86/mmu: cleanup computation of MMU roles
 for two-dimensional paging
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-13-pbonzini@redhat.com> <YiecYxd/YreGFWpB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiecYxd/YreGFWpB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 19:11, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Paolo Bonzini wrote:
>> Extended bits are unnecessary because page walking uses the CPU mode,
>> and EFER.NX/CR0.WP can be set to one unconditionally---matching the
>> format of shadow pages rather than the format of guest pages.
> 
> But they don't match the format of shadow pages.  EPT has an equivalent to NX in
> that KVM can always clear X, but KVM explicitly supports running with EPT and
> EFER.NX=0 in the host (32-bit non-PAE kernels).

In which case bit 2 of EPTs doesn't change meaning, does it?

> CR0.WP equally confusing.  Yes, both EPT and NPT enforce write protection at all
> times, but EPT has no concept of user vs. supervisor in the EPT tables themselves,
> at least with respect to writes (thanks mode-based execution for the qualifier...).
> NPT is even worse as the APM explicitly states:
> 
>    The host hCR0.WP bit is ignored under nested paging.
> 
> Unless there's some hidden dependency I'm missing, I'd prefer we arbitrarily leave
> them zero.

Setting EFER.NX=0 might be okay for EPT/NPT, but I'd prefer to set it 
respectively to 1 (X bit always present) and host EFER.NX (NX bit 
present depending on host EFER).

For CR0.WP it should really be 1 in my opinion, because CR0.WP=0 implies 
having a concept of user vs. supervisor access: CR0.WP=1 is the 
"default", while CR0.WP=0 is "always allow *supervisor* writes".

>> even if only barely so, due to SMM and guest mode; for consistency,
>> pass it down to kvm_calc_tdp_mmu_root_page_role instead of querying
>> the vcpu with is_smm or is_guest_mode.
> 
> The changelog should call out this is a _significant_ change in behavior for KVM,
> as it allows reusing shadow pages with different guest MMU "role bits".

Good point!  It's safe and arguably clea{n,r}er, but it's still a pretty 
large change.

> E.g. if this lands after the changes to not unload MMUs on cr0/cr4
> emulation, it will be quite the functional change.
I expect this to land first, so that the part where we don't really 
agree on the implementation comes last and benefits from a more 
understandable core.

Paolo

