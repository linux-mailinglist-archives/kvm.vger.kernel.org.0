Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA944568C
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 16:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhKDPvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 11:51:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55726 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhKDPvA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 11:51:00 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FH8DJ035307;
        Thu, 4 Nov 2021 15:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A/iC53wbbe3Xozy8wTJCE0T9o5VFjoBjc5tEMny9rR4=;
 b=kKAUmZ60jZMNpZgwNPOSkMBlqYNqUGDkS6vmJ/tZ5B8UyawmemWg0g3COv7T0xlfYL5Z
 aX1Vqmkmug66XR2k4Yp5BW40QKiXIqTISbp7j0vOtNAeGh5iEjXpHTkxx46Jqy2zm382
 sjnlEo5lPCfKt+i7NZVyQMACHaVONQQRc1ZjIQeWny2aLCoXWUnVn9wPj3etZSVXvM5r
 LrQE25FVEg9wivFoHv3fCqmtfM6LObPMmgYuzu6VC4R9KbxBqaaZUE3ZgyC0F9oCV2rt
 lwzxHSj1pbw5XChrMaNqqTal5wmX03Et40UDMqviuXgEHr1yFQ9BmPLX/KQPiL8hkt2d Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4j1c0myy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:48:20 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4FTH3J040705;
        Thu, 4 Nov 2021 15:48:20 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4j1c0mye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:48:20 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4FXQkP003730;
        Thu, 4 Nov 2021 15:48:19 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3c0wpcky5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 15:48:19 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4FmIJF24969518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 15:48:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DEEC6E056;
        Thu,  4 Nov 2021 15:48:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 018036E05E;
        Thu,  4 Nov 2021 15:48:15 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.110.109])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 15:48:15 +0000 (GMT)
Subject: Re: [PATCH v17 11/15] s390/ap: driver callback to indicate resource
 in use
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-12-akrowiak@linux.ibm.com>
 <15a87038-a88c-b29e-f7d7-760ca27c87cf@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8b7ed27f-b87f-d42f-5993-8e2f4fc7250f@linux.ibm.com>
Date:   Thu, 4 Nov 2021 11:48:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <15a87038-a88c-b29e-f7d7-760ca27c87cf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GYGo9Jm7UqCg8vYcOVy8N0g7JNcLLCAc
X-Proofpoint-GUID: tLiD4Oa7aZoVkEM5BXqu1rzwXtMzY1mo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_04,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/4/21 7:27 AM, Harald Freudenberger wrote:

> reviewed again. I still don't like this as it introduces an unbalanced weighting for the
> vfio dd but ... We could consider removing the
>
> if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> 		return 0;
>
> in function __verify_queue_reservations. It would still work as the 'default device
> drivers' do not implement the in_use() callback and thus do not disagree about
> the upcoming change.

I don't have a problem with that given the default drivers may one day
have use for implementing the callback.

>

