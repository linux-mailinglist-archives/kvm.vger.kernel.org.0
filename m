Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FDF72A285
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjFISpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 14:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjFISo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 14:44:56 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66949198C
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 11:44:55 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f4e71a09a7so2703406e87.1
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 11:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686336293; x=1688928293;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HvpDlCKTVQsvDfzT1xQOe6xivipkfREbNWcWMpTdPmo=;
        b=LtPj6fvoTzHA0nQEiGtGn8GHyTIY7SQSYBW07rmjEwO4w+ONXCcoroqL8qeObmS5py
         q164d5KiHVD33+YArpkWd6BTR6+s5xron17xYhV5Hk+HxHMwuOzC2rKtWRXbjber1iF/
         xzAwdUdhVfY4C5tv9jQyz50/KVfxIpNjOIFWXkbQ/AB3JsnNiHwt6UM6qk8YvT/nWDSK
         vx6cm6EmGi2PR6kztYlQeYkSTU6c7jaqzU/xNVFO3t2OLMuYXL+prPZgf8xhxEZxghBR
         w5nWv7LP8m65hlLfE3jmYRAexE6q0iS0/l8sU1kifD5v0VuDlPxc7fUjx2sjJSLTXB6E
         JYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686336293; x=1688928293;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HvpDlCKTVQsvDfzT1xQOe6xivipkfREbNWcWMpTdPmo=;
        b=SNyd4WtP+lID08xx5OGNya3zTyHLaDm1E27A5M4/jULIhRkbuQV1xdTE+qVH3qNlaG
         nJhL01BjdTDI7h4C1emfbm26+NAJlihE5fnJdxiNLGL50cDiUwz0HSf5OzjMCekDmONM
         1zY2FhIR20SPQf2PqZXHAGBL3LgrjUpvXAR3KmS0lwtQSVdRa01YS6l9OpD3cbvSePit
         IImykLXDvVtCOJqJVeBttMBZ8CV0lCSyK6tw93As6YXg6hOjlBSeKgka8LdkWbnXH/9S
         ZS9CSddwJFPDhRkqr14WKiAbjpB0V5LyhrPclRiakE/M7h0XommMmPt6v+bLZQ4RMSQZ
         7DXw==
X-Gm-Message-State: AC+VfDzR3OwqxQs8R082TwXHzM/+2ct1L1yuWJhy0rLpQ81vQ3+lqGFE
        LyOsU+La7xiQbKDQe+LTrwK4r1KIs3lrzFqoFAo=
X-Google-Smtp-Source: ACHHUZ4zMfrtystGmlYTBWN38fUeEBY5uP286YlDlhyUiPh0oUmo7AHNlLR6xagssxKul4lHX/3Dyg==
X-Received: by 2002:a05:6512:a94:b0:4eb:4258:bf62 with SMTP id m20-20020a0565120a9400b004eb4258bf62mr1266064lfu.8.1686336293599;
        Fri, 09 Jun 2023 11:44:53 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id u13-20020a2e9f0d000000b002b18f50d11asm482688ljk.84.2023.06.09.11.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 11:44:53 -0700 (PDT)
Message-ID: <add6bfd4-170a-4db2-ff08-33fdbe619829@semihalf.com>
Date:   Fri, 9 Jun 2023 20:44:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
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
Content-Language: en-US
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <bbc0b864-8a5f-50dd-40a2-14a8ae18af3b@quicinc.com>
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

On 6/9/23 18:57, Trilok Soni wrote:
> On 6/8/2023 2:06 PM, Dmytro Maluka wrote:
>> On 3/24/23 11:30, Keir Fraser wrote:
>>> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>>>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>>>
>>>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>>>> There are similar use cases on x86 platforms requesting protected
>>>>>>> environment which is isolated from host OS for confidential computing.
>>>>>>
>>>>>> What exactly are those use cases?  The more details you can provide, the better.
>>>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
>>>>>> the pKVM implementation.
>>>>>
>>>>> Thanks Sean for your comments, I am very appreciated!
>>>>>
>>>>> We are expected
>>>>
>>>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
>>>> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
>>>> then please work with whoever you need to in order to get permission to fully
>>>> disclose the use case.  Because realistically, without knowing exactly what is
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
> 
> 
> Very interesting usecases. I would be interested to know how you plan to
> paravirt the clocks and regulators required for these devices on the guest VM (Protected VM) on x86. On ARM, we have SCMI specification w/
> virtio-scmi, it is possible to do the clock and regulators paravirt.

On x86 things like clocks and regulators tend to be abstracted away via
ACPI, i.e. they are managed by AML code in ACPI tables, not by the
device driver in kernel. With pKVM, ACPI is still fully managed by the
host, although the secure device driver is running in the protected VM.

So at least in theory this is automatically solved for us in most cases
(though admittedly it is only a theory so far, we have no
proof-of-concept yet, see below).

> Camera may have need more h/w dependencies than clocks and regulators like flash LEDs, gpios, IOMMUs, I2C on top of the camera driver pipeline itself.

When it comes to camera, we are rather considering not a separate
physical camera but a secure image stream, separated from non-secure
image stream from the same camera e.g. with Intel IPU6. In this case
the assigned device (the IPU) is within the SoC. There are actually lots
of challenges with its assignment too, but completely different ones
(how to partition it between the host and the VM and ensure protection
from the host).

> Do you have any proof-of-concept for above usecases to check and reproduce on the chrome w/ x86?

Not really yet. We've been focused on evaluating functionality and
performace of ChromeOS itself, i.e. whether ChromeOS works with pKVM as
good as natively, - without the actual protected VMs yet, but already
with pKVM functionality required for protected VMs (memory protection
etc). We've also been looking a lot into the issues of assignment and
protection of secure devices for protected VMs, but (apart from the
simple case of generic PCI devices) mostly theoretically so far.

> Do we have the recording of the PUCK meeting?
> 
> ---Trilok Soni
