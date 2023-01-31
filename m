Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849E16827D3
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjAaI6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjAaI6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:58:25 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD755143F;
        Tue, 31 Jan 2023 00:54:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so3385343pjd.2;
        Tue, 31 Jan 2023 00:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FzJvkcgZ0YfW42PnpzKH9LgmOzD8Ikgfi8w02uzzo8s=;
        b=G3p9VagdmJWM4BqT2W4/RJML/dKuk8P65A1KSXk40ZZoOmv9Aheai6r/4R3MrmawD0
         BJKC44zuedjDAlhYAIz/cTwvwE95+0g4VI8DSUs3HAdnHGlntEc05t2FY+h6VofByHCX
         Pfqt06BPNzDH2b1qfQa3nDpuwRrTToaVBHd3kkNjrszVnphtBwh4q04yYFxOvjBTGHnu
         IhO5hdBj74ukRLR48OC6Jla9ERFySggiABJfFlbMntF3h5FOA5ZI3igM+ZgerFZR6dhx
         gsL9aCaIvE+i8QiIVpiNI7JDqCYsbyWGlHjBGtS4PEt9+xDFbe9fFo26X1ver0n+3QV9
         vFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzJvkcgZ0YfW42PnpzKH9LgmOzD8Ikgfi8w02uzzo8s=;
        b=P4OYjKLxZ6HxEyT1aLf2z7EdAKjmNtzJZmZD2eesu03oj+jw6bjMm0A9QryXWQKbnl
         xndjW2NaTvpuMyI27ni4wU+XTBa1AOvhYzHTo3SDE1wOVYH+fjxNkHBekKPV06AWcnWQ
         SIIEB0zXYWhzz1bIvW9n5Vc+2PD/sRe84cHQZat+VktTcFN02UVoZOSNZwuBGJnvdg6F
         +Py0tJRgNfbUc4MTyaZEVW0hGbYvFnn59KbFIH4O11a/vpLhhlfzpOSZvJL3moWS3HX3
         0xD5qBMiLAw7tFOg7AFMFOALJ2QYuM1y696TTyNM/7GAJd0tZXUYyIjyrlpn7wjKCtVI
         C83Q==
X-Gm-Message-State: AO0yUKUwwZ5dkzqtS2Yc/e8e+hXfO9BK9FwNolscDBPsDkSkurteERrN
        u6bWTiySkq/a5APF+bDd10kkd6ehIqPQndEg
X-Google-Smtp-Source: AK7set8cMaPZ7PqOED+YOPMLaN92XMb3ueUSy0smv4WmF2QTj15FSJ+ikAaNklyWJeHEpbJN0evzDA==
X-Received: by 2002:a17:902:9a85:b0:196:1d60:b1b1 with SMTP id w5-20020a1709029a8500b001961d60b1b1mr21729192plp.31.1675155235905;
        Tue, 31 Jan 2023 00:53:55 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902ea1200b00188fc6766d6sm9210214plg.219.2023.01.31.00.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 00:53:55 -0800 (PST)
Message-ID: <617d9a3f-63a2-3ce2-b19a-2427ebbb7754@gmail.com>
Date:   Tue, 31 Jan 2023 16:53:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due
 to heterogeneity
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-2-likexu@tencent.com> <Y8nknyxfKl4p/0GY@google.com>
 <9b422d58-72ab-051f-e317-02b4d8e7211d@gmail.com>
 <Y9gA9aZNxYAZGgPh@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9gA9aZNxYAZGgPh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/1/2023 1:40 am, Sean Christopherson wrote:
> On Mon, Jan 30, 2023, Like Xu wrote:
>> On 20/1/2023 8:47 am, Sean Christopherson wrote:
>>> On Wed, Nov 09, 2022, Like Xu wrote:
>>>> From: Like Xu <likexu@tencent.com>
>>>>
>>>>   From vPMU enabling perspective, KVM does not have proper support for
>>>> hybird x86 core. The reported perf_capabilities value (e.g. the format
>>>> of pebs record) depends on the type of cpu the kvm-intel module is init.
>>>> When a vcpu of one pebs format migrates to a vcpu of another pebs format,
>>>> the incorrect parsing of pebs records by guest can make profiling data
>>>> analysis extremely problematic.
>>>>
>>>> The safe way to fix this is to disable this part of the support until the
>>>> guest recognizes that it is running on the hybird cpu, which is appropriate
>>>> at the moment given that x86 hybrid architectures are not heavily touted
>>>> in the data center market.
>>>>
>>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/capabilities.h | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>>>> index cd2ac9536c99..ea0498684048 100644
>>>> --- a/arch/x86/kvm/vmx/capabilities.h
>>>> +++ b/arch/x86/kvm/vmx/capabilities.h
>>>> @@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>>>    static inline bool vmx_pebs_supported(void)
>>>>    {
>>>> -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>>>> +	return boot_cpu_has(X86_FEATURE_PEBS) &&
>>>> +	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
>>>> +	       kvm_pmu_cap.pebs_ept;
>>>
>>> I assume the patch I just posted[*] to disable the vPMU entirely is sufficient, or
>>
>> AFAI, some developers doing client-side virtualization on a hybrid cpu will
>> specifically want vPMU,
>> in which case it makes perfect sense for KVM to expose common pmu
>> capabilities (not PEBS at the current) of big and little cores, such as the
>> most basic performance counter.
>>
>>> do we need this as well in order to hide X86_FEATURE_DS and X86_FEATURE_DTES64?
>>
>> I think we still need this diff. Better to prioritize this minor feature a
>> little bit for hungry users.
> 
> That wasn't my question.  My question was whether or not wholesale disabling vPMU
> is sufficient to prevent issues with PEBS.  Unless we need this patch on top of
> disabling the vPMU, my strong preference is to disable vPMU, or at the very least
> make it off-by-default and require a explicit override.

OK and if so, just set global module parameter "enable_pmu=false" for HYBRID_CPU.
With "disable vPMU" diff, this patch should be dropped since 
kvm_pmu_cap.pebs_ept = 0.

> 
> I agree that there are users that want to enable vPMU for hybrid CPUs, but as
> stated in the link below, that needs to be a dedicated enabling effort.  I don't
> see any reason to exempt PEBS from that.  E.g. isn't PEBS usable if userspace pins
> vCPUs to pCPUs and enumerates an accurate topology to the guest?

So for HYBRID_CPU, {pebs, lbr, basic PMU} would be disabled globally by KVM
until a dedicated effort enables them one by one in the near future.

Follow up with a rewritten diff, 20230131085031.88939-1-likexu@tencent.com

> 
>>> [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com
