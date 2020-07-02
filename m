Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792552123C5
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 14:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgGBM4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 08:56:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42644 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728661AbgGBM43 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 08:56:29 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062CWxdh185748;
        Thu, 2 Jul 2020 08:56:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32041fwwh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 08:56:28 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 062CX3YT185895;
        Thu, 2 Jul 2020 08:56:27 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32041fwwgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 08:56:27 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 062CstFX010734;
        Thu, 2 Jul 2020 12:56:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 31wwr82vfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 12:56:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 062CuNGN44957844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jul 2020 12:56:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 177DC11C05C;
        Thu,  2 Jul 2020 12:56:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB35611C052;
        Thu,  2 Jul 2020 12:56:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.146.43])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jul 2020 12:56:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 12/12] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-13-git-send-email-pmorel@linux.ibm.com>
 <20200617115442.036735c5.cohuck@redhat.com>
 <2383bdc0-caaf-9cb0-f4c4-ed57c1d3dfb1@linux.ibm.com>
 <20200619085718.25964a0a.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <fd2f7506-da62-1be5-4896-499c6ce7a682@linux.ibm.com>
Date:   Thu, 2 Jul 2020 14:56:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619085718.25964a0a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_08:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-19 08:57, Cornelia Huck wrote:
> On Wed, 17 Jun 2020 13:55:52 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-06-17 11:54, Cornelia Huck wrote:
>>> On Mon, 15 Jun 2020 11:32:01 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> (...)
> 
>>>> +int start_subchannel(unsigned int sid, int code, void *data, int count,
>>>> +		     unsigned char flags)
>>>> +{
>>>> +	int cc;
>>>> +	struct ccw1 *ccw = &unique_ccw;
>>>
>>> Hm... it might better to call this function "start_single_ccw" or
>>> something like that.
>>
>> You are right.
>> I will rework this.
>> What about differentiating this badly named "start_subchannel()" into:
>>
>> ccw_setup_ccw(ccw, data, cnt, flgs);
>> ccw_setup_orb(orb, ccw, flgs)
>> ccw_start_request(schid, orb);
>>
>> would be much clearer I think.
> 
> Not sure about ccw_setup_ccw; might get a bit non-obvious if you're
> trying to build a chain.
> 
> Let's see how this turns out.
> 
> (...)
> 
>> I will rework this.
>>
>> - rework the start_subchannel()
>> - rework the read_len() if we ever need this
> 
> I think checking the count after the request concluded is actually a
> good idea. In the future, we could also add a check that it matches the
> requested length for a request where SLI was not specified.
> 
>>
>> Also thinking to put the irq_io routine inside the library, it will be
>> reused by other tests.
> 
> Yes, that probably makes sense as well.
> 

Thanks,
I respin soon.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
