Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E75272A89
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgIUPo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 11:44:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727671AbgIUPo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 11:44:28 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LFXmh2186557;
        Mon, 21 Sep 2020 11:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lfsrNQ2PCtn6RCH67VHFuzYDD2Vf3DTR2ey+/aVJ1xU=;
 b=mA9YWOq1+TJDkLHuh7O8DKgFGAfJvJxNIcjz3/S85+gv+rh8ityYMv8hpYZhFRskPqaQ
 I3u75rWmuFhKznCWYVsUf+CVX+1lRiPtHOzGFh1j9j64ZVgn2CVX0+n5wCfA3jMQ81ef
 XTxujAt/eZqMXTuYRi8QxkEcj46gorS814srXGAc1vKH0G7MGOiEsWz4HpJNznl4jLsH
 JccuQJCHsiJCVstfXOwFA4qAnusW6ylSRGUPReljXZMMBVR7Y14dClshFWhpL0+07VwT
 kdSSH36DjnUK8qTWQKNwO1gEdALB/JuyeVrDZnQ8INO2di330Ec7WJVrHZA0ZKNBoRbI 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33pwrxjxec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 11:44:27 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08LFY5bN188430;
        Mon, 21 Sep 2020 11:44:27 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33pwrxjxdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 11:44:27 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08LFSdTT030455;
        Mon, 21 Sep 2020 15:44:26 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 33n9m8r8h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 15:44:26 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08LFiJeN6160906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 15:44:19 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB4196A047;
        Mon, 21 Sep 2020 15:44:22 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B152D6A04D;
        Mon, 21 Sep 2020 15:44:21 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 15:44:21 +0000 (GMT)
Subject: Re: [PATCH 1/4] s390/pci: stash version in the zpci_dev
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
 <1600529318-8996-2-git-send-email-mjrosato@linux.ibm.com>
 <20200921170158.1080d872.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <ea53b58a-74f0-2a10-3f08-dbcca512ef86@linux.ibm.com>
Date:   Mon, 21 Sep 2020 11:44:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921170158.1080d872.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_05:2020-09-21,2020-09-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/20 11:01 AM, Cornelia Huck wrote:
> On Sat, 19 Sep 2020 11:28:35 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> In preparation for passing the info on to vfio-pci devices, stash the
>> supported PCI version for the target device in the zpci_dev.
> 
> Hm, what kind of version is that? The version of the zPCI interface?
> 
> Inquiring minds want to know :)
> 

Ha :) It's related to PCI-SIG spec versions and which one the zPCI 
facility supports for this device.

>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h | 1 +
>>   arch/s390/pci/pci_clp.c     | 1 +
>>   2 files changed, 2 insertions(+)
> 

