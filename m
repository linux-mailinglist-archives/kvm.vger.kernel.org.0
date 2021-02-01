Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F73D30A748
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhBAMKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:10:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhBAMKn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:10:43 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111C2P06189300;
        Mon, 1 Feb 2021 07:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dIPbU4zg1CS68Fh0A1ry9wUjnSDA/BQtJEVXb2F2HAQ=;
 b=rQfMFmVSe4c5/dy/zvdDUBF/3asuxal1aCXt9lSE90on/TnMzgcghYu9l0QXU9QpE/bR
 bLng92+LTa1HEA0r0oXqIuZkiIIz07R1iFbYKxJgTIbl+bNDqx8MUtb+4n0I7yuIXKBV
 jJ5yoYsJCTeB20iv5oJ/v+/LnzaFO2m6gRsQJy07q+6GECTBcrgqBzEqB8svXk7/0OeO
 HBKKy05ekh54NmcLy5rLoCOPdbtubw7UghxBu3INdmlb4rjaU9IlzSTZ6PO4O7zCU47E
 JMcq36KUlx/N/wpjqqEVSNIVGO+blN2NQ8iZV0Mgk8kX4Nzwfqtgh5jD5aoUoHbR1j4d lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36eha00bnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 07:10:01 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111C37ia194035;
        Mon, 1 Feb 2021 07:10:01 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36eha00bb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 07:10:00 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111C3ORW031860;
        Mon, 1 Feb 2021 12:09:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 36cy388xjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:09:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111C9WXn32637392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 12:09:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BBB2A4054;
        Mon,  1 Feb 2021 12:09:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 293AAA405F;
        Mon,  1 Feb 2021 12:09:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 12:09:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: css: Store CSS
 Characteristics
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
 <04f837d1-b389-9c51-a876-233c70c86999@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ab568f10-549c-e2d0-94be-8de4458a30ca@linux.ibm.com>
Date:   Mon, 1 Feb 2021 13:09:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <04f837d1-b389-9c51-a876-233c70c86999@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_04:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/1/21 11:01 AM, Janosch Frank wrote:
> On 1/29/21 3:34 PM, Pierre Morel wrote:
>> CSS characteristics exposes the features of the Channel SubSystem.

...

>> +/* Store Channel Subsystem Characteristics */
>> +struct chsc_scsc {
>> +	struct chsc_header req;
>> +	u32 reserved1;
>> +	u32 reserved2;
>> +	u32 reserved3;
> 
> Array?

OK

...snip...

>> +int get_chsc_scsc(void)
>> +{
>> +	int i, n;
>> +	int ret = 0;
>> +	char buffer[510];
>> +	char *p;
>> +
>> +	report_prefix_push("Channel Subsystem Call");
>> +
>> +	if (chsc_scsc) {
>> +		report_info("chsc_scsc already initialized");
>> +		goto end;
>> +	}
>> +
>> +	chsc_scsc = alloc_pages(0);
> 
> alloc_page() ?

OK too


Thanks for the comments,
Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
