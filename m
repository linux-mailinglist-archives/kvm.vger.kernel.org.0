Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30664463EC
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 14:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhKENSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 09:18:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231149AbhKENR4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 09:17:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5CW7a0027897;
        Fri, 5 Nov 2021 13:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=P40BYvr21zMMRQqDpp9OB7z7Xr5NMjDkrx+CF3Uv6gc=;
 b=gp3sStFTpo9yzE0lR9BHoAiFSI04GNPgt32OpP2gjzI2oBSHvpyCurVGf1326KLLzXSp
 5WsfqmjhcWgrcaIpU4Mbk7r/GqOwLOXy2uMT3KioLq6iMfTHjnmXqk3vT3qBwspKka33
 Zdn3RhJ1DbowIVqC5XC+WKh+apAlSRnLHASJc644AcSG+qhwT3716ee2fPe1X5ZpyNba
 6EbGPk5Z8GxEcNHa8d/XDmu+QIm7cgLN/4kyxIIRLVDjEvhydFbyp2gx7Xz77lbn6n23
 d9SkSZk+wgJd7Uetzn6Ct/EWAXIRru2Kk55WDGMVglUO35dh4YMv9ilca73fLZFPKuK3 qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4xuhyv34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 13:15:15 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A5CZSoY015709;
        Fri, 5 Nov 2021 13:15:14 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4xuhyv1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 13:15:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A5D7V8N013147;
        Fri, 5 Nov 2021 13:15:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3c4t4fmg4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 13:15:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A5DF8fF9896262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 13:15:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86C6B4C059;
        Fri,  5 Nov 2021 13:15:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CB334C05E;
        Fri,  5 Nov 2021 13:15:08 +0000 (GMT)
Received: from funtu.home (unknown [9.145.42.227])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Nov 2021 13:15:08 +0000 (GMT)
Subject: Re: [PATCH v17 14/15] s390/ap: notify drivers on config changed and
 scan complete callbacks
From:   Harald Freudenberger <freude@linux.ibm.com>
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
 <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
Message-ID: <559ed7e4-d36a-4145-7fe4-eefba3484901@linux.ibm.com>
Date:   Fri, 5 Nov 2021 14:15:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bb676730-a1b1-3bbe-116e-7d20ab6e8a58@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IKXFbpc20EQOI-4hNWJEHM-AgUX_1ywM
X-Proofpoint-ORIG-GUID: 2yR4bwplzqZ9x2P7bWo0BWk3GUk7j2er
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.11.21 09:23, Harald Freudenberger wrote:
> On 04.11.21 16:50, Tony Krowiak wrote:
>>
>> On 11/4/21 8:06 AM, Harald Freudenberger wrote:
>>> Tony as this is v17, if you may do jet another loop, I would pick the ap parts of your patch series and
>>> apply them to the devel branch as separate patches.
>> Are you suggesting I do this now, or when this is finally ready to go upstream?
>>
>>
> I am suggesting picking all the ap related stuff into one patch and commit it to the devel branch now (well in the next days).
> So the ap stuff is then prepared for your patches and it gives your patch series some relief.
Of course I would do this if you agree to this procedure.
