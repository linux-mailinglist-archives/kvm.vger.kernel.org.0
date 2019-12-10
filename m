Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83B1182DF
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 09:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfLJI4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 03:56:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbfLJI4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 03:56:42 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA8qUQY034896
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 03:56:41 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wrtkt6jfn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 03:56:40 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 10 Dec 2019 08:56:39 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Dec 2019 08:56:37 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBA8uaOO25297002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 08:56:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E01A4057;
        Tue, 10 Dec 2019 08:56:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23DE4A4055;
        Tue, 10 Dec 2019 08:56:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Dec 2019 08:56:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: css: stsch, enumeration test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
 <20191209174938.7df1ffa2.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 10 Dec 2019 09:56:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191209174938.7df1ffa2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121008-0020-0000-0000-000003961E1E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121008-0021-0000-0000-000021ED5D98
Message-Id: <e2d4611a-f702-36b9-9344-fdc4f4e771bf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_01:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-09 17:49, Cornelia Huck wrote:
> On Fri,  6 Dec 2019 17:26:25 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
>>
>> This tests the success of STSCH I/O instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   s390x/Makefile      |  2 ++
>>   s390x/css.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 +++
>>   4 files changed, 89 insertions(+)
>>   create mode 100644 s390x/css.c
>>
> 
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int scn;
>> +	int cc, i;
>> +	int found = 0;
>> +
>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn|SID_ONE, &schib);
>> +		if (!cc && (pmcw->flags & PMCW_DNV)) {
> 
> Not sure when dnv is actually applicable... it is used for I/O
> subchannels; chsc subchannels don't have a device; message subchannels
> use a different bit IIRC; not sure about EADM subchannels.
> 
> [Not very relevant as long as we run under KVM, but should be
> considered if you plan to run this test under z/VM or LPAR as well.]

Hum, interresting, I will check and modify accordingly.

> 
>> +			report_info("SID %04x Type %s PIM %x", scn,
>> +				     Channel_type[PMCW_CHANNEL_TYPE(pmcw)],
>> +				     pmcw->pim);
>> +			for (i = 0; i < 8; i++)  {
>> +				if ((pmcw->pim << i) & 0x80) {
>> +					report_info("CHPID[%d]: %02x", i,
>> +						    pmcw->chpid[i]);
>> +					break;
> 
> That 'break;' seems odd -- won't you end up printing the first chpid in
> the pim only?
yes
> 
> Maybe modify this loop to print the chpid if the path is in the pim,
> and 'n/a' or so if not?

OK

> 
>> +				}
>> +			}
>> +			found++;
>> +		}
>> +		if (cc == 3) /* cc = 3 means no more channel in CSS */
> 
> s/channel/subchannels/

thanks

> 
>> +			break;
>> +		if (found && !test_device_sid)
>> +			test_device_sid = scn|SID_ONE;
>> +	}
>> +	if (!found) {
>> +		report("Tested %d devices, none found", 0, scn);
>> +		return;
>> +	}
>> +	report("Tested %d devices, %d found", 1, scn, found);
>> +}
> 

Thanks for the reviewing,
Regards,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

