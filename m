Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA202ED2EF
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 15:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbhAGOmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 09:42:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728045AbhAGOmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 09:42:38 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107Ed6kZ012335;
        Thu, 7 Jan 2021 09:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pIF6MoeiCRHQube+DvMM2GDP9Jc5BQLMZ+2G0Qyfm1w=;
 b=f37kJF2k38UcvyuXJDCVr0ccVredk8qnfc7oHNFRW6+/N+AcEt0Mr+75+wiX+eH1mh2E
 LGOrhw99fyqUeg+0ZSnbzxbU6zb7trNMyLEpFBWD9Nnq590DtehaNtueekssVR3scQbI
 gh8qzrhMypKBo/5S0Rsp0mYYoJneq4S/iv17YquSdsyrefY7+ttwLyzxUo3K8ndGeCG9
 nJkJBm9kFAnHNf3M7pY6imoJrIB7U1HRHd0oDUltaAEic1WeeL00Mwo91LqeHaxAAmcM
 92lduTS1EPFE9NRviO6DYUvIj/EUYeHRd+yznq0ub+GDELrd5zJX/sM8cicWY7qmvdac yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x2mwae8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 09:41:55 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107EdY1L013311;
        Thu, 7 Jan 2021 09:41:54 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x2mwae83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 09:41:54 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107EdC3V011272;
        Thu, 7 Jan 2021 14:41:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 35tgf8cxcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 14:41:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107Efm0F35651960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 14:41:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA241A4054;
        Thu,  7 Jan 2021 14:41:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA8DA4062;
        Thu,  7 Jan 2021 14:41:47 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.48.187])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  7 Jan 2021 14:41:47 +0000 (GMT)
Date:   Thu, 7 Jan 2021 15:41:46 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 00/15] s390/vfio-ap: dynamic configuration support
Message-ID: <20210107154146.2f071c5e.pasic@linux.ibm.com>
In-Reply-To: <3c350e32-3206-25cb-1b1e-6577e8c15ae2@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <3c350e32-3206-25cb-1b1e-6577e8c15ae2@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 10:16:24 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Ping
> 

pong

Will try have a look these days...
