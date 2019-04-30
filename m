Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2EEF4E9
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfD3LBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 07:01:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbfD3LBE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 07:01:04 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UAv2Lh135966
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 07:01:03 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6m27jyf3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 07:01:03 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 30 Apr 2019 12:01:01 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 12:00:58 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3UB0uuh39911646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 11:00:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 882ED11C06C;
        Tue, 30 Apr 2019 11:00:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0333111C054;
        Tue, 30 Apr 2019 11:00:56 +0000 (GMT)
Received: from [9.152.222.31] (unknown [9.152.222.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Apr 2019 11:00:55 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
 <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
 <20190429185002.6041eecc.pasic@linux.ibm.com>
 <14453f04-f13f-f63c-fd8a-d9d8834182e0@linux.ibm.com>
 <efa8840b-35b1-2823-697f-ab56d4898854@linux.ibm.com>
 <20190430113718.426392f0.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 30 Apr 2019 13:00:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113718.426392f0.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19043011-0020-0000-0000-00000337D102
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043011-0021-0000-0000-0000218A4F4D
Message-Id: <e000d0b8-c5fa-bdc1-10f3-2bebae7ccdfe@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=840 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/2019 11:37, Halil Pasic wrote:
> On Tue, 30 Apr 2019 10:32:52 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>>> +    aqic_gisa.gisa = gisa->next_alert >> 4;
>>>>
>>>> Why gisa->next_alert? Isn't this supposed to get set to gisa origin
>>>> (without some bits on the left)?
> 
> s/left/right/
> 
>>>
>>> Someone already asked this question.
> 
> It must have been in some previous iteration... Can you give me a
> pointer?
> 
>>> The answer is: look at the ap_qirq_ctrl structure, you will see that the
>>> gisa field is 27 bits wide.
> 
> My question was not about the width, but about gisa->next_alert being
> used.
> 
> Regards,
> Halil
> 

Ah, OK, I understand.
it is inherited from the time I allocated the GISA myself, before the 
Mimu GISA/GIB patches.

So now indeed I must use the GISA origin for the case next_alert is used 
by GIB alert queue.


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

