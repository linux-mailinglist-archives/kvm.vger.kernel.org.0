Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC391EFD36
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFEQFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 12:05:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbgFEQFR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 12:05:17 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055G2K42069333;
        Fri, 5 Jun 2020 12:05:06 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rj9w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 12:05:06 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055G30F3072434;
        Fri, 5 Jun 2020 12:05:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31fr7rj9v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 12:05:05 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055G0uoi001764;
        Fri, 5 Jun 2020 16:05:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 31end6hgyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 16:05:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055G50kh655828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 16:05:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6DD7A4040;
        Fri,  5 Jun 2020 16:05:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28265A404D;
        Fri,  5 Jun 2020 16:05:00 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.61.106])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 16:05:00 +0000 (GMT)
Date:   Fri, 5 Jun 2020 18:04:58 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, dgilbert@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200605180458.7646070b.pasic@linux.ibm.com>
In-Reply-To: <20200605124535.12e8c96e.cohuck@redhat.com>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200521034304.340040-19-david@gibson.dropbear.id.au>
        <20200605124535.12e8c96e.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_04:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=876
 clxscore=1011 phishscore=0 bulkscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Jun 2020 12:45:35 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 21 May 2020 13:43:04 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
> > The default behaviour for virtio devices is not to use the platforms normal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memory
> > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > 
> > So, if a guest memory protection mechanism is enabled, then apply the
> > iommu_platform=on option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with the
> > hypervisor or hardware so that DMA will work.
> 
> cc: Halil, who had been looking at the interaction of virtio-ccw
> devices and s390 protected virt.
> 
> (IIRC, we wanted to try with a on/off/auto property for virtio-ccw?)

Thanks Connie! I will definitely look into this. And regarding
on/off/auto I will try to send out something today.

Regards,
Halil
