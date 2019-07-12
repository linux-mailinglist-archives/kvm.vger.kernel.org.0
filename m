Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663D367013
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfGLN2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:28:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbfGLN2i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Jul 2019 09:28:38 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CDRa9J144101
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:28:37 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tpswbu9kh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:28:30 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 12 Jul 2019 14:28:21 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 14:28:19 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CDSIoZ45679092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:28:18 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 287F42805C;
        Fri, 12 Jul 2019 13:28:18 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4ED728058;
        Fri, 12 Jul 2019 13:28:17 +0000 (GMT)
Received: from [9.85.144.233] (unknown [9.85.144.233])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 13:28:17 +0000 (GMT)
Subject: Re: [PATCH v3 5/5] vfio-ccw: Update documentation for csch/hsch
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1562854091.git.alifm@linux.ibm.com>
 <7d977612c3f3152ffb950d77ae11b4b25c1e20c4.1562854091.git.alifm@linux.ibm.com>
 <20190712133006.23efcd0d.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Fri, 12 Jul 2019 09:28:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712133006.23efcd0d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19071213-0072-0000-0000-0000044848F7
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011415; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01231111; UDB=6.00648508; IPR=6.01012395;
 MB=3.00027691; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-12 13:28:20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071213-0073-0000-0000-00004CB88E58
Message-Id: <8cac1675-0a56-09e3-75aa-00b4f81127c6@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/19 7:30 AM, Cornelia Huck wrote:
> On Thu, 11 Jul 2019 10:28:55 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> We now support CLEAR SUBCHANNEL and HALT SUBCHANNEL
>> via ccw_cmd_region.
>>
>> Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>  Documentation/s390/vfio-ccw.rst | 31 ++++++++++++++++++++++++++++---
>>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> (...)
> 
>> +vfio-ccw cmd region
>> +-------------------
>> +
>> +The vfio-ccw cmd region is used to accept asynchronous instructions
>> +from userspace.
>> +
> 
> Add :: and indent the structure so that we get proper formatting?
> 
> (Sorry about not noticing this last time; but I can add it while
> applying if there are no other comments.)
> 
>> +#define VFIO_CCW_ASYNC_CMD_HSCH (1 << 0)
>> +#define VFIO_CCW_ASYNC_CMD_CSCH (1 << 1)
>> +struct ccw_cmd_region {
>> +       __u32 command;
>> +       __u32 ret_code;
>> +} __packed;
>> +
>> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
>> +
>> +Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
>> +
> 
> Otherwise,
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Also good...

Reviewed-by: Eric Farman <farman@linux.ibm.com>

