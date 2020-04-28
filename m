Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0A51BB874
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgD1IJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:09:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgD1IJR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 04:09:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S831ds118075;
        Tue, 28 Apr 2020 04:09:16 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9nahes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:09:15 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S83DMp119777;
        Tue, 28 Apr 2020 04:09:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9nahdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:09:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S853dY000878;
        Tue, 28 Apr 2020 08:09:12 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5nmtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 08:09:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S89Aqr53018636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 08:09:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07F2F52051;
        Tue, 28 Apr 2020 08:09:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 707715204F;
        Tue, 28 Apr 2020 08:09:09 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <75bcbc06-f38f-1aff-138f-5d2a2dd3f7b6@linux.ibm.com>
 <162f7dbc-9dd0-0a42-0d1a-8412a9a848e7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <3f7f57fb-c137-4854-3cb0-b234196a9f1e@linux.ibm.com>
Date:   Tue, 28 Apr 2020 10:09:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <162f7dbc-9dd0-0a42-0d1a-8412a9a848e7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-28 00:24, Tony Krowiak wrote:
> 
> 
> On 4/27/20 4:20 AM, Pierre Morel wrote:
>>
>>
>> On 2020-04-07 21:20, Tony Krowiak wrote:
>>> Introduces a new driver callback to prevent a root user from unbinding
>>> an AP queue from its device driver if the queue is in use. The intent of
>>> this callback is to provide a driver with the means to prevent a root 
>>> user
>>> from inadvertently taking a queue away from a guest and giving it to the
>>> host while the guest is still using it.

...snip...

>>
>> This functionality is valid for the host as for the guests and is 
>> handled automatically by the firmware with the CRYCB.
>> The AP bus uses QCI to retrieve the host CRYCB and build the hosts AP 
>> queues.
>>
>> If instead to mix VFIO CRYCB matrix handling and queues at the same 
>> level inside the AP bus we separate these different firmware entities 
>> in two different software entities.
>>
>> If we make the AP bus sit above a CRYCB/Matrix bus, and in the way 
>> virtualize the QCI and test AP queue instructions:
>> - we can directly pass a matrix device to the guest though a VFIO 
>> matrix device
>> - the consistence will be automatic
>> - the VFIO device and parent device will be of the same kind which 
>> would make the design much more clearer.
>> - there will be no need for these callback because the consistence of 
>> the matrix will be guaranteed by firmware
> 
> As stated in my response above, the issue here is not consistency. While 
> the design you describe
> may be reasonable, it is a major departure from what is out in the 
> field. In other words, that ship
> has sailed.


The current VFIO-AP driver works as before, without any change, above 
the Matrix device I suggest.

Aside the old scheme which can continue, the Matrix device can be used 
directly to build a VFIO Matrix device, usable by QEMU without any 
modification.

Once the dynamic extensions proposed in this series and the associated 
tools are out on the field, then yes the ship is really far.
For now, the existing user's API do not change, the existing tools do 
not need modifications and we can repair the ship for its long journey.

The inconsistency between device and VFIO device and the resulting 
complexity is not going to ease future enhancement.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
