Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082C91F3A8A
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgFIMUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 08:20:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbgFIMUm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 08:20:42 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 059C374S042115;
        Tue, 9 Jun 2020 08:20:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j59uapfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 08:20:41 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 059C3QCl044221;
        Tue, 9 Jun 2020 08:20:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j59uapea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 08:20:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 059CBJlR023453;
        Tue, 9 Jun 2020 12:20:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7wwsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 12:20:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 059CJKe746662086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 12:19:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B08F4C046;
        Tue,  9 Jun 2020 12:20:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFBF74C040;
        Tue,  9 Jun 2020 12:20:35 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 12:20:35 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 10/12] s390x: css: stsch, enumeration
 test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-11-git-send-email-pmorel@linux.ibm.com>
 <af39687e-4512-d147-5011-11d03b68e1bf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a9a44f1d-2179-5d95-f45f-172000f7a3c1@linux.ibm.com>
Date:   Tue, 9 Jun 2020 14:20:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <af39687e-4512-d147-5011-11d03b68e1bf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_03:2020-06-09,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 cotscore=-2147483648 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 09:39, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:

...snip...

>> +int css_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int scn_found = 0;
>> +	int dev_found = 0;
>> +	int schid = 0;
>> +	int cc;
>> +	int scn;
>> +
>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn | SCHID_ONE, &schib);
>> +		switch (cc) {
>> +		case 0:		/* 0 means SCHIB stored */
>> +			break;
>> +		case 3:		/* 3 means no more channels */
>> +			goto out;
>> +		default:	/* 1 or 2 should never happened for STSCH */
>> +			report_info("Unexpected error %d on subchannel %08x",
>> +				    cc, scn | SCHID_ONE);
> 
> Should this maybe even be a report_abort() instead? Or leave the error
> reporting to the caller...

report_abort() should be fine as if this happens something is really broken.

> 
>> +			return cc;
>> +		}

...snip...

>> +static void test_enumerate(void)
>> +{
>> +	test_device_sid = css_enumerate();
>> +	if (test_device_sid & SCHID_ONE) {
>> +		report(1, "First device schid: 0x%08x", test_device_sid);
>> +		return;
>> +	}
>> +
>> +	switch (test_device_sid) {
>> +	case 0:
>> +		report (0, "No I/O device found");
>> +		break;
>> +	default:	/* 1 or 2 should never happened for STSCH */
>> +		report(0, "Unexpected cc=%d during enumeration",
>> +		       test_device_sid);
>> +			return;
>> +	}
> 
> Ok, so here is now the test failure for the cc=1 or 2 that should never
> happen. That means currently you print out the CC for this error twice.
> One time should be enough, either here, or use an report_abort() in the
> css_enumerate(), I'd say.
> 
> Anyway, can you please replace this switch statement with a "if
> (!test_device_sid)" instead? Or do you plan to add more "case"
> statements later?

I will use the repor_abort() in the css_enumerate() so there
is only two case, I find a channel or not, so I don't even need the 
second if :) .

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
