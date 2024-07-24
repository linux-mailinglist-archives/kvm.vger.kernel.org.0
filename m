Return-Path: <kvm+bounces-22148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 209CD93AADF
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 04:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4BA92858C0
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 02:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3771D1757E;
	Wed, 24 Jul 2024 02:04:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA57817C67
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.110.167.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721786648; cv=none; b=CKsZTZj/Uj042SCBHjvcCBTR2rgI/KHP9K5YUt0DpSLd0MqcH2pJOstLJD23s5cCjUA4sFSNPfqkz9L7pG6uvgG6L9H8J9sFjV4eFWCtBHM9mXhyRVfn4bJnrDCONZbYH6ec21rG/eENzFshhYtbQzHn4IXG8k7gqSks5yZL8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721786648; c=relaxed/simple;
	bh=6m4z09A2LHr6A3Odmy3JHTZUKhw11uweAAJS+aqWVow=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jEMYCnmvbqUhIiS04IOdGqbmaqPjOyhpGfkDM4wzu7vfd61iybqGx6g4KLIEQsiJKLb9QWTJ+0QsThCDT+oNnf6GtjUKcLnMrT/Q8uSrnnhWes80q8nI5EXvUBYWfcPEDNJMT2NioDDBR4RdQnIZgIP/PMTOdpJ5peRygL+/Vl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=203.110.167.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1721786631-1eb14e4056969b0001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx2.zhaoxin.com with ESMTP id I6AMgsLmGBtq0PJ1 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 24 Jul 2024 10:03:51 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 24 Jul
 2024 10:03:51 +0800
Received: from [10.28.66.62] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 24 Jul
 2024 10:03:50 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Message-ID: <a8f89526-5226-4859-98ef-5342c360d7db@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.62
Date: Tue, 23 Jul 2024 22:03:49 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
To: Zhao Liu <zhao1.liu@intel.com>
X-ASG-Orig-Subj: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
CC: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<mtosatti@redhat.com>, <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
	<ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>
References: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>
 <ZnqSj4PGrUeZ7OT1@intel.com>
 <53119b66-3528-41d6-ac44-df166699500a@zhaoxin.com>
 <ZnrPdZdgcBSY1sMi@intel.com>
Content-Language: en-US
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <ZnrPdZdgcBSY1sMi@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1721786631
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1991
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.128040
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Dear Maintainers and Paolo,

I hope this message finds you well. I am writing to inquire about the 
status of
the patch I submitted a month ago. Could you please provide any updates or
addtional comments regarding its review?

Thank you for your time and assistance.

Best regards,
Ewan

On 6/25/24 10:08, Zhao Liu wrote:
>>> Additionally, has_msr_vmx_vmfunc has the similar compat issue. I think
>>> it deserves a fix, too.
>>>
>>> -Zhao
>> Thanks for your reply. In fact, I've tried to process has_msr_vmx_vmfunc in
>> the same
>> way as has_msr_vmx_procbased_ctls in this patch, but when I tested on Linux
>> kernel
>> 4.19.67, I encountered an "error: failed to set MSR 0x491 to 0x***".
>>
>> This issue is due to Linux kernel commit 27c42a1bb ("KVM: nVMX: Enable
>> VMFUNC
>> for the L1 hypervisor", 2017-08-03) exposing VMFUNC to the QEMU guest
>> without
>> corresponding VMFUNC MSR modification code, leading to an error when QEMU
>> attempts
>> to set the VMFUNC MSR. This bug affects kernels from 4.14 to 5.2, with a fix
>> introduced
>> in 5.3 by Paolo (e8a70bd4e "KVM: nVMX: allow setting the VMFUNC controls
>> MSR", 2019-07-02).
> It looks like this fix was not ported to the 4.19 stable kernel.
>
>> So the fix for has_msr_vmx_vmfunc is clearly different from
>> has_msr_vmx_procbased_ctls2.
>> However, due to the different kernel support situations, I have not yet come
>> up with a suitable
>> way to handle the compatibility of has_msr_vmx_procbased_ctls2 across
>> different kernel versions.
>>
>> Therefore, should we consider only fixing has_msr_vmx_procbased_ctls2 this
>> time and addressing
>> has_msr_vmx_vmfunc in a future patch when the timing is more appropriate?
>>
> I agree this fix should focus on MSR_IA32_VMX_PROCBASED_CTLS2.
>
> But I think at least we need a comment (maybe a TODO) to note the case of
> has_msr_vmx_vmfunc in a followup patch.
>
> Let's wait and see what Paolo will say.
>
> -Zhao


