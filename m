Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B807458A48A
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 03:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiHEBiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 21:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiHEBiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 21:38:08 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4625925280
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 18:38:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q19so1017866pfg.8
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 18:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=0MC1aXXFD/F2RPwWLCHQLk9Dvj9n5nCe2dAeJt1lCvc=;
        b=mHxfnb623YTuRDCkGD2YyZh3LjVirSIVowfr2kztFpBE1eXvjQkGzvR/xUS8KrSWsG
         4SJNEUEBjl9Mt7TuCTufeJoIzlkArd2+zNClK+aTBO4zNUC7Gfw46Dn4v9Jbd8PMSjxL
         QtGjLVLRzLCUW+7HHXdUB8TTYiV9T3VVyNBHRdXCC+qvrLJN+JQv4GoVc7wDQT0Ws1Pb
         9JFc/dyDzxK56FstA62UwBSITlOzpoG+DDDCpBqWPtx1/e1YKXPmUaDGWgbAw8dWz1tS
         +plxbMK7A1PtvyuEMAYUrknw556W8UdlZP6EQAUrv4dQWN+VgxIGfmvVjxg66bQvOwyZ
         EFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=0MC1aXXFD/F2RPwWLCHQLk9Dvj9n5nCe2dAeJt1lCvc=;
        b=oEc7EkmJrVj01E7AW5v56jc35MWmKmufsdmhg8I7UZ1BlBbQ0eqnzOW9AFYsKQMVCj
         p1ABG/sRQVi3bSeL4G+QjwLKoCnUOZ4GaG7l7OV+o/wO2Pago46YyTRmF4Csc0BVROfe
         L6QYJffTqv5/j7N1/U91mM7UPYCWqPUPKbtoJlLXnC29rhxowdpt2AWN35tjA0aLPFzy
         yqubvOhagGQbY7LD8mo3K8NK3Lvg31giHbhcTnTLThKfHK5AP7zPkCiYx6qvYP948gsh
         GhDRQmnXpu9GLCC9cVCXLnSLaSSkzEm4u4fXbYTs2pf/QLNsR6GAHZNh8P1diJJoLaHL
         8UfA==
X-Gm-Message-State: ACgBeo1giO4OwCtc0mpk/yr3knQwqe92Ri9E3eySiWXuYDeSmwAdco6R
        CkqgTe1v5Zuc2kPzYoQslVyVIMNbLLi9vA==
X-Google-Smtp-Source: AA6agR4SLkDbWNpukm6uHa55YA7IIf7ubK7Zy14dOxQjL5V9KocDJcj5gd60DRgTiS0cahh+LT1ioQ==
X-Received: by 2002:a05:6a00:1a94:b0:52b:21a0:afbc with SMTP id e20-20020a056a001a9400b0052b21a0afbcmr4404829pfv.13.1659663486714;
        Thu, 04 Aug 2022 18:38:06 -0700 (PDT)
Received: from [10.76.15.169] ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id l10-20020a63da4a000000b0041c79a5f443sm503186pgj.9.2022.08.04.18.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 18:38:05 -0700 (PDT)
Message-ID: <3e59abfe-de87-ab99-d52b-6e8aced6c5d5@bytedance.com>
Date:   Fri, 5 Aug 2022 09:32:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Re: PING: [PATCH] KVM: HWPoison: Fix memory address&size during
 remap
Content-Language: en-US
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>
References: <20220420064542.423508-1-pizhenwei@bytedance.com>
 <527342ea-ad25-6f66-169d-912a6d75ae54@bytedance.com>
 <713249DB-CCBE-402D-96CE-447250FFDA42@nutanix.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <713249DB-CCBE-402D-96CE-447250FFDA42@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Could you please give me any hint about this issue & patch?


On 8/4/22 14:59, Eiichi Tsukata wrote:
> Hi
> 
> We’ve also hit this case.
> 
>> On May 5, 2022, at 9:32, zhenwei pi <pizhenwei@bytedance.com> wrote:
>>
>> Hi, Paolo
>>
>> I would appreciate it if you could review patch.
>>
>> On 4/20/22 14:45, zhenwei pi wrote:
>>> qemu exits during reset with log:
>>> qemu-system-x86_64: Could not remap addr: 1000@22001000
>>> Currently, after MCE on RAM of a guest, qemu records a ram_addr only,
>>> remaps this address with a fixed size(TARGET_PAGE_SIZE) during reset.
>>> In the hugetlbfs scenario, mmap(addr...) needs page_size aligned
>>> address and correct size. Unaligned address leads mmap to fail.
> 
> As far as I checked, SIGBUS sent from memory_failure() due to PR_MCE_KILL_EARLY has aligned address
> in siginfo. But SIGBUS sent from kvm_mmu_page_fault() has unaligned address. This happens only when Guest touches
> poisoned pages before they get remapped. This is not a usual case but it can sometimes happen.
> 
> FYI: call path
>         CPU 1/KVM-328915  [005] d..1. 711765.805910: signal_generate: sig=7 errno=0 code=4 comm=CPU 1/KVM pid=328915 grp=0 res=0
>         CPU 1/KVM-328915  [005] d..1. 711765.805915: <stack trace>
>   => trace_event_raw_event_signal_generate
>   => __send_signal
>   => do_send_sig_info
>   => send_sig_mceerr
>   => handle_abnormal_pfn
>   => direct_page_fault
>   => kvm_mmu_page_fault
>   => kvm_arch_vcpu_ioctl_run
>   => kvm_vcpu_ioctl
>   => __x64_sys_ioctl
>   => do_syscall_64
> 
> 
> In addition, aligning length suppresses the following madvise error message in qemu_ram_setup_dump():
> 
>    qemu_madvise: Invalid argument
>    madvise doesn't support MADV_DONTDUMP, but dump_guest_core=off specified
> 
> 
> Thanks
> 
> Eiichi

-- 
zhenwei pi
