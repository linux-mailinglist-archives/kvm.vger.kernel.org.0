Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DAC4E761C
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359800AbiCYPKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359835AbiCYPKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:10:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33B6DA0A8;
        Fri, 25 Mar 2022 08:07:54 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PDrt3S029330;
        Fri, 25 Mar 2022 15:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YRaLYfvaxXYeRP7SVAJmKPyuoPtpxvaAuGQli1N0Isw=;
 b=s/6vwqgVCstIECZQVyniKAzv+CMF7zmwOsqHCf6l1W9TlYzC3ufXo3kwgg3QAB9TDZ5e
 RyUjKp+3/UUIUyuFJ/OEdo5q4G/iCjF3zXfJBxQ0VYlYuGXvBIIw9MZfUCBVHbsBLKOC
 QtlW0Fkv3bevhKfGGq7DKpbU3i42ZxsBziw8o1HO8x8MaCAUFuPXMqKbcxMzxzmviSYm
 1TwYEPbzsw4V7x7e/BqtnOupwxMdAT3DeCaZUi5M0ppQ6yibKO8I+mrWHOEM2yykpo5A
 WpzUHE0wMHRSZJqZX7lXpmhEE/OieECjf36SmwJPGGexulYrHZsBJkwVZrV5e6yZjv/e oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f1f16srry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:07:54 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PDtpDc002208;
        Fri, 25 Mar 2022 15:07:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f1f16srqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:07:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PEvJP4018834;
        Fri, 25 Mar 2022 15:07:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t95hq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:07:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PF7mYp50200976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 15:07:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D80C52050;
        Fri, 25 Mar 2022 15:07:48 +0000 (GMT)
Received: from [9.145.191.115] (unknown [9.145.191.115])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C766F5204F;
        Fri, 25 Mar 2022 15:07:47 +0000 (GMT)
Message-ID: <34d7549b-40c0-a010-3a05-2adbe5f9c41d@linux.ibm.com>
Date:   Fri, 25 Mar 2022 16:07:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header file
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
References: <20220323170325.220848-1-nrb@linux.ibm.com>
 <20220323170325.220848-4-nrb@linux.ibm.com> <YjytK7iW7ucw/Gwj@osiris>
 <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
 <20220325153048.48306e40@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220325153048.48306e40@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yRmd61vSKIuUG9Irp85wsCSzZaG4Duqn
X-Proofpoint-GUID: z3JSMH9_xdYhambpNmE0Ggup1FIhaR31
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_04,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=857 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/22 15:30, Claudio Imbrenda wrote:
> On Fri, 25 Mar 2022 08:29:11 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 3/24/22 18:40, Heiko Carstens wrote:
>>> On Wed, Mar 23, 2022 at 06:03:19PM +0100, Nico Boehr wrote:
>>> ...
>>>> +static inline unsigned long load_guarded(unsigned long *p)
>>>> +{
>>>> +	unsigned long v;
>>>> +
>>>> +	asm(".insn rxy,0xe3000000004c, %0,%1"
>>>> +	    : "=d" (v)
>>>> +	    : "m" (*p)
>>>> +	    : "r14", "memory");
>>>> +	return v;
>>>> +}
>>>
>>> It was like that before, but why is r14 within the clobber list?
>>> That doesn't make sense.
>>
>> r14 is changed in the gs handler of the gs test which is executed if the
>> "guarded" part of the load takes place.
> 
> I will add a comment explaining that when picking the patch

Do we need load_guarded() in this new header?
The load/store_gscb() functions have potential to be shared across tests 
but the lg doesn't need to be executed, no?

We could opt to leave it in gs.c instead
