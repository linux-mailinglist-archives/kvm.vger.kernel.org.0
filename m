Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E331710627
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 09:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbjEYHVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 03:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjEYHVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 03:21:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FC419D;
        Thu, 25 May 2023 00:21:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-2553663f71eso819790a91.3;
        Thu, 25 May 2023 00:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684999294; x=1687591294;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xqc0RvBjEqmfMd1qioMCyBJH4DDZdjxzMOj0X5GfsUA=;
        b=gVlD33aFtOvzkcMkjOJ1fIcAsTV+rLJybqU5nLh5n7mK9K/xH9tWAzYgoNQrCpNzQI
         gNdVIfwhcj32Xkr//kBOI/fZwy4qPkJOyjT/ndcJ9rGoHxucTUDOazC6Ff67pLMu4O1g
         Z+1JDlh6ZrD2/nwUI0A8be0EpO0cmc5OSD3C03ecvqVsskQZSWlKofxeU/QnTjQBgTGP
         S8EA8JrG76ODO5Cqe3zWQRvKzhBZIl9kMDrob4qb+c8iRP5IpEjy0MH4czojugLfHVD8
         6+MyRN0ZujXqMbMr+CloWAYSHJWXZ5TGHx3HkVnQFbmsw7RzIQHv0J6x7Fu5MzgU2LBK
         r8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684999294; x=1687591294;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xqc0RvBjEqmfMd1qioMCyBJH4DDZdjxzMOj0X5GfsUA=;
        b=IXxKy33Ln8mNZAWVxuY75ie37+IA/plckL96WoFfsgf2FlvNGt3lH57ISRN/av6Wr9
         aJyCy5axPMwJykxDafRyYHah/abARNlkDJcKskrE+nB8gALk8JqjyYT/No54oSfDon8G
         +b6ZdKy9gtnVc+zfDp/DPoJ1lvfFLQvIw498O1KyiHIKCE4pOZsUHhwQ+hHFL0CdQkb5
         Mkmw+tW/8rr/5dyhN95kVaTZCZ+fotISQAjdcc1//eacZJUVfloCRGF29/hpqyZ4Kvrj
         1uV7lRgk5gU4gQzWsqxrWDWsDXmjvIi+nmm55g1mA4rU91QI5p7qPTf1ututf8ynSCxf
         t8Qg==
X-Gm-Message-State: AC+VfDyvRR/rtZQCg3ktDG9uLuptEH+5bbRp0lK+qMjhnpeyKui0V8rx
        59hzfSlHHhfsiyQnFhCo5ho=
X-Google-Smtp-Source: ACHHUZ5IYbP3gSc5r6+a5rwq/3ZjNdRBiDTIFHh8RjXFUliqBUw8onJAOOk1gJ3maZ3R7QkHFAGCQw==
X-Received: by 2002:a17:90a:9317:b0:253:62c2:4e1b with SMTP id p23-20020a17090a931700b0025362c24e1bmr640751pjo.48.1684999294520;
        Thu, 25 May 2023 00:21:34 -0700 (PDT)
Received: from [172.27.236.17] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id l64-20020a633e43000000b0053ef188c90bsm467964pga.89.2023.05.25.00.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 00:21:34 -0700 (PDT)
Message-ID: <393b16f7-8359-5d77-7d5d-8942de987331@gmail.com>
Date:   Thu, 25 May 2023 15:21:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/2023 2:21 PM, Yan Zhao wrote:
[...]
> Yes, leaving each vCPU's MTRR to mimic HW.
> 
> As also suggested in SDM, the guest OS manipulates MTRRs in this way:
> 
> for each online CPUs {
> 	disable MTRR
> 	update fixed/var MTRR ranges
> 	enable MTRR
> }
> Guest OS needs to access memory only after this full pattern.
> 
Thanks for confirmation and clarification.

> So, I think there should not have "hazard of inconsistency among per-VPU MTRR
> states".
> 
> I want to have per-VM MTRR state is because I want to reduce unnessary EPT
> zap, which costs quite a lot cpu cycles even when the EPT is empty.
> 
> In this patch, per-VM MTRR pointer is used to point to vCPU 0's MTRR state,
> so that it can save some memory to keep the MTRR state.
> But I found out that it would only work when vCPU 0 (boot processor) is
> always online (which is not true for x86 under some configration).
> 
> I'll try to find out lowest online vCPU and keep a per-VM copy of MTRR state
> in next version.
> 
> Thanks!
> 

IIUC, your saving comes from skips the intermediate state during boot, when 
APs goes through setting MTRR, which would cause SPTE zap before your this 
patch set.

MHO was, now that your ignores other vCPU's MTRR settings (unless it is 
different from BP's MTRR?), why not let each vCPU's MTRR set/update 
directly set to the per-VM MTRR states (if differs from current value). 
It's guest OS/BIOS's responsibility to keep the consistency anyway. And 
even if the malfunction caused by the inconsistency might differ from that 
of native, SDM doesn't clearly state how the malfunction should be, does it?
that's to say, anyone knows, when inconsistency happens, does it cause that 
logical processor malfunction or in fact it impacts the global MTRR 
settings? If the latter, I think leaving only the per-VM MTRR state aligns 
with native.

BTW, with regard to KVM_X86_QUIRK_CD_NW_CLEARED, I see svm honors it while 
vmx doesn't before it clear CR0.CD/NW.

svm_set_cr0():

	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
		hcr0 &= ~(X86_CR0_CD | X86_CR0_NW);


vmx_set_cr0():

	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);

Perhaps vmx side can be fixed passingly?
