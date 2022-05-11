Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA55D522FD4
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 11:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiEKJsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 05:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbiEKJsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 05:48:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AD44F9DE;
        Wed, 11 May 2022 02:48:35 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B95nxe029533;
        Wed, 11 May 2022 09:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TuwQ3MgSq7MD+WVVDQ3m7qzhPsrjv7nBqoz1C3SzmPU=;
 b=s/m0R0QTmzeW4Uj2JSAiSsmA4bFXtuOk2dYRJ88UIo2LPRzKpDOIvkhajTRm+k1s5gfg
 qCynT26adEdESjVup77vKUBXh4L65cVdqOQpWhttyNMVFz1uiGBinv3TcgO4hVBVSQic
 GRMouKb1KvrVwM++KnpMw5pYJogPPKJV+ylpY3OtbochpNwBhNG9BMv5NSwTGO7QleeW
 gpydGURFK3P7BCji0L+dyajTMnxwEfnH/tfu2W/H5XiOXTd/rPmvePnPbVFo3Ppsy5ch
 PPk1yStSZYEmu4/GyPQTsJwY0njqYljRqL6VkgBFYkUrTkJP0GQWtEX1zJeVEiHLcqqL Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0a6yrpw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 09:48:34 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24B9Z3m8006079;
        Wed, 11 May 2022 09:48:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0a6yrpvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 09:48:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24B9bCcp024090;
        Wed, 11 May 2022 09:48:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3fwgd8v372-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 09:48:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24B9mSTF13107516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 09:48:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F2415204F;
        Wed, 11 May 2022 09:48:28 +0000 (GMT)
Received: from [9.152.224.122] (unknown [9.152.224.122])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6018852050;
        Wed, 11 May 2022 09:48:28 +0000 (GMT)
Message-ID: <e5f26b70-e5ab-b61c-4db7-95ab06214919@linux.ibm.com>
Date:   Wed, 11 May 2022 11:48:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
 <20220505124656.1954092-2-scgl@linux.ibm.com>
 <ff77e8df-cf67-6ee2-8a9f-7f79a5d90622@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <ff77e8df-cf67-6ee2-8a9f-7f79a5d90622@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TUV07-hmlGcSa67K5fDoVsj-Y-fI-N46
X-Proofpoint-GUID: IIG1CaQN2FmUUzfp42aRLzDHntBV9iOc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110042
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 19:13, Janosch Frank wrote:
> On 5/5/22 14:46, Janis Schoetterl-Glausch wrote:
>> sclp_feat_check takes care of adjusting the bit numbering such that they
>> can be defined as they are in the documentation.
>>
>> Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> The fixing part of this is:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> But please add the (E)SOP bits in the other patches.

Oh, yeah, that slipped by me.
> 
>> ---
>>   lib/s390x/sclp.h | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index fead007a..4ce2209f 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -134,13 +134,15 @@ struct sclp_facilities {
>>   };
>>     /* bit number within a certain byte */
>> -#define SCLP_FEAT_85_BIT_GSLS        7
>> -#define SCLP_FEAT_98_BIT_KSS        0
>> -#define SCLP_FEAT_116_BIT_64BSCAO    7
>> -#define SCLP_FEAT_116_BIT_CMMA        6
>> -#define SCLP_FEAT_116_BIT_ESCA        3
>> -#define SCLP_FEAT_117_BIT_PFMFI        6
>> -#define SCLP_FEAT_117_BIT_IBS        5
>> +#define SCLP_FEAT_80_BIT_SOP        2
>> +#define SCLP_FEAT_85_BIT_GSLS        0
>> +#define SCLP_FEAT_85_BIT_ESOP        6
>> +#define SCLP_FEAT_98_BIT_KSS        7
>> +#define SCLP_FEAT_116_BIT_64BSCAO    0
>> +#define SCLP_FEAT_116_BIT_CMMA        1
>> +#define SCLP_FEAT_116_BIT_ESCA        4
>> +#define SCLP_FEAT_117_BIT_PFMFI        1
>> +#define SCLP_FEAT_117_BIT_IBS        2
>>     typedef struct ReadInfo {
>>       SCCBHeader h;
> 

