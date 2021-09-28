Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC641AC7D
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 11:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhI1J7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 05:59:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240037AbhI1J7c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 05:59:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S92mAd015324;
        Tue, 28 Sep 2021 05:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hlt/6ZpRlJpH26I8xfowU061lByrop6qLVQNOhwTwBc=;
 b=diqsoD9/5HZ6FTZBcFtTaCnPWN6w5L1uvNm4wNb/K3L5yfWunUdzQJ7d144cUkO7AQ69
 74s4lZnjuUALu+G4cQzge1F0/pKy1FloiHjINgAiVJlbm7OqYrIIveTmwN4/IZDx/vEX
 /zd/qjdS1XcY9+I5LgfnePDnC9Qfs3x7yM7vimPcdp1FguMdUx2bahiMSdzHo/vP4nZ1
 QM35aDqFYS9gPe13sUGuefFDYp3amBQfEThR+97if/m78HD7toZ8jnAUjzX5wBoxNxVG
 un3pK5R2WUo8VPJF7WLw2HaPZRIzppYDJh0u4xjZHcEX92/rk11ms2s2wFWuYviyFC2J nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqprxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 05:57:53 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18S9cTO4006194;
        Tue, 28 Sep 2021 05:57:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktqprwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 05:57:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18S9rwvI008014;
        Tue, 28 Sep 2021 09:57:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3b9ud9jyh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 09:57:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18S9qhQD55378420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:52:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DB914C04A;
        Tue, 28 Sep 2021 09:57:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB9F24C059;
        Tue, 28 Sep 2021 09:57:46 +0000 (GMT)
Received: from [9.145.12.195] (unknown [9.145.12.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 09:57:46 +0000 (GMT)
Message-ID: <43ff6973-dd0d-3800-9765-f8b1d7e8ee7d@linux.ibm.com>
Date:   Tue, 28 Sep 2021 11:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: Makefile: Remove snippet
 flatlib linking
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-8-frankja@linux.ibm.com>
 <329948a8-b4ea-1c4a-5392-3fd6aa8540f6@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <329948a8-b4ea-1c4a-5392-3fd6aa8540f6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V3oBVv30slaB4zBVI_Cj3wBapW4A8bPp
X-Proofpoint-GUID: g2LcvOEvydVsJLd3JKebW9R1Dkmr8Ina
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/21 19:47, Thomas Huth wrote:
> On 22/09/2021 09.18, Janosch Frank wrote:
>> We can't link the flatlib as we do not export everything that it needs
>> and we don't (want to) call the init functions.
>>
>> In the future we might implement a tiny lib that uses select lib
> 
> s/select/selected/ ?

Sure

> 
>> object files and re-implements functions like assert() and
>> test_facility() to be able to use some parts of the lib.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/Makefile | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 5d1a33a0..d09c0a17 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -92,7 +92,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>    	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>>    
>>    $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
>> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
>> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib)
> 
> Don't we need memcpy() and friends in some cases? ... well, likely not,
> otherwise linking would fail... So:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Currently not but we can still import header files and use static things 
which is very helpful already. Fixing this will require a lot of thought 
since I don't really want to write a new lib just for the snippets but 
making them compatible to the flatlib will also require a lot of work.
