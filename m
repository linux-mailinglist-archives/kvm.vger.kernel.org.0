Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45512473056
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhLMPV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:21:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31114 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234691AbhLMPV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 10:21:57 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEvTRu019387;
        Mon, 13 Dec 2021 15:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=6uKATVOKq+6mYEI33gn8wVbbiuB1hYGRL4/Y7PgKOvg=;
 b=BbbXXECVBIVUv2Hs/xY3cnyp7v6wXqtXt6imc96KcLBLyikiVsG2q/gub1n0rIJCYfIO
 +Tu+YnAW6E/fmkoaxWzJHoGOcDBTUr0KNARiwI9+yWKNAd7uxBe8z1aHLZoW5y2gYQW3
 s95i+GWVuEOXxUR7SlJ6W1te6SB0rrcB+IqSSLarJBqfXdooVTDeIeaq/PFGDnZBVNWO
 k03rTtGB27p4Z+Z83ArFK6XmqpoHJz2zxxfp95MXQImccKxKUpo6YLOYXh8OJvbbT8p4
 +K1nHYsKlto0fmGe8GcFrUb/4PamKNIMXEQ2zHZi2a/sXUUbTFp5jiAKntKZVuCYjMCJ 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx8d5rn9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:21:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDEw6Yi021488;
        Mon, 13 Dec 2021 15:21:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx8d5rn93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:21:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDFGObU019407;
        Mon, 13 Dec 2021 15:21:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3cvkm95gf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:21:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDFLoPk45875530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 15:21:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7928711C054;
        Mon, 13 Dec 2021 15:21:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0923C11C058;
        Mon, 13 Dec 2021 15:21:50 +0000 (GMT)
Received: from osiris (unknown [9.145.30.170])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 13 Dec 2021 15:21:49 +0000 (GMT)
Date:   Mon, 13 Dec 2021 16:21:48 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, gor@linux.ibm.com
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Message-ID: <YbdlDFLjZzpC6RRd@osiris>
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <20211122131443.66632-2-pmorel@linux.ibm.com>
 <20211209133616.650491fd@p-imbrenda>
 <YbImqX/NEus71tZ1@osiris>
 <fbc46b35-10af-2c7e-6e47-e4987070ad83@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbc46b35-10af-2c7e-6e47-e4987070ad83@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rbZSwQ6fN-gLUW7L53MWdD_SF9YAAjh6
X-Proofpoint-ORIG-GUID: 34Tv4CDkq_d8m36HdaOhT7gYESxjxibC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_06,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=677 spamscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 03:26:58PM +0100, Pierre Morel wrote:
> > Why is this assumption necessary? The statement that Linux runs only
> > with horizontal polarization is not true.
> > 
> 
> Right, I will rephrase this as:
> 
> "Polarization change is not taken into account, QEMU intercepts queries for
> polarization change (PTF) and only provides horizontal polarization
> indication to Guest's Linux."
> 
> @Heiko, I did not find any usage of the polarization in the kernel other
> than an indication in the sysfs. Is there currently other use of the
> polarization that I did not see?

You can change polarization by writing to /sys/devices/system/cpu/dispatching.

Or alternativel use the chcpu tool to change polarization. There is
however no real support for vertical polarization implemented in the
kernel. Therefore changing to vertical polarization is _not_
recommended, since it will most likely have negative performance
impacts on your Linux system.
However the interface is still there for experimental purposes.
