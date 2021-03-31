Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B734FDE3
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 12:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhCaKRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 06:17:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59596 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234932AbhCaKRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 06:17:07 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VA4Ams048614;
        Wed, 31 Mar 2021 06:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=C8kUxv+2bXpizrz4+aDRQ+XvPYyfvHyVU18QKEBmuRM=;
 b=T1t1CeX4pMufzoi6mnu/JC50VBTnYL94fb8VXUK/x0AjSmzko8ZJrTWIB05LEv7xdogX
 cUqPj6jooGpwZi6eph3CG/34gGapXFwhAHjO/jq1vckDMhET4hbI13cRDpGLEFmEzNz9
 YjduAGz074UlOPXn9Go9JRWojFllsTNmVfMZi87fOZPNZjEP0gD1YrV0B/+kBCkggo/X
 QpBbaArI38ZYtDVfMeKI2lH2OT2slLFuRsbJkBYxkoqE3Hs3o8ijmgXp4ovjaZ3wWBCb
 juM/p/j+hVstWIjQhGxMu733R6U2GQh8l6UhZo+0LddBxcdUQhx6RopwE2fgQ4TY5DnV aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mb3h8tj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 06:16:34 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VA4Db6048910;
        Wed, 31 Mar 2021 06:16:34 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mb3h8thr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 06:16:34 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VA8YHo007152;
        Wed, 31 Mar 2021 10:16:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37matt0fg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 10:16:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VAGUgn36962594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 10:16:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15C715204F;
        Wed, 31 Mar 2021 10:16:30 +0000 (GMT)
Received: from [9.199.32.117] (unknown [9.199.32.117])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 12FE35204E;
        Wed, 31 Mar 2021 10:16:26 +0000 (GMT)
Subject: Re: [PATCH v3 3/3] ppc: Enable 2nd DAWR support on p10
To:     David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
Cc:     paulus@samba.org, mikey@neuling.org, kvm@vger.kernel.org,
        mst@redhat.com, mpe@ellerman.id.au, cohuck@redhat.com,
        qemu-devel@nongnu.org, qemu-ppc@nongnu.org, clg@kaod.org,
        pbonzini@redhat.com, Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
 <20210330095350.36309-4-ravi.bangoria@linux.ibm.com>
 <20210330184838.6b976c9d@bahia.lan> <YGO2Eug243hXZgNd@yekko.fritz.box>
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Message-ID: <06294618-728b-4df1-aab2-d9691045e0c8@linux.ibm.com>
Date:   Wed, 31 Mar 2021 15:46:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YGO2Eug243hXZgNd@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FF0amYkkBOydLxoKPfEk2kthbvPlJ_Qf
X-Proofpoint-GUID: v30qrOFCub9bsU5pCXv18DUPFh2yUvbt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_03:2021-03-30,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/21 5:06 AM, David Gibson wrote:
> On Tue, Mar 30, 2021 at 06:48:38PM +0200, Greg Kurz wrote:
>> On Tue, 30 Mar 2021 15:23:50 +0530
>> Ravi Bangoria <ravi.bangoria@linux.ibm.com> wrote:
>>
>>> As per the PAPR, bit 0 of byte 64 in pa-features property indicates
>>> availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
>>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
>>> find whether kvm supports 2nd DAWR or not. If it's supported, allow
>>> user to set the pa-feature bit in guest DT using cap-dawr1 machine
>>> capability. Though, watchpoint on powerpc TCG guest is not supported
>>> and thus 2nd DAWR is not enabled for TCG mode.
>>>
>>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>>> ---
>>
>> LGTM. A couple of remarks, see below.
>>
>>>   hw/ppc/spapr.c                  | 11 ++++++++++-
>>>   hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
>>>   include/hw/ppc/spapr.h          |  6 +++++-
>>>   target/ppc/cpu.h                |  2 ++
>>>   target/ppc/kvm.c                | 12 ++++++++++++
>>>   target/ppc/kvm_ppc.h            |  7 +++++++
>>>   target/ppc/translate_init.c.inc | 15 +++++++++++++++
>>>   7 files changed, 83 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>>> index d56418ca29..4660ff9e6b 100644
>>> --- a/hw/ppc/spapr.c
>>> +++ b/hw/ppc/spapr.c
>>> @@ -238,7 +238,7 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>           0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>>>           /* 54: DecFP, 56: DecI, 58: SHA */
>>>           0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
>>> -        /* 60: NM atomic, 62: RNG */
>>> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
>>>           0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>>>       };
>>>       uint8_t *pa_features = NULL;
>>> @@ -256,6 +256,10 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>           pa_features = pa_features_300;
>>>           pa_size = sizeof(pa_features_300);
>>>       }
>>> +    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat_pvr)) {
>>> +        pa_features = pa_features_300;
>>> +        pa_size = sizeof(pa_features_300);
>>> +    }
>>
>> This isn't strictly needed right now because a POWER10 processor has
>> PCR_COMPAT_3_00, so the previous ppc_check_compat() block sets
>> pa_features to pa_features300 already. I guess this will make sense
>> when/if POWER10 has its own pa_features_310 one day.
> 
> This should be removed for now.  We're definitely too late for
> qemu-6.0 at this point, so might as well polish this.
> 
> The rest of Greg's comments look like they're good, too.

Sure. Will respin with these changes.

Thanks for the review,
Ravi
