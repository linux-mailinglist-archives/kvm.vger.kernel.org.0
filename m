Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE6055D54C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiF0NPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 09:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbiF0NPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 09:15:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A291183B;
        Mon, 27 Jun 2022 06:12:09 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RClVqx016203;
        Mon, 27 Jun 2022 13:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aR0eTGVRIMQ639wYavxhZjwoRkP1rs6D8kBbppDHllI=;
 b=MSMs1YKTGzVb0HC5JnhOuftL6cj8SliWpbpjrckfYwUizb475m70r/UPjxc8GRnE+DXx
 9zal7KC/YGPmPcdyFMSkJiOzNxid6o5VAjqcue/l+4AgMo6QuxcdzCLG2efkvx75ZQHO
 0NvyArk72WSfYRE2mnq1mrWNXWQuiT0UaROqFeGhT67Q1oNSQhuq1wfyZL+tojKzDg0E
 X5TMi7QTT8x9iI5QRAQg2J2btpqgKwrDs5HgDHbEBM26FFbOFhUyPZc3KjQ2qxx2YFTd
 jQz99bX3mHotAYj9PurHV12StYakv9frpzLNWsPi47Rdi5OfZpXWH8lAR/96FUWuBrNx Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycuwgvme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:12:08 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RCpLIA029868;
        Mon, 27 Jun 2022 13:12:08 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gycuwgvkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:12:08 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RD5l3q013202;
        Mon, 27 Jun 2022 13:12:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt09294r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:12:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RDC3oJ22479184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 13:12:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1124E11C054;
        Mon, 27 Jun 2022 13:12:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C7D811C050;
        Mon, 27 Jun 2022 13:12:02 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 13:12:02 +0000 (GMT)
Message-ID: <209a959b-b971-c06b-1731-6356908c623a@linux.ibm.com>
Date:   Mon, 27 Jun 2022 15:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <165605380436.8840.11959073846437899088@localhost.localdomain>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <165605380436.8840.11959073846437899088@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UGwuSklWixrFAwvKrEzDmFk18VVK-9-C
X-Proofpoint-ORIG-GUID: toBu6ryOlJAGCcnQC9Y0J9anEZgMhEc6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206270058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 08:56, Nico Boehr wrote:
> Quoting Pierre Morel (2022-06-20 14:54:36)
> [...]
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 766028d54a3e..bb54196d4ed6 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
> [...]
>> @@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>          rc = kvm_s390_vcpu_setup(vcpu);
>>          if (rc)
>>                  goto out_ucontrol_uninit;
>> +
>> +       kvm_s390_sca_set_mtcr(vcpu->kvm);
> 
> We set the MTCR in the vcpu create. Does it also make sense to set it in kvm_arch_vcpu_destroy?

I think you are right.

Even we only destroy vCPU when we destroy the VM and I think that it is 
not currently needed, it would be more logical to do so, and we will be 
ready for the day we can unplug vCPUs.

Unless somebody has another opinion I add the entry.

> 
> [...]
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 12c464c7cddf..77a692238585 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
> [...]
>> +       case 15:
>> +               trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>> +               insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>> +               return -EREMOTE;
> 
> Maybe the API documentation should clearly note that once you turn on KVM_CAP_S390_CPU_TOPOLOGY, you will get exits to userspace for STSI 15.x.y, regardless of whether KVM_CAP_S390_USER_STSI is on or off.
> 
> Other than that, looks good, hence:
> 
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
