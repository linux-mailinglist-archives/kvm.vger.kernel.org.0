Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18145B3672
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIILeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIILeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:34:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203E313BC5A;
        Fri,  9 Sep 2022 04:34:06 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289AgENa026549;
        Fri, 9 Sep 2022 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=d+yzRQNpyBwc2g2VarZKR7NkfDtwv1pgxAaR8FFFyiQ=;
 b=eJt25YshIGQUDtRhkfyJ85WYVQkB/FBAT92C2m9ydgUpU+joNwsF51tYc2RDujDT62Qz
 QShs1kplxUIwMRiYB71q9c3ijheHT5g8fnFjHeFDk4mh5DITdoPorT+Res/khk2VtY2I
 em/M5n6Q/hBOh35XMGBCS31EddSRSkAFlxGenoR5jLCPdKdfFJiXw+4UCoaWFAQQt85V
 NbOvuaeBRuUbX30FZSI6IWf6v8KntGAut0WdlN7gZLHXsIgN+17YVsJph60QWqAx+uhj
 d7EQc8Z9Lfq3m+A13BRUzyAHJfw3FE+H+yeqCGJvqVTA5mA+rSeyuI8DQuzft0bAStn+ Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg3y9sshr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 11:34:05 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 289AhewO030119;
        Fri, 9 Sep 2022 11:34:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jg3y9ssgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 11:34:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 289BKZsj006433;
        Fri, 9 Sep 2022 11:34:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3jbxj8ywab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 11:34:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289BXxSW38011308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 11:33:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E567AE045;
        Fri,  9 Sep 2022 11:33:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E208AE051;
        Fri,  9 Sep 2022 11:33:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.225])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Sep 2022 11:33:58 +0000 (GMT)
Date:   Fri, 9 Sep 2022 11:52:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        pmorel@linux.ibm.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: pci: fix GAIT physical vs virtual pointers
 usage
Message-ID: <20220909115228.0399098f@p-imbrenda>
In-Reply-To: <20220907155952.87356-1-mjrosato@linux.ibm.com>
References: <20220907155952.87356-1-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tVCa4lTxedtaJINPCJBYbcoISjjpcegz
X-Proofpoint-GUID: kMnuPpEIBc319mlePUNhNDCH1ulmPJdU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_06,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Sep 2022 11:59:52 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> The GAIT and all of its entries must be represented by physical
> addresses as this structure is shared with underlying firmware.
> We can keep a virtual address of the GAIT origin in order to
> handle processing in the kernel, but when traversing the entries
> we must again convert the physical AISB stored in that GAIT entry
> into a virtual address in order to process it.
> 
> Note: this currently doesn't fix a real bug, since virtual addresses
> are indentical to physical ones.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Nico Boehr <nrb@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/interrupt.c | 2 +-
>  arch/s390/kvm/pci.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index b9c944b262c7..ab569faf0df2 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3324,7 +3324,7 @@ static void aen_host_forward(unsigned long si)
>  	if (gaite->count == 0)
>  		return;
>  	if (gaite->aisb != 0)
> -		set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
> +		set_bit_inv(gaite->aisbo, phys_to_virt(gaite->aisb));
>  
>  	kvm = kvm_s390_pci_si_to_kvm(aift, si);
>  	if (!kvm)
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index bb8c335d17b9..8cfa0b03ebbb 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -71,7 +71,7 @@ static int zpci_setup_aipb(u8 nisc)
>  		rc = -ENOMEM;
>  		goto free_sbv;
>  	}
> -	aift->gait = (struct zpci_gaite *)page_to_phys(page);
> +	aift->gait = (struct zpci_gaite *)page_to_virt(page);
>  
>  	zpci_aipb->aipb.faisb = virt_to_phys(aift->sbv->vector);
>  	zpci_aipb->aipb.gait = virt_to_phys(aift->gait);

