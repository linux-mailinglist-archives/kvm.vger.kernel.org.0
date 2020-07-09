Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D56C21A112
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGINmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 09:42:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgGINmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 09:42:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069DWv6P063114;
        Thu, 9 Jul 2020 09:42:02 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325kh42ymq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:42:01 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069DYPMl072265;
        Thu, 9 Jul 2020 09:42:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325kh42ykd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 09:42:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069DavlK014019;
        Thu, 9 Jul 2020 13:41:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 325k0crxpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 13:41:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069Dfuc459834612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 13:41:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E10BAAE045;
        Thu,  9 Jul 2020 13:41:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72CB9AE04D;
        Thu,  9 Jul 2020 13:41:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 13:41:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v11 8/9] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
References: <1594282068-11054-1-git-send-email-pmorel@linux.ibm.com>
 <1594282068-11054-9-git-send-email-pmorel@linux.ibm.com>
 <20200709134056.0d267b6c.cohuck@redhat.com>
 <d55c3e5b-8adf-8f7f-2b97-c270fb6598b4@linux.ibm.com>
 <20200709153055.6f2b5e59.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4f861a9c-179b-5376-5f0f-dce30f31da71@linux.ibm.com>
Date:   Thu, 9 Jul 2020 15:41:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709153055.6f2b5e59.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_07:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-09 15:30, Cornelia Huck wrote:
> On Thu, 9 Jul 2020 15:12:05 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-07-09 13:40, Cornelia Huck wrote:
>>> On Thu,  9 Jul 2020 10:07:47 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> A second step when testing the channel subsystem is to prepare a channel
>>>> for use.
>>>> This includes:
>>>> - Get the current subchannel Information Block (SCHIB) using STSCH
>>>> - Update it in memory to set the ENABLE bit and the specified ISC
>>>> - Tell the CSS that the SCHIB has been modified using MSCH
>>>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>>>     enabled and uses the specified ISC.
>>>> - If the command succeeds but subchannel is not enabled or the ISC
>>>>     field is not as expected, retry a predefined retries count.
>>>> - If the command fails, report the failure and do not retry, even
>>>>     if cc indicates a busy/status pending as we do not expect this.
>>>>
>>>> This tests the MSCH instruction to enable a channel successfully.
>>>> Retries are done and in case of error, and if the retries count
>>>> is exceeded, a report is made.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Acked-by: Thomas Huth <thuth@redhat.com>
>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>> ---
>>>>    lib/s390x/css.h     |  8 +++--
>>>>    lib/s390x/css_lib.c | 72 +++++++++++++++++++++++++++++++++++++++++++++
>>>>    s390x/css.c         | 15 ++++++++++
>>>>    3 files changed, 92 insertions(+), 3 deletions(-)
>>>
>>> (...)
>>>    
>>>> +/*
>>>> + * css_msch: enable subchannel and set with specified ISC
>>>
>>> "css_enable: enable the subchannel with the specified ISC"
>>>
>>> ?
>>>    
>>>> + * @schid: Subchannel Identifier
>>>> + * @isc  : number of the interruption subclass to use
>>>> + * Return value:
>>>> + *   On success: 0
>>>> + *   On error the CC of the faulty instruction
>>>> + *      or -1 if the retry count is exceeded.
>>>> + */
>>>> +int css_enable(int schid, int isc)
>>>> +{
>>>> +	struct pmcw *pmcw = &schib.pmcw;
>>>> +	int retry_count = 0;
>>>> +	uint16_t flags;
>>>> +	int cc;
>>>> +
>>>> +	/* Read the SCHIB for this subchannel */
>>>> +	cc = stsch(schid, &schib);
>>>> +	if (cc) {
>>>> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>>>> +		return cc;
>>>> +	}
>>>> +
>>>> +	flags = PMCW_ENABLE | (isc << PMCW_ISC_SHIFT);
>>>> +	if ((pmcw->flags & flags) == flags) {
>>>
>>> I think you want (pmcw->flags & PMCW_ENABLE) == PMCW_ENABLE -- this
>>> catches the case of "subchannel has been enabled before, but with a
>>> different isc".
>>
>> If with a different ISC, we need to modify the ISC.
>> Don't we ?
> 
> I think that's a policy decision (I would probably fail and require a
> disable before setting another isc, but that's a matter of taste).
> 
> Regardless, I think the current check doesn't even catch the 'different
> isc' case?

hum, right.
If it is OK I remove this one.
And I must rework the same test I do later
  in this patch.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
