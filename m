Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FF455339
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732243AbfFYPU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 11:20:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732238AbfFYPU5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jun 2019 11:20:57 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PF3i6T006908;
        Tue, 25 Jun 2019 11:20:47 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tbnw1h040-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 11:20:47 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5PFFLLS012367;
        Tue, 25 Jun 2019 15:20:46 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 2t9by70upd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 15:20:46 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5PFKj8f50004462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 15:20:45 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3D0BE053;
        Tue, 25 Jun 2019 15:20:45 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECC43BE05B;
        Tue, 25 Jun 2019 15:20:44 +0000 (GMT)
Received: from [9.63.14.221] (unknown [9.63.14.221])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jun 2019 15:20:44 +0000 (GMT)
Subject: Re: [PATCH v5 0/2] Use DIAG318 to set Control Program Name & Version
 Codes
From:   Collin Walling <walling@linux.ibm.com>
To:     cohuck@redhat.com, david@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
Message-ID: <7c97cf39-8b93-f90b-94d4-27a29ef355c6@linux.ibm.com>
Date:   Tue, 25 Jun 2019 11:20:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1561475022-18348-1-git-send-email-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/25/19 11:03 AM, Collin Walling wrote:
> Changelog:
> 
>      v5
>          - s/cpc/diag318_info in order to make the relevant data more clear
>          - removed mutex locks for diag318_info get/set
> 
>      v4
>          - removed setup.c changes introduced in bullet 1 of v3
>          - kept diag318_info struct cleanup
>          - analogous QEMU patches:

Correct link to QEMU patches:
https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg05535.html

	
