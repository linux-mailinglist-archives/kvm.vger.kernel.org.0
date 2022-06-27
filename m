Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A6255E112
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiF0NYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiF0NYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 09:24:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EE063BE;
        Mon, 27 Jun 2022 06:24:52 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RDKrpL014505;
        Mon, 27 Jun 2022 13:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0AHL8AZDkqNDDEmvpD7+VWaXha+Xw2V5Mf/HF6f0TuY=;
 b=aJ+TyPjIJpLc+yzG3W0G6Pnem5DgEwRTCXnGkIdpdtTKIgM2+RrPcq50Ap1q9MuNIlxE
 ubzakoVb6ko9Ql2emOHxwkAiDyT5Q4xUtqlgFCEpCemlGEIZetoUvys3EQOYrdWLFkRG
 11vQzg3F/MxdP4ADByTqCi7LEulYEyzUwdyVLOJcHu63Nb8uMbeAsWmVmm/+8qXSNHHx
 fzC8D9C7t5ronn8ZFpuZPcTXbI1Q2Koj3f/oZNHpneyCNuwxX9KFgLB92T/j/w4PpPwz
 BlvKpiLBJb8UwoST7lo9g4uGOWWlnDH3Au15vudNmAb5bq099sVIizMKCgZqIJYx1coH qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gydbw035g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:24:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RDLTQu021700;
        Mon, 27 Jun 2022 13:24:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gydbw034h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:24:51 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RDJuKY031337;
        Mon, 27 Jun 2022 13:24:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3gwt08t9mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:24:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RDOkdL21168572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 13:24:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5509111C04C;
        Mon, 27 Jun 2022 13:24:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6274A11C04A;
        Mon, 27 Jun 2022 13:24:45 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 13:24:45 +0000 (GMT)
Message-ID: <0d90c2cb-e0e9-a112-1c85-9aa8fdd54311@linux.ibm.com>
Date:   Mon, 27 Jun 2022 15:29:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 1/3] KVM: s390: ipte lock for SCA access should be
 contained in KVM
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-2-pmorel@linux.ibm.com>
 <74a234eb-0705-3c42-214f-5cdc8b125c63@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <74a234eb-0705-3c42-214f-5cdc8b125c63@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UMMH4xadU8S7istT9M783qntWC0_LSnE
X-Proofpoint-ORIG-GUID: byymaZlGFS5i32Oe_-Yl1L8UjxSjYq8L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 07:47, Janosch Frank wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> We can check if SIIF is enabled by testing the sclp_info struct
>> instead of testing the sie control block eca variable.
>> sclp.has_ssif is the only requirement to set ECA_SII anyway
>> so we can go straight to the source for that.
> 
> 
> The subject and commit description don't fit together.
> You're doing two things in this patch and only describe one of them.
> 
> I'd suggest something like this:
> 
> KVM: s390: Cleanup ipte lock access and SIIF facility checks
> 
> We can check if SIIF is enabled by testing the sclp_info struct instead 
> of testing the sie control block eca variable as that facility is always 
> enabled if available.
> 
> Also let's cleanup all the ipte related struct member accesses which 
> currently happen by referencing the KVM struct via the VCPU struct. 
> Making the KVM struct the parameter to the ipte_* functions removes one 
> level of indirection which makes the code more readable.
> 

OK done.


> 
> Other than that I'm happy with this patch.


Thanks,

Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
