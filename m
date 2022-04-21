Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06B509F2C
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382734AbiDUMCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 08:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbiDUMCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 08:02:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1E32ED4D;
        Thu, 21 Apr 2022 04:59:13 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9Cuoo004921;
        Thu, 21 Apr 2022 11:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UfM4SajG/EAi4X1WZrdGARqPQdG3u1TBkxrT33iA3v4=;
 b=J8FFjEHrvjDGDaQE0rG0WqGC02sNSd3rt/CMCae2zyzDI9nJm/ekgUJ/yRsUQpxWld5L
 6EZv/9mEl3x4Q0mQMG/omtFbJmPfGvzvXwo5jbiESaCnrQYyA/9LaOfJg9oLH/1eY5QH
 PEWYTngjkLwqU6FD+kVThDSsz3m2WSVwLICD6Utphj+n5tBqZhJwo08QY7cku7HvmGnU
 2zqo8I+OMHeuBYQPWSZQXJZkPXUuUtmAq6NvrRMuWXSkCpSFj9tpeFhkfa+qTrAviF8K
 tdHYp0WnhL8KvM2PuSaL921MYKa/ncl+Rn1ORyBViA8Tq1U/jsw4yixPSgqCN2WEi/Tm RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfrj10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:12 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LBQ8uO027927;
        Thu, 21 Apr 2022 11:59:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjjhfrj0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LBq96q016093;
        Thu, 21 Apr 2022 11:59:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8qsx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:59:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LBx6g043581742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 11:59:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDDEEA4051;
        Thu, 21 Apr 2022 11:59:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CB0CA404D;
        Thu, 21 Apr 2022 11:59:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 11:59:06 +0000 (GMT)
Date:   Thu, 21 Apr 2022 13:59:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 11/11] s390x: Restore registers in
 diag308_load_reset() error path
Message-ID: <20220421135904.6ac14c7e@p-imbrenda>
In-Reply-To: <20220421101130.23107-12-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
        <20220421101130.23107-12-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KutmVzuGsuuGrQ_HoP-BMmJRJl_NxHfT
X-Proofpoint-GUID: a6aO3cQnMh_h0XvTr5HO7wX9cse_tqig
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Apr 2022 10:11:30 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> In case of an error we'll currently return with the wrong values in
> gr0 and gr1. Let's fix that by restoring the registers before setting
> the return value and branching to the return address.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/cpu.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/s390x/cpu.S b/s390x/cpu.S
> index 82b5e25d..0bd8c0e3 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu.S
> @@ -34,6 +34,7 @@ diag308_load_reset:
>  	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
>  	/* Do the reset */
>  	diag    %r0,%r2,0x308
> +	RESTORE_REGS_STACK
>  	/* Failure path */
>  	xgr	%r2, %r2
>  	br	%r14

