Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF0545C11
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 08:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346387AbiFJGEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 02:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244653AbiFJGEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 02:04:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5969C3D48A
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 23:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654841050; x=1686377050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=23TlCDe7zMdYv/o/w9W7FZcE4hNNti1jU8iXb//GEHI=;
  b=bGqvI+yAs5HnujY6HBN4+/95uaa2wJbVGfnK+R33th5xyK+V74wQ3+52
   Xo2mWa9VHpoEClGjNlxrskN+HAy3J2+SL8kosFeuQDJfdqYpJ9wL2WrT3
   qPTJoRz4tCmsdXIFikcD7dlMh8xITgJgtv2Ds3QB2nv5LoLLn4/VSnuDP
   aLHQiE3LEKAUK6J4ia2eVTnp6yC3v2wmh6Xuj/tEjgOq45Ol/ehqTKmQv
   3AMX63PtUk3ZGpGAw07Fe50hcuiI0IjjOTsEKv4E36VhOAwYXfv1+g7UQ
   +p4HLgqgfP8a8rG/ydx0BaarkyXk51ZFgntFciwtvsAccaQ9xAalR7Yo8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278666752"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278666752"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 23:04:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="828061223"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.27]) ([10.255.29.27])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 23:04:08 -0700
Message-ID: <18ca771e-9901-5730-ff7a-d3ce935687de@intel.com>
Date:   Fri, 10 Jun 2022 14:03:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com>
 <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
 <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
 <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com>
 <CALMp9eQL1YmS+Ysn7ZPQjcha6HoqALNVTBqTLO7iTFpZMgyUAg@mail.gmail.com>
 <CALMp9eRO0K7L=OtoE4MWok6_7cy0DX5FyjPw6Sv83cZBCws0AQ@mail.gmail.com>
 <a77e6ccf-e694-b71d-b4e6-fa851459382c@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <a77e6ccf-e694-b71d-b4e6-fa851459382c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/10/2022 12:56 PM, Like Xu wrote:
> On 10/6/2022 12:22 pm, Jim Mattson wrote:
>> On Thu, Jun 9, 2022 at 9:16 PM Jim Mattson <jmattson@google.com> wrote:
>>>
>>> On Thu, Jun 9, 2022 at 7:49 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>
>>>> RDPMC Intel Operation:
>>
>> Actually, the key phrase is also present in the pseudocode you quoted:
>>
>>>> MSCB = Most Significant Counter Bit (* Model-specific *)
>>>> IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates 
>>>> a supported
>>>> counter))
>>   ...
>>
>> The final conjunct in that condition is false under KVM when
>> !enable_pmu, because there are no supported counters.
>
> Uh, I have lifted a stone and smashed my own feet.
>
> Please move on with #GP expectation.
Thank you two!
