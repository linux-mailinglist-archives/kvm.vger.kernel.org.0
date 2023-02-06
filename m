Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8431B68B7BC
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBFIwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 03:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBFIwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 03:52:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEED113EE;
        Mon,  6 Feb 2023 00:52:23 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so12713654pjq.1;
        Mon, 06 Feb 2023 00:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTwAC18x9cIOiks/6Nlsw3FpytCj0rBSuF+cGpZx0VM=;
        b=VSd1My/oB2i372ZLnobUBAmRCyztLovO/+nubk400rlkIFAmqIIirSuZKwKufF6Cmz
         YyrXXRZ/Fz9JRCik4TvEzTcRjqcl116J42OdlFMfI/Zjb4EYIxxQX+kq8eeHYzIEEzGa
         +7CN/PWyLZamFpgTdiNMIyTZNuglmXDQUJujb3cERr6MA6noRnVzonrjAkKEtO4Dirzs
         GBY8HlikPGUwpe9oAsu8WGxtFIrCSdlMh5Wd1sg8iDadbGKv42DKush9+BiouOkjlLmH
         hzc2RxMolbkDJOI0Wdw0i0s/xQZZ/7huJzn6pmK4gpzTFCGrD9JMRm8mfjj4R4FqN0z2
         9UsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTwAC18x9cIOiks/6Nlsw3FpytCj0rBSuF+cGpZx0VM=;
        b=WbZcV7ItBChnfRCtl0kF0t+i387J0RWZMj1YRJAPHa3pTiE82XBWJ6MAWRDipKBUMm
         7X0vWQq3AjJ57LFFOcX/cOifDQPFUwsUglI7LtSk4rdZFSBTcTnV25wscSZuHqcM71BV
         jNBTjUotZstFiMalxN/DZKvfhBbqqRwGRdKOcJScZJWp5sa94Bb4U1hvsV5tzAcGW2Vm
         6qKkFUzhp7qjLEO7n5VaU6+ZT7Ias878Kf0Xigbom0G09mTXJ90jBKba9ynNhOMC7lfY
         Ddz6lv6+qRBy8goUqjBGhtFByMsRWFEavlquCWFF83spXMeGtokw8ImNbEHMzX5bGwvx
         H6sQ==
X-Gm-Message-State: AO0yUKVAR9PctgtrinNkto13y3y225QfC1VvCwb0dkB2h3Tw4R38EWnX
        2Sz+wZvx+5VrWRHvZkHpgBE=
X-Google-Smtp-Source: AK7set9NkvBN6SOTcQQAZVe9yJ4NefHT1nYDE0voeiXA81qVuThAhjyaNJuGoqKsWw0DrLlKScPndg==
X-Received: by 2002:a17:903:1111:b0:196:6ec4:52db with SMTP id n17-20020a170903111100b001966ec452dbmr22503790plh.51.1675673542782;
        Mon, 06 Feb 2023 00:52:22 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902e98900b00185402cfedesm4607769plb.246.2023.02.06.00.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 00:52:22 -0800 (PST)
Message-ID: <f0f6dbed-0e1d-059c-11a4-07fd4bec5c99@gmail.com>
Date:   Mon, 6 Feb 2023 16:52:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
 <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
 <Y9v7tEXPlki7YOT4@google.com>
 <7dc66398-aa0c-991f-3fa9-43aac8c710fd@gmail.com>
 <Y91DUmMjCLzIXlp+@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y91DUmMjCLzIXlp+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/2023 1:28 am, Sean Christopherson wrote:
> On Fri, Feb 03, 2023, Like Xu wrote:
>> On 3/2/2023 2:06 am, Sean Christopherson wrote:
>>> On Thu, Feb 02, 2023, Like Xu wrote:
>>>> On 1/2/2023 12:02 am, Sean Christopherson wrote:
>>>> The perf interface only provides host PMU capabilities and the logic for
>>>> choosing to disable (or enable) vPMU based on perf input should be left
>>>> in the KVM part so that subsequent development work can add most code
>>>> to the just KVM, which is very helpful for downstream users to upgrade
>>>> loadable KVM module rather than the entire core kernel.
>>>>
>>>> My experience interacting with the perf subsystem has taught me that
>>>> perf change required from KVM should be made as small as possible.
>>>
>>> I don't disagree, but I don't think that's relevant in this case.  Perf doesn't
>>> provide the necessary bits for KVM to virtualize a hybrid PMU, so unless KVM is
>>> somehow able to get away with enumerating a very stripped down vPMU, additional
>>> modifications to perf_get_x86_pmu_capability() will be required.
>>>
>>> What I care more about though is this ugliness in perf_get_x86_pmu_capability():
>>>
>>> 	/*
>>> 	 * KVM doesn't support the hybrid PMU yet.
>>> 	 * Return the common value in global x86_pmu,
>>> 	 * which available for all cores.
>>
>> I would have expected w/ current code base, vpmu (excluding pebs and lbr, intel_pt)
>> to continue to work on any type of pCPU until you decide to disable them completely.
> 
> Didn't follow this.

My expectation is that, if a guest doesn't enable "PEBS, LBR and intel_pt",
and only has the most basic pmu conters (its number is the lesser number
of big and small cores supported), with some pmu_event_fileter allow list
mechanism, vPMU works regardless of the vcpu model and does not
require cpu pined. Any complaints from users on this usages ?

> 
>> Moreover, the caller of perf_get_x86_pmu_capability() may be more than just KVM,
>> it may be technically ebpf helpers. The diff on comments from v1 can be applied to
>> this version (restrict KVM semantics), and it makes the status quo clearer
>> to KVM users.
> 
> In that case, eBPF is just as hosed, no?  And given that the only people that have
> touched perf_get_x86_pmu_capability() in its 11+ years of existence are all KVM
> people, I have a hard time believing there is meaningful use outside of KVM.

Some radical bpf programs will access the pmu directly, although this is
not  uncommon in upstream. KVM colleagues shouldn't need to care
about them, but at least don't mislead them.

> 
>>> 	 */
>>> 	cap->num_counters_gp	= x86_pmu.num_counters;
>>>
>>> I really don't want to leave that comment lying around as it's flat out wrong in
>>> that it obviously doesn't address the other differences beyond the number of
>>> counters.  And since there are dependencies on perf, my preference is to disable
>>> PMU enumeration in perf specifically so that whoever takes on vPMU enabling is
>>> forced to consider the perf side of things, and get buy in from the perf folks.
>>
>> The perf_get_x86_pmu_capability() obviously needs to be revamped,
>> but until real effective KVM enabling work arrives, any inconsequential intrusion
>> into perf/core code will only lead to trivial system maintenance.
> 
> Trivial doesn't mean useless or unnecessary though.  IMO, there's value in capturing,
> in code, that perf_get_x86_pmu_capability() doesn't properly support hybrid vPMUs.
> 
> That said, poking around perf, checking is_hybrid() is wrong.  This quirk suggests
> that if E-cores are disabled via BIOS, (a) X86_FEATURE_HYBRID_CPU is _supposed_ to
> be cleared, and (b) the base PMU will reflect the P-core PMU.  I.e. someone can
> enable vPMU by disabling E-cores.
> 
>                  /*
>                   * Quirk: For some Alder Lake machine, when all E-cores are disabled in
>                   * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
>                   * the X86_FEATURE_HYBRID_CPU is still set. The above codes will

Sigh. Then what if E-cores are manually offline via "/.../cpu$/online" and then 
init kvm module ?
I suggest leaving these open issues to that enabling guy (or maybe it's still me).

>                   * mistakenly add extra counters for P-cores. Correct the number of
>                   * counters here.
>                   */
>                  if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
>                          pmu->num_counters = x86_pmu.num_counters;
>                          pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
>                  }
> 
> Side topic, someone (*cough* Intel) should fix that, e.g. detect the scenario
> during boot and manually clear X86_FEATURE_HYBRID_CPU.

Maybe they did it on purpose.

> 
> I'm also ok explicitly disabling support in KVM, but since we need to update
> perf as well (that KVM comment needs to go), I don't see any reason not to also
> update perf_get_x86_pmu_capability().
> 
> How about this?  Maybe split over two patches to separate the KVM and perf changes?

OK, applying your diff below or mine V2 as a KVM move is both fine to me. Just 
thanks.

> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 85a63a41c471..d096b04bf80e 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2974,17 +2974,19 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>   
>   void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
>   {
> -       if (!x86_pmu_initialized()) {
> +       /* This API doesn't currently support enumerating hybrid PMUs. */
> +       if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
> +           !x86_pmu_initialized()) {
>                  memset(cap, 0, sizeof(*cap));
>                  return;
>          }
>   
> +       /*
> +        * Note, hybrid CPU models get tracked as having hybrid PMUs even when
> +        * all E-cores are disabled via BIOS.  When E-cores are disabled, the
> +        * base PMU holds the correct number of counters for P-cores.
> +        */
>          cap->version            = x86_pmu.version;
> -       /*
> -        * KVM doesn't support the hybrid PMU yet.
> -        * Return the common value in global x86_pmu,
> -        * which available for all cores.
> -        */
>          cap->num_counters_gp    = x86_pmu.num_counters;
>          cap->num_counters_fixed = x86_pmu.num_counters_fixed;
>          cap->bit_width_gp       = x86_pmu.cntval_bits;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index cdb91009701d..933165663703 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -165,15 +165,27 @@ static inline void kvm_init_pmu_capability(void)
>   {
>          bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>   
> -       perf_get_x86_pmu_capability(&kvm_pmu_cap);
> -
> -        /*
> -         * For Intel, only support guest architectural pmu
> -         * on a host with architectural pmu.
> -         */
> -       if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
> +       /*
> +        * Hybrid PMUs don't play nice with virtualization unless userspace
> +        * pins vCPUs _and_ can enumerate accurate informations to the guest.
> +        * Disable vPMU support for hybrid PMUs until KVM gains a way to let
> +        * userspace opt into the dangers of hybrid vPMUs.
> +       */
> +       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
>                  enable_pmu = false;
>   
> +       if (enable_pmu) {
> +               perf_get_x86_pmu_capability(&kvm_pmu_cap);
> +
> +               /*
> +                * For Intel, only support guest architectural pmu
> +                * on a host with architectural pmu.
> +                */
> +               if ((is_intel && !kvm_pmu_cap.version) ||
> +                   !kvm_pmu_cap.num_counters_gp)
> +                       enable_pmu = false;
> +       }
> +
>          if (!enable_pmu) {
>                  memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>                  return;
> 
