Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2A95087C8
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378420AbiDTMNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 08:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352815AbiDTMND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 08:13:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616E237C8;
        Wed, 20 Apr 2022 05:10:17 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K9KKgH024495;
        Wed, 20 Apr 2022 12:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iCgUOzBhDfl6Q/aq4LR70HlGXG5TAEqD5SgugqIK7/o=;
 b=KMaOUgYSwDEaO76AhrgE6Q0xw9E52NMzNKofBA3nE/Rj5NrV7QAZPvKM5CjMih0BkLs/
 0f5QQf/qHWxqnoL+omAF/86oufqGV6HS0veKynYGX1Aaoo1Be9S4L8r0L94M/K7U05+V
 F8ge/ASN+I1PRGcd4M18ur5ymFONo8b7qEHWfg9GQDqIAHeV44DUnxzKmN7l3kgDwWyH
 0IS81bVW6Ux8TcEE0PTWHtWchJgHG+A7tmOBRN0wKZTH9rjFdSWzsafBiuo2ed7XUHGw
 yo/oU+ZyULVXC8q28S9Qnw8UKtGtKfJT2VH6YDUvLSGn1LzGb/286a5T3JbpvBSjyMXt lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2u8k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:10:16 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KC8EcH013057;
        Wed, 20 Apr 2022 12:10:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2u8hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:10:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KC8mdl030107;
        Wed, 20 Apr 2022 12:10:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ffne8vx56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 12:10:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KCALe46750794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 12:10:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D2CA11C052;
        Wed, 20 Apr 2022 12:10:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C839411C04A;
        Wed, 20 Apr 2022 12:10:09 +0000 (GMT)
Received: from [9.171.58.217] (unknown [9.171.58.217])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 12:10:09 +0000 (GMT)
Message-ID: <75a152f6-2ea3-8af9-ca9a-5493c3ac885e@linux.ibm.com>
Date:   Wed, 20 Apr 2022 14:13:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-2-pmorel@linux.ibm.com> <Yl/27Pz3pvARmIHn@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Yl/27Pz3pvARmIHn@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zItRefrBfeE5ux2YTOmHTHvjNgormApQ
X-Proofpoint-ORIG-GUID: x4tiqNpaDvKIjuO6jMd7KOJubM6WDBII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=980 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200073
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/22 14:05, Heiko Carstens wrote:
>> +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!test_kvm_facility(vcpu->kvm, 11))
>> +		return false;
>> +
>> +	/* A new vCPU has been hotplugged */
>> +	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
>> +		return true;
>> +
>> +	/* The real CPU backing up the vCPU moved to another socket */
>> +	if (cpumask_test_cpu(vcpu->cpu,
>> +			     topology_core_cpumask(vcpu->arch.prev_cpu)))
>> +		return true;
>> +
>> +	return false;
>> +}
> 
> This seems to be wrong. I'd guess that you need
> 
> 	if (cpumask_test_cpu(vcpu->cpu,
> 			     topology_core_cpumask(vcpu->arch.prev_cpu)))
> -->		return false;
> -->	return true;
> 

/o\

I do not know if I can do this right at the end!

Thanks, I send an update immediately
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
