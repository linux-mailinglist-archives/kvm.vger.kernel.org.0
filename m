Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7601C2C1475
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 20:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgKWTXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 14:23:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4790 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729048AbgKWTXV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 14:23:21 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJ1W61063256;
        Mon, 23 Nov 2020 14:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F8eeHvrx+pj+1O7oYmKziQkR7JdrIiMpm+t+rUWYg4M=;
 b=fSLWf1LsYp1IRZtXtj51cyZ/a7TefeTSIl0rNLsdoy1knQnRdTGeZFGCmsWyEby/01Cm
 ZdMiOeNvDvttmZC/HW4ElNS4TRb4QHSkXfHjfE5sf9QVPg+oHwYpl/CuLtkKovCpWqMe
 yUAzrX1gGCDcPBAHq/QKC11pTKpINFvb2BdZqNWoNnGvyNHRrq6+Zr3qtciZn334jliK
 xhuLMrT1fuO+k48beEGFPp7pOnt5QKuWVluWTV9MI9IDl5MvtkSVztd4KXHPxr/NoDEV
 3UxsauzovFeu64W5PdoBc5BEshUJ0lct10OgOee2qC2fTEgBiIutPlKlJFopWX2yuLfP IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtt3tfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:23:15 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ANJ1mn9063995;
        Mon, 23 Nov 2020 14:23:14 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtt3tem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 14:23:14 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANJC6DX002564;
        Mon, 23 Nov 2020 19:23:12 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 34xth95yqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 19:23:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANJN2TO43188502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 19:23:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFF4FBE053;
        Mon, 23 Nov 2020 19:23:08 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6162DBE051;
        Mon, 23 Nov 2020 19:23:07 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.169.207])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 19:23:07 +0000 (GMT)
Subject: Re: [PATCH v11 05/14] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-6-akrowiak@linux.ibm.com>
 <20201027142711.1b57825e.pasic@linux.ibm.com>
 <6a5feb16-46b5-9dca-7e85-7d344b0ffa24@linux.ibm.com>
 <20201114004722.76c999e0.pasic@linux.ibm.com>
 <20201123180316.79273751.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <62a22a99-3485-353c-b4e5-e04fcec57778@linux.ibm.com>
Date:   Mon, 23 Nov 2020 14:23:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201123180316.79273751.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011230122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/23/20 12:03 PM, Cornelia Huck wrote:
> On Sat, 14 Nov 2020 00:47:22 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
>
>> On Fri, 13 Nov 2020 12:14:22 -0500
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>> [..]
>>>>>    }
>>>>>    
>>>>> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
>>>>> +			 "already assigned to %s"
>>>>> +
>>>>> +static void vfio_ap_mdev_log_sharing_err(const char *mdev_name,
>>>>> +					 unsigned long *apm,
>>>>> +					 unsigned long *aqm)
>>>>> +{
>>>>> +	unsigned long apid, apqi;
>>>>> +
>>>>> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>>>>> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
>>>>> +			pr_err(MDEV_SHARING_ERR, apid, apqi, mdev_name);
>>>> Isn't error rather severe for this? For my taste even warning would be
>>>> severe for this.
>>> The user only sees a EADDRINUSE returned from the sysfs interface,
>>> so Conny asked if I could log a message to indicate which APQNs are
>>> in use by which mdev. I can change this to an info message, but it
>>> will be missed if the log level is set higher. Maybe Conny can put in
>>> her two cents here since she asked for this.
>>>    
>> I'm looking forward to Conny's opinion. :)
> (only just saw this; -ETOOMANYEMAILS)
>
> It is probably not an error in the sense of "things are broken, this
> cannot work"; but I'd consider this at least a warning "this does not
> work as you intended".

Okay then, I'll make it a warning.

>

