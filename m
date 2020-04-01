Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481F419A70C
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 10:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDAITc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 04:19:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgDAITc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 04:19:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03184QCo055916
        for <kvm@vger.kernel.org>; Wed, 1 Apr 2020 04:19:31 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303vfj47u9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 04:19:31 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Wed, 1 Apr 2020 09:19:13 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 09:19:10 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0318JPmc29884554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 08:19:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB39AA4053;
        Wed,  1 Apr 2020 08:19:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E9F9A4069;
        Wed,  1 Apr 2020 08:19:25 +0000 (GMT)
Received: from [9.145.48.113] (unknown [9.145.48.113])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 08:19:25 +0000 (GMT)
Subject: Re: [PATCH 1/3] tools/kvm_stat: add command line switch '-z' to skip
 zero records
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-2-raspl@linux.ibm.com>
 <6edd0cda-993b-3565-8781-d2da786766a2@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Wed, 1 Apr 2020 10:19:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6edd0cda-993b-3565-8781-d2da786766a2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040108-0020-0000-0000-000003BF7AEF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040108-0021-0000-0000-000022181F7C
Message-Id: <648fea4a-ec81-2090-33b8-f1af25c5491f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-31 23:45, Paolo Bonzini wrote:
> On 31/03/20 22:00, Stefan Raspl wrote:
>> @@ -1523,14 +1535,20 @@ def log(stats, opts, frmt, keys):
>>      """Prints statistics as reiterating key block, multiple value blocks."""
>>      line = 0
>>      banner_repeat = 20
>> +    banner_printed = False
>> +
>>      while True:
>>          try:
>>              time.sleep(opts.set_delay)
>> -            if line % banner_repeat == 0:
>> +            if line % banner_repeat == 0 and not banner_printed:
>>                  print(frmt.get_banner())
>> -            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") +
>> -                  frmt.get_statline(keys, stats.get()))
>> +                banner_printed = True
> 
> Can't skip_zero_records be handled here instead?
> 
>     values = stats.get()
>     if not opts.skip_zero_records or \
>         any((values[k].delta != 0 for k in keys):
>        statline = frmt.get_statline(keys, values)
>        print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)

I wanted to avoid such an extra check for performance reasons. Granted, I have
to do something likewise (i.e. checking for non-zero values) in my patch for csv
records, but at least for the standard format things are a bit less costly
(avoiding an extra pass over the data).

Ciao,
Stefan

