Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E897D8821
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 20:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjJZSSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 14:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjJZSSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 14:18:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2294192;
        Thu, 26 Oct 2023 11:18:43 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QIEZ30017809;
        Thu, 26 Oct 2023 18:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qVfPEdY12sude9qpb6x/6PCFbJmpKdpptoj/LQcqZfM=;
 b=cFdLibiL/4C0OS+i048SwImrl+sFyn1g0PeqNmLQ4X1yGu04Rn8ZlIioz2G5jL5HVM84
 lyPiw5kIrBFUjdXVMQW8M0rGlsATXna2NV380dH3k3RF4/EjPvfrYB4hEQ9WAbP1oxQX
 M78CiWMz1R/RhUpnybYIH2UQBEUELrOpozi9plmGHePod1iCFsihf3XNt5UoqMHtuOww
 1Ah8nKUyFIL7JiDNfcsOYTeLy8ziuiWILUgKcdj4YIXNRQq4RbmRjuaxp4C0qMnH7giu
 RDVuTo3ZGElQa9B7n1AHV6KVXk4YuGN42Jf6PuLhUW4uIn/MAoQWRR/VWTpS/J4OCIlG sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7fr4mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:18:42 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QIFSE5023224;
        Thu, 26 Oct 2023 18:18:42 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyw7fr4mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:18:42 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QHUSVr026878;
        Thu, 26 Oct 2023 18:18:41 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsyp7y0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 18:18:41 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QIIehY64487752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 18:18:41 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9DD358056;
        Thu, 26 Oct 2023 18:18:40 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B2858052;
        Thu, 26 Oct 2023 18:18:40 +0000 (GMT)
Received: from [9.61.161.121] (unknown [9.61.161.121])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 18:18:39 +0000 (GMT)
Message-ID: <425ba458-3eba-4742-930d-1248be2c2cd3@linux.ibm.com>
Date:   Thu, 26 Oct 2023 14:18:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] s390/vfio-ap: improve reaction to response code 07
 from PQAP(AQIC) command
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-4-akrowiak@linux.ibm.com>
 <0bed3d29-7fb1-d56d-5f12-e2010ae7d97f@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <0bed3d29-7fb1-d56d-5f12-e2010ae7d97f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sB2KYg-oJIwPyNuaaK5HFwsVLqWdNtpy
X-Proofpoint-GUID: Qd7b1hmbPOGqG2axWloFvVZO9-_qCLyz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_16,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=945
 lowpriorityscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310260158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/23 10:15, Matthew Rosato wrote:
> On 10/18/23 9:38 AM, Tony Krowiak wrote:
>> Let's improve the vfio_ap driver's reaction to reception of response code
>> 07 from the PQAP(AQIC) command when enabling interrupts on behalf of a
>> guest:
>>
>> * Unregister the guest's ISC before the pages containing the notification
>>    indicator bytes are unpinned.
>>
>> * Capture the return code from the kvm_s390_gisc_unregister function and
>>    log a DBF warning if it fails.
>>
>> Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> I went back-and-forth on whether this should be a stable/fixes candidate but I think no...  I happened to notice it while reviewing other code, I'm not aware that it's ever created a visible issue, and it's on a pretty immediate error path.  If anyone thinks it should be a stable candidate I have no objection but in that case would suggest to break the patch up to separate the new WARN from the fix.

Nothing has ever been reported and is probably very unlikely to be 
reported; so, I agree it should not be a stable/fixes candidate.

> 
> 
> 
