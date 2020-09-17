Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298A226E58A
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 21:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgIQPMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 11:12:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55478 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgIQPFU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 11:05:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HEu3GX168524;
        Thu, 17 Sep 2020 11:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8NSebJ6ejs+2jYXFr8RVjNEJi+RFzmzRl7KZU3lBgxc=;
 b=mwyv1IpjmQWqtDNo1VcRCnyY12/NXNUx0jv/syMEY4kHUeRuKoEQdtiSvV6QNzsRSTed
 40VJHEY3/s9MVFy3SN/On5HZj7qdhmn2IQBqV4ztL/4mmqTaiNQ8WnRi2juS8lXBCWdC
 S2KsMWdGqv9w41rDFDsVop0fiwQzvX+02U7eP9yT0tm+RE+fMlHE55u56hjmBQHNkmi7
 uW3kKIYErdvIEvlEmRC6Bk/7HMnI2Ar3ToFKvTc7o3lpR8m47LA+rHueNhgv2yqDGm5t
 z1Kvzt1/aJgu0fE5LtL6sYQKjketaE3QUJ9m4HupFk34sjTeAi9YqCIcwPrKSnwzQgHn 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ma0er8en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 11:05:06 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HF0GHu179710;
        Thu, 17 Sep 2020 11:05:05 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ma0er8e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 11:05:05 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HF2mcW012287;
        Thu, 17 Sep 2020 15:05:04 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 33k5v9hhqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 15:05:04 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HF53Kj39715264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 15:05:03 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 161FE6E059;
        Thu, 17 Sep 2020 15:05:03 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE216E054;
        Thu, 17 Sep 2020 15:05:01 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 15:05:01 +0000 (GMT)
Subject: Re: [PATCH v4 0/5] s390x/pci: Accomodate vfio DMA limiting
To:     qemu-devel@nongnu.org, no-reply@patchew.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, pmorel@linux.ibm.com,
        david@redhat.com, qemu-s390x@nongnu.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, philmd@redhat.com, rth@twiddle.net
References: <160035396423.8478.4968781368528580151@66eaa9a8a123>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <3855da1b-4cd8-a664-56b9-66dff4db9c26@linux.ibm.com>
Date:   Thu, 17 Sep 2020 11:05:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <160035396423.8478.4968781368528580151@66eaa9a8a123>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 mlxscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/17/20 10:46 AM, no-reply@patchew.org wrote:
> Patchew URL: https://patchew.org/QEMU/1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com/
> 
> 
> 
> Hi,
> 
> This series failed the docker-quick@centos7 build test. Please find the testing commands and
> their output below. If you have Docker installed, you can probably reproduce it
> locally.
> 
> 

Errors seem to be of the flavor

'N/A. Internal error while reading log file'
and
'No space left on device'

seems like a patchew disk issue rather than something with this patchset?

> 
> 
> 
> 
> The full log is available at
> http://patchew.org/logs/1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com/testing.docker-quick@centos7/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com
> 

