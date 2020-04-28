Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3915C1BB8D3
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD1I1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:27:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbgD1I1n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 04:27:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S82USV129070;
        Tue, 28 Apr 2020 04:27:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhq82xk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:27:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S83be6135602;
        Tue, 28 Apr 2020 04:27:42 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhq82xjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:27:41 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S8B268017136;
        Tue, 28 Apr 2020 08:27:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6wpt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 08:27:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S8RbS843319498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 08:27:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 564445204F;
        Tue, 28 Apr 2020 08:27:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 07A2752050;
        Tue, 28 Apr 2020 08:27:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 07/10] s390x: css: msch, enable test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-8-git-send-email-pmorel@linux.ibm.com>
 <cff917e0-f7e0-fd48-eda5-0cbe8173ae8a@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <abafd691-d9ab-33b2-c522-d37fecc3e881@linux.ibm.com>
Date:   Tue, 28 Apr 2020 10:27:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <cff917e0-f7e0-fd48-eda5-0cbe8173ae8a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-27 15:11, Janosch Frank wrote:
> On 4/24/20 12:45 PM, Pierre Morel wrote:
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>> This includes:
>> - Get the current SubCHannel Information Block (SCHIB) using STSCH
>> - Update it in memory to set the ENABLE bit
>> - Tell the CSS that the SCHIB has been modified using MSCH
>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>    enabled.
>>
>> This tests the MSCH instruction to enable a channel succesfuly.
> 
> successfully

Thx

> 
>> This is NOT a routine to really enable the channel, no retry is done,
>> in case of error, a report is made.
> 
> Would we expect needing retries for the pong device?

Yes it can be that we need to retry some instructions if we want them to 
succeed.
This is the case for example if we develop a driver for an operating system.
When working with firmware, sometime, things do not work at the first 
time. Mostly due to races in silicium, firmware or hypervisor or between 
them all.

Since our purpose is to detect such problems we do not retry 
instructions but report the error.

If we detect such problem we may in the future enhance the tests.

> 
>>


>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
> 
> If these tests are layered on top of each other and need a device to
> work, we should abort or skip and exit the test if the enumeration
> doesn't bring up devices

OK, we can abort instead of skipping

>> +	report(1, "Tested");
> 
> s/Tested/Enabled/

OK

Thanks,
Regards,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
