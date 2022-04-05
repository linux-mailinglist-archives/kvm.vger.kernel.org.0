Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8BB4F4997
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442958AbiDEWUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446290AbiDEPo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:44:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873EF4E;
        Tue,  5 Apr 2022 07:13:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so1758569wme.0;
        Tue, 05 Apr 2022 07:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+obo3dTEvSnGwmrHTDGj7IsutLaAztXJd9lK133Uuvo=;
        b=VfYxeW309B7qGu5esco2QMkFCu6G6mGgJZ/7v8UJu4M3oqeTqLdCKy+aQe2MCk7aMO
         kMEbJrfpFmDIoqqmXEHM59o6bABYuWObSqmDEae2x33PnucQV4FLMP4dzti02kwmj16w
         Mi+f22V0Fo38phqCCyN1uib5VBjnpc4qiJHd7UpVqU2QJqWCF+MzPB53V6j7v3K4PgDS
         jEhde1If7rpH2oZQ4zWvTsFrR7kMoiXns+bzZ7Ir5ppm+1rBWQVEQznuQWv4Y3EesLHW
         TxVy/QJsb/wO9Xc+h3lcNoySiXAg7iH6z834ZpXcL2pGo5mzQyyhDmciuc6dJvXNEEV2
         GU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+obo3dTEvSnGwmrHTDGj7IsutLaAztXJd9lK133Uuvo=;
        b=2SRcwYRL20JefCtUvoxJ5wH6USX9NQcVU/6I2U3SBR7RqOxJoFI5sB2VQQmKTRU4n0
         s4+dUNviplt6pun83JzNWPHJlpHWu8oIDYfROqziJJuT1nZc/MC/H0FyG9hqQgdyh3up
         /LI63tz0F2Hp6JqU/2C2BgIvr5euAP4rnUlz+Ca4JOw5QYSd1AyPpkTe46wIYmHLgFJ3
         HD6ozh9rXS6jN05kMZhp03NzBKM3ZnOc0N6r/1UjhexYSLOzIxiyKbxG0LMpK+wDiEC2
         CeT/BVAbcPH4LDweTWmuxCqnMd+80UI+/07Quz0h7AAj1jzRPUbNaDYlnUijY9pYVQ1E
         w0YQ==
X-Gm-Message-State: AOAM5307FeNzsOsgV6fbrZ67YKmceo5vLP1qq/JdN+6cFzrYtzRbURaM
        ejy+AQl6155uXun0MI+M8UY=
X-Google-Smtp-Source: ABdhPJx9lAFWKFLwVX4uuRpIb/oQ+eh5zJKhmje6V6snh6ssBRmVU4vm5p55cuHnRNjRe+OFr82cSw==
X-Received: by 2002:a05:600c:3c9b:b0:38e:4c59:68b9 with SMTP id bg27-20020a05600c3c9b00b0038e4c5968b9mr3333948wmb.105.1649168014583;
        Tue, 05 Apr 2022 07:13:34 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p18-20020a1c5452000000b0038e70261309sm2347702wmi.1.2022.04.05.07.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:13:34 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <9dfc44d6-6b20-e864-8d4f-09ab7d489b97@redhat.com>
Date:   Tue, 5 Apr 2022 16:13:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
 <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 07:13, Kai Huang wrote:
>> @@ -617,9 +617,9 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>>   	int level = sptep_to_sp(sptep)->role.level;
>>   
>>   	if (!spte_has_volatile_bits(old_spte))
>> -		__update_clear_spte_fast(sptep, 0ull);
>> +		__update_clear_spte_fast(sptep, shadow_init_value);
>>   	else
>> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
>> +		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);

(FWIW this one should also assume that the init_value is zero, and WARN 
if not).

> I guess it's better to have some comment here.  Allow non-zero init value for
> shadow PTE doesn't necessarily mean the initial value should be used when one
> PTE is zapped.  I think mmu_spte_clear_track_bits() is only called for mapping
> of normal (shared) memory but not MMIO? Then perhaps it's better to have a
> comment to explain we want "suppress #VE" set to get a real EPT violation for
> normal memory access from guest?
> 
>>   
>>   	if (!is_shadow_present_pte(old_spte))
>>   		return old_spte;
>> @@ -651,7 +651,7 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>>    */
>>   static void mmu_spte_clear_no_track(u64 *sptep)
>>   {
>> -	__update_clear_spte_fast(sptep, 0ull);
>> +	__update_clear_spte_fast(sptep, shadow_init_value);
>>   }
> Similar here.  Seems mmu_spte_clear_no_track() is used to zap non-leaf PTE which
> doesn't require state tracking, so theoretically it can be set to 0.  But this
> seems is also called to zap MMIO PTE so looks need to set to shadow_init_value.
> Anyway looks deserve a comment?
> 
> Btw, Above two changes to mmu_spte_clear_track_bits() and
> mmu_spte_clear_track_bits() seems a little bit out-of-scope of what this patch
> claims to do.  Allow non-zero init value for shadow PTE doesn't necessarily mean
> the initial value should be used when one PTE is zapped. Maybe we can further
> improve the patch title and commit message a little bit.  Such as: Allow non-
> zero value for empty (or invalid?) PTE? Non-present seems doesn't fit here.

I think shadow_init_value is not named well.  Let's rename it to 
shadow_nonpresent_value, and the commit to "Allow non-zero value for 
non-present SPTE".  That explains why it's used for zapping.

Paolo
