Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2AE283C39
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 18:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgJEQQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 12:16:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28816 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbgJEQQR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 12:16:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095G2OKt009680;
        Mon, 5 Oct 2020 12:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=z+eJ36YCUnqSArUqCt5T9m96+aNX3zifOe7tV23w7Yk=;
 b=NovfCKZ4jhYGRkKBRgrTg06sPyct6QQwi5tU1cRUwf10ykhwDNgAJfjWinFAoq6Vg8SO
 TewBrlPhDGq/Pxitocx26QTnUpMT0yiJ9h9BuhYsh8ild7QcWxyFtf8YePPRtgLjyndu
 5VpCcj9MR4F8d/UAeQZmmTNx1NeAWyghS8lRCJLSKJKG1WAQTURvvaPuvOw5AkTiaJxW
 1LPA8FJyl2BIPPdnu/sC5l7om5lqyTNDZQNvSXoHe0Ffwghds47g1ytsk5tXgjiR7q0d
 0UpYN/sy0qZP3Xmrno22Bt8c4czYYx9/1QgsbniIXeYT8pWrvbWAY0FWvUZw0W0aLcp8 /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3405nmjud6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:16:15 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095G3cAY016047;
        Mon, 5 Oct 2020 12:16:15 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3405nmjucs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:16:15 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095GEnMp015581;
        Mon, 5 Oct 2020 16:16:14 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 33xgx8rsws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 16:16:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095GGDkX51904800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 16:16:13 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33324112064;
        Mon,  5 Oct 2020 16:16:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81D9B112061;
        Mon,  5 Oct 2020 16:16:11 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 16:16:11 +0000 (GMT)
Subject: Re: [PATCH v2 3/5] vfio-pci/zdev: define the vfio_zdev header
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
 <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
 <20201002154417.20c2a7ef@x1.home>
 <8a71af3b-f8fc-48b2-45c6-51222fd2455b@linux.ibm.com>
 <20201005180107.5d027441.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <e0688173-8c5a-1797-8398-235c5e406bc1@linux.ibm.com>
Date:   Mon, 5 Oct 2020 12:16:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005180107.5d027441.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_11:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/20 12:01 PM, Cornelia Huck wrote:
> On Mon, 5 Oct 2020 09:52:25 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 10/2/20 5:44 PM, Alex Williamson wrote:
> 
>>> Can you discuss why a region with embedded capability chain is a better
>>> solution than extending the VFIO_DEVICE_GET_INFO ioctl to support a
>>> capability chain and providing this info there?  This all appears to be
>>> read-only info, so what's the benefit of duplicating yet another
>>
>> It is indeed read-only info, and the device region was defined as such.
>>
>> I would not necessarily be opposed to extending VFIO_DEVICE_GET_INFO
>> with these defined as capabilities; I'd say a primary motivating factor
>> to putting these in their own region was to avoid stuffing a bunch of
>> s390-specific capabilities into a general-purpose ioctl response.
> 
> Can't you make the zdev code register the capabilities? That would put
> them nicely into their own configurable part.
> 

I can still keep the code that adds these capabilities in the zdev .c 
file, thus meaning they will only be added for s390 zpci devices -- but 
the actual definition of them should probably instead be in vfio.h, no? 
(maybe that's what you mean, but let's lay it out just in case)

The capability IDs would be shared with any other potential user of 
VFIO_DEVICE_GET_INFO (I guess there is precedent for this already, 
nvlink2 does this for vfio_region_info, see 
VFIO_REGION_INFO_CAP_NVLINK2_SSATGT as an example).

Today, ZPCI would be the only users of VFIO_DEVICE_GET_INFO capability 
chains.  Tomorrow, some other type might use them too.  Unless we want 
to put a stake in the ground that says there will never be a case for a 
capability that all devices share on VFIO_DEVICE_GET_INFO, I think we 
should keep the IDs unique and define the capabilities in vfio.h but do 
the corresponding add_capability() calls from a zdev-specific file.

>>
>> But if you're OK with that notion, I can give that a crack in v3.
>>
>>> capability chain in a region?  It would also be possible to define four
>>> separate device specific regions, one for each of these capabilities
>>> rather than creating this chain.  It just seems like a strange approach
>>
>> I'm not sure if creating separate regions would be the right approach
>> though; these are just the first 4.  There will definitely be additional
>> capabilities in support of new zPCI features moving forward, I'm not
>> sure how many regions we really want to end up with.  Some might be as
>> small as a single field, which seems more in-line with capabilities vs
>> an entire region.
> 
> If we are expecting more of these in the future, going with GET_INFO
> capabilities when adding new ones seems like the best approach.
> 

