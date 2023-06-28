Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F32740A57
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjF1IC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjF1IAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:00:14 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A8530F4;
        Wed, 28 Jun 2023 00:58:33 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f866383b25so52083551cf.2;
        Wed, 28 Jun 2023 00:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687939113; x=1690531113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F/+deGlxyQCKIrMGFxX8jHr01O2OkIlhTbQJBNAZork=;
        b=awqK1cFbb17MzuXbfPbLPEOcKAYclyob4SmrhhpQ+kKMsl8HemL5243FavMu9pQCNz
         mfHXQ9lA4GKP4X9DOgF6FM+B64TWhOO5H+fPcQSMOS4NMZP2Lg9MZ3F1mtei7sTp0SeL
         TEMTfxSbBtI+ZZ65sTxUMVltX1uK8n+3JNdoLNt+V2YbMnN7ToSyaHI6Ir/7oU3aXewq
         JlI2QIXmFyenJj0N7Yz3XqAc1aEVNtNX7IqGxc4X92+S89CfqMrXo3Q2mZ9FdxWg0/Aj
         5Q6EgblYOAPLKOy2aOWDb5nBgeMuG2+I4GA5flb2au9h/yiSP9ofSCW/9FPEm64MLEZn
         1c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687939113; x=1690531113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F/+deGlxyQCKIrMGFxX8jHr01O2OkIlhTbQJBNAZork=;
        b=Xoq1aFzMOjtvc4XaV+p7UwdC9mOYJ6F+RHkmcZGLUVT06noLuKpd0nxLvLCVpWrFvh
         mz2TYJK/ep532x88qR23RRD8JG5+cboPPA+Dtf/+KF9RO0JU+ZzJebmLTR/6nnAGBwXC
         hsMZto2cfh9FI0gPHUkoRrjnx6CDTWGK0v1iDiWAA08DvuNdTDoEMUbOui/qYhLCo74P
         RKkPsN3y93XGIC86yoS6NOwdehT22WbpBQ215pXbFcot2UPdB7FTESOuitPnnu+1aMLl
         9XR7HCDhz+2aRzUFIDMVNQ2aGM3w2DdTwm7aColxrBYGJqzIWLOLxBJj46jxeTBygFS3
         WrLw==
X-Gm-Message-State: AC+VfDzrWcXSb3Rgef7avtHDq0LdhuzGKrQg/si75JejA57uQGvaa7St
        B4uGt6W/k6K9sZIz2HuyLUI2KwOLYBBl0TCq/Fw=
X-Google-Smtp-Source: ACHHUZ5PsMjkE6U+KR8YtxLpljtRAEcZQGHjuykQiMUpKkYUa6v25kgJ7pXl/FUYPLoxk1I4LZruWg==
X-Received: by 2002:a05:6a20:8f1d:b0:125:9d2e:ae20 with SMTP id b29-20020a056a208f1d00b001259d2eae20mr12043108pzk.59.1687932454211;
        Tue, 27 Jun 2023 23:07:34 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u8-20020a170903124800b001b03cda6389sm6902572plh.10.2023.06.27.23.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 23:07:33 -0700 (PDT)
Message-ID: <0b21f3b7-9946-4f65-71c7-260ef490928d@gmail.com>
Date:   Wed, 28 Jun 2023 14:07:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
Content-Language: en-US
To:     Xiong Y Zhang <xiong.y.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        Zhiyuan Lv <zhiyuan.lv@intel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-4-xiong.y.zhang@intel.com>
 <ZJYCtDN+ITmrgCUs@google.com>
 <MW4PR11MB5824653862500CB4F9EE4519BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
 <ZJnEFTXMpQkXdHRj@google.com>
 <MW4PR11MB5824B76276020C1A33A26A72BB27A@MW4PR11MB5824.namprd11.prod.outlook.com>
 <ZJr7GtTFg2uzck1c@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZJr7GtTFg2uzck1c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/6/2023 11:07 pm, Sean Christopherson wrote:
> On Tue, Jun 27, 2023, Xiong Y Zhang wrote:
>>> On Sun, Jun 25, 2023, Xiong Y Zhang wrote:
>>>>>> On Fri, Jun 16, 2023, Xiong Zhang wrote:
>>>>> 	/*
>>>>> 	 * Attempt to re-enable the vLBR event if it was disabled due to
>>>>> 	 * contention with host LBR usage, i.e. was put into an error state.
>>>>> 	 * Perf doesn't notify KVM if the host stops using LBRs, i.e. KVM needs
>>>>> 	 * to manually re-enable the event.
>>>>> 	 */
>>>>>
>>>>> Which begs the question, why can't there be a notification of some
>>>>> form that the LBRs are once again available?
>>>> This is perf scheduler rule. If pinned event couldn't get resource as
>>>> resource limitation, perf will put it into error state and exclude it
>>>> from perf scheduler, even if resource available later, perf won't
>>>> schedule it again as it is in error state, the only way to reschedule
>>>> it is to enable it again.  If non-pinned event couldn't get resource
>>>> as resource limitation, perf will put it into inactive state, perf
>>>> will reschedule it automatically once resource is available.  vLBR event is per
>>> process pinned event.
>>>
>>> That doesn't answer my question.  I get that all of this is subject to perf
>>> scheduling, I'm asking why perf doesn't communicate directly with KVM to
>>> coordinate access to LBRs instead of pulling the rug out from under KVM.
>> Perf doesn't need such notification interface currently, as non-pinned event
>> will be active automatically once resource available, only pinned event is
>> still in inactive even if resource available, perf may refuse to add such
>> interface for KVM usage only.
> 
> Or maybe perf will be overjoyed that someone is finally proposing a coherent
> interface.  Until we actually try/ask, we'll never know.

For the perf subsystem, KVM or any other perf_event in kernel space is just a user,
and any external logic that deeply interferes with perf management of host PMU
hw resources will be defeated without question.

> 
>>> Your other response[1] mostly answered that question, but I want explicit
>>> documentation on the contract between perf and KVM with respect to LBRs.  In
>>> short, please work with Weijiang to fulfill my request/demand[*] that someone
>>> document KVM's LBR support, and justify the "design".  I am simply not willing to
>>> take KVM LBR patches until that documentation is provided.
>> Sure, I will work with Weijiang to supply such documentation. Will this
>> document be put in Documentation/virt/kvm/x86/ ?
> 
> Ya, Documentation/virt/kvm/x86/pmu.rst please.

Please pay extra attention to the current status and expectations of co-existence
in the documentation. I'm really looking forward to this document written from
the perspective of a new vPMU developer. Thanks.
