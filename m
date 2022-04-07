Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BEB4F8427
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345228AbiDGP6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiDGP6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:58:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BF5186C2;
        Thu,  7 Apr 2022 08:56:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qh7so11710742ejb.11;
        Thu, 07 Apr 2022 08:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oCLMqmvOfrGHdJ8J/9MpyAUq5T7nSt9PnJCJFfJ9Ovk=;
        b=Jjdme6TkPQCxRndLVwSWEmXsH+5XV2u2wSD04m/9PtSYUTEIxnH8bdqjxBptswdOsp
         oxAvvcbc7H2zLtAt21L8MuOwjYBAnen2avSBzWvPbErnOR7m+TYSW/f1cqk46bUbIDg4
         1at3cXZOxStoj/ryZamYb7saJkKz5YcvF/CRv48rljNPKqMaRI1oxxqmupBYLxNPXaNc
         IJuIm+Qgy+Lb5sswyGQ1lk//qot5tbLKY6/xS5ku5hIUn0gvQLLoy2BC6bjqmesnnpJ7
         oWq90Tiq1nEeW+VFKl5p1oTmpme6j01Nrcc1TikdH5tcw9hyb0WAX3Wqmb2SwAcj3k/J
         pEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oCLMqmvOfrGHdJ8J/9MpyAUq5T7nSt9PnJCJFfJ9Ovk=;
        b=qO9FuAfFWHA/VC9C7Xd7hyqI7J5P0gL54z2YIJKVMzQfVL1D+8nMOMRbMdcDlkLhOX
         Sx0NLCcucmVJUPjxqrkatO/1JkWLCCPSxW0kjZrq5JAoZa05ZGL3H3rC0/1vkbJ5wD0A
         As80bfVkGiV2uKYv9ejZyrDU+fEHTgCJDvQ3LnLRizQqxV1w8fTKDUY2CJwQGHD1rxV2
         OekkWIBnfCdjdiurCRLf2AtXOc8DOxSMXvib78WxoxWTEd9WJQfMgCyMxjcTGg8qZFcW
         0h9dDcVdaP/nR5rlkm6xyuMGZBe5hSmHvk+0uwayBsY/KTNtNGYUoMEBaYNOcC7ase5z
         C+dA==
X-Gm-Message-State: AOAM531iuk4Phab/Jz451uwSmkovuPe07oCSE83RAyMMClQWL2s0B7Jc
        jP3h5eTNHSUXrEUPg2Wamlk=
X-Google-Smtp-Source: ABdhPJwmsBMWfmYtE1epMAcbjNmECu4QuUPr2e6Y7Rp+be9nlQcvwEIUjIorCFTMM79og/wYaRSnPg==
X-Received: by 2002:a17:906:314b:b0:6d6:da31:e545 with SMTP id e11-20020a170906314b00b006d6da31e545mr14619905eje.125.1649346966605;
        Thu, 07 Apr 2022 08:56:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id er22-20020a170907739600b006e7e873ed6csm5228123ejc.53.2022.04.07.08.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 08:56:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
Date:   Thu, 7 Apr 2022 17:56:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yk79A4EdiZoVQMsV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 17:02, Sean Christopherson wrote:
> On Thu, Apr 07, 2022, Paolo Bonzini wrote:
>> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
>>> +	bool interrupt_disabled = tdvmcall_p1_read(vcpu);
>>
>> Where is R12 documented for TDG.VP.VMCALL<Instruction.HLT>?
>>
>>> +		 * Virtual interrupt can arrive after TDG.VM.VMCALL<HLT> during
>>> +		 * the TDX module executing.  On the other hand, KVM doesn't
>>> +		 * know if vcpu was executing in the guest TD or the TDX module.
>>
>> I don't understand this; why isn't it enough to check PI.ON or something
>> like that as part of HLT emulation?
> 
> Ooh, I think I remember what this is.  This is for the case where the virtual
> interrupt is recognized, i.e. set in vmcs.RVI, between the STI and "HLT".  KVM
> doesn't have access to RVI and the interrupt is no longer in the PID (because it
> was "recognized".  It doesn't get delivered in the guest because the TDCALL
> completes before interrupts are enabled.
> 
> I lobbied to get this fixed in the TDX module by immediately resuming the guest
> in this case, but obviously that was unsuccessful.

So the TDX module sets RVI while in an STI interrupt shadow.  So far so 
good.  Then:

- it receives the HLT TDCALL from the guest.  The interrupt shadow at 
this point is gone.

- it knows that there is an interrupt that can be delivered (RVI > PPR 
&& EFLAGS.IF=1, the other conditions of 29.2.2 don't matter)

- it forwards the HLT TDCALL nevertheless, to a clueless hypervisor that 
has no way to glean either RVI or PPR?

It's absurd that this be treated as anything but a bug.


Until that is fixed, KVM needs to do something like:

- every time a bit is set in PID.PIR, set tdx->buggy_hlt_workaround = 1

- every time TDG.VP.VMCALL<HLT> is received, 
xchg(&tdx->buggy_hlt_workaround, 0) and return immediately to the guest 
if it is 1.

Basically an internal version of PID.ON.

>>> +		details.full = td_state_non_arch_read64(
>>> +			to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
>>
>> TDX documentation says "the meaning of the field may change with Intel TDX
>> module version", where is this field documented?  I cannot find any "other
>> guest state" fields in the TDX documentation.
> 
> IMO we should put a stake in the ground and refuse to accept code that consumes
> "non-architectural" state.  It's all software, having non-architectural APIs is
> completely ridiculous.

Having them is fine, *using* them to work around undocumented bugs is 
the ridiculous part.

You didn't answer the other question, which is "Where is R12 documented 
for TDG.VP.VMCALL<Instruction.HLT>?" though...  Should I be worried? :)


Paolo
