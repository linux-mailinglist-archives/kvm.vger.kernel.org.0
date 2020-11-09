Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8033E2AB351
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKIJOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:14:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726482AbgKIJOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 04:14:03 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A992TQG007524;
        Mon, 9 Nov 2020 04:14:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wxdt/yKAtHEfPrCv8biItrCI1V4rQsjdX3/IyrpZhSM=;
 b=WePHTeDaBxA4Vx0E5DUSzqDvDdUVJuZH5LYb4SKQC0wLrPHEg/ov77HU8tvfiiBRPxDY
 jvUzzOwGbBoOE8W88ovBmI63PxAwQ4hSXOh+SCQCQQqbkVPwcpJlFXRAy2Ubf+nqnsYd
 pb0JVC+PylhZM46Q2recwMpqraO9YbD18Y0SZEvAqO1sEauFjtXP45+DEHiwWTriC4uj
 PH9ylZEeRVUKHxqmErn1InOorcQF52QNbYfZv6NermAckEzgB78o2FyLwkRFOC58oiBG
 B8w07KPak7zzsqW8p8a9O3gRjGDr8ktaAT4fT+UxzF6hWXr3FKi578enNmnrIS3kyt3W aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34p9qj2r5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 04:14:01 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A992Ze7008109;
        Mon, 9 Nov 2020 04:14:01 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34p9qj2r5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 04:14:01 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A99BlU1014914;
        Mon, 9 Nov 2020 09:13:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34p26ph9m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 09:13:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A99DujG8913600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 09:13:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C53E911C052;
        Mon,  9 Nov 2020 09:13:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A67E11C050;
        Mon,  9 Nov 2020 09:13:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.243])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 09:13:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
 <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
 <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
 <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
 <fc553f1a-8ddd-59b0-9dec-8bdddfb5483d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9dc9da3b-45de-7cb2-68ed-e5f7ada6c8b0@linux.ibm.com>
Date:   Mon, 9 Nov 2020 10:13:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <fc553f1a-8ddd-59b0-9dec-8bdddfb5483d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/6/20 2:25 PM, Paolo Bonzini wrote:
> On 05/11/20 15:15, Janosch Frank wrote:
>>> Isn't it possible to go on with this patch series.
>>> It can be adapted later to the changes that will be introduced by
>>> Claudio when it is final.
>>>
>>>
>> Pierre, that's outside of my jurisdiction, you're adding code to the
>> common code library.
>>
>> I've set Paolo CC, let's see if he finds this thread:)
>>
> 
> I have queued Claudio's series already, so let's start from there.
> 
> Paolo
> 

OK, thanks

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
