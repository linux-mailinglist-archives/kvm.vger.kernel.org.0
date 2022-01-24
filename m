Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE155498335
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 16:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiAXPMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 10:12:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235253AbiAXPMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 10:12:09 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OF8nlT027898;
        Mon, 24 Jan 2022 15:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lPhKLDqPJLHpyaTG18JL3x+7XGzkxKYr807FpjmCzvg=;
 b=EZEkNdZeE7crXDINvY8ssVycqPe9mSQgpdr+aszWNYS9tQEXG9ppFtvEZ7i35bPnhPwq
 wS676aYpIex8Nr+8cRO1yJJUTDk8aZiFmOju1+v3JmojHwCJdB9Vxsjse5WWszZ1KS4w
 txJJPK8U4ff0z2TQScDCu0N8lF97qGBQfMENrkonGu5iuQjb5DC/N9EbETdIdqNNbDME
 A6p35Lq4hDfCzex34m+HUhNc9tBHbt+cDJkBjdcVoybASdMcYX1N9sirVs6Ss/3p8Eti
 9kGtmNdLIojMroGeJbeC1EGCZD3EQCiJigbS6ez72YwbYBEcAA385BUVDlDRrHYFOrE4 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsx890ka2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:12:08 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OFA5M1001262;
        Mon, 24 Jan 2022 15:12:07 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsx890k9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:12:07 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OF97kK001996;
        Mon, 24 Jan 2022 15:12:06 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3dr9j9g428-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 15:12:06 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OFC4NS33227126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 15:12:05 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93426A05D;
        Mon, 24 Jan 2022 15:12:04 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 139016A057;
        Mon, 24 Jan 2022 15:12:02 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jan 2022 15:12:02 +0000 (GMT)
Message-ID: <1aad9eaa-8a1f-2e56-2441-248ec3ceff2b@linux.ibm.com>
Date:   Mon, 24 Jan 2022 10:12:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 08/30] s390/pci: stash associated GISA designation
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        schnelle@linux.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-9-mjrosato@linux.ibm.com>
 <8bef8c96-219e-3c40-246b-b974c45a5315@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8bef8c96-219e-3c40-246b-b974c45a5315@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Pfd5eJqUlV3BE4Q3LvGNxT0l31KiPpWf
X-Proofpoint-GUID: awjRh5GMcqEeSrD4mhyAVw7jNfuGcwSN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_08,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 suspectscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 9:08 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> For passthrough devices, we will need to know the GISA designation of the
>> guest if interpretation facilities are to be used.  Setup to stash 
>> this in
>> the zdev and set a default of 0 (no GISA designation) for now; a 
>> subsequent
>> patch will set a valid GISA designation for passthrough devices.
>> Also, extend mpcific routines to specify this stashed designation as part
>> of the mpcific command.
>>
>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Reviewed-by: Eric Farman <farman@linux.ibm.com>
>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h     | 1 +
>>   arch/s390/include/asm/pci_clp.h | 3 ++-
>>   arch/s390/pci/pci.c             | 6 ++++++
>>   arch/s390/pci/pci_clp.c         | 1 +
>>   arch/s390/pci/pci_irq.c         | 5 +++++
>>   5 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 90824be5ce9a..2474b8d30f2a 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -123,6 +123,7 @@ struct zpci_dev {
>>       enum zpci_state state;
>>       u32        fid;        /* function ID, used by sclp */
>>       u32        fh;        /* function handle, used by insn's */
>> +    u32        gd;        /* GISA designation for passthrough */
> 
> I already gave my R-B, and do not want to remove it, but wouldn't it be 
> possible to use more explicit names like gisa_designation instead of 
> just gd.
> It would not change anything to the functionality but would facilitate 
> the maintenance?
> 

Honestly, I don't have a strong opinion on this one -- AFAICT struct 
zpci_dev has a fair mix of short names (fh) and explicit names 
(max_bus_speed).

It does require changes to this patch and various subsequent patches -- 
The changes are, as you say, not functional, so I think it's not a big deal?

I do think 'gisa_designation' is too verbose though -- How about just 
'gisa', this is the same name used in the structure where we get this 
value from (gisa in struct sie_page2)

As long as nobody objects I will s/gd/gisa/ here and in struct 
clp_req_set_pci, retaining review tags.
