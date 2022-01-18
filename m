Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B6492D11
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbiARSOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:14:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347851AbiARSOc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:14:32 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IH21gB020493;
        Tue, 18 Jan 2022 18:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OeeIQHqSciwW8HtOkIWIfQsZnXz5o0lCVu5yRMTLSyE=;
 b=oymmLdS8mgGgX202aInL1EajDhGARWY0Zy+Jd8gEsTYuNC8hA7U+vW32G5ZO2nyAZwlU
 TQXvkW6QQf+YQWBTtASbXTiqRRmS7WaugMiVZBSHtuRUIiYdbPdRMwdqIjX7KD2msIFb
 siJxRXwGI4ApB9asDIgaXADyhPdivXvYjzaaFjACxT20mo0UDRodNcx84W2AWHjeU5Yn
 OTfWO4OmXOuQ7LrpK6eF2LcDuon+4QOX4RNYEWnIZSc80RJ+yXnD2Eqb3Z0JB7YFQJRw
 yLWIweljJYCaJQepJCNsjAXfVAlYDUa39eDkdOpRWT54/eEJTpkclzBFXfqSsEnb0TtW Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1kehugw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:14:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHlALQ005227;
        Tue, 18 Jan 2022 18:14:27 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1kehuga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:14:26 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IIDY2Y015506;
        Tue, 18 Jan 2022 18:14:25 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3dknwbmt99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:14:25 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IIEMVR30212398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:14:22 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB14C6E054;
        Tue, 18 Jan 2022 18:14:22 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56F4A6E058;
        Tue, 18 Jan 2022 18:14:21 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:14:21 +0000 (GMT)
Message-ID: <c4332e29-755d-378f-1e10-de8cc75f0387@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:14:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 4/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-5-mjrosato@linux.ibm.com>
 <9f55cf89-9d58-b1c5-0d97-d0730498b62f@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9f55cf89-9d58-b1c5-0d97-d0730498b62f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dqFDtpTBfAeCKNOg7Ab3nqEQL-S9A1hR
X-Proofpoint-ORIG-GUID: GU6hwFD1tTh9LEIpVME2YgJrZoKJkF1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 10:38 AM, Thomas Huth wrote:
> On 14/01/2022 21.38, Matthew Rosato wrote:
>> Use the associated vfio feature ioctl to enable interpretation for 
>> devices
>> when requested.  As part of this process, we must use the host function
>> handle rather than a QEMU-generated one -- this is provided as part of 
>> the
>> ioctl payload.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c          | 70 +++++++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-inst.c         | 63 +++++++++++++++++++++++++++-
>>   hw/s390x/s390-pci-vfio.c         | 52 ++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-bus.h  |  1 +
>>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>>   5 files changed, 199 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>> index 01b58ebc70..a39ccfee05 100644
>> --- a/hw/s390x/s390-pci-bus.c
>> +++ b/hw/s390x/s390-pci-bus.c
> ...
>> @@ -1360,6 +1427,7 @@ static Property s390_pci_device_properties[] = {
>>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
>> +    DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
>>       DEFINE_PROP_END_OF_LIST(),
>>   };
> 
> Since this is something that the user can see, would it maybe make sense 
> to provide a full word instead of an abbreviation here? I.e. "interpret" 
> or "interpretation" instead of "interp" ?

I'll go with "interpret" unless someone else has a strong opinion on it.
