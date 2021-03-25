Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B434967A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYQMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:12:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229533AbhCYQM0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:12:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG4YEi018836
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M9roaPPxh5PtBsRrWi4oFK35+Klwz4YNbZuSTsCRnCc=;
 b=m6NmR2FDJL6h4CdIRSBJ1IKDUBvrXsd3kw7nPsKM79jxFYeZQtuSrVauR2S3MNgkl4pj
 VWkmrvfy1pfQAuSztNp2uuZHPEGEYgalAQRv6PfQZhXreGffL9To+RrAoXRIRKqCObSw
 3AT6JMCXxqB/6STAe5Jb+bRtW32njYw1L/2GeGaGyewzbLNdOw0SyJoIhc1ES/bKLYhD
 Uep86H2lyuFmZdUBnq9o0YzF+thgYqs9vjlZqYq3HUZDfvl9x+UMh3Wmj2ZPLF0c0I+U
 GY+OheLHQlYNVEklLyt+V33ZzPuacpsCPzNChS6mpBuOqIWlMmSJYPlmX/zoAr7jGW5t eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0bdchc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:12:25 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG5gp4030904
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:12:25 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gq0bdbx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:12:24 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PG8EbV010726;
        Thu, 25 Mar 2021 16:10:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68d411-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:10:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PGA82U17629520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:10:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82D2E11C05B;
        Thu, 25 Mar 2021 16:10:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50D7611C069;
        Thu, 25 Mar 2021 16:10:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:10:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
 <20210325155235.4e0faa40@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4fa21a17-9d82-153e-459f-5ca1265b06db@linux.ibm.com>
Date:   Thu, 25 Mar 2021 17:10:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325155235.4e0faa40@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 3:52 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:00 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
...snip...
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: sch %08x failed with cc=%d",
>> schid, cc);
> 
> KVM unit tests allow up to 120 columns per line, please use them, the
> code will be more readable; this applies for all broken lines, not just
> in this patch.

Oh someone did not read the README!
thanks.


-- 
Pierre Morel
IBM Lab Boeblingen
