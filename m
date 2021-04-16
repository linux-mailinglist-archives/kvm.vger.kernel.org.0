Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155CE361FFE
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 14:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbhDPMim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 08:38:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235243AbhDPMil (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 08:38:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GCZX3m037291;
        Fri, 16 Apr 2021 08:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8iOl2pgc+pfrz28oppTEemV2d1omLs4ADa4tFM33Xlc=;
 b=VDFkjS+4LeYpNPu6fC7SQWNuxOwac7Q7+B2TV/pTqlrUIOJg0rgQhbwSgvERD+mUssB4
 EXZarjciy0LxqzwVoXOePZVW2NnSTgZzCrrCOxuasIt2+BUAG1Sn+R/H+2KOFhxcTphx
 xcDBBhQfk5NaSoVElMRLsRevQBJm6iQkFbCtej7/NKfRy1IIhtED9YJtNVNWL2bYv4UB
 xVzLmXmKh+EUV6XaIZYxJABihIGBgbdkDsY33D6IhEkalHK8W6cm5vE4yBAUMA5jQ530
 I+Q/YLNzrxBspepXZrNLe/AwJxIMSoIpN41fYO7xuSo/p86k8WWMxV2UhtcjFI45rdP8 jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xxnphcvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 08:38:10 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13GCZjMX038176;
        Fri, 16 Apr 2021 08:38:09 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xxnphcuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 08:38:09 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13GCRj8W006769;
        Fri, 16 Apr 2021 12:38:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n8cf0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 12:38:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13GCc5Ea42795498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 12:38:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6D0AAE055;
        Fri, 16 Apr 2021 12:38:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18E3DAE04D;
        Fri, 16 Apr 2021 12:38:05 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.64.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 16 Apr 2021 12:38:05 +0000 (GMT)
Subject: Re: linux-next: Fixes tag needs some work in the kvm tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210416222731.3e82b3a0@canb.auug.org.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <00222197-fb22-ab0a-97e2-11c9f85a67f1@de.ibm.com>
Date:   Fri, 16 Apr 2021 14:38:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210416222731.3e82b3a0@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jhd4b3CO_inSOEuzwgnTPLcvLjuMOTHn
X-Proofpoint-ORIG-GUID: RrMXz8aLz6p4OEC2DXqGZd9WGSa9MuRX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_07:2021-04-15,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.04.21 14:27, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>    c3171e94cc1c ("KVM: s390: VSIE: fix MVPG handling for prefixing and MSO")
> 
> Fixes tag
> 
>    Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
> 
> has these problem(s):
> 
>    - Subject does not match target commit subject
>      Just use
> 	git log -1 --format='Fixes: %h ("%s")'

Hmm, this has been sitting in kvms390/next for some time now. Is this a new check?
