Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3CF2D1499
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 16:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGPZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 10:25:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59628 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgLGPZL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 10:25:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7FGsgh140723;
        Mon, 7 Dec 2020 10:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hEoRplU0xj64JDWRn/htvzXssn19PM5NYa980cnFoXY=;
 b=UHQt6AyuYt/reZsh0ZyyhE6RvmPZ7nH/mLxAt3zWWxVDGaZymIOTidZ98OR4vYKtlHqP
 Dl2rXOsQk/99U0k6eDpYb9gYe43pWlsWsDdfVXcrOpf5qZyOsYZPiuBeo6Kw0vM43MzP
 pPQF20xg8FH/CP7i3wM4lJ35kbG5u0EtF60oHPne+1Pjo6G4sB4kWazuqiLyAHKphqSn
 m07Qz52OU8QZN5FXPzI8L0hcsrw1wJuqaqc8SQ6LkqJtcHnrj0EYO+tDqmqYjncNle+4
 qJWkbnIUYhy9N2DgYFEbouSYYwGKjnxz96qi3TGFXUKdy9pC7Ggcxrm00nKim+Nkkgn0 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358r4v1e66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 10:24:27 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7F7f7O115676;
        Mon, 7 Dec 2020 10:24:25 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358r4v1e2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 10:24:25 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7FCdp9028853;
        Mon, 7 Dec 2020 15:24:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u82kj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 15:24:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7FODRj66191728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 15:24:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACB9F11C058;
        Mon,  7 Dec 2020 15:24:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 298CD11C04C;
        Mon,  7 Dec 2020 15:24:13 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.6.119])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon,  7 Dec 2020 15:24:13 +0000 (GMT)
Date:   Mon, 7 Dec 2020 16:24:11 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201207162411.050c6cea.pasic@linux.ibm.com>
In-Reply-To: <a5a613ef-4c74-ad68-46bd-7159fbafef47@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <20201203185514.54060568.pasic@linux.ibm.com>
        <a5a613ef-4c74-ad68-46bd-7159fbafef47@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 11:48:24 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/3/20 12:55 PM, Halil Pasic wrote:
> > On Wed,  2 Dec 2020 18:41:01 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The vfio_ap device driver registers a group notifier with VFIO when the
> >> file descriptor for a VFIO mediated device for a KVM guest is opened to
> >> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> >> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
> >> and calls the kvm_get_kvm() function to increment its reference counter.
> >> When the notifier is called to make notification that the KVM pointer has
> >> been set to NULL, the driver should clean up any resources associated with
> >> the KVM pointer and decrement its reference counter. The current
> >> implementation does not take care of this clean up.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>  
> > Do we need a Fixes tag? Do we need this backported? In my opinion
> > this is necessary since the interrupt patches.  
> 
> I'll put in a fixes tag:
> Fixes: 258287c994de (s390: vfio-ap: implement mediated device open callback)
> 
> Yes, this should probably be backported.

I changed my mind regarding the severity of this issue. I was paranoid
about post-mortem interrupts, and resulting notifier byte updates by the
machine. What I overlooked is that the pin is going to prevent the memory
form getting repurposed. I.e. if we have something like vmalloc(),
vfio_pin(notifier_page), vfree(), I believe the notifier_page is not free
(available for allocation). So the worst case scenario is IMHO a resource
leak and not corruption. So I'm not sure this must be backported.
Opinions?

Regards,
Halil


