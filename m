Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF2711D12
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbjEZBts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 21:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZBtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 21:49:47 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885B3189;
        Thu, 25 May 2023 18:49:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-53202149ae2so115128a12.3;
        Thu, 25 May 2023 18:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685065786; x=1687657786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=isqQBR+LcWlcVRH5HFBLQWkUaienYbAAAetyeIPDhls=;
        b=k2dzm5yzkCF4Rc7qVxjzw78OcNbInMHg8ZVFXrtpvi04aTUXF6NXmNooTQIlp1lVgM
         hY4RruhfFdJiSRHiIiJnOzrLVxthQR5lB/6sUgJKGG47Cn6JPu/yQYiA9D3CRQqd2baO
         0sgMSdphtLcVhgB/o/MJorMxe+CdUboiX+MVNbBqexRjmL7SS44CaWb2r33640lOTEE7
         kFxsnyoLISGHAtIVPWq0KnihtcoYKDMUUhIEsGHIFeW5FjlqZc7c5bLbZpXFtDgCxBHh
         2xb3UBd53g2wDuP/ivdKo6CwMmvUFdHkvY/vp69UAneTs231rjZJxKWguaLcHdwrmUEm
         axCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685065786; x=1687657786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isqQBR+LcWlcVRH5HFBLQWkUaienYbAAAetyeIPDhls=;
        b=MybFpu/Vxu9x8mMyxmkY99wy96tn6b/Uz7FFLcGxwzzA/K7QtaX2G8HJPmlGrBxjaA
         3pxPzM/fBVDtO01NbQIvyylRTe8adYeT93oiZs9kRvbIraQpAk7bs7Es8RgWI9aaMvbE
         3QsGTttlRF9CB7wQpcvitwTF5r0XZtspHpGJqAzqGFdVwUmRgN2SpfwskHgFi6joRmth
         wfPOUeWjwYYrpKlUunRAwVvWkdz0qBVLgmCC/cGUHKOjhxdbL7J9vNHDH65bmWnNWKhp
         VmA9nqY7kqm6zlqSx+3OpUlKG10fsxvavVPLEmJQf3FCt9eSWwC6AWYLdVeLQhH6hYHc
         pmMQ==
X-Gm-Message-State: AC+VfDzZs87j35LyS0SpBjoD3gZUEP6o0RkFVE5V5AnfwiTpnLT8mPKF
        SKm3H4E8fniBih/Fke7YY+M=
X-Google-Smtp-Source: ACHHUZ7qbsvJNn8QDeJJCs5gnBHMCXRdl2DwncOu4TEkMeQtqXDQ4W2J75wich3JreZHQXHw4yhe8Q==
X-Received: by 2002:a17:902:8603:b0:1ab:1355:1a45 with SMTP id f3-20020a170902860300b001ab13551a45mr718292plo.30.1685065785844;
        Thu, 25 May 2023 18:49:45 -0700 (PDT)
Received: from [172.27.232.70] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id bg4-20020a1709028e8400b001a9873495f2sm1997572plb.233.2023.05.25.18.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 18:49:45 -0700 (PDT)
Message-ID: <4dc14170-8e22-9da7-30ec-a5597acf1f8e@gmail.com>
Date:   Fri, 26 May 2023 09:49:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <393b16f7-8359-5d77-7d5d-8942de987331@gmail.com>
 <ZG94Kmb8jMZKhtJW@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZG94Kmb8jMZKhtJW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2023 11:00 PM, Sean Christopherson wrote:
[...]
> The MTRRs are not system wide or per-package though, they are per logical CPU.
> Yes, they "need" to be consistent with respect to one another, but only when the
> CPU is actually accessing memory.  This is a big reason why trying to track MTRRs
> as a per-VM asset in KVM is so difficult/messy.  Software doesn't rendezvous all
> CPUs and then do the write on just one CPU, each CPU does its own writes more or
> less independently.

Ah, got it, thanks!

(Some things of each logical processor seems just a shadow of an 
consolidate global one, e.g. CR0.CD. Some things are really separated 
setting of each logical processor, e.g. MTRR above. Really unfathomable 😅)
> 
>> BTW, with regard to KVM_X86_QUIRK_CD_NW_CLEARED, I see svm honors it while
>> vmx doesn't before it clear CR0.CD/NW.
>>
>> svm_set_cr0():
>>
>> 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>> 		hcr0 &= ~(X86_CR0_CD | X86_CR0_NW);
>>
>>
>> vmx_set_cr0():
>>
>> 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
>>
>> Perhaps vmx side can be fixed passingly?
> 
> Sadly, no.  SVM and VMX manage guest memtype completely differently.  VMX doesn't
> allow CR0.CD=1 when VMX is enabled, and so KVM needs to emulate CR0.CD via the EPT
> memtype.

OK, get it, thanks. Wasn't aware of this through SDM.
