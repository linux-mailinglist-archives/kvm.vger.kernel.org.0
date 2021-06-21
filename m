Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684963AF64E
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 21:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhFUTob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 15:44:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230222AbhFUTob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 15:44:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LJY43K140007;
        Mon, 21 Jun 2021 15:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=tpTbAY+2SNGjxOxee8jh1frQ5eR6mnKDfmrbz8wFNlA=;
 b=eIKO0dqY7kds6RPToVJ+mzJRstYxNBCXl8SFGwMys1hmq13DQ1Zt/nXFR7UBiCE74WiU
 /8OkfOVJFyTj3Bvhz+MBqm3nzaGqUnNtpOzuhtPpPCd/4pC4t+ELnm5wQYFdRpapEnPL
 tXHk0VwSSHR+DX+386aeMWkseldl77bTvKRN9G1xuM0zthGgHbyrQrHxpsysZ4EStRC+
 f4K/kZvt7SmgGmI0QEZ/1lwZD3NMEwHVWi1ZosDDuzG6Sofc+2qS9LxwV7uFe6A8h+ft
 AP3NWiXW3oP12jdaVgKjKzTlzb5+Ue06uusWdmlR1V/htPO8vbgjC/FYT+j5Ju2z8C5s JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ayjmtvby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 15:42:16 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LJZAbP145922;
        Mon, 21 Jun 2021 15:42:15 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ayjmtvay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 15:42:15 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LJXcJ2006046;
        Mon, 21 Jun 2021 19:42:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3998788jxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 19:42:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LJgAdH25952556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 19:42:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A4E2A4054;
        Mon, 21 Jun 2021 19:42:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E26A405B;
        Mon, 21 Jun 2021 19:42:10 +0000 (GMT)
Received: from osiris (unknown [9.145.14.202])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Jun 2021 19:42:09 +0000 (GMT)
Date:   Mon, 21 Jun 2021 21:42:08 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio/s390: get rid of open-coded kvm hypercall
Message-ID: <YNDrkOhjRiaBv34p@osiris>
References: <20210621144522.1304273-1-hca@linux.ibm.com>
 <87lf73nsqj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf73nsqj.fsf@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IKAMp-76W4k5MjT0MgTo-NnoAPNCMtOh
X-Proofpoint-GUID: miWDX3LO9_vFH9H89bde_3WaO8KLONef
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_11:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106210114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 05:27:00PM +0200, Cornelia Huck wrote:
> On Mon, Jun 21 2021, Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> > do_kvm_notify() and __do_kvm_notify() are an (exact) open-coded variant
> > of kvm_hypercall3(). Therefore simply make use of kvm_hypercall3(),
> > and get rid of duplicated code.
> >
> > Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> > ---
> >  drivers/s390/virtio/virtio_ccw.c | 30 ++++--------------------------
> >  1 file changed, 4 insertions(+), 26 deletions(-)
> >
> 
> Hm, I wonder why I didn't use kvm_hypercall3 in the first place. It's in
> a header, and therefore should be independent of kvm being configured.
> 
> I don't think there's anything else virtio-ccw in flight at the moment,
> so maybe you can apply this one directly?

Yes, sure.

> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thank you!
