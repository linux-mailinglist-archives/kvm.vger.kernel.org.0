Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792E74E7224
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbiCYL2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 07:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355705AbiCYL2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 07:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D03BF70CFE
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 04:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648207629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxKFEDtkVHDp152TUqHwV7Qynzuw7D2VF2jr802SS7Q=;
        b=gpqpsAinES3ok3tUr/nYXI3URJT7D9uFhcMcXT5dUZuH07yk2YQZvVFFkWQ/m+M0yNmHc9
        YejehRsUu96kuVWTnNPxz6iqpsN9v+AZe2wiDgpvpPjecC9hOZj56ZZ9Siwiz09bR5R0qu
        ckD9enZTvYPrjW2uv59Dul4/k1b0JUE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-ft6Y-XdWNc2gNyWNb3iGIw-1; Fri, 25 Mar 2022 07:27:05 -0400
X-MC-Unique: ft6Y-XdWNc2gNyWNb3iGIw-1
Received: by mail-ed1-f71.google.com with SMTP id j39-20020a05640223a700b0041992453601so2490597eda.1
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 04:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sxKFEDtkVHDp152TUqHwV7Qynzuw7D2VF2jr802SS7Q=;
        b=w66HVobWRHdnJ2O7YGct4XW1gIjH6T2ITQl4VL51K61woh31Br7mUPJwPCjN+wzGAE
         T3EHv2joqCjY+nox09UBaG4Ldd6N8dSNdcXE3DvFWlVSWLARoz1fQwfpXFnFhgHGEptR
         A6sUdyDXlFiZwvuuGPyswpX3VHxCjEpjJsdSyjZQALDWGbDCYmhbG4sV6mV7dUKf3dps
         j0MQgkAsoPKkqlbasnedpfwkbJf2S2ealfaPttNqsRDBFxQTns2LTQNu1djvMIoSZVuH
         5jXpQBriKoPi41IwQtkEySfW5FpxZMNNexZFCWkQPYH61YeFPFuUqaPyPQAWWT5t9l5l
         btiA==
X-Gm-Message-State: AOAM5337xXs6E/gW/8enUlAUxgdRHJclljFZu9SgC9dKDX3RW38+zosd
        fovGR/eLFXOzZYDo15HyI1rFzp3Rk+mlhxL1fSiEGS5ohcw3wlN0ZFytPAk8SundO/mXh0jy3V7
        9SwEsenT1KRsS
X-Received: by 2002:a17:906:4ad0:b0:6e0:12aa:a911 with SMTP id u16-20020a1709064ad000b006e012aaa911mr11177153ejt.455.1648207624527;
        Fri, 25 Mar 2022 04:27:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdxZ6Dd1obUVVjmdWCRsGy/xGG5OGJ84RjwzSYKCiseyMLFhRU7VOvhU2RHoakRMd321PrXw==
X-Received: by 2002:a17:906:4ad0:b0:6e0:12aa:a911 with SMTP id u16-20020a1709064ad000b006e012aaa911mr11177120ejt.455.1648207624243;
        Fri, 25 Mar 2022 04:27:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id bm23-20020a170906c05700b006d597fd51c6sm2254888ejb.145.2022.03.25.04.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 04:27:03 -0700 (PDT)
Message-ID: <c7309380-c7d5-419d-6ba5-25d3243c469b@redhat.com>
Date:   Fri, 25 Mar 2022 12:26:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/mmu: Don't rebuild page when the page is synced
 and no tlb flushing is required
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        linux-kernel@vger.kernel.org
References: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
 <YjzRwDSPQNbpTrZ9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjzRwDSPQNbpTrZ9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/22 21:17, Sean Christopherson wrote:
>> +static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>   			 struct list_head *invalid_list)
>>   {
>>   	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
>>   
>> -	if (ret < 0) {
>> +	if (ret < 0)
>>   		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
>> -		return false;
>> -	}
>> -
>> -	return !!ret;
>> +	return ret;
> Hrm, this creates an oddity in mmu_sync_children(), which does a logical-OR of
> the result into a boolean.  It doesn't actually change the functionality since
> kvm_mmu_remote_flush_or_zap() will prioritize invalid_list, but it's weird.
> 
> What about checking invalid_list directly and keeping the boolean return?  Compile
> tested only.

It's even better to check

         flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;

in mmu_sync_children.  If the returned value is <0, then the page is 
added to invalid_list and there is no need to set flush = true, just 
like there is no need to call kvm_flush_remote_tlbs() in kvm_mmu_get_page().

Paolo

