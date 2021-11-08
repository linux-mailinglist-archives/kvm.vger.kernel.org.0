Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A39447F7D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbhKHMhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:37:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238062AbhKHMhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:37:41 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8AvNMK001399
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ngtj+Lx6R8WOXDvD6NPxRjc9t5g/ynZ7rxQwzF3EQPM=;
 b=NB8oics1R/pKC9Ln1P0c63u+hu1n2lPyX/Jbb+uBdgyWSlMNUjOlyCBW0k4mCX3Revni
 kndRlx6MjbvbwMtpY8EwOR978dFp+pi9AD5N11steM/O6y0J+zku6Io7cfpGUShIh8mL
 aKAUH5qzUCg7IzlCuWPUysBuDueQI6B6IXzwJ5b84349zif/IHqixhOj9kJq/Ttr7mQh
 zidghgE+797TqFujg66CoG30VaWAfcJSR7GC5YhaCkhEam+VrjrcQgroasDappqVyrnQ
 kRhdOFkkgAeyCocMEMM0Dj+jwduf7BBuoIvglehgaL+Y98BCf/jAihxeS+wh8xNpGzLK rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeyge32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:34:57 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8CU10f024309
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:34:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeyge23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:34:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CLjP0021122;
        Mon, 8 Nov 2021 12:34:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3c5hb9wxtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:34:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CYo3e48562622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:34:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA34642082;
        Mon,  8 Nov 2021 12:34:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFF0242045;
        Mon,  8 Nov 2021 12:34:49 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:34:49 +0000 (GMT)
Message-ID: <36faba77-d384-f1f0-2782-d7949feee4d1@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:35:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
 <20211103074625.4rcnwaor6sofcsdp@gator.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211103074625.4rcnwaor6sofcsdp@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ywzaxbu8M-eFZcJK4OdQSgeuUWfkoOcU
X-Proofpoint-ORIG-GUID: -Mwe6H82Y3-y8MxcFX1E9EgnlDYvv940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_04,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:46, Andrew Jones wrote:
> On Fri, Aug 27, 2021 at 12:17:16PM +0200, Pierre Morel wrote:
>> This is the implementation of the virtio-ccw transport level.
>>
>> We only support VIRTIO revision 0.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/virtio-ccw.h | 111 ++++++++++++
>>   lib/virtio-config.h    |  30 ++++
> 
> I'd probably just drop these config defines into lib/virtio.h.
> 
> Thanks,
> drew
> 

I will do that.
Thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
