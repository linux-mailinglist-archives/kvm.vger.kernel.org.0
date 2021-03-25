Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB563496B8
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYQXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:23:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229614AbhCYQXc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:23:32 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG4WWi008625
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EuGxQA9ffcz+hjEPju+ED92jgzR2RZLkbLMzi7XLBBI=;
 b=OEWa/FrehGcMwtZuoaIg+88e3wdhWsP4sfr64+83ieGKIF/3hfSV7/+JSsrCAv+q8ssU
 eDozuA+444gM3E4MD9WwtJohdnphH7PL5d9PZmzW0/quk9Gt23cmHgG5C1TbLSoe22Yc
 aYep5Nsfk+FGg8EgzUpG8NaWzjvYxBDVIvc9ey3zrdgd7EgR47uj/FeqTG6far1f9xcW
 b/PVzaKbt1e4jVoR4C4bEUKV+lVg7Bze8w3f+nDIVB8Kiiq0qf3JcM1vJfu4NwXo1/7Y
 KA8usLgwzgIT0XttFbl7DTHxYmc3HakPX7dtjwHzhlfg+5O+F5FQknwMuwyfman9qMBl Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvavkmfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:23:31 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG4W3O008690
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:23:31 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvavkmey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:23:31 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PGMN4M006611;
        Thu, 25 Mar 2021 16:23:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 37d9byawmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:23:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PGNQso38404488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:23:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2549411C050;
        Thu, 25 Mar 2021 16:23:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD0E211C04A;
        Thu, 25 Mar 2021 16:23:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:23:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for
 IRQ and check I/O completion
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
 <20210325162408.798bbaba@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <8f1063da-dc26-1fac-d5de-21b466dfa224@linux.ibm.com>
Date:   Thu, 25 Mar 2021 17:23:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325162408.798bbaba@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=986 adultscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 4:24 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:03 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We will may want to check the result of an I/O without waiting
>> for an interrupt.
>> For example because we do not handle interrupt.
>> Let's separate waiting for interrupt and the I/O complretion check.
>                                                     ^^^^^^^^^^^
>                                                     completion

completed :)

> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
