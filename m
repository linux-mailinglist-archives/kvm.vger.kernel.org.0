Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20078201EB
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 11:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEPJAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 05:00:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbfEPJAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 05:00:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4G8qLm7134610
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 05:00:03 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sh3egkvrd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 05:00:03 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 16 May 2019 10:00:00 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 09:59:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4G8xvWp38404298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 08:59:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29A5D42041;
        Thu, 16 May 2019 08:59:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D40314203F;
        Thu, 16 May 2019 08:59:56 +0000 (GMT)
Received: from [9.152.222.58] (unknown [9.152.222.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 May 2019 08:59:56 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v1 0/2] New state handling for VFIO CCW
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     pasic@linux.vnet.ibm.com, farman@linux.ibm.com,
        alifm@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
 <20190508115341.2be6b108.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 16 May 2019 10:59:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508115341.2be6b108.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051609-4275-0000-0000-000003355AB2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051608-4276-0000-0000-00003844E186
Message-Id: <118f3dc7-d950-75ac-527d-2eb65dce9a99@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160061
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 11:53, Cornelia Huck wrote:
> On Mon,  6 May 2019 15:11:08 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Hi,
>>
>> I did not integrate all my patches for state handling like I had
>> before but just two patches which seems interresting to me:
>>
>> - The first one allows the device ti be used only when a guest
>>    is currently using it.
>>    Otherwise the device is in NOT_OPER state
>>   
>> - The second rework the sch_event callback: AFAIU we can not
>>    consider that the event moves the device in IDLE state.
>>    I think we better let it as it is currently.
> 
> I agree with the direction of this patch series.
> 
>>
>> Regards,
>> Pierre
>>
>> Pierre Morel (2):
>>    vfio-ccw: Set subchannel state STANDBY on open
>>    vfio-ccw: rework sch_event
>>
>>   drivers/s390/cio/vfio_ccw_drv.c     | 21 ++-------------------
>>   drivers/s390/cio/vfio_ccw_fsm.c     |  7 +------
>>   drivers/s390/cio/vfio_ccw_ops.c     | 36 ++++++++++++++++++------------------
>>   drivers/s390/cio/vfio_ccw_private.h |  1 -
>>   4 files changed, 21 insertions(+), 44 deletions(-)
>>
> 
Thanks,
I will post a v2 with the corrections seen by you and Farhan,

Regards,
Pierre	

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

