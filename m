Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3BA2DC844
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 22:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgLPVTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 16:19:55 -0500
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:17126 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbgLPVTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 16:19:55 -0500
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGLEFVi013122;
        Wed, 16 Dec 2020 21:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=2aFvK27wjUPLUSmZ2FYvAYjppRuYn0YXB4jA+O/tDoI=;
 b=iSM8bgIvaCii5Ze1U0E0yKyrbB66XlIDqF+knqg9YdRjG5lfyXFJYwoGxbi5ympnp4/a
 4p/WSWCjUlEJQFlZX4zg413V29EXYzQkkpeIaoEVC+gJQtCbjrTVEKTIpQIDTASk/dcF
 Mvm0pE/e6VfafQyVqR2WK1N9mL+NecSHhfkOQpE9ffV68nkQxZ0X6ye/I5czf0q6Pb3R
 9I4S7wsLyCgw3ZakyhpIcCPx7oa9mEPIgPApuaTcfSccpAvAKCuvuv9wxxtj9V58Zjfw
 1U7n8qKgo6pSj1WvWYSPZHaWGglTz6ct4t6/umGfLMGIG4pDpSWpPNEkyWHd4mPdcRVb iA== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 35dfsjnxy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 21:16:36 +0000
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0BGL3nl5014066;
        Wed, 16 Dec 2020 16:16:35 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint8.akamai.com with ESMTP id 35ct338ahu-1;
        Wed, 16 Dec 2020 16:16:35 -0500
Received: from [0.0.0.0] (unknown [172.27.119.138])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 611FE525;
        Wed, 16 Dec 2020 21:16:34 +0000 (GMT)
Subject: Re: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
To:     Peter Zijlstra <peterz@infradead.org>,
        Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
 <20201216133014.GT3092@hirez.programming.kicks-ass.net>
 <20201216134249.GU3092@hirez.programming.kicks-ass.net>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <7a7ceca6-5a8d-f88e-27f1-9ac14d27a6b8@akamai.com>
Date:   Wed, 16 Dec 2020 16:16:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216134249.GU3092@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_09:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160131
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_09:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=903 suspectscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160133
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/16/20 8:42 AM, Peter Zijlstra wrote:
> On Wed, Dec 16, 2020 at 02:30:14PM +0100, Peter Zijlstra wrote:
>>

>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16766,6 +16766,18 @@ M:	Ion Badulescu <ionut@badula.org>
>>  S:	Odd Fixes
>>  F:	drivers/net/ethernet/adaptec/starfire*
>>  
>> +STATIC BRANCH/CALL
>> +M:	Peter Zijlstra <peterz@infradead.org>
>> +M:	Josh Poimboeuf <jpoimboe@redhat.com>
>> +M:	Jason Baron <jbaron@akamai.com>
>> +R:	Steven Rostedt <rostedt@goodmis.org>
>> +R:	Ard Biesheuvel <ardb@kernel.org>
>> +S:	Supported
> 
> F:	arch/*/include/asm/jump_label*.h
> F:	arch/*/include/asm/static_call*.h
> F:	arch/*/kernel/jump_label.c
> F:	arch/*/kernel/static_call.c
> 
> These too?
> 
>> +F:	include/linux/jump_label*.h
>> +F:	include/linux/static_call*.h
>> +F:	kernel/jump_label.c
>> +F:	kernel/static_call.c
>> +
>>  STEC S1220 SKD DRIVER
>>  M:	Damien Le Moal <Damien.LeMoal@wdc.com>
>>  L:	linux-block@vger.kernel.org


Thanks Peter.

Acked-by: Jason Baron <jbaron@akamai.com>
