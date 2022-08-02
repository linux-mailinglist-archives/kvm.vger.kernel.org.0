Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8882B587878
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiHBH43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbiHBH4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:56:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735A531DD9
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:56:20 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2727g14k003002
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=emwPPD6OXXQo+hg7zw1i46RIHjHaRUovL/XuRpcPt4E=;
 b=owQ1sMbXk8GRef6GNjFVMeuh8xQsTy78UXZZYPioiKackLsM3mYLhZLGu8tTeC+AD92c
 eqXqvUwhK+nyCRdBBWBeOgijDaRtlEezNTCIKpWho8+Gtb6nqqVA7aCRpT8Hps3aEisA
 EzhxQp98R22aQLY73J+jYDgQ/IYKSi48ERM4DLFaDpfkwcgo1A6LDOdkBlzLyPxHL/VK
 H7v79a8yML/DNYTIMqPR/kLzOPiNOfagqWF93eNHTbmY3eQu1FM02YmBteuBZYvAeJLo
 A3iXvA2wmBYF6Gw//miAjl+KSV12MS2zOGbPcqjSZk/6IdNrDZ2D3zl9vYxKJw7W32N7 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpyrvrb5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:56:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2727hSoH012513
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:56:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpyrvrb4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:56:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2727qJNo001727;
        Tue, 2 Aug 2022 07:56:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98kdaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:56:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727uTc032309504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:56:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1532F4C04E;
        Tue,  2 Aug 2022 07:56:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA34F4C046;
        Tue,  2 Aug 2022 07:56:12 +0000 (GMT)
Received: from [9.145.60.210] (unknown [9.145.60.210])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 07:56:12 +0000 (GMT)
Message-ID: <f08b1d12-f7ee-ae77-9c8c-ada4131d9324@linux.ibm.com>
Date:   Tue, 2 Aug 2022 09:56:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: snippets: asm: Add a macro to
 write an exception PSW
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20220729082633.277240-1-frankja@linux.ibm.com>
 <20220729082633.277240-2-frankja@linux.ibm.com>
 <165942423514.253051.2592124003163681093@localhost.localdomain>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <165942423514.253051.2592124003163681093@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IKuwG1uwaL9-rP9t-pdMhIyuOppNuUo5
X-Proofpoint-GUID: ydd73ltZwn8QOXBlQBS3Jiz7FM51oh74
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208020036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/22 09:10, Nico Boehr wrote:
> Quoting Janosch Frank (2022-07-29 10:26:28)
> [...]
>> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
>> index 8dd66bd9..f4d75388 100644
>> --- a/s390x/snippets/asm/snippet-pv-diag-500.S
>> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
>> @@ -8,6 +8,7 @@
>>    *  Janosch Frank <frankja@linux.ibm.com>
>>    */
>>   #include <asm/asm-offsets.h>
>> +#include "macros.S"
>>   .section .text
>>   
>>   /* Clean and pre-load registers that are used for diag 500 */
>> @@ -21,10 +22,7 @@ lghi %r3, 3
>>   lghi   %r4, 4
>>   
>>   /* Let's jump to the next label on a PGM */
>> -xgr    %r5, %r5
>> -stg    %r5, GEN_LC_PGM_NEW_PSW
> 
> So previously the PSW mask was zero and hence we had 24-bit addressing, no? Now, we have bits 31 and 32 one and hence 64 bit addressing.

Yes
Also the linker script patch will exchange the mask for an invalid one 
so we need to replace both the mask and the address.

> 
> I guess 24-bit addressing is not appropriate here (or at least doesn't matter too much), so I guess this is intended, isn't it?


Claudio complained about the addressing change so I moved it over to 
full 64 bit.
