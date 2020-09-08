Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4699F260E88
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 11:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgIHJSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 05:18:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727995AbgIHJSK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 05:18:10 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08891IZB120137;
        Tue, 8 Sep 2020 05:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+L7eR1mUzEA3NqUNFDNEfaZEiTX65PiIGb5FivUwZIU=;
 b=RvuBD8DuppneLr5et2nlwoOpkiUi+lrDMqKUAPWUuu0tycALuNBff8HbQQR+1FyVySzL
 4QcwjGFGahumg267ioG94uoUEjWSmH9hkl8z4r0lXTLeWXtoo9nlf9LVXcAthc/CsTWa
 B4WnU1HAFb3he1Q7U8gKt/Ey2V1zga2zzrG+RkauZyGeWH3mo7BTuiFqh3UX0kpf/H7J
 vLL13RLxZDwSN69NO2PMvermAQhydoRHf00ehF+ATNoDyeRY6VcHBSbPNhsyzj8HCCYC
 z0jn1hwB6c9lD9TqNOtx+WdJZwrHrQbEgp9ouRKCeBMSrqoZc2ElWhFrhEuKYbe8I3kd LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5yeacu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 05:18:08 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08891P7k120799;
        Tue, 8 Sep 2020 05:18:08 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5yeact4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 05:18:08 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0889FGCa003175;
        Tue, 8 Sep 2020 09:18:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 33c2a8a03y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:18:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0889I31Z36962674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 09:18:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E871AE057;
        Tue,  8 Sep 2020 09:18:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D369BAE05D;
        Tue,  8 Sep 2020 09:18:02 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.146.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 09:18:02 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: s390: Introduce storage key removal facility
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
References: <b34e559a-8292-873f-8d33-1e7ce819f4d5@de.ibm.com>
 <20200907143352.96618-1-frankja@linux.ibm.com>
 <20200907183030.07333af7.cohuck@redhat.com>
 <cd3ce2d9-99a5-5bb5-9b13-62d378274265@linux.ibm.com>
 <20200908103650.0c8cf352.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <185f1fb3-66a5-587e-470c-d228ffd77c2e@de.ibm.com>
Date:   Tue, 8 Sep 2020 11:18:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200908103650.0c8cf352.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_04:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.09.20 10:36, Cornelia Huck wrote:
> On Tue, 8 Sep 2020 09:52:48 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 9/7/20 6:30 PM, Cornelia Huck wrote:
>>> On Mon,  7 Sep 2020 10:33:52 -0400
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>   
>>>> The storage key removal facility makes skey related instructions
>>>> result in special operation program exceptions. It is based on the
>>>> Keyless Subset Facility.
>>>>
>>>> The usual suspects are iske, sske, rrbe and their respective
>>>> variants. lpsw(e), pfmf and tprot can also specify a key and essa with
>>>> an ORC of 4 will consult the change bit, hence they all result in
>>>> exceptions.
>>>>
>>>> Unfortunately storage keys were so essential to the architecture, that
>>>> there is no facility bit that we could deactivate. That's why the
>>>> removal facility (bit 169) was introduced which makes it necessary,
>>>> that, if active, the skey related facilities 10, 14, 66, 145 and 149
>>>> are zero. Managing this requirement and migratability has to be done
>>>> in userspace, as KVM does not check the facilities it receives to be
>>>> able to easily implement userspace emulation.
>>>>
>>>> Removing storage key support allows us to circumvent complicated
>>>> emulation code and makes huge page support tremendously easier.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>
>>>> v2:
>>>> 	* Removed the likely
>>>> 	* Updated and re-shuffeled the comments which had the wrong information
>>>>
>>>> ---
>>>>  arch/s390/kvm/intercept.c | 40 ++++++++++++++++++++++++++++++++++++++-
>>>>  arch/s390/kvm/kvm-s390.c  |  5 +++++
>>>>  arch/s390/kvm/priv.c      | 26 ++++++++++++++++++++++---
>>>>  3 files changed, 67 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
>>>> index e7a7c499a73f..983647ea2abe 100644
>>>> --- a/arch/s390/kvm/intercept.c
>>>> +++ b/arch/s390/kvm/intercept.c
>>>> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
>>>>  	case ICPT_OPEREXC:
>>>>  	case ICPT_PARTEXEC:
>>>>  	case ICPT_IOINST:
>>>> +	case ICPT_KSS:
>>>>  		/* instruction only stored for these icptcodes */
>>>>  		ilen = insn_length(vcpu->arch.sie_block->ipa >> 8);
>>>>  		/* Use the length of the EXECUTE instruction if necessary */
>>>> @@ -565,7 +566,44 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
>>>>  		rc = handle_partial_execution(vcpu);
>>>>  		break;
>>>>  	case ICPT_KSS:
>>>> -		rc = kvm_s390_skey_check_enable(vcpu);
>>>> +		if (!test_kvm_facility(vcpu->kvm, 169)) {
>>>> +			rc = kvm_s390_skey_check_enable(vcpu);
>>>> +		} else {  
>>>
>>> <bikeshed>Introduce a helper function? This is getting a bit hard to
>>> read.</bikeshed>
>>>   
>>>> +			/*
>>>> +			 * Storage key removal facility emulation.
>>>> +			 *
>>>> +			 * KSS is the same priority as an instruction
>>>> +			 * interception. Hence we need handling here
>>>> +			 * and in the instruction emulation code.
>>>> +			 *
>>>> +			 * KSS is nullifying (no psw forward), SKRF
>>>> +			 * issues suppressing SPECIAL OPS, so we need
>>>> +			 * to forward by hand.
>>>> +			 */
>>>> +			switch (vcpu->arch.sie_block->ipa) {
>>>> +			case 0xb2b2:
>>>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>>>> +				rc = kvm_s390_handle_b2(vcpu);
>>>> +				break;
>>>> +			case 0x8200:  
>>>
>>> Can we have speaking names? I can only guess that this is an lpsw...  
>>
>> You can only guess from the kvm_s390_handle_lpsw() call below? ;-)
>>
>> I'd be happy to put this into an own function and add some comments to
>> the cases where we lack them. However, I don't really want to define
>> constants for speaking names.
> 
> Well, I can guess the lpsw here :) but not the b2b2 above. Maybe add a
> comment like /* handle lpsw/lpswe */?

I think we can remove these 2 case statements and rely on the default case anyway.
> 
>>
>>>   
>>>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>>>> +				rc = kvm_s390_handle_lpsw(vcpu);
>>>> +				break;
>>>> +			case 0:
>>>> +				/*
>>>> +				 * Interception caused by a key in a
>>>> +				 * exception new PSW mask. The guest
>>>> +				 * PSW has already been updated to the
>>>> +				 * non-valid PSW so we only need to
>>>> +				 * inject a PGM.
>>>> +				 */
>>>> +				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>>>> +				break;
>>>> +			default:
>>>> +				kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
>>>> +				rc = kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPERATION);
>>>> +			}
>>>> +		}
>>>>  		break;
>>>>  	case ICPT_MCHKREQ:
>>>>  	case ICPT_INT_ENABLE:  
>>>   
>>
>>
> 
