Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52706554EFA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359193AbiFVPU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 11:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358961AbiFVPU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 11:20:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC573D1C9
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 08:20:24 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MEpCus018405;
        Wed, 22 Jun 2022 15:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2ZoQbI22i2XTHQYUksNJTgcFuYfkMb40kwjOpxt8NF8=;
 b=H+CQ81R4In6aPzmjmmdp8V8+QxpMYRfOoR/platbSHR1QYMaakg48UQDF2/6w93vsjUT
 LvCK6WrS0D8qc6QY7jzq3APUr2oFarVCLkLEpL1IElV9DUiv4Jm4zhiZqAcXwYN/Zi0Y
 rMsxCrudLciKy0l4iUOYaWytQY8CkxVKhsnoMMt9ZS1bgQr2PFcZgfpRPVYOdYA1AmMG
 nZL7EGOS0Ri0XHtC2tMxa7/fc/q1ZULbIvCPmNkDGAHMOBOS0O5JQQ1oHCkp1e1ZCLWW
 V3088FOqZGxKo8bPh6uqpJFJ/lje4E3RXtTfNlHvY6wjUJva2RMBEkgRn61z86G8J74W Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gv56x8ujd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 15:20:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25MEq5L6020754;
        Wed, 22 Jun 2022 15:20:18 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gv56x8uhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 15:20:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25MFK3dK018870;
        Wed, 22 Jun 2022 15:20:17 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3gt009bvba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 15:20:17 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25MFKGD310486042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 15:20:16 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 183F07805F;
        Wed, 22 Jun 2022 15:20:16 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C10A578063;
        Wed, 22 Jun 2022 15:20:14 +0000 (GMT)
Received: from [9.211.143.38] (unknown [9.211.143.38])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 22 Jun 2022 15:20:14 +0000 (GMT)
Message-ID: <12e29f2a-8641-7ba0-0dc4-1a7f97a7ca49@linux.ibm.com>
Date:   Wed, 22 Jun 2022 11:20:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v7 3/8] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
 <20220606203614.110928-4-mjrosato@linux.ibm.com>
 <ea3daac0-875d-dd9d-7ad0-65a0aed2aaed@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <ea3daac0-875d-dd9d-7ad0-65a0aed2aaed@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QeFyy9oNksTkeSBmzxn4EuUBZJKqBpV1
X-Proofpoint-GUID: l9Bi08vowIQ1SDmeaAo4Qo2mQVufqj96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-22_04,2022-06-22_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 4:35 AM, Pierre Morel wrote:
> 
> 
> On 6/6/22 22:36, Matthew Rosato wrote:
>> If the ZPCI_OP ioctl reports that is is available and usable, then the
>> underlying KVM host will enable load/store intepretation for any guest
>> device without a SHM bit in the guest function handle.  For a device that
>> will be using interpretation support, ensure the guest function handle
>> matches the host function handle; this value is re-checked every time the
>> guest issues a SET PCI FN to enable the guest device as it is the only
>> opportunity to reflect function handle changes.
>>
>> By default, unless interpret=off is specified, interpretation support 
>> will
>> always be assumed and exploited if the necessary ioctl and features are
>> available on the host kernel.  When these are unavailable, we will 
>> silently
>> revert to the interception model; this allows existing guest 
>> configurations
>> to work unmodified on hosts with and without zPCI interpretation support,
>> allowing QEMU to choose the best support model available.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/meson.build            |  1 +
>>   hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-inst.c        | 16 ++++++++
>>   hw/s390x/s390-pci-kvm.c         | 22 +++++++++++
>>   include/hw/s390x/s390-pci-bus.h |  1 +
>>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>>   target/s390x/kvm/kvm.c          |  7 ++++
>>   target/s390x/kvm/kvm_s390x.h    |  1 +
>>   8 files changed, 137 insertions(+), 1 deletion(-)
>>   create mode 100644 hw/s390x/s390-pci-kvm.c
>>   create mode 100644 include/hw/s390x/s390-pci-kvm.h
>>
>> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
>> index feefe0717e..f291016fee 100644
>> --- a/hw/s390x/meson.build
>> +++ b/hw/s390x/meson.build
>> @@ -23,6 +23,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>>     's390-skeys-kvm.c',
>>     's390-stattrib-kvm.c',
>>     'pv.c',
>> +  's390-pci-kvm.c',
>>   ))
> 
> Here...
> 
>> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
>> new file mode 100644
>> index 0000000000..0f16104a74
>> --- /dev/null
>> +++ b/hw/s390x/s390-pci-kvm.c
> 
> ...and here:
> 
> Shouldn't this file go in target/s390x/kvm ?
> 
> 

I wasn't sure tbh, there seems to be precedent to use hw/s390x already 
today for kvm-specific pieces of hardware support (e.g. tod, skeys, pv, 
stattrib) whereas target/s390x/kvm has only kvm.c?

Anyone else have an opinion on this one?


