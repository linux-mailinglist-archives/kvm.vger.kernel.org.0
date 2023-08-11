Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D560778E97
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbjHKMCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 08:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjHKMCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 08:02:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0286125;
        Fri, 11 Aug 2023 05:02:32 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37BBpWPO023901;
        Fri, 11 Aug 2023 12:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VdkLcjfWMe6NRoF/NolL+X0OUF17mEipJ/11rANwXMo=;
 b=Rctp2emZMc+Vs3m9uCMo6qTEOaEAT8i9AD6WAOlimsxM+GpPrc+Pw+RF1TODwJfOpMHF
 CcRrLX3NUq63o8GzfOHSH10jbnFeJv/aQ7uv/CM9AAJf4Gpzc/lz0zzOujk6TSgKwCkW
 gEacNZCw+//jJ0EmwbWATvbEjCw3fQKUf42pb8InhY8EIBrZHxSj9nluDII/FmV1V7TF
 t1edBmtIyftfPtiKPAkr9HLx9ZgemkV1fgMziEBXcwUMkDVZJkAR+Z7vrBJCdJKZ4xk4
 pk7layfOcw/Wi2t6K1tvpTaDtGZC/WAzMKhN9pgzST6Z7fNC1BX7W2BjRa421m0Hpw8L eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sdmfyg9xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 12:02:31 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37BBvBlZ009811;
        Fri, 11 Aug 2023 12:02:31 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sdmfyg9x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 12:02:31 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37BA1aYQ006421;
        Fri, 11 Aug 2023 12:02:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sd2evfsva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 12:02:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37BC2RVx44827134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Aug 2023 12:02:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32CAE20043;
        Fri, 11 Aug 2023 12:02:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB63620040;
        Fri, 11 Aug 2023 12:02:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 11 Aug 2023 12:02:26 +0000 (GMT)
Date:   Fri, 11 Aug 2023 14:02:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nsg@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: load full register
Message-ID: <20230811140225.7e810730@p-imbrenda>
In-Reply-To: <20230811112949.888903-1-nrb@linux.ibm.com>
References: <20230811112949.888903-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Svk9LrCq-Epu8EsKyh3EWtV5HMJnzpxR
X-Proofpoint-GUID: gxOUoyqwaETS8E8Lc9SgTV6HY6_pewXZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-11_03,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308110106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Aug 2023 13:29:36 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> There may be contents left in the upper 32 bits of executed_addr; hence
> we should use a 64-bit load to make sure they are overwritten.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/spec_ex.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index e3dd85dcb153..72b942576369 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -142,7 +142,7 @@ static int psw_odd_address(void)
>  		"	larl	%%r1,0f\n"
>  		"	stg	%%r1,%[fixup_addr]\n"
>  		"	lpswe	%[odd_psw]\n"
> -		"0:	lr	%[executed_addr],%%r0\n"
> +		"0:	lgr	%[executed_addr],%%r0\n"
>  	: [fixup_addr] "=&T" (fixup_psw.addr),
>  	  [executed_addr] "=d" (executed_addr)
>  	: [odd_psw] "Q" (odd)

