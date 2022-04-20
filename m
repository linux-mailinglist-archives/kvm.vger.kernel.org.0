Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5F508F64
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 20:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381149AbiDTSbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 14:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345676AbiDTSa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 14:30:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DC01EAD1;
        Wed, 20 Apr 2022 11:28:11 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KI75lZ020277;
        Wed, 20 Apr 2022 18:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C6aahPwojO4fi663wVKm4G2MabLycZE7ZCsBerbjchA=;
 b=E1Yp/JJJizPZ2q59aeX8nG7Gz2NN/wQNI40AF0BBLPrbMdjd/sYTSAmKyzGmM8HrkmsK
 GhEWk2GQkQUOG9GJ28k+Jg6coMyhyHOq4uT2/YJDSVWZs3M/VcCu+0hzyZf9V8EtAFrn
 zBks1QUCUGS6SwHafE1euhwyd0Y61VQjOssPkGaj+wQvBddo2Ko58T12E+y8MKkZ6/Ei
 rZQNBOMjAg4F0uwaUc7DJmpZ0ZI91UDWT7BmMYjxSI5/NeuTiwviTb4FebGRtH1FmIeA
 7D3YDE1c2RGwKGUs2ZQBjqQ0yrLNnSC5J+sLHn2K90DFRg3oj5kQ8j+8Msjw7uW2oLwC BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7rga14b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:28:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KIN92S019540;
        Wed, 20 Apr 2022 18:28:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7rga141-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:28:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KIDoeU024439;
        Wed, 20 Apr 2022 18:28:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9cx2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 18:28:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KIS5DO41288042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 18:28:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11EEAAE04D;
        Wed, 20 Apr 2022 18:28:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E9D2AE045;
        Wed, 20 Apr 2022 18:28:04 +0000 (GMT)
Received: from [9.171.15.220] (unknown [9.171.15.220])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 18:28:04 +0000 (GMT)
Message-ID: <f6c24447-2ed5-163a-8853-d70253eed0e8@linux.ibm.com>
Date:   Wed, 20 Apr 2022 20:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 1/2] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-2-pmorel@linux.ibm.com> <Yl/27Pz3pvARmIHn@osiris>
 <20220420152241.4d9edea5@p-imbrenda> <YmBQD278Uje6LXly@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <YmBQD278Uje6LXly@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZJGkMvZsEyfo3ix1oIK8_z86EX-ifIzI
X-Proofpoint-ORIG-GUID: srIcHPuc9MrrVLHMZDhEhNhPEnhdWzZf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_05,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200107
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/22 20:25, Heiko Carstens wrote:
> On Wed, Apr 20, 2022 at 03:22:41PM +0200, Claudio Imbrenda wrote:
>> On Wed, 20 Apr 2022 14:05:00 +0200
>> Heiko Carstens <hca@linux.ibm.com> wrote:
>>
>>>> +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	if (!test_kvm_facility(vcpu->kvm, 11))
>>>> +		return false;
>>>> +
>>>> +	/* A new vCPU has been hotplugged */
>>>> +	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
>>>> +		return true;
>>>> +
>>>> +	/* The real CPU backing up the vCPU moved to another socket */
>>>> +	if (cpumask_test_cpu(vcpu->cpu,
>>>> +			     topology_core_cpumask(vcpu->arch.prev_cpu)))
>>>> +		return true;
>>>> +
>>>> +	return false;
>>>> +}
>>>
>>> This seems to be wrong. I'd guess that you need
>>>
>>> 	if (cpumask_test_cpu(vcpu->cpu,
>>> 			     topology_core_cpumask(vcpu->arch.prev_cpu)))
>>> -->		return false;
>>> -->	return true;
>>
>> so if the CPU moved to a different socket, it's not a change?
>> and if nothing happened, it is a change?
> 
> How do you translate the above code to your statement?
> 

Take care that the comment is also wrong.
I will of course change it too.

-- 
Pierre Morel
IBM Lab Boeblingen
