Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACB369DB5
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhDXATI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:19:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240146AbhDXATC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 20:19:02 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13O02vGq182944;
        Fri, 23 Apr 2021 20:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GYws5ylnSTXh2v6y4EdRxkp70WEWB8n+BCHYEj+V+O8=;
 b=ZHP10wxeGRK8w7pmDV0GK72JVGBNfw9yJhBullgn/DdC9j+ubsjrPQKXHLgbP5w34H74
 xTJ53bxkyUwfQzG4MrKNGwKheDGV8OdIPKbHFE1JPe/AmchgaqHmzEeyZ2Jx3k7OXDJ3
 SYZDvA4N2mB2vDpS9I9GFAI+x1uSdtexHSZQJEQMREMgUu/h9rzC87zGLtMSpC7LNgZp
 zRK0yC/Y4mFl3VPqBgkL3aB67lkh0ytoMvsZSu1Ta4dLkdpSEAWTBrxMNiGa4vJnPEan
 CxuxkDWPRiOAsyo1dmHrOjpWELDi+f1qZZcXLoJqCg/ju48hs8guTF2bhqdyAHicAh9j 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3846fcju8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 20:18:22 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13O04f8N186935;
        Fri, 23 Apr 2021 20:18:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3846fcju7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 20:18:22 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13O0D9pk028014;
        Sat, 24 Apr 2021 00:18:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 37yqa8a0ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Apr 2021 00:18:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13O0HqE636962808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 00:17:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86DCE4C046;
        Sat, 24 Apr 2021 00:18:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11C914C044;
        Sat, 24 Apr 2021 00:18:16 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.88.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat, 24 Apr 2021 00:18:15 +0000 (GMT)
Date:   Sat, 24 Apr 2021 02:18:13 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20210424021814.36460aef.pasic@linux.ibm.com>
In-Reply-To: <986a165f08d29110e86c044359111582332a4ccb.camel@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210422025258.6ed7619d.pasic@linux.ibm.com>
        <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
        <20210423135015.5283edde.pasic@linux.ibm.com>
        <c23691d7e4d0456dffbbeb1cea80fe3395f92c86.camel@linux.ibm.com>
        <20210423190853.6b159871.pasic@linux.ibm.com>
        <986a165f08d29110e86c044359111582332a4ccb.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LekyCTZKJhbW69y8x6GIt95VKNA_Cbsm
X-Proofpoint-ORIG-GUID: PL9d2SiWzRN4HFZhFU3OP8848s_yS3Fs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 mlxlogscore=787 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230163
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Apr 2021 15:07:17 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> > > > Is in your opinion the vfio-ccw kernel module data race free with
> > > > this
> > > > series applied?    
> > > 
> > > I have no further concerns.  
> > 
> > I take this for a "yes, in my opinion it is data race free".  
> 
> You asked about once this series is applied, which it is not.

I applied this series to the then current master several days ago, so
I have no problem reasoning about that state of code.  It seems we had
a misunderstanding. I was talking about code that is available (this
series "[RFC PATCH v4] vfio-ccw: Fix interrupt handling for HALT/CLEAR"),
and you were talking some future non-RFC merged incarnation of it I had
no opportunity to examine at this point in time.

I'm looking forward to that incarnation. And by the way, if an RFC
contains problems that are intentionally not addressed, because the
author wants to get feedback on some other aspect on the problem, I
prefer the things that are not dealt with stated clearly. Otherwise I
tend to invest time into finding the problems the author is already
aware of, and telling him that his solution is not correct because of
those.

Regards,
Halil
