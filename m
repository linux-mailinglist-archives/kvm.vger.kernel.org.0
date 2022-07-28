Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62BB583F98
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiG1NGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 09:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbiG1NGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 09:06:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A25CD6
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 06:06:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SCpgsN022721
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6sfgsorhL6xF7d2lDyaG1bwB+sGYe85RN4RDroOOREg=;
 b=ZU+l6fixpR9xhlTH6lT8AeIbzpr+vfvwa2oYpsgfLip3aDmwyO1UVxQ39q1olofOMcX+
 kkxUaQ2MfJYJLVhGJNGpVarUnn4IT+Dz7VZIJfw2qCsiKdDF1m9PDPj/Fim4jDNkHy0A
 MeTod3Qx5jHT3ie5UpIvubmZgFQTx7OT2ZmBI8RkNOhydI4r2dxiLmKn8zQJDWrA2zaj
 ssLflrzT8wn0NNK1qTMM25Fo4sJlP8I0GgyffPY3IxOQ5TuI/rgJNBR9HmrIp5D1uZZE
 P2CHeEPZGIjNw1/v+TACu2XdRy7yfq2iWczjM2JDd1HYtQ6CoLPBwygjWJKOkimxv+iT 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hktu6rm1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:06:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SCve2O025149
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:06:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hktu6rkyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 13:06:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SD5J9J006879;
        Thu, 28 Jul 2022 13:06:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6eun2qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 13:06:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SD4boZ32244112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 13:04:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1415D11C050;
        Thu, 28 Jul 2022 13:06:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C876711C04A;
        Thu, 28 Jul 2022 13:06:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.43])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 13:06:39 +0000 (GMT)
Date:   Thu, 28 Jul 2022 15:06:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests] s390x: fix build with clang
Message-ID: <20220728150638.41b8f5f0@p-imbrenda>
In-Reply-To: <20220726083725.32454-1-pbonzini@redhat.com>
References: <20220726083725.32454-1-pbonzini@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e_1zLJDUgLES3oc2zlMXoSToVgsXt3AG
X-Proofpoint-ORIG-GUID: 4DPpESyWjHmqtXvtqpU3Mts9xp1B7--5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_05,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jul 2022 10:37:25 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Reported by Travis CI:
> 
> /home/travis/build/kvm-unit-tests/kvm-unit-tests/lib/s390x/fault.c:43:56: error: static_assert with no message is a C++17 extension [-Werror,-Wc++17-extensions]
>                 _Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
>                                                                      ^
>                                                                      , ""
> 1 error generated.
> make: *** [<builtin>: lib/s390x/fault.o] Error 1
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/fault.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> index 1cd6e26..a882d5d 100644
> --- a/lib/s390x/fault.c
> +++ b/lib/s390x/fault.c
> @@ -40,7 +40,7 @@ static void print_decode_pgm_prot(union teid teid)
>  			"LAP",
>  			"IEP",
>  		};
> -		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
> +		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES, "ESOP2 prot codes");
>  		int prot_code = teid_esop2_prot_code(teid);
>  
>  		printf("Type: %s\n", prot_str[prot_code]);

