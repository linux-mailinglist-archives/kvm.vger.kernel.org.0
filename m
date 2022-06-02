Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E730453BC56
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbiFBQTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiFBQTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 12:19:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9FA21A542;
        Thu,  2 Jun 2022 09:19:41 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252ELBRp001735;
        Thu, 2 Jun 2022 16:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z/R/EpVTF2zXBu3o4Czqi9pGk+qIiOc+hvy0nngVmgo=;
 b=F2O1eXSja35bUzW26MLLrxxYXbUDDx9twaM8lOpcrdHbxPONCgHOGerxKc04MS9vhSk7
 aNw3lEDtZAKZTWD/mrG1/3ZNG1YLBfv+9yHtLEiujC1yku6VmxoCt1rhgeMZkaDVcpyf
 p5sagphgUc3alZrkYXRWDLtbDzNOKQUGTKOsVMwgERwqrDWKLdlh8gctlEJ2V4vTpW3X
 6hxZ9+JC/pNfDE+ltF/cHfApqaILgMBj1MoNL9Gl+iumbxwT3cG+jvMlKIMxF6qEzCCW
 p1mvXEI5XndA9GjtYFoLVU5tDxOnjE90K/ptNfguCy2yCmW+FM/xyYJioVM5ARxEF1gK 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geub96tcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:19:40 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252FriIL012549;
        Thu, 2 Jun 2022 16:19:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geub96tc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:19:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252G632D003425;
        Thu, 2 Jun 2022 16:19:38 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3gcxt5uj1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:19:38 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252GJaK625821692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 16:19:36 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4E14136053;
        Thu,  2 Jun 2022 16:19:36 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8724136055;
        Thu,  2 Jun 2022 16:19:35 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 16:19:35 +0000 (GMT)
Message-ID: <23da8131-d38d-f30b-89ba-a27d58690739@linux.ibm.com>
Date:   Thu, 2 Jun 2022 12:19:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 20/20] MAINTAINERS: pick up all vfio_ap docs for VFIO
 AP maintainers
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-21-akrowiak@linux.ibm.com>
 <bcdf9615-628a-8696-4a3b-f10a35d7af87@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <bcdf9615-628a-8696-4a3b-f10a35d7af87@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jmaVD9gaZx25V2yt0_ZwvNfRiwKewSga
X-Proofpoint-ORIG-GUID: FMleaoowtP-ub3OqAj8ar6KOtIylpFLv
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_04,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=916 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020067
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/31/22 2:26 PM, Matthew Rosato wrote:
> On 4/4/22 6:10 PM, Tony Krowiak wrote:
>> A new document, Documentation/s390/vfio-ap-locking.rst was added. 
>> Make sure
>> the new document is picked up for the VFIO AP maintainers by using a
>> wildcard: Documentation/s390/vfio-ap*.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   MAINTAINERS | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index fd768d43e048..c8d8637c184c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17239,8 +17239,10 @@ M:    Jason Herne <jjherne@linux.ibm.com>
>>   L:    linux-s390@vger.kernel.org
>>   S:    Supported
>>   W:    http://www.ibm.com/developerworks/linux/linux390/
>> -F:    Documentation/s390/vfio-ap.rst
>> -F:    drivers/s390/crypto/vfio_ap*
>> +F:    Documentation/s390/vfio-ap*
>> +F:    drivers/s390/crypto/vfio_ap_drv.c
>> +F:    drivers/s390/crypto/vfio_ap_ops.c
>> +F:    drivers/s390/crypto/vfio_ap_private.h
>
> I think this change was a rebase error, the Documentation change makes 
> sense but you should leave drivers/s390/crypto/vfio_ap* alone, so the 
> final result looks like:
>
> F:    Documentation/s390/vfio-ap*
> F:    drivers/s390/crypto/vfio_ap*

I presume it happened during a rebase, I've already fixed it.


