Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0834C24
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfFDPYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 11:24:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727857AbfFDPYu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jun 2019 11:24:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54FCQ95125871
        for <kvm@vger.kernel.org>; Tue, 4 Jun 2019 11:24:49 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2swu05gxe2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 11:24:49 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Tue, 4 Jun 2019 16:24:47 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 16:24:45 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54FOiFC45744334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 15:24:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22762A4060;
        Tue,  4 Jun 2019 15:24:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB830A4054;
        Tue,  4 Jun 2019 15:24:43 +0000 (GMT)
Received: from osiris (unknown [9.152.212.21])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Jun 2019 15:24:43 +0000 (GMT)
Date:   Tue, 4 Jun 2019 17:24:42 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/7] vfio-ccw: fixes
References: <20190603105038.11788-1-cohuck@redhat.com>
 <20190603111124.GB20699@osiris>
 <20190603131641.4ad411f0.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603131641.4ad411f0.cohuck@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19060415-4275-0000-0000-0000033CA89C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060415-4276-0000-0000-0000384CB838
Message-Id: <20190604152442.GG5774@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=799 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 03, 2019 at 01:16:41PM +0200, Cornelia Huck wrote:
> On Mon, 3 Jun 2019 13:11:24 +0200
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Mon, Jun 03, 2019 at 12:50:31PM +0200, Cornelia Huck wrote:
> > > The following changes since commit 674459be116955e025d6a5e6142e2d500103de8e:
> > > 
> > >   MAINTAINERS: add Vasily Gorbik and Christian Borntraeger for s390 (2019-05-31 10:14:15 +0200)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190603
> > > 
> > > for you to fetch changes up to 9b6e57e5a51696171de990b3c41bd53d4b8ab8ac:
> > > 
> > >   s390/cio: Remove vfio-ccw checks of command codes (2019-06-03 12:02:55 +0200)
> > > 
> > > ----------------------------------------------------------------
> > > various vfio-ccw fixes (ccw translation, state machine)
> > > 
> > > ----------------------------------------------------------------
> > > 
> > > Eric Farman (7):
> > >   s390/cio: Update SCSW if it points to the end of the chain
> > >   s390/cio: Set vfio-ccw FSM state before ioeventfd
> > >   s390/cio: Split pfn_array_alloc_pin into pieces
> > >   s390/cio: Initialize the host addresses in pfn_array
> > >   s390/cio: Don't pin vfio pages for empty transfers
> > >   s390/cio: Allow zero-length CCWs in vfio-ccw
> > >   s390/cio: Remove vfio-ccw checks of command codes  
> > 
> > Given that none of the commits contains a stable tag, I assume it's ok
> > to schedule these for the next merge window (aka 'feature branch')?
> 
> All are bug fixes, but for what I think are edge cases. Would be nice
> if they could still make it into 5.2, but I have no real problem with
> deferring them to the next release, either.
> 
> Eric, Farhan: Do you agree?

As discussed on IRC: pulled and pushed to features branch. Urgent
fixes really should either have a stable and/or fixes tag, if
possible.

Thank you!

