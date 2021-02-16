Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF731C902
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 11:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBPKnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 05:43:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46848 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhBPKnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 05:43:04 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11GAX3NP124533;
        Tue, 16 Feb 2021 05:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gGpHKUVut1e5h+GesFZOQHKFq6ZkLXyolgzAx+o8uKw=;
 b=oWGDgDFpUUVBuB7c/uk44R+A2xih6221uOtOZbG5/4M4j/gn29Gjh5AzzIbEA33x6TH0
 eyBG1xIkvyvdHS3kBUvhS2u66L78Q6LhycTe8UDVhzWfN0HAbTqVK6rm1sLA6YQsq4nU
 /nROWaXSoVHpm/CiizZl560lFrxQNT/9V0RnU5basjoxlit7Mg6rkW/YZMI/jjZoHXwn
 4rPbyjhW+E8yGiRg576hg7j5XtgKFQrjtmw7Y660jh8sMmpnr0CRApP/xQNyCuxWOCVe
 zRud9+vUNo/mCiHdjr0gcY9xzNNwGzzy6aN6ZvVVvctIqwav4g2sjLTCsJbPOixtrJh+ 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rc7j0qwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 05:42:16 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11GAXCBp125506;
        Tue, 16 Feb 2021 05:42:16 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rc7j0qw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 05:42:16 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11GAfOOg002699;
        Tue, 16 Feb 2021 10:42:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8ap3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 10:42:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11GAgCa032113004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 10:42:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B73442047;
        Tue, 16 Feb 2021 10:42:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC63842041;
        Tue, 16 Feb 2021 10:42:11 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.71.158])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 16 Feb 2021 10:42:11 +0000 (GMT)
Date:   Tue, 16 Feb 2021 11:42:09 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio/s390: implement virtio-ccw revision 2 correctly
Message-ID: <20210216114209.08fab659.pasic@linux.ibm.com>
In-Reply-To: <20210216113907.4e6943a9.cohuck@redhat.com>
References: <20210212170411.992217-1-cohuck@redhat.com>
        <20210215124702.23a093b8.cohuck@redhat.com>
        <20210215195144.7b96b41f.pasic@linux.ibm.com>
        <20210216113907.4e6943a9.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_16:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Feb 2021 11:39:07 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> > 
> > Reviewed-by: Halil Pasic <pasic@linux.ibm.com>  
> 
> Thanks!
> 
> I'll do a v2 with a tweaked commit message and cc:stable.

Sounds good!

