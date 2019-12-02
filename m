Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB9110EECF
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfLBR4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 12:56:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11294 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727420AbfLBR4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 12:56:06 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2HlDP8153714
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 12:56:05 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wkm46ueyw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:56:05 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 17:56:02 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 17:55:58 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2HtHJo26214906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 17:55:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C217AA4055;
        Mon,  2 Dec 2019 17:55:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CE65A4051;
        Mon,  2 Dec 2019 17:55:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 17:55:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 7/9] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-8-git-send-email-pmorel@linux.ibm.com>
 <20191202153016.382e3fa8.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 18:55:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202153016.382e3fa8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120217-0016-0000-0000-000002CFD7BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120217-0017-0000-0000-00003331CD84
Message-Id: <14ca95f4-f64c-6535-776a-639b45269cd2@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_04:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 15:30, Cornelia Huck wrote:
> On Thu, 28 Nov 2019 13:46:05 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>>
>> This tests the success of the MSCH instruction by enabling a channel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 8186f55..e42dc2f 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -62,11 +62,38 @@ static void test_enumerate(void)
>>   	return;
>>   }
>>   
>> +static void set_schib(void)
>> +{
>> +	struct pmcw *p = &schib.pmcw;
>> +
>> +	p->intparm = 0xdeadbeef;
>> +	p->flags |= PMCW_ENABLE;
>> +}
>> +
>> +static void test_enable(void)
>> +{
>> +	int ret;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +	set_schib();
>> +	dump_schib(&schib);
>> +
>> +	ret = msch(test_device_sid, &schib);
>> +	if (ret)
>> +		report("msch cc=%d", 0, ret);
> 
> Maybe do a stsch and then check/dump the contents of the schib again?
> 
> Background: The architecture allows that msch returns success, but that
> the fields modified by the issuer remain unchanged at the subchannel
> regardless. That should not happen with QEMU; but I remember versions
> of z/VM where we sometimes had to call msch twice to make changes stick.

OK, thanks, good advice

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

