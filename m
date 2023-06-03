Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278E5720CBF
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 02:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjFCAzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 20:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbjFCAzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 20:55:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0A0E72;
        Fri,  2 Jun 2023 17:55:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2566ed9328eso2258277a91.2;
        Fri, 02 Jun 2023 17:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685753704; x=1688345704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TT8sByaX2hXluUvmdoPcZkl5zm6gea8dxZyBG7LDTT4=;
        b=pBIdRXXzXxmm1GgW1IMNRd1w2xaGM5JinI+w/BMUwGPsYorIhn3nIz/bzPRmPtP+Mc
         k3CPPAliHbZhZCAr3LO6S70DS1pcOFjCFgSl1kaf5M/IpUZ+s3L2nPfJC6Dm4vf5/TQI
         J3Pv5m//kDG6XeyiH1w7mgcf3fvMX10O8Jr1n/gQoc2wTghr3B3snumEMmbbr/XZWFuU
         4nav33qwWttnl1MmgjdrXtViWGzPxhkg9HNIp1vnNxOycCNaaPW6wCmGg1mdNcFdwQyD
         VzFxq1O9s4iWhwpki+42aszbbciU4tpzjh0DYqssGiE02DGGLs6c1o0T60cd0GXWkzQl
         oxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685753704; x=1688345704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TT8sByaX2hXluUvmdoPcZkl5zm6gea8dxZyBG7LDTT4=;
        b=finVQhi+R3td1ucCVptEu/kEqzn6RN5jJrdW4+BbkmI9bcBEFbKdIZy1P2SVQgRJLh
         KHAcZT9NcNnIUcZK2GMcb75t8izQEeT22A9OCqEaORto3V5iYcMvZf1Li5EDRvgh6u/K
         lt+d68DtGUxtAYkGnOa9QFJHuaieQsSaIqzRNVkm1OULtSi5+Ni8Sz2/JgGEKZEFule1
         wMoY/PE1CElz4xeeXp32zrni6/xSXxpSEe/LHhnDeK4EWshJYlnow36VnWIRsEJkY8gN
         XK5tjRDPHNyj/0ZUb9tTthj0rvnU4yV0Plq6+q3yOtiO9iX48+IfegUNilZmuTDy8l0K
         Bl9Q==
X-Gm-Message-State: AC+VfDzEgc4ldbG46bD/zfmyk94YER129mv8M+VDnShLwpq2W6AaOJCG
        hjr11Is+4J09WtEPOvqYGYU=
X-Google-Smtp-Source: ACHHUZ51XpGEFG4JCY/JreOyiuvqdccFMUfv/AJeWksTvWYgMj/wS4NTF6MDMm5nPC+AAdZVhWBgJw==
X-Received: by 2002:a17:90a:77c3:b0:253:5728:f631 with SMTP id e3-20020a17090a77c300b002535728f631mr1475467pjs.15.1685753703863;
        Fri, 02 Jun 2023 17:55:03 -0700 (PDT)
Received: from [172.27.232.92] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2ac900b00247150f2091sm3931862pjg.8.2023.06.02.17.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 17:55:03 -0700 (PDT)
Message-ID: <79f3ab2e-ffff-0733-00bb-bab79a51b1e7@gmail.com>
Date:   Sat, 3 Jun 2023 08:54:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Kai Huang <kai.huang@intel.com>
References: <20230602005859.784190-1-seanjc@google.com>
 <28bd9d11-282f-bb22-66f5-d3d9165d4adf@gmail.com>
 <ZHoGEwFqx3kJrmJe@google.com>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZHoGEwFqx3kJrmJe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2023 11:09 PM, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Robert Hoo wrote:
>> On 6/2/2023 8:58 AM, Sean Christopherson wrote:
>>> @@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>>>    	bool old_val = nx_huge_pages;
>>>    	bool new_val;
>>> +	if (nx_hugepage_mitigation_hard_disabled)
>>> +		return -EPERM;
>>> +
>>>    	/* In "auto" mode deploy workaround only if CPU has the bug. */
>>> -	if (sysfs_streq(val, "off"))
>>> +	if (sysfs_streq(val, "off")) {
>>>    		new_val = 0;
>>> -	else if (sysfs_streq(val, "force"))
>>> +	} else if (sysfs_streq(val, "force")) {
>>>    		new_val = 1;
>>> -	else if (sysfs_streq(val, "auto"))
>>> +	} else if (sysfs_streq(val, "auto")) {
>>>    		new_val = get_nx_auto_mode();
>>> -	else if (kstrtobool(val, &new_val) < 0)
>>> +	} else if (sysfs_streq(val, "never")) {
>>> +		new_val = 0;
>>> +
>>> +		mutex_lock(&kvm_lock);
>>> +		if (!list_empty(&vm_list)) {
>>> +			mutex_unlock(&kvm_lock);
>>> +			return -EBUSY;

Ah, right, thanks for explanation.

Reviewed-by: Robert Hoo <robert.hoo.linux@gmail.com>

>>> +		}
>>> +		nx_hugepage_mitigation_hard_disabled = true;
>>> +		mutex_unlock(&kvm_lock);
>>> +	} else if (kstrtobool(val, &new_val) < 0) {
>>>    		return -EINVAL;
>>> +	}
>>>
>>
>> IIUC, (Initially) "auto_off"/"off" --> create some VM --> turn to "never",
>> the created VMs still have those kthreads, but can never be used, until
>> destroyed with VM.
> 
> Shouldn't be able to happen.  The above rejects "never" if vm_list isn't empty,
> i.e. if there are any VMs, and sets nx_hugepage_mitigation_hard_disabled under
> kvm_lock to ensure it can't race with KVM_CREATE_VM.  I forgot to call this out
> in the changelog though
