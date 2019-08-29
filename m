Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DBDA2298
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfH2RmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:42:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727314AbfH2RmH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Aug 2019 13:42:07 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7THWBmF164373
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 13:42:06 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2umpb4krq1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 13:42:05 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 29 Aug 2019 18:42:03 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 18:42:01 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7THg0RU19202112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:42:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1678052052;
        Thu, 29 Aug 2019 17:42:00 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.193])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D936D5204F;
        Thu, 29 Aug 2019 17:41:59 +0000 (GMT)
Date:   Thu, 29 Aug 2019 19:41:58 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC UNTESTED] vfio-ccw: indirect access to translated
 cps
In-Reply-To: <20190828143947.1c6b88e4.cohuck@redhat.com>
References: <20190726100617.19718-1-cohuck@redhat.com>
        <20190730174910.47930494.pasic@linux.ibm.com>
        <20190807132311.5238bc24.cohuck@redhat.com>
        <20190807160136.178e69de.pasic@linux.ibm.com>
        <20190808104306.2450bdcf.cohuck@redhat.com>
        <20190816003402.2a52b863.pasic@linux.ibm.com>
        <20190828143947.1c6b88e4.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082917-0012-0000-0000-000003445AE7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082917-0013-0000-0000-0000217E9C7C
Message-Id: <20190829194158.094879b8.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290186
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Aug 2019 14:39:47 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> > > 
> > > So we do have three states here, right? (I hope we're not talking past
> > > each other again...)    
> > 
> > Right, AFAIR  and without any consideration to fine details the three
> > states and two state transitions do make sense.  
> 
> If we translate the three states to today's states in the fsm, we get:
> - "idle" -> VFIO_CCW_STATE_IDLE
> - "doing translation" -> VFIO_CCW_STATE_CP_PROCESSING
> - "submitted" -> VFIO_CCW_STATE_CP_PENDING
> and the transitions between the three already look fine to me (modulo
> locking). We also seem to handle async requests correctly (-EAGAIN if
> _PROCESSING, else just go ahead).
> 
> So we can probably forget about the approach in this patch, and
> concentrate on eliminating races in state transitions.

I agree.

> 
> Not sure what the best approach is for tackling these: intermediate
> transit state, a mutex or another lock, running locked and running
> stuff that cannot be done locked on workqueues (and wait for all work
> to finish while disallowing new work while doing the transition)?
> 
> Clever ideas wanted :)

AFAIR Eric has this problem on his TODO list. I think we can resume the
in depth discussion over his code :)

Regards,
Halil

