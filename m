Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC7A1CA7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfH2O0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 10:26:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfH2O0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 10:26:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TEDbY6121965;
        Thu, 29 Aug 2019 14:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VM7U3ulJIpm8PedSQ9NraLh7L3JdiYZKsAXFk1U52Qc=;
 b=P+21lZZxITVxHx+aPfRUoOUCXEfKe+E7iZQXYFydaAg8oRceDVyrSgD+tW+RFyx9kzIy
 ybKMecU9u+u7C7tnQ8DoiXzj/mLcAwuigyzM3HFx6sozauciEbw/FcFXW2jqqsoT233A
 SEfJoYLk6QMAefk8ZPl1fjhgz0SwyS12ESlZj8mhwCoo3ihVL/LazRmu2QB2RaAQeF70
 7FcXjaGotrkGJJSte2MYsZTEhszEZFtLq9TGyaXUY6Y6vuateUpOWbRFP/u8vk7XaWig
 yQKHSOgoYL4RpJyTHdFm1EFhdgo13i2NqZXU4JWps0cbbhvPW1ICoDTOA0KmXRNQdGWk OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2upg74g6kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 14:24:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TECqF4055716;
        Thu, 29 Aug 2019 14:24:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2upc8urv7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 14:24:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TEOaT6028347;
        Thu, 29 Aug 2019 14:24:36 GMT
Received: from [10.175.160.184] (/10.175.160.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 07:24:36 -0700
Subject: Re: [PATCH v1] cpuidle-haltpoll: vcpu hotplug support
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190828185650.16923-1-joao.m.martins@oracle.com>
 <20190829115634.GA4949@amt.cnet>
 <8c459d91-bc47-2ff4-7d3b-243ed4e466cb@oracle.com>
Message-ID: <311c2ffe-f840-9990-c1a7-5561cc5a0f54@oracle.com>
Date:   Thu, 29 Aug 2019 15:24:31 +0100
MIME-Version: 1.0
In-Reply-To: <8c459d91-bc47-2ff4-7d3b-243ed4e466cb@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=913
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=975 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 2:50 PM, Joao Martins wrote:
> On 8/29/19 12:56 PM, Marcelo Tosatti wrote:
>> Hi Joao,
>>
>> On Wed, Aug 28, 2019 at 07:56:50PM +0100, Joao Martins wrote:
>>> +static void haltpoll_uninit(void)
>>> +{
>>> +	unsigned int cpu;
>>> +
>>> +	cpus_read_lock();
>>> +
>>> +	for_each_online_cpu(cpu) {
>>> +		struct cpuidle_device *dev =
>>> +			per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
>>> +
>>> +		if (!dev->registered)
>>> +			continue;
>>> +
>>> +		arch_haltpoll_disable(cpu);
>>> +		cpuidle_unregister_device(dev);
>>> +	}
>>
>> 1)
>>
>>> +
>>> +	cpuidle_unregister(&haltpoll_driver);
>>
>> cpuidle_unregister_driver.
> 
> Will fix -- this was an oversight.
> 
>>
>>> +	free_percpu(haltpoll_cpuidle_devices);
>>> +	haltpoll_cpuidle_devices = NULL;
>>> +
>>> +	cpus_read_unlock();
>>
>> Any reason you can't cpus_read_unlock() at 1) ?
>>
> No, let me adjust that too.
> 
>> Looks good otherwise.
>>

BTW, should I take this as a Acked-by, Reviewed-by, or neither? :)

	Joao
