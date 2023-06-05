Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612627221C0
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjFEJL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjFEJLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:11:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E4D2;
        Mon,  5 Jun 2023 02:11:24 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3558qe0I017290;
        Mon, 5 Jun 2023 09:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oXcIKS3GZ8WyTfS0QYmtLBKhmFiLpJlnOAFrXZoKAF8=;
 b=G5ASvnoPL0kzLmYlK3sFSIkNShM4l5f0PrzBeW2Mj8WF2gbDA2UeLORD2RmUAeZru7Rl
 wezlLTvi7LwQp8s81odd+yY6ZxuGC/Z08K3/oBDYuY080yfg1sjHUVkYo1xUrJ+ceEXH
 4obpN6h6+W6qoZttdjgMlLe2GoUh7Y/Fd7RSWdastRjjVLtQQrRN5S0rtxq9BniU0lJC
 7KRawOskd+UFGsXAEGYp4ZUAfUtQ5Ig4BwQDj7yRiqISeltlsZ59API5qUXfCqbdxgd0
 m7FQkfS0eBCmC3dUr8hiGmAAfX7waq0NlFV+DS6Ae+7TPrasGAiX1OCqCz7dvYHV6vP3 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1cju0fdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:11:23 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35590uui016022;
        Mon, 5 Jun 2023 09:11:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1cju0fcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:11:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3551fFik012752;
        Mon, 5 Jun 2023 09:11:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2h8ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:11:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3559BGfQ58458514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 09:11:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCA4820065;
        Mon,  5 Jun 2023 09:11:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B2192004D;
        Mon,  5 Jun 2023 09:11:16 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 09:11:16 +0000 (GMT)
Message-ID: <a11b4d65-d8fd-f1a2-6acd-ceeec9c7ac90@linux.ibm.com>
Date:   Mon, 5 Jun 2023 11:11:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v3 4/6] s390x: lib: don't forward PSW when
 handling exception in SIE
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-5-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230601070202.152094-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bO57AODeCxTlq-ixoCnl7uu9oIBfjdyU
X-Proofpoint-ORIG-GUID: A4FFgILEhs7HHbiuH-I1Zyzhz98w0V7G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:02, Nico Boehr wrote:
> When we're handling a pgm int in SIE, we want to return to the SIE
> cleanup after handling the exception. That's why we set pgm_old_psw to
> the sie_exit label in fixup_pgm_int.
> 
> On nullifing pgm ints, fixup_pgm_int will also forward the old PSW such
> that we don't cause an pgm int again.
> 
> However, when we want to return to the sie_exit label, this is not
> needed (since we've manually set pgm_old_psw). Instead, forwarding the
> PSW might cause us to skip an instruction or end up in the middle of an
> instruction.
> 
> So, let's just skip the rest of the fixup in case we're inside SIE.
> 
> Note that we're intentionally not fixing up the PSW in the guest; that's
> best left to the test at hand by registering their own psw fixup.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/interrupt.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index d97b5a3a7e97..3f07068877ee 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -145,6 +145,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>   	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
>   	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
>   		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
> +		return;
>   	}
>   
>   	switch (lowcore.pgm_int_code) {

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
