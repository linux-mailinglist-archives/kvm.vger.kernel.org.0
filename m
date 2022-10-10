Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4A5F9F29
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJJNKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 09:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJJNKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 09:10:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E103915718;
        Mon, 10 Oct 2022 06:10:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29ACue60011472;
        Mon, 10 Oct 2022 13:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+P3hQRCynIBxrklRQT3Di9PZqt/NJ+VejWPlet9Qa8Y=;
 b=A6d5Mlk6OxkTbAcJQpFmalG9CuHtwXORcRta4Jwc0LNtx/i6bxdTCsvL7ve8v5ttf2xS
 HyRBkJcVDqBQMHHcz18dw1DqMN7Eb0glMyfuGuz/wQvPBEQTei0+Gf1iB/9IVVyzj9p+
 h/PRaFysvhptQcZnGNjgyg8ZFkQGxP2iiD3Qn0q3LPXenwFyvnYgygjJnrxX5MrOtwOJ
 bXTfFHCdcsOSl5xqI4leNUAOZ/941K72aec8zQPwjprBjkBXFPmzdI66hlqZkn9tCBtc
 BB67BmDzbMcmVZrB8+psf1IBkTZZuoDfF9mmSKKhzgO45GmTS3UuId5FAT2qg9fiAvoO 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k6hn23g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 13:10:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29ABpawO019166;
        Mon, 10 Oct 2022 13:10:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k6hn21p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 13:10:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AD8aiS015820;
        Mon, 10 Oct 2022 13:10:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3k30u9atsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 13:10:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29ADAZsS59179418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 13:10:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 094ED11C04A;
        Mon, 10 Oct 2022 13:10:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8630611C04C;
        Mon, 10 Oct 2022 13:10:34 +0000 (GMT)
Received: from [9.171.5.210] (unknown [9.171.5.210])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 13:10:34 +0000 (GMT)
Message-ID: <0059c67b-3dda-e95d-9b96-8c69af77bbb9@linux.ibm.com>
Date:   Mon, 10 Oct 2022 15:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v14 3/6] KVM: s390: pv: add
 KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
 <20220930140150.37463-4-imbrenda@linux.ibm.com>
 <748d07b8-1746-c12a-ccfb-89c8b15901d9@linux.ibm.com>
 <20221010141511.25eca963@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221010141511.25eca963@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cJ0kc0EUsOhaRT70Ny5FY9WtqjizMOrl
X-Proofpoint-GUID: kFry-r5W_Zz1dUJHC-EK-gbFzUU3b7Pb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_07,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100076
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/22 14:15, Claudio Imbrenda wrote:
> On Mon, 10 Oct 2022 13:45:54 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 9/30/22 16:01, Claudio Imbrenda wrote:
>>> Add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE to signal that the
>>> KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for the
>>> KVM_S390_PV_COMMAND ioctl are available.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/kvm-s390.c | 3 +++
>>>    include/uapi/linux/kvm.h | 1 +
>>>    2 files changed, 4 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index d0027964a6f5..7a3bd68efd85 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>    	case KVM_CAP_S390_BPB:
>>>    		r = test_facility(82);
>>>    		break;
>>> +	case KVM_CAP_S390_PROTECTED_ASYNC_DISABLE:
>>> +		r = async_destroy && is_prot_virt_host();
>>> +		break;
>>>    	case KVM_CAP_S390_PROTECTED:
>>>    		r = is_prot_virt_host();
>>>    		break;
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 02602c5c1975..9afe0084b2c5 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
>>>    #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
>>>    #define KVM_CAP_S390_ZPCI_OP 221
>>>    #define KVM_CAP_S390_CPU_TOPOLOGY 222
>>> +#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 225
>>
>> I can see 223 in Paolo's next, is there a 224 that I've missed?
> 
> no, I set this to an arbitrarily high value to avoid conficts
> 
> seems like I got it more or less right :)
> 
> feel free to change the value of the macro when merging, so it's
> contiguous.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

