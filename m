Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A6730D71B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhBCKME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:12:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233759AbhBCKLY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 05:11:24 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113A1jZd068157;
        Wed, 3 Feb 2021 05:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9m0hdIUByF4HWhIJNsELS8Bk63EN9cKogEKLBPSLY34=;
 b=fqTqHn0fvA0ZHjcrAhtFhPIIYWaAd8/uEK5iCOHcRPJPezGRT/yTIlcZA9aqOY8UQ2d5
 upnf6ph1Rg7jjXZSk9iYAcsxg1mckjke3sfUEnQ88ih4BgnB7vfqTYEdm8ghHX3/n1wv
 5jrssh/XL1s40xQVcWLei9AQ4jILu4sTr8LhgyUO6KIa+1VJbhwRHECrLCd28t8mUOkG
 I3xhA3BehdxSCRleDdccTJRvtlRQfCvXiv2g6Cp44wAylu4pcbLgn9NpTfvd5hEFcJqz
 GIvocZhy4Tnsj2PH9S+Kngt0QVhlFp1hyC+GJSo1AHylrwNsplnjVgqX8/Af7nSuiLhb FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fsncrh7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:10:43 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113A1GpD066840;
        Wed, 3 Feb 2021 05:10:42 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36fsncrh6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:10:42 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113A5T02027896;
        Wed, 3 Feb 2021 10:10:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 36cy389ycx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 10:10:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113AAcbT41746882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 10:10:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D59A2A405B;
        Wed,  3 Feb 2021 10:10:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0752A4062;
        Wed,  3 Feb 2021 10:10:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.177.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 10:10:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of the
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
 <daf7ef77-98fc-3e29-d753-78b933a494d5@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a46eae99-0cb2-a775-3254-83dd8dfe1f83@linux.ibm.com>
Date:   Wed, 3 Feb 2021 11:10:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <daf7ef77-98fc-3e29-d753-78b933a494d5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_04:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 6:29 PM, Thomas Huth wrote:
> On 29/01/2021 15.34, Pierre Morel wrote:
>> In order to ease the writing of tests based on:
...snip...
>>   error_ccw:
>>       free_io_mem(senseid, sizeof(*senseid));
>> -error_senseid:
>> -    unregister_io_int_func(css_irq_io);
>> +    return retval;
>> +}
> 
> Maybe use "success" as a name for the variable instead of "retval"? ... 
> since it's a boolean value...
yes, I do, thanks.
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
