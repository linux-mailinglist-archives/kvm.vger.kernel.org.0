Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9328134CD3D
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 11:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhC2Jl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 05:41:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47878 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232282AbhC2Jlt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 05:41:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T9YUKR196502
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 05:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0CFZPgpyYzeSzPVTHm/XkXHhDOEDPIDIIVZLMlKm+OE=;
 b=i3qHKe+ZU/YCwU0EBjqTeE1RGnVmPlk2i2opBSTf7SCfpnD9Rq5YO5PTd5VMsMFlmpy2
 WOegrz9OKWYp30mkMyno3lkxO85aqb8uoYr0W8xfq8CZUaB4ulmmSsiXJxaicyCWAQli
 qkGB35x62D0YfYdMU8lq7Qd4O9640pC53V3+FHz7r2H4J/ZBF7QbkfuyXBEE51sq70zv
 LUE+kEfGrZRrswW/HgB2WCK3ixX6t+QHXFdK/2Zs5yuxJrpctdP3s789jS/MMebzCzsP
 Yuu8lbvPzgoW80gbNjfpxivrc/LL5PQwZpyMXCRR6FzivH59bDXOrTA5DcQNa2kl6uIg 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj98skp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 05:41:48 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T9YhwY001793
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 05:41:48 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj98sknn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 05:41:48 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T9S7Zj020941;
        Mon, 29 Mar 2021 09:41:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 37hvb88vf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 09:41:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T9fhBu21037512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 09:41:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7744C044;
        Mon, 29 Mar 2021 09:41:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FA2A4C040;
        Mon, 29 Mar 2021 09:41:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.173.162])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 09:41:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: css: testing ssch error
 response
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
Message-ID: <61b918e0-8179-1b1f-cad4-86294d113fdd@linux.ibm.com>
Date:   Mon, 29 Mar 2021 11:40:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-7-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: At7xQfnSWwLiss_RmlpHqMIooMMA0Y7c
X-Proofpoint-ORIG-GUID: GXssxwGLb12pYpj7ts-BtR9i8D3b7TUc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_05:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 10:39 AM, Pierre Morel wrote:
> Checking error response on various eroneous SSCH instructions:
> - ORB alignment
> - ORB above 2G

! seems I made an error here, I do not find from where I got that ORB 
must be under 2G.
...



-- 
Pierre Morel
IBM Lab Boeblingen
