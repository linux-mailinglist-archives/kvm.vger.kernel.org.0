Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CA36DD15E
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 07:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjDKFFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 01:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKFE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 01:04:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237121FC1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 22:04:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a52667e35fso4650255ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 22:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681189497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pgg9iBxZJj9AESlGkJWpNG21cI3ZSKa62ycWyjsqGls=;
        b=YlOJ58MIVy10F+LtDaVNYDFo3rBnNpGIsds7p+i4Nm84ZMCjDZTolxvmz0uA4aoCBq
         B6dm/SzF15tFh4EQHeHQlwv8dGkWzwnIFj1wajhfGAdb8wYP6ANkFg+gHtH1ytCtcMrw
         IYeE/9OowKi44v+Opyh7FDJOJZ10gSCaFABpJn2kf+Yj7/uAPhRZu8ZT/j+1bs/ek/3o
         ycCTU+drXe/Gv7SwRa35d/UkR0sp8y35U03GYXMY3KKo27ZUppOvy5UNohvxRKrR314g
         yWGSTojAPmuDS2tU2NBzYiGif9ER7tYniIjJD8vpsjZDc4HqcQszunl8qXUAvipArzB8
         lCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681189497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pgg9iBxZJj9AESlGkJWpNG21cI3ZSKa62ycWyjsqGls=;
        b=ynbfKlyN/fCangLHCJB8lQgH8xMJ6atFec3One2cLBF9gdUS+x7h+NnVEvzbwATkEM
         GpagcNa5yL5+qoxvkX6HA9H2nf9R2FDfsiDqtpWnQrPXHKSszO81pxsVG+IHL9ESuvIM
         ZDOlJqTgIezTUEY8qkXW5lOpJiGsxhwyCzAXyBstXmN+tRGuHc8iUmgn8SM3Aqd+aj/e
         31KhltZ4QChcNLk2zbJI6cBHQRgfqBFDhJ+l0AaDA2KzqxskUu7Hgm4/py4M9gLoIFWV
         y2+L6CdSmvK0+91sUfKszvKSlIdhzAHjR9etvK3Ki6Nw+BKcAg3Ucf2Aihyys4YZWaWH
         aaFw==
X-Gm-Message-State: AAQBX9eEueJba162vgJIK78aQPbLizbdej94PyeCDOnfZYxec2SKcMSY
        EeMwZMCNpTcC/p3SnYIzWQQa4INUjGv1mg==
X-Google-Smtp-Source: AKy350ZxS0HZXvPaMeb4Oe5/wwvBjrq6vgeDrfYpICz5eSV+tiHNSTocsotyXfHuwmDIBoFU8DHosA==
X-Received: by 2002:aa7:9435:0:b0:633:1938:e302 with SMTP id y21-20020aa79435000000b006331938e302mr10126746pfo.18.1681189497569;
        Mon, 10 Apr 2023 22:04:57 -0700 (PDT)
Received: from [172.27.232.2] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id w9-20020a655349000000b0050f85ef50d1sm7916570pgr.26.2023.04.10.22.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 22:04:57 -0700 (PDT)
Message-ID: <c23abfa4-c767-6c95-d14f-f6af8c414692@gmail.com>
Date:   Tue, 11 Apr 2023 13:04:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
References: <20230310125718.1442088-1-robert.hu@intel.com>
 <20230310125718.1442088-3-robert.hu@intel.com> <ZAtW7PF/1yhgBwYP@google.com>
 <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
 <ZBHz7kL7wSRZzvKk@google.com>
 <CA+wubQBDU4y97HrShmn+=0=o0HGwTckU1_y+VJLCuJtf2M+fyw@mail.gmail.com>
 <ZDRW2zvPxa3ekDVv@google.com>
From:   Hoo Robert <robert.hoo.linux@gmail.com>
In-Reply-To: <ZDRW2zvPxa3ekDVv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/11 2:35, Sean Christopherson wrote:
> On Fri, Mar 31, 2023, Robert Hoo wrote:
>> Sean Christopherson <seanjc@google.com> 于2023年3月16日周四 00:36写道：
>>>> Sorry I don't follow you.
>>>> My point is that, given it has passed kvm_is_valid_cr4() (in kvm_set_cr4()),
>>>> we can assert boot_cpu_has(X86_FEATURE_UMIP)  and vmx_umip_emulated() must be
>>>> at least one true.
>>>
>>> This assertion is wrong for the case where guest.CR4.UMIP=0.  The below code is
>>> not guarded with a check on guest.CR4.UMIP.  If the vmx_umip_emulated() check goes
>>> away and guest.CR4.UMIP=0, KVM will attempt to write secondary controls.
>>>
>>
>> Sorry still don't follow you. Do you mean in nested case? the "guest"
>> above is L1?
> 
> Please take the time to walk through the code with possible inputs/scenarios before
> asking these types of questions, e.g. if necessary use a whiteboard, pen+paper, etc.
> I'm happy to explain subtleties and add answer specific questions, but as evidenced
> by my delayed response, I simply do not have the bandwidth to answer questions where
> the answer is literally a trace-through of a small, fully contained section of code.

Sure, fully understand your busyness, thanks for still providing detailed 
explanation. Sorry for the annoyance.

Given that you've merged host UMIP cap check into vmx_umip_emulated(), I 
might have not tangled in this point.

We can close this thread of patch set now.
> 
> 	if (!boot_cpu_has(X86_FEATURE_UMIP)) {    <= evaluates true when UMIP is NOT supported
> 		if (cr4 & X86_CR4_UMIP) {         <= evaluates false when guest.CR4.UMIP == 0
> 			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
> 			hw_cr4 &= ~X86_CR4_UMIP;
> 		} else if (!is_guest_mode(vcpu) || <= evalutes true when L2 is NOT active
> 			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
> 			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC); <= KVM "blindly" writes secondary controls
> 		}
> 	}
