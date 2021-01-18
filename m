Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE71A2FA712
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406713AbhARRIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:08:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406893AbhARRIG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:08:06 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10IGXlHk140751;
        Mon, 18 Jan 2021 12:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nOiJLIo106Cpat4KWMS7JpogysP/9MwXiVEDgdX4HvE=;
 b=jLdnSVU9/R6Zwv2S4yrQxbl/P8BU8MlTSvcE1NEPrRWxbYQQEM/h22tyyyCZAbYCjvrb
 3VaA1CVcOcU1yeD2PpHP69TgxOop/E9CokRw/ZAbOv6WjdhoAqTKNimvluuwtf1fhg+w
 V6778qg5QcJJg8IJrLKEt4cDfkcU7ykCeXGTsecIvHXcU4npKL8q+EEImeYm5xB3Yuvk
 8Z2Qa2pT+UjiNE1CDRwTWLbZe+RfDI7pSItSFF99xQIG6FbJJj9Vei0DNYnLOR1E/yoe
 erBx8oEd4dm7DmLu00IL0StiWmZASxp37ZFms/Vv34inYjtVnO8ero5Kbq0Sb7bCw2q2 og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365d8ta45n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 12:06:54 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10IGaC54154470;
        Mon, 18 Jan 2021 12:06:54 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365d8ta44w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 12:06:53 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10IH2gsY001195;
        Mon, 18 Jan 2021 17:06:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 363qs895nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 17:06:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10IH6gwG31457734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 17:06:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BCB94C040;
        Mon, 18 Jan 2021 17:06:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E9DC4C046;
        Mon, 18 Jan 2021 17:06:47 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.2.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Jan 2021 17:06:47 +0000 (GMT)
Subject: Re: [PATCH v7 13/13] s390: Recognize confidential-guest-support
 option
To:     Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-14-david@gibson.dropbear.id.au>
 <20210115173647.28f4cc9e.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <2aab901d-4f32-46bd-dcb0-425a31cb5e1f@de.ibm.com>
Date:   Mon, 18 Jan 2021 18:06:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115173647.28f4cc9e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_13:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.01.21 17:36, Cornelia Huck wrote:
> On Thu, 14 Jan 2021 10:58:11 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
>> At least some s390 cpu models support "Protected Virtualization" (PV),
>> a mechanism to protect guests from eavesdropping by a compromised
>> hypervisor.
>>
>> This is similar in function to other mechanisms like AMD's SEV and
>> POWER's PEF, which are controlled by the "confidential-guest-support"
>> machine option.  s390 is a slightly special case, because we already
>> supported PV, simply by using a CPU model with the required feature
>> (S390_FEAT_UNPACK).
>>
>> To integrate this with the option used by other platforms, we
>> implement the following compromise:
>>
>>  - When the confidential-guest-support option is set, s390 will
>>    recognize it, verify that the CPU can support PV (failing if not)
>>    and set virtio default options necessary for encrypted or protected
>>    guests, as on other platforms.  i.e. if confidential-guest-support
>>    is set, we will either create a guest capable of entering PV mode,
>>    or fail outright.
>>
>>  - If confidential-guest-support is not set, guests might still be
>>    able to enter PV mode, if the CPU has the right model.  This may be
>>    a little surprising, but shouldn't actually be harmful.
>>
>> To start a guest supporting Protected Virtualization using the new
>> option use the command line arguments:
>>     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0
>>
>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>> ---
>>  docs/confidential-guest-support.txt |  3 ++
>>  docs/system/s390x/protvirt.rst      | 19 ++++++---
>>  hw/s390x/pv.c                       | 62 +++++++++++++++++++++++++++++
>>  include/hw/s390x/pv.h               |  1 +
>>  target/s390x/kvm.c                  |  3 ++
>>  5 files changed, 82 insertions(+), 6 deletions(-)
>>
> 
> (...)
> 
>> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
>> +{
>> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
>> +        return 0;
>> +    }
>> +
>> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
>> +        error_setg(errp,
>> +                   "CPU model does not support Protected Virtualization");
>> +        return -1;
>> +    }
>> +
>> +    cgs->ready = true;
>> +
>> +    return 0;
>> +}
> 
> Do we want to add a migration blocker here? If we keep the one that is
> added when the guest transitions, we'll end up with two of them, but
> that might be easier than trying to unify it.

that whould be fine with me. We still need to move things around to
make sure that the cpu model is already in place, though. 
