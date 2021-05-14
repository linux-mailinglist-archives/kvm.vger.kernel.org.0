Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCB380123
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 02:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhENAbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 20:31:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhENAbF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 20:31:05 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14E02tvR086166;
        Thu, 13 May 2021 20:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+3q1+f/7W9aLY/875YVSaLqc+FFnACbfBN12gTUyGGQ=;
 b=gxnOMmTuM6ae4s/+793sMmHkyosb2aOnMKnDXsuWtdFlep5JBfoRki/WKwakfpJtx3UU
 ucsAj02kWr84gvt9L5RsM+xyisXxl8emvH6GrgJAua57rCKNKhdSb/KknYAbsyrbmNgL
 oDITQ2WYVwjzKmp00DFoGMpI4sEa/PcISaYEXaEh/cvb11XVrnS334fQhKG1o7u3rOk1
 XaOdhj5jqDsQGSfm6BpY9uM1SCGXZrX4xwqR2YdS0oi4TQJg9KjdFwedrXPPDYkZIGWw
 dgtamfmubn0rs6DDjuWQys1A5bUUwN6CvKR70ItpyiKrB3venZoSdnCVavKMeI+k//dT FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38hchcjrgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 20:29:55 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14E04qLm094903;
        Thu, 13 May 2021 20:29:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38hchcjrg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 20:29:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14E0TO75013738;
        Fri, 14 May 2021 00:29:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38hc77g19u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 May 2021 00:29:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14E0TM8V27001156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 00:29:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7795A11C04C;
        Fri, 14 May 2021 00:29:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06C6C11C054;
        Fri, 14 May 2021 00:29:49 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.9.250])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 14 May 2021 00:29:48 +0000 (GMT)
Date:   Fri, 14 May 2021 02:29:46 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Message-ID: <20210514022946.693936fc.pasic@linux.ibm.com>
In-Reply-To: <8224aa872f243610583aab327c7e0b813ddaf0dd.camel@linux.ibm.com>
References: <20210511195631.3995081-1-farman@linux.ibm.com>
        <20210513030543.67601a8c.pasic@linux.ibm.com>
        <8224aa872f243610583aab327c7e0b813ddaf0dd.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qa2SlGelqLl_dM4JdRTBlQgqqpCaAyjb
X-Proofpoint-ORIG-GUID: EEe7NS9MGLESw9Nr45bMJzWmni2b9NmC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_16:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130171
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 May 2021 14:33:20 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> > 
> > In any case, I don't want to hold this up any further.
> >   
> 
> Thanks for that. You are correct that there's still a potential issue
> here, in the handoff between fsm_irq() and vfio_ccw_sch_io_todo(), and
> another fsm_io_request() that would arrive between those points. But
> it's not anything that we haven't already discussed, and will hopefully
> begin discussing in the next couple of weeks.

Thanks for all the explanations and your patience. I know, I can be
difficult when I'm at discomfort due to dissonances in my mental model
of a certain problem or a certain solution. Will try to carve out some
time to at least have a look at those as well.

Have a nice weekend!

Halil 
