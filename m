Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7BA4A9BBA
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356544AbiBDPOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:14:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21518 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346758AbiBDPOj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:14:39 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214D27TN022518
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:14:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OuMqbO6rwCDc5DSAob9KVfgj5Q0d7ka4MrXdxEPqi94=;
 b=tg4uDK6mo0GUG5MNESPPBvUlB8wQ9FjK4R11zbL46lPxUg8hgAUHBZ4E+S6gGxFgvTEh
 fiUkiMFZv5eW6D8qcR80stUCNqB2cElCh8qUNX4MG4/hysQ/7qXZjp8GclcRuutdqqCo
 y+2H+mEl3hFFS1cwEAK+3oq/qEkqILHU6+Mxso3iRp8HQO7HtsWOssdiXlEDGWfriuFG
 QGqOxwZ1BbOFlmMZevIlQQQy52yObemU6YqYgMiiAdZBjZ2N2c64QRhfk3AhWIkKVzK5
 TFP6x/gmwtKcAct5FfSr5mvgfn77oXqydYl21B+shqrdql2pulZsUAtK0ipCQlYwHXs9 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5q2kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 15:14:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214ERlQM003032
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 15:14:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0rj5q2ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:14:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214F3e9F013771;
        Fri, 4 Feb 2022 15:14:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e0r11nqep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:14:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214F4bnS49414410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:04:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 684EA11C052;
        Fri,  4 Feb 2022 15:14:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5D5A11C050;
        Fri,  4 Feb 2022 15:14:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.50])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:14:32 +0000 (GMT)
Date:   Fri, 4 Feb 2022 16:14:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU
 addresses
Message-ID: <20220204161430.27d1da36@p-imbrenda>
In-Reply-To: <96a1a92b-d97a-32e9-7cdc-305994904181@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
        <96a1a92b-d97a-32e9-7cdc-305994904181@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rIFkY9WSheMbT-Iwsx4J64ys9WHT07QW
X-Proofpoint-GUID: lBv7b9HgohZ0tFZtPaM2G8UehyJEUx8S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Feb 2022 16:01:54 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/28/22 19:54, Claudio Imbrenda wrote:
> > On s390x there are no guarantees about the CPU addresses, except that
> > they shall be unique. This means that in some environments, it's
> > possible that there is no match between the CPU address and its
> > position (index) in the list of available CPUs returned by the system.
> > 
> > This series fixes a small bug in the SMP initialization code, adds a
> > guarantee that the boot CPU will always have index 0, and introduces
> > some functions to allow tests to use CPU indexes instead of using
> > hardcoded CPU addresses. This will allow the tests to run successfully
> > in more environments (e.g. z/VM, LPAR).
> > 
> > Some existing tests are adapted to take advantage of the new
> > functionalities.
> > 
> > Claudio Imbrenda (5):
> >    lib: s390x: smp: add functions to work with CPU indexes
> >    lib: s390x: smp: guarantee that boot CPU has index 0
> >    s390x: smp: avoid hardcoded CPU addresses
> >    s390x: firq: avoid hardcoded CPU addresses
> >    s390x: skrf: avoid hardcoded CPU addresses
> > 
> >   lib/s390x/smp.h |  2 ++
> >   lib/s390x/smp.c | 28 ++++++++++++-----
> >   s390x/firq.c    | 17 +++++-----
> >   s390x/skrf.c    |  8 +++--
> >   s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------  
> 
> We use smp/sigp in uv-host.c and one of those uses looks a bit strange 
> to me anyway.

I had noticed that, it's fixed in the v2 (and that test will almost
surely be rewritten anyway)

> 
> I think we also need to fix the sigp in cstart.S to only stop itself and 
> not the cpu with the addr 0.

not sure if that is needed right now. that is only used for snippets,
right?

or did you mean cstart64.S?
but there, sigp is only used for SET_ARCHITECTURE, so it doesn't really
matter I guess?

> 
> Up to now we very much assumed that cpu 0 is always our boot cpu so if 
> you start running the test with cpu addr 1 and 2 and leave out 0 you 
> might find more problematic code.
> 
> 
> >   5 files changed, 79 insertions(+), 59 deletions(-)
> >   
> 

