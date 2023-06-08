Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF47289E8
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 23:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbjFHVGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 17:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236934AbjFHVGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 17:06:33 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6F82D42
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 14:06:32 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1b2ca09b9so10949741fa.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 14:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686258390; x=1688850390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzf/AJVLLwlyNuLXoxGchwTBAwnp78x515ybTJqhleE=;
        b=Su4oCEPeVfQlp40IQiLBzwhZiEtTHr47lZN6+em/NH0ZJcawr1X/UrZb/9XjpC19Cj
         IoApKeYlF8QDeRSXTSMFtXeT7iHo451IYHAdMSn2mzwPPheCIg7rqPklfCwVh/wERGbl
         j4GasgmPDEDWp9kxZNRObChAOQETIu+GbxsO4m+9EzMq8n2fpeltFMj7VLRzPExfqsUH
         dDuxROWWBfY2tWOHMF7X/bFVpGIcnSvIpcZkDZiJ0jvNUNG8+Oe8VCj06g9GWoLGJL37
         LqmVTtRVYMyIo+LmPFgNTblelf11HETfAPVtx+ptCdz6IsKTHPjkkF9tGiXkT6biPAe6
         EHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686258390; x=1688850390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzf/AJVLLwlyNuLXoxGchwTBAwnp78x515ybTJqhleE=;
        b=bntS7BBCt3VZZD0EMqmo8NyZrOgSAzHZ3MA6vDXGlrITppKDVw4rEqRRLsXOQR7PCR
         rf/zGHHsCeWmJGD75LmtqiLSz2gAEFsSMxBEfp9bgdnDrBnLJ1YPjKVdKb6puk2CVRjP
         3Q3E2OHOfL6iE7faPqG9mL3JGUYyXVGWP2/uLK7TPqRw1ADhwIHVz6inoU2n8U84VouA
         7o6l/19YR+fs9fJQbL+PNzPp4ONgNOzYa0VljMD69wT5xxaSJ1NYJxjaloh7ul038OKJ
         VWG3KaAZOwOR9Kf2GM6sqCqvYyV2G4xfzWjrmO86jjEri/Z7YIG+Ue1IZ66ak4MtAYW7
         fLIw==
X-Gm-Message-State: AC+VfDzeltEBsrzIdIGV6l31+MssraB/O99Lgko2PcjxNCMsYEzyVMWA
        dGzCG4Ut3Jziv/OLotmML1mlvQ==
X-Google-Smtp-Source: ACHHUZ635AcINIrZnwAop2wCdnitxw6tvQYReQ0rNsnCihbRwyPlJ9G7TQLOh6yxZMCtmcZWWh2irA==
X-Received: by 2002:a05:651c:cc:b0:2b1:ecac:91d3 with SMTP id 12-20020a05651c00cc00b002b1ecac91d3mr4223907ljr.25.1686258390114;
        Thu, 08 Jun 2023 14:06:30 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id l18-20020a2e8692000000b002b04fc12365sm80256lji.76.2023.06.08.14.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 14:06:29 -0700 (PDT)
Message-ID: <883b7419-b8ac-f16a-e102-d3408c29bbff@semihalf.com>
Date:   Thu, 8 Jun 2023 23:06:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Content-Language: en-US
To:     Keir Fraser <keirf@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>, kvm@vger.kernel.org,
        android-kvm@google.com, Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com> <ZB17s69rC9ioomF7@google.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <ZB17s69rC9ioomF7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/23 11:30, Keir Fraser wrote:
> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>
>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>> There are similar use cases on x86 platforms requesting protected
>>>>> environment which is isolated from host OS for confidential computing.
>>>>
>>>> What exactly are those use cases?  The more details you can provide, the better.
>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
>>>> the pKVM implementation.
>>>
>>> Thanks Sean for your comments, I am very appreciated!
>>>
>>> We are expected 
>>
>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
>> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
>> then please work with whoever you need to in order to get permission to fully
>> disclose the use case.  Because realistically, without knowing exactly what is
>> in scope and why, this is going nowhere.  
> 
> This is being seriously evaluated by ChromeOS as an alternative to
> their existing ManaTEE design. Compared with that (hypervisor == full
> Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
> "VM" runs closer to native and without nested scheduling, demonstrated
> better performance, and closer alignment with Android virtualisation
> (that's my team, which of course is ARM focused, but we'd love to see
> broader uptake of pKVM in the kernel).

Right, we (Google with the help of Semihalf and Intel) have been
evaluating pKVM for ChromeOS on Intel platforms (using this Intel's
pKVM-on-x86 PoC) as a platform for running secure workloads in VMs
protected from the untrusted ChromeOS host, and it looks quite promising
so far, in terms of both performance and design simplicity.

The primary use cases for those secure workloads on Chromebooks are for
protection of sensitive biometric data (e.g. fingerprints, face
authentication), which means that we expect pKVM to provide not just the
basic memory protection for secure VMs but also protection of secure
devices assigned to those VMs (e.g. fingerprint sensor, secure camera).

Summarizing what we discussed at PUCK [1] regarding the existing pKVM
design (with kernel deprivileging) vs pKVM using SEAM (please correct me
if I'm missing something):

- As we are interested in pKVM for client-side platforms (Chromebooks)
  which have no SEAM hardware, using SEAM does not seem to be an option
  at all. And even if it was, we still prefer the current (software
  based) pKVM design, since we need not just memory protection but also
  device protection, and generally we prefer to have more flexibility.

- Sean had a concern that kernel deprivileging may require intrusive
  changes in the common x86 arch code outside KVM, but IIUC it's not
  quite the case. AFAICT the code needed for deprivileging (i.e. making
  the kernel run in VMX non-root as a VM) is almost fully contained
  within KVM, i.e. the rest of the kernel can remain largely agnostic of
  the fact that it is running in VMX non-root. (Jason, please correct me
  if I'm wrong.)

Outside KVM, there is a bit of changes in drivers/intel/iommu/ for a bit
of PV stuff for IOMMU in pKVM (not sure if that is already included in
this RFC), and if we go with a more PV based design [2] and not just for
VMX and EPT but also for IOMMU, then I expect we're gonna have more of
such PV changes for pKVM there, but still contained within Intel IOMMU
driver.

[1] https://lore.kernel.org/kvm/20230606181525.1295020-1-seanjc@google.com/
[2] https://lore.kernel.org/all/ZA9WM3xA6Qu5Q43K@google.com/

Thanks,
Dmytro

> 
>  -- Keir
> 
>>> to run protected VM with general OS and may with pass-thru secure devices support.
>>
>> Why?  What is the actual use case?
>>
>>> May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
>>> work out a SW-TDX solution, or just do some leverage from SEAM code?
>>
>> Throw away TDX and let KVM run its own code in SEAM.
>>
