Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8898172AA6D
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 10:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjFJI4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 04:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjFJI42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 04:56:28 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499A930E3
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:56:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b203891b2cso29012441fa.3
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686387385; x=1688979385;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=52Fk4hfW4Pl7K+7ANB+q3w84HE2NS5WoeZBywcfe038=;
        b=IZNebbEFixI1CispgDYTREqrbwMHV6ZG+h2I0Pn1y8sLFOC21gNetN3L3IyOHcXQrS
         ZlQJEZhOU8taU/MaxJ4sLUJPx2rnx7u0rYl9YTmOxCdVOaZZnRPFuNtUq/yVK5eUUkzR
         OMhrGcC2pkCCsTYTHQI84ARAHv/1dvrokjgWhaNHFGAQal6TGxyFQZzs/y8Fw/lRcvNc
         O9ScIxvvVyTT6kdznVEUZ5BQ2WwfJSBsQUpaLX43yu2anGBbfHqc0Dm/E1srxfDyhDgF
         ACdENt+4pKAmp3UCM+JwLN34DzIyQQ3MKEKHUeJZVq714TNBQxwp3Rxoxx+iAWqjdOHS
         /p6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686387385; x=1688979385;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52Fk4hfW4Pl7K+7ANB+q3w84HE2NS5WoeZBywcfe038=;
        b=CkYIM6APTgiyW8gb5prQyu9n5nVZyl70n0OmzF6vU3ZqVCPvZSECR7vO9CxmweUyDu
         lkRWjBtJX+BYwNzMDziNv6gCEvyHjgPExke2z8Zxy4L/uhhGenC2VrmWN6X6r10RfjKV
         GT4SS+Q4I/kOaqyMrQQD9x2ubb7+WFXXw9ptfZWc7btG2G173V5jnmpX5M6XETOc4tHU
         Az3llyPG+FTFi8AM4kbDVJVK34s/XMFwtC6zIVp6ahWdZl/w3EfMK0/j2NC2qhowT5q0
         A82Var+DSotEYmFcgpRmvqhoQ9S42DV/WhfbAF6bCnFKUHtY6g8u51rfvvPTwQigHQBa
         MvfA==
X-Gm-Message-State: AC+VfDze94wWtvdKaDcmAi6nl3/bw2ukg7HfXW1HyjGr3a1/rcBwNtsG
        ri5udGxN5eUdXI92Sy/qlbPxbQ==
X-Google-Smtp-Source: ACHHUZ4gScHJYEj8chkPyFrIS/pr19xLPP8sIJkiz3xg0agR1BpzHkhgAgPGPTv2yf0i1jgreDTlCQ==
X-Received: by 2002:a2e:9a92:0:b0:2a8:c75d:8167 with SMTP id p18-20020a2e9a92000000b002a8c75d8167mr407318lji.4.1686387385307;
        Sat, 10 Jun 2023 01:56:25 -0700 (PDT)
Received: from ?IPV6:2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13? ([2a02:a31b:2041:8680:1268:c8b0:5fcc:bf13])
        by smtp.gmail.com with ESMTPSA id s20-20020a2e2c14000000b002b1a8b926f3sm760183ljs.3.2023.06.10.01.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 01:56:24 -0700 (PDT)
Message-ID: <5cbf44a3-12a4-f1c4-aaa0-d9cec30fd85e@semihalf.com>
Date:   Sat, 10 Jun 2023 10:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Content-Language: en-US
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Trilok Soni <quic_tsoni@quicinc.com>,
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
 <bbc0b864-8a5f-50dd-40a2-14a8ae18af3b@quicinc.com>
 <add6bfd4-170a-4db2-ff08-33fdbe619829@semihalf.com>
In-Reply-To: <add6bfd4-170a-4db2-ff08-33fdbe619829@semihalf.com>
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

On 6/9/23 20:44, Dmytro Maluka wrote:
> On 6/9/23 18:57, Trilok Soni wrote:
>> On 6/8/2023 2:06 PM, Dmytro Maluka wrote:
>>> On 3/24/23 11:30, Keir Fraser wrote:
>>>> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>>>>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>>>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>>>>
>>>>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>>>>> There are similar use cases on x86 platforms requesting protected
>>>>>>>> environment which is isolated from host OS for confidential computing.
>>>>>>>
>>>>>>> What exactly are those use cases?  The more details you can provide, the better.
>>>>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
>>>>>>> the pKVM implementation.
>>>>>>
>>>>>> Thanks Sean for your comments, I am very appreciated!
>>>>>>
>>>>>> We are expected
>>>>>
>>>>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
>>>>> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
>>>>> then please work with whoever you need to in order to get permission to fully
>>>>> disclose the use case.  Because realistically, without knowing exactly what is
>>>>> in scope and why, this is going nowhere.
>>>>
>>>> This is being seriously evaluated by ChromeOS as an alternative to
>>>> their existing ManaTEE design. Compared with that (hypervisor == full
>>>> Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
>>>> "VM" runs closer to native and without nested scheduling, demonstrated
>>>> better performance, and closer alignment with Android virtualisation
>>>> (that's my team, which of course is ARM focused, but we'd love to see
>>>> broader uptake of pKVM in the kernel).
>>>
>>> Right, we (Google with the help of Semihalf and Intel) have been
>>> evaluating pKVM for ChromeOS on Intel platforms (using this Intel's
>>> pKVM-on-x86 PoC) as a platform for running secure workloads in VMs
>>> protected from the untrusted ChromeOS host, and it looks quite promising
>>> so far, in terms of both performance and design simplicity.
>>>
>>> The primary use cases for those secure workloads on Chromebooks are for
>>> protection of sensitive biometric data (e.g. fingerprints, face
>>> authentication), which means that we expect pKVM to provide not just the
>>> basic memory protection for secure VMs but also protection of secure
>>> devices assigned to those VMs (e.g. fingerprint sensor, secure camera).
>>
>>
>> Very interesting usecases. I would be interested to know how you plan to
>> paravirt the clocks and regulators required for these devices on the guest VM (Protected VM) on x86. On ARM, we have SCMI specification w/
>> virtio-scmi, it is possible to do the clock and regulators paravirt.
> 
> On x86 things like clocks and regulators tend to be abstracted away via
> ACPI, i.e. they are managed by AML code in ACPI tables, not by the
> device driver in kernel. With pKVM, ACPI is still fully managed by the
> host, although the secure device driver is running in the protected VM.
> 
> So at least in theory this is automatically solved for us in most cases
> (though admittedly it is only a theory so far, we have no
> proof-of-concept yet, see below).
> 
>> Camera may have need more h/w dependencies than clocks and regulators like flash LEDs, gpios, IOMMUs, I2C on top of the camera driver pipeline itself.
> 
> When it comes to camera, we are rather considering not a separate
> physical camera but a secure image stream, separated from non-secure
> image stream from the same camera e.g. with Intel IPU6. In this case
> the assigned device (the IPU) is within the SoC. There are actually lots
> of challenges with its assignment too, but completely different ones
> (how to partition it between the host and the VM and ensure protection
> from the host).

On second thought, the "within the SoC" point is probably not important.
What's important is that the protected guest needs only a small part of
the IPU hw functionality - the one related to the secure camera data
channel. Among the things you mentioned, the IPU's internal IOMMU needs
to be assigned to the guest, as it's crucial that the secure VM has
exclusive control over this IOMMU to ensure DMA isolation between secure
and non-secure data channels. (The host IOMMU, managed by pKVM
hypervisor, needs to be involved too but is not enough.) Others things
(GPIOs, clocks etc) are left to the host IPU driver and/or ACPI.

How shall we assign the IPU IOMMU to the guest? In the IPU's device
specific ways, unfortunately.

Hopefully for other use cases we can do things more generically, as we
can pass-through the entire device to the guest, except for the power
management bits which are already effectively partitioned away via ACPI.

>> Do you have any proof-of-concept for above usecases to check and reproduce on the chrome w/ x86?
> 
> Not really yet. We've been focused on evaluating functionality and
> performace of ChromeOS itself, i.e. whether ChromeOS works with pKVM as
> good as natively, - without the actual protected VMs yet, but already
> with pKVM functionality required for protected VMs (memory protection
> etc). We've also been looking a lot into the issues of assignment and
> protection of secure devices for protected VMs, but (apart from the
> simple case of generic PCI devices) mostly theoretically so far.
> 
>> Do we have the recording of the PUCK meeting?
>>
>> ---Trilok Soni
