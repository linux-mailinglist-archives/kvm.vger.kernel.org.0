Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6684F2DCF
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 13:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiDEIkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiDEIYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 04:24:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E0A9FE7;
        Tue,  5 Apr 2022 01:20:20 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2357drRY009012;
        Tue, 5 Apr 2022 08:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jvaX86yLEGbCLrrwl/LtphbACiuYVeIpVZHlGhHhu9A=;
 b=pC2LZtcc2Qv1H41r0/eOKPbXojqTB5fcpkzQRg8jmQBjbQx97WHG8dSnADlTsBn6Jt0t
 pU+pDRuQs05X5Io3E18RibsrJsN00owZ/h0oj/qtH8KIEGIH4lt6tEUOuEizZZdep9dl
 tUXvIFqm4naLP2NjSOgW2tq0fR5JSqQInBZQGeHlJq/iVrmnfybPrcFYaeqLZXdFiMrv
 12bhRsVs3Rg07mFhL6c8UVGl3ZIKZBZ1/PxUV9ncfra8KaDINdWYKAKFooF2nPGbt9RF
 C0KJJO5RsyiTa8+hMU38XN9hozCxNnfVt+IkHbaBEfioDHVa+8oYnwbCuACpL4KX5XAa 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705hk73j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 08:20:18 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2358IRKg021885;
        Tue, 5 Apr 2022 08:20:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705hk72k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 08:20:17 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2358DRfg020930;
        Tue, 5 Apr 2022 08:20:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48vanb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 08:20:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2358KC0U33358080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 08:20:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4241C42041;
        Tue,  5 Apr 2022 08:20:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB0D42045;
        Tue,  5 Apr 2022 08:20:10 +0000 (GMT)
Received: from sig-9-145-21-185.uk.ibm.com (unknown [9.145.21.185])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 08:20:10 +0000 (GMT)
Message-ID: <8fc611271c6156dee5c5f5b5c2f583d2d7774843.camel@linux.ibm.com>
Subject: Re: [PATCH v5 10/21] KVM: s390: pci: add basic kvm_zdev structure
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Tue, 05 Apr 2022 10:20:10 +0200
In-Reply-To: <20220404174349.58530-11-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
         <20220404174349.58530-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tLpowZUl73C-jlbAU_rgjQIxTiHb2PhV
X-Proofpoint-ORIG-GUID: Cd9hlDx7RLCspQAJowud_tOMJozcrHjG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_10,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=692
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
> This structure will be used to carry kvm passthrough information related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h |  3 +++
>  arch/s390/kvm/Makefile      |  1 +
>  arch/s390/kvm/pci.c         | 38 +++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/pci.h         | 21 ++++++++++++++++++++
>  4 files changed, 63 insertions(+)
>  create mode 100644 arch/s390/kvm/pci.c
>  create mode 100644 arch/s390/kvm/pci.h
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 4c5b8fbc2079..9eb20cebaa18 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>  };
>  
>  struct s390_domain;
> +struct kvm_zdev;
>  
>  #define ZPCI_FUNCTIONS_PER_BUS 256
>  struct zpci_bus {
> @@ -190,6 +191,8 @@ struct zpci_dev {
>  	struct dentry	*debugfs_dev;
>  
>  	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
> +
> +	struct kvm_zdev *kzdev; /* passthrough data */
>  };

The struct zpci_dev tries to use semantic groups in its formatting.
It's not perfect and we probably need to clean this up to remove some
holes in the future. For now let's put the new kzdev without a blank
line together with s390_domain and add a "section comment" like
"IOMMU and passthrough".
Also I'd drop the "... data" part of the line end comment or even drop
it entirely, the name is pretty clear already when combined with the
section comment.

With that Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

