Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31E34CD2DA
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiCDK5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiCDK5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:57:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1191AE67D;
        Fri,  4 Mar 2022 02:56:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2247NlBj015429;
        Fri, 4 Mar 2022 10:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Sv55zqQxwC7XwhgQmm1PedhbnchspmcsAQt2q3kUjk4=;
 b=r/GK0CwjfMnMAugIszZqLQrRqih/8/cBdyBgnIrln7he6y092TQO4swbzh6QmosvEZUQ
 vmIe2RJyMFXDSt2yCvD94pE8Sn110nFrn4LHjNBnPxteVBigjRYMG8eulytin2H40URQ
 IfU0GFJ0TEyDw1iKObJ08QpWK2/GrslzhWiePvQFmhS5y+MmqJIfitH9I7HRALlfB60Z
 SfJ+VzEs2NOQrB4wx6+4zdlKr1nTlS63l3WJisHKH01612AtHqDgRy4VH0o8O+eCE8+A
 nTFGxuF7vpf/pPSx35c1BbE59glD/JmSND+c00tFllOFBNcfCBNz/uvKBuyzRFyTXRov Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekebdbff8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:56:47 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224Aq4Ue035332;
        Fri, 4 Mar 2022 10:56:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekebdbfet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:56:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224Arv59010825;
        Fri, 4 Mar 2022 10:56:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ek4kg9gt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:56:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224Auf2R47186228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 10:56:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A22A42049;
        Fri,  4 Mar 2022 10:56:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E126E42041;
        Fri,  4 Mar 2022 10:56:40 +0000 (GMT)
Received: from [9.145.58.173] (unknown [9.145.58.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 10:56:40 +0000 (GMT)
Message-ID: <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
Date:   Fri, 4 Mar 2022 11:56:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert remaining
 smp_sigp to _retry
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220303210425.1693486-1-farman@linux.ibm.com>
 <20220303210425.1693486-7-farman@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220303210425.1693486-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q30IIxJf6GF9uRHl-gc7O5Qh46JOCGgV
X-Proofpoint-GUID: RXxsgBnrtZdO4eG3pdr6TY81-1iWQcQh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_02,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 22:04, Eric Farman wrote:
> A SIGP SENSE is used to determine if a CPU is stopped or operating,
> and thus has a vested interest in ensuring it received a CC0 or CC1,
> instead of a CC2 (BUSY). But, any order could receive a CC2 response,
> and is probably ill-equipped to respond to it.

sigp sense running status doesn't return a cc2, only sigp sense does afaik.
Looking at the KVM implementation tells me that it's not doing more than 
looking at the R bit in the sblk.

> 
> In practice, the order is likely to only encounter this when racing
> with a SIGP STOP (AND STORE STATUS) or SIGP RESTART order, which are
> unlikely. But, since it's not impossible, let's convert the library
> calls that issue a SIGP to loop on CC2 so the callers do not need
> to react to that possible outcome.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   lib/s390x/smp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 85b046a5..2e476264 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -85,7 +85,7 @@ bool smp_cpu_stopped(uint16_t idx)
>   
>   bool smp_sense_running_status(uint16_t idx)
>   {
> -	if (smp_sigp(idx, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
> +	if (smp_sigp_retry(idx, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
>   		return true;
>   	/* Status stored condition code is equivalent to cpu not running. */
>   	return false;
> @@ -169,7 +169,7 @@ static int smp_cpu_restart_nolock(uint16_t idx, struct psw *psw)
>   	 * running after the restart.
>   	 */
>   	smp_cpu_stop_nolock(idx, false);
> -	rc = smp_sigp(idx, SIGP_RESTART, 0, NULL);
> +	rc = smp_sigp_retry(idx, SIGP_RESTART, 0, NULL);
>   	if (rc)
>   		return rc;
>   	/*

