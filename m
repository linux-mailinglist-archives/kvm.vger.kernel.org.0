Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB20B2D3E47
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgLIJMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:12:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728021AbgLIJML (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:12:11 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B991rZL034072
        for <kvm@vger.kernel.org>; Wed, 9 Dec 2020 04:11:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dCtIgMH+UU8hwfj/M6Rqk8uMPBsUgXsxUx/27G8r+sM=;
 b=R/N6+ZF0seq6+Iy5qBpGB6Yl3ISp6xOz//byvUoEOCQPtFzZwZrMeeHp4UikVjqu0Uf9
 t5IYcqlSvDb3i5IFwNwm0a0/c8UhqDX/6cL01NcsgUE18TPh3ZPiCMNEQBo09LAcjhQ8
 cIoPK/KPn3KpCFqbrcW5MDwHhI8t+YlgQ9LsX2wQWuY2bwewbSkwZDCxLOU/ArBKFfDO
 ZFsZIMX1m+U8Qkl0wm7J6sP+5IhEqmieDCgm8PFBASM2f+YZ6Q3Xlcg73LnCGoRM8czY
 GZZyZB9aT509b1SxwChSPBEhgz/6X9kt4seQDHoBZLANWdj1PNZOZq2PPmn2fjOk0SFl KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35afekau5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 04:11:30 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B993rPi042619
        for <kvm@vger.kernel.org>; Wed, 9 Dec 2020 04:11:30 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35afekau4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 04:11:30 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B998VMi030057;
        Wed, 9 Dec 2020 09:11:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8ph2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 09:11:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B99BP7654198556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 09:11:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58C124C046;
        Wed,  9 Dec 2020 09:11:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24D494C040;
        Wed,  9 Dec 2020 09:11:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.15.225])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 09:11:25 +0000 (GMT)
Subject: Re: [PATCH] tools/kvm_stat: Exempt time-based counters
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20201208210829.101324-1-raspl@linux.ibm.com>
 <0c89c376-3cce-3d46-ca29-2b5ba1a3aab8@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c5402269-1073-f436-3101-5513a8137533@de.ibm.com>
Date:   Wed, 9 Dec 2020 10:11:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0c89c376-3cce-3d46-ca29-2b5ba1a3aab8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_07:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=868 suspectscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09.12.20 10:08, Paolo Bonzini wrote:
> On 08/12/20 22:08, Stefan Raspl wrote:
>> From: Stefan Raspl<raspl@de.ibm.com>
>>
>> The new counters halt_poll_success_ns and halt_poll_fail_ns do not count
>> events. Instead they provide a time, and mess up our statistics. Therefore,
>> we should exclude them.
> 
> What is the issue exactly?  Do they mess up the formatting?

they mess up the percentage (they are 99% almost all the time)

> 
> Paolo
> 
>> Removal is currently implemented with an exempt list. If more counters like
>> these appear, we can think about a more general rule like excluding all
>> fields name "*_ns", in case that's a standing convention.
>>
>> Signed-off-by: Stefan Raspl<raspl@linux.ibm.com>
>> Tested-and-reported-by: Christian Borntraeger<borntraeger@de.ibm.com>
>> ---
> 
