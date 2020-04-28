Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD661BB926
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD1Iu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:50:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgD1Iu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 04:50:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S8XAFl173479;
        Tue, 28 Apr 2020 04:50:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mguvs0g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:50:27 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S8XP4U174065;
        Tue, 28 Apr 2020 04:50:27 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mguvs0e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:50:27 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S8j9s9031144;
        Tue, 28 Apr 2020 08:50:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 30mcu8cq9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 08:50:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S8oKJC63897746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 08:50:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C83835204E;
        Tue, 28 Apr 2020 08:50:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 84A4452054;
        Tue, 28 Apr 2020 08:50:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 10/10] s390x: css: ping pong
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-11-git-send-email-pmorel@linux.ibm.com>
 <ecd95341-0cc2-1aee-239d-5de63cf6e7e1@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6591ec0d-5b44-1d85-a314-c6b9f87b7952@linux.ibm.com>
Date:   Tue, 28 Apr 2020 10:50:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ecd95341-0cc2-1aee-239d-5de63cf6e7e1@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-27 15:14, Janosch Frank wrote:
> On 4/24/20 12:45 PM, Pierre Morel wrote:
>> To test a write command with the SSCH instruction we need a QEMU device,
>> with control unit type 0xC0CA. The PONG device is such a device.
>>
>> This type of device responds to PONG_WRITE requests by incrementing an
>> integer, stored as a string at offset 0 of the CCW data.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

>> +static void test_ping(void)
>> +{
>> +	int success, result;
>> +	int cnt = 0, max = 4;
>> +
>> +	if (senseid.cu_type != PONG_CU) {
>> +		report_skip("No PONG, no ping-pong");
> 
> "Device is not a pong device."

:( so far for poetry


> 
>> +		return;
>> +	}
>> +
>> +	result = register_io_int_func(irq_io);
>> +	if (result) {
>> +		report(0, "Could not register IRQ handler");
>> +		return;
>> +	}
> 
> I'm not sure if it's worth checking the return values or even having a
> check in register_io_int_func() in the first place.

I wait for reviewers/maintainers having already given their reviewed-by 
to the interrupt registration patch to give their opinion.
Then I change it if needed.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
