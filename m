Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735624481B7
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 15:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbhKHOa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 09:30:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236400AbhKHOa1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 09:30:27 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8DQrJW020711;
        Mon, 8 Nov 2021 14:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bo4LrUDkBr8Gjdgxq8b70ukpwPbJPJjJB/WGW2y6Z5E=;
 b=eRAqW0U2KApBRCcDXQKkwXqwoLHHeRmvuQQQawp2fzuRbZs5ncSYSdh11uB8Hq5HjU+m
 N5vv6Cs39hsIRhDiIDqvYm8DQJ8agboHjRoxJiEsBiAkatZxHa/xDmIhLKGX2B0ZpEJV
 PeG/W19NH2xVoZQ3xscquEpqsgZo+4N/1Aojf2MszDRY5s5gkTkOXXtiJMcNMoW857lP
 J0QjhaTv6A+8TW00P61xk2r8M60iS3p2S57WEfLaoquwFV9iNa8SbbgmNoKmfHlwCQ3y
 fMmnwB+PbjmZfooGOPQ24I4/SjY2GgcueqZJavXkomjgVmJJ5VL9C5exbN3k7O6Oe64b Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c6rs5tggr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8DL6oc013912;
        Mon, 8 Nov 2021 14:27:39 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c6rs5tgg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:39 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8EOo9c002527;
        Mon, 8 Nov 2021 14:27:38 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3c5hbadcka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 14:27:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8ERbZK41025800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 14:27:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E2CBC605F;
        Mon,  8 Nov 2021 14:27:37 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCAE8C605A;
        Mon,  8 Nov 2021 14:27:33 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.167.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 14:27:33 +0000 (GMT)
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-15-akrowiak@linux.ibm.com>
 <11b72236-34fe-4d65-0da1-033050c75a87@linux.ibm.com>
 <77a4b43b-940e-0321-9ebf-3249a8d8513a@linux.ibm.com>
 <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
 <559ed7e4-d36a-4145-7fe4-eefba3484901@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <3466dbba-0a3e-5678-2b2b-90a16ea9ca86@linux.ibm.com>
Date:   Mon, 8 Nov 2021 09:27:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <559ed7e4-d36a-4145-7fe4-eefba3484901@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FttwI4EQmVZ_61aIXKCkrIeDF6wL_v7K
X-Proofpoint-ORIG-GUID: J4juOjvnnoMAFb1Vva-3VBwmmIwGWFcD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111080087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/5/21 9:15 AM, Harald Freudenberger wrote:
> On 05.11.21 09:23, Harald Freudenberger wrote:
>> On 04.11.21 16:50, Tony Krowiak wrote:
>>> On 11/4/21 8:06 AM, Harald Freudenberger wrote:
>>>> Tony as this is v17, if you may do jet another loop, I would pick the ap parts of your patch series and
>>>> apply them to the devel branch as separate patches.
>>> Are you suggesting I do this now, or when this is finally ready to go upstream?
>>>
>>>
>> I am suggesting picking all the ap related stuff into one patch and commit it to the devel branch now (well in the next days).
>> So the ap stuff is then prepared for your patches and it gives your patch series some relief.
> Of course I would do this if you agree to this procedure.

I am fine with it, it makes sense


