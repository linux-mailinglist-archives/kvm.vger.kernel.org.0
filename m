Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF11544608F
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 09:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhKEI0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 04:26:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhKEI0k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 04:26:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A58M8Xw028192;
        Fri, 5 Nov 2021 08:24:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YhMG9O9jMkvCk14Cuua/r9qYNGRijvQggxM7Ck4ffyg=;
 b=iEHsEgW61s9jvcMb4sENLMutURMLxLAvA/OQlH7+lkls9OaTCT7kHbw6tMUzpR40jJrN
 CoOihnEGnGBXg/cVpvs1A61mc3lVb8SwITjtwQhPIB1Rj9825lPVb0vV/nYIUCn+niXy
 vwz107yb/I21DGbdk92iUK6Kfh1FMzEsmr/EcFyp4r6HcdAlEcVYud5miWmHxKffB3xz
 cCPamBpFl9wTewTLd+E+4rTzwN8tcwV0GOusjjmUPi01WKJR74dHd22JRF30WfrXobDA
 U6qcrHgRK2eEsGwAE15p7CI6GXkXIJfi3O+MJemfJ+aE+8EZGXUbjnPINvLpi/HLcbIa FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c511tr0kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 08:24:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A58NxWl031686;
        Fri, 5 Nov 2021 08:23:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c511tr0k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 08:23:59 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A58IAjK000457;
        Fri, 5 Nov 2021 08:23:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3c4t4ta7sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 08:23:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A58HQ1t37552586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 08:17:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 900434C050;
        Fri,  5 Nov 2021 08:23:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C8594C04E;
        Fri,  5 Nov 2021 08:23:53 +0000 (GMT)
Received: from funtu.home (unknown [9.145.42.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Nov 2021 08:23:53 +0000 (GMT)
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-15-akrowiak@linux.ibm.com>
 <11b72236-34fe-4d65-0da1-033050c75a87@linux.ibm.com>
 <77a4b43b-940e-0321-9ebf-3249a8d8513a@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
Date:   Fri, 5 Nov 2021 09:23:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <77a4b43b-940e-0321-9ebf-3249a8d8513a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3lTp7ejQQnfPpNn864REldgrfRnisV3T
X-Proofpoint-GUID: UV7A_l-Y91iIRWhNSu5asEKlaucgmWBo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_01,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.21 16:50, Tony Krowiak wrote:
>
>
> On 11/4/21 8:06 AM, Harald Freudenberger wrote:
>>
>> Tony as this is v17, if you may do jet another loop, I would pick the ap parts of your patch series and
>> apply them to the devel branch as separate patches.
>
> Are you suggesting I do this now, or when this is finally ready to go upstream?
>
>
I am suggesting picking all the ap related stuff into one patch and commit it to the devel branch now (well in the next days).
So the ap stuff is then prepared for your patches and it gives your patch series some relief.
