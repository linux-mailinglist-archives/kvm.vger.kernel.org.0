Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9810D5F9
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 14:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfK2NE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 08:04:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61236 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfK2NE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 08:04:58 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATD31Fh142060
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:04:57 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wjar9mv8b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:04:56 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 29 Nov 2019 13:04:52 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 13:04:50 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xATD4nYU48562230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 13:04:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 905614C044;
        Fri, 29 Nov 2019 13:04:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57AF14C059;
        Fri, 29 Nov 2019 13:04:49 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Nov 2019 13:04:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/9] s390x: export the clock
 get_clock_ms() utility
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-5-git-send-email-pmorel@linux.ibm.com>
 <442f3d30-e61f-e884-096e-6ed47b4c6d7e@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 29 Nov 2019 14:04:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <442f3d30-e61f-e884-096e-6ed47b4c6d7e@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19112913-0028-0000-0000-000003C1A148
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112913-0029-0000-0000-00002484AFFD
Message-Id: <db120d16-210a-5ed4-fb98-857ce0f4ee4b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_03:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911290114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-11-29 13:03, David Hildenbrand wrote:
> On 28.11.19 13:46, Pierre Morel wrote:
>> To serve multiple times, the function get_clock_ms() is moved
>> from intercept.c test to the new file asm/clock.h.
> 
> I'd probably call this "tod.h" instead. Nevermind.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

