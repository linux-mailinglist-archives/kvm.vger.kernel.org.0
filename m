Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C802E34E83B
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhC3NCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 09:02:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53774 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232117AbhC3NB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 09:01:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UCYJfd140403
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 09:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OoQbY8W01b+0hYwOEloepD9DJ1SBhj7uF0ULvICBf2Q=;
 b=Ba+VZGy2UBWlDzfF+qt78irl3xa8fvw/RTjBxFlWwQf6h5Uqa/PKPY8hdMxC8JRHqyId
 DC1zbhO4nKIwF045Es2PKeDzO5fpV7ON29ElyX19X2XSH36R78PavGjtAeRERvxERyl2
 TvEhhZ/opipeIIoFluTRdF26x1N77fPIkx+zGLf4Ui8ue2l5IZTOVUucOeOfpqDRIy1r
 Wwc1mRxt+1B4InOmgQ14QGkJ3+xwyQgUCYYA76V1Q0WjoyzUpS8dLQia7np/cnjSGQ9L
 JGA6cMgJVqzELiRmdS8XzK8S6tm8hZEXA/4ZzgeRg4QBBZ9bGXIgLA4ozvFeYkHqTVVw uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj9a0qd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 09:01:56 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UCYpSg142209
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 09:01:55 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj9a0qcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 09:01:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UCwPg4012347;
        Tue, 30 Mar 2021 13:01:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyhar0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 13:01:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UD1pe140436044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 13:01:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8DBAE056;
        Tue, 30 Mar 2021 13:01:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2169AE055;
        Tue, 30 Mar 2021 13:01:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 13:01:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
 <20210325170257.2e753967@ibm-vm>
 <12260eaf-1fc8-00ce-f500-b56e7ad7ae2a@linux.ibm.com>
 <20210326115855.21427c7d@ibm-vm>
 <dfd959d6-453c-5c06-d0b1-5b657e72c8d4@linux.ibm.com>
Message-ID: <851f38c9-343b-3a70-a11d-d635349277ca@linux.ibm.com>
Date:   Tue, 30 Mar 2021 15:01:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <dfd959d6-453c-5c06-d0b1-5b657e72c8d4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E7XidQRhUNDkK0D7pUO0PWZ7qqufPFsF
X-Proofpoint-ORIG-GUID: aDSlQ1PEOD8iaY6vWyXU4YHSRHzqNmBO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 9:42 AM, Pierre Morel wrote:
> 
> 
> On 3/26/21 11:58 AM, Claudio Imbrenda wrote:
>> On Fri, 26 Mar 2021 11:41:34 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:

...snip...

>>> What is the purpose to check with only 1G memory?
>>
>> you need to run this test twice, once with 1G and once with 3G.
>> it's the same test, so it can't know if it is being run with 1G or
>> 3G, so you have to test for it.
>>
>> when you need a valid address above 2G, you need to make sure you have
>> that much memory, and when you want an invalid address between 1G and
>> 2G, you have to make sure you have no more than 1G.
> 
> OK, thanks
> 
> 
> 
> 

To handle the access errors I will need to extend the checking I 
currently do on the SCSW to the status fields for subchannel and device.

So no need to review this part for now because I will reorganize and 
extend it.

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
