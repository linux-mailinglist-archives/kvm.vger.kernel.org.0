Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC8D1FCBFD
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgFQLOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:14:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726708AbgFQLOX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:14:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HB1cV3034010;
        Wed, 17 Jun 2020 07:14:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hpt8hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:14:21 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HAYDcP148046;
        Wed, 17 Jun 2020 07:14:20 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hpt8ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:14:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HBAJDJ019170;
        Wed, 17 Jun 2020 11:14:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs8wy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:14:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBEG8765274366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:14:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B5F211C04C;
        Wed, 17 Jun 2020 11:14:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B0C11C058;
        Wed, 17 Jun 2020 11:14:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:14:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 10/12] s390x: css: stsch, enumeration
 test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-11-git-send-email-pmorel@linux.ibm.com>
 <20200617104857.1bdab6a5.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <20d6e17c-a396-1a99-938a-7e55656d518c@linux.ibm.com>
Date:   Wed, 17 Jun 2020 13:14:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617104857.1bdab6a5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 10:48, Cornelia Huck wrote:
> On Mon, 15 Jun 2020 11:31:59 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
> 
> Maybe worth adding a note:
> 
> "We currently don't enable multiple subchannel sets and therefore only
> look in subchannel set 0."

right, thanks

> 
>>
>> This tests the success of STSCH I/O instruction, we do not test the
>> reaction of the VM for an instruction with wrong parameters.

...snip...

>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn | SCHID_ONE, &schib);
>> +		switch (cc) {
>> +		case 0:		/* 0 means SCHIB stored */
>> +			break;
>> +		case 3:		/* 3 means no more channels */
>> +			goto out;
>> +		default:	/* 1 or 2 should never happened for STSCH */
> 
> s/happened/happen/

yes

...snip...


>> diff --git a/s390x/css.c b/s390x/css.c
...
>> +static void test_enumerate(void)
>> +{
>> +	test_device_sid = css_enumerate();
>> +	if (test_device_sid & SCHID_ONE) {
>> +		report(1, "First device schid: 0x%08x", test_device_sid);
> 
> Maybe "Schid of first I/O device" ?

yes, better.

> 
...snip...
>> +}
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
