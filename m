Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055D430D710
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhBCKJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:09:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49602 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233509AbhBCKJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 05:09:50 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113A3YRA027426;
        Wed, 3 Feb 2021 05:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PfGtKEooDvYrSNHEyGqtxGCIxVXpPGfsXjW5dql49yc=;
 b=oer3a86Lr9NAi4wnO5R/bkTnidE9K3hS9DhNBrctLLYrcIEqFw2h4eiKhEpWvA+mF0gD
 j0/B3SUii6Tg60onZ0bGZybWMQUo166GDNxUIV4SFXLoDol+CKqBbCir87LX4t/P7Zgg
 wOzb4Tph1UHTekSj9WBESJX3SBnrmxIFkKmf4TjVXqoHlRDVsawYNrlm49v0kC6KUH1g
 myx6HqTCC+EHRoPQbJrWViDG9PoFM1u5npzlWPIBvKRfYt4sGdkIVVJxU1tWKv9egucC
 PGb1qL540ISIfi5pSOglP07Apwcv/BDgwuvbNR2R3XBBiuirSWDfugS7xKCx/Ad/SDeu 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fsh0rmjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:09:09 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113A3ZNH027733;
        Wed, 3 Feb 2021 05:09:08 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fsh0rmhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:09:08 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113A4r9p032655;
        Wed, 3 Feb 2021 10:09:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 36evvf1cr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 10:09:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113A93Cg12583316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 10:09:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFA96A405C;
        Wed,  3 Feb 2021 10:09:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47D2FA405B;
        Wed,  3 Feb 2021 10:09:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.177.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 10:09:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 4/5] s390x: css: SCHM tests format 0
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-5-git-send-email-pmorel@linux.ibm.com>
 <b3086f69-98fa-07c0-72c7-711c17e71c9d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <26db612d-45ea-de8b-5eed-bd2658f69aa0@linux.ibm.com>
Date:   Wed, 3 Feb 2021 11:09:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <b3086f69-98fa-07c0-72c7-711c17e71c9d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_04:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 6:35 PM, Thomas Huth wrote:
> On 29/01/2021 15.34, Pierre Morel wrote:
...snip...
>>   static void test_schm(void)
>>   {
>> +    struct measurement_block_format0 *mb0;
>> +
>>       if (css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
>>           report_info("Extended measurement block available");
>> +
>> +    mb0 = alloc_io_mem(sizeof(struct measurement_block_format0), 0);
>> +    if (!mb0) {
>> +        report(0, "measurement_block_format0 allocation");
>> +        goto end_free;
> 
> If allocation failed, there is certainly no need to try to free it, so 

:) yes

> you can get rid of the goto and the label here and return directly 
> instead. Or maybe
> Maybe also simply use report_abort() in this case?

OK, report_abort when an allocation failed seems right.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
