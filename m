Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307B16980C5
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBOQWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 11:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBOQWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 11:22:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4843B3E7;
        Wed, 15 Feb 2023 08:21:59 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FFC74C026361;
        Wed, 15 Feb 2023 16:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N4xx3PALnXgsxfPbsfIX8t1okAN0F2Tn4smgky1btSQ=;
 b=HZ31z8y2m/Nhec8/iK/UncQRyE6LesFmZiNtsumSoWFLcELyEdjOl61V5RquQrc4IKUU
 UAm7YMDOgmBW63AobHt8/qmKi08/TMMN51PsKBdhVIpqBwtkarpW8ebRwva0tm0vFg5w
 M3wIgwGKrSXVC9KGVhXA2tmpH3nEovAYxGEsNEZ3Pw0HN2KaX5wGsxfBxC7rmKfN232W
 z1b4xWpnB1YnG/36gyliUuj6TBnb7UDvEuXS1ImROAGtVrGfE6Erqe5UbA4aJoYDvueN
 gH3FPuw8rME61oeoaUhfitN8bcQ3nYs2OfGSsIjkeO+9WhAUZtHCD2vtu6JktXVOy9bL cw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns1tujurs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:21:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBNbnk010684;
        Wed, 15 Feb 2023 16:21:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6wkyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:21:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FGLlEE51118486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 16:21:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E5E2004D;
        Wed, 15 Feb 2023 16:21:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3632004B;
        Wed, 15 Feb 2023 16:21:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 16:21:47 +0000 (GMT)
Date:   Wed, 15 Feb 2023 17:20:18 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390: nmi: fix virtual-physical address
 confusion
Message-ID: <20230215172018.24bf964f@p-imbrenda>
In-Reply-To: <20230215160252.14672-2-nrb@linux.ibm.com>
References: <20230215160252.14672-1-nrb@linux.ibm.com>
        <20230215160252.14672-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oqOFASujzS8EZg6R39pJCBzN-3KN9hK4
X-Proofpoint-GUID: oqOFASujzS8EZg6R39pJCBzN-3KN9hK4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Feb 2023 17:02:52 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> When a machine check is received while in SIE, it is reinjected into the
> guest in some cases. The respective code needs to access the sie_block,
> which is taken from the backed up R14.
> 
> Since reinjection only occurs while we are in SIE (i.e. between the
> labels sie_entry and sie_leave in entry.S and thus if CIF_MCCK_GUEST is
> set), the backed up R14 will always contain a physical address in
> s390_backup_mcck_info.
> 
> This currently works, because virtual and physical addresses are
> the same.
> 
> Add phys_to_virt() to resolve the virtual-physical confusion.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/nmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
> index 5dbf274719a9..322160328866 100644
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -347,7 +347,7 @@ static void notrace s390_backup_mcck_info(struct pt_regs *regs)
>  
>  	/* r14 contains the sie block, which was set in sie64a */
>  	struct kvm_s390_sie_block *sie_block =
> -			(struct kvm_s390_sie_block *) regs->gprs[14];
> +			(struct kvm_s390_sie_block *)phys_to_virt(regs->gprs[14]);
>  
>  	if (sie_block == NULL)
>  		/* Something's seriously wrong, stop system. */

