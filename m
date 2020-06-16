Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7021FB266
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 15:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgFPNoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 09:44:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728869AbgFPNn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 09:43:58 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GDXfZm163618;
        Tue, 16 Jun 2020 09:43:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31mtxfw6c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 09:43:57 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GDYo48171672;
        Tue, 16 Jun 2020 09:43:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31mtxfw6bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 09:43:56 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GDe9WE007434;
        Tue, 16 Jun 2020 13:43:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 31mpe85e5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 13:43:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GDhrni1900914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 13:43:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E8024C046;
        Tue, 16 Jun 2020 13:43:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B345B4C04E;
        Tue, 16 Jun 2020 13:43:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.26.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jun 2020 13:43:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 11/12] s390x: css: msch, enable test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
 <665f6c4c-6e72-5980-a3c8-d6ca31ff470c@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <16a6a1c3-d6da-75bb-084d-2e990ddadd49@linux.ibm.com>
Date:   Tue, 16 Jun 2020 15:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <665f6c4c-6e72-5980-a3c8-d6ca31ff470c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_04:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 cotscore=-2147483648
 bulkscore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160101
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-16 13:43, Thomas Huth wrote:
> On 15/06/2020 11.32, Pierre Morel wrote:
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>> This includes:
>> - Get the current subchannel Information Block (SCHIB) using STSCH
>> - Update it in memory to set the ENABLE bit
>> - Tell the CSS that the SCHIB has been modified using MSCH
>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>    enabled.
>> - If the command succeeds but subchannel is not enabled retry a
>>    predefined retries count.
>> - If the command fails, report the failure and do not retry, even
>>    if cc indicates a busy/status pending as we do not expect this.
>>
>> This tests the MSCH instruction to enable a channel succesfuly.
> 
> s/succesfuly/successfully/

yes.

> 
>> This some retries are done and in case of error, and if the retries
>> count is exceeded, a report is made.
> 
> That sentence needs some fixes, too ;-)
> 
> With the commit description fixed:
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
