Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D038172924F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 10:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjFIIKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 04:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240059AbjFIIJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 04:09:13 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4F5421B
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 01:08:43 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4effb818c37so1839331e87.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 01:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686298122; x=1688890122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UYadoATDuSxIkUTsVnx83inug0Nps0NQ8Z+2SNpfwB8=;
        b=Fs1efqGB1pgLN6smoE5cCiv+RwUe/raHxnXJnRxPAUQI7fq5vrk7no5c5LiqqOQNHJ
         BbKoS7Q4plZrixJf02/fiDmSxGxXMIi78KFwVTbSzIcnWeyl76ipm7Fgyklsg48cKpz3
         UR9+QzvutQ0ztgmh7suxwh3u72u8qaGjOHaq4G1vhcaJKQp1AmWAfPbxmSOZ7sa8AJnd
         SsC7ac6TqKu8/PrOCNhB3ifU1gB5lN96tpCc5icRqREQLezZBibkrzrDY8u2MwV0gLPS
         mJKCzeYgUsNKOrMkNM43r5W17yAJ19PDpT106QXGZkLLss9VhVqyRL7II05orJ5+DvKj
         UNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686298122; x=1688890122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYadoATDuSxIkUTsVnx83inug0Nps0NQ8Z+2SNpfwB8=;
        b=SWf+ILvjbkRT0q3Jz0cvCMX39cLeKFu9/wrj9/o2N8XVYGPdEXJ1hMaoZyU2CjRXcx
         u4+rzmlJL3WzTUNqImWJ/Q9o+gGu9wDf22hev6xmDOKRFcr5EGpg4+hJgo65xKLFD6Mb
         nndEcxoOfCToFg+pXPSDR/0fUs94FEbZGgcqcOZxC4fPqugF4tLrX+7KkA/cMgcW5/dp
         pc4KjKzoFbdVyiGVonyvBgR1hvhWH3t5wc+/+Pp1Wl0slABTpn8NZ50ceQRnNZDexcnE
         zIdz6cxGODi9RD1pAQBoKXcWeitLfpoMUfV7CIloWVfzLxQcvI2FRe31ezfV/ye9ctNK
         DrpQ==
X-Gm-Message-State: AC+VfDxQ5jr/L4CjjyJjljrwAzT7/KPxwPHiCqqhVUsD6rgsb4xqjaFT
        2fmP746f5rCGRDWwH17nRstvaA==
X-Google-Smtp-Source: ACHHUZ7dExDOIVWfCGNNkfXXQ2mYwtgRYbtv6rHSXgNY33WSmo6i22e7rSjVYFOProiJ5+QQbsGuMA==
X-Received: by 2002:a05:6512:475:b0:4ef:eb50:4d3d with SMTP id x21-20020a056512047500b004efeb504d3dmr446347lfd.18.1686298121788;
        Fri, 09 Jun 2023 01:08:41 -0700 (PDT)
Received: from ?IPV6:2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13? ([2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13])
        by smtp.gmail.com with ESMTPSA id u26-20020ac243da000000b004f4d5003e8dsm459076lfl.7.2023.06.09.01.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 01:08:41 -0700 (PDT)
Message-ID: <49c3c20b-5683-2ef8-a9bf-87e0415c18cf@semihalf.com>
Date:   Fri, 9 Jun 2023 10:08:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Content-Language: en-US
To:     "tina.zhang" <tina.zhang@intel.com>,
        Keir Fraser <keirf@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>, kvm@vger.kernel.org,
        android-kvm@google.com, Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com> <ZB17s69rC9ioomF7@google.com>
 <883b7419-b8ac-f16a-e102-d3408c29bbff@semihalf.com>
 <d0900265-6ae6-2430-8185-4f9d153ec105@intel.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <d0900265-6ae6-2430-8185-4f9d153ec105@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/23 01:02, tina.zhang wrote:
> 
> 
> On 6/9/23 05:06, Dmytro Maluka wrote:
>> On 3/24/23 11:30, Keir Fraser wrote:
>>> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>>>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>>>
>>>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>>>> There are similar use cases on x86 platforms requesting protected
>>>>>>> environment which is isolated from host OS for confidential
>>>>>>> computing.
>>>>>>
>>>>>> What exactly are those use cases?  The more details you can
>>>>>> provide, the better.
>>>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would
>>>>>> likely simplify
>>>>>> the pKVM implementation.
>>>>>
>>>>> Thanks Sean for your comments, I am very appreciated!
>>>>>
>>>>> We are expected
>>>>
>>>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt
>>>> Intel is the
>>>> end customer of pKVM-on-x86.  If you aren't at liberty to say due
>>>> NDA/confidentiality,
>>>> then please work with whoever you need to in order to get permission
>>>> to fully
>>>> disclose the use case.  Because realistically, without knowing
>>>> exactly what is
>>>> in scope and why, this is going nowhere.
>>>
>>> This is being seriously evaluated by ChromeOS as an alternative to
>>> their existing ManaTEE design. Compared with that (hypervisor == full
>>> Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
>>> "VM" runs closer to native and without nested scheduling, demonstrated
>>> better performance, and closer alignment with Android virtualisation
>>> (that's my team, which of course is ARM focused, but we'd love to see
>>> broader uptake of pKVM in the kernel).
>>
>> Right, we (Google with the help of Semihalf and Intel) have been
>> evaluating pKVM for ChromeOS on Intel platforms (using this Intel's
>> pKVM-on-x86 PoC) as a platform for running secure workloads in VMs
>> protected from the untrusted ChromeOS host, and it looks quite promising
>> so far, in terms of both performance and design simplicity.
>>
>> The primary use cases for those secure workloads on Chromebooks are for
>> protection of sensitive biometric data (e.g. fingerprints, face
>> authentication), which means that we expect pKVM to provide not just the
>> basic memory protection for secure VMs but also protection of secure
>> devices assigned to those VMs (e.g. fingerprint sensor, secure camera).
>>
>> Summarizing what we discussed at PUCK [1] regarding the existing pKVM
>> design (with kernel deprivileging) vs pKVM using SEAM (please correct me
>> if I'm missing something):
>>
>> - As we are interested in pKVM for client-side platforms (Chromebooks)
>>    which have no SEAM hardware, using SEAM does not seem to be an option
>>    at all. And even if it was, we still prefer the current (software
>>    based) pKVM design, since we need not just memory protection but also
>>    device protection, and generally we prefer to have more flexibility.
>>
>> - Sean had a concern that kernel deprivileging may require intrusive
>>    changes in the common x86 arch code outside KVM, but IIUC it's not
>>    quite the case. AFAICT the code needed for deprivileging (i.e. making
>>    the kernel run in VMX non-root as a VM) is almost fully contained
>>    within KVM, i.e. the rest of the kernel can remain largely agnostic of
>>    the fact that it is running in VMX non-root. (Jason, please correct me
>>    if I'm wrong.)
>>
>> Outside KVM, there is a bit of changes in drivers/intel/iommu/ for a bit
>> of PV stuff for IOMMU in pKVM (not sure if that is already included in
>> this RFC), and if we go with a more PV based design [2] and not just for
>> VMX and EPT but also for IOMMU, then I expect we're gonna have more of
>> such PV changes for pKVM there, but still contained within Intel IOMMU
>> driver.
> Thanks Dmytro for the summarizing. I just want to add a bit update about
> the PV stuff for Intel IOMMU driver: we took deep look into the
> solution[1] proposed by pKVM-ARM folks and we think it's promising
> especially for the platforms that have no hardware IOMMU nested
> translation support. If PV is going to be the direction, we'd like to
> try the solution on pKVM-IA.

Hi Tina,

Thanks for the info, looks quite interesting. Yeah, I agree that PV
seems to be the best way to go. Also, using (fully or partially) the
same PV interface as on ARM is probably a good idea too.

> 
> [1]:
> https://lore.kernel.org/linux-arm-kernel/20230201125328.2186498-14-jean-philippe@linaro.org/T/
> 
> Regards,
> -Tina
>>
>> [1]
>> https://lore.kernel.org/kvm/20230606181525.1295020-1-seanjc@google.com/
>> [2] https://lore.kernel.org/all/ZA9WM3xA6Qu5Q43K@google.com/
>>
>> Thanks,
>> Dmytro
>>
>>>
>>>   -- Keir
>>>
>>>>> to run protected VM with general OS and may with pass-thru secure
>>>>> devices support.
>>>>
>>>> Why?  What is the actual use case?
>>>>
>>>>> May I know your suggestion of "utilize SEAM" is to follow TDX SPEC
>>>>> then
>>>>> work out a SW-TDX solution, or just do some leverage from SEAM code?
>>>>
>>>> Throw away TDX and let KVM run its own code in SEAM.
>>>>
