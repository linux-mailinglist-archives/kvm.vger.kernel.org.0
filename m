Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7FE330F9
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfFCNXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 09:23:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfFCNXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 09:23:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53DDISE092899
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 09:23:46 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw1ye792h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 09:23:46 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 3 Jun 2019 14:23:46 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 14:23:44 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53DNe2R27984250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 13:23:40 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36EC16E050;
        Mon,  3 Jun 2019 13:23:40 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D9E36E04E;
        Mon,  3 Jun 2019 13:23:39 +0000 (GMT)
Received: from [9.85.133.178] (unknown [9.85.133.178])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 13:23:39 +0000 (GMT)
Subject: Re: [PULL 0/7] vfio-ccw: fixes
To:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190603105038.11788-1-cohuck@redhat.com>
 <20190603111124.GB20699@osiris> <20190603131641.4ad411f0.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Mon, 3 Jun 2019 09:23:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603131641.4ad411f0.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060313-0012-0000-0000-0000173FB5D6
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011207; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212647; UDB=6.00637289; IPR=6.00993707;
 MB=3.00027163; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 13:23:45
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060313-0013-0000-0000-00005784D48D
Message-Id: <15ea4980-a6e2-64d5-b52f-0c7e84ae7c74@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=715 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/3/19 7:16 AM, Cornelia Huck wrote:
> On Mon, 3 Jun 2019 13:11:24 +0200
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
>> On Mon, Jun 03, 2019 at 12:50:31PM +0200, Cornelia Huck wrote:
>>> The following changes since commit 674459be116955e025d6a5e6142e2d500103de8e:
>>>
>>>   MAINTAINERS: add Vasily Gorbik and Christian Borntraeger for s390 (2019-05-31 10:14:15 +0200)
>>>
>>> are available in the Git repository at:
>>>
>>>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190603
>>>
>>> for you to fetch changes up to 9b6e57e5a51696171de990b3c41bd53d4b8ab8ac:
>>>
>>>   s390/cio: Remove vfio-ccw checks of command codes (2019-06-03 12:02:55 +0200)
>>>
>>> ----------------------------------------------------------------
>>> various vfio-ccw fixes (ccw translation, state machine)
>>>
>>> ----------------------------------------------------------------
>>>
>>> Eric Farman (7):
>>>   s390/cio: Update SCSW if it points to the end of the chain
>>>   s390/cio: Set vfio-ccw FSM state before ioeventfd
>>>   s390/cio: Split pfn_array_alloc_pin into pieces
>>>   s390/cio: Initialize the host addresses in pfn_array
>>>   s390/cio: Don't pin vfio pages for empty transfers
>>>   s390/cio: Allow zero-length CCWs in vfio-ccw
>>>   s390/cio: Remove vfio-ccw checks of command codes  
>>
>> Given that none of the commits contains a stable tag, I assume it's ok
>> to schedule these for the next merge window (aka 'feature branch')?
> 
> All are bug fixes, but for what I think are edge cases. Would be nice
> if they could still make it into 5.2, but I have no real problem with
> deferring them to the next release, either.
> 
> Eric, Farhan: Do you agree?
> 

Agreed, it would be nice for 5.2, but the next merge window is fine with
me too.

