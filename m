Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71A846D5C3
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 15:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhLHOhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:37:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14100 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235192AbhLHOhL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 09:37:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8DMg0X020975;
        Wed, 8 Dec 2021 14:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=xIW1H2jSzOIOpq9Vd7TDRv1GCS4O1mkWCPZuT3KG6Ts=;
 b=XuiFqogsW0B+k+DebHrrdmFfZ0IVFRQtt5gJ2ypdT/IQWF4zp8KqdPNCV1AaYGCQXBfI
 CxPyMFXkBt1WaCAGSKw+j3ZZySB4U/1zXY29FCSDD7UK/R06irSupA/Nk3K25kMehJvH
 PxyrkLiwvC4tsLoCQFL8LNmGgUP6SyMlN2XVMCbcArWtYBNXIM7WDo5BxI0YSWZxV+VE
 L/2yvfmiiUeytxhM80/pJzBSy3lUMMHgDtWci1Ii8z9q/UpTMbhLeyrMuq5Z821hPQZl
 znzcMQ390tL53DlUdtLgvASYDD9lgvfp0x4pU8KBsSEcWuMgZGvQZBCmjwhEWZNmCEH8 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwhp9gvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:33:39 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8EIrUw038725;
        Wed, 8 Dec 2021 14:33:38 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctwhp9gvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:33:38 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8ERtZ1016538;
        Wed, 8 Dec 2021 14:33:37 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyycn2b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 14:33:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8EXXcG60031350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 14:33:33 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7964136068;
        Wed,  8 Dec 2021 14:33:33 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE69B13604F;
        Wed,  8 Dec 2021 14:33:31 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.151.152])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 14:33:31 +0000 (GMT)
Message-ID: <920e05abe1116263a00a51104feb80a07acca0c1.camel@linux.ibm.com>
Subject: Re: [PATCH 01/32] s390/sclp: detect the zPCI interpretation facility
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 09:33:30 -0500
In-Reply-To: <3ed8f5ca-e508-e261-e71d-875f5762f2f9@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-2-mjrosato@linux.ibm.com>
         <3ed8f5ca-e508-e261-e71d-875f5762f2f9@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wyn5hZyz-h2SMAZywB2SaIV3iiGurTa7
X-Proofpoint-ORIG-GUID: p0RNlG_i9UIB6FRVmcYrOXKqTFge2_23
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_05,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 clxscore=1011
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-08 at 12:12 +0100, Christian Borntraeger wrote:
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> > Detect the zPCI Load/Store Interpretation facility.
> > 
> > Reviewed-by: Eric Farman <farman@linux.ibm.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/sclp.h   | 1 +
> >   drivers/s390/char/sclp_early.c | 1 +
> >   2 files changed, 2 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/sclp.h
> > b/arch/s390/include/asm/sclp.h
> > index c68ea35de498..c84e8e0ca344 100644
> > --- a/arch/s390/include/asm/sclp.h
> > +++ b/arch/s390/include/asm/sclp.h
> > @@ -88,6 +88,7 @@ struct sclp_info {
> >   	unsigned char has_diag318 : 1;
> >   	unsigned char has_sipl : 1;
> >   	unsigned char has_dirq : 1;
> > +	unsigned char has_zpci_interp : 1;
> 
> maybe use zpci_lsi (load store interpretion) as pci interpretion
> would be something else (also fix the the subject line).
> With that
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

My r-b can stay with Christian's suggested change.

> 
> 
> >   	unsigned int ibc;
> >   	unsigned int mtid;
> >   	unsigned int mtid_cp;
> > diff --git a/drivers/s390/char/sclp_early.c
> > b/drivers/s390/char/sclp_early.c
> > index b64feab62caa..2e8199b7ae50 100644
> > --- a/drivers/s390/char/sclp_early.c
> > +++ b/drivers/s390/char/sclp_early.c
> > @@ -45,6 +45,7 @@ static void __init
> > sclp_early_facilities_detect(void)
> >   	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
> >   	sclp.has_hvs = !!(sccb->fac119 & 0x80);
> >   	sclp.has_kss = !!(sccb->fac98 & 0x01);
> > +	sclp.has_zpci_interp = !!(sccb->fac118 & 0x01);
> >   	if (sccb->fac85 & 0x02)
> >   		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
> >   	if (sccb->fac91 & 0x40)
> > 

