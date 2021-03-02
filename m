Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32EB32A7A4
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhCBQUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:20:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:29013 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379907AbhCBPxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 10:53:16 -0500
IronPort-SDR: JmGAddyfFXeSFTjweAZPtC6ojW61iU6VvUeGzbZrLN6WQQ7foDKmmHEyrGl4CjASLlBzJcMdXG
 zpArI4yUdm0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="186186383"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186186383"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 07:48:59 -0800
IronPort-SDR: wVcckAcNDKw1mDHGz+UUI2L2TTkTW5I2/4Wo5ktkxjiscoWYocw50CK5sKaXUQ9rdx93cMNjjx
 9hZ/1V4OL7bw==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="406772369"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO arkane-mobl1.gar.corp.intel.com) ([10.212.216.3])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 02 Mar 2021 07:48:57 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Borislav Petkov" <bp@alien8.de>, "Kai Huang" <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
 <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
 <20210301105346.GC6699@zn.tnic>
 <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
 <20210301113257.GD6699@zn.tnic>
 <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
Date:   Tue, 02 Mar 2021 09:48:56 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0zmwm1ogwjvjmi@arkane-mobl1.gar.corp.intel.com>
In-Reply-To: <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 01 Mar 2021 05:43:06 -0600, Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2021-03-01 at 12:32 +0100, Borislav Petkov wrote:
>> On Tue, Mar 02, 2021 at 12:28:27AM +1300, Kai Huang wrote:
>> > I think some script can utilize /proc/cpuinfo. For instance, admin  
>> can have
>> > automation tool/script to deploy enclave (with sgx2) apps, and that  
>> script can check
>> > whether platform supports sgx2 or not, before it can deploy those  
>> enclave apps. Or
>> > enclave author may just want to check /proc/cpuinfo to know whether  
>> the machine can
>> > be used for testing sgx2 enclave or not.
>>
>> This doesn't sound like a concrete use of this. So you can hide it
>> initially with "" until you guys have a use case. Exposing it later is
>> always easy vs exposing it now and then not being able to change it
>> anymore.
>>
>
> Hi Haitao, Jarkko,
>
> Do you have more concrete use case of needing "sgx2" in /proc/cpuinfo?
>

I don't have specific use cases so far. But I think users would expect all  
sub-features supported by the cpu in /proc/cpuinfo. And it is a more  
convenient and readily available tool than cpuid for verifying sgx2  
enabled in HW. So it'd be just nice for cpuinfo to be consistent with  
cpuid output.

Thanks
Haitao
