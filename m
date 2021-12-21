Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7696247BBC2
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 09:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhLUIW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 03:22:58 -0500
Received: from 5.mo548.mail-out.ovh.net ([188.165.49.213]:53399 "EHLO
        5.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhLUIW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 03:22:58 -0500
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.149])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id D443920890;
        Tue, 21 Dec 2021 08:22:55 +0000 (UTC)
Received: from kaod.org (37.59.142.102) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 21 Dec
 2021 09:22:54 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-102R0044d8bfc19-396c-481b-b929-127b9419749d,
                    742E9276A26BC2B4C6C283707E5EBA255AB8FB31) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <cad67609-fa1f-f234-7205-2735dd438797@kaod.org>
Date:   Tue, 21 Dec 2021 09:22:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Merge powerpc's debugfs entry content
 into generic entry
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
CC:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        David Stevens <stevensd@chromium.org>,
        <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
References: <20211220012351.2719879-1-aik@ozlabs.ru>
 <6111f49a-6ab9-2aba-92b1-ae02db3859b2@kaod.org>
 <b63e0570-934e-522f-8567-c9c4c438a55e@ozlabs.ru>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <b63e0570-934e-522f-8567-c9c4c438a55e@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.102]
X-ClientProxiedBy: DAG2EX1.mxp5.local (172.16.2.11) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 606a9c4e-6963-4284-9d4e-855090539a27
X-Ovh-Tracer-Id: 10294947273805630313
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddruddtfedguddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpefhhfelgeeukedtteffvdffueeiuefgkeekleehleetfedtgfetffefheeugeelheenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> -	xive->dentry = debugfs_create_file(name, S_IRUGO, arch_debugfs_dir,
>>> +	xive->dentry = debugfs_create_file("xive", S_IRUGO, xive->kvm->debugfs_dentry,
>>>    					   xive, &xive_debug_fops);
>>
>> The KVM XIVE device implements a "xics-on-xive" interface, the XICS hcalls
>> on top of the XIVE native PowerNV (OPAL) interface, and ...
>>
>>> -	pr_debug("%s: created %s\n", __func__, name);
>>> -	kfree(name);
>>> +	pr_debug("%s: created\n", __func__);
>>>    }
>>>    
>>>    static void kvmppc_xive_init(struct kvm_device *dev)
>>> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
>>> index 99db9ac49901..e86f5b6c2ae1 100644
>>> --- a/arch/powerpc/kvm/book3s_xive_native.c
>>> +++ b/arch/powerpc/kvm/book3s_xive_native.c
>>> @@ -1259,19 +1259,10 @@ DEFINE_SHOW_ATTRIBUTE(xive_native_debug);
>>>    
>>>    static void xive_native_debugfs_init(struct kvmppc_xive *xive)
>>>    {
>>> -	char *name;
>>> -
>>> -	name = kasprintf(GFP_KERNEL, "kvm-xive-%p", xive);
>>> -	if (!name) {
>>> -		pr_err("%s: no memory for name\n", __func__);
>>> -		return;
>>> -	}
>>> -
>>> -	xive->dentry = debugfs_create_file(name, 0444, arch_debugfs_dir,
>>> +	xive->dentry = debugfs_create_file("xive", 0444, xive->kvm->debugfs_dentry,
>>>    					   xive, &xive_native_debug_fops);
>>
>> ... the KVM XIVE *native* device implements a "xive" interface", the one
>> using MMIOs for interrupt management.
>>
>> May be it's worth making the difference in the user interface ?
> 
> 
> The content of these xive files is quite different so I kept the same
> name as before, I can change if you think it is worth it, should I? 

It's not very important. The contents differ anyhow.

> You
> are probably the only person who looked at it recently (or ever?) :) Thanks,

and you just did ! :)

Cheers,

C.
