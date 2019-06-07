Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5423945C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbfFGSaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 14:30:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729047AbfFGSaz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jun 2019 14:30:55 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57I6qPx034449
        for <kvm@vger.kernel.org>; Fri, 7 Jun 2019 14:30:54 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2syvbf2cmm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 14:30:53 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Fri, 7 Jun 2019 19:30:52 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e17.ny.us.ibm.com (146.89.104.204) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Jun 2019 19:30:49 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x57IUmIw23003416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jun 2019 18:30:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE919124052;
        Fri,  7 Jun 2019 18:30:48 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88B8C124053;
        Fri,  7 Jun 2019 18:30:48 +0000 (GMT)
Received: from [9.85.133.83] (unknown [9.85.133.83])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jun 2019 18:30:48 +0000 (GMT)
Subject: Re: [PATCH RFC 0/1] mdevctl: further config for vfio-ap
To:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Halil Pasic <pasic@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
 <234ed452-45bd-e7ec-f1be-929e3b77d364@linux.ibm.com>
 <20190607165630.21ad033b.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Fri, 7 Jun 2019 14:30:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190607165630.21ad033b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060718-0040-0000-0000-000004FA344D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011228; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214642; UDB=6.00638503; IPR=6.00995727;
 MB=3.00027226; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-07 18:30:51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060718-0041-0000-0000-0000090654F6
Message-Id: <2f8e2b74-8119-2886-5a70-ccdcf0fb4619@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/19 10:56 AM, Cornelia Huck wrote:
> On Thu, 6 Jun 2019 12:45:29 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 6/6/19 10:44 AM, Cornelia Huck wrote:
>>> This patch adds a very rough implementation of additional config data
>>> for mdev devices. The idea is to make it possible to specify some
>>> type-specific key=value pairs in the config file for an mdev device.
>>> If a device is started automatically, the device is stopped and restarted
>>> after applying the config.
>>>
>>> The code has still some problems, like not doing a lot of error handling
>>> and being ugly in general; but most importantly, I can't really test it,
>>> as I don't have the needed hardware. Feedback welcome; would be good to
>>> know if the direction is sensible in general.
>>
>> Hi Connie,
>>
>> This is very similar to what I was looking to do in zdev (config via
>> key=value pairs), so I like your general approach.
>>
>> I pulled your code and took it for a spin on an LPAR with access to
>> crypto cards:
>>
>> # mdevctl create-mdev `uuidgen` matrix vfio_ap-passthrough
>> # mdevctl set-additional-config <uuid> ap_adapters=0x4,0x5
>> # mdevctl set-additional-config <uuid> ap_domains=0x36
>> # mdevctl set-additional-config <uuid> ap_control_domains=0x37
>>
>> Assuming all valid inputs, this successfully creates the appropriate
>> mdev and what looks to be a valid mdevctl.d entry.  A subsequent reboot
>> successfully brings the same vfio_ap-passthrough device up again.
> 
> Cool, thanks for checking!

I also confirmed this. I realize this is a very early proof of concept,
if you will, but error handling could be an interesting endeavor in
the case of vfio_ap given the layers of configuration involved; for
example:

* The necessity for the vfio_ap module to be installed
* The necessity that the /sys/bus/ap/apmask and /sys/bus/ap/aqmask must
   be appropriately configured

> 
>>
>> Matt
>>
>>>
>>> Also available at
>>>
>>> https://github.com/cohuck/mdevctl conf-data
>>>
>>> Cornelia Huck (1):
>>>    allow to specify additional config data
>>>
>>>   mdevctl.libexec | 25 ++++++++++++++++++++++
>>>   mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>   2 files changed, 80 insertions(+), 1 deletion(-)
>>>    
>>
> 

