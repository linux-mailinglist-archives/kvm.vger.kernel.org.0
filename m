Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6703FDD92
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 16:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244221AbhIAOBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 10:01:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242535AbhIAOBh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 10:01:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181DXw6w061707;
        Wed, 1 Sep 2021 09:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AyGCXqTlDxFDakHInkc1TJcPaYtvreQxI3c3MyOovZ0=;
 b=mxRP+lhXY+6m6BKpBUmt9xD9Wq6OvxF3K1iTovTBaMA0UTqgSyoKhL1jVmlILZ2+Ia5X
 PGbOS0iuHQZqvh0bBKnvRRf7BsRjQPK6aHq8fktRmrw/PINFRMM5YnqcrGasr8VgBvpy
 /qaD8sa3kzBhd7nTmXW1Am8T/c0CkUaJ/tgCGJEeX6GR00ZSV31P+WDyezvuH++hf+2O
 V2u68y9NopPBQpbiTUFKJqPJt35PyybLhI92SXI0h0fDgIKWxCfla+wtKeiSh+i0W6xw
 DgOOtZyEZHMnnWeVCPtGFikrHicaMOJq+WuIWa5jepawp8yIr1jLVr+A1qsIycAuR0l+ Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3at7ctx9ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 09:59:26 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 181DYaNT064566;
        Wed, 1 Sep 2021 09:59:26 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3at7ctx9e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 09:59:26 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181DmojZ004850;
        Wed, 1 Sep 2021 13:59:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3aqcs9a9s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 13:59:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181DxKoD47383008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 13:59:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92CF4AE058;
        Wed,  1 Sep 2021 13:59:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 201B0AE053;
        Wed,  1 Sep 2021 13:59:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.78])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 13:59:20 +0000 (GMT)
Subject: Re: [PATCH 0/2] s390x: ccw: A simple test device for virtio CCW
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, Michael S Tsirkin <mst@redhat.com>,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        qemu-s390x@nongnu.org, richard.henderson@linaro.org,
        qemu-devel@nongnu.org
References: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
 <fe2c0cbd-24a6-0785-6a64-22c6b6c01e6d@de.ibm.com>
 <20210830224204.49a7965a.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9bcd5bc3-06b9-f5f5-d6c5-949e70a71ffa@linux.ibm.com>
Date:   Wed, 1 Sep 2021 15:59:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210830224204.49a7965a.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bufpzJ1ZC30HoPccisE-0GDhcUUc92lJ
X-Proofpoint-GUID: jCiJ1AmJD9ieuTxsrzlFjyGXPnPSS9-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_04:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/30/21 10:42 PM, Halil Pasic wrote:
> On Mon, 30 Aug 2021 11:51:51 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 27.08.21 12:50, Pierre Morel wrote:
>>> Hello All,
>>>
>>>
>>> This series presents a VIRTIO test device which receives data on its
>>> input channel and sends back a simple checksum for the data it received
>>> on its output channel.
>>>    
>>> The goal is to allow a simple VIRTIO device driver to check the VIRTIO
>>> initialization and various data transfer.
> 
> Can you please elaborate a little on the objectives.

Yes I will, but I must think a lot more about it, I think doing the 
specifications you speak about later in this response is the right way 
to do it.


> 
>>>
>>> For this I introduced a new device ID for the device and having no
>>> Linux driver but a kvm-unit-test driver, I have the following
>>> questions:
>>
>> I think we should reserve an ID in the official virtio spec then for such a device?
>> Maybe also add mst for such things.
> 
> I agree having ID reserved is a good idea. But then if we are going to
> introduce an official test device, I believe we should write a
> specification for it as well. Yes having the guarantee that test devices
> and real devices won't mix is a value in itself, but if we had a
> standardized test device, whoever does work with it would not have to
> ask themselves is this test device compatible with this test device
> driver.

Yes right.

> 
>>    
>>
>>> Is there another way to advertise new VIRTIO IDs but Linux?
>>> If this QEMU test meet interest, should I write a Linux test program?
>>>
> 
> You may not simply claim and advertise a VIRTIO ID. The virtio ids
> are allocated by the virtio standardisation body, and the list of the
> IDs reserved in the v1.1-cs01 incarnation of the spec can be found here:
> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1930005
> 
> For how to contribute to the virtio specification please take look at
> this:
> https://github.com/oasis-tcs/virtio-admin/blob/master/README.md

Thanks, I will go this way.


Thanks for these constructive answers,

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
