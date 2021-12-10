Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE246FCEE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 09:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbhLJItk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 03:49:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229761AbhLJItj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 03:49:39 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA7RWaN023566;
        Fri, 10 Dec 2021 08:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=hW3zRwy9cMGT3Zh9RdpuCzNn2DZ5NFZSQ3wZ3yYvBY0=;
 b=lQRFgRL0/QiFOx9ui6Lxvd0m2W3qsPMuPCOLixrjoIBiP8ZHFwJCIvmH5YaNtC8Bg8fG
 qhRTihkNB8iXmi8N4qGyL3/zIM9KSGb9PXa/RI+6Wggh2scT7h/QEt15VgyA0rlBB9+h
 aBbYmwUslA74Q46oXqluC/lSQZt/kAiyo44e8aALBbfiTCjuJ57mEhml+X7eTGzcj7gR
 P0HMExaTO0v21JwldQge+CYrzOVCgIoaKcowX5wVOEKUoY6o6+qL26wDzI1a9gblAM/g
 xnqhOmmzrAyTNd6JhTfbwcZUIcNRn0mkPx3/+LV7wL3IRC6+2R3NEYMAJ29raTSJBkcL 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cv2h6sd5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:46:03 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BA8LEms020110;
        Fri, 10 Dec 2021 08:46:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cv2h6sd56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:46:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BA8SXhw001414;
        Fri, 10 Dec 2021 08:46:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyya6vff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:46:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BA8cBfE29360628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 08:38:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3503F11C05E;
        Fri, 10 Dec 2021 08:45:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1847611C058;
        Fri, 10 Dec 2021 08:45:57 +0000 (GMT)
Received: from sig-9-145-163-175.de.ibm.com (unknown [9.145.163.175])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 08:45:57 +0000 (GMT)
Message-ID: <bc6b967e461c066bb248437597195c0fd737e6e3.camel@linux.ibm.com>
Subject: Re: [PATCH 12/32] s390/pci: get SHM information from list pci
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Dec 2021 09:45:56 +0100
In-Reply-To: <cabce091-531a-de77-5b90-9ee1f1482da7@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-13-mjrosato@linux.ibm.com>
         <cabce091-531a-de77-5b90-9ee1f1482da7@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3YmTcH5bIDtheOlzqafwrRSTINUfeIYZ
X-Proofpoint-ORIG-GUID: ncMRMp_BXnCKDYTxqHvcfg273YVRqpe_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 spamscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 16:47 +0100, Christian Borntraeger wrote:
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> > KVM will need information on the special handle mask used to indicate
> > emulated devices.  In order to obtain this, a new type of list pci call
> > must be made to gather the information.  Remove the unused data pointer
> > from clp_list_pci and __clp_add and instead optionally pass a pointer to
> > a model-dependent-data field.  Additionally, allow for clp_list_pci calls
> > that don't specify a callback - in this case, just do the first pass of
> > list pci and exit.
> > 
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/pci.h     |  6 ++++++
> >   arch/s390/include/asm/pci_clp.h |  2 +-
> >   arch/s390/pci/pci.c             | 19 +++++++++++++++++++
> >   arch/s390/pci/pci_clp.c         | 16 ++++++++++------
> >   4 files changed, 36 insertions(+), 7 deletions(-)
> > 
---8<---
> >   
> > +int zpci_get_mdd(u32 *mdd)
> > +{
> > +	struct clp_req_rsp_list_pci *rrb;
> > +	int rc;
> > +
> > +	if (!mdd)
> > +		return -EINVAL;
> > +
> > +	rrb = clp_alloc_block(GFP_KERNEL);
> > +	if (!rrb)
> > +		return -ENOMEM;
> > +
> > +	rc = clp_list_pci(rrb, mdd, NULL);
> > +
> > +	clp_free_block(rrb);
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(zpci_get_mdd);
> 
> Maybe move this into pci_clp.c to avoid the export of clp_alloc_block and void clp_free_block?
> Niklas?

That was actually my idea. I'm thinking of moving clp_get_state(),
clp_scan_pci_devices(), ans clp_refresh_fh() to pci.c too because I
feel these deal with higher level concerns than the rest of pci_clp.c.

I have no strong opinion though and might be thinking ahead to much
here. With the change discussed in the other mail of not modifying
clp_list_pci() maybe it would be better to keep it here and thus this
patch more focused and minimal and then possibly move it with the other
similar functions.

