Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6123725D875
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgIDMOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:14:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729297AbgIDMOa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 08:14:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084C3FM9084232;
        Fri, 4 Sep 2020 08:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=K381IaVbA2zo5RAQ40c885fpzDPdiPaWkS9prEIANdg=;
 b=BParFI30rHGDxH2fpwwCuLbdwUIxbeikAysQ/pvtUfsA2Gn0KBLuhDFLMGwbY5yPtsXB
 7EYoUoYo77/Z+VpuzPk+xG/454SKpQTwp14mdm5+XdE5jFmifelzFc9/VttlJ85ET2x7
 RNB4BqppTycl0nmYKbGuExIMeJizzwjyOUjodI6fx29Q/6KQgF4JcbH10qfMSafn4elP
 oxCsiLgTA4LGWX/nSALQjVzRqbHTH5IB8j05VtDdJ7nOJTgZnMuSVJbMqqLUNxvF3ory
 jIwx9oADCaFRoH5ja8OTmaf20lF0bMHlLF8I7qdGDXa4N6cpB1hDbgYai3yLFDxOFYCl kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bhmexr3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 08:14:29 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084C484L088458;
        Fri, 4 Sep 2020 08:14:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bhmexr3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 08:14:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084CCVj8011440;
        Fri, 4 Sep 2020 12:14:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 337en86uty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 12:14:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084CEOSx27722024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 12:14:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C85742041;
        Fri,  4 Sep 2020 12:14:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C16AE42042;
        Fri,  4 Sep 2020 12:14:23 +0000 (GMT)
Received: from osiris (unknown [9.171.25.186])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  4 Sep 2020 12:14:23 +0000 (GMT)
Date:   Fri, 4 Sep 2020 14:14:22 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
Subject: Re: [PATCH 2/2] s390x: Add 3f program exception handler
Message-ID: <20200904121422.GG6075@osiris>
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-3-frankja@linux.ibm.com>
 <20200904103543.GD6075@osiris>
 <36e1c11c-c4a2-6ae2-b341-7d582203d031@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36e1c11c-c4a2-6ae2-b341-7d582203d031@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=1 mlxlogscore=986 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 01:33:28PM +0200, Janosch Frank wrote:
> >> +	printk_ratelimited(KERN_WARNING
> >> +			   "Secure storage violation in task: %s, pid %d\n",
> >> +			   get_task_comm(buf, current), task_pid_nr(current));
> > 
> > Why get_task_comm() and task_pid_nr() instead of simply current->comm
> > and current->pid?
> 
> Normally if there are functions to get data I assume those should be used.

Could be used, however I don't see why you need that extra complexity
here for both of them.

> > Also: is the dmesg message of any value?
> Yes, it's import for administrators to know that an exception caused
> this segfault and not some memory shenanigans.
> 
> As the exception only occurs if a guest runs in unsupported modes like
> sharing the memory between two secure guests it's a good first
> indication what went wrong.

Yes, fine with me. Just not sure of how help this is when pid
namespaces come into play...
