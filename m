Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F618095
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 21:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfEHTir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 15:38:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbfEHTir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 15:38:47 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48JWR1A067036
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 15:38:46 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc211hs2t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 15:38:45 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 8 May 2019 20:38:44 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 20:38:41 +0100
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48JceZu65077384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 19:38:40 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D5EA6A04D;
        Wed,  8 May 2019 19:38:40 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294896A04F;
        Wed,  8 May 2019 19:38:38 +0000 (GMT)
Received: from [9.85.183.31] (unknown [9.85.183.31])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 19:38:38 +0000 (GMT)
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
 <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
 <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
 <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
 <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
 <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
 <20190508120648.6c40231d.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Wed, 8 May 2019 15:38:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508120648.6c40231d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050819-0036-0000-0000-00000AB6CA7F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011072; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01200486; UDB=6.00629893; IPR=6.00981372;
 MB=3.00026797; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-08 19:38:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050819-0037-0000-0000-00004BB5930B
Message-Id: <abb996d4-4f3d-f10d-7ced-e27ca72a92f0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=888 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/19 6:06 AM, Cornelia Huck wrote:
> On Wed, 8 May 2019 11:22:07 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> The TEST command is used to retrieve the status of the I/O-device
>> __path__ and do not go up to the device.
>> I did not find clearly that it does not start a data transfer but I
>> really do not think it does.
>> May be we should ask people from hardware.
>> I only found that test I/O (a specific test command) do not initiate an
>> operation.
> 
> FWIW, I'm not sure about what we should do with the test command in any
> case.
> 
> Currently, I see it defined as a proper command in the rather ancient
> "Common I/O Device Commands" (I don't know of any newer public
> version), 

Nor I.  I had to rummage around a few dumpsters to find a copy of this 
one, even.

> which states that it retrieves the status on the parallel
> interface _only_ (and generates a command reject on the serial
> interface). IIRC, the parallel interface has been phased out quite some
> time ago.

The current POPs, towards the bottom left side of page 13-3, has this 
statement:

---
The term “serial-I/O interface” is used to refer the ESCON I/O 
interface, the FICON I/O interface, and the FICON-converted I/O 
interface. The term “parallel-I/O interface” is used to refer to the IBM 
System/360 and System/370 I/O interface.
---

So, yes it was phased out some time ago.  :)

> 
> The current PoP, in contrast, defines this as an _invalid_ command
> (generating a channel program check).

Ditto the ESA/390 POPs (SA22-7201-08).

> 
> So, while the test command originally was designed to never initiate a
> data transfer, we now have an invalid command in its place, and we
> don't know if something else might change in the future (for transfer
> mode, a test-like command is already defined in the PoP).

Indeed, the ccw_is_test() check would need to be reworked if we ever 
want to support transport mode anyway.  :shudder:

> 
> So, the safest course would probably be to handle the ->cda portion and
> send the command down. We'll get a check condition on current hardware,
> but it should be safe if something changes in the future.
> 
> Of course, asking some hardware folks is not a bad idea, either :)
> 

I'll shoot a quick note (and cc Pierre) just for the sake of sanity, but 
I'm still convinced this patch is fine as-is.  :)

