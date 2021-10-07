Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13060424FA5
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbhJGJEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:04:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231661AbhJGJEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:04:44 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978JRww030896;
        Thu, 7 Oct 2021 05:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LIZcQMu5pkYTo0z3ZSJZyeHC2PaNP/F1G1nPx99qJt0=;
 b=Fwuuiul8Cycu++v9j2zGO7dBIKK78HjMQBL5xhhZ3bWN16+yP8swimOf5k/adntXS1Yl
 Vjik7LvQBAZFidiwzjgv6Vy4a7S82poqJRHkWNMSyylWHuJUjypi8oeVhG4aWDaMkUFM
 iWiZR0UvUO/J1o8RrXsBsJmxPt+14HUN7DbAXdGCcXx931PSQNbnp+CH7oT3WGAYQxOT
 mEqHiQLvGiSGyxlT8jw+yv01xdB+OgMekS23OPYuhX2qKfIu0eGkn4SyO5nVskC+KYA8
 Hel3Z8yP+CGwpBmz4UJDylK2ywugs6Hviehdo9A+3WP6An3oUk+LyiuHm9JMrC1/zV5n RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd7g1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:02:50 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1977r8Ni031669;
        Thu, 7 Oct 2021 05:02:47 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd7g12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:02:47 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19791vvc003407;
        Thu, 7 Oct 2021 09:02:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2aaser-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 09:02:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978vJ7D54722924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:57:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A5884C046;
        Thu,  7 Oct 2021 09:02:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DC884C05A;
        Thu,  7 Oct 2021 09:02:39 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.7.98])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 09:02:39 +0000 (GMT)
Subject: Re: [PATCH 0/2] s390: downsize my responsibilities
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
References: <20211006160120.217636-1-cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <9dc7d312-5541-60bb-5d8a-3b0dfd594cae@de.ibm.com>
Date:   Thu, 7 Oct 2021 11:02:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006160120.217636-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XSPr6kLZ9lVDqtz-9YEisqGJ0kLv_qS_
X-Proofpoint-GUID: q-ZtNZ3PpbRV0ov9HlYsyWN09KwdrQbg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=850 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 06.10.21 um 18:01 schrieb Cornelia Huck:
> I currently don't have as much time to work on s390 things
> anymore, so let's adjust some of my entries.
> 
> Cornelia Huck (2):
>    KVM: s390: remove myself as reviewer
>    vfio-ccw: step down as maintainer
> 
>   MAINTAINERS | 2 --
>   1 file changed, 2 deletions(-)

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thank you for your work. Both patches applied. Will likely go via the s390 tree.

