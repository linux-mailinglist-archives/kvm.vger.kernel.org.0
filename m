Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA09E63EFEF
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiLALxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiLALwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:52:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A5FC38
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:52:48 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1BjOp1020802;
        Thu, 1 Dec 2022 11:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xqS6QbBW8ODJFNE4gcGi9rrzUH9f7YDDtJkyIcWZ5rQ=;
 b=N2/gZBUwkHYGGfz2M/cEY5c8esk5Wkg8zK7aaHLkl+FOCBJPzvQcEE2MhUbAIPZEHr7W
 t5xoSa7oClvg9KOKGdiMTEwtjh8vcVkBVT7/AdPTbCtTp0gYNGZkFfeb1lqlAT8AAJSs
 YvurJGkAK4wGvwdXq9NmwM2ui7niVuxfz5SxGog4XPgsNQWfbpOYzLCTVMiAwbSayuQf
 2B7LK1GTtAJ8WVm8THIaimPgMAWHYWJC7HZDgFQjH2VD+HmZ5MstGW3IOsZHoD4sGGjN
 n0psC5N30Gu7cQuenDlGgpVS0azff0Yz1eyDHxJ+npLD6Xel987vfKM/B6dSyemNGQna GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6unv0493-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 11:52:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1BlLur028650;
        Thu, 1 Dec 2022 11:52:34 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6unv048c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 11:52:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1Bq0sr004326;
        Thu, 1 Dec 2022 11:52:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae9d9ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 11:52:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1BqS0i8061450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 11:52:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2C3C11C04A;
        Thu,  1 Dec 2022 11:52:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE97D11C04C;
        Thu,  1 Dec 2022 11:52:26 +0000 (GMT)
Received: from [9.171.21.111] (unknown [9.171.21.111])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 11:52:26 +0000 (GMT)
Message-ID: <ea965d1c-ab6a-5aa3-8ce3-65b8177f6320@linux.ibm.com>
Date:   Thu, 1 Dec 2022 12:52:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-7-pmorel@linux.ibm.com>
 <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hw5nlMbfqsyN_fVcQdkhbpDyG2meUXbn
X-Proofpoint-ORIG-GUID: -ohskUUqf2S37VIPWiEAwvjH6hPLS4n8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010083
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/1/22 11:15, Thomas Huth wrote:
> On 29/11/2022 18.42, Pierre Morel wrote:
>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>> the topology facility for the guest in the case the topology
>> is available in QEMU and in KVM.
>>
>> The feature is fenced for SE (secure execution).
> 
> Out of curiosity: Why does it not work yet?
> 
>> To allow smooth migration with old QEMU the feature is disabled by
>> default using the CPU flag -disable-topology.
> 
> I stared at this code for a while now, but I have to admit that I don't 
> quite get it. Why do we need a new "disable" feature flag here? I think 
> it is pretty much impossible to set "ctop=on" with an older version of 
> QEMU, since it would require the QEMU to enable 
> KVM_CAP_S390_CPU_TOPOLOGY in the kernel for this feature bit - and older 
> versions of QEMU don't set this capability yet.
> 
> Which scenario would fail without this disable-topology feature bit? 
> What do I miss?

The only scenario it provides is that ctop is then disabled by default 
on newer QEMU allowing migration between old and new QEMU for older 
machine without changing the CPU flags.

Otherwise, we would need -ctop=off on newer QEMU to disable the topology.


> 
>> Making the S390_FEAT_CONFIGURATION_TOPOLOGY belonging to the
>> default features makes the -ctop CPU flag is no more necessary,
> 
> too many verbs in this sentence ;-)

definitively :)

> 
>> turning the topology feature on is done with -disable-topology
>> only.
> ...
> 
>   Thomas
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
