Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E167632CDF8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 08:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhCDHzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 02:55:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:57527 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhCDHzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 02:55:14 -0500
IronPort-SDR: tNhDlivBvku/20EVIhzeQ026FImNIhEUqxzUvfWITD80c/MnCeC0877YXnE6hboTOytdyxDWid
 XQZCrOI4D7FA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251407291"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="251407291"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 23:54:33 -0800
IronPort-SDR: NuJhgYAltXQaRNb65mrv6QqJWpUD9p4tygKJVVwr5bz+sgCpRVQDetQAzXoLSlHElKgbLFqxsd
 EXP4isHeRzOA==
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="400475609"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 23:54:32 -0800
Subject: Re: Processor to run Intel PT in a Guest VM
To:     Aditya Basu <aditya.basu@psu.edu>
Cc:     "Jaeger, Trent Ray" <trj1@psu.edu>, kvm <kvm@vger.kernel.org>
References: <CAPn5F5zvmfpo3tdbfVDYC+rTBmVzQ8aGYG+7FrcbeRsnZKPs-w@mail.gmail.com>
 <0f76acb4-48ee-1e20-f3f1-de4efa276620@intel.com>
 <CAPn5F5xms0LnffB78ep-nsHH7LiJYaWv_1c0=Awfz9zcciaogQ@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <762ac97c-5ad9-978e-4962-7d57d9b59581@intel.com>
Date:   Thu, 4 Mar 2021 15:54:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAPn5F5xms0LnffB78ep-nsHH7LiJYaWv_1c0=Awfz9zcciaogQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Aditya,

On "Comet Lake", the answer will also be (unofficially) negative.
You may preferentially focus on the Small Core (Atom) or Hybrid Processors.

Ref: 
https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/include/asm/intel-family.h

On 2021/3/3 3:59, Aditya Basu wrote:
> Thanks a lot for the information. From what I see, the Atom P series
> are server-grade processors.
>
> Would you happen to know if any Desktop/Workstation processors (ex.
> 10th gen i9) also support this feature?
> Specifically, I'm referring to Comet Lake, here --
>
> https://ark.intel.com/content/www/us/en/ark/products/codename/90354/comet-lake.html
>
> Aditya
>
>
> Aditya
>
> On Mon, Mar 1, 2021 at 8:16 PM Xu, Like <like.xu@intel.com> wrote:
>> On 2021/3/2 2:48, Aditya Basu wrote:
>>> Hi all,
>>> I am a PhD student at the Pennsylvania State University. For my
>>> current project, I am trying to run Intel Processor Trace (PT) inside
>>> a Guest VM. Specifically, I want to run KVM in the "Host-Guest mode"
>>> as stated in the following bug:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=201565
>>>
>>> However, I *cannot* find an Intel processor that supports this mode. I
>>> have tried using Intel's i7-7700 and i7-9700k processors. Based on my
>>> findings, the problem seems to be that bit 24 (PT_USE_GPA) of
>>> MSR_IA32_VMX_PROCBASED_CTLS2 (high) is reported as 0 by the processor.
>>> Hence, KVM seems to force pt_mode to 0 (or PT_MODE_HOST).
>> You may try the Intel Atom® Processor P* Series.
>>
>> https://ark.intel.com/content/www/us/en/ark/products/series/29035/intel-atom-processor.html?wapkw=Atom#@Server
>>
>>> I would appreciate any pointers that someone might have regarding the
>>> above. Specifically, I want to find an Intel processor that supports
>>> running Intel PT in "Host-Guest mode".
>>>
>>> Regards,
>>>
>>> Aditya Basu
>>> PhD Student in CSE
>>> Pennsylvania State University
>>> https://www.adityabasu.me/

