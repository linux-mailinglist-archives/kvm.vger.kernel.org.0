Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBAD478E9B
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 15:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhLQOzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 09:55:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231971AbhLQOzR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 09:55:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHDaxFG022998;
        Fri, 17 Dec 2021 14:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jn+7vU3DeFwv40C/Xn8u61FAyk08AIabx42PwN2Qc20=;
 b=kCKpv+yClD+BkC6ITtMnuH2kAQymlt+5UtAcFL1gxsQaJpfckIo7vvxmdnUzKdPNS+++
 niiAC+Cpn3Srq/FWxfvPOzrO4bgiR2Imbyr0/iqxn1ES7LTA4TUtxt3aN8vxlLndAkae
 wMGAqaLubw1zr1pYFIE4TosBfLqcNvLNqL7sHnDsH31H4b1ybPwiQnARkou0rS9IeYY5
 vOyz3PNJ0Rub/rsY7rpVEZ5kla2sOJq0Pif4oiWeNoT1XdwU/djmit8mgwHiTfkqQRck
 W9OitakvcE2LoYVWmzGF2cyINDRDZBHd/c+Y6Ya0H73iecqXmXkDxFGisXdZAziICI6q iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0pywyx5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:55:16 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHEX4VG007533;
        Fri, 17 Dec 2021 14:55:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0pywyx3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:55:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEal4j009415;
        Fri, 17 Dec 2021 14:55:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3cy7k3sawg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 14:55:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHEtABG39452952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 14:55:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3ADF52050;
        Fri, 17 Dec 2021 14:55:09 +0000 (GMT)
Received: from [9.171.60.51] (unknown [9.171.60.51])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 102EA5204F;
        Fri, 17 Dec 2021 14:55:09 +0000 (GMT)
Message-ID: <5073966a-0e99-977b-dc97-e72f55ff7091@linux.ibm.com>
Date:   Fri, 17 Dec 2021 15:55:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 32/32] MAINTAINERS: additional files related kvm s390 pci
 passthrough
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-33-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-33-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z7n_tkup5mnXNl0_WSrva9gAXKtIGLKC
X-Proofpoint-ORIG-GUID: XeGCCKbsEKjIvCA7LCjSS-Iai_Io2P_s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> Add entries from the s390 kvm subdirectory related to pci passthrough.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Question for Alex. Shall I take these and future patches regarding KVM hw support for PCI passthru via my tree or via your vfio tree?

> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 43007f2d29e0..a88f8e4f2c80 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16689,6 +16689,8 @@ M:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported
> +F:	arch/s390/include/asm/kvm_pci.h
> +F:	arch/s390/kvm/pci*
>   F:	drivers/vfio/pci/vfio_pci_zdev.c
>   F:	include/uapi/linux/vfio_zdev.h
>   
> 
